Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab2ECBxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 21:53:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55696 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab2ECBxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 21:53:50 -0400
Message-ID: <4FA1E527.1090807@gmail.com>
Date: Thu, 03 May 2012 09:53:43 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Milton Miller <miltonm@bga.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc: use local var instead of local_paca->irq_happened
 directly in __check_irq_replay
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

local_paca->irq_happened may be changed asychronously. 

In my test env (IBM Power 9117-MMA), I installed the RHEL6.2 with the shipped
oprofile. Then I run into kernel v3.4-rc4, setup/start oprofile and start the
LTP test suite.

In a short while, the system would crash. Seems that oprofile may change
the irq_happened.
======================================================================
      KERNEL: /boot/vmlinux-3.4.0-rc4-00104-gaf3a3ab
    DUMPFILE: vmcore  [PARTIAL DUMP]
        CPUS: 10
        DATE: Fri Apr 27 18:54:34 2012
      UPTIME: 00:02:34
LOAD AVERAGE: 0.60, 0.27, 0.10
       TASKS: 369
    NODENAME: feastlp3.upt.austin.ibm.com
     RELEASE: 3.4.0-rc4-00104-gaf3a3ab
     VERSION: #4 SMP Fri Apr 27 03:13:43 CDT 2012
     MACHINE: ppc64  (4704 Mhz)
      MEMORY: 9.8 GB
       PANIC: "kernel BUG at /usr/src/kernels/linux/arch/powerpc/kernel/irq.c:188!"
         PID: 0
     COMMAND: "swapper/4"
        TASK: c0000002694e3cc0  (1 of 10)  [THREAD_INFO: c0000002694f8000]
         CPU: 4
       STATE: TASK_RUNNING (PANIC)

crash> bt
PID: 0      TASK: c0000002694e3cc0  CPU: 4   COMMAND: "swapper/4"
 #0 [c00000026ffcb6e0] .crash_kexec at c0000000000f22e8
 #1 [c00000026ffcb8e0] .oops_end at c00000000060aed8
 #2 [c00000026ffcb980] ._exception at c000000000020900
 #3 [c00000026ffcbb40] program_check_common at c0000000000053b4
 Breakpoint trap  [700] exception frame:
 R0:  0000000000000001    R1:  c00000026ffcbe30    R2:  c000000000edd170   
 R3:  0000000000000500    R4:  0000000000000000    R5:  00000000000007fd   
 R6:  000000000124a180    R7:  003450cf9bd1233b    R8:  0000000000940000   
 R9:  c000000003400c00    R10: 0000000000000001    R11: 0000000000000000   
 R12: 0000000000000002    R13: c000000003400c00    R14: c0000002694fbf90   
 R15: 0000000002000040    R16: 0000000000000004    R17: 0000000000000000   
 R18: 0000000000000000    R19: 0000000000000000    R20: c000000000f42100   
 R21: 0000000000000000    R22: c000000000955b80    R23: c000000000955b80   
 R24: 000000000000000a    R25: 0000000000000004    R26: c0000002694f8100   
 R27: c00000026ffc8000    R28: 0000000000000000    R29: c000000000f42100   
 R30: c000000000e60810    R31: 0000000000000040   
 NIP: c00000000000ea9c    MSR: 8000000000029032    OR3: c00000000000ea3c
 CTR: c000000000063e40    LR:  c000000000010578    XER: 0000000000000000
 CCR: 0000000028000048    MQ:  0000000000000000    DAR: c000000001295d00
 DSISR: 0000000000000000     Syscall Result: 0000000000000000

 #4 [c00000026ffcbe30] .__check_irq_replay at c00000000000ea9c
 [Link Register ]  [c00000026ffcbe30] .arch_local_irq_restore at c000000000010578
 #5 [c00000026ffcbea0] .__do_softirq at c000000000085724
 #6 [c00000026ffcbf90] .call_do_softirq at c000000000022928
 #7 [c0000002694fb8d0] .do_softirq at c0000000000106c8
 #8 [c0000002694fb970] .irq_exit at c000000000085414
 #9 [c0000002694fb9f0] .do_IRQ at c0000000000100a4
