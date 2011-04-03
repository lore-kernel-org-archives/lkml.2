Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab1DCVBF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 17:01:05 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:52038
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753533Ab1DCVAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 17:00:42 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzc8kzz1202hzz8275bhz2dh95h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
From: John Linn <john.linn@xilinx.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>, <jamie@jamieiles.com>, <arnd@arndb.de>
CC: John Linn <john.linn@xilinx.com>
Subject: [PATCH 2/3] ARM: Xilinx: add SMP specific support files
Date: Sun, 3 Apr 2011 15:00:17 -0600
X-Mailer: git-send-email 1.5.4.7
In-Reply-To: <1301864418-12425-2-git-send-email-john.linn@xilinx.com>
References: <1301864418-12425-1-git-send-email-john.linn@xilinx.com>
 <1301864418-12425-2-git-send-email-john.linn@xilinx.com>
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <5ad00b91-47d8-4f02-aa72-5a413957cdb5@VA3EHSMHS005.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These files are the core processing for SMP which are similar
to most other platforms SMP. The biggest difference is the
way the 2nd CPU is started.

Signed-off-by: John Linn <john.linn@xilinx.com>
---
 arch/arm/mach-xilinx/common.h           |    2 +
 arch/arm/mach-xilinx/headsmp.S          |   59 ++++++++++++
 arch/arm/mach-xilinx/include/mach/smp.h |   30 ++++++
 arch/arm/mach-xilinx/platsmp.c          |  159 +++++++++++++++++++++++++++++++
 4 files changed, 250 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-xilinx/headsmp.S
 create mode 100644 arch/arm/mach-xilinx/include/mach/smp.h
 create mode 100644 arch/arm/mach-xilinx/platsmp.c

diff --git a/arch/arm/mach-xilinx/common.h b/arch/arm/mach-xilinx/common.h
index 71f4ebc..ecd8d65 100644
--- a/arch/arm/mach-xilinx/common.h
+++ b/arch/arm/mach-xilinx/common.h
@@ -25,6 +25,8 @@ void __init xilinx_system_init(void);
 void __init xilinx_irq_init(void);
 void __init xilinx_map_io(void);
 
+void xilinx_secondary_startup(void);
+
 extern struct sys_timer xttcpss_sys_timer;
 
 #endif
