Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701Ab2IVAkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 20:40:49 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:44918 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757515Ab2IVAkq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 20:40:46 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "x86@kernel.org" <x86@kernel.org>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: [PATCH v4] trace,x86: add x86 irq vector tracepoints
Thread-Topic: [PATCH v4] trace,x86: add x86 irq vector tracepoints
Thread-Index: Ac2YWrA+n8Wn2uRQSgKoDvfneAuZiQ==
Date: Sat, 22 Sep 2012 00:40:06 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41385F33C@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-09-21_11:2012-09-21,2012-09-21,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=2 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1209210327
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change log 
 v3 -> v4
 - Add a latency measurement of each tracepoint
 - Rebased to 3.6-rc6

 v2 -> v3
 - Remove an invalidate_tlb_vector event because it was replaced by a call function vector
   in a following commit.
   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=52aec3308db85f4e9f5c8b9f5dc4fbd0138c6fa4

 v1 -> v2
 - Modify variable name from irq to vector.
 - Merge arch-specific tracepoints below to an arch_irq_vector_entry/exit.
   - error_apic_vector
   - thermal_apic_vector
   - threshold_apic_vector
   - spurious_apic_vector
   - x86_platform_ipi_vector

As Vaibhav explained in the thread below, tracepoints for irq vectors
are useful.

http://www.spinics.net/lists/mm-commits/msg85707.html

<snip>
The current interrupt traces from irq_handler_entry and irq_handler_exit
provide when an interrupt is handled.  They provide good data about when
the system has switched to kernel space and how it affects the currently
running processes.

There are some IRQ vectors which trigger the system into kernel space,
which are not handled in generic IRQ handlers.  Tracing such events gives
us the information about IRQ interaction with other system events.

The trace also tells where the system is spending its time.  We want to
know which cores are handling interrupts and how they are affecting other
processes in the system.  Also, the trace provides information about when
the cores are idle and which interrupts are changing that state.
<snip>

On the other hand, my usecase is tracing just local timer event and 
getting a value of instruction pointer.

  I suggested to add an argument local timer event to get instruction pointer before.
  But there is another way to get it with external module like systemtap.
  So, I don't need to add any argument to irq vector tracepoints now.

Vaibhav's patch shared a trace point ,irq_vector_entry/irq_vector_exit, in all events.
But there is an above use case to trace specific irq_vector rather than tracing all events.
In this case, we are concerned about overhead due to unwanted events.

This patch modifies Vaibhav's one as follows.
 - Separate generic, and across-architecture tracepoints to enable independently.
   - nmi_vector
   - local_timer_vector
   - reschedule_vector
   - call_function_vector
   - call_function_single_vector 
   - irq_work_entry_vector

 - Rename architecture-specific tracepoints from irq_vector_entry/exit to 
   arch_irq_vector_entry/exit.
   - error_apic_vector
   - thermal_apic_vector
   - threshold_apic_vector
   - spurious_apic_vector
   - x86_platform_ipi_vector

   Those x86 specific ones are not really frequently raised vectors, so
   enabling them all won't affect performance and readability of the
   traces too much.

 Latencies of each event are measured by enabling a latency tracer of ftrace because some of tracepoints are 
 in performace critical pathes. 
 In my machine, all tracepoints are an usec order in case where they are enabled.

 CPU: Xeon X3430  @ 2.40GHz
 kernel: 3.6-rc6
 arch: x86_64

(1) local timer

(1-1) local_timer_entry

 - 3.6-rc6 original
   	<...>-2788    2dNh. 894834337us : exit_idle <-smp_apic_timer_interrupt
   	<...>-2788    2dNh. 894834337us : hrtimer_interrupt <-smp_apic_timer_interrupt

 - 3.6-rc6 + this patch + trace off
   	<...>-1981    0d.h. 210538us : exit_idle <-smp_apic_timer_interrupt
   	<...>-1981    0d.h. 210538us : hrtimer_interrupt <-smp_apic_timer_interrupt

 - 3.6-rc6 + this patch + trace on
   	cat-3158    0d.h. 169673us : exit_idle <-smp_apic_timer_interrupt
    	*cat-3158    0d.h. 169674us : local_timer_entry: vector=239*
     	cat-3158    0d.h. 169674us : hrtimer_interrupt <-smp_apic_timer_interrupt

