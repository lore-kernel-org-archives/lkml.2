Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab1GXVHa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 17:07:30 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:34388 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab1GXVH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 17:07:28 -0400
MIME-Version: 1.0
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 24 Jul 2011 17:07:08 -0400
X-Google-Sender-Auth: SjCWcZOLSmU-Kn7Vcdls58oKTCk
Message-ID: <CAObL_7GCDsfXWRJgkNk7c44GNF0JhQPAH_P0WiYHK7QUX1Bcaw@mail.gmail.com>
Subject: [RFC] syscall calling convention, stts/clts, and xstate latency
To: linux-kernel@vger.kernel.org, x86 <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was trying to understand the FPU/xstate saving code, and I ran some
benchmarks with surprising results.  These are all on Sandy Bridge
i7-2600.  Please take all numbers with a grain of salt -- they're in
tight-ish loops and don't really take into account real-world cache
effects.

A clts/stts pair takes about 80 ns.  Accessing extended state from
userspace with TS set takes 239 ns.  A kernel_fpu_begin /
kernel_fpu_end pair with no userspace xstate access takes 80 ns
(presumably 79 of those 80 are the clts/stts).  (Note: The numbers in
this paragraph were measured using a hacked-up kernel and KVM.)

With nonzero ymm state, xsave + clflush (on the first cacheline of
xstate) + xrstor takes 128 ns.  With hot cache, xsave = 24ns, xsaveopt
(with unchanged state) = 16 ns, and xrstor = 40 ns.

With nonzero xmm state but zero ymm state, xsave+xrstor drops to 38 ns
and xsaveopt saves another 5 ns.

Zeroing the state completely with vzeroall adds 2 ns.  Not sure what's going on.

All of this makes me think that, at least on Sandy Bridge, lazy xstate
saving is a bad optimization -- if the cache is being nice,
save/restore is faster than twiddling the TS bit.  And the cost of the
trap when TS is set blows everything else away.


Which brings me to another question: what do you think about declaring
some of the extended state to be clobbered by syscall?  Ideally, we'd
treat syscall like a regular function and clobber everything except
the floating point control word and mxcsr.  More conservatively, we'd
leave xmm and x87 state but clobber ymm.  This would let us keep the
cost of the state save and restore down when kernel_fpu_begin is used
in a syscall path and when a context switch happens as a result of a
syscall.

glibc does *not* mark the xmm registers as clobbered when it issues
syscalls, but I suspect that everything everywhere that issues
syscalls does it from a function, and functions are implicitly assumed
to clobber extended state.  (And if anything out there assumes that
ymm state is preserved, I'd be amazed.)


--Andy
