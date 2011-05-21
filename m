Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab1EUIon (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 04:44:43 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:41031 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751748Ab1EUImz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 04:42:55 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Martin Persson <martin.persson@stericsson.com>,
        Per Fransson <per.xx.fransson@stericsson.com>,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Sebastien Rault <sebastien.rault@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 08/13] mfd: update DB8500 PRCMU driver
Date: Sat, 21 May 2011 10:42:43 +0200
Message-ID: <1305967363-16611-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias Nilsson <mattias.i.nilsson@stericsson.com>

This updates the DB8500 PRCMU driver to the latest version
available internally. Nominally we would update the dependent
CPUfreq driver at the same time but since that is being moved
around in this patch set we postpone that by simply deactivating
it for the time being.

This is a snapshot of the current PRCMU firmware API as it looks
right now. The PRCMU firmware is still subject to change. This
also updates the CPUfreq driver to a newer version that will
utilize the new API.

Signed-off-by: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
Signed-off-by: Martin Persson <martin.persson@stericsson.com>
Signed-off-by: Per Fransson <per.xx.fransson@stericsson.com>
Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Sebastien Rault <sebastien.rault@stericsson.com>
Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Rickard Andersson <rickard.andersson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/Makefile     |    2 +-
 arch/arm/mach-ux500/cpu-db8500.c |    5 +
 drivers/mfd/db8500-prcmu-regs.h  |  194 +++--
 drivers/mfd/db8500-prcmu.c       | 1879 ++++++++++++++++++++++++++++++++++----
 include/linux/mfd/db8500-prcmu.h |  992 +++++++++++++++++++-
 5 files changed, 2782 insertions(+), 290 deletions(-)

diff --git a/arch/arm/mach-ux500/Makefile b/arch/arm/mach-ux500/Makefile
index 7a1d43e..1694916 100644
--- a/arch/arm/mach-ux500/Makefile
+++ b/arch/arm/mach-ux500/Makefile
@@ -17,4 +17,4 @@ obj-$(CONFIG_HOTPLUG_CPU)	+= hotplug.o
 obj-$(CONFIG_LOCAL_TIMERS)	+= localtimer.o
 obj-$(CONFIG_U5500_MODEM_IRQ)	+= modem-irq-db5500.o
 obj-$(CONFIG_U5500_MBOX)	+= mbox-db5500.o
-obj-$(CONFIG_CPU_FREQ)		+= cpufreq.o
+
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 3d419fe..c3c4176 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -131,9 +131,14 @@ static struct platform_device db8500_pmu_device = {
 	.dev.platform_data	= &db8500_pmu_platdata,
 };
 
