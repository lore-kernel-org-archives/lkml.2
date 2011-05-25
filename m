Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab1EYHlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 03:41:32 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58931 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab1EYHla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 03:41:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDCB294.9000405@jp.fujitsu.com>
Date: Wed, 25 May 2011 16:41:08 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: huang ying <huang.ying.caritas@gmail.com>,
        Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 5/9] HWPoison: add memory_failure_queue()
References: <1305619719-7480-1-git-send-email-ying.huang@intel.com> <1305619719-7480-6-git-send-email-ying.huang@intel.com> <20110517084622.GE22093@elte.hu> <4DD23750.3030606@intel.com> <20110517092620.GI22093@elte.hu> <4DD31C78.6000209@intel.com> <20110520115614.GH14745@elte.hu> <BANLkTi=5Y0fqsmhsoPm8si=nQBc-tCwtrw@mail.gmail.com> <20110522100021.GA28177@elte.hu>
In-Reply-To: <20110522100021.GA28177@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/22 19:00), Ingo Molnar wrote:
> * huang ying <huang.ying.caritas@gmail.com> wrote:
>> How to do hardware error recovering in your perf framework?  IMHO, it can be 
>> something as follow:
>>
>> - NMI handler run for the hardware error, where hardware error
>> information is collected and put into a ring buffer, an irq_work is
>> triggered for further work
>> - In irq_work handler, memory_failure_queue() is called to do the real
>> recovering work for recoverable memory error in ring buffer.
>>
>> What's your idea about hardware error recovering in perf?
> 
> The first step, the whole irq_work and ring buffer already looks largely 
> duplicated: you can collect into a perf event ring-buffer from NMI context like 
> the regular perf events do.
> 
> The generalization that *would* make sense is not at the irq_work level really, 
> instead we could generalize a 'struct event' for kernel internal producers and 
> consumers of events that have no explicit PMU connection.
> 
> This new 'struct event' would be slimmer and would only contain the fields and 
> features that generic event consumers and producers need. Tracing events could 
> be updated to use these kinds of slimmer events.
> 
> It would still plug nicely into existing event ABIs, would work with event 
> filters, etc. so the tooling side would remain focused and unified.
> 
> Something like that. It is rather clear by now that splitting out irq_work was 
> a mistake. But mistakes can be fixed and some really nice code could come out 
> of it! Would you be interested in looking into this?

Err...?

Then is it better to write some nice code and throw away the following patch?


Thanks,
H.Seto

=====

[PATCH] x86, mce: replace MCE_SELF_VECTOR by irq_work

Use provided generic mechanism.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/include/asm/entry_arch.h  |    4 ---
 arch/x86/include/asm/hw_irq.h      |    1 -
 arch/x86/include/asm/irq_vectors.h |    5 ----
 arch/x86/kernel/cpu/mcheck/mce.c   |   47 ++++-------------------------------
 arch/x86/kernel/entry_64.S         |    5 ----
 arch/x86/kernel/irqinit.c          |    3 --
 6 files changed, 6 insertions(+), 59 deletions(-)

diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
index 1cd6d26..0baa628 100644
--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -53,8 +53,4 @@ BUILD_INTERRUPT(thermal_interrupt,THERMAL_APIC_VECTOR)
 BUILD_INTERRUPT(threshold_interrupt,THRESHOLD_APIC_VECTOR)
 #endif
 
-#ifdef CONFIG_X86_MCE
-BUILD_INTERRUPT(mce_self_interrupt,MCE_SELF_VECTOR)
-#endif
-
 #endif
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index bb9efe8..13f5504 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -34,7 +34,6 @@ extern void irq_work_interrupt(void);
 extern void spurious_interrupt(void);
 extern void thermal_interrupt(void);
 extern void reschedule_interrupt(void);
-extern void mce_self_interrupt(void);
 
 extern void invalidate_interrupt(void);
 extern void invalidate_interrupt0(void);
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 6e976ee..6665026 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -109,11 +109,6 @@
 
 #define UV_BAU_MESSAGE			0xf5
 