#10 [c0000002694fbab0] hardware_interrupt_common at c0000000000038c0
 Hardware Interrupt  [501] exception frame:
 R0:  0000000000000001    R1:  c0000002694fbda0    R2:  c000000000edd170   
 R3:  0000000000000000    R4:  0000000000000000    R5:  0000000000000000   
 R6:  00000000000000e0    R7:  003450cf9bd1233b    R8:  0000000000940000   
 R9:  ffffffffffffffff    R10: 0000000000243694    R11: 0000000000000001   
 R12: 0000000000000002    R13: c000000003400c00   
 NIP: c0000000000105b4    MSR: 8000000000009032    OR3: 0000000000000c00
 CTR: c0000000004de3a0    LR:  c0000000000105b4    XER: 0000000000000000
 CCR: 0000000044000044    MQ:  0000000000000001    DAR: c0000000012990b0
 DSISR: c0000002694fbce0     Syscall Result: 0000000000000000

#11 [c0000002694fbda0] .arch_local_irq_restore at c0000000000105b4  (unreliable)
#12 [c0000002694fbe10] .cpu_idle at c000000000017d20
#13 [c0000002694fbed0] .start_secondary at c00000000061a934
#14 [c0000002694fbf90] .start_secondary_prolog at c00000000000936c


Use local var instead of local_paca->irq_happened directly in this function here.

Please check this patch. Any comments are welcome.


Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 arch/powerpc/kernel/irq.c |   46 +++++++++++++++++++++++++++++---------------
 1 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 5ec1b23..3d48b23 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -137,15 +137,17 @@ static inline notrace int decrementer_check_overflow(void)
  */
 notrace unsigned int __check_irq_replay(void)
 {
+	unsigned int ret_val;
 	/*
 	 * We use local_paca rather than get_paca() to avoid all
 	 * the debug_smp_processor_id() business in this low level
 	 * function
 	 */
-	unsigned char happened = local_paca->irq_happened;
+	unsigned char happened, irq_happened;
+	happened = irq_happened = local_paca->irq_happened;
 
 	/* Clear bit 0 which we wouldn't clear otherwise */
-	local_paca->irq_happened &= ~PACA_IRQ_HARD_DIS;
+	irq_happened &= ~PACA_IRQ_HARD_DIS;
 
 	/*
 	 * Force the delivery of pending soft-disabled interrupts on PS3.
@@ -161,33 +163,45 @@ notrace unsigned int __check_irq_replay(void)
 	 * decrementer itself rather than the paca irq_happened field
 	 * in case we also had a rollover while hard disabled
 	 */
-	local_paca->irq_happened &= ~PACA_IRQ_DEC;
-	if (decrementer_check_overflow())
-		return 0x900;
+	irq_happened &= ~PACA_IRQ_DEC;
+	if (decrementer_check_overflow()) {
+		ret_val = 0x900;
+		goto replay;
+	}
 
 	/* Finally check if an external interrupt happened */
-	local_paca->irq_happened &= ~PACA_IRQ_EE;
-	if (happened & PACA_IRQ_EE)
-		return 0x500;
+	irq_happened &= ~PACA_IRQ_EE;
+	if (happened & PACA_IRQ_EE) {
+		ret_val = 0x500;
+		goto replay;
+	}
 
 #ifdef CONFIG_PPC_BOOK3E
 	/* Finally check if an EPR external interrupt happened
 	 * this bit is typically set if we need to handle another
 	 * "edge" interrupt from within the MPIC "EPR" handler
 	 */
-	local_paca->irq_happened &= ~PACA_IRQ_EE_EDGE;
-	if (happened & PACA_IRQ_EE_EDGE)
-		return 0x500;
+	irq_happened &= ~PACA_IRQ_EE_EDGE;
+	if (happened & PACA_IRQ_EE_EDGE) {
+		ret_val = 0x500;
+		goto replay;
+	}
 
-	local_paca->irq_happened &= ~PACA_IRQ_DBELL;
-	if (happened & PACA_IRQ_DBELL)
-		return 0x280;
+	irq_happened &= ~PACA_IRQ_DBELL;
+	if (happened & PACA_IRQ_DBELL) {
+		ret_val = 0x280;
+		goto replay;
+	}
 #endif /* CONFIG_PPC_BOOK3E */
 
 	/* There should be nothing left ! */
-	BUG_ON(local_paca->irq_happened != 0);
+	BUG_ON(irq_happened != 0);
+	ret_val = 0;
 
-	return 0;
+replay:
+	local_paca->irq_happened = irq_happened;
+
+	return ret_val;
 }
 
 notrace void arch_local_irq_restore(unsigned long en)
-- 
1.7.1

