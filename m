Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab1FMJtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 05:49:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54777 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab1FMJtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 05:49:23 -0400
Date: Mon, 13 Jun 2011 11:49:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] x86 fixes
Message-ID: <20110613094917.GA19464@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-urgent-for-linus

 Thanks,

	Ingo

------------------>
Florian Fainelli (1):
      x86: devicetree: Add missing early_init_dt_setup_initrd_arch stub

Thomas Gleixner (1):
      x86: cpu-hotplug: Prevent softirq wakeup on wrong CPU


 arch/x86/kernel/devicetree.c |   11 +++++++++++
 arch/x86/kernel/smpboot.c    |   13 +++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 690bc84..9aeb78a 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <linux/of_pci.h>
+#include <linux/initrd.h>
 
 #include <asm/hpet.h>
 #include <asm/irq_controller.h>
@@ -98,6 +99,16 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 	return __alloc_bootmem(size, align, __pa(MAX_DMA_ADDRESS));
 }
 
+#ifdef CONFIG_BLK_DEV_INITRD
+void __init early_init_dt_setup_initrd_arch(unsigned long start,
+					    unsigned long end)
+{
+	initrd_start = (unsigned long)__va(start);
+	initrd_end = (unsigned long)__va(end);
+	initrd_below_start_ok = 1;
+}
+#endif
+
 void __init add_dtb(u64 data)
 {
 	initial_dtb = data + offsetof(struct setup_data, data);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 33a0c11..9fd3137 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -285,6 +285,19 @@ notrace static void __cpuinit start_secondary(void *unused)
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
 	x86_platform.nmi_init();
 
+	/*
+	 * Wait until the cpu which brought this one up marked it
+	 * online before enabling interrupts. If we don't do that then
+	 * we can end up waking up the softirq thread before this cpu
+	 * reached the active state, which makes the scheduler unhappy
+	 * and schedule the softirq thread on the wrong cpu. This is
+	 * only observable with forced threaded interrupts, but in
+	 * theory it could also happen w/o them. It's just way harder
+	 * to achieve.
+	 */
+	while (!cpumask_test_cpu(smp_processor_id(), cpu_active_mask))
+		cpu_relax();
+
 	/* enable local interrupts */
 	local_irq_enable();
 
