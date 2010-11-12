Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab0KLPM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 10:12:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60820 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab0KLPMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 10:12:24 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=_2W9UAC4NssA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=_O_uq2F3zi6mVyOhAEkA:9 a=Izfdn5aiOXJEhF4rZ5QA:7 a=z8rMr7712_qARoVc_5Am2jl1RS4A:4 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101112151222.912248551@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 12 Nov 2010 10:10:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/3] tracing: Force arch_local_irq_* notrace for paravirt
References: <20101112151045.672405637@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Force-arch_local_irq_-notrace-for-paravirt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When running ktest.pl randconfig tests, I would sometimes trigger
a lockdep annotation bug (possible reason: unannotated irqs-on).

This triggering happened right after function tracer self test was
executed. After doing a config bisect I found that this was caused with
having function tracer, paravirt guest, prove locking, and rcu torture
all enabled.

The rcu torture just enhanced the likelyhood of triggering the bug.
Prove locking was needed, since it was the thing that was bugging.
Function tracer would trace and disable interrupts in all sorts
of funny places.
paravirt guest would turn arch_local_irq_* into functions that would
be traced.

Besides the fact that tracing arch_local_irq_* is just a bad idea,
this is what is happening.

The bug happened simply in the local_irq_restore() code:

		if (raw_irqs_disabled_flags(flags)) {	\
			raw_local_irq_restore(flags);	\
			trace_hardirqs_off();		\
		} else {				\
			trace_hardirqs_on();		\
			raw_local_irq_restore(flags);	\
		}					\

The raw_local_irq_restore() was defined as arch_local_irq_restore().

Now imagine, we are about to enable interrupts. We go into the else
case and call trace_hardirqs_on() which tells lockdep that we are enabling
interrupts, so it sets the current->hardirqs_enabled = 1.

Then we call raw_local_irq_restore() which calls arch_local_irq_restore()
which gets traced!

Now in the function tracer we disable interrupts with local_irq_save().
This is fine, but flags is stored that we have interrupts disabled.

When the function tracer calls local_irq_restore() it does it, but this
time with flags set as disabled, so we go into the if () path.
This keeps interrupts disabled and calls trace_hardirqs_off() which
sets current->hardirqs_enabled = 0.

When the tracer is finished and proceeds with the original code,
we enable interrupts but leave current->hardirqs_enabled as 0. Which
now breaks lockdeps internal processing.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/paravirt.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 18e3b8a..ef99758 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -824,27 +824,27 @@ static __always_inline void arch_spin_unlock(struct arch_spinlock *lock)
 #define __PV_IS_CALLEE_SAVE(func)			\
 	((struct paravirt_callee_save) { func })
 
-static inline unsigned long arch_local_save_flags(void)
+static inline notrace unsigned long arch_local_save_flags(void)
 {
 	return PVOP_CALLEE0(unsigned long, pv_irq_ops.save_fl);
 }
 
-static inline void arch_local_irq_restore(unsigned long f)
+static inline notrace void arch_local_irq_restore(unsigned long f)
 {
 	PVOP_VCALLEE1(pv_irq_ops.restore_fl, f);
 }
 
-static inline void arch_local_irq_disable(void)
+static inline notrace void arch_local_irq_disable(void)
 {
 	PVOP_VCALLEE0(pv_irq_ops.irq_disable);
 }
 
-static inline void arch_local_irq_enable(void)
+static inline notrace void arch_local_irq_enable(void)
 {
 	PVOP_VCALLEE0(pv_irq_ops.irq_enable);
 }
 
-static inline unsigned long arch_local_irq_save(void)
+static inline notrace unsigned long arch_local_irq_save(void)
 {
 	unsigned long f;
 
-- 
1.7.1


