Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab1HLIvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:51:52 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:41612 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753522Ab1HLIvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:51:08 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 01/23] mfd/db8500-prcmu: refactor DB8500 PRCMU reg access
Date: Fri, 12 Aug 2011 10:27:20 +0200
Message-ID: <1313137640-30617-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias Nilsson <mattias.i.nilsson@stericsson.com>

Instead of carrying around the __PRCMU_BASE in every read or
write to the PRCMU registers, move it out to the register
definition file and define registers along with their base
offset so that the code gets easier to read.

Signed-off-by: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db8500-prcmu-regs.h |  266 ++++++++++++++++++++++-----------------
 drivers/mfd/db8500-prcmu.c      |  159 +++++++++++------------
 2 files changed, 229 insertions(+), 196 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu-regs.h b/drivers/mfd/db8500-prcmu-regs.h
index 3bbf04d..ec22e9f 100644
--- a/drivers/mfd/db8500-prcmu-regs.h
+++ b/drivers/mfd/db8500-prcmu-regs.h
@@ -9,99 +9,170 @@
  *
  * PRCM Unit registers
  */
+
 #ifndef __DB8500_PRCMU_REGS_H
 #define __DB8500_PRCMU_REGS_H
 
-#include <linux/bitops.h>
 #include <mach/hardware.h>
 
 #define BITS(_start, _end) ((BIT(_end) - BIT(_start)) + BIT(_end))
 
-#define PRCM_ARM_PLLDIVPS 0x118
-#define PRCM_ARM_PLLDIVPS_ARM_BRM_RATE	BITS(0, 5)
-#define PRCM_ARM_PLLDIVPS_MAX_MASK	0xF
-
-#define PRCM_PLLARM_LOCKP 0x0A8
-#define PRCM_PLLARM_LOCKP_PRCM_PLLARM_LOCKP3 BIT(1)
-
-#define PRCM_ARM_CHGCLKREQ 0x114
-#define PRCM_ARM_CHGCLKREQ_PRCM_ARM_CHGCLKREQ BIT(0)
-
-#define PRCM_PLLARM_ENABLE 0x98
-#define PRCM_PLLARM_ENABLE_PRCM_PLLARM_ENABLE	BIT(0)
-#define PRCM_PLLARM_ENABLE_PRCM_PLLARM_COUNTON	BIT(8)
-
-#define PRCM_ARMCLKFIX_MGT	0x0
-#define PRCM_A9_RESETN_CLR	0x1f4
-#define PRCM_A9_RESETN_SET	0x1f0
-#define PRCM_ARM_LS_CLAMP	0x30C
-#define PRCM_SRAM_A9		0x308
+#define PRCM_SVACLK_MGT_OFF		0x008
+#define PRCM_SIACLK_MGT_OFF		0x00C
+#define PRCM_SGACLK_MGT_OFF		0x014
+#define PRCM_UARTCLK_MGT_OFF		0x018
+#define PRCM_MSP02CLK_MGT_OFF		0x01C
+#define PRCM_I2CCLK_MGT_OFF		0x020
+#define PRCM_SDMMCCLK_MGT_OFF		0x024
+#define PRCM_SLIMCLK_MGT_OFF		0x028
+#define PRCM_PER1CLK_MGT_OFF		0x02C
+#define PRCM_PER2CLK_MGT_OFF		0x030
+#define PRCM_PER3CLK_MGT_OFF		0x034
+#define PRCM_PER5CLK_MGT_OFF		0x038
+#define PRCM_PER6CLK_MGT_OFF		0x03C
+#define PRCM_PER7CLK_MGT_OFF		0x040
+#define PRCM_PWMCLK_MGT_OFF		0x044 /* for DB5500 */
+#define PRCM_IRDACLK_MGT_OFF		0x048 /* for DB5500 */
+#define PRCM_IRRCCLK_MGT_OFF		0x04C /* for DB5500 */
+#define PRCM_LCDCLK_MGT_OFF		0x044
+#define PRCM_BMLCLK_MGT_OFF		0x04C
+#define PRCM_HSITXCLK_MGT_OFF		0x050
+#define PRCM_HSIRXCLK_MGT_OFF		0x054
+#define PRCM_HDMICLK_MGT_OFF		0x058
+#define PRCM_APEATCLK_MGT_OFF		0x05C
+#define PRCM_APETRACECLK_MGT_OFF	0x060
+#define PRCM_MCDECLK_MGT_OFF		0x064
+#define PRCM_IPI2CCLK_MGT_OFF		0x068
+#define PRCM_DSIALTCLK_MGT_OFF		0x06C
+#define PRCM_DMACLK_MGT_OFF		0x074
+#define PRCM_B2R2CLK_MGT_OFF		0x078
+#define PRCM_TVCLK_MGT_OFF		0x07C
+#define PRCM_UNIPROCLK_MGT_OFF		0x278
+#define PRCM_SSPCLK_MGT_OFF		0x280
+#define PRCM_RNGCLK_MGT_OFF		0x284
+#define PRCM_UICCCLK_MGT_OFF		0x27C
+#define PRCM_MSP1CLK_MGT_OFF		0x288
+
+#define PRCM_ARM_PLLDIVPS	(_PRCMU_BASE + 0x118)
+#define PRCM_ARM_PLLDIVPS_ARM_BRM_RATE		0x3f
+#define PRCM_ARM_PLLDIVPS_MAX_MASK		0xf
+
+#define PRCM_PLLARM_LOCKP       (_PRCMU_BASE + 0x0a8)
+#define PRCM_PLLARM_LOCKP_PRCM_PLLARM_LOCKP3	0x2
+
+#define PRCM_ARM_CHGCLKREQ	(_PRCMU_BASE + 0x114)
+#define PRCM_ARM_CHGCLKREQ_PRCM_ARM_CHGCLKREQ	0x1
+
+#define PRCM_PLLARM_ENABLE	(_PRCMU_BASE + 0x98)
+#define PRCM_PLLARM_ENABLE_PRCM_PLLARM_ENABLE	0x1
+#define PRCM_PLLARM_ENABLE_PRCM_PLLARM_COUNTON	0x100
+
+#define PRCM_ARMCLKFIX_MGT	(_PRCMU_BASE + 0x0)
+#define PRCM_A9PL_FORCE_CLKEN	(_PRCMU_BASE + 0x19C)
+#define PRCM_A9_RESETN_CLR	(_PRCMU_BASE + 0x1f4)
+#define PRCM_A9_RESETN_SET	(_PRCMU_BASE + 0x1f0)
+#define PRCM_ARM_LS_CLAMP	(_PRCMU_BASE + 0x30c)
+#define PRCM_SRAM_A9		(_PRCMU_BASE + 0x308)
+
+#define PRCM_A9PL_FORCE_CLKEN_PRCM_A9PL_FORCE_CLKEN BIT(0)
+#define PRCM_A9PL_FORCE_CLKEN_PRCM_A9AXI_FORCE_CLKEN BIT(1)
 
 /* ARM WFI Standby signal register */
