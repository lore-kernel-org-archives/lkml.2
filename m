Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705Ab1DFRPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 13:15:31 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:52950
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755610Ab1DFRP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 13:15:28 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzc8kzz1202hzz8275bhz2dh95h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
From: John Linn <john.linn@xilinx.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>, <jamie@jamieiles.com>, <arnd@arndb.de>,
        <nicolas.pitre@linaro.org>
CC: John Linn <john.linn@xilinx.com>
Subject: [PATCH V2 3/4] ARM: Xilinx: add SMP specific support files
Date: Wed, 6 Apr 2011 11:15:09 -0600
X-Mailer: git-send-email 1.5.4.7
In-Reply-To: <1302110110-32208-3-git-send-email-john.linn@xilinx.com>
References: <1302110110-32208-1-git-send-email-john.linn@xilinx.com>
 <1302110110-32208-2-git-send-email-john.linn@xilinx.com>
 <1302110110-32208-3-git-send-email-john.linn@xilinx.com>
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <fc7b42da-f233-48a5-8662-0239be3c72ef@VA3EHSMHS017.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These files are the core processing for SMP which are similar
to most other platforms SMP. The biggest difference is the
way the 2nd CPU is started.

Signed-off-by: John Linn <john.linn@xilinx.com>
---

V2 Changes

Minor cleanup for the change from mach-xilinx to mach-zynq. 

Quite a few changes to the SMP boot process based on input from Russell and 
Catalin.  Maybe I have oversimplifed it too much, but testing has shown it 
to work reliably and it's nice and clean (to me anyway).

 arch/arm/mach-zynq/common.h           |    2 +
 arch/arm/mach-zynq/include/mach/smp.h |   30 ++++++++
 arch/arm/mach-zynq/platsmp.c          |  128 +++++++++++++++++++++++++++++++++
 3 files changed, 160 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-zynq/include/mach/smp.h
 create mode 100644 arch/arm/mach-zynq/platsmp.c

diff --git a/arch/arm/mach-zynq/common.h b/arch/arm/mach-zynq/common.h
index a87bedc..c6c92d0 100644
--- a/arch/arm/mach-zynq/common.h
+++ b/arch/arm/mach-zynq/common.h
@@ -25,6 +25,8 @@ void __init xilinx_system_init(void);
 void __init xilinx_irq_init(void);
 void __init xilinx_map_io(void);
 
+void secondary_startup(void);
+
 extern struct sys_timer xttcpss_sys_timer;
 
 #endif
diff --git a/arch/arm/mach-zynq/include/mach/smp.h b/arch/arm/mach-zynq/include/mach/smp.h
new file mode 100644
index 0000000..c3aae15
--- /dev/null
+++ b/arch/arm/mach-zynq/include/mach/smp.h
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
diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.c
new file mode 100644
index 0000000..96367b0
--- /dev/null
+++ b/arch/arm/mach-zynq/platsmp.c
@@ -0,0 +1,128 @@
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
+#include <mach/zynq_soc.h>
+#include <mach/smp.h>
+#include "common.h"
+
+static DEFINE_SPINLOCK(boot_lock);
+
+/* Secondary CPU kernel startup is a 2 step process. The primary CPU
+ * starts the secondary CPU by giving it the address of the kernel and
+ * then sending it an event to wake it up. The secondary CPU then
+ * starts the kernel and tells the primary CPU it's up and running.
+ */
+void __cpuinit platform_secondary_init(unsigned int cpu)
+{
+	/*
+	 * if any interrupts are already enabled for the primary
+	 * core (e.g. timer irq), then they will not have been enabled
+	 * for us: do so
+	 */
+	gic_secondary_init(0);
+
+	/* Indicate to the primary core that the secondary is up and running.
+	 * Let the write buffer drain.
+	 */
+	__raw_writel(BOOT_STATUS_CPU1_UP, OCM_HIGH_BASE + BOOT_STATUS_OFFSET);
+	wmb();
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
+	/* Initialize the boot status and give the secondary core
+	 * the start address of the kernel, let the write buffer drain
+	 */
+	__raw_writel(0, OCM_HIGH_BASE + BOOT_STATUS_OFFSET);
+
+	__raw_writel(virt_to_phys(secondary_startup),
+					OCM_HIGH_BASE + BOOT_ADDR_OFFSET);
+	wmb();
+
+	/*
+	 * Send an event to wake the secondary core from WFE state.
+	 */
+	sev();
+
+	/*
+	 * Wait for the other CPU to boot, but timeout if it doesn't
+	 */
+	timeout = jiffies + (1 * HZ);
+	while ((__raw_readl(OCM_HIGH_BASE + BOOT_STATUS_OFFSET) !=
+				BOOT_STATUS_CPU1_UP) &&
+				(time_before(jiffies, timeout)))
+		rmb();
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
+	int i, ncores;
+
+	ncores = scu_get_core_count(SCU_PERIPH_BASE);
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
+	scu_enable(SCU_PERIPH_BASE);
+}
-- 
1.5.4.7



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