+static struct platform_device db8500_prcmu_device = {
+	.name			= "db8500-prcmu",
+};
+
 static struct platform_device *platform_devs[] __initdata = {
 	&u8500_dma40_device,
 	&db8500_pmu_device,
+	&db8500_prcmu_device,
 };
 
 static resource_size_t __initdata db8500_gpio_base[] = {
diff --git a/drivers/mfd/db8500-prcmu-regs.h b/drivers/mfd/db8500-prcmu-regs.h
index c1226da..3bbf04d 100644
--- a/drivers/mfd/db8500-prcmu-regs.h
+++ b/drivers/mfd/db8500-prcmu-regs.h
@@ -9,86 +9,158 @@
  *
  * PRCM Unit registers
  */
+#ifndef __DB8500_PRCMU_REGS_H
+#define __DB8500_PRCMU_REGS_H
 
-#ifndef __MACH_PRCMU_REGS_H
-#define __MACH_PRCMU_REGS_H
-
+#include <linux/bitops.h>
 #include <mach/hardware.h>
 
-#define PRCM_ARM_PLLDIVPS	(_PRCMU_BASE + 0x118)
-#define PRCM_ARM_CHGCLKREQ	(_PRCMU_BASE + 0x114)
-#define PRCM_PLLARM_ENABLE	(_PRCMU_BASE + 0x98)
-#define PRCM_ARMCLKFIX_MGT	(_PRCMU_BASE + 0x0)
-#define PRCM_A9_RESETN_CLR	(_PRCMU_BASE + 0x1f4)
-#define PRCM_A9_RESETN_SET	(_PRCMU_BASE + 0x1f0)
-#define PRCM_ARM_LS_CLAMP	(_PRCMU_BASE + 0x30c)
-#define PRCM_SRAM_A9		(_PRCMU_BASE + 0x308)
+#define BITS(_start, _end) ((BIT(_end) - BIT(_start)) + BIT(_end))
+
+#define PRCM_ARM_PLLDIVPS 0x118
+#define PRCM_ARM_PLLDIVPS_ARM_BRM_RATE	BITS(0, 5)
+#define PRCM_ARM_PLLDIVPS_MAX_MASK	0xF
+
+#define PRCM_PLLARM_LOCKP 0x0A8
+#define PRCM_PLLARM_LOCKP_PRCM_PLLARM_LOCKP3 BIT(1)
+
+#define PRCM_ARM_CHGCLKREQ 0x114
+#define PRCM_ARM_CHGCLKREQ_PRCM_ARM_CHGCLKREQ BIT(0)
+
+#define PRCM_PLLARM_ENABLE 0x98
+#define PRCM_PLLARM_ENABLE_PRCM_PLLARM_ENABLE	BIT(0)
+#define PRCM_PLLARM_ENABLE_PRCM_PLLARM_COUNTON	BIT(8)
+
+#define PRCM_ARMCLKFIX_MGT	0x0
+#define PRCM_A9_RESETN_CLR	0x1f4
+#define PRCM_A9_RESETN_SET	0x1f0
+#define PRCM_ARM_LS_CLAMP	0x30C
+#define PRCM_SRAM_A9		0x308
 
 /* ARM WFI Standby signal register */
-#define PRCM_ARM_WFI_STANDBY    (_PRCMU_BASE + 0x130)
-#define PRCMU_IOCR              (_PRCMU_BASE + 0x310)
+#define PRCM_ARM_WFI_STANDBY	0x130
+#define PRCM_IOCR		0x310
+#define PRCM_IOCR_IOFORCE BIT(0)
 
 /* CPU mailbox registers */
-#define PRCM_MBOX_CPU_VAL	(_PRCMU_BASE + 0x0fc)
-#define PRCM_MBOX_CPU_SET	(_PRCMU_BASE + 0x100)
-#define PRCM_MBOX_CPU_CLR	(_PRCMU_BASE + 0x104)
+#define PRCM_MBOX_CPU_VAL 0x0FC
+#define PRCM_MBOX_CPU_SET 0x100
 
 /* Dual A9 core interrupt management unit registers */
-#define PRCM_A9_MASK_REQ	(_PRCMU_BASE + 0x328)
-#define PRCM_A9_MASK_ACK	(_PRCMU_BASE + 0x32c)
-#define PRCM_ARMITMSK31TO0	(_PRCMU_BASE + 0x11c)
-#define PRCM_ARMITMSK63TO32	(_PRCMU_BASE + 0x120)
-#define PRCM_ARMITMSK95TO64	(_PRCMU_BASE + 0x124)
-#define PRCM_ARMITMSK127TO96	(_PRCMU_BASE + 0x128)
-#define PRCM_POWER_STATE_VAL	(_PRCMU_BASE + 0x25C)
-#define PRCM_ARMITVAL31TO0	(_PRCMU_BASE + 0x260)
-#define PRCM_ARMITVAL63TO32	(_PRCMU_BASE + 0x264)
-#define PRCM_ARMITVAL95TO64	(_PRCMU_BASE + 0x268)
-#define PRCM_ARMITVAL127TO96	(_PRCMU_BASE + 0x26C)
-
-#define PRCM_HOSTACCESS_REQ	(_PRCMU_BASE + 0x334)
-#define ARM_WAKEUP_MODEM	0x1
-
-#define PRCM_ARM_IT1_CLEAR	(_PRCMU_BASE + 0x48C)
-#define PRCM_ARM_IT1_VAL	(_PRCMU_BASE + 0x494)
-#define PRCM_HOLD_EVT		(_PRCMU_BASE + 0x174)
-
-#define PRCM_ITSTATUS0		(_PRCMU_BASE + 0x148)
-#define PRCM_ITSTATUS1		(_PRCMU_BASE + 0x150)
-#define PRCM_ITSTATUS2		(_PRCMU_BASE + 0x158)
-#define PRCM_ITSTATUS3		(_PRCMU_BASE + 0x160)
-#define PRCM_ITSTATUS4		(_PRCMU_BASE + 0x168)
-#define PRCM_ITSTATUS5		(_PRCMU_BASE + 0x484)
-#define PRCM_ITCLEAR5		(_PRCMU_BASE + 0x488)
-#define PRCM_ARMIT_MASKXP70_IT	(_PRCMU_BASE + 0x1018)
+#define PRCM_A9_MASK_REQ 0x328
+#define PRCM_A9_MASK_REQ_PRCM_A9_MASK_REQ BIT(0)
+
+#define PRCM_A9_MASK_ACK	0x32C
+#define PRCM_ARMITMSK31TO0	0x11C
+#define PRCM_ARMITMSK63TO32	0x120
+#define PRCM_ARMITMSK95TO64	0x124
+#define PRCM_ARMITMSK127TO96	0x128
+#define PRCM_POWER_STATE_VAL	0x25C
+#define PRCM_ARMITVAL31TO0	0x260
+#define PRCM_ARMITVAL63TO32	0x264
+#define PRCM_ARMITVAL95TO64	0x268
+#define PRCM_ARMITVAL127TO96	0x26C
+
+#define PRCM_HOSTACCESS_REQ 0x334
+#define PRCM_HOSTACCESS_REQ_HOSTACCESS_REQ BIT(0)
+
+#define PRCM_ARM_IT1_CLR 0x48C
+#define PRCM_ARM_IT1_VAL 0x494
+
+#define PRCM_ITSTATUS0		0x148
+#define PRCM_ITSTATUS1		0x150
+#define PRCM_ITSTATUS2		0x158
+#define PRCM_ITSTATUS3		0x160
+#define PRCM_ITSTATUS4		0x168
+#define PRCM_ITSTATUS5		0x484
+#define PRCM_ITCLEAR5		0x488
+#define PRCM_ARMIT_MASKXP70_IT	0x1018
 
 /* System reset register */
-#define PRCM_APE_SOFTRST	(_PRCMU_BASE + 0x228)
+#define PRCM_APE_SOFTRST 0x228
 
 /* Level shifter and clamp control registers */
-#define PRCM_MMIP_LS_CLAMP_SET     (_PRCMU_BASE + 0x420)
-#define PRCM_MMIP_LS_CLAMP_CLR     (_PRCMU_BASE + 0x424)
+#define PRCM_MMIP_LS_CLAMP_SET 0x420
+#define PRCM_MMIP_LS_CLAMP_CLR 0x424
+
+/* PRCMU HW semaphore */
+#define PRCM_SEM 0x400
+#define PRCM_SEM_PRCM_SEM BIT(0)
 
 /* PRCMU clock/PLL/reset registers */
-#define PRCM_PLLDSI_FREQ           (_PRCMU_BASE + 0x500)
-#define PRCM_PLLDSI_ENABLE         (_PRCMU_BASE + 0x504)
-#define PRCM_LCDCLK_MGT            (_PRCMU_BASE + 0x044)
-#define PRCM_MCDECLK_MGT           (_PRCMU_BASE + 0x064)
-#define PRCM_HDMICLK_MGT           (_PRCMU_BASE + 0x058)
-#define PRCM_TVCLK_MGT             (_PRCMU_BASE + 0x07c)
-#define PRCM_DSI_PLLOUT_SEL        (_PRCMU_BASE + 0x530)
-#define PRCM_DSITVCLK_DIV          (_PRCMU_BASE + 0x52C)
-#define PRCM_APE_RESETN_SET        (_PRCMU_BASE + 0x1E4)
-#define PRCM_APE_RESETN_CLR        (_PRCMU_BASE + 0x1E8)
+#define PRCM_PLLDSI_FREQ	0x500
+#define PRCM_PLLDSI_ENABLE	0x504
+#define PRCM_PLLDSI_LOCKP	0x508
+#define PRCM_DSI_PLLOUT_SEL	0x530
+#define PRCM_DSITVCLK_DIV	0x52C
+#define PRCM_APE_RESETN_SET	0x1E4
+#define PRCM_APE_RESETN_CLR	0x1E8
+
+#define PRCM_TCR		0x1C8
+#define PRCM_TCR_TENSEL_MASK	BITS(0, 7)
+#define PRCM_TCR_STOP_TIMERS	BIT(16)
+#define PRCM_TCR_DOZE_MODE	BIT(17)
+
+#define PRCM_CLKOCR			0x1CC
+#define PRCM_CLKOCR_CLKODIV0_SHIFT	0
+#define PRCM_CLKOCR_CLKODIV0_MASK	BITS(0, 5)
+#define PRCM_CLKOCR_CLKOSEL0_SHIFT	6
+#define PRCM_CLKOCR_CLKOSEL0_MASK	BITS(6, 8)
+#define PRCM_CLKOCR_CLKODIV1_SHIFT	16
+#define PRCM_CLKOCR_CLKODIV1_MASK	BITS(16, 21)
+#define PRCM_CLKOCR_CLKOSEL1_SHIFT	22
+#define PRCM_CLKOCR_CLKOSEL1_MASK	BITS(22, 24)
+#define PRCM_CLKOCR_CLK1TYPE		BIT(28)
+
+#define PRCM_SGACLK_MGT		0x014
+#define PRCM_UARTCLK_MGT	0x018
+#define PRCM_MSP02CLK_MGT	0x01C
+#define PRCM_MSP1CLK_MGT	0x288
+#define PRCM_I2CCLK_MGT		0x020
+#define PRCM_SDMMCCLK_MGT	0x024
+#define PRCM_SLIMCLK_MGT	0x028
+#define PRCM_PER1CLK_MGT	0x02C
+#define PRCM_PER2CLK_MGT	0x030
+#define PRCM_PER3CLK_MGT	0x034
+#define PRCM_PER5CLK_MGT	0x038
+#define PRCM_PER6CLK_MGT	0x03C
+#define PRCM_PER7CLK_MGT	0x040
+#define PRCM_LCDCLK_MGT		0x044
+#define PRCM_BMLCLK_MGT		0x04C
+#define PRCM_HSITXCLK_MGT	0x050
+#define PRCM_HSIRXCLK_MGT	0x054
+#define PRCM_HDMICLK_MGT	0x058
+#define PRCM_APEATCLK_MGT	0x05C
+#define PRCM_APETRACECLK_MGT	0x060
+#define PRCM_MCDECLK_MGT	0x064
+#define PRCM_IPI2CCLK_MGT	0x068
+#define PRCM_DSIALTCLK_MGT	0x06C
+#define PRCM_DMACLK_MGT		0x074
+#define PRCM_B2R2CLK_MGT	0x078
+#define PRCM_TVCLK_MGT		0x07C
+#define PRCM_UNIPROCLK_MGT	0x278
+#define PRCM_SSPCLK_MGT		0x280
+#define PRCM_RNGCLK_MGT		0x284
+#define PRCM_UICCCLK_MGT	0x27C
+
+#define PRCM_CLK_MGT_CLKPLLDIV_MASK	BITS(0, 4)
+#define PRCM_CLK_MGT_CLKPLLSW_MASK	BITS(5, 7)
+#define PRCM_CLK_MGT_CLKEN		BIT(8)
 
 /* ePOD and memory power signal control registers */
-#define PRCM_EPOD_C_SET            (_PRCMU_BASE + 0x410)
-#define PRCM_SRAM_LS_SLEEP         (_PRCMU_BASE + 0x304)
+#define PRCM_EPOD_C_SET		0x410
+#define PRCM_SRAM_LS_SLEEP	0x304
 
 /* Debug power control unit registers */
-#define PRCM_POWER_STATE_SET       (_PRCMU_BASE + 0x254)
+#define PRCM_POWER_STATE_SET 0x254
 
 /* Miscellaneous unit registers */
-#define PRCM_DSI_SW_RESET          (_PRCMU_BASE + 0x324)
+#define PRCM_DSI_SW_RESET 0x324
+#define PRCM_GPIOCR		0x138
+
+/* GPIOCR register */
+#define PRCM_GPIOCR_SPI2_SELECT BIT(23)
+
+#define PRCM_DDR_SUBSYS_APE_MINBW  0x438
 
-#endif /* __MACH_PRCMU_REGS_H */
+#endif /* __DB8500_PRCMU_REGS_H */
diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 31f18c8..c44725b 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -10,93 +10,1354 @@
  * U8500 PRCM Unit interface driver
  *
  */
-#include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/err.h>
+#include <linux/spinlock.h>
 #include <linux/io.h>
+#include <linux/slab.h>
 #include <linux/mutex.h>
 #include <linux/completion.h>
+#include <linux/irq.h>
 #include <linux/jiffies.h>
 #include <linux/bitops.h>
-#include <linux/interrupt.h>
+#include <linux/fs.h>
+#include <linux/platform_device.h>
+#include <linux/uaccess.h>
+#include <linux/mfd/core.h>
 #include <linux/mfd/db8500-prcmu.h>
+#include <mach/hardware.h>
+#include <mach/irqs.h>
+#include <mach/db8500-regs.h>
+#include <mach/id.h>
+#include "db8500-prcmu-regs.h"
+
+/* Offset for the firmware version within the TCPM */
+#define PRCMU_FW_VERSION_OFFSET 0xA4
+
+/* PRCMU project numbers, defined by PRCMU FW */
+#define PRCMU_PROJECT_ID_8500V1_0 1
+#define PRCMU_PROJECT_ID_8500V2_0 2
+#define PRCMU_PROJECT_ID_8400V2_0 3
+
+/* Index of different voltages to be used when accessing AVSData */
+#define PRCM_AVS_BASE		0x2FC
+#define PRCM_AVS_VBB_RET	(PRCM_AVS_BASE + 0x0)
+#define PRCM_AVS_VBB_MAX_OPP	(PRCM_AVS_BASE + 0x1)
+#define PRCM_AVS_VBB_100_OPP	(PRCM_AVS_BASE + 0x2)
+#define PRCM_AVS_VBB_50_OPP	(PRCM_AVS_BASE + 0x3)
+#define PRCM_AVS_VARM_MAX_OPP	(PRCM_AVS_BASE + 0x4)
+#define PRCM_AVS_VARM_100_OPP	(PRCM_AVS_BASE + 0x5)
+#define PRCM_AVS_VARM_50_OPP	(PRCM_AVS_BASE + 0x6)
+#define PRCM_AVS_VARM_RET	(PRCM_AVS_BASE + 0x7)
+#define PRCM_AVS_VAPE_100_OPP	(PRCM_AVS_BASE + 0x8)
+#define PRCM_AVS_VAPE_50_OPP	(PRCM_AVS_BASE + 0x9)
+#define PRCM_AVS_VMOD_100_OPP	(PRCM_AVS_BASE + 0xA)
+#define PRCM_AVS_VMOD_50_OPP	(PRCM_AVS_BASE + 0xB)
+#define PRCM_AVS_VSAFE		(PRCM_AVS_BASE + 0xC)
+
+#define PRCM_AVS_VOLTAGE		0
+#define PRCM_AVS_VOLTAGE_MASK		0x3f
+#define PRCM_AVS_ISSLOWSTARTUP		6
+#define PRCM_AVS_ISSLOWSTARTUP_MASK	(1 << PRCM_AVS_ISSLOWSTARTUP)
+#define PRCM_AVS_ISMODEENABLE		7
+#define PRCM_AVS_ISMODEENABLE_MASK	(1 << PRCM_AVS_ISMODEENABLE)
+
+#define PRCM_BOOT_STATUS	0xFFF
+#define PRCM_ROMCODE_A2P	0xFFE
+#define PRCM_ROMCODE_P2A	0xFFD
+#define PRCM_XP70_CUR_PWR_STATE 0xFFC      /* 4 BYTES */
+
+#define PRCM_SW_RST_REASON 0xFF8 /* 2 bytes */
+
+#define _PRCM_MBOX_HEADER		0xFE8 /* 16 bytes */
+#define PRCM_MBOX_HEADER_REQ_MB0	(_PRCM_MBOX_HEADER + 0x0)
+#define PRCM_MBOX_HEADER_REQ_MB1	(_PRCM_MBOX_HEADER + 0x1)
+#define PRCM_MBOX_HEADER_REQ_MB2	(_PRCM_MBOX_HEADER + 0x2)
+#define PRCM_MBOX_HEADER_REQ_MB3	(_PRCM_MBOX_HEADER + 0x3)
+#define PRCM_MBOX_HEADER_REQ_MB4	(_PRCM_MBOX_HEADER + 0x4)
+#define PRCM_MBOX_HEADER_REQ_MB5	(_PRCM_MBOX_HEADER + 0x5)
+#define PRCM_MBOX_HEADER_ACK_MB0	(_PRCM_MBOX_HEADER + 0x8)
+
+/* Req Mailboxes */
+#define PRCM_REQ_MB0 0xFDC /* 12 bytes  */
+#define PRCM_REQ_MB1 0xFD0 /* 12 bytes  */
+#define PRCM_REQ_MB2 0xFC0 /* 16 bytes  */
+#define PRCM_REQ_MB3 0xE4C /* 372 bytes  */
+#define PRCM_REQ_MB4 0xE48 /* 4 bytes  */
+#define PRCM_REQ_MB5 0xE44 /* 4 bytes  */
+
+/* Ack Mailboxes */
+#define PRCM_ACK_MB0 0xE08 /* 52 bytes  */
+#define PRCM_ACK_MB1 0xE04 /* 4 bytes */
+#define PRCM_ACK_MB2 0xE00 /* 4 bytes */
+#define PRCM_ACK_MB3 0xDFC /* 4 bytes */
+#define PRCM_ACK_MB4 0xDF8 /* 4 bytes */
+#define PRCM_ACK_MB5 0xDF4 /* 4 bytes */
+
+/* Mailbox 0 headers */
+#define MB0H_POWER_STATE_TRANS		0
+#define MB0H_CONFIG_WAKEUPS_EXE		1
+#define MB0H_READ_WAKEUP_ACK		3
+#define MB0H_CONFIG_WAKEUPS_SLEEP	4
+
+#define MB0H_WAKEUP_EXE 2
+#define MB0H_WAKEUP_SLEEP 5
+
+/* Mailbox 0 REQs */
+#define PRCM_REQ_MB0_AP_POWER_STATE	(PRCM_REQ_MB0 + 0x0)
+#define PRCM_REQ_MB0_AP_PLL_STATE	(PRCM_REQ_MB0 + 0x1)
+#define PRCM_REQ_MB0_ULP_CLOCK_STATE	(PRCM_REQ_MB0 + 0x2)
+#define PRCM_REQ_MB0_DO_NOT_WFI		(PRCM_REQ_MB0 + 0x3)
+#define PRCM_REQ_MB0_WAKEUP_8500	(PRCM_REQ_MB0 + 0x4)
+#define PRCM_REQ_MB0_WAKEUP_4500	(PRCM_REQ_MB0 + 0x8)
+
+/* Mailbox 0 ACKs */
+#define PRCM_ACK_MB0_AP_PWRSTTR_STATUS	(PRCM_ACK_MB0 + 0x0)
+#define PRCM_ACK_MB0_READ_POINTER	(PRCM_ACK_MB0 + 0x1)
+#define PRCM_ACK_MB0_WAKEUP_0_8500	(PRCM_ACK_MB0 + 0x4)
+#define PRCM_ACK_MB0_WAKEUP_0_4500	(PRCM_ACK_MB0 + 0x8)
+#define PRCM_ACK_MB0_WAKEUP_1_8500	(PRCM_ACK_MB0 + 0x1C)
+#define PRCM_ACK_MB0_WAKEUP_1_4500	(PRCM_ACK_MB0 + 0x20)
+#define PRCM_ACK_MB0_EVENT_4500_NUMBERS	20
+
+/* Mailbox 1 headers */
+#define MB1H_ARM_APE_OPP 0x0
+#define MB1H_RESET_MODEM 0x2
+#define MB1H_REQUEST_APE_OPP_100_VOLT 0x3
+#define MB1H_RELEASE_APE_OPP_100_VOLT 0x4
+#define MB1H_RELEASE_USB_WAKEUP 0x5
+
+/* Mailbox 1 Requests */
+#define PRCM_REQ_MB1_ARM_OPP			(PRCM_REQ_MB1 + 0x0)
+#define PRCM_REQ_MB1_APE_OPP			(PRCM_REQ_MB1 + 0x1)
+#define PRCM_REQ_MB1_APE_OPP_100_RESTORE	(PRCM_REQ_MB1 + 0x4)
+#define PRCM_REQ_MB1_ARM_OPP_100_RESTORE	(PRCM_REQ_MB1 + 0x8)
+
+/* Mailbox 1 ACKs */
+#define PRCM_ACK_MB1_CURRENT_ARM_OPP	(PRCM_ACK_MB1 + 0x0)
+#define PRCM_ACK_MB1_CURRENT_APE_OPP	(PRCM_ACK_MB1 + 0x1)
+#define PRCM_ACK_MB1_APE_VOLTAGE_STATUS	(PRCM_ACK_MB1 + 0x2)
+#define PRCM_ACK_MB1_DVFS_STATUS	(PRCM_ACK_MB1 + 0x3)
+
+/* Mailbox 2 headers */
+#define MB2H_DPS	0x0
+#define MB2H_AUTO_PWR	0x1
+
+/* Mailbox 2 REQs */
+#define PRCM_REQ_MB2_SVA_MMDSP		(PRCM_REQ_MB2 + 0x0)
+#define PRCM_REQ_MB2_SVA_PIPE		(PRCM_REQ_MB2 + 0x1)
+#define PRCM_REQ_MB2_SIA_MMDSP		(PRCM_REQ_MB2 + 0x2)
+#define PRCM_REQ_MB2_SIA_PIPE		(PRCM_REQ_MB2 + 0x3)
+#define PRCM_REQ_MB2_SGA		(PRCM_REQ_MB2 + 0x4)
+#define PRCM_REQ_MB2_B2R2_MCDE		(PRCM_REQ_MB2 + 0x5)
+#define PRCM_REQ_MB2_ESRAM12		(PRCM_REQ_MB2 + 0x6)
+#define PRCM_REQ_MB2_ESRAM34		(PRCM_REQ_MB2 + 0x7)
+#define PRCM_REQ_MB2_AUTO_PM_SLEEP	(PRCM_REQ_MB2 + 0x8)
+#define PRCM_REQ_MB2_AUTO_PM_IDLE	(PRCM_REQ_MB2 + 0xC)
+
+/* Mailbox 2 ACKs */
+#define PRCM_ACK_MB2_DPS_STATUS (PRCM_ACK_MB2 + 0x0)
+#define HWACC_PWR_ST_OK 0xFE
+
+/* Mailbox 3 headers */
+#define MB3H_ANC	0x0
+#define MB3H_SIDETONE	0x1
+#define MB3H_SYSCLK	0xE
+
+/* Mailbox 3 Requests */
+#define PRCM_REQ_MB3_ANC_FIR_COEFF	(PRCM_REQ_MB3 + 0x0)
+#define PRCM_REQ_MB3_ANC_IIR_COEFF	(PRCM_REQ_MB3 + 0x20)
+#define PRCM_REQ_MB3_ANC_SHIFTER	(PRCM_REQ_MB3 + 0x60)
+#define PRCM_REQ_MB3_ANC_WARP		(PRCM_REQ_MB3 + 0x64)
+#define PRCM_REQ_MB3_SIDETONE_FIR_GAIN	(PRCM_REQ_MB3 + 0x68)
+#define PRCM_REQ_MB3_SIDETONE_FIR_COEFF	(PRCM_REQ_MB3 + 0x6C)
+#define PRCM_REQ_MB3_SYSCLK_MGT		(PRCM_REQ_MB3 + 0x16C)
+
+/* Mailbox 4 headers */
+#define MB4H_DDR_INIT	0x0
+#define MB4H_MEM_ST	0x1
+#define MB4H_HOTDOG	0x12
+#define MB4H_HOTMON	0x13
+#define MB4H_HOT_PERIOD	0x14
+
+/* Mailbox 4 Requests */
+#define PRCM_REQ_MB4_DDR_ST_AP_SLEEP_IDLE	(PRCM_REQ_MB4 + 0x0)
+#define PRCM_REQ_MB4_DDR_ST_AP_DEEP_IDLE	(PRCM_REQ_MB4 + 0x1)
+#define PRCM_REQ_MB4_ESRAM0_ST			(PRCM_REQ_MB4 + 0x3)
+#define PRCM_REQ_MB4_HOTDOG_THRESHOLD		(PRCM_REQ_MB4 + 0x0)
+#define PRCM_REQ_MB4_HOTMON_LOW			(PRCM_REQ_MB4 + 0x0)
+#define PRCM_REQ_MB4_HOTMON_HIGH		(PRCM_REQ_MB4 + 0x1)
+#define PRCM_REQ_MB4_HOTMON_CONFIG		(PRCM_REQ_MB4 + 0x2)
+#define PRCM_REQ_MB4_HOT_PERIOD			(PRCM_REQ_MB4 + 0x0)
+#define HOTMON_CONFIG_LOW			BIT(0)
+#define HOTMON_CONFIG_HIGH			BIT(1)
+
+/* Mailbox 5 Requests */
+#define PRCM_REQ_MB5_I2C_SLAVE_OP	(PRCM_REQ_MB5 + 0x0)
+#define PRCM_REQ_MB5_I2C_HW_BITS	(PRCM_REQ_MB5 + 0x1)
+#define PRCM_REQ_MB5_I2C_REG		(PRCM_REQ_MB5 + 0x2)
+#define PRCM_REQ_MB5_I2C_VAL		(PRCM_REQ_MB5 + 0x3)
+#define PRCMU_I2C_WRITE(slave) \
+	(((slave) << 1) | (cpu_is_u8500v2() ? BIT(6) : 0))
+#define PRCMU_I2C_READ(slave) \
+	(((slave) << 1) | BIT(0) | (cpu_is_u8500v2() ? BIT(6) : 0))
+#define PRCMU_I2C_STOP_EN		BIT(3)
+
+/* Mailbox 5 ACKs */
+#define PRCM_ACK_MB5_I2C_STATUS	(PRCM_ACK_MB5 + 0x1)
+#define PRCM_ACK_MB5_I2C_VAL	(PRCM_ACK_MB5 + 0x3)
+#define I2C_WR_OK 0x1
+#define I2C_RD_OK 0x2
+
+#define NUM_MB 8
+#define MBOX_BIT BIT
+#define ALL_MBOX_BITS (MBOX_BIT(NUM_MB) - 1)
+
+/*
+ * Wakeups/IRQs
+ */
+
+#define WAKEUP_BIT_RTC BIT(0)
+#define WAKEUP_BIT_RTT0 BIT(1)
+#define WAKEUP_BIT_RTT1 BIT(2)
+#define WAKEUP_BIT_HSI0 BIT(3)
+#define WAKEUP_BIT_HSI1 BIT(4)
+#define WAKEUP_BIT_CA_WAKE BIT(5)
+#define WAKEUP_BIT_USB BIT(6)
+#define WAKEUP_BIT_ABB BIT(7)
+#define WAKEUP_BIT_ABB_FIFO BIT(8)
+#define WAKEUP_BIT_SYSCLK_OK BIT(9)
+#define WAKEUP_BIT_CA_SLEEP BIT(10)
+#define WAKEUP_BIT_AC_WAKE_ACK BIT(11)
+#define WAKEUP_BIT_SIDE_TONE_OK BIT(12)
+#define WAKEUP_BIT_ANC_OK BIT(13)
+#define WAKEUP_BIT_SW_ERROR BIT(14)
+#define WAKEUP_BIT_AC_SLEEP_ACK BIT(15)
+#define WAKEUP_BIT_ARM BIT(17)
+#define WAKEUP_BIT_HOTMON_LOW BIT(18)
+#define WAKEUP_BIT_HOTMON_HIGH BIT(19)
+#define WAKEUP_BIT_MODEM_SW_RESET_REQ BIT(20)
+#define WAKEUP_BIT_GPIO0 BIT(23)
+#define WAKEUP_BIT_GPIO1 BIT(24)
+#define WAKEUP_BIT_GPIO2 BIT(25)
+#define WAKEUP_BIT_GPIO3 BIT(26)
+#define WAKEUP_BIT_GPIO4 BIT(27)
+#define WAKEUP_BIT_GPIO5 BIT(28)
+#define WAKEUP_BIT_GPIO6 BIT(29)
+#define WAKEUP_BIT_GPIO7 BIT(30)
+#define WAKEUP_BIT_GPIO8 BIT(31)
+
+/*
+ * This vector maps irq numbers to the bits in the bit field used in
+ * communication with the PRCMU firmware.
+ *
+ * The reason for having this is to keep the irq numbers contiguous even though
+ * the bits in the bit field are not. (The bits also have a tendency to move
+ * around, to further complicate matters.)
+ */
+#define IRQ_INDEX(_name) ((IRQ_PRCMU_##_name) - IRQ_PRCMU_BASE)
+#define IRQ_ENTRY(_name)[IRQ_INDEX(_name)] = (WAKEUP_BIT_##_name)
+static u32 prcmu_irq_bit[NUM_PRCMU_WAKEUPS] = {
+	IRQ_ENTRY(RTC),
+	IRQ_ENTRY(RTT0),
+	IRQ_ENTRY(RTT1),
+	IRQ_ENTRY(HSI0),
+	IRQ_ENTRY(HSI1),
+	IRQ_ENTRY(CA_WAKE),
+	IRQ_ENTRY(USB),
+	IRQ_ENTRY(ABB),
+	IRQ_ENTRY(ABB_FIFO),
+	IRQ_ENTRY(CA_SLEEP),
+	IRQ_ENTRY(ARM),
+	IRQ_ENTRY(HOTMON_LOW),
+	IRQ_ENTRY(HOTMON_HIGH),
+	IRQ_ENTRY(MODEM_SW_RESET_REQ),
+	IRQ_ENTRY(GPIO0),
+	IRQ_ENTRY(GPIO1),
+	IRQ_ENTRY(GPIO2),
+	IRQ_ENTRY(GPIO3),
+	IRQ_ENTRY(GPIO4),
+	IRQ_ENTRY(GPIO5),
+	IRQ_ENTRY(GPIO6),
+	IRQ_ENTRY(GPIO7),
+	IRQ_ENTRY(GPIO8)
+};
+
+#define VALID_WAKEUPS (BIT(NUM_PRCMU_WAKEUP_INDICES) - 1)
+#define WAKEUP_ENTRY(_name)[PRCMU_WAKEUP_INDEX_##_name] = (WAKEUP_BIT_##_name)
+static u32 prcmu_wakeup_bit[NUM_PRCMU_WAKEUP_INDICES] = {
+	WAKEUP_ENTRY(RTC),
+	WAKEUP_ENTRY(RTT0),
+	WAKEUP_ENTRY(RTT1),
+	WAKEUP_ENTRY(HSI0),
+	WAKEUP_ENTRY(HSI1),
+	WAKEUP_ENTRY(USB),
+	WAKEUP_ENTRY(ABB),
+	WAKEUP_ENTRY(ABB_FIFO),
+	WAKEUP_ENTRY(ARM)
+};
+
+/*
+ * mb0_transfer - state needed for mailbox 0 communication.
+ * @lock:		The transaction lock.
+ * @dbb_events_lock:	A lock used to handle concurrent access to (parts of)
+ *			the request data.
+ * @mask_work:		Work structure used for (un)masking wakeup interrupts.
+ * @req:		Request data that need to persist between requests.
+ */
+static struct {
+	spinlock_t lock;
+	spinlock_t dbb_irqs_lock;
+	struct work_struct mask_work;
+	struct mutex ac_wake_lock;
+	struct completion ac_wake_work;
+	struct {
+		u32 dbb_irqs;
+		u32 dbb_wakeups;
+		u32 abb_events;
+	} req;
+} mb0_transfer;
+
+/*
+ * mb1_transfer - state needed for mailbox 1 communication.
+ * @lock:	The transaction lock.
+ * @work:	The transaction completion structure.
+ * @ack:	Reply ("acknowledge") data.
+ */
+static struct {
+	struct mutex lock;
+	struct completion work;
+	struct {
+		u8 header;
+		u8 arm_opp;
+		u8 ape_opp;
+		u8 ape_voltage_status;
+	} ack;
+} mb1_transfer;
+
+/*
+ * mb2_transfer - state needed for mailbox 2 communication.
+ * @lock:            The transaction lock.
+ * @work:            The transaction completion structure.
+ * @auto_pm_lock:    The autonomous power management configuration lock.
+ * @auto_pm_enabled: A flag indicating whether autonomous PM is enabled.
+ * @req:             Request data that need to persist between requests.
+ * @ack:             Reply ("acknowledge") data.
+ */
+static struct {
+	struct mutex lock;
+	struct completion work;
+	spinlock_t auto_pm_lock;
+	bool auto_pm_enabled;
+	struct {
+		u8 status;
+	} ack;
+} mb2_transfer;
+
+/*
+ * mb3_transfer - state needed for mailbox 3 communication.
+ * @lock:		The request lock.
+ * @sysclk_lock:	A lock used to handle concurrent sysclk requests.
+ * @sysclk_work:	Work structure used for sysclk requests.
+ */
+static struct {
+	spinlock_t lock;
+	struct mutex sysclk_lock;
+	struct completion sysclk_work;
+} mb3_transfer;
+
+/*
+ * mb4_transfer - state needed for mailbox 4 communication.
+ * @lock:	The transaction lock.
+ * @work:	The transaction completion structure.
+ */
+static struct {
+	struct mutex lock;
+	struct completion work;
+} mb4_transfer;
+
+/*
+ * mb5_transfer - state needed for mailbox 5 communication.
+ * @lock:	The transaction lock.
+ * @work:	The transaction completion structure.
+ * @ack:	Reply ("acknowledge") data.
+ */
+static struct {
+	struct mutex lock;
+	struct completion work;
+	struct {
+		u8 status;
+		u8 value;
+	} ack;
+} mb5_transfer;
+
+static atomic_t ac_wake_req_state = ATOMIC_INIT(0);
+
+/* Spinlocks */
+static DEFINE_SPINLOCK(clkout_lock);
+static DEFINE_SPINLOCK(gpiocr_lock);
+
+/* Global var to runtime determine TCDM base for v2 or v1 */
+static __iomem void *tcdm_base;
+
+struct clk_mgt {
+	unsigned int offset;
+	u32 pllsw;
+};
+
+static DEFINE_SPINLOCK(clk_mgt_lock);
+
+#define CLK_MGT_ENTRY(_name)[PRCMU_##_name] = { (PRCM_##_name##_MGT), 0 }
+struct clk_mgt clk_mgt[PRCMU_NUM_REG_CLOCKS] = {
+	CLK_MGT_ENTRY(SGACLK),
+	CLK_MGT_ENTRY(UARTCLK),
+	CLK_MGT_ENTRY(MSP02CLK),
+	CLK_MGT_ENTRY(MSP1CLK),
+	CLK_MGT_ENTRY(I2CCLK),
+	CLK_MGT_ENTRY(SDMMCCLK),
+	CLK_MGT_ENTRY(SLIMCLK),
+	CLK_MGT_ENTRY(PER1CLK),
+	CLK_MGT_ENTRY(PER2CLK),
+	CLK_MGT_ENTRY(PER3CLK),
+	CLK_MGT_ENTRY(PER5CLK),
+	CLK_MGT_ENTRY(PER6CLK),
+	CLK_MGT_ENTRY(PER7CLK),
+	CLK_MGT_ENTRY(LCDCLK),
+	CLK_MGT_ENTRY(BMLCLK),
+	CLK_MGT_ENTRY(HSITXCLK),
+	CLK_MGT_ENTRY(HSIRXCLK),
+	CLK_MGT_ENTRY(HDMICLK),
+	CLK_MGT_ENTRY(APEATCLK),
+	CLK_MGT_ENTRY(APETRACECLK),
+	CLK_MGT_ENTRY(MCDECLK),
+	CLK_MGT_ENTRY(IPI2CCLK),
+	CLK_MGT_ENTRY(DSIALTCLK),
+	CLK_MGT_ENTRY(DMACLK),
+	CLK_MGT_ENTRY(B2R2CLK),
+	CLK_MGT_ENTRY(TVCLK),
+	CLK_MGT_ENTRY(SSPCLK),
+	CLK_MGT_ENTRY(RNGCLK),
+	CLK_MGT_ENTRY(UICCCLK),
+};
+
+/*
+* Used by MCDE to setup all necessary PRCMU registers
+*/
+#define PRCMU_RESET_DSIPLL		0x00004000
+#define PRCMU_UNCLAMP_DSIPLL		0x00400800
+
+#define PRCMU_CLK_PLL_DIV_SHIFT		0
+#define PRCMU_CLK_PLL_SW_SHIFT		5
+#define PRCMU_CLK_38			(1 << 9)
+#define PRCMU_CLK_38_SRC		(1 << 10)
+#define PRCMU_CLK_38_DIV		(1 << 11)
+
+/* PLLDIV=12, PLLSW=4 (PLLDDR) */
+#define PRCMU_DSI_CLOCK_SETTING		0x0000008C
+
+/* PLLDIV=8, PLLSW=4 (PLLDDR) */
+#define PRCMU_DSI_CLOCK_SETTING_U8400	0x00000088
+
+/* DPI 50000000 Hz */
+#define PRCMU_DPI_CLOCK_SETTING		((1 << PRCMU_CLK_PLL_SW_SHIFT) | \
+					  (16 << PRCMU_CLK_PLL_DIV_SHIFT))
+#define PRCMU_DSI_LP_CLOCK_SETTING	0x00000E00
+
+/* D=101, N=1, R=4, SELDIV2=0 */
+#define PRCMU_PLLDSI_FREQ_SETTING	0x00040165
+
+/* D=70, N=1, R=3, SELDIV2=0 */
+#define PRCMU_PLLDSI_FREQ_SETTING_U8400	0x00030146
+
+#define PRCMU_ENABLE_PLLDSI		0x00000001
+#define PRCMU_DISABLE_PLLDSI		0x00000000
+#define PRCMU_RELEASE_RESET_DSS		0x0000400C
+#define PRCMU_DSI_PLLOUT_SEL_SETTING	0x00000202
+/* ESC clk, div0=1, div1=1, div2=3 */
+#define PRCMU_ENABLE_ESCAPE_CLOCK_DIV	0x07030101
+#define PRCMU_DISABLE_ESCAPE_CLOCK_DIV	0x00030101
+#define PRCMU_DSI_RESET_SW		0x00000007
+
+#define PRCMU_PLLDSI_LOCKP_LOCKED	0x3
+
+static struct {
+	u8 project_number;
+	u8 api_version;
+	u8 func_version;
+	u8 errata;
+} prcmu_version;
+
+
+int prcmu_enable_dsipll(void)
+{
+	int i;
+	unsigned int plldsifreq;
+
+	/* Clear DSIPLL_RESETN */
+	writel(PRCMU_RESET_DSIPLL, (_PRCMU_BASE + PRCM_APE_RESETN_CLR));
+	/* Unclamp DSIPLL in/out */
+	writel(PRCMU_UNCLAMP_DSIPLL, (_PRCMU_BASE + PRCM_MMIP_LS_CLAMP_CLR));
+
+	if (prcmu_is_u8400())
+		plldsifreq = PRCMU_PLLDSI_FREQ_SETTING_U8400;
+	else
+		plldsifreq = PRCMU_PLLDSI_FREQ_SETTING;
+	/* Set DSI PLL FREQ */
+	writel(plldsifreq, (_PRCMU_BASE + PRCM_PLLDSI_FREQ));
+	writel(PRCMU_DSI_PLLOUT_SEL_SETTING,
+		(_PRCMU_BASE + PRCM_DSI_PLLOUT_SEL));
+	/* Enable Escape clocks */
+	writel(PRCMU_ENABLE_ESCAPE_CLOCK_DIV,
+					(_PRCMU_BASE + PRCM_DSITVCLK_DIV));
+
+	/* Start DSI PLL */
+	writel(PRCMU_ENABLE_PLLDSI, (_PRCMU_BASE + PRCM_PLLDSI_ENABLE));
+	/* Reset DSI PLL */
+	writel(PRCMU_DSI_RESET_SW, (_PRCMU_BASE + PRCM_DSI_SW_RESET));
+	for (i = 0; i < 10; i++) {
+		if ((readl(_PRCMU_BASE + PRCM_PLLDSI_LOCKP) &
+			PRCMU_PLLDSI_LOCKP_LOCKED)
+					== PRCMU_PLLDSI_LOCKP_LOCKED)
+			break;
+		udelay(100);
+	}
+	/* Set DSIPLL_RESETN */
+	writel(PRCMU_RESET_DSIPLL, (_PRCMU_BASE + PRCM_APE_RESETN_SET));
+	return 0;
+}
+
+int prcmu_disable_dsipll(void)
+{
+	/* Disable dsi pll */
+	writel(PRCMU_DISABLE_PLLDSI, (_PRCMU_BASE + PRCM_PLLDSI_ENABLE));
+	/* Disable  escapeclock */
+	writel(PRCMU_DISABLE_ESCAPE_CLOCK_DIV,
+					(_PRCMU_BASE + PRCM_DSITVCLK_DIV));
+	return 0;
+}
+
+int prcmu_set_display_clocks(void)
+{
+	unsigned long flags;
+	unsigned int dsiclk;
+
+	if (prcmu_is_u8400())
+		dsiclk = PRCMU_DSI_CLOCK_SETTING_U8400;
+	else
+		dsiclk = PRCMU_DSI_CLOCK_SETTING;
+
+	spin_lock_irqsave(&clk_mgt_lock, flags);
+
+	/* Grab the HW semaphore. */
+	while ((readl(_PRCMU_BASE + PRCM_SEM) & PRCM_SEM_PRCM_SEM) != 0)
+		cpu_relax();
+
+	writel(dsiclk, (_PRCMU_BASE + PRCM_HDMICLK_MGT));
+	writel(PRCMU_DSI_LP_CLOCK_SETTING, (_PRCMU_BASE + PRCM_TVCLK_MGT));
+	writel(PRCMU_DPI_CLOCK_SETTING, (_PRCMU_BASE + PRCM_LCDCLK_MGT));
+
+	/* Release the HW semaphore. */
+	writel(0, (_PRCMU_BASE + PRCM_SEM));
+
+	spin_unlock_irqrestore(&clk_mgt_lock, flags);
+
+	return 0;
+}
+
+/**
+ * prcmu_enable_spi2 - Enables pin muxing for SPI2 on OtherAlternateC1.
+ */
+void prcmu_enable_spi2(void)
+{
+	u32 reg;
+	unsigned long flags;
+
+	spin_lock_irqsave(&gpiocr_lock, flags);
+	reg = readl(_PRCMU_BASE + PRCM_GPIOCR);
+	writel(reg | PRCM_GPIOCR_SPI2_SELECT, _PRCMU_BASE + PRCM_GPIOCR);
+	spin_unlock_irqrestore(&gpiocr_lock, flags);
+}
+
+/**
+ * prcmu_disable_spi2 - Disables pin muxing for SPI2 on OtherAlternateC1.
+ */
+void prcmu_disable_spi2(void)
+{
+	u32 reg;
+	unsigned long flags;
+
+	spin_lock_irqsave(&gpiocr_lock, flags);
+	reg = readl(_PRCMU_BASE + PRCM_GPIOCR);
+	writel(reg & ~PRCM_GPIOCR_SPI2_SELECT, _PRCMU_BASE + PRCM_GPIOCR);
+	spin_unlock_irqrestore(&gpiocr_lock, flags);
+}
+
+bool prcmu_has_arm_maxopp(void)
+{
+	return (readb(tcdm_base + PRCM_AVS_VARM_MAX_OPP) &
+		PRCM_AVS_ISMODEENABLE_MASK) == PRCM_AVS_ISMODEENABLE_MASK;
+}
+
+bool prcmu_is_u8400(void)
+{
+	return prcmu_version.project_number == PRCMU_PROJECT_ID_8400V2_0;
+}
+
+/**
+ * prcmu_get_boot_status - PRCMU boot status checking
+ * Returns: the current PRCMU boot status
+ */
+int prcmu_get_boot_status(void)
+{
+	return readb(tcdm_base + PRCM_BOOT_STATUS);
+}
+
+/**
+ * prcmu_set_rc_a2p - This function is used to run few power state sequences
+ * @val: Value to be set, i.e. transition requested
+ * Returns: 0 on success, -EINVAL on invalid argument
+ *
+ * This function is used to run the following power state sequences -
+ * any state to ApReset,  ApDeepSleep to ApExecute, ApExecute to ApDeepSleep
+ */
+int prcmu_set_rc_a2p(enum romcode_write val)
+{
+	if (val < RDY_2_DS || val > RDY_2_XP70_RST)
+		return -EINVAL;
+	writeb(val, (tcdm_base + PRCM_ROMCODE_A2P));
+	return 0;
+}
+
+/**
+ * prcmu_get_rc_p2a - This function is used to get power state sequences
+ * Returns: the power transition that has last happened
+ *
+ * This function can return the following transitions-
+ * any state to ApReset,  ApDeepSleep to ApExecute, ApExecute to ApDeepSleep
+ */
+enum romcode_read prcmu_get_rc_p2a(void)
+{
+	return readb(tcdm_base + PRCM_ROMCODE_P2A);
+}
+
+/**
+ * prcmu_get_current_mode - Return the current XP70 power mode
+ * Returns: Returns the current AP(ARM) power mode: init,
+ * apBoot, apExecute, apDeepSleep, apSleep, apIdle, apReset
+ */
+enum ap_pwrst prcmu_get_xp70_current_state(void)
+{
+	return readb(tcdm_base + PRCM_XP70_CUR_PWR_STATE);
+}
+
+/**
+ * prcmu_config_clkout - Configure one of the programmable clock outputs.
+ * @clkout:	The CLKOUT number (0 or 1).
+ * @source:	The clock to be used (one of the PRCMU_CLKSRC_*).
+ * @div:	The divider to be applied.
+ *
+ * Configures one of the programmable clock outputs (CLKOUTs).
+ * @div should be in the range [1,63] to request a configuration, or 0 to
+ * inform that the configuration is no longer requested.
+ */
+int prcmu_config_clkout(u8 clkout, u8 source, u8 div)
+{
+	static int requests[2];
+	int r = 0;
+	unsigned long flags;
+	u32 val;
+	u32 bits;
+	u32 mask;
+	u32 div_mask;
+
+	BUG_ON(clkout > 1);
+	BUG_ON(div > 63);
+	BUG_ON((clkout == 0) && (source > PRCMU_CLKSRC_CLK009));
+
+	if (!div && !requests[clkout])
+		return -EINVAL;
+
+	switch (clkout) {
+	case 0:
+		div_mask = PRCM_CLKOCR_CLKODIV0_MASK;
+		mask = (PRCM_CLKOCR_CLKODIV0_MASK | PRCM_CLKOCR_CLKOSEL0_MASK);
+		bits = ((source << PRCM_CLKOCR_CLKOSEL0_SHIFT) |
+			(div << PRCM_CLKOCR_CLKODIV0_SHIFT));
+		break;
+	case 1:
+		div_mask = PRCM_CLKOCR_CLKODIV1_MASK;
+		mask = (PRCM_CLKOCR_CLKODIV1_MASK | PRCM_CLKOCR_CLKOSEL1_MASK |
+			PRCM_CLKOCR_CLK1TYPE);
+		bits = ((source << PRCM_CLKOCR_CLKOSEL1_SHIFT) |
+			(div << PRCM_CLKOCR_CLKODIV1_SHIFT));
+		break;
+	}
+	bits &= mask;
+
+	spin_lock_irqsave(&clkout_lock, flags);
+
+	val = readl(_PRCMU_BASE + PRCM_CLKOCR);
+	if (val & div_mask) {
+		if (div) {
+			if ((val & mask) != bits) {
+				r = -EBUSY;
+				goto unlock_and_return;
+			}
+		} else {
+			if ((val & mask & ~div_mask) != bits) {
+				r = -EINVAL;
+				goto unlock_and_return;
+			}
+		}
+	}
+	writel((bits | (val & ~mask)), (_PRCMU_BASE + PRCM_CLKOCR));
+	requests[clkout] += (div ? 1 : -1);
+
+unlock_and_return:
+	spin_unlock_irqrestore(&clkout_lock, flags);
+
+	return r;
+}
+
+int prcmu_set_power_state(u8 state, bool keep_ulp_clk, bool keep_ap_pll)
+{
+	unsigned long flags;
+
+	BUG_ON((state < PRCMU_AP_SLEEP) || (PRCMU_AP_DEEP_IDLE < state));
+
+	spin_lock_irqsave(&mb0_transfer.lock, flags);
+
+	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(0))
+		cpu_relax();
+
+	writeb(MB0H_POWER_STATE_TRANS, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB0));
+	writeb(state, (tcdm_base + PRCM_REQ_MB0_AP_POWER_STATE));
+	writeb((keep_ap_pll ? 1 : 0), (tcdm_base + PRCM_REQ_MB0_AP_PLL_STATE));
+	writeb((keep_ulp_clk ? 1 : 0),
+		(tcdm_base + PRCM_REQ_MB0_ULP_CLOCK_STATE));
+	writeb(0, (tcdm_base + PRCM_REQ_MB0_DO_NOT_WFI));
+	writel(MBOX_BIT(0), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+
+	spin_unlock_irqrestore(&mb0_transfer.lock, flags);
+
+	return 0;
+}
+
+/* This function should only be called while mb0_transfer.lock is held. */
+static void config_wakeups(void)
+{
+	const u8 header[2] = {
+		MB0H_CONFIG_WAKEUPS_EXE,
+		MB0H_CONFIG_WAKEUPS_SLEEP
+	};
+	static u32 last_dbb_events;
+	static u32 last_abb_events;
+	u32 dbb_events;
+	u32 abb_events;
+	unsigned int i;
+
+	dbb_events = mb0_transfer.req.dbb_irqs | mb0_transfer.req.dbb_wakeups;
+	dbb_events |= (WAKEUP_BIT_AC_WAKE_ACK | WAKEUP_BIT_AC_SLEEP_ACK);
+
+	abb_events = mb0_transfer.req.abb_events;
+
+	if ((dbb_events == last_dbb_events) && (abb_events == last_abb_events))
+		return;
+
+	for (i = 0; i < 2; i++) {
+		while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(0))
+			cpu_relax();
+		writel(dbb_events, (tcdm_base + PRCM_REQ_MB0_WAKEUP_8500));
+		writel(abb_events, (tcdm_base + PRCM_REQ_MB0_WAKEUP_4500));
+		writeb(header[i], (tcdm_base + PRCM_MBOX_HEADER_REQ_MB0));
+		writel(MBOX_BIT(0), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+	}
+	last_dbb_events = dbb_events;
+	last_abb_events = abb_events;
+}
+
+void prcmu_enable_wakeups(u32 wakeups)
+{
+	unsigned long flags;
+	u32 bits;
+	int i;
+
+	BUG_ON(wakeups != (wakeups & VALID_WAKEUPS));
+
+	for (i = 0, bits = 0; i < NUM_PRCMU_WAKEUP_INDICES; i++) {
+		if (wakeups & BIT(i))
+			bits |= prcmu_wakeup_bit[i];
+	}
+
+	spin_lock_irqsave(&mb0_transfer.lock, flags);
+
+	mb0_transfer.req.dbb_wakeups = bits;
+	config_wakeups();
+
+	spin_unlock_irqrestore(&mb0_transfer.lock, flags);
+}
+
+void prcmu_config_abb_event_readout(u32 abb_events)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mb0_transfer.lock, flags);
+
+	mb0_transfer.req.abb_events = abb_events;
+	config_wakeups();
+
+	spin_unlock_irqrestore(&mb0_transfer.lock, flags);
+}
+
+void prcmu_get_abb_event_buffer(void __iomem **buf)
+{
+	if (readb(tcdm_base + PRCM_ACK_MB0_READ_POINTER) & 1)
+		*buf = (tcdm_base + PRCM_ACK_MB0_WAKEUP_1_4500);
+	else
+		*buf = (tcdm_base + PRCM_ACK_MB0_WAKEUP_0_4500);
+}
+
+/**
+ * prcmu_set_arm_opp - set the appropriate ARM OPP
+ * @opp: The new ARM operating point to which transition is to be made
+ * Returns: 0 on success, non-zero on failure
+ *
+ * This function sets the the operating point of the ARM.
+ */
+int prcmu_set_arm_opp(u8 opp)
+{
+	int r;
+
+	if (opp < ARM_NO_CHANGE || opp > ARM_EXTCLK)
+		return -EINVAL;
+
+	r = 0;
+
+	mutex_lock(&mb1_transfer.lock);
+
+	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
+		cpu_relax();
+
+	writeb(MB1H_ARM_APE_OPP, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB1));
+	writeb(opp, (tcdm_base + PRCM_REQ_MB1_ARM_OPP));
+	writeb(APE_NO_CHANGE, (tcdm_base + PRCM_REQ_MB1_APE_OPP));
+
+	writel(MBOX_BIT(1), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+	wait_for_completion(&mb1_transfer.work);
+
+	if ((mb1_transfer.ack.header != MB1H_ARM_APE_OPP) ||
+		(mb1_transfer.ack.arm_opp != opp))
+		r = -EIO;
+
+	mutex_unlock(&mb1_transfer.lock);
+
+	return r;
+}
+
+/**
+ * prcmu_get_arm_opp - get the current ARM OPP
+ *
+ * Returns: the current ARM OPP
+ */
+int prcmu_get_arm_opp(void)
+{
+	return readb(tcdm_base + PRCM_ACK_MB1_CURRENT_ARM_OPP);
+}
+
+/**
+ * prcmu_get_ddr_opp - get the current DDR OPP
+ *
+ * Returns: the current DDR OPP
+ */
+int prcmu_get_ddr_opp(void)
+{
+	return readb(_PRCMU_BASE + PRCM_DDR_SUBSYS_APE_MINBW);
+}
+
+/**
+ * set_ddr_opp - set the appropriate DDR OPP
+ * @opp: The new DDR operating point to which transition is to be made
+ * Returns: 0 on success, non-zero on failure
+ *
+ * This function sets the operating point of the DDR.
+ */
+int prcmu_set_ddr_opp(u8 opp)
+{
+	if (opp < DDR_100_OPP || opp > DDR_25_OPP)
+		return -EINVAL;
+	/* Changing the DDR OPP can hang the hardware pre-v21 */
+	if (cpu_is_u8500v20_or_later() && !cpu_is_u8500v20())
+		writeb(opp, (_PRCMU_BASE + PRCM_DDR_SUBSYS_APE_MINBW));
+
+	return 0;
+}
+/**
+ * set_ape_opp - set the appropriate APE OPP
+ * @opp: The new APE operating point to which transition is to be made
+ * Returns: 0 on success, non-zero on failure
+ *
+ * This function sets the operating point of the APE.
+ */
+int prcmu_set_ape_opp(u8 opp)
+{
+	int r = 0;
+
+	mutex_lock(&mb1_transfer.lock);
+
+	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
+		cpu_relax();
+
+	writeb(MB1H_ARM_APE_OPP, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB1));
+	writeb(ARM_NO_CHANGE, (tcdm_base + PRCM_REQ_MB1_ARM_OPP));
+	writeb(opp, (tcdm_base + PRCM_REQ_MB1_APE_OPP));
+
+	writel(MBOX_BIT(1), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+	wait_for_completion(&mb1_transfer.work);
+
+	if ((mb1_transfer.ack.header != MB1H_ARM_APE_OPP) ||
+		(mb1_transfer.ack.ape_opp != opp))
+		r = -EIO;
+
+	mutex_unlock(&mb1_transfer.lock);
+
+	return r;
+}
+
+/**
+ * prcmu_get_ape_opp - get the current APE OPP
+ *
+ * Returns: the current APE OPP
+ */
+int prcmu_get_ape_opp(void)
+{
+	return readb(tcdm_base + PRCM_ACK_MB1_CURRENT_APE_OPP);
+}
+
+/**
+ * prcmu_request_ape_opp_100_voltage - Request APE OPP 100% voltage
+ * @enable: true to request the higher voltage, false to drop a request.
+ *
+ * Calls to this function to enable and disable requests must be balanced.
+ */
+int prcmu_request_ape_opp_100_voltage(bool enable)
+{
+	int r = 0;
+	u8 header;
+	static unsigned int requests;
+
+	mutex_lock(&mb1_transfer.lock);
+
+	if (enable) {
+		if (0 != requests++)
+			goto unlock_and_return;
+		header = MB1H_REQUEST_APE_OPP_100_VOLT;
+	} else {
+		if (requests == 0) {
+			r = -EIO;
+			goto unlock_and_return;
+		} else if (1 != requests--) {
+			goto unlock_and_return;
+		}
+		header = MB1H_RELEASE_APE_OPP_100_VOLT;
+	}
+
+	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
+		cpu_relax();
+
+	writeb(header, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB1));
+
+	writel(MBOX_BIT(1), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+	wait_for_completion(&mb1_transfer.work);
+
+	if ((mb1_transfer.ack.header != header) ||
+		((mb1_transfer.ack.ape_voltage_status & BIT(0)) != 0))
+		r = -EIO;
+
+unlock_and_return:
+	mutex_unlock(&mb1_transfer.lock);
+
+	return r;
+}
+
+/**
+ * prcmu_release_usb_wakeup_state - release the state required by a USB wakeup
+ *
+ * This function releases the power state requirements of a USB wakeup.
+ */
+int prcmu_release_usb_wakeup_state(void)
+{
+	int r = 0;
+
+	mutex_lock(&mb1_transfer.lock);
+
+	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
+		cpu_relax();
+
+	writeb(MB1H_RELEASE_USB_WAKEUP,
+		(tcdm_base + PRCM_MBOX_HEADER_REQ_MB1));
+
+	writel(MBOX_BIT(1), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+	wait_for_completion(&mb1_transfer.work);
+
+	if ((mb1_transfer.ack.header != MB1H_RELEASE_USB_WAKEUP) ||
+		((mb1_transfer.ack.ape_voltage_status & BIT(0)) != 0))
+		r = -EIO;
+
+	mutex_unlock(&mb1_transfer.lock);
+
+	return r;
+}
+
+/**
+ * prcmu_set_epod - set the state of a EPOD (power domain)
+ * @epod_id: The EPOD to set
+ * @epod_state: The new EPOD state
+ *
+ * This function sets the state of a EPOD (power domain). It may not be called
+ * from interrupt context.
+ */
+int prcmu_set_epod(u16 epod_id, u8 epod_state)
+{
+	int r = 0;
+	bool ram_retention = false;
+	int i;
+
+	/* check argument */
+	BUG_ON(epod_id >= NUM_EPOD_ID);
+
+	/* set flag if retention is possible */
+	switch (epod_id) {
+	case EPOD_ID_SVAMMDSP:
+	case EPOD_ID_SIAMMDSP:
+	case EPOD_ID_ESRAM12:
+	case EPOD_ID_ESRAM34:
+		ram_retention = true;
+		break;
+	}
+
+	/* check argument */
+	BUG_ON(epod_state > EPOD_STATE_ON);
+	BUG_ON(epod_state == EPOD_STATE_RAMRET && !ram_retention);
+
+	/* get lock */
+	mutex_lock(&mb2_transfer.lock);
+
+	/* wait for mailbox */
+	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(2))
+		cpu_relax();
+
+	/* fill in mailbox */
+	for (i = 0; i < NUM_EPOD_ID; i++)
+		writeb(EPOD_STATE_NO_CHANGE, (tcdm_base + PRCM_REQ_MB2 + i));
+	writeb(epod_state, (tcdm_base + PRCM_REQ_MB2 + epod_id));
+
+	writeb(MB2H_DPS, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB2));
+
+	writel(MBOX_BIT(2), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+
+	/*
+	 * The current firmware version does not handle errors correctly,
+	 * and we cannot recover if there is an error.
+	 * This is expected to change when the firmware is updated.
+	 */
+	if (!wait_for_completion_timeout(&mb2_transfer.work,
+			msecs_to_jiffies(20000))) {
+		pr_err("prcmu: %s timed out (20 s) waiting for a reply.\n",
+			__func__);
+		r = -EIO;
+		goto unlock_and_return;
+	}
+
+	if (mb2_transfer.ack.status != HWACC_PWR_ST_OK)
+		r = -EIO;
+
+unlock_and_return:
+	mutex_unlock(&mb2_transfer.lock);
+	return r;
+}
+
+/**
+ * prcmu_configure_auto_pm - Configure autonomous power management.
+ * @sleep: Configuration for ApSleep.
+ * @idle:  Configuration for ApIdle.
+ */
+void prcmu_configure_auto_pm(struct prcmu_auto_pm_config *sleep,
+	struct prcmu_auto_pm_config *idle)
+{
+	u32 sleep_cfg;
+	u32 idle_cfg;
+	unsigned long flags;
 
-#include <mach/hardware.h>
+	BUG_ON((sleep == NULL) || (idle == NULL));
 
-#include "db8500-prcmu-regs.h"
+	sleep_cfg = (sleep->sva_auto_pm_enable & 0xF);
+	sleep_cfg = ((sleep_cfg << 4) | (sleep->sia_auto_pm_enable & 0xF));
+	sleep_cfg = ((sleep_cfg << 8) | (sleep->sva_power_on & 0xFF));
+	sleep_cfg = ((sleep_cfg << 8) | (sleep->sia_power_on & 0xFF));
+	sleep_cfg = ((sleep_cfg << 4) | (sleep->sva_policy & 0xF));
+	sleep_cfg = ((sleep_cfg << 4) | (sleep->sia_policy & 0xF));
 
-/* Global var to runtime determine TCDM base for v2 or v1 */
-static __iomem void *tcdm_base;
+	idle_cfg = (idle->sva_auto_pm_enable & 0xF);
+	idle_cfg = ((idle_cfg << 4) | (idle->sia_auto_pm_enable & 0xF));
+	idle_cfg = ((idle_cfg << 8) | (idle->sva_power_on & 0xFF));
+	idle_cfg = ((idle_cfg << 8) | (idle->sia_power_on & 0xFF));
+	idle_cfg = ((idle_cfg << 4) | (idle->sva_policy & 0xF));
+	idle_cfg = ((idle_cfg << 4) | (idle->sia_policy & 0xF));
 
-#define _MBOX_HEADER		(tcdm_base + 0xFE8)
-#define MBOX_HEADER_REQ_MB0	(_MBOX_HEADER + 0x0)
+	spin_lock_irqsave(&mb2_transfer.auto_pm_lock, flags);
 
-#define REQ_MB1 (tcdm_base + 0xFD0)
-#define REQ_MB5 (tcdm_base + 0xE44)
+	/*
+	 * The autonomous power management configuration is done through
+	 * fields in mailbox 2, but these fields are only used as shared
+	 * variables - i.e. there is no need to send a message.
+	 */
+	writel(sleep_cfg, (tcdm_base + PRCM_REQ_MB2_AUTO_PM_SLEEP));
+	writel(idle_cfg, (tcdm_base + PRCM_REQ_MB2_AUTO_PM_IDLE));
 
-#define REQ_MB1_ARMOPP		(REQ_MB1 + 0x0)
-#define REQ_MB1_APEOPP		(REQ_MB1 + 0x1)
-#define REQ_MB1_BOOSTOPP	(REQ_MB1 + 0x2)
+	mb2_transfer.auto_pm_enabled =
+		((sleep->sva_auto_pm_enable == PRCMU_AUTO_PM_ON) ||
+		 (sleep->sia_auto_pm_enable == PRCMU_AUTO_PM_ON) ||
+		 (idle->sva_auto_pm_enable == PRCMU_AUTO_PM_ON) ||
+		 (idle->sia_auto_pm_enable == PRCMU_AUTO_PM_ON));
 
-#define ACK_MB1 (tcdm_base + 0xE04)
-#define ACK_MB5 (tcdm_base + 0xDF4)
+	spin_unlock_irqrestore(&mb2_transfer.auto_pm_lock, flags);
+}
+EXPORT_SYMBOL(prcmu_configure_auto_pm);
 
