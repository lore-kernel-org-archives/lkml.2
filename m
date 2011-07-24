Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab1GXWew (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 18:34:52 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63262 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab1GXWes convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 18:34:48 -0400
MIME-Version: 1.0
In-Reply-To: <20110724211526.GA6785@elte.hu>
References: <CAObL_7GCDsfXWRJgkNk7c44GNF0JhQPAH_P0WiYHK7QUX1Bcaw@mail.gmail.com>
 <20110724211526.GA6785@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 24 Jul 2011 18:34:28 -0400
X-Google-Sender-Auth: QVc3Uy1vricOhhY62Ityfy3vGi4
Message-ID: <CAObL_7H1j1cewgWP6Jmkw_H9dZVh1kxRGgTLa+ju=ns4gYxMdA@mail.gmail.com>
Subject: Re: [RFC] syscall calling convention, stts/clts, and xstate latency
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, x86 <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>, Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 5:15 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andrew Lutomirski <luto@mit.edu> wrote:
>
>> I was trying to understand the FPU/xstate saving code, and I ran
>> some benchmarks with surprising results.  These are all on Sandy
>> Bridge i7-2600.  Please take all numbers with a grain of salt --
>> they're in tight-ish loops and don't really take into account
>> real-world cache effects.
>>
>> A clts/stts pair takes about 80 ns.  Accessing extended state from
>> userspace with TS set takes 239 ns.  A kernel_fpu_begin /
>> kernel_fpu_end pair with no userspace xstate access takes 80 ns
>> (presumably 79 of those 80 are the clts/stts).  (Note: The numbers
>> in this paragraph were measured using a hacked-up kernel and KVM.)
>>
>> With nonzero ymm state, xsave + clflush (on the first cacheline of
>> xstate) + xrstor takes 128 ns.  With hot cache, xsave = 24ns,
>> xsaveopt (with unchanged state) = 16 ns, and xrstor = 40 ns.
>>
>> With nonzero xmm state but zero ymm state, xsave+xrstor drops to 38
>> ns and xsaveopt saves another 5 ns.
>>
>> Zeroing the state completely with vzeroall adds 2 ns.  Not sure
>> what's going on.
>>
>> All of this makes me think that, at least on Sandy Bridge, lazy
>> xstate saving is a bad optimization -- if the cache is being nice,
>> save/restore is faster than twiddling the TS bit.  And the cost of
>> the trap when TS is set blows everything else away.
>
> Interesting. Mind cooking up a delazying patch and measure it on
> native as well? KVM generally makes exceptions more expensive, so the
> effect of lazy exceptions might be less on native.

Using the same patch on native, I get:

kernel_fpu_begin/kernel_fpu_end (no userspace xstate): 71.53 ns
stts/clts: 73 ns (clearly there's a bit of error here)
userspace xstate with TS set: 229 ns

So virtualization adds only a little bit of overhead.

This isn't really a delazying patch -- it's two arch_prctls, one of
them is kernel_fpu_begin();kernel_fpu_end().  The other is the same
thing in a loop.

The other numbers were already native since I measured them entirely
in userspace.  They look the same after rebooting.

>
>>
>> Which brings me to another question: what do you think about
>> declaring some of the extended state to be clobbered by syscall?
>> Ideally, we'd treat syscall like a regular function and clobber
>> everything except the floating point control word and mxcsr.  More
>> conservatively, we'd leave xmm and x87 state but clobber ymm.  This
>> would let us keep the cost of the state save and restore down when
>> kernel_fpu_begin is used in a syscall path and when a context
>> switch happens as a result of a syscall.
>>
>> glibc does *not* mark the xmm registers as clobbered when it issues
>> syscalls, but I suspect that everything everywhere that issues
>> syscalls does it from a function, and functions are implicitly
>> assumed to clobber extended state.  (And if anything out there
>> assumes that ymm state is preserved, I'd be amazed.)
>
> To build the kernel with sse optimizations? Would certainly be
> interesting to try.

I had in mind something a little less ambitious: making
kernel_fpu_begin very fast, especially when used more than once.
Currently it's slow enough to have spawned arch/x86/crypto/fpu.c,
which is a hideous piece of infrastructure that exists solely to
reduce the number of kernel_fpu_begin/end pairs when using AES-NI.
Clobbering registers in syscall would reduce the cost even more, but
it might require having a way to detect whether the most recent kernel
entry was via syscall or some other means.

Making the whole kernel safe for xstate use would be technically
possible, but it would add about three cycles to syscalls (for
vzeroall -- non-AVX machines would take a larger hit) and apparently
about 57 ns to non-syscall traps.  That seems worse than the lazier
approach.

--Andy
