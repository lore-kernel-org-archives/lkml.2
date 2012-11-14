Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab2KNTkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:40:16 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54530 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab2KNTkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 14:40:14 -0500
Subject: Re: [PATCH 18/31] mm: sched: numa: Implement constant, per task
 Working Set Sampling (WSS) rate
From: Andrew Theurer <habanero@linux.vnet.ibm.com>
Reply-To: habanero@linux.vnet.ibm.com
To: Mel Gorman <mgorman@suse.de>
Cc: a.p.zijlstra@chello.nl, riel@redhat.com, aarcange@redhat.com,
        lee.schermerhorn@hp.com, linux-kernel@vger.kernel.org
In-Reply-To: <20121114182826.GP8218@suse.de>
References: <1352913882.7130.131.camel@oc2024037011.ibm.com>
	 <20121114182826.GP8218@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Nov 2012 13:39:53 -0600
Message-ID: <1352921993.7130.154.camel@oc2024037011.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111419-6078-0000-0000-000011E88D9C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-14 at 18:28 +0000, Mel Gorman wrote:
> On Wed, Nov 14, 2012 at 11:24:42AM -0600, Andrew Theurer wrote:
> > 
> > > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > 
> > > Note: The scan period is much larger than it was in the original patch.
> > > 	The reason was because the system CPU usage went through the roof
> > > 	with a sample period of 500ms but it was unsuitable to have a
> > > 	situation where a large process could stall for excessively long
> > > 	updating pte_numa. This may need to be tuned again if a placement
> > > 	policy converges too slowly.
> > > 
> > > Previously, to probe the working set of a task, we'd use
> > > a very simple and crude method: mark all of its address
> > > space PROT_NONE.
> > > 
> > > That method has various (obvious) disadvantages:
> > > 
> > >  - it samples the working set at dissimilar rates,
> > >    giving some tasks a sampling quality advantage
> > >    over others.
> > > 
> > >  - creates performance problems for tasks with very
> > >    large working sets
> > > 
> > >  - over-samples processes with large address spaces but
> > >    which only very rarely execute
> > > 
> > > Improve that method by keeping a rotating offset into the
> > > address space that marks the current position of the scan,
> > > and advance it by a constant rate (in a CPU cycles execution
> > > proportional manner). If the offset reaches the last mapped
> > > address of the mm then it then it starts over at the first
> > > address.
> > 
> > I believe we will have problems with this. For example, running a large
> > KVM VM with 512GB memory, using the new defaults in this patch, and
> > assuming we never go longer per scan than the scan_period_min, it would
> > take over an hour to scan the entire VM just once.  The defaults could
> > be changed, but ideally there should be no knobs like this in the final
> > version, as it should just work well under all conditions.
> > 
> 
> Good point. I'll switch to the old defaults. The system CPU usage will
> be high but that has to be coped with anyway. Ideally the tunables would
> go away but for now they are handy for debugging.
> 
> > Also, if such a method is kept, would it be possible to base it on fixed
> > number of pages successfully marked instead of a MB range? 
> 
> I see a patch for that in the -tip tree. I'm still debating this with
> myself. On the one hand, it'll update the PTEs faster. On the other
> hand, the time spent scanning is now variable because it depends on the
> number of PTE updates. It's no longer a constant in terms of scanning
> although it would still be constant in terms of PTEs update. Hmm..
> 
> > Reason I
> > bring it up is that we often can have VMs which are large in their
> > memory definition, but might not actually have a lot of pages faulted
> > in.  We could be "scanning" sections of vma which are not even actually
> > present yet.
> > 
> 
> Ok, thanks for that. That would push me towards accepting it and being
> ok with the variable amount of scanning.
> 
> > > The per-task nature of the working set sampling functionality in this tree
> > > allows such constant rate, per task, execution-weight proportional sampling
> > > of the working set, with an adaptive sampling interval/frequency that
> > > goes from once per 2 seconds up to just once per 32 seconds.  The current
> > > sampling volume is 256 MB per interval.
> > 
> > Once a new section is marked, is the previous section automatically
> > reverted? 
> 
> No.
> 
> > If not, I wonder if there's risk of building up a ton of
> > potential page faults?
> > 
> 
> Yes, if the full address space is suddenly referenced.
> 
> > > As tasks mature and converge their working set, so does the
> > > sampling rate slow down to just a trickle, 256 MB per 32
> > > seconds of CPU time executed.
> > > 
> > > This, beyond being adaptive, also rate-limits rarely
> > > executing systems and does not over-sample on overloaded
> > > systems.
> > 
> > I am wondering if it would be better to shrink the scan period back to a
> > much smaller fixed value,
> 
> I'll do that anyway.
> 
> > and instead of picking 256MB ranges of memory
> > to mark completely, go back to using all of the address space, but mark
> > only every Nth page. 
> 
> It'll still be necessary to do the full walk and I wonder if we'd lose on
> the larger number of PTE locks that will have to be taken to do a scan if
> we are only updating every 128 pages for example. It could be very expensive.

Yes, good point.  My other inclination was not doing a mass marking of
pages at all (except just one time at some point after task init) and
conditionally setting or clearing the prot_numa in the fault path itself
to control the fault rate.  The problem I see is I am not sure how we
"back-off" the fault rate per page.  You could choose to not leave the
page marked, but then you never get a fault on that page again, so
there's no good way to mark it again in the fault path for that page
unless you have the periodic marker.  However, maybe a certain number of
pages are considered clustered together, and a fault from any page is
considered a fault for the cluster of pages.  When handling the fault,
the number of pages which are marked in the cluster is varied to achieve
a target, reasonable fault rate.  Might be able to treat page migrations
in clusters as well...  I probably need to think about this a bit
more....

> 
> > N is adjusted each period to target a rolling
> > average of X faults per MB per execution time period.  This per task N
> > would also be an interesting value to rank memory access frequency among
> > tasks and help prioritize scheduling decisions.
> > 
> 
> It's an interesting idea. I'll think on it more but my initial reaction
> is that the cost could be really high.

-Andrew Theurer