-#define PRCM_ARM_WFI_STANDBY	0x130
-#define PRCM_IOCR		0x310
-#define PRCM_IOCR_IOFORCE BIT(0)
+#define PRCM_ARM_WFI_STANDBY    (_PRCMU_BASE + 0x130)
+#define PRCM_IOCR		(_PRCMU_BASE + 0x310)
+#define PRCM_IOCR_IOFORCE			0x1
 
 /* CPU mailbox registers */
-#define PRCM_MBOX_CPU_VAL 0x0FC
-#define PRCM_MBOX_CPU_SET 0x100
+#define PRCM_MBOX_CPU_VAL	(_PRCMU_BASE + 0x0fc)
+#define PRCM_MBOX_CPU_SET	(_PRCMU_BASE + 0x100)
+#define PRCM_MBOX_CPU_CLR	(_PRCMU_BASE + 0x104)
 
 /* Dual A9 core interrupt management unit registers */
-#define PRCM_A9_MASK_REQ 0x328
-#define PRCM_A9_MASK_REQ_PRCM_A9_MASK_REQ BIT(0)
-
-#define PRCM_A9_MASK_ACK	0x32C
-#define PRCM_ARMITMSK31TO0	0x11C
-#define PRCM_ARMITMSK63TO32	0x120
-#define PRCM_ARMITMSK95TO64	0x124
-#define PRCM_ARMITMSK127TO96	0x128
-#define PRCM_POWER_STATE_VAL	0x25C
-#define PRCM_ARMITVAL31TO0	0x260
-#define PRCM_ARMITVAL63TO32	0x264
-#define PRCM_ARMITVAL95TO64	0x268
-#define PRCM_ARMITVAL127TO96	0x26C
-
-#define PRCM_HOSTACCESS_REQ 0x334
-#define PRCM_HOSTACCESS_REQ_HOSTACCESS_REQ BIT(0)
-
-#define PRCM_ARM_IT1_CLR 0x48C
-#define PRCM_ARM_IT1_VAL 0x494
-
-#define PRCM_ITSTATUS0		0x148
-#define PRCM_ITSTATUS1		0x150
-#define PRCM_ITSTATUS2		0x158
-#define PRCM_ITSTATUS3		0x160
-#define PRCM_ITSTATUS4		0x168
-#define PRCM_ITSTATUS5		0x484
-#define PRCM_ITCLEAR5		0x488
-#define PRCM_ARMIT_MASKXP70_IT	0x1018
+#define PRCM_A9_MASK_REQ	(_PRCMU_BASE + 0x328)
+#define PRCM_A9_MASK_REQ_PRCM_A9_MASK_REQ	0x1
+
+#define PRCM_A9_MASK_ACK	(_PRCMU_BASE + 0x32c)
+#define PRCM_ARMITMSK31TO0	(_PRCMU_BASE + 0x11c)
+#define PRCM_ARMITMSK63TO32	(_PRCMU_BASE + 0x120)
+#define PRCM_ARMITMSK95TO64	(_PRCMU_BASE + 0x124)
+#define PRCM_ARMITMSK127TO96	(_PRCMU_BASE + 0x128)
+#define PRCM_POWER_STATE_VAL	(_PRCMU_BASE + 0x25C)
+#define PRCM_ARMITVAL31TO0	(_PRCMU_BASE + 0x260)
+#define PRCM_ARMITVAL63TO32	(_PRCMU_BASE + 0x264)
+#define PRCM_ARMITVAL95TO64	(_PRCMU_BASE + 0x268)
+#define PRCM_ARMITVAL127TO96	(_PRCMU_BASE + 0x26C)
+
+#define PRCM_HOSTACCESS_REQ	(_PRCMU_BASE + 0x334)
+#define PRCM_HOSTACCESS_REQ_HOSTACCESS_REQ 0x1
+#define ARM_WAKEUP_MODEM	0x1
+
+#define PRCM_ARM_IT1_CLR	(_PRCMU_BASE + 0x48C)
+#define PRCM_ARM_IT1_VAL	(_PRCMU_BASE + 0x494)
+#define PRCM_HOLD_EVT		(_PRCMU_BASE + 0x174)
+
+#define PRCM_MOD_AWAKE_STATUS	(_PRCMU_BASE + 0x4A0)
+#define PRCM_MOD_AWAKE_STATUS_PRCM_MOD_COREPD_AWAKE	BIT(0)
+#define PRCM_MOD_AWAKE_STATUS_PRCM_MOD_AAPD_AWAKE	BIT(1)
+#define PRCM_MOD_AWAKE_STATUS_PRCM_MOD_VMODEM_OFF_ISO	BIT(2)
+
+#define PRCM_ITSTATUS0		(_PRCMU_BASE + 0x148)
+#define PRCM_ITSTATUS1		(_PRCMU_BASE + 0x150)
+#define PRCM_ITSTATUS2		(_PRCMU_BASE + 0x158)
+#define PRCM_ITSTATUS3		(_PRCMU_BASE + 0x160)
+#define PRCM_ITSTATUS4		(_PRCMU_BASE + 0x168)
+#define PRCM_ITSTATUS5		(_PRCMU_BASE + 0x484)
+#define PRCM_ITCLEAR5		(_PRCMU_BASE + 0x488)
+#define PRCM_ARMIT_MASKXP70_IT	(_PRCMU_BASE + 0x1018)
 
 /* System reset register */
