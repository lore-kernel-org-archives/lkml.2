Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab0KATaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:30:20 -0400
Received: from king.tilera.com ([72.1.168.226]:3864 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab0KAT3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:29:55 -0400
Message-Id: <201011011929.oA1JTmSj024941@farm-0027.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 1 Nov 2010 15:24:29 -0400
Subject: [PATCH] arch/tile: bomb raw_local_irq_ to arch_local_irq_
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 01 Nov 2010 19:29:48.0585 (UTC) FILETIME=[25AA2190:01CB79FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This completes the tile migration to the new naming scheme for
the architecture-specific irq management code.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/early_printk.c |    2 +-
 arch/tile/kernel/hardwall.c     |    4 ++--
 arch/tile/kernel/irq.c          |    4 ++--
 arch/tile/kernel/messaging.c    |    2 +-
 arch/tile/kernel/reboot.c       |    6 +++---
 arch/tile/kernel/setup.c        |    8 ++++----
 arch/tile/kernel/smp.c          |    2 +-
 arch/tile/kernel/time.c         |    8 ++++----
 8 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/tile/kernel/early_printk.c b/arch/tile/kernel/early_printk.c
index 2c54fd4..493a0e6 100644
--- a/arch/tile/kernel/early_printk.c
+++ b/arch/tile/kernel/early_printk.c
@@ -54,7 +54,7 @@ void early_printk(const char *fmt, ...)
 void early_panic(const char *fmt, ...)
 {
 	va_list ap;
-	raw_local_irq_disable_all();
+	arch_local_irq_disable_all();
 	va_start(ap, fmt);
 	early_printk("Kernel panic - not syncing: ");
 	early_vprintk(fmt, ap);
diff --git a/arch/tile/kernel/hardwall.c b/arch/tile/kernel/hardwall.c
index db5e610..e910530 100644
--- a/arch/tile/kernel/hardwall.c
+++ b/arch/tile/kernel/hardwall.c
@@ -151,12 +151,12 @@ enum direction_protect {
 
 static void enable_firewall_interrupts(void)
 {
-	raw_local_irq_unmask_now(INT_UDN_FIREWALL);
+	arch_local_irq_unmask_now(INT_UDN_FIREWALL);
 }
 
 static void disable_firewall_interrupts(void)
 {
-	raw_local_irq_mask_now(INT_UDN_FIREWALL);
+	arch_local_irq_mask_now(INT_UDN_FIREWALL);
 }
 
 /* Set up hardwall on this cpu based on the passed hardwall_info. */
diff --git a/arch/tile/kernel/irq.c b/arch/tile/kernel/irq.c
index e639176..128805e 100644
--- a/arch/tile/kernel/irq.c
+++ b/arch/tile/kernel/irq.c
@@ -26,7 +26,7 @@
 #define IS_HW_CLEARED 1
 
 /*
- * The set of interrupts we enable for raw_local_irq_enable().
+ * The set of interrupts we enable for arch_local_irq_enable().
  * This is initialized to have just a single interrupt that the kernel
  * doesn't actually use as a sentinel.  During kernel init,
  * interrupts are added as the kernel gets prepared to support them.
@@ -225,7 +225,7 @@ void __cpuinit setup_irq_regs(void)
 	/* Enable interrupt delivery. */
 	unmask_irqs(~0UL);
 #if CHIP_HAS_IPI()
-	raw_local_irq_unmask(INT_IPI_K);
+	arch_local_irq_unmask(INT_IPI_K);
 #endif
 }
 
diff --git a/arch/tile/kernel/messaging.c b/arch/tile/kernel/messaging.c
index 997e393..0858ee6 100644
--- a/arch/tile/kernel/messaging.c
+++ b/arch/tile/kernel/messaging.c
@@ -34,7 +34,7 @@ void __cpuinit init_messaging(void)
 		panic("hv_register_message_state: error %d", rc);
 
 	/* Make sure downcall interrupts will be enabled. */
-	raw_local_irq_unmask(INT_INTCTRL_K);
+	arch_local_irq_unmask(INT_INTCTRL_K);
 }
 
 void hv_message_intr(struct pt_regs *regs, int intnum)
diff --git a/arch/tile/kernel/reboot.c b/arch/tile/kernel/reboot.c
index acd86d2..baa3d90 100644
--- a/arch/tile/kernel/reboot.c
+++ b/arch/tile/kernel/reboot.c
@@ -27,7 +27,7 @@
 void machine_halt(void)
 {
 	warn_early_printk();
-	raw_local_irq_disable_all();
+	arch_local_irq_disable_all();
 	smp_send_stop();
 	hv_halt();
 }
@@ -35,14 +35,14 @@ void machine_halt(void)
 void machine_power_off(void)
 {
 	warn_early_printk();
-	raw_local_irq_disable_all();
+	arch_local_irq_disable_all();
 	smp_send_stop();
 	hv_power_off();
 }
 
 void machine_restart(char *cmd)
 {
-	raw_local_irq_disable_all();
+	arch_local_irq_disable_all();
 	smp_send_stop();
 	hv_restart((HV_VirtAddr) "vmlinux", (HV_VirtAddr) cmd);
 }
diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index ae51cad..fb0b3cb 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -868,14 +868,14 @@ void __cpuinit setup_cpu(int boot)
 
 	/* Allow asynchronous TLB interrupts. */
 #if CHIP_HAS_TILE_DMA()
-	raw_local_irq_unmask(INT_DMATLB_MISS);
-	raw_local_irq_unmask(INT_DMATLB_ACCESS);
+	arch_local_irq_unmask(INT_DMATLB_MISS);
+	arch_local_irq_unmask(INT_DMATLB_ACCESS);
 #endif
 #if CHIP_HAS_SN_PROC()
-	raw_local_irq_unmask(INT_SNITLB_MISS);
+	arch_local_irq_unmask(INT_SNITLB_MISS);
 #endif
 #ifdef __tilegx__
-	raw_local_irq_unmask(INT_SINGLE_STEP_K);
+	arch_local_irq_unmask(INT_SINGLE_STEP_K);
 #endif
 
 	/*
diff --git a/arch/tile/kernel/smp.c b/arch/tile/kernel/smp.c
index 75255d9..9575b37 100644
--- a/arch/tile/kernel/smp.c
+++ b/arch/tile/kernel/smp.c
@@ -115,7 +115,7 @@ static void smp_start_cpu_interrupt(void)
 static void smp_stop_cpu_interrupt(void)
 {
 	set_cpu_online(smp_processor_id(), 0);
-	raw_local_irq_disable_all();
+	arch_local_irq_disable_all();
 	for (;;)
 		asm("nap");
 }
diff --git a/arch/tile/kernel/time.c b/arch/tile/kernel/time.c
index 6bed820..f2e156e 100644
--- a/arch/tile/kernel/time.c
+++ b/arch/tile/kernel/time.c
@@ -132,7 +132,7 @@ static int tile_timer_set_next_event(unsigned long ticks,
 {
 	BUG_ON(ticks > MAX_TICK);
 	__insn_mtspr(SPR_TILE_TIMER_CONTROL, ticks);
-	raw_local_irq_unmask_now(INT_TILE_TIMER);
+	arch_local_irq_unmask_now(INT_TILE_TIMER);
 	return 0;
 }
 
@@ -143,7 +143,7 @@ static int tile_timer_set_next_event(unsigned long ticks,
 static void tile_timer_set_mode(enum clock_event_mode mode,
 				struct clock_event_device *evt)
 {
-	raw_local_irq_mask_now(INT_TILE_TIMER);
+	arch_local_irq_mask_now(INT_TILE_TIMER);
 }
 
 /*
@@ -172,7 +172,7 @@ void __cpuinit setup_tile_timer(void)
 	evt->cpumask = cpumask_of(smp_processor_id());
 
 	/* Start out with timer not firing. */
-	raw_local_irq_mask_now(INT_TILE_TIMER);
+	arch_local_irq_mask_now(INT_TILE_TIMER);
 
 	/* Register tile timer. */
 	clockevents_register_device(evt);
@@ -188,7 +188,7 @@ void do_timer_interrupt(struct pt_regs *regs, int fault_num)
 	 * Mask the timer interrupt here, since we are a oneshot timer
 	 * and there are now by definition no events pending.
 	 */
-	raw_local_irq_mask(INT_TILE_TIMER);
+	arch_local_irq_mask(INT_TILE_TIMER);
 
 	/* Track time spent here in an interrupt context */
 	irq_enter();
-- 
1.6.5.2