(1-2) local_timer_exit

 - 3.6-rc6 original
   	<...>-2788    2dNh. 894834361us : lapic_next_event <-clockevents_program_event
   	<...>-2788    2dNh. 894834361us : irq_exit <-smp_apic_timer_interrupt

 - 3.6-rc6 + this patch + trace off
   	<...>-1981    0d.h. 210550us : lapic_next_event <-clockevents_program_event
   	<...>-1981    0d.h. 210550us : irq_exit <-smp_apic_timer_interrupt

 - 3.6-rc6 + this patch + trace on
     	cat-3158    0d.h. 169695us : lapic_next_event <-clockevents_program_event
    	*cat-3158    0d.h. 169695us : local_timer_exit: vector=239*
     	cat-3158    0d.h. 169695us : irq_exit <-smp_apic_timer_interrupt

(2) reschedule
(2-1) reschedule_entry

 - 3.6-rc6 original
  	<idle>-0       2d... 897118426us : smp_reschedule_interrupt <-reschedule_interrupt
  	<idle>-0       2d... 897118426us : scheduler_ipi <-smp_reschedule_interrupt

 - 3.6-rc6 + this patch + trace off
  	<idle>-0       0d... 212565us : smp_reschedule_interrupt <-reschedule_interrupt
  	<idle>-0       0d... 212565us : scheduler_ipi <-smp_reschedule_interrupt

 - 3.6-rc6 + this patch + trace on
  	<idle>-0       0d... 181656us : smp_reschedule_interrupt <-reschedule_interrupt
 	*<idle>-0       0d... 181656us : reschedule_entry: vector=253*
  	<idle>-0       0d... 181657us : scheduler_ipi <-smp_reschedule_interrupt

(2-2) reschedule_exit

 - 3.6-rc6 original
  	<idle>-0       2d... 897118464us : rcu_idle_enter_common <-rcu_irq_exit
  	<idle>-0       2d... 897118465us : trace_hardirqs_on_thunk <-restore_args

 - 3.6-rc6 + this patch + trace off
  	<idle>-0       0d... 212703us : rcu_idle_enter_common <-rcu_irq_exit
  	<idle>-0       0d... 212703us : trace_hardirqs_on_thunk <-restore_args

 - 3.6-rc6 + this patch + trace on
  	<idle>-0       0d... 182711us : rcu_idle_enter_common <-rcu_irq_exit
 	*<idle>-0       0d... 182712us : reschedule_exit: vector=253*
  	<idle>-0       0d... 182712us : trace_hardirqs_on_thunk <-restore_args

(3) call_function 

 - 3.6-rc6 original
  	<idle>-0       0dNs. 158960us : __local_bh_enable <-_local_bh_enable
  	<idle>-0       0dNh. 158960us : generic_smp_call_function_interrupt <-smp_call_function_interrupt
  	<idle>-0       0dNh. 158961us : irq_exit <-smp_call_function_interrupt

 - 3.6-rc6 + this patch + trace off
  	<idle>-0       0d.s. 209117us : __local_bh_enable <-_local_bh_enable
  	<idle>-0       0d.h. 209117us : generic_smp_call_function_interrupt <-smp_call_function_interrupt
  	<idle>-0       0d.h. 209117us : irq_exit <-smp_call_function_interrupt

 - 3.6-rc6 + trace on
	<idle>-0       0d.s. 213068us : __local_bh_enable <-_local_bh_enable
	*<idle>-0       0d.h. 213069us : call_function_entry: vector=252*
	<idle>-0       0d.h. 213069us : generic_smp_call_function_interrupt <-smp_call_function_interrupt
	*<idle>-0       0d.h. 213069us : call_function_exit: vector=252*
	<idle>-0       0d.h. 213070us : irq_exit <-smp_call_function_interrupt

