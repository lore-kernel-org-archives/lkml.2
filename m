Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab1CVRMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 13:12:21 -0400
Received: from relay1.sgi.com ([192.48.179.29]:54711 "HELO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756459Ab1CVRMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 13:12:17 -0400
Date: Tue, 22 Mar 2011 12:11:18 -0500
From: Jack Steiner <steiner@sgi.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86, UV: Fix NMI handler for UV platforms
Message-ID: <20110322171118.GA6294@sgi.com>
References: <20110321160135.GA31562@sgi.com> <20110321161425.GC23614@elte.hu> <4D877C4B.9090602@gmail.com> <20110321175110.GL1239@redhat.com> <20110321182235.GA14562@sgi.com> <20110321193740.GN1239@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110321193740.GN1239@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 03:37:40PM -0400, Don Zickus wrote:
> On Mon, Mar 21, 2011 at 01:22:35PM -0500, Jack Steiner wrote:
> > On Mon, Mar 21, 2011 at 01:51:10PM -0400, Don Zickus wrote:
> > > On Mon, Mar 21, 2011 at 07:26:51PM +0300, Cyrill Gorcunov wrote:
> > > > On 03/21/2011 07:14 PM, Ingo Molnar wrote:
> > > > > 
> > > > > * Jack Steiner <steiner@sgi.com> wrote:
> > > > > 
> > > > >> This fixes a problem seen on UV systems handling NMIs from the node controller.
> > > > >> The original code used the DIE notifier as the hook to get to the UV NMI
> > > > >> handler. This does not work if performance counters are active - the hw_perf
> > > > >> code consumes the NMI and the UV handler is not called.
> > > 
> > > Well that is a bug in the perf code.  We have been dealing with 'perf'
> > > swallowing NMIs for a couple of releases now.  I think we got rid of most
> > > of the cases (p4 and acme's core2 quad are the only cases I know that are
> > > still an issue).
> > > 
> > > I would much prefer to investigate the reason why this is happening
> > > because the perf nmi handler is supposed to check the global interrupt bit
> > > to determine if the perf counters caused the nmi or not otherwise fall
> > > through to other handler like SGI's nmi button in this case.
> > 
> > The patch that I posted is based on a RHEL6.1 patch that I'm running internally.
> > Unless something has very recently changed in the RH sources, the perf
> > NMI handler unconditionally returns NOTIFY_STOP if it handles an NMI.
> > If no NMI was handled, it returns NOTIFY_DONE. This sometimes works
> > and allows the platform generated NMI to be processed but if both NMI
> > sources trigger at about he same time, the lower priority event
> > will be lost.
> 
> Not necessarily, if both are triggered, you should still get _two_ NMIs.
> It may get processed in the wrong order but it should still get correctly
> processed.

How certain are you that multiple NMIs triggered at about the same time will
deliver discrete NMI events? I updated the patch so that I'm running with:

	- no special code in traps.c (I removed the traps.c code that was
	  in the patch I posted)
	- used die_notifier for calling the UV nmi handler
	- UV priority is higher than the hw_perf priority

Both hw_perf (perf top) & UV NMIs work correctly under light loads. However, if I
run for 10 - 15 minutes injecting UV NMIs at a rate of about 30/min, "perf top"
stops generating output. Strace shows that it continues to poll() but no data
is received.

While "perf top" is hung, if I inject an NMI into the system in a way that will NOT
be consumed by the UV nmi handler, "perf top" resumes output but will stop again after
a few minutes.


AFAICT, the UV nmi handler is not consuming extra NMI interrupts. I can't
rule out that I'm missing something but I don't see it.


Do you have any ideas or clues???


> 
> > 
> > The root cause of the problem is that architecturally, x86 does not
> > have a way to identifies the source(s) that cause an NMI. If multiple
> > events occur at about the same time, there is no way that I can see that the
> > OS can detect it.
> 
> There are registers we can check to see who owns trigger the NMI (at least
> for the perf code, the SGI code maybe not, which is why I set it to a
> lower priority to be a catch-all).
> 
> I'm not aware of the x86 architecture dropping NMIs, so they should all
> get processed.  It is just a matter of which subsystems get determine if
> they are the source of the NMI or not.
> 
> > 
> > > 
> > > My first impression is the skip nmi logic in the perf handler is probably
> > > accidentally thinking the SGI external nmi is the perf's 'extra' nmi it is
> > > supposed to skip and thus swallows it.  At least that is the impression I
> > 
> > Agree
> > 
> > 
> > > get from the RedHat bugzilla which says SGI is running 'perf top', getting
> > > a hang, then pressing their nmi button to see the stack traces.
> > > 
> > > Jack,
> > > 
> > > I worked through a number of these issues upstream and I already talked to
> > > George and Russ over here at RedHat about working through the issue over
> > > here with them.  They can help me get access to your box to help debug.
> > 
> > Russ is right down the hall.
> 
> Great!
> 
> Cheers,
> Don
