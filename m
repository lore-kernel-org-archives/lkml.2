Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759951Ab0JFXGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 19:06:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758212Ab0JFXGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 19:06:41 -0400
Date: Wed, 6 Oct 2010 19:06:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <h.peter.anvin@intel.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, yinghai@kernel.org,
        caiqian@redhat.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [tip:core/memblock] x86, memblock: Fix crashkernel allocation
Message-ID: <20101006230632.GA22059@redhat.com>
References: <4CABAF2A.5090501@kernel.org>
 <tip-9f4c13964b58608fbce05540743281ea3146c0e8@git.kernel.org>
 <20101006151449.GA7378@redhat.com>
 <4CACF531.2060407@intel.com>
 <20101006224704.GD7378@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101006224704.GD7378@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 06:47:04PM -0400, Vivek Goyal wrote:
> On Wed, Oct 06, 2010 at 03:16:17PM -0700, H. Peter Anvin wrote:
> > On 10/06/2010 08:14 AM, Vivek Goyal wrote:
> > > 
> > > I really don't understand why to put a upper limit of DEFAULT_BZIMAGE_ADDR_MAX.
> > > It does not make much sense to internally impose an upper limit on
> > > reserved memory area if reserver has not specified one.
> > > 
> > > Why can't we provide a function which does a search from bottom up for
> > > the required size of memory. If the memory finally reserved does not meet
> > > the constraints needed by kexec, then kexec load will fail. Kernel does
> > > not have to try to figure out the upper limit in this case.
> > > 
> > > Current state of affairs are not perfect, but coming up with artificial
> > > upper limit here is further deterioriating the situation, IMHO.
> > > 
> > > Regarding the question of specifying the upper limit by kexec on command
> > > line, I think it is hard. Kexec needs to load multiple segments and some
> > > needs to go in really low memory area and some can be in higher memory
> > > area. What is the upper limit in this case. If we take the upper limit
> > > of lowest memory segment, then we will just not have sufficient memory
> > > to load all segments.
> > > 
> > > That would mean split the reserved region into multiple parts and one
> > > should specifiy separate upper limit for each region. That would make
> > > the whole thing complex.
> > > 
> > > So can we atleast maintain the status quo where we search for crashkernel
> > > memory bottom up without any upper limits instread of top down.
> > > 
> > 
> > The reason the "whole thing is complex" is because your constraints are
> > complex, and you're still trying to hide them from the kernel.  And what
> > is absolutely incomprehensible to me is that you seem to think this is okay.
> > 
> > I really, REALLY, ***REALLY*** don't want to burden the kernel with a
> > bunch of constraints which are invisible to it, where things will
> > randomly fail because the implementation changed.  We have too much of
> > that already, and it causes an enormous amount of problems all over the
> > kernel.
> > 
> > Of course, we're already painted into a corner with a bad design that
> > isn't going to change overnight, and of course, this is hardly the first
> > time this has happened -- we do find our way out of tight spots on a
> > regular basis.  Perhaps you're right and the best thing is to add an
> > explicit bottoms-up allocator function for now, *BUT* I would also like
> > to see a firm commitment to fix the underlying architectural problem for
> > real, and not just "maintain the status quo" indefinitely, which is what
> > your emails make me think you're expecting.
> 
> I really don't mind fixing the things properly in long term, just that I am
> running out of ideas regarding how to fix it in proper way.
> 
> To me the best thing would be that this whole allocation thing be dyanmic
> from user space where kexec will run, determine what it is loading, 
> determine what are the memory contstraints on these segments (min, upper
> limit, alignment etc), and then ask kernel for reserving contiguous
> memory. This kind of dynamic reservation will remove lot of problems
> associated with crashkernel= reservations.
> 
> But I am not aware of anyway of doing dynamic allocation and it certainly
> does not seem to be easy to be able to allocated 128M of memory contiguously.
> 
> Because we don't have a way to reserve memory dynamically later, we end up
> doing a big chunk of reservation using kernel command line and later
> figure out what to load where. Now with this approach kexec has not even run
> so how it can tell you what are the memory constraints.
> 
> So to me one of the ways of properly fixing is adding some kind of
> capability to reserve the memory dynamically (may be using sys_kexec())
> and get rid of this notion of reserving memory at boot time.
> 
> The other concern you raised is hiding constraints from kernel. At this
> point of time the only problem with crashkernel=X@0 syntax is that it
> does not tell you whether to look for memory bottom up or top down. How
> about if we specify it explicitly in the syntax so that kernel does not
> have to assume things?
> 
> In fact the initial crashkernel syntax was. crashkernel=X@Y. This meant
> allocated X amount of memory at location Y. This left no ambiguity and
> kernel did not have to assume things. It had the problem though that 
> we might not have physical RAM at location Y. So I think that's when
> somebody came up with the idea of crashkernel=X@0 so that we ideally
> want memory at location 0, but if you can't provide that, then provide
> anything available next scanning bottom up. 
> 
> So the only part missing from syntax is explicitly speicifying "next
> available location scanning bottom up". If we add that to syntax then
> kernel does not have to make assumptions. (except the alignment part).
> 
> So how about modifying syntax to crashkernel=X@Y#BU.
> 
> The "#BU" part can be optional and in that case kernel is free to allocate
> memory either top down or bottom up.
> 

Thinking more on above point.

crashkernel=X@Y will mean that allocate memory X at location Y only. If
it is not available just don't reserve. This will also mean that
we should not overload Y=0 case and crashkernel=X@0 should also mean
that reserve X amount of memory at location 0 and if it is not available
fail.

crashkernel=<size>@<offset>#<policy> will communicate additional
inforation regarding how to allocate memory. 

policy could be comma separated strings to communicate bottom up or top down
constraints. In future we could extend it to specify additional
constraints like alignment.

policy="<str>"

BU---> Look for next available free memory bottom up if memory at originally
       specified location is not available.

Thanks
Vivek