-#define PRCM_APE_SOFTRST 0x228
+#define PRCM_APE_SOFTRST	(_PRCMU_BASE + 0x228)
 
 /* Level shifter and clamp control registers */
-#define PRCM_MMIP_LS_CLAMP_SET 0x420
-#define PRCM_MMIP_LS_CLAMP_CLR 0x424
+#define PRCM_MMIP_LS_CLAMP_SET     (_PRCMU_BASE + 0x420)
+#define PRCM_MMIP_LS_CLAMP_CLR     (_PRCMU_BASE + 0x424)
+
+/* PRCMU clock/PLL/reset registers */
+#define PRCM_PLLDSI_FREQ           (_PRCMU_BASE + 0x500)
+#define PRCM_PLLDSI_ENABLE         (_PRCMU_BASE + 0x504)
+#define PRCM_PLLDSI_LOCKP          (_PRCMU_BASE + 0x508)
+#define PRCM_LCDCLK_MGT            (_PRCMU_BASE + PRCM_LCDCLK_MGT_OFF)
+#define PRCM_MCDECLK_MGT           (_PRCMU_BASE + PRCM_MCDECLK_MGT_OFF)
+#define PRCM_HDMICLK_MGT           (_PRCMU_BASE + PRCM_HDMICLK_MGT_OFF)
+#define PRCM_TVCLK_MGT             (_PRCMU_BASE + PRCM_TVCLK_MGT_OFF)
+#define PRCM_DSI_PLLOUT_SEL        (_PRCMU_BASE + 0x530)
+#define PRCM_DSITVCLK_DIV          (_PRCMU_BASE + 0x52C)
+#define PRCM_PLLDSI_LOCKP          (_PRCMU_BASE + 0x508)
+#define PRCM_APE_RESETN_SET        (_PRCMU_BASE + 0x1E4)
+#define PRCM_APE_RESETN_CLR        (_PRCMU_BASE + 0x1E8)
+
+#define PRCM_CLKOCR		   (_PRCMU_BASE + 0x1CC)
+#define PRCM_CLKOCR_CLKOUT0_REF_CLK	(1 << 0)
+#define PRCM_CLKOCR_CLKOUT0_MASK	BITS(0, 13)
+#define PRCM_CLKOCR_CLKOUT1_REF_CLK	(1 << 16)
+#define PRCM_CLKOCR_CLKOUT1_MASK	BITS(16, 29)
+
+/* ePOD and memory power signal control registers */
+#define PRCM_EPOD_C_SET            (_PRCMU_BASE + 0x410)
+#define PRCM_SRAM_LS_SLEEP         (_PRCMU_BASE + 0x304)
+
+/* Debug power control unit registers */
+#define PRCM_POWER_STATE_SET       (_PRCMU_BASE + 0x254)
+
+/* Miscellaneous unit registers */
+#define PRCM_DSI_SW_RESET          (_PRCMU_BASE + 0x324)
+#define PRCM_GPIOCR                (_PRCMU_BASE + 0x138)
+#define PRCM_GPIOCR_DBG_STM_MOD_CMD1            0x800
+#define PRCM_GPIOCR_DBG_UARTMOD_CMD0            0x1
 
 /* PRCMU HW semaphore */
-#define PRCM_SEM 0x400
+#define PRCM_SEM                   (_PRCMU_BASE + 0x400)
 #define PRCM_SEM_PRCM_SEM BIT(0)
 
-/* PRCMU clock/PLL/reset registers */
-#define PRCM_PLLDSI_FREQ	0x500
-#define PRCM_PLLDSI_ENABLE	0x504
-#define PRCM_PLLDSI_LOCKP	0x508
-#define PRCM_DSI_PLLOUT_SEL	0x530
-#define PRCM_DSITVCLK_DIV	0x52C
-#define PRCM_APE_RESETN_SET	0x1E4
-#define PRCM_APE_RESETN_CLR	0x1E8
-
-#define PRCM_TCR		0x1C8
-#define PRCM_TCR_TENSEL_MASK	BITS(0, 7)
-#define PRCM_TCR_STOP_TIMERS	BIT(16)
-#define PRCM_TCR_DOZE_MODE	BIT(17)
-
-#define PRCM_CLKOCR			0x1CC
+#define PRCM_TCR                   (_PRCMU_BASE + 0x1C8)
+#define PRCM_TCR_TENSEL_MASK       BITS(0, 7)
+#define PRCM_TCR_STOP_TIMERS       BIT(16)
+#define PRCM_TCR_DOZE_MODE         BIT(17)
+
 #define PRCM_CLKOCR_CLKODIV0_SHIFT	0
 #define PRCM_CLKOCR_CLKODIV0_MASK	BITS(0, 5)
 #define PRCM_CLKOCR_CLKOSEL0_SHIFT	6
@@ -112,55 +183,22 @@
 #define PRCM_CLKOCR_CLKOSEL1_MASK	BITS(22, 24)
 #define PRCM_CLKOCR_CLK1TYPE		BIT(28)
 
-#define PRCM_SGACLK_MGT		0x014
-#define PRCM_UARTCLK_MGT	0x018
-#define PRCM_MSP02CLK_MGT	0x01C
-#define PRCM_MSP1CLK_MGT	0x288
-#define PRCM_I2CCLK_MGT		0x020
-#define PRCM_SDMMCCLK_MGT	0x024
-#define PRCM_SLIMCLK_MGT	0x028
-#define PRCM_PER1CLK_MGT	0x02C
-#define PRCM_PER2CLK_MGT	0x030
-#define PRCM_PER3CLK_MGT	0x034
-#define PRCM_PER5CLK_MGT	0x038
-#define PRCM_PER6CLK_MGT	0x03C
-#define PRCM_PER7CLK_MGT	0x040
-#define PRCM_LCDCLK_MGT		0x044
-#define PRCM_BMLCLK_MGT		0x04C
-#define PRCM_HSITXCLK_MGT	0x050
-#define PRCM_HSIRXCLK_MGT	0x054
-#define PRCM_HDMICLK_MGT	0x058
-#define PRCM_APEATCLK_MGT	0x05C
-#define PRCM_APETRACECLK_MGT	0x060
-#define PRCM_MCDECLK_MGT	0x064
-#define PRCM_IPI2CCLK_MGT	0x068
-#define PRCM_DSIALTCLK_MGT	0x06C
-#define PRCM_DMACLK_MGT		0x074
-#define PRCM_B2R2CLK_MGT	0x078
-#define PRCM_TVCLK_MGT		0x07C
-#define PRCM_UNIPROCLK_MGT	0x278
-#define PRCM_SSPCLK_MGT		0x280
-#define PRCM_RNGCLK_MGT		0x284
-#define PRCM_UICCCLK_MGT	0x27C
-
 #define PRCM_CLK_MGT_CLKPLLDIV_MASK	BITS(0, 4)
 #define PRCM_CLK_MGT_CLKPLLSW_MASK	BITS(5, 7)
 #define PRCM_CLK_MGT_CLKEN		BIT(8)
 