(4) call_function_single

 - 3.6-rc6 original
  	<idle>-0       0dNs. 158963us : __local_bh_enable <-_local_bh_enable
  	<idle>-0       0dNh. 158963us : generic_smp_call_function_single_interrupt <-smp_call_function_single_interrupt
  	<idle>-0       0dNh. 158963us : _raw_spin_lock <-generic_smp_call_function_single_interrupt
  	<idle>-0       0dNh. 158963us : irq_exit <-smp_call_function_single_interrupt

 - 3.6-rc6 + this patch + trace off
  	<idle>-0       0d.s. 209117us : __local_bh_enable <-_local_bh_enable
  	<idle>-0       0d.h. 209117us : generic_smp_call_function_interrupt <-smp_call_function_interrupt
  	<idle>-0       0d.h. 209117us : irq_exit <-smp_call_function_interrupt

 - 3.6-rc6 + this patch + trace on
  	<idle>-0       0d.s. 213095us : __local_bh_enable <-_local_bh_enable
  	*<idle>-0       0d.h. 213095us : call_function_single_entry: vector=251*
  	<idle>-0       0d.h. 213095us : generic_smp_call_function_single_interrupt <-smp_call_function_single_interrupt
  	<idle>-0       0d.h. 213095us : _raw_spin_lock <-generic_smp_call_function_single_interrupt
  	*<idle>-0       0d.h. 213095us : call_function_single_exit: vector=251*
  	<idle>-0       0d.h. 213096us : irq_exit <-smp_call_function_single_interrupt

(5) irq_work

 - 3.6-rc6 original
  	<idle>-0       0dNs. 158976us : __local_bh_enable <-_local_bh_enable
  	<idle>-0       0dNh. 158976us : irq_exit <-smp_irq_work_interrupt

 - 3.6-rc6 + this patch + trace off
  	<idle>-0       0d.s. 209163us : __local_bh_enable <-_local_bh_enable
  	<idle>-0       0d.h. 209163us : irq_exit <-smp_irq_work_interrupt

 - 3.6-rc6 + this patch + trace on
  	<idle>-0       0dNs. 181414us : __local_bh_enable <-_local_bh_enable
 	*<idle>-0       0dNh. 181415us : irq_work_entry: vector=246*
 	*<idle>-0       0dNh. 181415us : irq_work_exit: vector=246*
  	<idle>-0       0dNh. 181416us : irq_exit <-smp_irq_work_interrupt

(6) nmi

 - 3.6-rc6 original
   	<...>-2584    0d... 54448291us : trace_hardirqs_on_caller <-sysret_check
   	<...>-2584    0d.h. 54448303us : local_clock <-perf_event_update_userpage
   	<...>-2584    0d.h. 54448303us : intel_pmu_enable_all <-intel_pmu_handle_irq
   	<...>-2584    0d.h. 54448304us : intel_pmu_pebs_enable_all <-intel_pmu_enable_all
   	<...>-2584    0d.h. 54448304us : intel_pmu_lbr_enable_all <-intel_pmu_enable_all
   	<...>-2584    0d.h. 54448304us : arch_trigger_all_cpu_backtrace_handler <-nmi_handle
   	<...>-2584    0d.h. 54448304us : rcu_nmi_exit <-do_nmi

 - 3.6-rc6 + this patch + trace off
	<...>-2581    1d.h. 46380362us : local_clock <-perf_event_update_userpage
	<...>-2581    1d.h. 46380363us : intel_pmu_enable_all <-intel_pmu_handle_irq
	<...>-2581    1d.h. 46380363us : intel_pmu_pebs_enable_all <-intel_pmu_enable_all
	<...>-2581    1d.h. 46380363us : intel_pmu_lbr_enable_all <-intel_pmu_enable_all
	<...>-2581    1d.h. 46380364us : arch_trigger_all_cpu_backtrace_handler <-nmi_handle
	<...>-2581    1d.h. 46380364us : rcu_nmi_exit <-do_nmi


 - 3.6-rc6 + this patch + trace on
	grep-2619    1d... 176854482us : trace_hardirqs_on_caller <-sysret_check
   	*grep-2619    1d.h. 176854528us : nmi_entry: vector=2*
    	grep-2619    1d.h. 176854531us : local_clock <-perf_event_update_userpage
   	grep-2619    1d.h. 176854531us : intel_pmu_enable_all <-intel_pmu_handle_irq
    	grep-2619    1d.h. 176854531us : intel_pmu_pebs_enable_all <-intel_pmu_enable_all
    	grep-2619    1d.h. 176854532us : intel_pmu_lbr_enable_all <-intel_pmu_enable_all
    	grep-2619    1d.h. 176854532us : arch_trigger_all_cpu_backtrace_handler <-nmi_handle
   	*grep-2619    1d.h. 176854532us : nmi_exit: vector=2*
    	grep-2619    1d.h. 176854532us : rcu_nmi_exit <-do_nmi

