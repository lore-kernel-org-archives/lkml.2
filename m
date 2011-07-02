Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab1GBDpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 23:45:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46290 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab1GBDpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 23:45:14 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=vhdKIqpQuCYA:10 a=ZUdgYUbPPZQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=oGMlB6cnAAAA:8 a=meVymXHHAAAA:8 a=LE3ihm_ZJSPgXNxJQTAA:9 a=24w_iQnyoQdUQhmxa9wA:7 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=CY6gl2JlH4YA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110702033852.733414762@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 01 Jul 2011 23:04:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 01/11] x86/irqs: Do not trace arch_local_{*,irq_*} functions
References: <20110702030435.308336775@goodmis.org>
Content-Disposition: inline; filename=0001-x86-irqs-Do-not-trace-arch_local_-irq_-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

I triggered a triple fault with gcc 4.5.1 because it did not honor
the inline annotation to arch_local_save_flags() function and that
function was added to the pool of functions traced by the function tracer.

When preempt_schedule() called arch_local_save_flags() (called by
irqs_disabled()), it was traced, but the first thing the function tracer
does is disable preemption. When it enables preemption, the NEED_RESCHED
flag will not have been cleared and the preemption check will trigger
the call to preempt_schedule() again.

Although the dynamic function tracer crashed immediately, the static
version of the function tracer (CONFIG_DYNAMIC_FTRACE is not set) actually
was able to show where the problem was.

 swapper-1       3.N.. 103885us : arch_local_save_flags <-preempt_schedule
 swapper-1       3.N.. 103886us : arch_local_save_flags <-preempt_schedule
 swapper-1       3.N.. 103886us : arch_local_save_flags <-preempt_schedule
 swapper-1       3.N.. 103887us : arch_local_save_flags <-preempt_schedule
 swapper-1       3.N.. 103887us : arch_local_save_flags <-preempt_schedule
 swapper-1       3.N.. 103888us : arch_local_save_flags <-preempt_schedule
 swapper-1       3.N.. 103888us : arch_local_save_flags <-preempt_schedule

It went on for a while before it triple faulted with a corrupted stack.

The arch_local_save_flags and arch_local_irq_* functions should not be
traced. Even though they are marked as inline, gcc may still make
them a function and enable tracing of them.

The simple solution is to just mark them as notrace. I had to add the
<linux/types.h> for this file to include the notrace tag.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/irqflags.h |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/irqflags.h b/arch/x86/include/asm/irqflags.h
index 5745ce8..bba3cf8 100644
--- a/arch/x86/include/asm/irqflags.h
+++ b/arch/x86/include/asm/irqflags.h
@@ -60,23 +60,24 @@ static inline void native_halt(void)
 #include <asm/paravirt.h>
 #else
 #ifndef __ASSEMBLY__
+#include <linux/types.h>
 
-static inline unsigned long arch_local_save_flags(void)
+static inline notrace unsigned long arch_local_save_flags(void)
 {
 	return native_save_fl();
 }
 
-static inline void arch_local_irq_restore(unsigned long flags)
+static inline notrace void arch_local_irq_restore(unsigned long flags)
 {
 	native_restore_fl(flags);
 }
 
-static inline void arch_local_irq_disable(void)
+static inline notrace void arch_local_irq_disable(void)
 {
 	native_irq_disable();
 }
 
-static inline void arch_local_irq_enable(void)
+static inline notrace void arch_local_irq_enable(void)
 {
 	native_irq_enable();
 }
@@ -102,7 +103,7 @@ static inline void halt(void)
 /*
  * For spinlocks, etc:
  */
-static inline unsigned long arch_local_irq_save(void)
+static inline notrace unsigned long arch_local_irq_save(void)
 {
 	unsigned long flags = arch_local_save_flags();
 	arch_local_irq_disable();
-- 
1.7.5.4