-/* ePOD and memory power signal control registers */
-#define PRCM_EPOD_C_SET		0x410
-#define PRCM_SRAM_LS_SLEEP	0x304
+/* GPIOCR register */
+#define PRCM_GPIOCR_SPI2_SELECT BIT(23)
 
-/* Debug power control unit registers */
-#define PRCM_POWER_STATE_SET 0x254
+#define PRCM_DDR_SUBSYS_APE_MINBW	(_PRCMU_BASE + 0x438)
+#define PRCM_CGATING_BYPASS		(_PRCMU_BASE + 0x134)
+#define PRCM_CGATING_BYPASS_ICN2	BIT(6)
 
 /* Miscellaneous unit registers */
-#define PRCM_DSI_SW_RESET 0x324
-#define PRCM_GPIOCR		0x138
-
-/* GPIOCR register */
-#define PRCM_GPIOCR_SPI2_SELECT BIT(23)
+#define PRCM_RESOUTN_SET		(_PRCMU_BASE + 0x214)
+#define PRCM_RESOUTN_CLR		(_PRCMU_BASE + 0x218)
 
-#define PRCM_DDR_SUBSYS_APE_MINBW  0x438
+/* System reset register */
+#define PRCM_APE_SOFTRST		(_PRCMU_BASE + 0x228)
 
 #endif /* __DB8500_PRCMU_REGS_H */
diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 02a15d7..b5bd245 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -412,7 +412,7 @@ struct clk_mgt {
 
 static DEFINE_SPINLOCK(clk_mgt_lock);
 
-#define CLK_MGT_ENTRY(_name)[PRCMU_##_name] = { (PRCM_##_name##_MGT), 0 }
+#define CLK_MGT_ENTRY(_name)[PRCMU_##_name] = { (PRCM_##_name##_MGT_OFF), 0 }
 struct clk_mgt clk_mgt[PRCMU_NUM_REG_CLOCKS] = {
 	CLK_MGT_ENTRY(SGACLK),
 	CLK_MGT_ENTRY(UARTCLK),
@@ -499,45 +499,41 @@ int prcmu_enable_dsipll(void)
 	unsigned int plldsifreq;
 
 	/* Clear DSIPLL_RESETN */
-	writel(PRCMU_RESET_DSIPLL, (_PRCMU_BASE + PRCM_APE_RESETN_CLR));
+	writel(PRCMU_RESET_DSIPLL, PRCM_APE_RESETN_CLR);
 	/* Unclamp DSIPLL in/out */
-	writel(PRCMU_UNCLAMP_DSIPLL, (_PRCMU_BASE + PRCM_MMIP_LS_CLAMP_CLR));
+	writel(PRCMU_UNCLAMP_DSIPLL, PRCM_MMIP_LS_CLAMP_CLR);
 
 	if (prcmu_is_u8400())
 		plldsifreq = PRCMU_PLLDSI_FREQ_SETTING_U8400;
 	else
 		plldsifreq = PRCMU_PLLDSI_FREQ_SETTING;
 	/* Set DSI PLL FREQ */
-	writel(plldsifreq, (_PRCMU_BASE + PRCM_PLLDSI_FREQ));
-	writel(PRCMU_DSI_PLLOUT_SEL_SETTING,
-		(_PRCMU_BASE + PRCM_DSI_PLLOUT_SEL));
+	writel(plldsifreq, PRCM_PLLDSI_FREQ);
+	writel(PRCMU_DSI_PLLOUT_SEL_SETTING, PRCM_DSI_PLLOUT_SEL);
 	/* Enable Escape clocks */
-	writel(PRCMU_ENABLE_ESCAPE_CLOCK_DIV,
-					(_PRCMU_BASE + PRCM_DSITVCLK_DIV));
+	writel(PRCMU_ENABLE_ESCAPE_CLOCK_DIV, PRCM_DSITVCLK_DIV);
 
 	/* Start DSI PLL */
-	writel(PRCMU_ENABLE_PLLDSI, (_PRCMU_BASE + PRCM_PLLDSI_ENABLE));
+	writel(PRCMU_ENABLE_PLLDSI, PRCM_PLLDSI_ENABLE);
 	/* Reset DSI PLL */
-	writel(PRCMU_DSI_RESET_SW, (_PRCMU_BASE + PRCM_DSI_SW_RESET));
+	writel(PRCMU_DSI_RESET_SW, PRCM_DSI_SW_RESET);
 	for (i = 0; i < 10; i++) {
-		if ((readl(_PRCMU_BASE + PRCM_PLLDSI_LOCKP) &
-			PRCMU_PLLDSI_LOCKP_LOCKED)
+		if ((readl(PRCM_PLLDSI_LOCKP) & PRCMU_PLLDSI_LOCKP_LOCKED)
 					== PRCMU_PLLDSI_LOCKP_LOCKED)
 			break;
 		udelay(100);
 	}
 	/* Set DSIPLL_RESETN */
-	writel(PRCMU_RESET_DSIPLL, (_PRCMU_BASE + PRCM_APE_RESETN_SET));
+	writel(PRCMU_RESET_DSIPLL, PRCM_APE_RESETN_SET);
 	return 0;
 }
 
 int prcmu_disable_dsipll(void)
 {
 	/* Disable dsi pll */
-	writel(PRCMU_DISABLE_PLLDSI, (_PRCMU_BASE + PRCM_PLLDSI_ENABLE));
+	writel(PRCMU_DISABLE_PLLDSI, PRCM_PLLDSI_ENABLE);
 	/* Disable  escapeclock */
-	writel(PRCMU_DISABLE_ESCAPE_CLOCK_DIV,
-					(_PRCMU_BASE + PRCM_DSITVCLK_DIV));
+	writel(PRCMU_DISABLE_ESCAPE_CLOCK_DIV, PRCM_DSITVCLK_DIV);
 	return 0;
 }
 
@@ -554,15 +550,15 @@ int prcmu_set_display_clocks(void)
 	spin_lock_irqsave(&clk_mgt_lock, flags);
 
 	/* Grab the HW semaphore. */
-	while ((readl(_PRCMU_BASE + PRCM_SEM) & PRCM_SEM_PRCM_SEM) != 0)
+	while ((readl(PRCM_SEM) & PRCM_SEM_PRCM_SEM) != 0)
 		cpu_relax();
 
-	writel(dsiclk, (_PRCMU_BASE + PRCM_HDMICLK_MGT));
-	writel(PRCMU_DSI_LP_CLOCK_SETTING, (_PRCMU_BASE + PRCM_TVCLK_MGT));
-	writel(PRCMU_DPI_CLOCK_SETTING, (_PRCMU_BASE + PRCM_LCDCLK_MGT));
+	writel(dsiclk, PRCM_HDMICLK_MGT);
+	writel(PRCMU_DSI_LP_CLOCK_SETTING, PRCM_TVCLK_MGT);
+	writel(PRCMU_DPI_CLOCK_SETTING, PRCM_LCDCLK_MGT);
 
 	/* Release the HW semaphore. */
-	writel(0, (_PRCMU_BASE + PRCM_SEM));
+	writel(0, PRCM_SEM);
 
 	spin_unlock_irqrestore(&clk_mgt_lock, flags);
 
@@ -578,8 +574,8 @@ void prcmu_enable_spi2(void)
 	unsigned long flags;
 
 	spin_lock_irqsave(&gpiocr_lock, flags);
-	reg = readl(_PRCMU_BASE + PRCM_GPIOCR);
-	writel(reg | PRCM_GPIOCR_SPI2_SELECT, _PRCMU_BASE + PRCM_GPIOCR);
+	reg = readl(PRCM_GPIOCR);
+	writel(reg | PRCM_GPIOCR_SPI2_SELECT, PRCM_GPIOCR);
 	spin_unlock_irqrestore(&gpiocr_lock, flags);
 }
 
@@ -592,8 +588,8 @@ void prcmu_disable_spi2(void)
 	unsigned long flags;
 
 	spin_lock_irqsave(&gpiocr_lock, flags);
-	reg = readl(_PRCMU_BASE + PRCM_GPIOCR);
-	writel(reg & ~PRCM_GPIOCR_SPI2_SELECT, _PRCMU_BASE + PRCM_GPIOCR);
+	reg = readl(PRCM_GPIOCR);
+	writel(reg & ~PRCM_GPIOCR_SPI2_SELECT, PRCM_GPIOCR);
 	spin_unlock_irqrestore(&gpiocr_lock, flags);
 }
 