diff --git a/arch/arm/mach-xilinx/headsmp.S b/arch/arm/mach-xilinx/headsmp.S
new file mode 100644
index 0000000..bdf9a16
--- /dev/null
+++ b/arch/arm/mach-xilinx/headsmp.S
@@ -0,0 +1,59 @@
+/*
+ * arch/arm/mach-xilinx/headsmp.S
+ *
+ * Secondary CPU startup routine source file.
+ *
+ * Copyright (C) 2011 Xilinx, Inc.
+ *
+ * This file is based on arm omap smp platform file and arm
+ * realview smp platform.
+ *
+ * Copyright (C) 2009 Texas Instruments, Inc.
+ * Copyright (c) 2003 ARM Limited.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/linkage.h>
+#include <linux/init.h>
+#include <mach/xilinx_soc.h>
+#include <mach/io.h>
+
+	__INIT
+
+/*
+ * Xilinx specific entry point for secondary CPU to jump from ROM
+ * code.  This routine provides a wait loop in which secondary core
+ * is held until we're ready for it to initialise. The primary core
+ * will update the boot lock with the boot key when it's ready for
+ * the secondary CPU to boot.
+ *
+ * The WFE must be in the loop when using this code with a probe
+ * because any operations cause debug events which can wake up CPU1
+ * falsely.
+ */
+ENTRY(xilinx_secondary_startup)
+	mov	r0, #0
+	ldr	r1, =(OCM_HIGH_PHYS + BOOT_LOCK_OFFSET)
+	ldr	r0, =BOOT_LOCK_KEY
+	mov	r3, #0
+hold:
+	wfe
+	add	r3, #1			@ only track number of wakeups
+					@ for diagnostics
+	ldr	r2, [r1]
+	cmp	r2, r0
+	bne	hold
+
+	/*
+	 * CPU0 released CPU1 by writing the key to the lock, go ahead
+	 * and start CPU1 running the kernel
+	 */
+	b	secondary_startup
diff --git a/arch/arm/mach-xilinx/include/mach/smp.h b/arch/arm/mach-xilinx/include/mach/smp.h
new file mode 100644
index 0000000..c3aae15
--- /dev/null
+++ b/arch/arm/mach-xilinx/include/mach/smp.h
@@ -0,0 +1,30 @@
+/* arch/arm/mach-xilinx/include/mach/smp.h
+ *
+ * Copyright (C) 2011 Xilinx
+ *
+ * based on arch/arm/mach-realview/include/mach/smp.h
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MACH_SMP_H__
+#define __MACH_SMP_H__
+
+#include <asm/hardware/gic.h>
+
+/*
+ * We use IRQ1 as the IPI
+ */
+static inline void smp_cross_call(const struct cpumask *mask, int ipi)
+{
+	gic_raise_softirq(mask, ipi);
+}
+
+#endif
diff --git a/arch/arm/mach-xilinx/platsmp.c b/arch/arm/mach-xilinx/platsmp.c
new file mode 100644
index 0000000..be2d55c
--- /dev/null
+++ b/arch/arm/mach-xilinx/platsmp.c
@@ -0,0 +1,159 @@
+/*
+ * arch/arm/mach-xilinx/platsmp.c
+ *
+ * This file contains Xilinx specific SMP code, used to start up
+ * the second processor.
+ *
+ * Copyright (C) 2011 Xilinx
+ *
+ * based on linux/arch/arm/mach-realview/platsmp.c
+ *
+ * Copyright (C) 2002 ARM Ltd.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include <linux/jiffies.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <asm/cacheflush.h>
+#include <asm/smp_scu.h>
+#include <mach/xilinx_soc.h>
+#include <mach/smp.h>
+#include "common.h"
+
+static void __iomem *scu_base = SCU_PERIPH_BASE;
+
+static DEFINE_SPINLOCK(boot_lock);
+
+/* Secondary CPU kernel startup is a 2 phase process.
+ * 1st phase is transition from a boot loader to the kernel, but
+ * then wait not starting the kernel yet. 2nd phase starts the
+ * the kernel. In both phases, the secondary CPU waits for an
+ * event before it continues.
+ */
+
+void __cpuinit platform_secondary_init(unsigned int cpu)
+{
+	/*
+	 * if any interrupts are already enabled for the primary
+	 * core (e.g. timer irq), then they will not have been enabled
+	 * for us: do so
+	 */
+	gic_secondary_init(0);
+
+	/*
+	 * Synchronise with the boot thread.
+	 */
+	spin_lock(&boot_lock);
+	spin_unlock(&boot_lock);
+}
+
+int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
+{
+	unsigned long timeout;
+
+	/*
+	 * set synchronisation state between this boot processor
+	 * and the secondary one
+	 */
+	spin_lock(&boot_lock);
+
+	printk(KERN_INFO "Xilinx SMP: booting CPU1 now\n");
+
+	/*
+	 * Update boot lock register with the boot key to allow the
+	 * secondary processor to start the kernel after an SEV.
+	 */
+	__raw_writel(BOOT_LOCK_KEY, OCM_HIGH_BASE + BOOT_LOCK_OFFSET);
+
+	/* Flush the kernel cache to ensure that the page tables are
+	 * available for the secondary CPU to use and make sure that
+	 * the write buffer is drained before doing an SEV.
+	 */
+	flush_cache_all();
+	smp_wmb();
+
+	/*
+	 * Send an event to wake the secondary core from WFE state.
+	 */
+	sev();
+
+	timeout = jiffies + (1 * HZ);
+	while (time_before(jiffies, timeout))
+		;
+
+	/*
+	 * now the secondary core is starting up let it run its
+	 * calibrations, then wait for it to finish
+	 */
+	spin_unlock(&boot_lock);
+
+	return 0;
+}
+
+/*
+ * Initialise the CPU possible map early - this describes the CPUs
+ * which may be present or become present in the system.
+ */
+void __init smp_init_cpus(void)
+{
+	unsigned int i, ncores;
+
+	ncores = scu_base ? scu_get_core_count(scu_base) : 1;
+
+	/* sanity check */
+	if (ncores > NR_CPUS) {
+		printk(KERN_WARNING
+		       "Realview: no. of cores (%d) greater than configured "
+		       "maximum of %d - clipping\n",
+		       ncores, NR_CPUS);
+		ncores = NR_CPUS;
+	}
+
+	for (i = 0; i < ncores; i++)
+		set_cpu_possible(i, true);
+}
+
+void __init platform_smp_prepare_cpus(unsigned int max_cpus)
+{
+	int i;
+
+	/*
+	 * Initialise the present map, which describes the set of CPUs
+	 * actually populated at the present time.
+	 */
+	for (i = 0; i < max_cpus; i++)
+		set_cpu_present(i, true);
+
+	scu_enable(scu_base);
+
+	/* Initialize the boot lock register to prevent CPU1 from
+	   starting the kernel before CPU0 is ready for that.
+	*/
+	__raw_writel(0, OCM_HIGH_BASE + BOOT_LOCK_OFFSET);
+
+	/*
+	 * Write the address of secondary startup routine into the
+	 * boot address. The secondary CPU will use this value
+	 * to get into the kernel after it's awake from WFE state.
+	 *
+	 * Note the physical address is needed as the secondary CPU
+	 * will not have the MMU on yet. A barrier is added to ensure
+	 * that write buffer is drained.
+	 */
+	__raw_writel(virt_to_phys(xilinx_secondary_startup),
+					OCM_HIGH_BASE + BOOT_ADDR_OFFSET);
+	smp_wmb();
+
+	/*
+	 * Send an event to wake the secondary core from WFE state.
+	 */
+	sev();
+}
-- 
1.5.4.7



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