-#define ACK_MB1_CURR_ARMOPP		(ACK_MB1 + 0x0)
-#define ACK_MB1_CURR_APEOPP		(ACK_MB1 + 0x1)
+bool prcmu_is_auto_pm_enabled(void)
+{
+	return mb2_transfer.auto_pm_enabled;
+}
 
-#define REQ_MB5_I2C_SLAVE_OP (REQ_MB5)
-#define REQ_MB5_I2C_HW_BITS (REQ_MB5 + 1)
-#define REQ_MB5_I2C_REG (REQ_MB5 + 2)
-#define REQ_MB5_I2C_VAL (REQ_MB5 + 3)
+static int request_sysclk(bool enable)
+{
+	int r;
+	unsigned long flags;
 
-#define ACK_MB5_I2C_STATUS (ACK_MB5 + 1)
-#define ACK_MB5_I2C_VAL (ACK_MB5 + 3)
+	r = 0;
 
-#define PRCM_AVS_VARM_MAX_OPP		(tcdm_base + 0x2E4)
-#define PRCM_AVS_ISMODEENABLE		7
-#define PRCM_AVS_ISMODEENABLE_MASK	(1 << PRCM_AVS_ISMODEENABLE)
+	mutex_lock(&mb3_transfer.sysclk_lock);
 
-#define I2C_WRITE(slave) \
-	(((slave) << 1) | (cpu_is_u8500v2() ? BIT(6) : 0))
-#define I2C_READ(slave) \
-	(((slave) << 1) | (cpu_is_u8500v2() ? BIT(6) : 0) | BIT(0))
-#define I2C_STOP_EN BIT(3)
-
-enum mb1_h {
-	MB1H_ARM_OPP = 1,
-	MB1H_APE_OPP,
-	MB1H_ARM_APE_OPP,
-};
+	spin_lock_irqsave(&mb3_transfer.lock, flags);
 
-static struct {
-	struct mutex lock;
-	struct completion work;
-	struct {
-		u8 arm_opp;
-		u8 ape_opp;
-		u8 arm_status;
-		u8 ape_status;
-	} ack;
-} mb1_transfer;
+	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(3))
+		cpu_relax();
 