(7) arch_irq_vector
(7-1) arch_irq_vector_entry

 - 3.6-rc6 original
	<idle>-0       0dNh. 158949us : notifier_call_chain <-atomic_notifier_call_chain
	<idle>-0       0dNh. 158949us : printk <-smp_spurious_interrupt

 - 3.6-rc6 + this patch + trace off
  	<idle>-0       0d.h. 209125us : notifier_call_chain <-atomic_notifier_call_chain
  	<idle>-0       0d.h. 209125us : printk <-smp_spurious_interrupt

 - 3.6-rc6 + this patch + trace on
  	<idle>-0       0d.h. 213076us : notifier_call_chain <-atomic_notifier_call_chain
 	*<idle>-0       0d.h. 213076us : arch_irq_vector_entry: vector=255 name=SPURIOUS_APIC_VECTOR*
  	<idle>-0       0d.h. 213076us : printk <-smp_spurious_interrupt

(7-2) arch_irq_vector_exit

 - 3.6-rc6 original
	<idle>-0       0dNh. 158955us : _raw_spin_unlock_irqrestore <-console_unlock
  	<idle>-0       0dNh. 158955us : irq_exit <-smp_spurious_interrupt

 - 3.6-rc6 + this patch + trace off
  	<idle>-0       0d.h. 209131us : _raw_spin_unlock_irqrestore <-console_unlock
  	<idle>-0       0d.h. 209131us : irq_exit <-smp_spurious_interrupt

 - 3.6-rc6 + this patch + trace on
  	<idle>-0       0d.h. 213082us : _raw_spin_unlock_irqrestore <-console_unlock
 	*<idle>-0       0d.h. 213082us : arch_irq_vector_exit: vector=255 name=SPURIOUS_APIC_VECTOR*
  	<idle>-0       0d.h. 213083us : irq_exit <-smp_spurious_interrupt

 Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

---
 arch/x86/include/asm/irq_vectors.h       |    9 ++
 arch/x86/kernel/apic/apic.c              |    7 +
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    3 +
 arch/x86/kernel/cpu/mcheck/threshold.c   |    3 +
 arch/x86/kernel/irq.c                    |    5 +
 arch/x86/kernel/irq_work.c               |    3 +
 arch/x86/kernel/nmi.c                    |    3 +
 arch/x86/kernel/smp.c                    |    7 +
 include/trace/events/irq_vectors.h       |  209 ++++++++++++++++++++++++++++++
 9 files changed, 249 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/irq_vectors.h

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 1508e51..510ced5 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -158,4 +158,13 @@ static inline int invalid_vm86_irq(int irq)
 # define NR_IRQS			NR_IRQS_LEGACY
 #endif
 
+#define irq_vector_name(vector) { vector, #vector }
+
+#define irq_vector_name_table						\
+			irq_vector_name(ERROR_APIC_VECTOR),		\
+			irq_vector_name(THERMAL_APIC_VECTOR),		\
+			irq_vector_name(THRESHOLD_APIC_VECTOR),		\
+			irq_vector_name(SPURIOUS_APIC_VECTOR),		\
+			irq_vector_name(X86_PLATFORM_IPI_VECTOR)
+
 #endif /* _ASM_X86_IRQ_VECTORS_H */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 24deb30..b9cdd8f 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -34,6 +34,7 @@
 #include <linux/dmi.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
+#include <trace/events/irq_vectors.h>
 
 #include <asm/irq_remapping.h>
 #include <asm/perf_event.h>
@@ -895,7 +896,9 @@ void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
 	 */
 	irq_enter();
 	exit_idle();
+	trace_local_timer_entry(LOCAL_TIMER_VECTOR);
 	local_apic_timer_interrupt();
