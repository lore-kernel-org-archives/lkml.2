Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab1GXVQY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 17:16:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50253 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284Ab1GXVQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 17:16:21 -0400
Date: Sun, 24 Jul 2011 23:15:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org, x86 <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>, Avi Kivity <avi@redhat.com>
Subject: Re: [RFC] syscall calling convention, stts/clts, and xstate latency
Message-ID: <20110724211526.GA6785@elte.hu>
References: <CAObL_7GCDsfXWRJgkNk7c44GNF0JhQPAH_P0WiYHK7QUX1Bcaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAObL_7GCDsfXWRJgkNk7c44GNF0JhQPAH_P0WiYHK7QUX1Bcaw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Lutomirski <luto@mit.edu> wrote:

> I was trying to understand the FPU/xstate saving code, and I ran 
> some benchmarks with surprising results.  These are all on Sandy 
> Bridge i7-2600.  Please take all numbers with a grain of salt -- 
> they're in tight-ish loops and don't really take into account 
> real-world cache effects.
> 
> A clts/stts pair takes about 80 ns.  Accessing extended state from 
> userspace with TS set takes 239 ns.  A kernel_fpu_begin / 
> kernel_fpu_end pair with no userspace xstate access takes 80 ns 
> (presumably 79 of those 80 are the clts/stts).  (Note: The numbers 
> in this paragraph were measured using a hacked-up kernel and KVM.)
> 
> With nonzero ymm state, xsave + clflush (on the first cacheline of 
> xstate) + xrstor takes 128 ns.  With hot cache, xsave = 24ns, 
> xsaveopt (with unchanged state) = 16 ns, and xrstor = 40 ns.
> 
> With nonzero xmm state but zero ymm state, xsave+xrstor drops to 38 
> ns and xsaveopt saves another 5 ns.
> 
> Zeroing the state completely with vzeroall adds 2 ns.  Not sure 
> what's going on.
> 
> All of this makes me think that, at least on Sandy Bridge, lazy 
> xstate saving is a bad optimization -- if the cache is being nice, 
> save/restore is faster than twiddling the TS bit.  And the cost of 
> the trap when TS is set blows everything else away.

Interesting. Mind cooking up a delazying patch and measure it on 
native as well? KVM generally makes exceptions more expensive, so the 
effect of lazy exceptions might be less on native.

> 
> Which brings me to another question: what do you think about 
> declaring some of the extended state to be clobbered by syscall?  
> Ideally, we'd treat syscall like a regular function and clobber 
> everything except the floating point control word and mxcsr.  More 
> conservatively, we'd leave xmm and x87 state but clobber ymm.  This 
> would let us keep the cost of the state save and restore down when 
> kernel_fpu_begin is used in a syscall path and when a context 
> switch happens as a result of a syscall.
> 
> glibc does *not* mark the xmm registers as clobbered when it issues 
> syscalls, but I suspect that everything everywhere that issues 
> syscalls does it from a function, and functions are implicitly 
> assumed to clobber extended state.  (And if anything out there 
> assumes that ymm state is preserved, I'd be amazed.)

To build the kernel with sse optimizations? Would certainly be 
interesting to try.

Thanks,

	Ingo