@@ -701,7 +697,7 @@ int prcmu_config_clkout(u8 clkout, u8 source, u8 div)
 
 	spin_lock_irqsave(&clkout_lock, flags);
 
-	val = readl(_PRCMU_BASE + PRCM_CLKOCR);
+	val = readl(PRCM_CLKOCR);
 	if (val & div_mask) {
 		if (div) {
 			if ((val & mask) != bits) {
@@ -715,7 +711,7 @@ int prcmu_config_clkout(u8 clkout, u8 source, u8 div)
 			}
 		}
 	}
-	writel((bits | (val & ~mask)), (_PRCMU_BASE + PRCM_CLKOCR));
+	writel((bits | (val & ~mask)), PRCM_CLKOCR);
 	requests[clkout] += (div ? 1 : -1);
 
 unlock_and_return:
@@ -732,7 +728,7 @@ int prcmu_set_power_state(u8 state, bool keep_ulp_clk, bool keep_ap_pll)
 
 	spin_lock_irqsave(&mb0_transfer.lock, flags);
 
-	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(0))
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(0))
 		cpu_relax();
 
 	writeb(MB0H_POWER_STATE_TRANS, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB0));
@@ -741,7 +737,7 @@ int prcmu_set_power_state(u8 state, bool keep_ulp_clk, bool keep_ap_pll)
 	writeb((keep_ulp_clk ? 1 : 0),
 		(tcdm_base + PRCM_REQ_MB0_ULP_CLOCK_STATE));
 	writeb(0, (tcdm_base + PRCM_REQ_MB0_DO_NOT_WFI));
-	writel(MBOX_BIT(0), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+	writel(MBOX_BIT(0), PRCM_MBOX_CPU_SET);
 
 	spin_unlock_irqrestore(&mb0_transfer.lock, flags);
 
@@ -770,12 +766,12 @@ static void config_wakeups(void)
 		return;
 
 	for (i = 0; i < 2; i++) {
-		while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(0))
+		while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(0))
 			cpu_relax();
 		writel(dbb_events, (tcdm_base + PRCM_REQ_MB0_WAKEUP_8500));
 		writel(abb_events, (tcdm_base + PRCM_REQ_MB0_WAKEUP_4500));
 		writeb(header[i], (tcdm_base + PRCM_MBOX_HEADER_REQ_MB0));
-		writel(MBOX_BIT(0), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+		writel(MBOX_BIT(0), PRCM_MBOX_CPU_SET);
 	}
 	last_dbb_events = dbb_events;
 	last_abb_events = abb_events;
@@ -840,14 +836,14 @@ int prcmu_set_arm_opp(u8 opp)
 
 	mutex_lock(&mb1_transfer.lock);
 
-	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
 		cpu_relax();
 
 	writeb(MB1H_ARM_APE_OPP, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB1));
 	writeb(opp, (tcdm_base + PRCM_REQ_MB1_ARM_OPP));
 	writeb(APE_NO_CHANGE, (tcdm_base + PRCM_REQ_MB1_APE_OPP));
 
