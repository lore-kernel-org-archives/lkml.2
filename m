Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab1C1GhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 02:37:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60924 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab1C1GhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 02:37:10 -0400
Date: Mon, 28 Mar 2011 08:36:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
        tj@kernel.org, npiggin@kernel.dk, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] slub: Disable the lockless allocator
Message-ID: <20110328063656.GA29462@elte.hu>
References: <1301161507.2979.105.camel@edumazet-laptop>
 <alpine.DEB.2.00.1103261406420.24195@router.home>
 <alpine.DEB.2.00.1103261428200.25375@router.home>
 <alpine.DEB.2.00.1103261440160.25375@router.home>
 <AANLkTinTzKQkRcE2JvP_BpR0YMj82gppAmNo7RqgftCG@mail.gmail.com>
 <alpine.DEB.2.00.1103262028170.1004@router.home>
 <alpine.DEB.2.00.1103262054410.1373@router.home>
 <4D9026C8.6060905@cs.helsinki.fi>
 <20110328061929.GA24328@elte.hu>
 <AANLkTinpCa6GBjP3+fdantvOdbktqW8m_D0fGkAnCXYk@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinpCa6GBjP3+fdantvOdbktqW8m_D0fGkAnCXYk@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Pekka Enberg <penberg@kernel.org> wrote:

> On Mon, Mar 28, 2011 at 9:19 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >> Tejun, does this look good to you as well? I think it should go
> >> through the percpu tree. It's needed to fix a boot crash with
> >> lockless SLUB fastpaths enabled.
> >
> > AFAICS Linus applied it already:
> >
> > d7c3f8cee81f: percpu: Omit segment prefix in the UP case for cmpxchg_double
> 
> Oh, I missed that. Did you test the patch, Ingo? It's missing attributions 
> and reference to the LKML discussion unfortunately...

I think we might still be missing the hunk below - or is it now not needed 
anymore?

Thanks,

	Ingo

-------------->
>From 53c0eceb7bf64f2a89c59ae4f14a676fa4128462 Mon Sep 17 00:00:00 2001
From: Christoph Lameter <cl@linux.com>
Date: Sat, 26 Mar 2011 14:49:56 -0500
Subject: [PATCH] per_cpu: Fix cmpxchg_double() for !SMP

cmpxchg_double() should only be provided for SMP. In the UP case
the GS register is not defined and the function will fail.

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: torvalds@linux-foundation.org
Cc: tj@kernel.org
Cc: npiggin@kernel.dk
Cc: rientjes@google.com
Cc: linux-mm@kvack.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
LKML-Reference: <alpine.DEB.2.00.1103261440160.25375@router.home>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/percpu.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index a09e1f0..52330a4 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -507,6 +507,7 @@ do {									\
  * it in software.  The address used in the cmpxchg16 instruction must be
  * aligned to a 16 byte boundary.
  */
+#ifdef CONFIG_SMP
 #define percpu_cmpxchg16b_double(pcp1, o1, o2, n1, n2)			\
 ({									\
 	char __ret;							\
@@ -529,6 +530,7 @@ do {									\
 #define irqsafe_cpu_cmpxchg_double_8(pcp1, pcp2, o1, o2, n1, n2)	percpu_cmpxchg16b_double(pcp1, o1, o2, n1, n2)
 
 #endif
+#endif
 
 /* This is not atomic against other CPUs -- CPU preemption needs to be off */
 #define x86_test_and_clear_bit_percpu(bit, var)				\