-enum ack_mb5_status {
-	I2C_WR_OK = 0x01,
-	I2C_RD_OK = 0x02,
-};
+	writeb((enable ? ON : OFF), (tcdm_base + PRCM_REQ_MB3_SYSCLK_MGT));
 
-#define MBOX_BIT BIT
-#define NUM_MBOX 8
+	writeb(MB3H_SYSCLK, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB3));
+	writel(MBOX_BIT(3), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
 
-static struct {
-	struct mutex lock;
-	struct completion work;
-	bool failed;
-	struct {
-		u8 status;
-		u8 value;
-	} ack;
-} mb5_transfer;
+	spin_unlock_irqrestore(&mb3_transfer.lock, flags);
+
+	/*
+	 * The firmware only sends an ACK if we want to enable the
+	 * SysClk, and it succeeds.
+	 */
+	if (enable && !wait_for_completion_timeout(&mb3_transfer.sysclk_work,
+			msecs_to_jiffies(20000))) {
+		pr_err("prcmu: %s timed out (20 s) waiting for a reply.\n",
+			__func__);
+		r = -EIO;
+	}
+
+	mutex_unlock(&mb3_transfer.sysclk_lock);
+
+	return r;
+}
+
+static int request_timclk(bool enable)
+{
+	u32 val = (PRCM_TCR_DOZE_MODE | PRCM_TCR_TENSEL_MASK);
+
+	if (!enable)
+		val |= PRCM_TCR_STOP_TIMERS;
+	writel(val, (_PRCMU_BASE + PRCM_TCR));
+
+	return 0;
+}
+
+static int request_reg_clock(u8 clock, bool enable)
+{
+	u32 val;
+	unsigned long flags;
+
+	spin_lock_irqsave(&clk_mgt_lock, flags);
+
+	/* Grab the HW semaphore. */
+	while ((readl(_PRCMU_BASE + PRCM_SEM) & PRCM_SEM_PRCM_SEM) != 0)
+		cpu_relax();
+
+	val = readl(_PRCMU_BASE + clk_mgt[clock].offset);
+	if (enable) {
+		val |= (PRCM_CLK_MGT_CLKEN | clk_mgt[clock].pllsw);
+	} else {
+		clk_mgt[clock].pllsw = (val & PRCM_CLK_MGT_CLKPLLSW_MASK);
+		val &= ~(PRCM_CLK_MGT_CLKEN | PRCM_CLK_MGT_CLKPLLSW_MASK);
+	}
+	writel(val, (_PRCMU_BASE + clk_mgt[clock].offset));
+
+	/* Release the HW semaphore. */
+	writel(0, (_PRCMU_BASE + PRCM_SEM));
+
+	spin_unlock_irqrestore(&clk_mgt_lock, flags);
+
+	return 0;
+}
+
+/**
+ * prcmu_request_clock() - Request for a clock to be enabled or disabled.
+ * @clock:      The clock for which the request is made.
+ * @enable:     Whether the clock should be enabled (true) or disabled (false).
+ *
+ * This function should only be used by the clock implementation.
+ * Do not use it from any other place!
+ */
+int prcmu_request_clock(u8 clock, bool enable)
+{
+	if (clock < PRCMU_NUM_REG_CLOCKS)
+		return request_reg_clock(clock, enable);
+	else if (clock == PRCMU_TIMCLK)
+		return request_timclk(enable);
+	else if (clock == PRCMU_SYSCLK)
+		return request_sysclk(enable);
+	else
+		return -EINVAL;
+}
+
+int prcmu_config_esram0_deep_sleep(u8 state)
+{
+	if ((state > ESRAM0_DEEP_SLEEP_STATE_RET) ||
+	    (state < ESRAM0_DEEP_SLEEP_STATE_OFF))
+		return -EINVAL;
+
+	mutex_lock(&mb4_transfer.lock);
+
+	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
+		cpu_relax();
+
+	writeb(MB4H_MEM_ST, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB4));
+	writeb(((DDR_PWR_STATE_OFFHIGHLAT << 4) | DDR_PWR_STATE_ON),
+	       (tcdm_base + PRCM_REQ_MB4_DDR_ST_AP_SLEEP_IDLE));
+	writeb(DDR_PWR_STATE_ON,
+	       (tcdm_base + PRCM_REQ_MB4_DDR_ST_AP_DEEP_IDLE));
+	writeb(state, (tcdm_base + PRCM_REQ_MB4_ESRAM0_ST));
+
+	writel(MBOX_BIT(4), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+	wait_for_completion(&mb4_transfer.work);
+
+	mutex_unlock(&mb4_transfer.lock);
+
+	return 0;
+}
+
+int prcmu_config_hotdog(u8 threshold)
+{
+	mutex_lock(&mb4_transfer.lock);
+
+	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
+		cpu_relax();
+
+	writeb(threshold, (tcdm_base + PRCM_REQ_MB4_HOTDOG_THRESHOLD));
+	writeb(MB4H_HOTDOG, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB4));
+
+	writel(MBOX_BIT(4), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+	wait_for_completion(&mb4_transfer.work);
+
+	mutex_unlock(&mb4_transfer.lock);
+
+	return 0;
+}
+
+int prcmu_config_hotmon(u8 low, u8 high)
+{
+	mutex_lock(&mb4_transfer.lock);
+
+	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
+		cpu_relax();
+
+	writeb(low, (tcdm_base + PRCM_REQ_MB4_HOTMON_LOW));
+	writeb(high, (tcdm_base + PRCM_REQ_MB4_HOTMON_HIGH));
+	writeb((HOTMON_CONFIG_LOW | HOTMON_CONFIG_HIGH),
+		(tcdm_base + PRCM_REQ_MB4_HOTMON_CONFIG));
+	writeb(MB4H_HOTMON, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB4));
+
+	writel(MBOX_BIT(4), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+	wait_for_completion(&mb4_transfer.work);
+
+	mutex_unlock(&mb4_transfer.lock);
+
+	return 0;
+}
+
+static int config_hot_period(u16 val)
+{
+	mutex_lock(&mb4_transfer.lock);
+
+	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
+		cpu_relax();
+
+	writew(val, (tcdm_base + PRCM_REQ_MB4_HOT_PERIOD));
+	writeb(MB4H_HOT_PERIOD, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB4));
+
+	writel(MBOX_BIT(4), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+	wait_for_completion(&mb4_transfer.work);
+
+	mutex_unlock(&mb4_transfer.lock);
+
+	return 0;
+}
+
+int prcmu_start_temp_sense(u16 cycles32k)
+{
+	if (cycles32k == 0xFFFF)
+		return -EINVAL;
+
+	return config_hot_period(cycles32k);
+}
+
+int prcmu_stop_temp_sense(void)
+{
+	return config_hot_period(0xFFFF);
+}
+
+/**
+ * prcmu_set_clock_divider() - Configure the clock divider.
+ * @clock:	The clock for which the request is made.
+ * @divider:	The clock divider. (< 32)
+ *
+ * This function should only be used by the clock implementation.
+ * Do not use it from any other place!
+ */
+int prcmu_set_clock_divider(u8 clock, u8 divider)
+{
+	u32 val;
+	unsigned long flags;
+
+	if ((clock >= PRCMU_NUM_REG_CLOCKS) || (divider < 1) || (31 < divider))
+		return -EINVAL;
+
+	spin_lock_irqsave(&clk_mgt_lock, flags);
+
+	/* Grab the HW semaphore. */
+	while ((readl(_PRCMU_BASE + PRCM_SEM) & PRCM_SEM_PRCM_SEM) != 0)
+		cpu_relax();
+
+	val = readl(_PRCMU_BASE + clk_mgt[clock].offset);
+	val &= ~(PRCM_CLK_MGT_CLKPLLDIV_MASK);
+	val |= (u32)divider;
+	writel(val, (_PRCMU_BASE + clk_mgt[clock].offset));
+
+	/* Release the HW semaphore. */
+	writel(0, (_PRCMU_BASE + PRCM_SEM));
+
+	spin_unlock_irqrestore(&clk_mgt_lock, flags);
+
+	return 0;
+}
 
 /**
  * prcmu_abb_read() - Read register value(s) from the ABB.
@@ -115,33 +1376,34 @@ int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
 	if (size != 1)
 		return -EINVAL;
 
-	r = mutex_lock_interruptible(&mb5_transfer.lock);
-	if (r)
-		return r;
+	mutex_lock(&mb5_transfer.lock);
 
-	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(5))
+	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(5))
 		cpu_relax();
 
-	writeb(I2C_READ(slave), REQ_MB5_I2C_SLAVE_OP);
-	writeb(I2C_STOP_EN, REQ_MB5_I2C_HW_BITS);
-	writeb(reg, REQ_MB5_I2C_REG);
+	writeb(PRCMU_I2C_READ(slave), (tcdm_base + PRCM_REQ_MB5_I2C_SLAVE_OP));
+	writeb(PRCMU_I2C_STOP_EN, (tcdm_base + PRCM_REQ_MB5_I2C_HW_BITS));
+	writeb(reg, (tcdm_base + PRCM_REQ_MB5_I2C_REG));
+	writeb(0, (tcdm_base + PRCM_REQ_MB5_I2C_VAL));
+
+	writel(MBOX_BIT(5), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
 
-	writel(MBOX_BIT(5), PRCM_MBOX_CPU_SET);
 	if (!wait_for_completion_timeout(&mb5_transfer.work,
-			msecs_to_jiffies(500))) {
-		pr_err("prcmu: prcmu_abb_read timed out.\n");
+				msecs_to_jiffies(20000))) {
+		pr_err("prcmu: %s timed out (20 s) waiting for a reply.\n",
+			__func__);
 		r = -EIO;
-		goto unlock_and_return;
+	} else {
+		r = ((mb5_transfer.ack.status == I2C_RD_OK) ? 0 : -EIO);
 	}
-	r = ((mb5_transfer.ack.status == I2C_RD_OK) ? 0 : -EIO);
+
 	if (!r)
 		*value = mb5_transfer.ack.value;
 
-unlock_and_return:
 	mutex_unlock(&mb5_transfer.lock);
+
 	return r;
 }
-EXPORT_SYMBOL(prcmu_abb_read);
 
 /**
  * prcmu_abb_write() - Write register value(s) to the ABB.
@@ -160,179 +1422,262 @@ int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
 	if (size != 1)
 		return -EINVAL;
 
-	r = mutex_lock_interruptible(&mb5_transfer.lock);
-	if (r)
-		return r;
+	mutex_lock(&mb5_transfer.lock);
 
-
-	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(5))
+	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(5))
 		cpu_relax();
 
-	writeb(I2C_WRITE(slave), REQ_MB5_I2C_SLAVE_OP);
-	writeb(I2C_STOP_EN, REQ_MB5_I2C_HW_BITS);
-	writeb(reg, REQ_MB5_I2C_REG);
-	writeb(*value, REQ_MB5_I2C_VAL);
+	writeb(PRCMU_I2C_WRITE(slave), (tcdm_base + PRCM_REQ_MB5_I2C_SLAVE_OP));
+	writeb(PRCMU_I2C_STOP_EN, (tcdm_base + PRCM_REQ_MB5_I2C_HW_BITS));
+	writeb(reg, (tcdm_base + PRCM_REQ_MB5_I2C_REG));
+	writeb(*value, (tcdm_base + PRCM_REQ_MB5_I2C_VAL));
+
+	writel(MBOX_BIT(5), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
 
-	writel(MBOX_BIT(5), PRCM_MBOX_CPU_SET);
 	if (!wait_for_completion_timeout(&mb5_transfer.work,
-			msecs_to_jiffies(500))) {
-		pr_err("prcmu: prcmu_abb_write timed out.\n");
+				msecs_to_jiffies(20000))) {
+		pr_err("prcmu: %s timed out (20 s) waiting for a reply.\n",
+			__func__);
 		r = -EIO;
-		goto unlock_and_return;
+	} else {
+		r = ((mb5_transfer.ack.status == I2C_WR_OK) ? 0 : -EIO);
 	}
-	r = ((mb5_transfer.ack.status == I2C_WR_OK) ? 0 : -EIO);
 
-unlock_and_return:
 	mutex_unlock(&mb5_transfer.lock);
+
 	return r;
 }
-EXPORT_SYMBOL(prcmu_abb_write);
 
-static int set_ape_cpu_opps(u8 header, enum prcmu_ape_opp ape_opp,
-			    enum prcmu_cpu_opp cpu_opp)
+/**
+ * prcmu_ac_wake_req - should be called whenever ARM wants to wakeup Modem
+ */
+void prcmu_ac_wake_req(void)
 {
-	bool do_ape;
-	bool do_arm;
-	int err = 0;
+	u32 val;
 
-	do_ape = ((header == MB1H_APE_OPP) || (header == MB1H_ARM_APE_OPP));
-	do_arm = ((header == MB1H_ARM_OPP) || (header == MB1H_ARM_APE_OPP));
+	mutex_lock(&mb0_transfer.ac_wake_lock);
 
-	mutex_lock(&mb1_transfer.lock);
+	val = readl(_PRCMU_BASE + PRCM_HOSTACCESS_REQ);
+	if (val & PRCM_HOSTACCESS_REQ_HOSTACCESS_REQ)
+		goto unlock_and_return;
 
-	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
-		cpu_relax();
+	atomic_set(&ac_wake_req_state, 1);
 
-	writeb(0, MBOX_HEADER_REQ_MB0);
-	writeb(cpu_opp, REQ_MB1_ARMOPP);
-	writeb(ape_opp, REQ_MB1_APEOPP);
-	writeb(0, REQ_MB1_BOOSTOPP);
-	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
-	wait_for_completion(&mb1_transfer.work);
-	if ((do_ape) && (mb1_transfer.ack.ape_status != 0))
-		err = -EIO;
-	if ((do_arm) && (mb1_transfer.ack.arm_status != 0))
-		err = -EIO;
+	writel((val | PRCM_HOSTACCESS_REQ_HOSTACCESS_REQ),
+		(_PRCMU_BASE + PRCM_HOSTACCESS_REQ));
 
-	mutex_unlock(&mb1_transfer.lock);
+	if (!wait_for_completion_timeout(&mb0_transfer.ac_wake_work,
+			msecs_to_jiffies(20000))) {
+		pr_err("prcmu: %s timed out (20 s) waiting for a reply.\n",
+			__func__);
+	}
 
-	return err;
+unlock_and_return:
+	mutex_unlock(&mb0_transfer.ac_wake_lock);
 }
 
 /**
- * prcmu_set_ape_opp() - Set the OPP of the APE.
- * @opp:	The OPP to set.
- *
- * This function sets the OPP of the APE.
+ * prcmu_ac_sleep_req - called when ARM no longer needs to talk to modem
  */
