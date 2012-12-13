Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab2LMPtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:49:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314Ab2LMPtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:49:10 -0500
Date: Thu, 13 Dec 2012 16:49:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/tile: provide PT_FLAGS_COMPAT value in pt_regs
Message-ID: <20121213154929.GA17421@redhat.com>
References: <201212122227.qBCMRiNg000851@farm-0002.internal.tilera.com> <20121212234307.GA7694@redhat.com> <50C9ECFF.6070708@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C9ECFF.6070708@tilera.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13, Chris Metcalf wrote:
>
> On 12/12/2012 6:43 PM, Oleg Nesterov wrote:
>
> > On 12/12, Chris Metcalf wrote:
> >> This flag is set for ptrace GETREGS or PEEKUSER for processes
> >> that are COMPAT, i.e. 32-bit.
> >            ^^^^^^^^^^^^^^^^^^^
> >
> > at least on x86 this is not the same. TS_COMPAT can also be set if a 64-bit
> > task calls the 32-bit syscall.
>
> There's no way on tile for that to happen.

OK,

> >> --- a/arch/tile/include/uapi/asm/ptrace.h
> >> +++ b/arch/tile/include/uapi/asm/ptrace.h
> >> @@ -84,5 +84,11 @@ struct pt_regs {
> >>  #define PTRACE_O_TRACEMIGRATE	0x00010000
> >>  #define PTRACE_EVENT_MIGRATE	16
> >>
> >> +/*
> >> + * Flag bits in pt_regs.flags that are part of the ptrace API.
> >> + * We start our numbering higher up to avoid confusion with the
> >> + * non-ABI kernel-internal values that use the low 16 bits.
> >> + */
> >> +#define PT_FLAGS_COMPAT		0x10000  /* process is an -m32 compat process */
> > Can't understand how this connects to ptrace (I mean task->ptrace).
>
> The idea is that while other architectures have things in their registers
> that identify a 32-bit execution environment, tile doesn't.  For example,
> PPC has a bit in the MSR and x86 has a different value in the CS register.
> So for tile I just synthesize a bit to report in the existing "flags" word
> of the struct pt_regs.
>
> > OK, let it live in asm/ptrace.h, but it seems that it is similar to
> > (say) PT_FLAGS_RESTORE_REGS and thus it should be 8?
>
> The other bits that live in that word are kernel-internal only, e.g.
> PT_FLAGS_RESTORE_REGS.  So they are not in the uapi header.  And in fact,
> we don't even report them out through the GETREGS API;
> we just set the single user-visible bit.

OK,

> > And. arch/tile/kernel/ptrace.c:arch_ptrace() does
> >
> > 	case PTRACE_SETOPTIONS:
> > 		/* Support TILE-specific ptrace options. */
> > 		child->ptrace &= ~PT_TRACE_MASK_TILE;
> > 		tmp = data & PTRACE_O_MASK_TILE;
> > 		data &= ~PTRACE_O_MASK_TILE;
> >
> > AFAICS we need something like BUILD_BUG_ON(PTRACE_O_MASK_TILE & PTRACE_O_MASK),
>
> I don't think so.  These are disjoint namespaces anyway.
> PTRACE_O_MASK_TILE is for the actual PTRACE_SETOPTIONS ABI values.

Yes, and thus it should not intersect with the generic PTRACE_O_MASK, no?

Suppose that we add the new generic ptrace option equal to PT_TRACE_MIGRATE.
then it won't work on tile.

> PT_TRACE_MASK_TILE is for the values stored in task->ptrace.

Yes, and thus it would be better to ensure it can't conflict with other
->ptrace bits.


> > 		ret = ptrace_request(child, request, addr, data);
> > 		if (tmp & PTRACE_O_TRACEMIGRATE)
> > 			child->ptrace |= PT_TRACE_MIGRATE;
> >
> > this also needs "ret == 0" check
>
> The question is, what happens if we pass some illegal bit to the generic
> ptrace_request(), and also pass a valid PTRACE_O_MASK_TILE bit?
> Currently we set the tile-specific bit, then report the error.
> This is consistent with how ptrace_setoptions() handles a mix of legal and
> illegal bits.

But ptrace_setoptions() returns EINVAL? it doesn't accept illegal bits.

> > and "&= ~PT_TRACE_MASK_TILE" abobe should be moved here, no?
>
> We could move it, but I don't think there's a correctness argument here.
> Are you just seeing it would be easier to understand if the manipulation of
> child->ptrace was all on adjacent lines of code?  I agree that does seem a bit
> clearer; I'll post a separate patch for that.

I agree this is minor, and up to you. Just it doesn't look consistent to me.

> > OTOH using /bin/grep I can't see where do we check ">ptrace & PT_TRACE_MIGRATE".
>
> Yes, in our internal tree,

OK. And again, somehow it would be nice to check that PTRACE_EVENT_MIGRATE
doesn't conflict with the generic PTRACE_EVENT_'s.

But this all is offtopic,

> > In short: confused ;)
> >
> I hope this clears it up a bit.  Let me know if the patch makes sense to you now! :-)

Oh, I do not understand this code with or without the patch ;)

So I'd say it looks fine to me.

Oleg.