+	trace_local_timer_exit(LOCAL_TIMER_VECTOR);
 	irq_exit();
 
 	set_irq_regs(old_regs);
@@ -1881,6 +1884,7 @@ void smp_spurious_interrupt(struct pt_regs *regs)
 
 	irq_enter();
 	exit_idle();
+	trace_arch_irq_vector_entry(SPURIOUS_APIC_VECTOR);
 	/*
 	 * Check if this really is a spurious interrupt and ACK it
 	 * if it is a vectored one.  Just in case...
@@ -1895,6 +1899,7 @@ void smp_spurious_interrupt(struct pt_regs *regs)
 	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
 	pr_info("spurious APIC interrupt on CPU#%d, "
 		"should never happen.\n", smp_processor_id());
+	trace_arch_irq_vector_exit(SPURIOUS_APIC_VECTOR);
 	irq_exit();
 }
 
@@ -1918,6 +1923,7 @@ void smp_error_interrupt(struct pt_regs *regs)
 
 	irq_enter();
 	exit_idle();
+	trace_arch_irq_vector_entry(ERROR_APIC_VECTOR);
 	/* First tickle the hardware, only then report what went on. -- REW */
 	v0 = apic_read(APIC_ESR);
 	apic_write(APIC_ESR, 0);
@@ -1938,6 +1944,7 @@ void smp_error_interrupt(struct pt_regs *regs)
 
 	apic_printk(APIC_DEBUG, KERN_CONT "\n");
 
+	trace_arch_irq_vector_exit(ERROR_APIC_VECTOR);
 	irq_exit();
 }
 
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 47a1870..63c2cc8 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
+#include <trace/events/irq_vectors.h>
 
 #include <asm/processor.h>
 #include <asm/apic.h>