-int prcmu_set_ape_opp(enum prcmu_ape_opp opp)
+void prcmu_ac_sleep_req()
 {
-	return set_ape_cpu_opps(MB1H_APE_OPP, opp, APE_OPP_NO_CHANGE);
+	u32 val;
+
+	mutex_lock(&mb0_transfer.ac_wake_lock);
+
+	val = readl(_PRCMU_BASE + PRCM_HOSTACCESS_REQ);
+	if (!(val & PRCM_HOSTACCESS_REQ_HOSTACCESS_REQ))
+		goto unlock_and_return;
+
+	writel((val & ~PRCM_HOSTACCESS_REQ_HOSTACCESS_REQ),
+		(_PRCMU_BASE + PRCM_HOSTACCESS_REQ));
+
+	if (!wait_for_completion_timeout(&mb0_transfer.ac_wake_work,
+			msecs_to_jiffies(20000))) {
+		pr_err("prcmu: %s timed out (20 s) waiting for a reply.\n",
+			__func__);
+	}
+
+	atomic_set(&ac_wake_req_state, 0);
+
+unlock_and_return:
+	mutex_unlock(&mb0_transfer.ac_wake_lock);
 }
-EXPORT_SYMBOL(prcmu_set_ape_opp);
 
-/**
- * prcmu_set_cpu_opp() - Set the OPP of the CPU.
- * @opp:	The OPP to set.
- *
- * This function sets the OPP of the CPU.
- */
-int prcmu_set_cpu_opp(enum prcmu_cpu_opp opp)
+bool prcmu_is_ac_wake_requested(void)
 {
-	return set_ape_cpu_opps(MB1H_ARM_OPP, CPU_OPP_NO_CHANGE, opp);
+	return (atomic_read(&ac_wake_req_state) != 0);
 }
-EXPORT_SYMBOL(prcmu_set_cpu_opp);
 
 /**
- * prcmu_set_ape_cpu_opps() - Set the OPPs of the APE and the CPU.
- * @ape_opp:	The APE OPP to set.
- * @cpu_opp:	The CPU OPP to set.
+ * prcmu_system_reset - System reset
  *
- * This function sets the OPPs of the APE and the CPU.
+ * Saves the reset reason code and then sets the APE_SOFRST register which
+ * fires interrupt to fw
  */
-int prcmu_set_ape_cpu_opps(enum prcmu_ape_opp ape_opp,
-			   enum prcmu_cpu_opp cpu_opp)
+void prcmu_system_reset(u16 reset_code)
 {
-	return set_ape_cpu_opps(MB1H_ARM_APE_OPP, ape_opp, cpu_opp);
+	writew(reset_code, (tcdm_base + PRCM_SW_RST_REASON));
+	writel(1, (_PRCMU_BASE + PRCM_APE_SOFTRST));
 }
-EXPORT_SYMBOL(prcmu_set_ape_cpu_opps);
 
 /**
- * prcmu_get_ape_opp() - Get the OPP of the APE.
- *
- * This function gets the OPP of the APE.
+ * prcmu_reset_modem - ask the PRCMU to reset modem
  */
-enum prcmu_ape_opp prcmu_get_ape_opp(void)
+void prcmu_modem_reset(void)
 {
-	return readb(ACK_MB1_CURR_APEOPP);
+	mutex_lock(&mb1_transfer.lock);
+
+	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
+		cpu_relax();
+
+	writeb(MB1H_RESET_MODEM, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB1));
+	writel(MBOX_BIT(1), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+	wait_for_completion(&mb1_transfer.work);
+
+	/*
+	 * No need to check return from PRCMU as modem should go in reset state
+	 * This state is already managed by upper layer
+	 */
+
+	mutex_unlock(&mb1_transfer.lock);
 }
-EXPORT_SYMBOL(prcmu_get_ape_opp);
 
-/**
- * prcmu_get_cpu_opp() - Get the OPP of the CPU.
- *
- * This function gets the OPP of the CPU. The OPP is specified in %%.
- * PRCMU_OPP_EXT is a special OPP value, not specified in %%.
- */
-int prcmu_get_cpu_opp(void)
+static void ack_dbb_wakeup(void)
 {
-	return readb(ACK_MB1_CURR_ARMOPP);
+	unsigned long flags;
+
+	spin_lock_irqsave(&mb0_transfer.lock, flags);
+
+	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(0))
+		cpu_relax();
+
+	writeb(MB0H_READ_WAKEUP_ACK, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB0));
+	writel(MBOX_BIT(0), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+
+	spin_unlock_irqrestore(&mb0_transfer.lock, flags);
 }
-EXPORT_SYMBOL(prcmu_get_cpu_opp);
 
-bool prcmu_has_arm_maxopp(void)
+static inline void print_unknown_header_warning(u8 n, u8 header)
 {
-	return (readb(PRCM_AVS_VARM_MAX_OPP) & PRCM_AVS_ISMODEENABLE_MASK)
-		== PRCM_AVS_ISMODEENABLE_MASK;
+	pr_warning("prcmu: Unknown message header (%d) in mailbox %d.\n",
+		header, n);
 }
 
-static void read_mailbox_0(void)
+static bool read_mailbox_0(void)
 {
-	writel(MBOX_BIT(0), PRCM_ARM_IT1_CLEAR);
+	bool r;
+	u32 ev;
+	unsigned int n;
+	u8 header;
+
+	header = readb(tcdm_base + PRCM_MBOX_HEADER_ACK_MB0);
+	switch (header) {
+	case MB0H_WAKEUP_EXE:
+	case MB0H_WAKEUP_SLEEP:
+		if (readb(tcdm_base + PRCM_ACK_MB0_READ_POINTER) & 1)
+			ev = readl(tcdm_base + PRCM_ACK_MB0_WAKEUP_1_8500);
+		else
+			ev = readl(tcdm_base + PRCM_ACK_MB0_WAKEUP_0_8500);
+
+		if (ev & (WAKEUP_BIT_AC_WAKE_ACK | WAKEUP_BIT_AC_SLEEP_ACK))
+			complete(&mb0_transfer.ac_wake_work);
+		if (ev & WAKEUP_BIT_SYSCLK_OK)
+			complete(&mb3_transfer.sysclk_work);
+
+		ev &= mb0_transfer.req.dbb_irqs;
+
+		for (n = 0; n < NUM_PRCMU_WAKEUPS; n++) {
+			if (ev & prcmu_irq_bit[n])
+				generic_handle_irq(IRQ_PRCMU_BASE + n);
+		}
+		r = true;
+		break;
+	default:
+		print_unknown_header_warning(0, header);
+		r = false;
+		break;
+	}
+	writel(MBOX_BIT(0), (_PRCMU_BASE + PRCM_ARM_IT1_CLR));
+	return r;
 }
 