-	writel(MBOX_BIT(1), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
 	wait_for_completion(&mb1_transfer.work);
 
 	if ((mb1_transfer.ack.header != MB1H_ARM_APE_OPP) ||
@@ -876,7 +872,7 @@ int prcmu_get_arm_opp(void)
  */
 int prcmu_get_ddr_opp(void)
 {
-	return readb(_PRCMU_BASE + PRCM_DDR_SUBSYS_APE_MINBW);
+	return readb(PRCM_DDR_SUBSYS_APE_MINBW);
 }
 
 /**
@@ -892,7 +888,7 @@ int prcmu_set_ddr_opp(u8 opp)
 		return -EINVAL;
 	/* Changing the DDR OPP can hang the hardware pre-v21 */
 	if (cpu_is_u8500v20_or_later() && !cpu_is_u8500v20())
-		writeb(opp, (_PRCMU_BASE + PRCM_DDR_SUBSYS_APE_MINBW));
+		writeb(opp, PRCM_DDR_SUBSYS_APE_MINBW);
 
 	return 0;
 }
@@ -909,14 +905,14 @@ int prcmu_set_ape_opp(u8 opp)
 
 	mutex_lock(&mb1_transfer.lock);
 
-	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
 		cpu_relax();
 
 	writeb(MB1H_ARM_APE_OPP, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB1));
 	writeb(ARM_NO_CHANGE, (tcdm_base + PRCM_REQ_MB1_ARM_OPP));
 	writeb(opp, (tcdm_base + PRCM_REQ_MB1_APE_OPP));
 
-	writel(MBOX_BIT(1), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
 	wait_for_completion(&mb1_transfer.work);
 
 	if ((mb1_transfer.ack.header != MB1H_ARM_APE_OPP) ||
@@ -966,12 +962,12 @@ int prcmu_request_ape_opp_100_voltage(bool enable)
 		header = MB1H_RELEASE_APE_OPP_100_VOLT;
 	}
 
-	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
 		cpu_relax();
 
 	writeb(header, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB1));
 
-	writel(MBOX_BIT(1), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
 	wait_for_completion(&mb1_transfer.work);
 
 	if ((mb1_transfer.ack.header != header) ||
@@ -995,13 +991,13 @@ int prcmu_release_usb_wakeup_state(void)
 
 	mutex_lock(&mb1_transfer.lock);
 
-	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
 		cpu_relax();
 
 	writeb(MB1H_RELEASE_USB_WAKEUP,
 		(tcdm_base + PRCM_MBOX_HEADER_REQ_MB1));
 
-	writel(MBOX_BIT(1), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
 	wait_for_completion(&mb1_transfer.work);
 
 	if ((mb1_transfer.ack.header != MB1H_RELEASE_USB_WAKEUP) ||
@@ -1048,7 +1044,7 @@ int prcmu_set_epod(u16 epod_id, u8 epod_state)
 	mutex_lock(&mb2_transfer.lock);
 
 	/* wait for mailbox */
-	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(2))
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(2))
 		cpu_relax();
 
 	/* fill in mailbox */
@@ -1058,7 +1054,7 @@ int prcmu_set_epod(u16 epod_id, u8 epod_state)
 
 	writeb(MB2H_DPS, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB2));
 
-	writel(MBOX_BIT(2), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+	writel(MBOX_BIT(2), PRCM_MBOX_CPU_SET);
 
 	/*
 	 * The current firmware version does not handle errors correctly,
@@ -1145,13 +1141,13 @@ static int request_sysclk(bool enable)
 
 	spin_lock_irqsave(&mb3_transfer.lock, flags);
 
-	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(3))
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(3))
 		cpu_relax();
 
 	writeb((enable ? ON : OFF), (tcdm_base + PRCM_REQ_MB3_SYSCLK_MGT));
 
 	writeb(MB3H_SYSCLK, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB3));
-	writel(MBOX_BIT(3), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+	writel(MBOX_BIT(3), PRCM_MBOX_CPU_SET);
 
 	spin_unlock_irqrestore(&mb3_transfer.lock, flags);
 
@@ -1177,7 +1173,7 @@ static int request_timclk(bool enable)
 
 	if (!enable)
 		val |= PRCM_TCR_STOP_TIMERS;
-	writel(val, (_PRCMU_BASE + PRCM_TCR));
+	writel(val, PRCM_TCR);
 
 	return 0;
 }
@@ -1190,7 +1186,7 @@ static int request_reg_clock(u8 clock, bool enable)
 	spin_lock_irqsave(&clk_mgt_lock, flags);
 
 	/* Grab the HW semaphore. */
-	while ((readl(_PRCMU_BASE + PRCM_SEM) & PRCM_SEM_PRCM_SEM) != 0)
+	while ((readl(PRCM_SEM) & PRCM_SEM_PRCM_SEM) != 0)
 		cpu_relax();
 
 	val = readl(_PRCMU_BASE + clk_mgt[clock].offset);
@@ -1203,7 +1199,7 @@ static int request_reg_clock(u8 clock, bool enable)
 	writel(val, (_PRCMU_BASE + clk_mgt[clock].offset));
 
 	/* Release the HW semaphore. */
-	writel(0, (_PRCMU_BASE + PRCM_SEM));
+	writel(0, PRCM_SEM);
 
 	spin_unlock_irqrestore(&clk_mgt_lock, flags);
 
@@ -1238,7 +1234,7 @@ int prcmu_config_esram0_deep_sleep(u8 state)
 
 	mutex_lock(&mb4_transfer.lock);
 
-	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
 		cpu_relax();
 
 	writeb(MB4H_MEM_ST, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB4));
@@ -1248,7 +1244,7 @@ int prcmu_config_esram0_deep_sleep(u8 state)
 	       (tcdm_base + PRCM_REQ_MB4_DDR_ST_AP_DEEP_IDLE));
 	writeb(state, (tcdm_base + PRCM_REQ_MB4_ESRAM0_ST));
 
