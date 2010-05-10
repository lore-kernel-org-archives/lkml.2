Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab0EJL0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 07:26:43 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:35893 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915Ab0EJL0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 07:26:39 -0400
X-Greylist: delayed 3092 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 May 2010 07:26:39 EDT
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: avictor.za@gmail.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] AT91: PM: dual ram controller support
Date: Mon, 10 May 2010 13:51:27 +0200
Message-Id: <1273492287-7647-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This rework allows to address tow memory controllers. AT91SAM9263 and
AT91SAM9G45 family have tow SDRAM or DDR/SDRAM controllers. Power management
should take care of this.
This patch modify the way RAM IP header files are implemented to allow
access to registers of both controllers ; it also adds some macros.

We also modify the power management files to use those modified header files.
Slow clock (assembly) and regular power management functions are synchronized
for setting of RAM self-refresh procedure: 
(lpr & ~AT91_DDRSDRC_LPCB) | AT91_DDRSDRC_LPCB_SELF_REFRESH

Note that AT91RM9200 is not impacted by this modification.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
AT91SAM9263 configuration has been kept: no management of RAM connected to
second EBI. On the contrary, on AT91SAM9G45, both controllers are taken into
account because it is the default behavior of initialization code found in
AT91Bootstrap.

 arch/arm/mach-at91/include/mach/at91cap9.h        |    2 +-
 arch/arm/mach-at91/include/mach/at91cap9_ddrsdr.h |   22 +++--
 arch/arm/mach-at91/include/mach/at91sam9260.h     |    2 +-
 arch/arm/mach-at91/include/mach/at91sam9261.h     |    2 +-
 arch/arm/mach-at91/include/mach/at91sam9_ddrsdr.h |  130 +++++++++++++++++++++
 arch/arm/mach-at91/include/mach/at91sam9_sdramc.h |   23 +++--
 arch/arm/mach-at91/include/mach/at91sam9rl.h      |    2 +-
 arch/arm/mach-at91/pm.h                           |   49 +++++++-
 arch/arm/mach-at91/pm_slowclock.S                 |   74 +++++++++---
 9 files changed, 258 insertions(+), 48 deletions(-)
 create mode 100644 arch/arm/mach-at91/include/mach/at91sam9_ddrsdr.h

diff --git a/arch/arm/mach-at91/include/mach/at91cap9.h b/arch/arm/mach-at91/include/mach/at91cap9.h
index d8c1ede..9c6af97 100644
--- a/arch/arm/mach-at91/include/mach/at91cap9.h
+++ b/arch/arm/mach-at91/include/mach/at91cap9.h
@@ -84,7 +84,7 @@
  */
 #define AT91_ECC	(0xffffe200 - AT91_BASE_SYS)
 #define AT91_BCRAMC	(0xffffe400 - AT91_BASE_SYS)
-#define AT91_DDRSDRC	(0xffffe600 - AT91_BASE_SYS)
+#define AT91_DDRSDRC0	(0xffffe600 - AT91_BASE_SYS)
 #define AT91_SMC	(0xffffe800 - AT91_BASE_SYS)
 #define AT91_MATRIX	(0xffffea00 - AT91_BASE_SYS)
 #define AT91_CCFG	(0xffffeb10 - AT91_BASE_SYS)
diff --git a/arch/arm/mach-at91/include/mach/at91cap9_ddrsdr.h b/arch/arm/mach-at91/include/mach/at91cap9_ddrsdr.h
index 1499b1c..976f4a6 100644
--- a/arch/arm/mach-at91/include/mach/at91cap9_ddrsdr.h
+++ b/arch/arm/mach-at91/include/mach/at91cap9_ddrsdr.h
@@ -15,7 +15,7 @@
 #ifndef AT91CAP9_DDRSDR_H
 #define AT91CAP9_DDRSDR_H
 
-#define AT91_DDRSDRC_MR		(AT91_DDRSDRC + 0x00)	/* Mode Register */
+#define AT91_DDRSDRC_MR		0x00	/* Mode Register */
 #define		AT91_DDRSDRC_MODE	(0xf << 0)		/* Command Mode */
 #define			AT91_DDRSDRC_MODE_NORMAL		0
 #define			AT91_DDRSDRC_MODE_NOP		1
@@ -25,10 +25,10 @@
 #define			AT91_DDRSDRC_MODE_EXT_LMR	5
 #define			AT91_DDRSDRC_MODE_DEEP		6
 
-#define AT91_DDRSDRC_RTR	(AT91_DDRSDRC + 0x04)	/* Refresh Timer Register */
+#define AT91_DDRSDRC_RTR	0x04	/* Refresh Timer Register */
 #define		AT91_DDRSDRC_COUNT	(0xfff << 0)		/* Refresh Timer Counter */
 