-/*
- * Self IPI vector for machine checks
- */
-#define MCE_SELF_VECTOR			0xf4
-
 /* Xen vector callback to receive events in a HVM domain */
 #define XEN_HVM_EVTCHN_CALLBACK		0xf3
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index ff1ae9b..e81d48b 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -10,7 +10,6 @@
 #include <linux/thread_info.h>
 #include <linux/capability.h>
 #include <linux/miscdevice.h>
-#include <linux/interrupt.h>
 #include <linux/ratelimit.h>
 #include <linux/kallsyms.h>
 #include <linux/rcupdate.h>
@@ -38,12 +37,9 @@
 #include <linux/mm.h>
 #include <linux/debugfs.h>
 #include <linux/edac_mce.h>
+#include <linux/irq_work.h>
 
 #include <asm/processor.h>
-#include <asm/hw_irq.h>
-#include <asm/apic.h>
-#include <asm/idle.h>
-#include <asm/ipi.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
 
@@ -461,22 +457,13 @@ static inline void mce_get_rip(struct mce *m, struct pt_regs *regs)
 		m->ip = mce_rdmsrl(rip_msr);
 }
 
-#ifdef CONFIG_X86_LOCAL_APIC
-/*
- * Called after interrupts have been reenabled again
- * when a MCE happened during an interrupts off region
- * in the kernel.
- */
-asmlinkage void smp_mce_self_interrupt(struct pt_regs *regs)
+DEFINE_PER_CPU(struct irq_work, mce_irq_work);
+
+static void mce_irq_work_cb(struct irq_work *entry)
 {
-	ack_APIC_irq();
-	exit_idle();
-	irq_enter();
 	mce_notify_irq();
 	mce_schedule_work();
-	irq_exit();
 }
-#endif
 
 static void mce_report_event(struct pt_regs *regs)
 {
@@ -492,29 +479,7 @@ static void mce_report_event(struct pt_regs *regs)
 		return;
 	}
 
-#ifdef CONFIG_X86_LOCAL_APIC
-	/*
-	 * Without APIC do not notify. The event will be picked
-	 * up eventually.
-	 */
-	if (!cpu_has_apic)
-		return;
-
-	/*
-	 * When interrupts are disabled we cannot use
-	 * kernel services safely. Trigger an self interrupt
-	 * through the APIC to instead do the notification
-	 * after interrupts are reenabled again.
-	 */
-	apic->send_IPI_self(MCE_SELF_VECTOR);
-
-	/*
-	 * Wait for idle afterwards again so that we don't leave the
-	 * APIC in a non idle state because the normal APIC writes
-	 * cannot exclude us.
-	 */
-	apic_wait_icr_idle();
-#endif
+	irq_work_queue(&__get_cpu_var(mce_irq_work));
 }
 
 DEFINE_PER_CPU(unsigned, mce_poll_count);
@@ -1444,7 +1409,7 @@ void __cpuinit mcheck_cpu_init(struct cpuinfo_x86 *c)
 	__mcheck_cpu_init_vendor(c);
 	__mcheck_cpu_init_timer();
 	INIT_WORK(&__get_cpu_var(mce_work), mce_process_work);
-
+	init_irq_work(&__get_cpu_var(mce_irq_work), &mce_irq_work_cb);
 }
 
 /*
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 8a445a0..9fa6546 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -991,11 +991,6 @@ apicinterrupt THRESHOLD_APIC_VECTOR \
 apicinterrupt THERMAL_APIC_VECTOR \
 	thermal_interrupt smp_thermal_interrupt
 
-#ifdef CONFIG_X86_MCE
-apicinterrupt MCE_SELF_VECTOR \
-	mce_self_interrupt smp_mce_self_interrupt
-#endif
-
 #ifdef CONFIG_SMP
 apicinterrupt CALL_FUNCTION_SINGLE_VECTOR \
 	call_function_single_interrupt smp_call_function_single_interrupt
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index f470e4e..f09d4bb 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -272,9 +272,6 @@ static void __init apic_intr_init(void)
 #ifdef CONFIG_X86_MCE_THRESHOLD
 	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
 #endif
-#if defined(CONFIG_X86_MCE) && defined(CONFIG_X86_LOCAL_APIC)
-	alloc_intr_gate(MCE_SELF_VECTOR, mce_self_interrupt);
-#endif
 
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
 	/* self generated IPI for local APIC timer */
-- 
1.7.4.4