-	writel(MBOX_BIT(4), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+	writel(MBOX_BIT(4), PRCM_MBOX_CPU_SET);
 	wait_for_completion(&mb4_transfer.work);
 
 	mutex_unlock(&mb4_transfer.lock);
@@ -1260,13 +1256,13 @@ int prcmu_config_hotdog(u8 threshold)
 {
 	mutex_lock(&mb4_transfer.lock);
 
-	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
 		cpu_relax();
 
 	writeb(threshold, (tcdm_base + PRCM_REQ_MB4_HOTDOG_THRESHOLD));
 	writeb(MB4H_HOTDOG, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB4));
 
-	writel(MBOX_BIT(4), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+	writel(MBOX_BIT(4), PRCM_MBOX_CPU_SET);
 	wait_for_completion(&mb4_transfer.work);
 
 	mutex_unlock(&mb4_transfer.lock);
@@ -1278,7 +1274,7 @@ int prcmu_config_hotmon(u8 low, u8 high)
 {
 	mutex_lock(&mb4_transfer.lock);
 
-	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
 		cpu_relax();
 
 	writeb(low, (tcdm_base + PRCM_REQ_MB4_HOTMON_LOW));
@@ -1287,7 +1283,7 @@ int prcmu_config_hotmon(u8 low, u8 high)
 		(tcdm_base + PRCM_REQ_MB4_HOTMON_CONFIG));
 	writeb(MB4H_HOTMON, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB4));
 
-	writel(MBOX_BIT(4), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+	writel(MBOX_BIT(4), PRCM_MBOX_CPU_SET);
 	wait_for_completion(&mb4_transfer.work);
 
 	mutex_unlock(&mb4_transfer.lock);
@@ -1299,13 +1295,13 @@ static int config_hot_period(u16 val)
 {
 	mutex_lock(&mb4_transfer.lock);
 
-	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
 		cpu_relax();
 
 	writew(val, (tcdm_base + PRCM_REQ_MB4_HOT_PERIOD));
 	writeb(MB4H_HOT_PERIOD, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB4));
 
-	writel(MBOX_BIT(4), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+	writel(MBOX_BIT(4), PRCM_MBOX_CPU_SET);
 	wait_for_completion(&mb4_transfer.work);
 
 	mutex_unlock(&mb4_transfer.lock);
@@ -1345,7 +1341,7 @@ int prcmu_set_clock_divider(u8 clock, u8 divider)
 	spin_lock_irqsave(&clk_mgt_lock, flags);
 
 	/* Grab the HW semaphore. */
-	while ((readl(_PRCMU_BASE + PRCM_SEM) & PRCM_SEM_PRCM_SEM) != 0)
+	while ((readl(PRCM_SEM) & PRCM_SEM_PRCM_SEM) != 0)
 		cpu_relax();
 
 	val = readl(_PRCMU_BASE + clk_mgt[clock].offset);
@@ -1354,7 +1350,7 @@ int prcmu_set_clock_divider(u8 clock, u8 divider)
 	writel(val, (_PRCMU_BASE + clk_mgt[clock].offset));
 
 	/* Release the HW semaphore. */
-	writel(0, (_PRCMU_BASE + PRCM_SEM));
+	writel(0, PRCM_SEM);
 
 	spin_unlock_irqrestore(&clk_mgt_lock, flags);
 
@@ -1380,7 +1376,7 @@ int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
 
 	mutex_lock(&mb5_transfer.lock);
 
-	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(5))
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(5))
 		cpu_relax();
 
 	writeb(PRCMU_I2C_READ(slave), (tcdm_base + PRCM_REQ_MB5_I2C_SLAVE_OP));
@@ -1388,7 +1384,7 @@ int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
 	writeb(reg, (tcdm_base + PRCM_REQ_MB5_I2C_REG));
 	writeb(0, (tcdm_base + PRCM_REQ_MB5_I2C_VAL));
 
-	writel(MBOX_BIT(5), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+	writel(MBOX_BIT(5), PRCM_MBOX_CPU_SET);
 
 	if (!wait_for_completion_timeout(&mb5_transfer.work,
 				msecs_to_jiffies(20000))) {
@@ -1426,7 +1422,7 @@ int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
 
 	mutex_lock(&mb5_transfer.lock);
 
-	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(5))
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(5))
 		cpu_relax();
 
 	writeb(PRCMU_I2C_WRITE(slave), (tcdm_base + PRCM_REQ_MB5_I2C_SLAVE_OP));
@@ -1434,7 +1430,7 @@ int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
 	writeb(reg, (tcdm_base + PRCM_REQ_MB5_I2C_REG));
 	writeb(*value, (tcdm_base + PRCM_REQ_MB5_I2C_VAL));
 
-	writel(MBOX_BIT(5), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+	writel(MBOX_BIT(5), PRCM_MBOX_CPU_SET);
 
 	if (!wait_for_completion_timeout(&mb5_transfer.work,
 				msecs_to_jiffies(20000))) {
@@ -1459,14 +1455,13 @@ void prcmu_ac_wake_req(void)
 
 	mutex_lock(&mb0_transfer.ac_wake_lock);
 
-	val = readl(_PRCMU_BASE + PRCM_HOSTACCESS_REQ);
+	val = readl(PRCM_HOSTACCESS_REQ);
 	if (val & PRCM_HOSTACCESS_REQ_HOSTACCESS_REQ)
 		goto unlock_and_return;
 
 	atomic_set(&ac_wake_req_state, 1);
 
-	writel((val | PRCM_HOSTACCESS_REQ_HOSTACCESS_REQ),
-		(_PRCMU_BASE + PRCM_HOSTACCESS_REQ));
+	writel((val | PRCM_HOSTACCESS_REQ_HOSTACCESS_REQ), PRCM_HOSTACCESS_REQ);
 
 	if (!wait_for_completion_timeout(&mb0_transfer.ac_wake_work,
 			msecs_to_jiffies(20000))) {
@@ -1487,12 +1482,12 @@ void prcmu_ac_sleep_req()
 
 	mutex_lock(&mb0_transfer.ac_wake_lock);
 
-	val = readl(_PRCMU_BASE + PRCM_HOSTACCESS_REQ);
+	val = readl(PRCM_HOSTACCESS_REQ);
 	if (!(val & PRCM_HOSTACCESS_REQ_HOSTACCESS_REQ))
 		goto unlock_and_return;
 
 	writel((val & ~PRCM_HOSTACCESS_REQ_HOSTACCESS_REQ),
-		(_PRCMU_BASE + PRCM_HOSTACCESS_REQ));
+		PRCM_HOSTACCESS_REQ);
 
 	if (!wait_for_completion_timeout(&mb0_transfer.ac_wake_work,
 			msecs_to_jiffies(20000))) {
@@ -1520,7 +1515,7 @@ bool prcmu_is_ac_wake_requested(void)
 void prcmu_system_reset(u16 reset_code)
 {
 	writew(reset_code, (tcdm_base + PRCM_SW_RST_REASON));
-	writel(1, (_PRCMU_BASE + PRCM_APE_SOFTRST));
+	writel(1, PRCM_APE_SOFTRST);
 }
 
 /**
@@ -1530,11 +1525,11 @@ void prcmu_modem_reset(void)
 {
 	mutex_lock(&mb1_transfer.lock);
 
-	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
 		cpu_relax();
 
 	writeb(MB1H_RESET_MODEM, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB1));
-	writel(MBOX_BIT(1), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
 	wait_for_completion(&mb1_transfer.work);
 
 	/*
@@ -1551,11 +1546,11 @@ static void ack_dbb_wakeup(void)
 
 	spin_lock_irqsave(&mb0_transfer.lock, flags);
 
-	while (readl(_PRCMU_BASE + PRCM_MBOX_CPU_VAL) & MBOX_BIT(0))
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(0))
 		cpu_relax();
 
 	writeb(MB0H_READ_WAKEUP_ACK, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB0));
-	writel(MBOX_BIT(0), (_PRCMU_BASE + PRCM_MBOX_CPU_SET));
+	writel(MBOX_BIT(0), PRCM_MBOX_CPU_SET);
 
 	spin_unlock_irqrestore(&mb0_transfer.lock, flags);
 }
@@ -1600,7 +1595,7 @@ static bool read_mailbox_0(void)
 		r = false;
 		break;
 	}
-	writel(MBOX_BIT(0), (_PRCMU_BASE + PRCM_ARM_IT1_CLR));
+	writel(MBOX_BIT(0), PRCM_ARM_IT1_CLR);
 	return r;
 }
 
@@ -1613,7 +1608,7 @@ static bool read_mailbox_1(void)
 		PRCM_ACK_MB1_CURRENT_APE_OPP);
 	mb1_transfer.ack.ape_voltage_status = readb(tcdm_base +
 		PRCM_ACK_MB1_APE_VOLTAGE_STATUS);
-	writel(MBOX_BIT(1), (_PRCMU_BASE + PRCM_ARM_IT1_CLR));
+	writel(MBOX_BIT(1), PRCM_ARM_IT1_CLR);
 	complete(&mb1_transfer.work);
 	return false;
 }
@@ -1621,14 +1616,14 @@ static bool read_mailbox_1(void)
 static bool read_mailbox_2(void)
 {
 	mb2_transfer.ack.status = readb(tcdm_base + PRCM_ACK_MB2_DPS_STATUS);
-	writel(MBOX_BIT(2), (_PRCMU_BASE + PRCM_ARM_IT1_CLR));
+	writel(MBOX_BIT(2), PRCM_ARM_IT1_CLR);
 	complete(&mb2_transfer.work);
 	return false;
 }
 
 static bool read_mailbox_3(void)
 {
-	writel(MBOX_BIT(3), (_PRCMU_BASE + PRCM_ARM_IT1_CLR));
+	writel(MBOX_BIT(3), PRCM_ARM_IT1_CLR);
 	return false;
 }
 
@@ -1650,7 +1645,7 @@ static bool read_mailbox_4(void)
 		break;
 	}
 
-	writel(MBOX_BIT(4), (_PRCMU_BASE + PRCM_ARM_IT1_CLR));
+	writel(MBOX_BIT(4), PRCM_ARM_IT1_CLR);
 
 	if (do_complete)
 		complete(&mb4_transfer.work);
@@ -1662,20 +1657,20 @@ static bool read_mailbox_5(void)
 {
 	mb5_transfer.ack.status = readb(tcdm_base + PRCM_ACK_MB5_I2C_STATUS);
 	mb5_transfer.ack.value = readb(tcdm_base + PRCM_ACK_MB5_I2C_VAL);
-	writel(MBOX_BIT(5), (_PRCMU_BASE + PRCM_ARM_IT1_CLR));
+	writel(MBOX_BIT(5), PRCM_ARM_IT1_CLR);
 	complete(&mb5_transfer.work);
 	return false;
 }
 
 static bool read_mailbox_6(void)
 {
-	writel(MBOX_BIT(6), (_PRCMU_BASE + PRCM_ARM_IT1_CLR));
+	writel(MBOX_BIT(6), PRCM_ARM_IT1_CLR);
 	return false;
 }
 
 static bool read_mailbox_7(void)
 {
-	writel(MBOX_BIT(7), (_PRCMU_BASE + PRCM_ARM_IT1_CLR));
+	writel(MBOX_BIT(7), PRCM_ARM_IT1_CLR);
 	return false;
 }
 
@@ -1696,7 +1691,7 @@ static irqreturn_t prcmu_irq_handler(int irq, void *data)
 	u8 n;
 	irqreturn_t r;
 
-	bits = (readl(_PRCMU_BASE + PRCM_ARM_IT1_VAL) & ALL_MBOX_BITS);
+	bits = (readl(PRCM_ARM_IT1_VAL) & ALL_MBOX_BITS);
 	if (unlikely(!bits))
 		return IRQ_NONE;
 
@@ -2025,7 +2020,7 @@ static int __init db8500_prcmu_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	/* Clean up the mailbox interrupts after pre-kernel code. */
-	writel(ALL_MBOX_BITS, (_PRCMU_BASE + PRCM_ARM_IT1_CLR));
+	writel(ALL_MBOX_BITS, PRCM_ARM_IT1_CLR);
 
 	err = request_threaded_irq(IRQ_DB8500_PRCMU1, prcmu_irq_handler,
 		prcmu_irq_thread_fn, IRQF_NO_SUSPEND, "prcmu", NULL);
-- 
1.7.3.2