-#define AT91_DDRSDRC_CR		(AT91_DDRSDRC + 0x08)	/* Configuration Register */
+#define AT91_DDRSDRC_CR		0x08	/* Configuration Register */
 #define		AT91_DDRSDRC_NC		(3 << 0)		/* Number of Column Bits */
 #define			AT91_DDRSDRC_NC_SDR8	(0 << 0)
 #define			AT91_DDRSDRC_NC_SDR9	(1 << 0)
@@ -49,7 +49,7 @@
 #define		AT91_DDRSDRC_DLL	(1 << 7)		/* Reset DLL */
 #define		AT91_DDRSDRC_DICDS	(1 << 8)		/* Output impedance control */
 
-#define AT91_DDRSDRC_T0PR	(AT91_DDRSDRC + 0x0C)	/* Timing 0 Register */
+#define AT91_DDRSDRC_T0PR	0x0C	/* Timing 0 Register */
 #define		AT91_DDRSDRC_TRAS	(0xf <<  0)		/* Active to Precharge delay */
 #define		AT91_DDRSDRC_TRCD	(0xf <<  4)		/* Row to Column delay */
 #define		AT91_DDRSDRC_TWR	(0xf <<  8)		/* Write recovery delay */
@@ -59,13 +59,13 @@
 #define		AT91_DDRSDRC_TWTR	(1   << 24)		/* Internal Write to Read delay */
 #define		AT91_DDRSDRC_TMRD	(0xf << 28)		/* Load mode to active/refresh delay */
 
-#define AT91_DDRSDRC_T1PR	(AT91_DDRSDRC + 0x10)	/* Timing 1 Register */
+#define AT91_DDRSDRC_T1PR	0x10	/* Timing 1 Register */
 #define		AT91_DDRSDRC_TRFC	(0x1f << 0)		/* Row Cycle Delay */
 #define		AT91_DDRSDRC_TXSNR	(0xff << 8)		/* Exit self-refresh to non-read */
 #define		AT91_DDRSDRC_TXSRD	(0xff << 16)		/* Exit self-refresh to read */
 #define		AT91_DDRSDRC_TXP	(0xf  << 24)		/* Exit power-down delay */
 
-#define AT91_DDRSDRC_LPR	(AT91_DDRSDRC + 0x18)	/* Low Power Register */
+#define AT91_DDRSDRC_LPR	0x18	/* Low Power Register */
 #define		AT91_DDRSDRC_LPCB		(3 << 0)	/* Low-power Configurations */
 #define			AT91_DDRSDRC_LPCB_DISABLE		0
 #define			AT91_DDRSDRC_LPCB_SELF_REFRESH		1
@@ -80,14 +80,14 @@
 #define			AT91_DDRSDRC_TIMEOUT_64_CLK_CYCLES	(1 << 12)
 #define			AT91_DDRSDRC_TIMEOUT_128_CLK_CYCLES	(2 << 12)
 
-#define AT91_DDRSDRC_MDR	(AT91_DDRSDRC + 0x1C)	/* Memory Device Register */
+#define AT91_DDRSDRC_MDR	0x1C	/* Memory Device Register */
 #define		AT91_DDRSDRC_MD		(3 << 0)		/* Memory Device Type */
 #define			AT91_DDRSDRC_MD_SDR		0
 #define			AT91_DDRSDRC_MD_LOW_POWER_SDR	1
 #define			AT91_DDRSDRC_MD_DDR		2
 #define			AT91_DDRSDRC_MD_LOW_POWER_DDR	3
 
-#define AT91_DDRSDRC_DLLR	(AT91_DDRSDRC + 0x20)	/* DLL Information Register */
+#define AT91_DDRSDRC_DLLR	0x20	/* DLL Information Register */
 #define		AT91_DDRSDRC_MDINC	(1 << 0)		/* Master Delay increment */
 #define		AT91_DDRSDRC_MDDEC	(1 << 1)		/* Master Delay decrement */
 #define		AT91_DDRSDRC_MDOVF	(1 << 2)		/* Master Delay Overflow */
@@ -98,5 +98,11 @@
 #define		AT91_DDRSDRC_SDVAL	(0xff << 16)		/* Slave Delay value */
 #define		AT91_DDRSDRC_SDCVAL	(0xff << 24)		/* Slave Delay Correction value */
 
