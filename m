Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab1DCVAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 17:00:36 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:16175
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753415Ab1DCVAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 17:00:35 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzc8kzz1202hzz8275bhz2dh95h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
From: John Linn <john.linn@xilinx.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>, <jamie@jamieiles.com>, <arnd@arndb.de>
CC: John Linn <john.linn@xilinx.com>
Subject: [PATCH 1/3] ARM: Xilinx: add timer and on chip memory support for SMP
Date: Sun, 3 Apr 2011 15:00:16 -0600
X-Mailer: git-send-email 1.5.4.7
In-Reply-To: <1301864418-12425-1-git-send-email-john.linn@xilinx.com>
References: <1301864418-12425-1-git-send-email-john.linn@xilinx.com>
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <548833b1-f72d-4ede-8c67-07bb930f9c9c@VA3EHSMHS009.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes are required to support SMP.

This includes an update so that the non-local timer is set
to run on the 1st CPU, the addition of local timer support
and support for on chip memory.

Signed-off-by: John Linn <john.linn@xilinx.com>
---
 arch/arm/mach-xilinx/common.c                  |   16 ++++++++++-
 arch/arm/mach-xilinx/include/mach/irqs.h       |    1 +
 arch/arm/mach-xilinx/include/mach/xilinx_soc.h |   20 +++++++++++++
 arch/arm/mach-xilinx/localtimer.c              |   36 ++++++++++++++++++++++++
 arch/arm/mach-xilinx/timer.c                   |    4 +-
 5 files changed, 74 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/mach-xilinx/localtimer.c

diff --git a/arch/arm/mach-xilinx/common.c b/arch/arm/mach-xilinx/common.c
index 83b549d..2695b39 100644
--- a/arch/arm/mach-xilinx/common.c
+++ b/arch/arm/mach-xilinx/common.c
@@ -101,7 +101,21 @@ static struct map_desc io_desc[] __initdata = {
 		.type		= MT_DEVICE,
 	},
 #endif
-
+	/* create a mapping for the OCM  (256K) leaving a hole for the
+	 * interrupt vectors which are handled in the kernel
+	 */
+	{
+		.virtual	= OCM_LOW_VIRT,
+		.pfn		= __phys_to_pfn(OCM_LOW_PHYS),
+		.length		= (192 * SZ_1K),
+		.type		= MT_DEVICE_CACHED,
+	},
+	{
+		.virtual	= OCM_HIGH_VIRT,
+		.pfn		= __phys_to_pfn(OCM_HIGH_PHYS),
+		.length		= (60 * SZ_1K),
+		.type		= MT_DEVICE,
+	},
 };
 
 /**
diff --git a/arch/arm/mach-xilinx/include/mach/irqs.h b/arch/arm/mach-xilinx/include/mach/irqs.h
index 47a8162..8c41b22 100644
--- a/arch/arm/mach-xilinx/include/mach/irqs.h
+++ b/arch/arm/mach-xilinx/include/mach/irqs.h
@@ -22,6 +22,7 @@
  * GIC Interrupts
  */
 
+#define IRQ_SCU_CPU_TIMER	29
 #define IRQ_GIC_SPI_START	32
 #define IRQ_TIMERCOUNTER0	42
 #define IRQ_UART0		59
diff --git a/arch/arm/mach-xilinx/include/mach/xilinx_soc.h b/arch/arm/mach-xilinx/include/mach/xilinx_soc.h
index d181c5c..a55a46c 100644
--- a/arch/arm/mach-xilinx/include/mach/xilinx_soc.h
+++ b/arch/arm/mach-xilinx/include/mach/xilinx_soc.h
@@ -31,13 +31,33 @@
 #define SCU_PERIPH_PHYS			0xF8F00000
 #define SCU_PERIPH_VIRT			SCU_PERIPH_PHYS
 
+#define OCM_LOW_PHYS			0xFFFC0000
+#define OCM_LOW_VIRT			OCM_LOW_PHYS
+
+#define OCM_HIGH_PHYS			0xFFFF1000
+#define OCM_HIGH_VIRT			OCM_HIGH_PHYS
+
 /* The following are intended for the devices that are mapped early */
 
 #define TTC0_BASE			IOMEM(TTC0_VIRT)
 #define SCU_PERIPH_BASE			IOMEM(SCU_PERIPH_VIRT)
 #define SCU_GIC_CPU_BASE		(SCU_PERIPH_BASE + 0x100)
+#define SCU_CPU_TIMER_BASE		(SCU_PERIPH_BASE + 0x600)
 #define SCU_GIC_DIST_BASE		(SCU_PERIPH_BASE + 0x1000)
 #define PL310_L2CC_BASE			IOMEM(PL310_L2CC_VIRT)
+#define OCM_LOW_BASE			IOMEM(OCM_LOW_VIRT)
+#define OCM_HIGH_BASE			IOMEM(OCM_HIGH_VIRT)
+
+/* There are a couple ram addresses needed for communication between the boot
+ * loader software and the linux kernel with multiple cpus in the kernel (SMP).
+ * The memory addresses are in the high on-chip RAM and these addresses are
+ * mapped flat (virtual = physical). The memory must be mapped early and
+ * non-cached.
+ */
+
+#define BOOT_ADDR_OFFSET	0xEFF0
+#define BOOT_LOCK_OFFSET	0xEFF4
+#define BOOT_LOCK_KEY		0xFACECAFE
 
 /*
  * Mandatory for CONFIG_LL_DEBUG, UART is mapped virtual = physical
diff --git a/arch/arm/mach-xilinx/localtimer.c b/arch/arm/mach-xilinx/localtimer.c
new file mode 100644
index 0000000..4bd0a0d
--- /dev/null
+++ b/arch/arm/mach-xilinx/localtimer.c
@@ -0,0 +1,36 @@
+/*
+ * arch/arm/mach-xilinx/localtimer.c
+ *
+ * Both cortex-a9 cores have their own timer in it's CPU domain.
+ *
+ * Copyright (C) 2011 Xilinx, Inc.
+ *
+ * This file is based on arch/arm/plat-versatile/localtimer.c
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
+#include <linux/init.h>
+#include <asm/smp_twd.h>
+#include <mach/xilinx_soc.h>
+
+/*
+ * Setup the local clock events for a CPU.
+ */
+int __cpuinit local_timer_setup(struct clock_event_device *evt)
+{
+	twd_base = SCU_CPU_TIMER_BASE;
+
+	evt->irq = IRQ_SCU_CPU_TIMER;
+	twd_timer_setup(evt);
+	return 0;
+}
+
diff --git a/arch/arm/mach-xilinx/timer.c b/arch/arm/mach-xilinx/timer.c
index b2a72f0..65c336a 100644
--- a/arch/arm/mach-xilinx/timer.c
+++ b/arch/arm/mach-xilinx/timer.c
@@ -283,9 +283,9 @@ static void __init xttcpss_timer_init(void)
 	xttcpss_clockevent.min_delta_ns =
 		clockevent_delta2ns(1, &xttcpss_clockevent);
 
-	/* Indicate that clock event can be used on any of the CPUs */
+	/* Indicate that clock event is on 1st CPU as SMP boot needs it */
 
-	xttcpss_clockevent.cpumask = cpu_all_mask;
+	xttcpss_clockevent.cpumask = cpumask_of(0);
 	clockevents_register_device(&xttcpss_clockevent);
 }
 
-- 
1.5.4.7



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


