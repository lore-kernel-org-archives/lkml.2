Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab2KLLwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:52:06 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:57574 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab2KLLwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:52:02 -0500
From: <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC Patch v1 48/55] ARC: [plat-arfpga] BVCI Latency Unit setup
Date: Mon, 12 Nov 2012 17:19:06 +0530
Message-ID: <1352720953-24321-18-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/plat-arcfpga/Kconfig    |   32 +++++++++++++++++++++
 arch/arc/plat-arcfpga/platform.c |   56 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/arch/arc/plat-arcfpga/Kconfig b/arch/arc/plat-arcfpga/Kconfig
index 1b65644..6bc1149 100644
--- a/arch/arc/plat-arcfpga/Kconfig
+++ b/arch/arc/plat-arcfpga/Kconfig
@@ -55,4 +55,36 @@ config ARC_SERIAL_LV2
 	depends on ARC_COMPACT_IRQ_LEVELS
 	select ARC_IRQ5_LV2
 
+menuconfig ARC_HAS_BVCI_LAT_UNIT
+	bool "BVCI Bus Latency Unit"
+	depends on ARC_BOARD_ML509 || ARC_BOARD_ANGEL4
+	help
+	  IP to add artifical latency to BVCI Bus Based FPGA builds.
+	  The default latency (even worst case) for FPGA is non-realistic
+	  (~10 SDRAM, ~5 SSRAM).
+
+config BVCI_LAT_UNITS
+	hex "Latency Unit(s) Bitmap"
+	default "0x0"
+	depends on ARC_HAS_BVCI_LAT_UNIT
+	help
+	  There are multiple Latency Units corresponding to the many
+	  interfaces of the system bus arbiter (both CPU side as well as
+	  the peripheral side).
+	  To add latency to ALL memory transaction, choose Unit 0, otherwise
+	  for finer grainer - interface wise latency, specify a bitmap (1 bit
+	  per unit) of all units. e.g. 1,2,12 will be 0x1003
+
+	  Unit  0 - System Arb and Mem Controller
+	  Unit  1 - I$ and System Bus
+	  Unit  2 - D$ and System Bus
+	  ..
+	  Unit 12 - IDE Disk controller and System Bus
+
+config BVCI_LAT_CYCLES
+	int "Latency Value in cycles"
+	range 0 63
+	default "30"
+	depends on ARC_HAS_BVCI_LAT_UNIT
+
 endif
diff --git a/arch/arc/plat-arcfpga/platform.c b/arch/arc/plat-arcfpga/platform.c
index 3243091..d5d4a10 100644
--- a/arch/arc/plat-arcfpga/platform.c
+++ b/arch/arc/plat-arcfpga/platform.c
@@ -17,6 +17,60 @@
 #include <asm/irq.h>
 #include <plat/memmap.h>
 
+/*-----------------------BVCI Latency Unit -----------------------------*/
+
+#ifdef CONFIG_ARC_HAS_BVCI_LAT_UNIT
+
+int lat_cycles = CONFIG_BVCI_LAT_CYCLES;
+
+/* BVCI Bus Profiler: Latency Unit */
+static void __init setup_bvci_lat_unit(void)
+{
+#define MAX_BVCI_UNITS 12
+
+	/* TBD: rewrite this using I/O macros */
+	volatile unsigned int *base = (unsigned int *)BVCI_LAT_UNIT_BASE;
+	volatile unsigned int *lat_unit = (unsigned int *)base + 21;
+	volatile unsigned int *lat_val = (unsigned int *)base + 22;
+	unsigned int unit;
+	const unsigned long units_req = CONFIG_BVCI_LAT_UNITS;
+
+	/*
+	 * There are multiple Latency Units corresponding to the many
+	 * interfaces of the system bus arbiter (both CPU side as well as
+	 * the peripheral side).
+	 *
+	 * Unit  0 - System Arb and Mem Controller - adds latency to all
+	 *	    memory trasactions
+	 * Unit  1 - I$ and System Bus
+	 * Unit  2 - D$ and System Bus
+	 * ..
+	 * Unit 12 - IDE Disk controller and System Bus
+	 *
+	 * The programmers model requires writing to lat_unit reg first
+	 * and then the latency value (cycles) to lat_value reg
+	 */
+
+	if (CONFIG_BVCI_LAT_UNITS == 0) {
+		*lat_unit = 0;
+		*lat_val = lat_cycles;
+		pr_info("BVCI Latency for all Memory Transactions %d cycles\n",
+			lat_cycles);
+	} else {
+		for_each_set_bit(unit, &units_req, MAX_BVCI_UNITS) {
+			*lat_unit = unit + 1;  /* above returns 0 based */
+			*lat_val = lat_cycles;
+			pr_info("BVCI Latency for Unit[%d] = %d cycles\n",
+				(unit + 1), lat_cycles);
+		}
+	}
+}
+#else
+static void __init setup_bvci_lat_unit(void)
+{
+}
+#endif
+
 /*----------------------- Platform Devices -----------------------------*/
 
 #if defined(CONFIG_SERIAL_ARC) || defined(CONFIG_SERIAL_ARC_MODULE)
@@ -111,6 +165,8 @@ void __init arc_platform_early_init(void)
 {
 	pr_info("[plat-arcfpga]: registering early dev resources\n");
 
+	setup_bvci_lat_unit();
+
 	arc_fpga_serial_init();
 }
 
-- 
1.7.4.1