+/* Register access macros */
+#define at91_ramc_read(num, reg) \
+	at91_sys_read(AT91_DDRSDRC##num + reg)
+#define at91_ramc_write(num, reg, value) \
+	at91_sys_write(AT91_DDRSDRC##num + reg, value)
+
 
 #endif
diff --git a/arch/arm/mach-at91/include/mach/at91sam9260.h b/arch/arm/mach-at91/include/mach/at91sam9260.h
index 43c396b..4e79036 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9260.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9260.h
@@ -84,7 +84,7 @@
  * System Peripherals (offset from AT91_BASE_SYS)
  */
 #define AT91_ECC	(0xffffe800 - AT91_BASE_SYS)
-#define AT91_SDRAMC	(0xffffea00 - AT91_BASE_SYS)
+#define AT91_SDRAMC0	(0xffffea00 - AT91_BASE_SYS)
 #define AT91_SMC	(0xffffec00 - AT91_BASE_SYS)
 #define AT91_MATRIX	(0xffffee00 - AT91_BASE_SYS)
 #define AT91_CCFG	(0xffffef10 - AT91_BASE_SYS)
diff --git a/arch/arm/mach-at91/include/mach/at91sam9261.h b/arch/arm/mach-at91/include/mach/at91sam9261.h
index 87de8be..2b56185 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9261.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9261.h
@@ -68,7 +68,7 @@
 /*
  * System Peripherals (offset from AT91_BASE_SYS)
  */
-#define AT91_SDRAMC	(0xffffea00 - AT91_BASE_SYS)
+#define AT91_SDRAMC0	(0xffffea00 - AT91_BASE_SYS)
 #define AT91_SMC	(0xffffec00 - AT91_BASE_SYS)
 #define AT91_MATRIX	(0xffffee00 - AT91_BASE_SYS)
 #define AT91_AIC	(0xfffff000 - AT91_BASE_SYS)
diff --git a/arch/arm/mach-at91/include/mach/at91sam9_ddrsdr.h b/arch/arm/mach-at91/include/mach/at91sam9_ddrsdr.h
new file mode 100644
index 0000000..d27b15b
--- /dev/null
+++ b/arch/arm/mach-at91/include/mach/at91sam9_ddrsdr.h
@@ -0,0 +1,130 @@
+/*
+ * Header file for the Atmel DDR/SDR SDRAM Controller
+ *
+ * Copyright (C) 2010 Atmel Corporation
+ *	Nicolas Ferre <nicolas.ferre@atmel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef AT91SAM9_DDRSDR_H
+#define AT91SAM9_DDRSDR_H
+
+#define AT91_DDRSDRC_MR		0x00	/* Mode Register */
+#define		AT91_DDRSDRC_MODE	(0x7 << 0)		/* Command Mode */
+#define			AT91_DDRSDRC_MODE_NORMAL	0
+#define			AT91_DDRSDRC_MODE_NOP		1
+#define			AT91_DDRSDRC_MODE_PRECHARGE	2
+#define			AT91_DDRSDRC_MODE_LMR		3
+#define			AT91_DDRSDRC_MODE_REFRESH	4
+#define			AT91_DDRSDRC_MODE_EXT_LMR	5
+#define			AT91_DDRSDRC_MODE_DEEP		6
+
+#define AT91_DDRSDRC_RTR	0x04	/* Refresh Timer Register */
+#define		AT91_DDRSDRC_COUNT	(0xfff << 0)		/* Refresh Timer Counter */
+
+#define AT91_DDRSDRC_CR		0x08	/* Configuration Register */
+#define		AT91_DDRSDRC_NC		(3 << 0)		/* Number of Column Bits */
+#define			AT91_DDRSDRC_NC_SDR8	(0 << 0)
+#define			AT91_DDRSDRC_NC_SDR9	(1 << 0)
+#define			AT91_DDRSDRC_NC_SDR10	(2 << 0)
+#define			AT91_DDRSDRC_NC_SDR11	(3 << 0)
+#define			AT91_DDRSDRC_NC_DDR9	(0 << 0)
+#define			AT91_DDRSDRC_NC_DDR10	(1 << 0)
+#define			AT91_DDRSDRC_NC_DDR11	(2 << 0)
+#define			AT91_DDRSDRC_NC_DDR12	(3 << 0)
+#define		AT91_DDRSDRC_NR		(3 << 2)		/* Number of Row Bits */
+#define			AT91_DDRSDRC_NR_11	(0 << 2)
+#define			AT91_DDRSDRC_NR_12	(1 << 2)
+#define			AT91_DDRSDRC_NR_13	(2 << 2)
+#define			AT91_DDRSDRC_NR_14	(3 << 2)
+#define		AT91_DDRSDRC_CAS	(7 << 4)		/* CAS Latency */
+#define			AT91_DDRSDRC_CAS_2	(2 << 4)
+#define			AT91_DDRSDRC_CAS_3	(3 << 4)
+#define			AT91_DDRSDRC_CAS_25	(6 << 4)
+#define		AT91_DDRSDRC_RST_DLL	(1 << 7)		/* Reset DLL */
+#define		AT91_DDRSDRC_DICDS	(1 << 8)		/* Output impedance control */
+#define		AT91_DDRSDRC_DIS_DLL	(1 << 9)		/* Disable DLL */
+#define		AT91_DDRSDRC_OCD	(1 << 12)		/* Off-Chip Driver */
+#define		AT91_DDRSDRC_DQMS	(1 << 16)		/* Mask Data is Shared */
+#define		AT91_DDRSDRC_ACTBST	(1 << 18)		/* Active Bank X to Burst Stop Read Access Bank Y */
+
+#define AT91_DDRSDRC_T0PR	0x0C	/* Timing 0 Register */
+#define		AT91_DDRSDRC_TRAS	(0xf <<  0)		/* Active to Precharge delay */
+#define		AT91_DDRSDRC_TRCD	(0xf <<  4)		/* Row to Column delay */
+#define		AT91_DDRSDRC_TWR	(0xf <<  8)		/* Write recovery delay */
+#define		AT91_DDRSDRC_TRC	(0xf << 12)		/* Row cycle delay */
+#define		AT91_DDRSDRC_TRP	(0xf << 16)		/* Row precharge delay */
+#define		AT91_DDRSDRC_TRRD	(0xf << 20)		/* Active BankA to BankB */
+#define		AT91_DDRSDRC_TWTR	(0x7 << 24)		/* Internal Write to Read delay */
+#define		AT91_DDRSDRC_RED_WRRD	(0x1 << 27)		/* Reduce Write to Read Delay */
+#define		AT91_DDRSDRC_TMRD	(0xf << 28)		/* Load mode to active/refresh delay */
+
+#define AT91_DDRSDRC_T1PR	0x10	/* Timing 1 Register */
+#define		AT91_DDRSDRC_TRFC	(0x1f << 0)		/* Row Cycle Delay */
+#define		AT91_DDRSDRC_TXSNR	(0xff << 8)		/* Exit self-refresh to non-read */
+#define		AT91_DDRSDRC_TXSRD	(0xff << 16)		/* Exit self-refresh to read */
+#define		AT91_DDRSDRC_TXP	(0xf  << 24)		/* Exit power-down delay */
+
+#define AT91_DDRSDRC_T2PR	0x14	/* Timing 2 Register */
+#define		AT91_DDRSDRC_TXARD	(0xf  << 0)		/* Exit active power down delay to read command in mode "Fast Exit" */
+#define		AT91_DDRSDRC_TXARDS	(0xf  << 4)		/* Exit active power down delay to read command in mode "Slow Exit" */
+#define		AT91_DDRSDRC_TRPA	(0xf  << 8)		/* Row Precharge All delay */
+#define		AT91_DDRSDRC_TRTP	(0x7  << 12)		/* Read to Precharge delay */
+
+#define AT91_DDRSDRC_LPR	0x1C	/* Low Power Register */
+#define		AT91_DDRSDRC_LPCB	(3 << 0)		/* Low-power Configurations */
+#define			AT91_DDRSDRC_LPCB_DISABLE		0
+#define			AT91_DDRSDRC_LPCB_SELF_REFRESH		1
+#define			AT91_DDRSDRC_LPCB_POWER_DOWN		2
+#define			AT91_DDRSDRC_LPCB_DEEP_POWER_DOWN	3
+#define		AT91_DDRSDRC_CLKFR	(1 << 2)	/* Clock Frozen */
+#define		AT91_DDRSDRC_PASR	(7 << 4)	/* Partial Array Self Refresh */
+#define		AT91_DDRSDRC_TCSR	(3 << 8)	/* Temperature Compensated Self Refresh */
+#define		AT91_DDRSDRC_DS		(3 << 10)	/* Drive Strength */
+#define		AT91_DDRSDRC_TIMEOUT	(3 << 12)	/* Time to define when Low Power Mode is enabled */
+#define			AT91_DDRSDRC_TIMEOUT_0_CLK_CYCLES	(0 << 12)
+#define			AT91_DDRSDRC_TIMEOUT_64_CLK_CYCLES	(1 << 12)
+#define			AT91_DDRSDRC_TIMEOUT_128_CLK_CYCLES	(2 << 12)
+#define		AT91_DDRSDRC_APDE	(1 << 16)	 /* Active power down exit time */
+#define		AT91_DDRSDRC_UPD_MR	(3 << 20)	 /* Update load mode register and extended mode register */
+
+#define AT91_DDRSDRC_MDR	0x20	/* Memory Device Register */
+#define		AT91_DDRSDRC_MD		(3 << 0)		/* Memory Device Type */
+#define			AT91_DDRSDRC_MD_SDR		0
+#define			AT91_DDRSDRC_MD_LOW_POWER_SDR	1
+#define			AT91_DDRSDRC_MD_LOW_POWER_DDR	3
+#define			AT91_DDRSDRC_MD_DDR2		6
+#define		AT91_DDRSDRC_DBW	(1 << 4)		/* Data Bus Width */
+#define			AT91_DDRSDRC_DBW_32BITS		(0 <<  4)
+#define			AT91_DDRSDRC_DBW_16BITS		(1 <<  4)
+
+#define AT91_DDRSDRC_DLL	0x24	/* DLL Information Register */
+#define		AT91_DDRSDRC_MDINC	(1 << 0)		/* Master Delay increment */
+#define		AT91_DDRSDRC_MDDEC	(1 << 1)		/* Master Delay decrement */
+#define		AT91_DDRSDRC_MDOVF	(1 << 2)		/* Master Delay Overflow */
+#define		AT91_DDRSDRC_MDVAL	(0xff <<  8)		/* Master Delay value */
+
+#define AT91_DDRSDRC_HS		0x2C	/* High Speed Register */
+#define		AT91_DDRSDRC_DIS_ATCP_RD	(1 << 2)	/* Anticip read access is disabled */
+
+#define AT91_DDRSDRC_DELAY(n)	(0x30 + (0x4 * (n)))	/* Delay I/O Register n */
+
+#define AT91_DDRSDRC_WPMR	0xE4	/* Write Protect Mode Register */
+#define		AT91_DDRSDRC_WP		(1 << 0)		/* Write protect enable */
+#define		AT91_DDRSDRC_WPKEY	(0xffffff << 8)		/* Write protect key */
+#define		AT91_DDRSDRC_KEY	(0x444452 << 8)		/* Write protect key = "DDR" */
+
+#define AT91_DDRSDRC_WPSR	0xE8	/* Write Protect Status Register */
+#define		AT91_DDRSDRC_WPVS	(1 << 0)		/* Write protect violation status */
+#define		AT91_DDRSDRC_WPVSRC	(0xffff << 8)		/* Write protect violation source */
+
+/* Register access macros */
+#define at91_ramc_read(num, reg) \
+	at91_sys_read(AT91_DDRSDRC##num + reg)
+#define at91_ramc_write(num, reg, value) \
+	at91_sys_write(AT91_DDRSDRC##num + reg, value)
+
+#endif
diff --git a/arch/arm/mach-at91/include/mach/at91sam9_sdramc.h b/arch/arm/mach-at91/include/mach/at91sam9_sdramc.h
index b726038..100f5a5 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9_sdramc.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9_sdramc.h
@@ -17,7 +17,7 @@
 #define AT91SAM9_SDRAMC_H
 
 /* SDRAM Controller (SDRAMC) registers */
-#define AT91_SDRAMC_MR		(AT91_SDRAMC + 0x00)	/* SDRAM Controller Mode Register */
+#define AT91_SDRAMC_MR		0x00	/* SDRAM Controller Mode Register */
 #define		AT91_SDRAMC_MODE	(0xf << 0)		/* Command Mode */
 #define			AT91_SDRAMC_MODE_NORMAL		0
 #define			AT91_SDRAMC_MODE_NOP		1
@@ -27,10 +27,10 @@
 #define			AT91_SDRAMC_MODE_EXT_LMR	5
 #define			AT91_SDRAMC_MODE_DEEP		6
 
-#define AT91_SDRAMC_TR		(AT91_SDRAMC + 0x04)	/* SDRAM Controller Refresh Timer Register */
+#define AT91_SDRAMC_TR		0x04	/* SDRAM Controller Refresh Timer Register */
 #define		AT91_SDRAMC_COUNT	(0xfff << 0)		/* Refresh Timer Counter */
 
-#define AT91_SDRAMC_CR		(AT91_SDRAMC + 0x08)	/* SDRAM Controller Configuration Register */
+#define AT91_SDRAMC_CR		0x08	/* SDRAM Controller Configuration Register */
 #define		AT91_SDRAMC_NC		(3 << 0)		/* Number of Column Bits */
 #define			AT91_SDRAMC_NC_8	(0 << 0)
 #define			AT91_SDRAMC_NC_9	(1 << 0)
@@ -57,7 +57,7 @@
 #define		AT91_SDRAMC_TRAS	(0xf << 24)		/* Active to Precharge Delay */
 #define		AT91_SDRAMC_TXSR	(0xf << 28)		/* Exit Self Refresh to Active Delay */
 
-#define AT91_SDRAMC_LPR		(AT91_SDRAMC + 0x10)	/* SDRAM Controller Low Power Register */
+#define AT91_SDRAMC_LPR		0x10	/* SDRAM Controller Low Power Register */
 #define		AT91_SDRAMC_LPCB		(3 << 0)	/* Low-power Configurations */
 #define			AT91_SDRAMC_LPCB_DISABLE		0
 #define			AT91_SDRAMC_LPCB_SELF_REFRESH		1
@@ -71,16 +71,21 @@
 #define			AT91_SDRAMC_TIMEOUT_64_CLK_CYCLES	(1 << 12)
 #define			AT91_SDRAMC_TIMEOUT_128_CLK_CYCLES	(2 << 12)
 
-#define AT91_SDRAMC_IER		(AT91_SDRAMC + 0x14)	/* SDRAM Controller Interrupt Enable Register */
-#define AT91_SDRAMC_IDR		(AT91_SDRAMC + 0x18)	/* SDRAM Controller Interrupt Disable Register */
-#define AT91_SDRAMC_IMR		(AT91_SDRAMC + 0x1C)	/* SDRAM Controller Interrupt Mask Register */
-#define AT91_SDRAMC_ISR		(AT91_SDRAMC + 0x20)	/* SDRAM Controller Interrupt Status Register */
+#define AT91_SDRAMC_IER		0x14	/* SDRAM Controller Interrupt Enable Register */
+#define AT91_SDRAMC_IDR		0x18	/* SDRAM Controller Interrupt Disable Register */
+#define AT91_SDRAMC_IMR		0x1C	/* SDRAM Controller Interrupt Mask Register */
+#define AT91_SDRAMC_ISR		0x20	/* SDRAM Controller Interrupt Status Register */
 #define		AT91_SDRAMC_RES		(1 << 0)		/* Refresh Error Status */
 
-#define AT91_SDRAMC_MDR		(AT91_SDRAMC + 0x24)	/* SDRAM Memory Device Register */
+#define AT91_SDRAMC_MDR		0x24	/* SDRAM Memory Device Register */
 #define		AT91_SDRAMC_MD		(3 << 0)		/* Memory Device Type */
 #define			AT91_SDRAMC_MD_SDRAM		0
 #define			AT91_SDRAMC_MD_LOW_POWER_SDRAM	1
 
+/* Register access macros */
+#define at91_ramc_read(num, reg) \
+	at91_sys_read(AT91_SDRAMC##num + reg)
+#define at91_ramc_write(num, reg, value) \
+	at91_sys_write(AT91_SDRAMC##num + reg, value)
 
 #endif
diff --git a/arch/arm/mach-at91/include/mach/at91sam9rl.h b/arch/arm/mach-at91/include/mach/at91sam9rl.h
index fc2de6c..87ba851 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9rl.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9rl.h
@@ -74,7 +74,7 @@
  */
 #define AT91_DMA	(0xffffe600 - AT91_BASE_SYS)
 #define AT91_ECC	(0xffffe800 - AT91_BASE_SYS)
-#define AT91_SDRAMC	(0xffffea00 - AT91_BASE_SYS)
+#define AT91_SDRAMC0	(0xffffea00 - AT91_BASE_SYS)
 #define AT91_SMC	(0xffffec00 - AT91_BASE_SYS)
 #define AT91_MATRIX	(0xffffee00 - AT91_BASE_SYS)
 #define AT91_CCFG	(0xffffef10 - AT91_BASE_SYS)
diff --git a/arch/arm/mach-at91/pm.h b/arch/arm/mach-at91/pm.h
index 08322c4..8c87d0c 100644
--- a/arch/arm/mach-at91/pm.h
+++ b/arch/arm/mach-at91/pm.h
@@ -30,14 +30,50 @@ static inline u32 sdram_selfrefresh_enable(void)
 {
 	u32 saved_lpr, lpr;
 
-	saved_lpr = at91_sys_read(AT91_DDRSDRC_LPR);
+	saved_lpr = at91_ramc_read(0, AT91_DDRSDRC_LPR);
 
 	lpr = saved_lpr & ~AT91_DDRSDRC_LPCB;
-	at91_sys_write(AT91_DDRSDRC_LPR, lpr | AT91_DDRSDRC_LPCB_SELF_REFRESH);
+	at91_ramc_write(0, AT91_DDRSDRC_LPR, lpr | AT91_DDRSDRC_LPCB_SELF_REFRESH);
 	return saved_lpr;
 }
 
-#define sdram_selfrefresh_disable(saved_lpr)	at91_sys_write(AT91_DDRSDRC_LPR, saved_lpr)
+#define sdram_selfrefresh_disable(saved_lpr)	at91_ramc_write(0, AT91_DDRSDRC_LPR, saved_lpr)
+
+#elif defined(CONFIG_ARCH_AT91SAM9G45)
+#include <mach/at91sam9_ddrsdr.h>
+
+/* We manage both DDRAM/SDRAM controllers, we need more than one value to
+ * remember.
+ */
+static u32 saved_lpr1;
+
+static inline u32 sdram_selfrefresh_enable(void)
+{
+	/* Those tow values allow us to delay self-refresh activation
+	 * to the maximum. */
+	u32 lpr0, lpr1;
+	u32 saved_lpr0;
+
+	saved_lpr1 = at91_ramc_read(1, AT91_DDRSDRC_LPR);
+	lpr1 = saved_lpr1 & ~AT91_DDRSDRC_LPCB;
+	lpr1 |= AT91_DDRSDRC_LPCB_SELF_REFRESH;
+
+	saved_lpr0 = at91_ramc_read(0, AT91_DDRSDRC_LPR);
+	lpr0 = saved_lpr0 & ~AT91_DDRSDRC_LPCB;
+	lpr0 |= AT91_DDRSDRC_LPCB_SELF_REFRESH;
+
+	/* self-refresh mode now */
+	at91_ramc_write(0, AT91_DDRSDRC_LPR, lpr0);
+	at91_ramc_write(1, AT91_DDRSDRC_LPR, lpr1);
+
+	return saved_lpr0;
+}
+
+#define sdram_selfrefresh_disable(saved_lpr0)	\
+	do { \
+		at91_ramc_write(0, AT91_DDRSDRC_LPR, saved_lpr0); \
+		at91_ramc_write(1, AT91_DDRSDRC_LPR, saved_lpr1); \
+	} while (0)
 
 #else
 #include <mach/at91sam9_sdramc.h>
@@ -47,7 +83,6 @@ static inline u32 sdram_selfrefresh_enable(void)
  * FIXME either or both the SDRAM controllers (EB0, EB1) might be in use;
  * handle those cases both here and in the Suspend-To-RAM support.
  */
-#define	AT91_SDRAMC	AT91_SDRAMC0
 #warning Assuming EB1 SDRAM controller is *NOT* used
 #endif
 
@@ -55,13 +90,13 @@ static inline u32 sdram_selfrefresh_enable(void)
 {
 	u32 saved_lpr, lpr;
 
-	saved_lpr = at91_sys_read(AT91_SDRAMC_LPR);
+	saved_lpr = at91_ramc_read(0, AT91_SDRAMC_LPR);
 
 	lpr = saved_lpr & ~AT91_SDRAMC_LPCB;
-	at91_sys_write(AT91_SDRAMC_LPR, lpr | AT91_SDRAMC_LPCB_SELF_REFRESH);
+	at91_ramc_write(0, AT91_SDRAMC_LPR, lpr | AT91_SDRAMC_LPCB_SELF_REFRESH);
 	return saved_lpr;
 }
 
-#define sdram_selfrefresh_disable(saved_lpr)	at91_sys_write(AT91_SDRAMC_LPR, saved_lpr)
+#define sdram_selfrefresh_disable(saved_lpr)	at91_ramc_write(0, AT91_SDRAMC_LPR, saved_lpr)
 
 #endif
diff --git a/arch/arm/mach-at91/pm_slowclock.S b/arch/arm/mach-at91/pm_slowclock.S
index 9c5b48e..b6b00a1 100644
--- a/arch/arm/mach-at91/pm_slowclock.S
+++ b/arch/arm/mach-at91/pm_slowclock.S
@@ -16,10 +16,12 @@
 #include <mach/hardware.h>
 #include <mach/at91_pmc.h>
 
-#ifdef CONFIG_ARCH_AT91RM9200
+#if defined(CONFIG_ARCH_AT91RM9200)
 #include <mach/at91rm9200_mc.h>
 #elif defined(CONFIG_ARCH_AT91CAP9)
 #include <mach/at91cap9_ddrsdr.h>
+#elif defined(CONFIG_ARCH_AT91SAM9G45)
+#include <mach/at91sam9_ddrsdr.h>
 #else
 #include <mach/at91sam9_sdramc.h>
 #endif
@@ -30,7 +32,6 @@
  * FIXME either or both the SDRAM controllers (EB0, EB1) might be in use;
  * handle those cases both here and in the Suspend-To-RAM support.
  */
-#define AT91_SDRAMC	AT91_SDRAMC0
 #warning Assuming EB1 SDRAM controller is *NOT* used
 #endif
 
@@ -113,12 +114,14 @@ ENTRY(at91_slow_clock)
 	/*
 	 * Register usage:
 	 *  R1 = Base address of AT91_PMC
-	 *  R2 = Base address of AT91_SDRAMC (or AT91_SYS on AT91RM9200)
+	 *  R2 = Base address of RAM Controller (SDRAM, DDRSDR, or AT91_SYS)
 	 *  R3 = temporary register
 	 *  R4 = temporary register
+	 *  R5 = Base address of second RAM Controller or 0 if not present
 	 */
 	ldr	r1, .at91_va_base_pmc
 	ldr	r2, .at91_va_base_sdramc
+	ldr	r5, .at91_va_base_ramc1
 
 	/* Drain write buffer */
 	mcr	p15, 0, r0, c7, c10, 4
@@ -127,20 +130,33 @@ ENTRY(at91_slow_clock)
 	/* Put SDRAM in self-refresh mode */
 	mov	r3, #1
 	str	r3, [r2, #AT91_SDRAMC_SRR]
-#elif defined(CONFIG_ARCH_AT91CAP9)
-	/* Enable SDRAM self-refresh mode */
-	ldr	r3, [r2, #AT91_DDRSDRC_LPR - AT91_DDRSDRC]
-	str	r3, .saved_sam9_lpr
+#elif defined(CONFIG_ARCH_AT91CAP9) \
+	|| defined(CONFIG_ARCH_AT91SAM9G45)
 
-	mov	r3, #AT91_DDRSDRC_LPCB_SELF_REFRESH
-	str	r3, [r2, #AT91_DDRSDRC_LPR - AT91_DDRSDRC]
+	/* prepare for DDRAM self-refresh mode */
+	ldr	r3, [r2, #AT91_DDRSDRC_LPR]
+	str	r3, .saved_sam9_lpr
+	bic	r3, #AT91_DDRSDRC_LPCB
+	orr	r3, #AT91_DDRSDRC_LPCB_SELF_REFRESH
+
+	/* figure out if we use the second ram controller */
+	cmp	r5, #0
+	ldrne	r4, [r5, #AT91_DDRSDRC_LPR]
+	strne	r4, .saved_sam9_lpr1
+	bicne	r4, #AT91_DDRSDRC_LPCB
+	orrne	r4, #AT91_DDRSDRC_LPCB_SELF_REFRESH
+
+	/* Enable DDRAM self-refresh mode */
+	str	r3, [r2, #AT91_DDRSDRC_LPR]
+	strne	r4, [r5, #AT91_DDRSDRC_LPR]
 #else
 	/* Enable SDRAM self-refresh mode */
-	ldr	r3, [r2, #AT91_SDRAMC_LPR - AT91_SDRAMC]
+	ldr	r3, [r2, #AT91_SDRAMC_LPR]
 	str	r3, .saved_sam9_lpr
 
-	mov	r3, #AT91_SDRAMC_LPCB_SELF_REFRESH
-	str	r3, [r2, #AT91_SDRAMC_LPR - AT91_SDRAMC]
+	bic	r3, #AT91_SDRAMC_LPCB
+	orr	r3, #AT91_SDRAMC_LPCB_SELF_REFRESH
+	str	r3, [r2, #AT91_SDRAMC_LPR]
 #endif
 
 	/* Save Master clock setting */
@@ -247,14 +263,21 @@ ENTRY(at91_slow_clock)
 
 #ifdef CONFIG_ARCH_AT91RM9200
 	/* Do nothing - self-refresh is automatically disabled. */
-#elif defined(CONFIG_ARCH_AT91CAP9)
-	/* Restore LPR on AT91CAP9 */
+#elif defined(CONFIG_ARCH_AT91CAP9) \
+	|| defined(CONFIG_ARCH_AT91SAM9G45)
+	/* Restore LPR on AT91 with DDRAM */
 	ldr	r3, .saved_sam9_lpr
-	str	r3, [r2, #AT91_DDRSDRC_LPR - AT91_DDRSDRC]
+	str	r3, [r2, #AT91_DDRSDRC_LPR]
+
+	/* if we use the second ram controller */
+	cmp	r5, #0
+	ldrne	r4, .saved_sam9_lpr1
+	strne	r4, [r5, #AT91_DDRSDRC_LPR]
+
 #else
-	/* Restore LPR on AT91SAM9 */
+	/* Restore LPR on AT91 with SDRAM */
 	ldr	r3, .saved_sam9_lpr
-	str	r3, [r2, #AT91_SDRAMC_LPR - AT91_SDRAMC]
+	str	r3, [r2, #AT91_SDRAMC_LPR]
 #endif
 
 	/* Restore registers, and return */
@@ -273,18 +296,29 @@ ENTRY(at91_slow_clock)
 .saved_sam9_lpr:
 	.word 0
 
+.saved_sam9_lpr1:
+	.word 0
+
 .at91_va_base_pmc:
 	.word AT91_VA_BASE_SYS + AT91_PMC
 
 #ifdef CONFIG_ARCH_AT91RM9200
 .at91_va_base_sdramc:
 	.word AT91_VA_BASE_SYS
-#elif defined(CONFIG_ARCH_AT91CAP9)
+#elif defined(CONFIG_ARCH_AT91CAP9) \
+	|| defined(CONFIG_ARCH_AT91SAM9G45)
 .at91_va_base_sdramc:
-	.word AT91_VA_BASE_SYS + AT91_DDRSDRC
+	.word AT91_VA_BASE_SYS + AT91_DDRSDRC0
 #else
 .at91_va_base_sdramc:
-	.word AT91_VA_BASE_SYS + AT91_SDRAMC
+	.word AT91_VA_BASE_SYS + AT91_SDRAMC0
+#endif
+
+.at91_va_base_ramc1:
+#if defined(CONFIG_ARCH_AT91SAM9G45)
+	.word AT91_VA_BASE_SYS + AT91_DDRSDRC1
+#else
+	.word 0
 #endif
 
 ENTRY(at91_slow_clock_sz)
-- 
1.5.6.5