@@ -382,8 +383,10 @@ asmlinkage void smp_thermal_interrupt(struct pt_regs *regs)
 {
 	irq_enter();
 	exit_idle();
+	trace_arch_irq_vector_entry(THERMAL_APIC_VECTOR);
 	inc_irq_stat(irq_thermal_count);
 	smp_thermal_vector();
+	trace_arch_irq_vector_exit(THERMAL_APIC_VECTOR);
 	irq_exit();
 	/* Ack only at the end to avoid potential reentry */
 	ack_APIC_irq();
diff --git a/arch/x86/kernel/cpu/mcheck/threshold.c b/arch/x86/kernel/cpu/mcheck/threshold.c
index aa578ca..de74768 100644
--- a/arch/x86/kernel/cpu/mcheck/threshold.c
+++ b/arch/x86/kernel/cpu/mcheck/threshold.c
@@ -3,6 +3,7 @@
  */
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
+#include <trace/events/irq_vectors.h>
 
 #include <asm/irq_vectors.h>
 #include <asm/apic.h>
@@ -21,8 +22,10 @@ asmlinkage void smp_threshold_interrupt(void)
 {
 	irq_enter();
 	exit_idle();
+	trace_arch_irq_vector_entry(THRESHOLD_APIC_VECTOR);
 	inc_irq_stat(irq_threshold_count);
 	mce_threshold_vector();
+	trace_arch_irq_vector_exit(THRESHOLD_APIC_VECTOR);
 	irq_exit();
 	/* Ack only at the end to avoid potential reentry */
 	ack_APIC_irq();
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 1f5f1d5..f4d7344 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -18,6 +18,9 @@
 #include <asm/mce.h>
 #include <asm/hw_irq.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/irq_vectors.h>
+
 atomic_t irq_err_count;
 
 /* Function pointer for generic interrupt vector handling */
@@ -218,11 +221,13 @@ void smp_x86_platform_ipi(struct pt_regs *regs)
 
 	exit_idle();
 
+	trace_arch_irq_vector_entry(X86_PLATFORM_IPI_VECTOR);
 	inc_irq_stat(x86_platform_ipis);
 
 	if (x86_platform_ipi_callback)
 		x86_platform_ipi_callback();
 
+	trace_arch_irq_vector_exit(X86_PLATFORM_IPI_VECTOR);
 	irq_exit();
 
 	set_irq_regs(old_regs);
diff --git a/arch/x86/kernel/irq_work.c b/arch/x86/kernel/irq_work.c
index ca8f703..2cf7505 100644
--- a/arch/x86/kernel/irq_work.c
+++ b/arch/x86/kernel/irq_work.c
@@ -8,13 +8,16 @@
 #include <linux/irq_work.h>
 #include <linux/hardirq.h>
 #include <asm/apic.h>
+#include <trace/events/irq_vectors.h>
 
 void smp_irq_work_interrupt(struct pt_regs *regs)
 {
 	irq_enter();
 	ack_APIC_irq();
+	trace_irq_work_entry(IRQ_WORK_VECTOR);
 	inc_irq_stat(apic_irq_work_irqs);
 	irq_work_run();
+	trace_irq_work_exit(IRQ_WORK_VECTOR);
 	irq_exit();
 }
 
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index f84f5c5..cc57aba 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -28,6 +28,7 @@
 #include <asm/mach_traps.h>
 #include <asm/nmi.h>
 #include <asm/x86_init.h>
+#include <trace/events/irq_vectors.h>
 
 struct nmi_desc {
 	spinlock_t lock;
@@ -482,12 +483,14 @@ do_nmi(struct pt_regs *regs, long error_code)
 	nmi_nesting_preprocess(regs);
 
 	nmi_enter();
+	trace_nmi_entry(NMI_VECTOR);
 
 	inc_irq_stat(__nmi_count);
 
 	if (!ignore_nmis)
 		default_do_nmi(regs);
 
+	trace_nmi_exit(NMI_VECTOR);
 	nmi_exit();
 
 	/* On i386, may loop back to preprocess */
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 48d2b7d..5b2d6de 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
 #include <linux/gfp.h>
+#include <trace/events/irq_vectors.h>
 
 #include <asm/mtrr.h>
 #include <asm/tlbflush.h>
@@ -252,8 +253,10 @@ finish:
 void smp_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
+	trace_reschedule_entry(RESCHEDULE_VECTOR);
 	inc_irq_stat(irq_resched_count);
 	scheduler_ipi();
+	trace_reschedule_exit(RESCHEDULE_VECTOR);
 	/*
 	 * KVM uses this interrupt to force a cpu out of guest mode
 	 */
@@ -263,8 +266,10 @@ void smp_call_function_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
 	irq_enter();
+	trace_call_function_entry(CALL_FUNCTION_VECTOR);
 	generic_smp_call_function_interrupt();
 	inc_irq_stat(irq_call_count);
+	trace_call_function_exit(CALL_FUNCTION_VECTOR);
 	irq_exit();
 }
 
@@ -272,8 +277,10 @@ void smp_call_function_single_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
 	irq_enter();
+	trace_call_function_single_entry(CALL_FUNCTION_SINGLE_VECTOR);
 	generic_smp_call_function_single_interrupt();
 	inc_irq_stat(irq_call_count);
+	trace_call_function_single_exit(CALL_FUNCTION_SINGLE_VECTOR);
 	irq_exit();
 }
 
diff --git a/include/trace/events/irq_vectors.h b/include/trace/events/irq_vectors.h
new file mode 100644
index 0000000..fffe0c0
--- /dev/null
+++ b/include/trace/events/irq_vectors.h
@@ -0,0 +1,209 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM irq_vectors
+
+#if !defined(_TRACE_IRQ_VECTORS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_IRQ_VECTORS_H
+
+#include <linux/tracepoint.h>
+#include <asm/irq.h>
+
+#ifndef irq_vector_name_table
+#define irq_vector_name_table { -1, NULL }
+#endif
+
+
+/*
+ * This class is used by generic ,cross-architecture tracepoints.
+ */
+DECLARE_EVENT_CLASS(irq_vector,
+
+	TP_PROTO(int vector),
+
+	TP_ARGS(vector),
+
+	TP_STRUCT__entry(
+		__field(	int,	vector	)
+	),
+
+	TP_fast_assign(
+		__entry->vector = vector;
+	),
+
+	TP_printk("vector=%d", __entry->vector)
+);
+
+/*
+ * nmi_entry - called before enterring a nmi vector handler
+ */
+DEFINE_EVENT(irq_vector, nmi_entry,
+
+	TP_PROTO(int vector),
+
+	TP_ARGS(vector)
+);
+
+/*
+ * nmi_exit - called immediately after the interrupt vector
+ * handler returns
+ */
+DEFINE_EVENT(irq_vector, nmi_exit,
+
+	TP_PROTO(int vector),
+
+	TP_ARGS(vector)
+);
+
+/*
+ * local_timer_entry - called before enterring a local timer interrupt
+ * vector handler
+ */
+DEFINE_EVENT(irq_vector, local_timer_entry,
+
+	TP_PROTO(int vector),
+
+	TP_ARGS(vector)
+);
+
+/*
+ * local_timer_exit - called immediately after the interrupt vector
+ * handler returns
+ */
+DEFINE_EVENT(irq_vector, local_timer_exit,
+
+	TP_PROTO(int vector),
+
+	TP_ARGS(vector)
+);
+
+/*
+ * reschedule_entry - called before enterring a reschedule vector handler
+ */
+DEFINE_EVENT(irq_vector, reschedule_entry,
+
+	TP_PROTO(int vector),
+
+	TP_ARGS(vector)
+);
+
+/*
+ * reschedule_exit - called immediately after the interrupt vector
+ * handler returns
+ */
+DEFINE_EVENT(irq_vector, reschedule_exit,
+
+	TP_PROTO(int vector),
+
+	TP_ARGS(vector)
+);
+
+/*
+ * call_function_entry - called before enterring a call function
+ *			 vector handler
+ */
+DEFINE_EVENT(irq_vector, call_function_entry,
+
+	TP_PROTO(int vector),
+
+	TP_ARGS(vector)
+);
+
+/*
+ * call_function_exit - called immediately after the interrupt vector
+ * handler returns
+ */
+DEFINE_EVENT(irq_vector, call_function_exit,
+
+	TP_PROTO(int vector),
+
+	TP_ARGS(vector)
+);
+
+/*
+ * call_function_single_entry - called before enterring a call function
+ * single vector handler
+ */
+DEFINE_EVENT(irq_vector, call_function_single_entry,
+
+	TP_PROTO(int vector),
+
+	TP_ARGS(vector)
+);
+
+/*
+ * call_function_single_exit - called immediately after the interrupt vector
+ * handler returns
+ */
+DEFINE_EVENT(irq_vector, call_function_single_exit,
+
+	TP_PROTO(int vector),
+
+	TP_ARGS(vector)
+);
+
+/*
+ * irq_work_entry - called before enterring an irq work vector handler
+ */
+DEFINE_EVENT(irq_vector, irq_work_entry,
+
+	TP_PROTO(int vector),
+
+	TP_ARGS(vector)
+);
+
+/*
+ * irq_work_exit - called immediately after the interrupt vector
+ * handler returns
+ */
+DEFINE_EVENT(irq_vector, irq_work_exit,
+
+	TP_PROTO(int vector),
+
+	TP_ARGS(vector)
+);
+
+/*
+ * This class is used by arch-specific tracepoints.
+ */
+DECLARE_EVENT_CLASS(arch_irq_vector,
+
+	TP_PROTO(int vector),
+
+	TP_ARGS(vector),
+
+	TP_STRUCT__entry(
+		__field(	int,	vector	)
+	),
+
+	TP_fast_assign(
+		__entry->vector = vector;
+	),
+
+	TP_printk("vector=%d name=%s", __entry->vector,
+		__print_symbolic(__entry->vector, irq_vector_name_table))
+);
+
+/*
+ * arch_irq_vector_entry - called before enterring a interrupt vector handler
+ */
+DEFINE_EVENT(arch_irq_vector, arch_irq_vector_entry,
+
+	TP_PROTO(int vector),
+
+	TP_ARGS(vector)
+);
+
+/*
+ * arch_irq_vector_exit - called immediately after the interrupt vector
+ * handler returns
+ */
+DEFINE_EVENT(arch_irq_vector, arch_irq_vector_exit,
+
+	TP_PROTO(int vector),
+
+	TP_ARGS(vector)
+);
+
+#endif /*  _TRACE_IRQ_VECTORS_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 1.7.1 