-static void read_mailbox_1(void)
+static bool read_mailbox_1(void)
 {
-	mb1_transfer.ack.arm_opp = readb(ACK_MB1_CURR_ARMOPP);
-	mb1_transfer.ack.ape_opp = readb(ACK_MB1_CURR_APEOPP);
+	mb1_transfer.ack.header = readb(tcdm_base + PRCM_MBOX_HEADER_REQ_MB1);
+	mb1_transfer.ack.arm_opp = readb(tcdm_base +
+		PRCM_ACK_MB1_CURRENT_ARM_OPP);
+	mb1_transfer.ack.ape_opp = readb(tcdm_base +
+		PRCM_ACK_MB1_CURRENT_APE_OPP);
+	mb1_transfer.ack.ape_voltage_status = readb(tcdm_base +
+		PRCM_ACK_MB1_APE_VOLTAGE_STATUS);
+	writel(MBOX_BIT(1), (_PRCMU_BASE + PRCM_ARM_IT1_CLR));
 	complete(&mb1_transfer.work);
-	writel(MBOX_BIT(1), PRCM_ARM_IT1_CLEAR);
+	return false;
 }
 
-static void read_mailbox_2(void)
+static bool read_mailbox_2(void)
 {
-	writel(MBOX_BIT(2), PRCM_ARM_IT1_CLEAR);
+	mb2_transfer.ack.status = readb(tcdm_base + PRCM_ACK_MB2_DPS_STATUS);
+	writel(MBOX_BIT(2), (_PRCMU_BASE + PRCM_ARM_IT1_CLR));
+	complete(&mb2_transfer.work);
+	return false;
 }
 
-static void read_mailbox_3(void)
+static bool read_mailbox_3(void)
 {
-	writel(MBOX_BIT(3), PRCM_ARM_IT1_CLEAR);
+	writel(MBOX_BIT(3), (_PRCMU_BASE + PRCM_ARM_IT1_CLR));
+	return false;
 }
 
-static void read_mailbox_4(void)
+static bool read_mailbox_4(void)
 {
-	writel(MBOX_BIT(4), PRCM_ARM_IT1_CLEAR);
+	u8 header;
+	bool do_complete = true;
+
+	header = readb(tcdm_base + PRCM_MBOX_HEADER_REQ_MB4);
+	switch (header) {
+	case MB4H_MEM_ST:
+	case MB4H_HOTDOG:
+	case MB4H_HOTMON:
+	case MB4H_HOT_PERIOD:
+		break;
+	default:
+		print_unknown_header_warning(4, header);
+		do_complete = false;
+		break;
+	}
+
+	writel(MBOX_BIT(4), (_PRCMU_BASE + PRCM_ARM_IT1_CLR));
+
+	if (do_complete)
+		complete(&mb4_transfer.work);
+
+	return false;
 }
 
-static void read_mailbox_5(void)
+static bool read_mailbox_5(void)
 {
-	mb5_transfer.ack.status = readb(ACK_MB5_I2C_STATUS);
-	mb5_transfer.ack.value = readb(ACK_MB5_I2C_VAL);
+	mb5_transfer.ack.status = readb(tcdm_base + PRCM_ACK_MB5_I2C_STATUS);
+	mb5_transfer.ack.value = readb(tcdm_base + PRCM_ACK_MB5_I2C_VAL);
+	writel(MBOX_BIT(5), (_PRCMU_BASE + PRCM_ARM_IT1_CLR));
 	complete(&mb5_transfer.work);
-	writel(MBOX_BIT(5), PRCM_ARM_IT1_CLEAR);
+	return false;
 }
 
-static void read_mailbox_6(void)
+static bool read_mailbox_6(void)
 {
-	writel(MBOX_BIT(6), PRCM_ARM_IT1_CLEAR);
+	writel(MBOX_BIT(6), (_PRCMU_BASE + PRCM_ARM_IT1_CLR));
+	return false;
 }
 
-static void read_mailbox_7(void)
+static bool read_mailbox_7(void)
 {
-	writel(MBOX_BIT(7), PRCM_ARM_IT1_CLEAR);
+	writel(MBOX_BIT(7), (_PRCMU_BASE + PRCM_ARM_IT1_CLR));
+	return false;
 }
 
