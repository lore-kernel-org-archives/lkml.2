Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab1JQO7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 10:59:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab1JQO7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 10:59:06 -0400
Date: Mon, 17 Oct 2011 10:58:42 -0400
From: Jason Baron <jbaron@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        konrad.wilk@oracle.com, rth@redhat.com
Subject: Re: [PATCH RFC V5 00/11] Paravirtualized ticketlocks
Message-ID: <20111017145842.GA2658@redhat.com>
References: <cover.1318466916.git.jeremy.fitzhardinge@citrix.com>
 <1318503245.24856.12.camel@twins>
 <4E971580.6030300@goop.org>
 <20111014141701.GA2433@redhat.com>
 <4E986B2B.60803@goop.org>
 <20111014183539.GE2433@redhat.com>
 <4E988753.1080201@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E988753.1080201@goop.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 12:02:43PM -0700, Jeremy Fitzhardinge wrote:
> On 10/14/2011 11:35 AM, Jason Baron wrote:
> > On Fri, Oct 14, 2011 at 10:02:35AM -0700, Jeremy Fitzhardinge wrote:
> >> On 10/14/2011 07:17 AM, Jason Baron wrote:
> >>> On Thu, Oct 13, 2011 at 09:44:48AM -0700, Jeremy Fitzhardinge wrote:
> >>>> pvops is basically a collection of ordinary _ops structures full of
> >>>> function pointers, but it has a layer of patching to help optimise it. 
> >>>> In the common case, this just replaces an indirect call with a direct
> >>>> one, but in some special cases it can inline code.  This is used for
> >>>> small, extremely performance-critical things like cli/sti, but it
> >>>> awkward to use in general because you have to specify the inlined code
> >>>> as a parameterless asm.
> >>>>
> >>> I haven't look at the pvops patching (probably should), but I was
> >>> wondering if jump labels could be used for it? Or is there something
> >>> that the pvops patching is doing that jump labels can't handle?
> >> Jump labels are essentially binary: you can use path A or path B.  pvops
> >> are multiway: there's no limit to the number of potential number of
> >> paravirtualized hypervisor implementations.  At the moment we have 4:
> >> native, Xen, KVM and lguest.
> >>
> > Yes, they are binary using the static_branch() interface. But in
> > general, the asm goto() construct, allows branching to any number of
> > labels. I have implemented the boolean static_branch() b/c it seems like
> > the most common interface for jump labels, but I imagine we will
> > introduce new interfaces as time goes on. You could of course nest
> > static_branch() calls, although I can't say I've tried it.
> 
> At the moment we're using pvops to optimise things like:
> 
> 	(*pv_mmu_ops.set_pte)(...);
> 
> To do that with some kind of multiway jump label thing, then that would
> need to expand out to something akin to:
> 
> 	if (static_branch(is_xen))
> 		xen_set_pte(...);
> 	else if (static_branch(is_kvm))
> 		kvm_set_pte(...);
> 	else if (static_branch(is_lguest))
> 		lguest_set_pte(...);
> 	else
> 		native_set_pte(...);
> 
> or something similar with an actual jump table.  But I don't see how it
> offers much scope for improvement.
> 
> If there were something like:
> 
> 	STATIC_INDIRECT_CALL(&pv_mmu_ops.set_pte)(...);
> 
> where the apparently indirect call is actually patched to be a direct
> call, then that would offer a large subset of what we do with pvops.
> 
> However, to completely replace pvops patching, the static branch / jump
> label mechanism would also need to work in assembler code, and be
> capable of actually patching callsites with instructions rather than
> just calls (sti/cli/pushf/popf being the most important).
> 
> We also keep track of the live registers at the callsite, and compare
> that to what registers the target functions will clobber in order to
> optimise the amount of register save/restore is needed.  And as a result
> we have some pvops functions with non-standard calling conventions to
> minimise save/restores on critical paths.
> 
> > We could have an interface, that allowed static branch(), to specifiy an
> > arbitrary number of no-ops such that call-site itself could look anyway
> > we want, if we don't know the bias at compile time. This, of course
> > means potentially greater than 1 no-op in the fast path. I assume the
> > pvops can have greater than 1 no-op in the fast path. Or is there a
> > better solution here?
> 
> See above.  But pvops patching is pretty well tuned for its job.
> 
> However, I definitely think its worth investigating some way to reduce
> the number of patching mechanisms, and if pvops patching doesn't stretch
> static jumps in unnatural ways, then perhaps that's the way to go.
> 
> Thanks,
>     J

ok, as things are now, I don't think jump labels are well suited for
replacing indirect calls. They could be used to have a single no-op that
is replaced with a jmp to the proper direct call...but at that point
you've taken an extra jump. That doesn't make sense to me.

Jump labels are well suited as mentioned for if/else type control flow,
while the indirect call table, at least to me, seems like a bit of a
different use-case...

Thanks,

-Jason