-static void (* const read_mailbox[NUM_MBOX])(void) = {
+static bool (* const read_mailbox[NUM_MB])(void) = {
 	read_mailbox_0,
 	read_mailbox_1,
 	read_mailbox_2,
@@ -347,49 +1692,199 @@ static irqreturn_t prcmu_irq_handler(int irq, void *data)
 {
 	u32 bits;
 	u8 n;
+	irqreturn_t r;
 
-	bits = (readl(PRCM_ARM_IT1_VAL) & (MBOX_BIT(NUM_MBOX) - 1));
+	bits = (readl(_PRCMU_BASE + PRCM_ARM_IT1_VAL) & ALL_MBOX_BITS);
 	if (unlikely(!bits))
 		return IRQ_NONE;
 
+	r = IRQ_HANDLED;
 	for (n = 0; bits; n++) {
 		if (bits & MBOX_BIT(n)) {
 			bits -= MBOX_BIT(n);
-			read_mailbox[n]();
+			if (read_mailbox[n]())
+				r = IRQ_WAKE_THREAD;
 		}
 	}
+	return r;
+}
+
+static irqreturn_t prcmu_irq_thread_fn(int irq, void *data)
+{
+	ack_dbb_wakeup();
 	return IRQ_HANDLED;
 }
 
+static void prcmu_mask_work(struct work_struct *work)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mb0_transfer.lock, flags);
+
+	config_wakeups();
+
+	spin_unlock_irqrestore(&mb0_transfer.lock, flags);
+}
+
+static void prcmu_irq_mask(struct irq_data *d)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mb0_transfer.dbb_irqs_lock, flags);
+
+	mb0_transfer.req.dbb_irqs &= ~prcmu_irq_bit[d->irq - IRQ_PRCMU_BASE];
+
+	spin_unlock_irqrestore(&mb0_transfer.dbb_irqs_lock, flags);
+
+	if (d->irq != IRQ_PRCMU_CA_SLEEP)
+		schedule_work(&mb0_transfer.mask_work);
+}
+
+static void prcmu_irq_unmask(struct irq_data *d)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mb0_transfer.dbb_irqs_lock, flags);
+
+	mb0_transfer.req.dbb_irqs |= prcmu_irq_bit[d->irq - IRQ_PRCMU_BASE];
+
+	spin_unlock_irqrestore(&mb0_transfer.dbb_irqs_lock, flags);
+
+	if (d->irq != IRQ_PRCMU_CA_SLEEP)
+		schedule_work(&mb0_transfer.mask_work);
+}
+
+static void noop(struct irq_data *d)
+{
+}
+
+static struct irq_chip prcmu_irq_chip = {
+	.name		= "prcmu",
+	.irq_disable	= prcmu_irq_mask,
+	.irq_ack	= noop,
+	.irq_mask	= prcmu_irq_mask,
+	.irq_unmask	= prcmu_irq_unmask,
+};
+
 void __init prcmu_early_init(void)
 {
-	if (cpu_is_u8500v11() || cpu_is_u8500ed()) {
+	unsigned int i;
+
+	if (cpu_is_u8500v1()) {
 		tcdm_base = __io_address(U8500_PRCMU_TCDM_BASE_V1);
 	} else if (cpu_is_u8500v2()) {
+		void *tcpm_base = ioremap_nocache(U8500_PRCMU_TCPM_BASE, SZ_4K);
+
+		if (tcpm_base != NULL) {
+			int version;
+			version = readl(tcpm_base + PRCMU_FW_VERSION_OFFSET);
+			prcmu_version.project_number = version & 0xFF;
+			prcmu_version.api_version = (version >> 8) & 0xFF;
+			prcmu_version.func_version = (version >> 16) & 0xFF;
+			prcmu_version.errata = (version >> 24) & 0xFF;
+			pr_info("PRCMU firmware version %d.%d.%d\n",
+				(version >> 8) & 0xFF, (version >> 16) & 0xFF,
+				(version >> 24) & 0xFF);
+			iounmap(tcpm_base);
+		}
+
 		tcdm_base = __io_address(U8500_PRCMU_TCDM_BASE);
 	} else {
 		pr_err("prcmu: Unsupported chip version\n");
 		BUG();
 	}
-}
-
-static int __init prcmu_init(void)
-{
-	if (cpu_is_u8500ed()) {
-		pr_err("prcmu: Unsupported chip version\n");
-		return 0;
-	}
 
+	spin_lock_init(&mb0_transfer.lock);
+	spin_lock_init(&mb0_transfer.dbb_irqs_lock);
+	mutex_init(&mb0_transfer.ac_wake_lock);
+	init_completion(&mb0_transfer.ac_wake_work);
 	mutex_init(&mb1_transfer.lock);
 	init_completion(&mb1_transfer.work);
+	mutex_init(&mb2_transfer.lock);
+	init_completion(&mb2_transfer.work);
+	spin_lock_init(&mb2_transfer.auto_pm_lock);
+	spin_lock_init(&mb3_transfer.lock);
+	mutex_init(&mb3_transfer.sysclk_lock);
+	init_completion(&mb3_transfer.sysclk_work);
+	mutex_init(&mb4_transfer.lock);
+	init_completion(&mb4_transfer.work);
 	mutex_init(&mb5_transfer.lock);
 	init_completion(&mb5_transfer.work);
 
+	INIT_WORK(&mb0_transfer.mask_work, prcmu_mask_work);
+
+	/* Initalize irqs. */
+	for (i = 0; i < NUM_PRCMU_WAKEUPS; i++) {
+		unsigned int irq;
+
+		irq = IRQ_PRCMU_BASE + i;
+		irq_set_chip_and_handler(irq, &prcmu_irq_chip,
+					 handle_simple_irq);
+		set_irq_flags(irq, IRQF_VALID);
+	}
+}
+
+static struct mfd_cell db8500_prcmu_devs[] = {
+	{
+		.name = "db8500-prcmu-regulators",
+	},
+	{
+		.name = "cpufreq-u8500",
+	},
+};
+
+/**
+ * prcmu_fw_init - arch init call for the Linux PRCMU fw init logic
+ *
+ */
+static int __init db8500_prcmu_probe(struct platform_device *pdev)
+{
+	int err = 0;
+
+	if (ux500_is_svp())
+		return -ENODEV;
+
 	/* Clean up the mailbox interrupts after pre-kernel code. */
-	writel((MBOX_BIT(NUM_MBOX) - 1), PRCM_ARM_IT1_CLEAR);
+	writel(ALL_MBOX_BITS, (_PRCMU_BASE + PRCM_ARM_IT1_CLR));
+
+	err = request_threaded_irq(IRQ_DB8500_PRCMU1, prcmu_irq_handler,
+		prcmu_irq_thread_fn, IRQF_NO_SUSPEND, "prcmu", NULL);
+	if (err < 0) {
+		pr_err("prcmu: Failed to allocate IRQ_DB8500_PRCMU1.\n");
+		err = -EBUSY;
+		goto no_irq_return;
+	}
+
+	if (cpu_is_u8500v20_or_later())
+		prcmu_config_esram0_deep_sleep(ESRAM0_DEEP_SLEEP_STATE_RET);
+
+	err = mfd_add_devices(&pdev->dev, 0, db8500_prcmu_devs,
+			      ARRAY_SIZE(db8500_prcmu_devs), NULL,
+			      0);
 
-	return request_irq(IRQ_DB8500_PRCMU1, prcmu_irq_handler, 0,
-			   "prcmu", NULL);
+	if (err)
+		pr_err("prcmu: Failed to add subdevices\n");
+	else
+		pr_info("DB8500 PRCMU initialized\n");
+
+no_irq_return:
+	return err;
+}
+
+static struct platform_driver db8500_prcmu_driver = {
+	.driver = {
+		.name = "db8500-prcmu",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init db8500_prcmu_init(void)
+{
+	return platform_driver_probe(&db8500_prcmu_driver, db8500_prcmu_probe);
 }
 
-arch_initcall(prcmu_init);
+arch_initcall(db8500_prcmu_init);
+
+MODULE_AUTHOR("Mattias Nilsson <mattias.i.nilsson@stericsson.com>");
+MODULE_DESCRIPTION("DB8500 PRCM Unit driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mfd/db8500-prcmu.h b/include/linux/mfd/db8500-prcmu.h
index d591d79..917dbcab 100644
--- a/include/linux/mfd/db8500-prcmu.h
+++ b/include/linux/mfd/db8500-prcmu.h
@@ -2,57 +2,977 @@
  * Copyright (C) STMicroelectronics 2009
  * Copyright (C) ST-Ericsson SA 2010
  *
- * Author: Sundar Iyer <sundar.iyer@stericsson.com>
- * Author: Martin Persson <martin.persson@stericsson.com>
- *
  * License Terms: GNU General Public License v2
+ * Author: Kumar Sanghvi <kumar.sanghvi@stericsson.com>
  *
- * PRCM Unit definitions
+ * PRCMU f/w APIs
  */
+#ifndef __MFD_DB8500_PRCMU_H
+#define __MFD_DB8500_PRCMU_H
+
+#include <linux/interrupt.h>
+#include <linux/notifier.h>
 
-#ifndef __MACH_PRCMU_DEFS_H
-#define __MACH_PRCMU_DEFS_H
+/* This portion previously known as <mach/prcmu-fw-defs_v1.h> */
 
-enum prcmu_cpu_opp {
-	CPU_OPP_INIT	  = 0x00,
-	CPU_OPP_NO_CHANGE = 0x01,
-	CPU_OPP_100	  = 0x02,
-	CPU_OPP_50	  = 0x03,
-	CPU_OPP_MAX	  = 0x04,
-	CPU_OPP_EXT_CLK	  = 0x07
+/**
+ * enum state - ON/OFF state definition
+ * @OFF: State is ON
+ * @ON: State is OFF
+ *
+ */
+enum state {
+	OFF = 0x0,
+	ON  = 0x1,
 };
-enum prcmu_ape_opp {
-	APE_OPP_NO_CHANGE = 0x00,
-	APE_OPP_100	  = 0x02,
-	APE_OPP_50	  = 0x03,
+
+/**
+ * enum ret_state - general purpose On/Off/Retention states
+ *
+ */
+enum ret_state {
+	OFFST = 0,
+	ONST  = 1,
+	RETST = 2
 };
 
-#endif /* __MACH_PRCMU_DEFS_H */
+/**
+ * enum clk_arm - ARM Cortex A9 clock schemes
+ * @A9_OFF:
+ * @A9_BOOT:
+ * @A9_OPPT1:
+ * @A9_OPPT2:
+ * @A9_EXTCLK:
+ */
+enum clk_arm {
+	A9_OFF,
+	A9_BOOT,
+	A9_OPPT1,
+	A9_OPPT2,
+	A9_EXTCLK
+};
 
-/*
- * Copyright (C) STMicroelectronics 2009
- * Copyright (C) ST-Ericsson SA 2010
+/**
+ * enum clk_gen - GEN#0/GEN#1 clock schemes
+ * @GEN_OFF:
+ * @GEN_BOOT:
+ * @GEN_OPPT1:
+ */
+enum clk_gen {
+	GEN_OFF,
+	GEN_BOOT,
+	GEN_OPPT1,
+};
+
+/* some information between arm and xp70 */
+
+/**
+ * enum romcode_write - Romcode message written by A9 AND read by XP70
+ * @RDY_2_DS: Value set when ApDeepSleep state can be executed by XP70
+ * @RDY_2_XP70_RST: Value set when 0x0F has been successfully polled by the
+ *                 romcode. The xp70 will go into self-reset
+ */
+enum romcode_write {
+	RDY_2_DS = 0x09,
+	RDY_2_XP70_RST = 0x10
+};
+
+/**
+ * enum romcode_read - Romcode message written by XP70 and read by A9
+ * @INIT: Init value when romcode field is not used
+ * @FS_2_DS: Value set when power state is going from ApExecute to
+ *          ApDeepSleep
+ * @END_DS: Value set when ApDeepSleep power state is reached coming from
+ *         ApExecute state
+ * @DS_TO_FS: Value set when power state is going from ApDeepSleep to
+ *           ApExecute
+ * @END_FS: Value set when ApExecute power state is reached coming from
+ *         ApDeepSleep state
+ * @SWR: Value set when power state is going to ApReset
+ * @END_SWR: Value set when the xp70 finished executing ApReset actions and
+ *          waits for romcode acknowledgment to go to self-reset
+ */
+enum romcode_read {
+	INIT = 0x00,
+	FS_2_DS = 0x0A,
+	END_DS = 0x0B,
+	DS_TO_FS = 0x0C,
+	END_FS = 0x0D,
+	SWR = 0x0E,
+	END_SWR = 0x0F
+};
+
+/**
+ * enum ap_pwrst - current power states defined in PRCMU firmware
+ * @NO_PWRST: Current power state init
+ * @AP_BOOT: Current power state is apBoot
+ * @AP_EXECUTE: Current power state is apExecute
+ * @AP_DEEP_SLEEP: Current power state is apDeepSleep
+ * @AP_SLEEP: Current power state is apSleep
+ * @AP_IDLE: Current power state is apIdle
+ * @AP_RESET: Current power state is apReset
+ */
+enum ap_pwrst {
+	NO_PWRST = 0x00,
+	AP_BOOT = 0x01,
+	AP_EXECUTE = 0x02,
+	AP_DEEP_SLEEP = 0x03,
+	AP_SLEEP = 0x04,
+	AP_IDLE = 0x05,
+	AP_RESET = 0x06
+};
+
+/**
+ * enum ap_pwrst_trans - Transition states defined in PRCMU firmware
+ * @NO_TRANSITION: No power state transition
+ * @APEXECUTE_TO_APSLEEP: Power state transition from ApExecute to ApSleep
+ * @APIDLE_TO_APSLEEP: Power state transition from ApIdle to ApSleep
+ * @APBOOT_TO_APEXECUTE: Power state transition from ApBoot to ApExecute
+ * @APEXECUTE_TO_APDEEPSLEEP: Power state transition from ApExecute to
+ *                          ApDeepSleep
+ * @APEXECUTE_TO_APIDLE: Power state transition from ApExecute to ApIdle
+ */
+enum ap_pwrst_trans {
+	NO_TRANSITION			= 0x00,
+	APEXECUTE_TO_APSLEEP		= 0x01,
+	APIDLE_TO_APSLEEP		= 0x02, /* To be removed */
+	PRCMU_AP_SLEEP			= 0x01,
+	APBOOT_TO_APEXECUTE		= 0x03,
+	APEXECUTE_TO_APDEEPSLEEP	= 0x04, /* To be removed */
+	PRCMU_AP_DEEP_SLEEP		= 0x04,
+	APEXECUTE_TO_APIDLE		= 0x05, /* To be removed */
+	PRCMU_AP_IDLE			= 0x05,
+	PRCMU_AP_DEEP_IDLE		= 0x07,
+};
+
+/**
+ * enum ddr_pwrst - DDR power states definition
+ * @DDR_PWR_STATE_UNCHANGED: SDRAM and DDR controller state is unchanged
+ * @DDR_PWR_STATE_ON:
+ * @DDR_PWR_STATE_OFFLOWLAT:
+ * @DDR_PWR_STATE_OFFHIGHLAT:
+ */
+enum ddr_pwrst {
+	DDR_PWR_STATE_UNCHANGED     = 0x00,
+	DDR_PWR_STATE_ON            = 0x01,
+	DDR_PWR_STATE_OFFLOWLAT     = 0x02,
+	DDR_PWR_STATE_OFFHIGHLAT    = 0x03
+};
+
+/**
+ * enum arm_opp - ARM OPP states definition
+ * @ARM_OPP_INIT:
+ * @ARM_NO_CHANGE: The ARM operating point is unchanged
+ * @ARM_100_OPP: The new ARM operating point is arm100opp
+ * @ARM_50_OPP: The new ARM operating point is arm50opp
+ * @ARM_MAX_OPP: Operating point is "max" (more than 100)
+ * @ARM_MAX_FREQ100OPP: Set max opp if available, else 100
+ * @ARM_EXTCLK: The new ARM operating point is armExtClk
+ */
+enum arm_opp {
+	ARM_OPP_INIT = 0x00,
+	ARM_NO_CHANGE = 0x01,
+	ARM_100_OPP = 0x02,
+	ARM_50_OPP = 0x03,
+	ARM_MAX_OPP = 0x04,
+	ARM_MAX_FREQ100OPP = 0x05,
+	ARM_EXTCLK = 0x07
+};
+
+/**
+ * enum ape_opp - APE OPP states definition
+ * @APE_OPP_INIT:
+ * @APE_NO_CHANGE: The APE operating point is unchanged
+ * @APE_100_OPP: The new APE operating point is ape100opp
+ * @APE_50_OPP: 50%
+ */
+enum ape_opp {
+	APE_OPP_INIT = 0x00,
+	APE_NO_CHANGE = 0x01,
+	APE_100_OPP = 0x02,
+	APE_50_OPP = 0x03
+};
+
+/**
+ * enum hw_acc_state - State definition for hardware accelerator
+ * @HW_NO_CHANGE: The hardware accelerator state must remain unchanged
+ * @HW_OFF: The hardware accelerator must be switched off
+ * @HW_OFF_RAMRET: The hardware accelerator must be switched off with its
+ *               internal RAM in retention
+ * @HW_ON: The hwa hardware accelerator hwa must be switched on
  *
- * Author: Kumar Sanghvi <kumar.sanghvi@stericsson.com>
- * Author: Sundar Iyer <sundar.iyer@stericsson.com>
- * Author: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
+ * NOTE! Deprecated, to be removed when all users switched over to use the
+ * regulator API.
+ */
+enum hw_acc_state {
+	HW_NO_CHANGE = 0x00,
+	HW_OFF = 0x01,
+	HW_OFF_RAMRET = 0x02,
+	HW_ON = 0x04
+};
+
+/**
+ * enum  mbox_2_arm_stat - Status messages definition for mbox_arm
+ * @BOOT_TO_EXECUTEOK: The apBoot to apExecute state transition has been
+ *                    completed
+ * @DEEPSLEEPOK: The apExecute to apDeepSleep state transition has been
+ *              completed
+ * @SLEEPOK: The apExecute to apSleep state transition has been completed
+ * @IDLEOK: The apExecute to apIdle state transition has been completed
+ * @SOFTRESETOK: The A9 watchdog/ SoftReset state has been completed
+ * @SOFTRESETGO : The A9 watchdog/SoftReset state is on going
+ * @BOOT_TO_EXECUTE: The apBoot to apExecute state transition is on going
+ * @EXECUTE_TO_DEEPSLEEP: The apExecute to apDeepSleep state transition is on
+ *                       going
+ * @DEEPSLEEP_TO_EXECUTE: The apDeepSleep to apExecute state transition is on
+ *                       going
+ * @DEEPSLEEP_TO_EXECUTEOK: The apDeepSleep to apExecute state transition has
+ *                         been completed
+ * @EXECUTE_TO_SLEEP: The apExecute to apSleep state transition is on going
+ * @SLEEP_TO_EXECUTE: The apSleep to apExecute state transition is on going
+ * @SLEEP_TO_EXECUTEOK: The apSleep to apExecute state transition has been
+ *                     completed
+ * @EXECUTE_TO_IDLE: The apExecute to apIdle state transition is on going
+ * @IDLE_TO_EXECUTE: The apIdle to apExecute state transition is on going
+ * @IDLE_TO_EXECUTEOK: The apIdle to apExecute state transition has been
+ *                    completed
+ * @INIT_STATUS: Status init
+ */
+enum ap_pwrsttr_status {
+	BOOT_TO_EXECUTEOK = 0xFF,
+	DEEPSLEEPOK = 0xFE,
+	SLEEPOK = 0xFD,
+	IDLEOK = 0xFC,
+	SOFTRESETOK = 0xFB,
+	SOFTRESETGO = 0xFA,
+	BOOT_TO_EXECUTE = 0xF9,
+	EXECUTE_TO_DEEPSLEEP = 0xF8,
+	DEEPSLEEP_TO_EXECUTE = 0xF7,
+	DEEPSLEEP_TO_EXECUTEOK = 0xF6,
+	EXECUTE_TO_SLEEP = 0xF5,
+	SLEEP_TO_EXECUTE = 0xF4,
+	SLEEP_TO_EXECUTEOK = 0xF3,
+	EXECUTE_TO_IDLE = 0xF2,
+	IDLE_TO_EXECUTE = 0xF1,
+	IDLE_TO_EXECUTEOK = 0xF0,
+	RDYTODS_RETURNTOEXE    = 0xEF,
+	NORDYTODS_RETURNTOEXE  = 0xEE,
+	EXETOSLEEP_RETURNTOEXE = 0xED,
+	EXETOIDLE_RETURNTOEXE  = 0xEC,
+	INIT_STATUS = 0xEB,
+
+	/*error messages */
+	INITERROR                     = 0x00,
+	PLLARMLOCKP_ER                = 0x01,
+	PLLDDRLOCKP_ER                = 0x02,
+	PLLSOCLOCKP_ER                = 0x03,
+	PLLSOCK1LOCKP_ER              = 0x04,
+	ARMWFI_ER                     = 0x05,
+	SYSCLKOK_ER                   = 0x06,
+	I2C_NACK_DATA_ER              = 0x07,
+	BOOT_ER                       = 0x08,
+	I2C_STATUS_ALWAYS_1           = 0x0A,
+	I2C_NACK_REG_ADDR_ER          = 0x0B,
+	I2C_NACK_DATA0123_ER          = 0x1B,
+	I2C_NACK_ADDR_ER              = 0x1F,
+	CURAPPWRSTISNOT_BOOT          = 0x20,
+	CURAPPWRSTISNOT_EXECUTE       = 0x21,
+	CURAPPWRSTISNOT_SLEEPMODE     = 0x22,
+	CURAPPWRSTISNOT_CORRECTFORIT10 = 0x23,
+	FIFO4500WUISNOT_WUPEVENT      = 0x24,
+	PLL32KLOCKP_ER                = 0x29,
+	DDRDEEPSLEEPOK_ER             = 0x2A,
+	ROMCODEREADY_ER               = 0x50,
+	WUPBEFOREDS                   = 0x51,
+	DDRCONFIG_ER                  = 0x52,
+	WUPBEFORESLEEP                = 0x53,
+	WUPBEFOREIDLE                 = 0x54
+};  /* earlier called as  mbox_2_arm_stat */
+
+/**
+ * enum dvfs_stat - DVFS status messages definition
+ * @DVFS_GO: A state transition DVFS is on going
+ * @DVFS_ARM100OPPOK: The state transition DVFS has been completed for 100OPP
+ * @DVFS_ARM50OPPOK: The state transition DVFS has been completed for 50OPP
+ * @DVFS_ARMEXTCLKOK: The state transition DVFS has been completed for EXTCLK
+ * @DVFS_NOCHGTCLKOK: The state transition DVFS has been completed for
+ *                   NOCHGCLK
+ * @DVFS_INITSTATUS: Value init
+ */
+enum dvfs_stat {
+	DVFS_GO = 0xFF,
+	DVFS_ARM100OPPOK = 0xFE,
+	DVFS_ARM50OPPOK = 0xFD,
+	DVFS_ARMEXTCLKOK = 0xFC,
+	DVFS_NOCHGTCLKOK = 0xFB,
+	DVFS_INITSTATUS = 0x00
+};
+
+/**
+ * enum sva_mmdsp_stat - SVA MMDSP status messages
+ * @SVA_MMDSP_GO: SVAMMDSP interrupt has happened
+ * @SVA_MMDSP_INIT: Status init
+ */
+enum sva_mmdsp_stat {
+	SVA_MMDSP_GO = 0xFF,
+	SVA_MMDSP_INIT = 0x00
+};
+
+/**
+ * enum sia_mmdsp_stat - SIA MMDSP status messages
+ * @SIA_MMDSP_GO: SIAMMDSP interrupt has happened
+ * @SIA_MMDSP_INIT: Status init
+ */
+enum sia_mmdsp_stat {
+	SIA_MMDSP_GO = 0xFF,
+	SIA_MMDSP_INIT = 0x00
+};
+
+/**
+ * enum  mbox_to_arm_err - Error messages definition
+ * @INIT_ERR: Init value
+ * @PLLARMLOCKP_ERR: PLLARM has not been correctly locked in given time
+ * @PLLDDRLOCKP_ERR: PLLDDR has not been correctly locked in the given time
+ * @PLLSOC0LOCKP_ERR: PLLSOC0 has not been correctly locked in the given time
+ * @PLLSOC1LOCKP_ERR: PLLSOC1 has not been correctly locked in the given time
+ * @ARMWFI_ERR: The ARM WFI has not been correctly executed in the given time
+ * @SYSCLKOK_ERR: The SYSCLK is not available in the given time
+ * @BOOT_ERR: Romcode has not validated the XP70 self reset in the given time
+ * @ROMCODESAVECONTEXT: The Romcode didn.t correctly save it secure context
+ * @VARMHIGHSPEEDVALTO_ERR: The ARM high speed supply value transfered
+ *          through I2C has not been correctly executed in the given time
+ * @VARMHIGHSPEEDACCESS_ERR: The command value of VarmHighSpeedVal transfered
+ *             through I2C has not been correctly executed in the given time
+ * @VARMLOWSPEEDVALTO_ERR:The ARM low speed supply value transfered through
+ *                     I2C has not been correctly executed in the given time
+ * @VARMLOWSPEEDACCESS_ERR: The command value of VarmLowSpeedVal transfered
+ *             through I2C has not been correctly executed in the given time
+ * @VARMRETENTIONVALTO_ERR: The ARM retention supply value transfered through
+ *                     I2C has not been correctly executed in the given time
+ * @VARMRETENTIONACCESS_ERR: The command value of VarmRetentionVal transfered
+ *             through I2C has not been correctly executed in the given time
+ * @VAPEHIGHSPEEDVALTO_ERR: The APE highspeed supply value transfered through
+ *                     I2C has not been correctly executed in the given time
+ * @VSAFEHPVALTO_ERR: The SAFE high power supply value transfered through I2C
+ *                         has not been correctly executed in the given time
+ * @VMODSEL1VALTO_ERR: The MODEM sel1 supply value transfered through I2C has
+ *                             not been correctly executed in the given time
+ * @VMODSEL2VALTO_ERR: The MODEM sel2 supply value transfered through I2C has
+ *                             not been correctly executed in the given time
+ * @VARMOFFACCESS_ERR: The command value of Varm ON/OFF transfered through
+ *                     I2C has not been correctly executed in the given time
+ * @VAPEOFFACCESS_ERR: The command value of Vape ON/OFF transfered through
+ *                     I2C has not been correctly executed in the given time
+ * @VARMRETACCES_ERR: The command value of Varm retention ON/OFF transfered
+ *             through I2C has not been correctly executed in the given time
+ * @CURAPPWRSTISNOTBOOT:Generated when Arm want to do power state transition
+ *             ApBoot to ApExecute but the power current state is not Apboot
+ * @CURAPPWRSTISNOTEXECUTE: Generated when Arm want to do power state
+ *              transition from ApExecute to others power state but the
+ *              power current state is not ApExecute
+ * @CURAPPWRSTISNOTSLEEPMODE: Generated when wake up events are transmitted
+ *             but the power current state is not ApDeepSleep/ApSleep/ApIdle
+ * @CURAPPWRSTISNOTCORRECTDBG:  Generated when wake up events are transmitted
+ *              but the power current state is not correct
+ * @ARMREGU1VALTO_ERR:The ArmRegu1 value transferred through I2C has not
+ *                    been correctly executed in the given time
+ * @ARMREGU2VALTO_ERR: The ArmRegu2 value transferred through I2C has not
+ *                    been correctly executed in the given time
+ * @VAPEREGUVALTO_ERR: The VApeRegu value transfered through I2C has not
+ *                    been correctly executed in the given time
+ * @VSMPS3REGUVALTO_ERR: The VSmps3Regu value transfered through I2C has not
+ *                      been correctly executed in the given time
+ * @VMODREGUVALTO_ERR: The VModemRegu value transfered through I2C has not
+ *                    been correctly executed in the given time
+ */
+enum mbox_to_arm_err {
+	INIT_ERR = 0x00,
+	PLLARMLOCKP_ERR = 0x01,
+	PLLDDRLOCKP_ERR = 0x02,
+	PLLSOC0LOCKP_ERR = 0x03,
+	PLLSOC1LOCKP_ERR = 0x04,
+	ARMWFI_ERR = 0x05,
+	SYSCLKOK_ERR = 0x06,
+	BOOT_ERR = 0x07,
+	ROMCODESAVECONTEXT = 0x08,
+	VARMHIGHSPEEDVALTO_ERR = 0x10,
+	VARMHIGHSPEEDACCESS_ERR = 0x11,
+	VARMLOWSPEEDVALTO_ERR = 0x12,
+	VARMLOWSPEEDACCESS_ERR = 0x13,
+	VARMRETENTIONVALTO_ERR = 0x14,
+	VARMRETENTIONACCESS_ERR = 0x15,
+	VAPEHIGHSPEEDVALTO_ERR = 0x16,
+	VSAFEHPVALTO_ERR = 0x17,
+	VMODSEL1VALTO_ERR = 0x18,
+	VMODSEL2VALTO_ERR = 0x19,
+	VARMOFFACCESS_ERR = 0x1A,
+	VAPEOFFACCESS_ERR = 0x1B,
+	VARMRETACCES_ERR = 0x1C,
+	CURAPPWRSTISNOTBOOT = 0x20,
+	CURAPPWRSTISNOTEXECUTE = 0x21,
+	CURAPPWRSTISNOTSLEEPMODE = 0x22,
+	CURAPPWRSTISNOTCORRECTDBG = 0x23,
+	ARMREGU1VALTO_ERR = 0x24,
+	ARMREGU2VALTO_ERR = 0x25,
+	VAPEREGUVALTO_ERR = 0x26,
+	VSMPS3REGUVALTO_ERR = 0x27,
+	VMODREGUVALTO_ERR = 0x28
+};
+
+enum hw_acc {
+	SVAMMDSP = 0,
+	SVAPIPE = 1,
+	SIAMMDSP = 2,
+	SIAPIPE = 3,
+	SGA = 4,
+	B2R2MCDE = 5,
+	ESRAM12 = 6,
+	ESRAM34 = 7,
+};
+
+enum cs_pwrmgt {
+	PWRDNCS0  = 0,
+	WKUPCS0   = 1,
+	PWRDNCS1  = 2,
+	WKUPCS1   = 3
+};
+
+/* Defs related to autonomous power management */
+
+/**
+ * enum sia_sva_pwr_policy - Power policy
+ * @NO_CHGT:	No change
+ * @DSPOFF_HWPOFF:
+ * @DSPOFFRAMRET_HWPOFF:
+ * @DSPCLKOFF_HWPOFF:
+ * @DSPCLKOFF_HWPCLKOFF:
  *
- * License Terms: GNU General Public License v2
+ */
+enum sia_sva_pwr_policy {
+	NO_CHGT			= 0x0,
+	DSPOFF_HWPOFF		= 0x1,
+	DSPOFFRAMRET_HWPOFF	= 0x2,
+	DSPCLKOFF_HWPOFF	= 0x3,
+	DSPCLKOFF_HWPCLKOFF	= 0x4,
+};
+
+/**
+ * enum auto_enable - Auto Power enable
+ * @AUTO_OFF:
+ * @AUTO_ON:
+ *
+ */
+enum auto_enable {
+	AUTO_OFF	= 0x0,
+	AUTO_ON		= 0x1,
+};
+
+/* End of file previously known as prcmu-fw-defs_v1.h */
+
+/* PRCMU Wakeup defines */
+enum prcmu_wakeup_index {
+	PRCMU_WAKEUP_INDEX_RTC,
+	PRCMU_WAKEUP_INDEX_RTT0,
+	PRCMU_WAKEUP_INDEX_RTT1,
+	PRCMU_WAKEUP_INDEX_HSI0,
+	PRCMU_WAKEUP_INDEX_HSI1,
+	PRCMU_WAKEUP_INDEX_USB,
+	PRCMU_WAKEUP_INDEX_ABB,
+	PRCMU_WAKEUP_INDEX_ABB_FIFO,
+	PRCMU_WAKEUP_INDEX_ARM,
+	NUM_PRCMU_WAKEUP_INDICES
+};
+#define PRCMU_WAKEUP(_name) (BIT(PRCMU_WAKEUP_INDEX_##_name))
+
+/* PRCMU QoS APE OPP class */
+#define PRCMU_QOS_APE_OPP 1
+#define PRCMU_QOS_DDR_OPP 2
+#define PRCMU_QOS_DEFAULT_VALUE -1
+
+/**
+ * enum hw_acc_dev - enum for hw accelerators
+ * @HW_ACC_SVAMMDSP: for SVAMMDSP
+ * @HW_ACC_SVAPIPE:  for SVAPIPE
+ * @HW_ACC_SIAMMDSP: for SIAMMDSP
+ * @HW_ACC_SIAPIPE: for SIAPIPE
+ * @HW_ACC_SGA: for SGA
+ * @HW_ACC_B2R2: for B2R2
+ * @HW_ACC_MCDE: for MCDE
+ * @HW_ACC_ESRAM1: for ESRAM1
+ * @HW_ACC_ESRAM2: for ESRAM2
+ * @HW_ACC_ESRAM3: for ESRAM3
+ * @HW_ACC_ESRAM4: for ESRAM4
+ * @NUM_HW_ACC: number of hardware accelerators
+ *
+ * Different hw accelerators which can be turned ON/
+ * OFF or put into retention (MMDSPs and ESRAMs).
+ * Used with EPOD API.
  *
- * PRCM Unit f/w API
+ * NOTE! Deprecated, to be removed when all users switched over to use the
+ * regulator API.
+ */
+enum hw_acc_dev {
+	HW_ACC_SVAMMDSP,
+	HW_ACC_SVAPIPE,
+	HW_ACC_SIAMMDSP,
+	HW_ACC_SIAPIPE,
+	HW_ACC_SGA,
+	HW_ACC_B2R2,
+	HW_ACC_MCDE,
+	HW_ACC_ESRAM1,
+	HW_ACC_ESRAM2,
+	HW_ACC_ESRAM3,
+	HW_ACC_ESRAM4,
+	NUM_HW_ACC
+};
+
+/*
+ * Ids for all EPODs (power domains)
+ * - EPOD_ID_SVAMMDSP: power domain for SVA MMDSP
+ * - EPOD_ID_SVAPIPE: power domain for SVA pipe
+ * - EPOD_ID_SIAMMDSP: power domain for SIA MMDSP
+ * - EPOD_ID_SIAPIPE: power domain for SIA pipe
+ * - EPOD_ID_SGA: power domain for SGA
+ * - EPOD_ID_B2R2_MCDE: power domain for B2R2 and MCDE
+ * - EPOD_ID_ESRAM12: power domain for ESRAM 1 and 2
+ * - EPOD_ID_ESRAM34: power domain for ESRAM 3 and 4
+ * - NUM_EPOD_ID: number of power domains
+ */
+#define EPOD_ID_SVAMMDSP	0
+#define EPOD_ID_SVAPIPE		1
+#define EPOD_ID_SIAMMDSP	2
+#define EPOD_ID_SIAPIPE		3
+#define EPOD_ID_SGA		4
+#define EPOD_ID_B2R2_MCDE	5
+#define EPOD_ID_ESRAM12		6
+#define EPOD_ID_ESRAM34		7
+#define NUM_EPOD_ID		8
+
+/*
+ * state definition for EPOD (power domain)
+ * - EPOD_STATE_NO_CHANGE: The EPOD should remain unchanged
+ * - EPOD_STATE_OFF: The EPOD is switched off
+ * - EPOD_STATE_RAMRET: The EPOD is switched off with its internal RAM in
+ *                         retention
+ * - EPOD_STATE_ON_CLK_OFF: The EPOD is switched on, clock is still off
+ * - EPOD_STATE_ON: Same as above, but with clock enabled
  */
-#ifndef __MACH_PRCMU_H
-#define __MACH_PRCMU_H
+#define EPOD_STATE_NO_CHANGE	0x00
+#define EPOD_STATE_OFF		0x01
+#define EPOD_STATE_RAMRET	0x02
+#define EPOD_STATE_ON_CLK_OFF	0x03
+#define EPOD_STATE_ON		0x04
 
+/*
+ * CLKOUT sources
+ */
+#define PRCMU_CLKSRC_CLK38M		0x00
+#define PRCMU_CLKSRC_ACLK		0x01
+#define PRCMU_CLKSRC_SYSCLK		0x02
+#define PRCMU_CLKSRC_LCDCLK		0x03
+#define PRCMU_CLKSRC_SDMMCCLK		0x04
+#define PRCMU_CLKSRC_TVCLK		0x05
+#define PRCMU_CLKSRC_TIMCLK		0x06
+#define PRCMU_CLKSRC_CLK009		0x07
+/* These are only valid for CLKOUT1: */
+#define PRCMU_CLKSRC_SIAMMDSPCLK	0x40
+#define PRCMU_CLKSRC_I2CCLK		0x41
+#define PRCMU_CLKSRC_MSP02CLK		0x42
+#define PRCMU_CLKSRC_ARMPLL_OBSCLK	0x43
+#define PRCMU_CLKSRC_HSIRXCLK		0x44
+#define PRCMU_CLKSRC_HSITXCLK		0x45
+#define PRCMU_CLKSRC_ARMCLKFIX		0x46
+#define PRCMU_CLKSRC_HDMICLK		0x47
+
+/*
+ * Definitions for autonomous power management configuration.
+ */
+
+#define PRCMU_AUTO_PM_OFF 0
+#define PRCMU_AUTO_PM_ON 1
+
+#define PRCMU_AUTO_PM_POWER_ON_HSEM BIT(0)
+#define PRCMU_AUTO_PM_POWER_ON_ABB_FIFO_IT BIT(1)
+
+enum prcmu_auto_pm_policy {
+	PRCMU_AUTO_PM_POLICY_NO_CHANGE,
+	PRCMU_AUTO_PM_POLICY_DSP_OFF_HWP_OFF,
+	PRCMU_AUTO_PM_POLICY_DSP_OFF_RAMRET_HWP_OFF,
+	PRCMU_AUTO_PM_POLICY_DSP_CLK_OFF_HWP_OFF,
+	PRCMU_AUTO_PM_POLICY_DSP_CLK_OFF_HWP_CLK_OFF,
+};
+
+/**
+ * struct prcmu_auto_pm_config - Autonomous power management configuration.
+ * @sia_auto_pm_enable: SIA autonomous pm enable. (PRCMU_AUTO_PM_{OFF,ON})
+ * @sia_power_on:       SIA power ON enable. (PRCMU_AUTO_PM_POWER_ON_* bitmask)
+ * @sia_policy:         SIA power policy. (enum prcmu_auto_pm_policy)
+ * @sva_auto_pm_enable: SVA autonomous pm enable. (PRCMU_AUTO_PM_{OFF,ON})
+ * @sva_power_on:       SVA power ON enable. (PRCMU_AUTO_PM_POWER_ON_* bitmask)
+ * @sva_policy:         SVA power policy. (enum prcmu_auto_pm_policy)
+ */
+struct prcmu_auto_pm_config {
+	u8 sia_auto_pm_enable;
+	u8 sia_power_on;
+	u8 sia_policy;
+	u8 sva_auto_pm_enable;
+	u8 sva_power_on;
+	u8 sva_policy;
+};
+
+/**
+ * enum ddr_opp - DDR OPP states definition
+ * @DDR_100_OPP: The new DDR operating point is ddr100opp
+ * @DDR_50_OPP: The new DDR operating point is ddr50opp
+ * @DDR_25_OPP: The new DDR operating point is ddr25opp
+ */
+enum ddr_opp {
+	DDR_100_OPP = 0x00,
+	DDR_50_OPP = 0x01,
+	DDR_25_OPP = 0x02,
+};
+
+/*
+ * Clock identifiers.
+ */
+enum prcmu_clock {
+	PRCMU_SGACLK,
+	PRCMU_UARTCLK,
+	PRCMU_MSP02CLK,
+	PRCMU_MSP1CLK,
+	PRCMU_I2CCLK,
+	PRCMU_SDMMCCLK,
+	PRCMU_SLIMCLK,
+	PRCMU_PER1CLK,
+	PRCMU_PER2CLK,
+	PRCMU_PER3CLK,
+	PRCMU_PER5CLK,
+	PRCMU_PER6CLK,
+	PRCMU_PER7CLK,
+	PRCMU_LCDCLK,
+	PRCMU_BMLCLK,
+	PRCMU_HSITXCLK,
+	PRCMU_HSIRXCLK,
+	PRCMU_HDMICLK,
+	PRCMU_APEATCLK,
+	PRCMU_APETRACECLK,
+	PRCMU_MCDECLK,
+	PRCMU_IPI2CCLK,
+	PRCMU_DSIALTCLK,
+	PRCMU_DMACLK,
+	PRCMU_B2R2CLK,
+	PRCMU_TVCLK,
+	PRCMU_SSPCLK,
+	PRCMU_RNGCLK,
+	PRCMU_UICCCLK,
+	PRCMU_NUM_REG_CLOCKS,
+	PRCMU_SYSCLK = PRCMU_NUM_REG_CLOCKS,
+	PRCMU_TIMCLK,
+};
+
+/*
+ * Definitions for controlling ESRAM0 in deep sleep.
+ */
+#define ESRAM0_DEEP_SLEEP_STATE_OFF 1
+#define ESRAM0_DEEP_SLEEP_STATE_RET 2
+
+#ifdef CONFIG_MFD_DB8500_PRCMU
 void __init prcmu_early_init(void);
+int prcmu_set_display_clocks(void);
+int prcmu_disable_dsipll(void);
+int prcmu_enable_dsipll(void);
+#else
+static inline void __init prcmu_early_init(void) {}
+#endif
+
+#ifdef CONFIG_MFD_DB8500_PRCMU
+
+int prcmu_set_rc_a2p(enum romcode_write);
+enum romcode_read prcmu_get_rc_p2a(void);
+enum ap_pwrst prcmu_get_xp70_current_state(void);
+int prcmu_set_power_state(u8 state, bool keep_ulp_clk, bool keep_ap_pll);
+
+void prcmu_enable_wakeups(u32 wakeups);
+static inline void prcmu_disable_wakeups(void)
+{
+	prcmu_enable_wakeups(0);
+}
+
+void prcmu_config_abb_event_readout(u32 abb_events);
+void prcmu_get_abb_event_buffer(void __iomem **buf);
+int prcmu_set_arm_opp(u8 opp);
+int prcmu_get_arm_opp(void);
+bool prcmu_has_arm_maxopp(void);
+bool prcmu_is_u8400(void);
+int prcmu_set_ape_opp(u8 opp);
+int prcmu_get_ape_opp(void);
+int prcmu_request_ape_opp_100_voltage(bool enable);
+int prcmu_release_usb_wakeup_state(void);
+int prcmu_set_ddr_opp(u8 opp);
+int prcmu_get_ddr_opp(void);
+unsigned long prcmu_qos_get_cpufreq_opp_delay(void);
+void prcmu_qos_set_cpufreq_opp_delay(unsigned long);
+/* NOTE! Use regulator framework instead */
+int prcmu_set_hwacc(u16 hw_acc_dev, u8 state);
+int prcmu_set_epod(u16 epod_id, u8 epod_state);
+void prcmu_configure_auto_pm(struct prcmu_auto_pm_config *sleep,
+	struct prcmu_auto_pm_config *idle);
+bool prcmu_is_auto_pm_enabled(void);
+
+int prcmu_config_clkout(u8 clkout, u8 source, u8 div);
+int prcmu_request_clock(u8 clock, bool enable);
+int prcmu_set_clock_divider(u8 clock, u8 divider);
+int prcmu_config_esram0_deep_sleep(u8 state);
+int prcmu_config_hotdog(u8 threshold);
+int prcmu_config_hotmon(u8 low, u8 high);
+int prcmu_start_temp_sense(u16 cycles32k);
+int prcmu_stop_temp_sense(void);
 int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size);
 int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size);
-int prcmu_set_ape_opp(enum prcmu_ape_opp opp);
-int prcmu_set_cpu_opp(enum prcmu_cpu_opp opp);
-int prcmu_set_ape_cpu_opps(enum prcmu_ape_opp ape_opp,
-			   enum prcmu_cpu_opp cpu_opp);
-enum prcmu_ape_opp prcmu_get_ape_opp(void);
-int prcmu_get_cpu_opp(void);
-bool prcmu_has_arm_maxopp(void);
 
-#endif /* __MACH_PRCMU_H */
+void prcmu_ac_wake_req(void);
+void prcmu_ac_sleep_req(void);
+void prcmu_system_reset(u16 reset_code);
+void prcmu_modem_reset(void);
+bool prcmu_is_ac_wake_requested(void);
+void prcmu_enable_spi2(void);
+void prcmu_disable_spi2(void);
+
+#else /* !CONFIG_MFD_DB8500_PRCMU */
+
+static inline int prcmu_set_rc_a2p(enum romcode_write code)
+{
+	return 0;
+}
+
+static inline enum romcode_read prcmu_get_rc_p2a(void)
+{
+	return INIT;
+}
+
+static inline enum ap_pwrst prcmu_get_xp70_current_state(void)
+{
+	return AP_EXECUTE;
+}
+
+static inline int prcmu_set_power_state(u8 state, bool keep_ulp_clk,
+	bool keep_ap_pll)
+{
+	return 0;
+}
+
+static inline void prcmu_enable_wakeups(u32 wakeups) {}
+
+static inline void prcmu_disable_wakeups(void) {}
+
+static inline void prcmu_config_abb_event_readout(u32 abb_events) {}
+
+static inline int prcmu_set_arm_opp(u8 opp)
+{
+	return 0;
+}
+
+static inline int prcmu_get_arm_opp(void)
+{
+	return ARM_100_OPP;
+}
+
+static bool prcmu_has_arm_maxopp(void)
+{
+	return false;
+}
+
+static bool prcmu_is_u8400(void)
+{
+	return false;
+}
+
+static inline int prcmu_set_ape_opp(u8 opp)
+{
+	return 0;
+}
+
+static inline int prcmu_get_ape_opp(void)
+{
+	return APE_100_OPP;
+}
+
+static inline int prcmu_request_ape_opp_100_voltage(bool enable)
+{
+	return 0;
+}
+
+static inline int prcmu_release_usb_wakeup_state(void)
+{
+	return 0;
+}
+
+static inline int prcmu_set_ddr_opp(u8 opp)
+{
+	return 0;
+}
+
+static inline int prcmu_get_ddr_opp(void)
+{
+	return DDR_100_OPP;
+}
+
+static inline unsigned long prcmu_qos_get_cpufreq_opp_delay(void)
+{
+	return 0;
+}
+
+static inline void prcmu_qos_set_cpufreq_opp_delay(unsigned long n) {}
+
+static inline int prcmu_set_hwacc(u16 hw_acc_dev, u8 state)
+{
+	return 0;
+}
+
+static inline void prcmu_configure_auto_pm(struct prcmu_auto_pm_config *sleep,
+	struct prcmu_auto_pm_config *idle)
+{
+}
+
+static inline bool prcmu_is_auto_pm_enabled(void)
+{
+	return false;
+}
+
+static inline int prcmu_config_clkout(u8 clkout, u8 source, u8 div)
+{
+	return 0;
+}
+
+static inline int prcmu_request_clock(u8 clock, bool enable)
+{
+	return 0;
+}
+
+static inline int prcmu_set_clock_divider(u8 clock, u8 divider)
+{
+	return 0;
+}
+
+int prcmu_config_esram0_deep_sleep(u8 state)
+{
+	return 0;
+}
+
+static inline int prcmu_config_hotdog(u8 threshold)
+{
+	return 0;
+}
+
+static inline int prcmu_config_hotmon(u8 low, u8 high)
+{
+	return 0;
+}
+
+static inline int prcmu_start_temp_sense(u16 cycles32k)
+{
+	return 0;
+}
+
+static inline int prcmu_stop_temp_sense(void)
+{
+	return 0;
+}
+
+static inline int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
+{
+	return -ENOSYS;
+}
+
+static inline int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
+{
+	return -ENOSYS;
+}
+
+static inline void prcmu_ac_wake_req(void) {}
+
+static inline void prcmu_ac_sleep_req(void) {}
+
+static inline void prcmu_system_reset(u16 reset_code) {}
+
+static inline void prcmu_modem_reset(void) {}
+
+static inline bool prcmu_is_ac_wake_requested(void)
+{
+	return false;
+}
+
+#ifndef CONFIG_UX500_SOC_DB5500
+static inline int prcmu_set_display_clocks(void)
+{
+	return 0;
+}
+
+static inline int prcmu_disable_dsipll(void)
+{
+	return 0;
+}
+
+static inline int prcmu_enable_dsipll(void)
+{
+	return 0;
+}
+#endif
+
+static inline int prcmu_enable_spi2(void)
+{
+	return 0;
+}
+
+static inline int prcmu_disable_spi2(void)
+{
+	return 0;
+}
+
+#endif /* !CONFIG_MFD_DB8500_PRCMU */
+
+#ifdef CONFIG_UX500_PRCMU_QOS_POWER
+int prcmu_qos_requirement(int pm_qos_class);
+int prcmu_qos_add_requirement(int pm_qos_class, char *name, s32 value);
+int prcmu_qos_update_requirement(int pm_qos_class, char *name, s32 new_value);
+void prcmu_qos_remove_requirement(int pm_qos_class, char *name);
+int prcmu_qos_add_notifier(int prcmu_qos_class,
+			   struct notifier_block *notifier);
+int prcmu_qos_remove_notifier(int prcmu_qos_class,
+			      struct notifier_block *notifier);
+#else
+static inline int prcmu_qos_requirement(int prcmu_qos_class)
+{
+	return 0;
+}
+
+static inline int prcmu_qos_add_requirement(int prcmu_qos_class,
+					    char *name, s32 value)
+{
+	return 0;
+}
+
+static inline int prcmu_qos_update_requirement(int prcmu_qos_class,
+					       char *name, s32 new_value)
+{
+	return 0;
+}
+
+static inline void prcmu_qos_remove_requirement(int prcmu_qos_class, char *name)
+{
+}
+
+static inline int prcmu_qos_add_notifier(int prcmu_qos_class,
+					 struct notifier_block *notifier)
+{
+	return 0;
+}
+static inline int prcmu_qos_remove_notifier(int prcmu_qos_class,
+					    struct notifier_block *notifier)
+{
+	return 0;
+}
+
+#endif
+
+#endif /* __MFD_DB8500_PRCMU_H */
-- 
1.7.3.2

