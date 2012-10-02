Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab2JBNhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 09:37:47 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:45555 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752921Ab2JBNhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:37:45 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl/nomadik: support other alternate-C functions
Date: Tue, 2 Oct 2012 15:37:21 +0200
Message-ID: <1349185041-1810-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>

Upgrade nomadik pinctrl driver to enable selection of other
alternate-C[1-4] functions on some specific ux500 SoC pins.
Handling of those functions is done thanks to PRCM GPIOCR
registers. This was previously managed in PRCMU driver and
it was not really convenient. Idea is to provide a common
way to control all alternate functions.

Note that this improvement does not support the old-fashioned way
used to control nomadik pins, namely the "nmk_config_pin()" function
and its derivatives.

Signed-off-by: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
Reviewed-by: Philippe Langlais <philippe.langlais@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/plat-nomadik/include/plat/gpio-nomadik.h |   6 +
 arch/arm/plat-nomadik/include/plat/pincfg.h       |   2 +
 drivers/pinctrl/pinctrl-nomadik-db8500.c          | 289 +++++++++++++++++-
 drivers/pinctrl/pinctrl-nomadik-db8540.c          | 344 +++++++++++++++++++---
 drivers/pinctrl/pinctrl-nomadik.c                 | 101 ++++++-
 drivers/pinctrl/pinctrl-nomadik.h                 |  78 +++++
 6 files changed, 773 insertions(+), 47 deletions(-)

diff --git a/arch/arm/plat-nomadik/include/plat/gpio-nomadik.h b/arch/arm/plat-nomadik/include/plat/gpio-nomadik.h
index 826de74..c08a54d 100644
--- a/arch/arm/plat-nomadik/include/plat/gpio-nomadik.h
+++ b/arch/arm/plat-nomadik/include/plat/gpio-nomadik.h
@@ -45,6 +45,12 @@
 #define NMK_GPIO_ALT_B	2
 #define NMK_GPIO_ALT_C	(NMK_GPIO_ALT_A | NMK_GPIO_ALT_B)
 
+#define NMK_GPIO_ALT_CX_SHIFT 2
+#define NMK_GPIO_ALT_C1	((1<<NMK_GPIO_ALT_CX_SHIFT) | NMK_GPIO_ALT_C)
+#define NMK_GPIO_ALT_C2	((2<<NMK_GPIO_ALT_CX_SHIFT) | NMK_GPIO_ALT_C)
+#define NMK_GPIO_ALT_C3	((3<<NMK_GPIO_ALT_CX_SHIFT) | NMK_GPIO_ALT_C)
+#define NMK_GPIO_ALT_C4	((4<<NMK_GPIO_ALT_CX_SHIFT) | NMK_GPIO_ALT_C)
+
 /* Pull up/down values */
 enum nmk_gpio_pull {
 	NMK_GPIO_PULL_NONE,
diff --git a/arch/arm/plat-nomadik/include/plat/pincfg.h b/arch/arm/plat-nomadik/include/plat/pincfg.h
index 9c949c7..3b8ec60 100644
--- a/arch/arm/plat-nomadik/include/plat/pincfg.h
+++ b/arch/arm/plat-nomadik/include/plat/pincfg.h
@@ -25,6 +25,8 @@
  *	bit 19..20 - SLPM direction
  *	bit 21..22 - SLPM Value (if output)
  *	bit 23..25 - PDIS value (if input)
+ *	bit	26 - Gpio mode
+ *	bit	27 - Sleep mode
  *
  * to facilitate the definition, the following macros are provided
  *
diff --git a/drivers/pinctrl/pinctrl-nomadik-db8500.c b/drivers/pinctrl/pinctrl-nomadik-db8500.c
index ec6209d..debaa75b 100644
--- a/drivers/pinctrl/pinctrl-nomadik-db8500.c
+++ b/drivers/pinctrl/pinctrl-nomadik-db8500.c
@@ -725,10 +725,10 @@ static const struct nmk_pingroup nmk_db8500_groups[] = {
 	DB8500_PIN_GROUP(spi0_c_1, NMK_GPIO_ALT_C),
 	DB8500_PIN_GROUP(usbsim_c_2, NMK_GPIO_ALT_C),
 	DB8500_PIN_GROUP(i2c3_c_2, NMK_GPIO_ALT_C),
-	/* Other alt C1 column, these are still configured as alt C */
-	DB8500_PIN_GROUP(kp_oc1_1, NMK_GPIO_ALT_C),
-	DB8500_PIN_GROUP(spi2_oc1_1, NMK_GPIO_ALT_C),
-	DB8500_PIN_GROUP(spi2_oc1_2, NMK_GPIO_ALT_C),
+	/* Other alt C1 column */
+	DB8500_PIN_GROUP(kp_oc1_1, NMK_GPIO_ALT_C1),
+	DB8500_PIN_GROUP(spi2_oc1_1, NMK_GPIO_ALT_C1),
+	DB8500_PIN_GROUP(spi2_oc1_2, NMK_GPIO_ALT_C1),
 };
 
 /* We use this macro to define the groups applicable to a function */
@@ -860,6 +860,284 @@ static const struct nmk_function nmk_db8500_functions[] = {
 	FUNCTION(spi2),
 };
 
+static const struct prcm_gpiocr_altcx_pin_desc db8500_altcx_pins[] = {
+	PRCM_GPIOCR_ALTCX(23,	true, PRCM_IDX_GPIOCR1, 9,	/* STMAPE_CLK_a */
+				true, PRCM_IDX_GPIOCR1, 7,	/* SBAG_CLK_a */
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(24,	true, PRCM_IDX_GPIOCR1, 9,	/* STMAPE or U2_RXD ??? */
+				true, PRCM_IDX_GPIOCR1, 7,	/* SBAG_VAL_a */
+				true, PRCM_IDX_GPIOCR1, 10,	/* STM_MOD_CMD0 */
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(25,	true, PRCM_IDX_GPIOCR1, 9,	/* STMAPE_DAT_a[0] */
+				true, PRCM_IDX_GPIOCR1, 7,	/* SBAG_D_a[0] */
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(26,	true, PRCM_IDX_GPIOCR1, 9,	/* STMAPE_DAT_a[1] */
+				true, PRCM_IDX_GPIOCR1, 7,	/* SBAG_D_a[1] */
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(27,	true, PRCM_IDX_GPIOCR1, 9,	/* STMAPE_DAT_a[2] */
+				true, PRCM_IDX_GPIOCR1, 7,	/* SBAG_D_a[2] */
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(28,	true, PRCM_IDX_GPIOCR1, 9,	/* STMAPE_DAT_a[3] */
+				true, PRCM_IDX_GPIOCR1, 7,	/* SBAG_D_a[3] */
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(29,	false, 0, 0,
+				false, 0, 0,
+				true, PRCM_IDX_GPIOCR1, 10,	/* STM_MOD_CMD0 */
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(30,	false, 0, 0,
+				false, 0, 0,
+				true, PRCM_IDX_GPIOCR1, 10,	/* STM_MOD_CMD0 */
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(31,	false, 0, 0,
+				false, 0, 0,
+				true, PRCM_IDX_GPIOCR1, 10,	/* STM_MOD_CMD0 */
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(32,	false, 0, 0,
+				false, 0, 0,
+				true, PRCM_IDX_GPIOCR1, 10,	/* STM_MOD_CMD0 */
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(68,	true, PRCM_IDX_GPIOCR1, 18,	/* REMAP_SELECT_ON */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(69,	true, PRCM_IDX_GPIOCR1, 18,	/* REMAP_SELECT_ON */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(70,	true, PRCM_IDX_GPIOCR1, 5,	/* PTM_A9_D23 */
+				true, PRCM_IDX_GPIOCR2, 2,	/* DBG_ETM_R4_CMD0 */
+				true, PRCM_IDX_GPIOCR1, 11,	/* STM_MOD_CMD1 */
+				true, PRCM_IDX_GPIOCR1, 8	/* SBAG_CLK */
+	),
+	PRCM_GPIOCR_ALTCX(71,	true, PRCM_IDX_GPIOCR1, 5,	/* PTM_A9_D22 */
+				true, PRCM_IDX_GPIOCR2, 2,	/* DBG_ETM_R4_CMD0 */
+				true, PRCM_IDX_GPIOCR1, 11,	/* STM_MOD_CMD1 */
+				true, PRCM_IDX_GPIOCR1, 8	/* SBAG_D3 */
+	),
+	PRCM_GPIOCR_ALTCX(72,	true, PRCM_IDX_GPIOCR1, 5,	/* PTM_A9_D21 */
+				true, PRCM_IDX_GPIOCR2, 2,	/* DBG_ETM_R4_CMD0 */
+				true, PRCM_IDX_GPIOCR1, 11,	/* STM_MOD_CMD1 */
+				true, PRCM_IDX_GPIOCR1, 8	/* SBAG_D2 */
+	),
+	PRCM_GPIOCR_ALTCX(73,	true, PRCM_IDX_GPIOCR1, 5,	/* PTM_A9_D20 */
+				true, PRCM_IDX_GPIOCR2, 2,	/* DBG_ETM_R4_CMD0 */
+				true, PRCM_IDX_GPIOCR1, 11,	/* STM_MOD_CMD1 */
+				true, PRCM_IDX_GPIOCR1, 8	/* SBAG_D1 */
+	),
+	PRCM_GPIOCR_ALTCX(74,	true, PRCM_IDX_GPIOCR1, 5,	/* PTM_A9_D19 */
+				true, PRCM_IDX_GPIOCR2, 2,	/* DBG_ETM_R4_CMD0 */
+				true, PRCM_IDX_GPIOCR1, 11,	/* STM_MOD_CMD1 */
+				true, PRCM_IDX_GPIOCR1, 8	/* SBAG_D0 */
+	),
+	PRCM_GPIOCR_ALTCX(75,	true, PRCM_IDX_GPIOCR1, 5,	/* PTM_A9_D18 */
+				true, PRCM_IDX_GPIOCR2, 2,	/* DBG_ETM_R4_CMD0 */
+				true, PRCM_IDX_GPIOCR1, 0,	/* DBG_UARTMOD_CMD0 */
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(76,	true, PRCM_IDX_GPIOCR1, 5,	/* PTM_A9_D17 */
+				true, PRCM_IDX_GPIOCR2, 2,	/* DBG_ETM_R4_CMD0 */
+				true, PRCM_IDX_GPIOCR1, 0,	/* DBG_UARTMOD_CMD0 */
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(77,	true, PRCM_IDX_GPIOCR1, 5,	/* PTM_A9_D16 */
+				true, PRCM_IDX_GPIOCR2, 2,	/* DBG_ETM_R4_CMD0 */
+				false, 0, 0,
+				true, PRCM_IDX_GPIOCR1, 8	/* SBAG_VAL */
+	),
+	PRCM_GPIOCR_ALTCX(86,	true, PRCM_IDX_GPIOCR1, 12,	/* KP_O3 */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(87,	true, PRCM_IDX_GPIOCR1, 12,	/* KP_O2 */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(88,	true, PRCM_IDX_GPIOCR1, 12,	/* KP_I3 */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(89,	true, PRCM_IDX_GPIOCR1, 12,	/* KP_I2 */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(90,	true, PRCM_IDX_GPIOCR1, 12,	/* KP_O1 */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(91,	true, PRCM_IDX_GPIOCR1, 12,	/* KP_O0 */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(92,	true, PRCM_IDX_GPIOCR1, 12,	/* KP_I1 */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(93,	true, PRCM_IDX_GPIOCR1, 12,	/* KP_I0 */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(96,	true, PRCM_IDX_GPIOCR2, 3,	/* RF_INT */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(97,	true, PRCM_IDX_GPIOCR2, 1,	/* RF_CTRL */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(151,	false, 0, 0,
+				true, PRCM_IDX_GPIOCR1, 6,	/* PTM_A9_CTL */
+				true, PRCM_IDX_GPIOCR1, 15,	/* DBG_ETM_R4_CMD1*/
+				true, PRCM_IDX_GPIOCR1, 25	/* HW_OBS17 */
+	),
+	PRCM_GPIOCR_ALTCX(152,	true, PRCM_IDX_GPIOCR1, 4,	/* Hx_CLK */
+				true, PRCM_IDX_GPIOCR1, 6,	/* PTM_A9_CLK */
+				true, PRCM_IDX_GPIOCR1, 15,	/* DBG_ETM_R4_CMD1*/
+				true, PRCM_IDX_GPIOCR1, 25	/* HW_OBS16 */
+	),
+	PRCM_GPIOCR_ALTCX(153,	true, PRCM_IDX_GPIOCR1, 1,	/* UARTMOD_CMD1 */
+				true, PRCM_IDX_GPIOCR1, 14,	/* PTM_A9_D15 */
+				true, PRCM_IDX_GPIOCR1, 19,	/* DBG_ETM_R4_CMD2 */
+				true, PRCM_IDX_GPIOCR1, 25	/* HW_OBS15 */
+	),
+	PRCM_GPIOCR_ALTCX(154,	true, PRCM_IDX_GPIOCR1, 1,	/* UARTMOD_CMD1 */
+				true, PRCM_IDX_GPIOCR1, 14,	/* PTM_A9_D14 */
+				true, PRCM_IDX_GPIOCR1, 19,	/* DBG_ETM_R4_CMD2 */
+				true, PRCM_IDX_GPIOCR1, 25	/* HW_OBS14 */
+	),
+	PRCM_GPIOCR_ALTCX(155,	true, PRCM_IDX_GPIOCR1, 13,	/* STM_MOD_CMD2 */
+				true, PRCM_IDX_GPIOCR1, 14,	/* PTM_A9_D13 */
+				true, PRCM_IDX_GPIOCR1, 19,	/* DBG_ETM_R4_CMD2 */
+				true, PRCM_IDX_GPIOCR1, 25	/* HW_OBS13 */
+	),
+	PRCM_GPIOCR_ALTCX(156,	true, PRCM_IDX_GPIOCR1, 13,	/* STM_MOD_CMD2 */
+				true, PRCM_IDX_GPIOCR1, 14,	/* PTM_A9_D12 */
+				true, PRCM_IDX_GPIOCR1, 19,	/* DBG_ETM_R4_CMD2 */
+				true, PRCM_IDX_GPIOCR1, 25	/* HW_OBS12 */
+	),
+	PRCM_GPIOCR_ALTCX(157,	true, PRCM_IDX_GPIOCR1, 13,	/* STM_MOD_CMD2 */
+				true, PRCM_IDX_GPIOCR1, 14,	/* PTM_A9_D11 */
+				true, PRCM_IDX_GPIOCR1, 19,	/* DBG_ETM_R4_CMD2 */
+				true, PRCM_IDX_GPIOCR1, 25	/* HW_OBS11 */
+	),
+	PRCM_GPIOCR_ALTCX(158,	true, PRCM_IDX_GPIOCR1, 13,	/* STM_MOD_CMD2 */
+				true, PRCM_IDX_GPIOCR1, 14,	/* PTM_A9_D10 */
+				true, PRCM_IDX_GPIOCR1, 19,	/* DBG_ETM_R4_CMD2 */
+				true, PRCM_IDX_GPIOCR1, 25	/* HW_OBS10 */
+	),
+	PRCM_GPIOCR_ALTCX(159,	true, PRCM_IDX_GPIOCR1, 13,	/* STM_MOD_CMD2 */
+				true, PRCM_IDX_GPIOCR1, 14,	/* PTM_A9_D9 */
+				true, PRCM_IDX_GPIOCR1, 19,	/* DBG_ETM_R4_CMD2 */
+				true, PRCM_IDX_GPIOCR1, 25	/* HW_OBS9 */
+	),
+	PRCM_GPIOCR_ALTCX(160,	false, 0, 0,
+				true, PRCM_IDX_GPIOCR1, 14,	/* PTM_A9_D8 */
+				true, PRCM_IDX_GPIOCR1, 19,	/* DBG_ETM_R4_CMD2 */
+				true, PRCM_IDX_GPIOCR1, 25	/* HW_OBS8 */
+	),
+	PRCM_GPIOCR_ALTCX(161,	true, PRCM_IDX_GPIOCR1, 4,	/* Hx_GPIO7 */
+				true, PRCM_IDX_GPIOCR1, 6,	/* PTM_A9_D7 */
+				true, PRCM_IDX_GPIOCR1, 15,	/* DBG_ETM_R4_CMD1*/
+				true, PRCM_IDX_GPIOCR1, 24	/* HW_OBS7 */
+	),
+	PRCM_GPIOCR_ALTCX(162,	true, PRCM_IDX_GPIOCR1, 4,	/* Hx_GPIO6 */
+				true, PRCM_IDX_GPIOCR1, 6,	/* PTM_A9_D6 */
+				true, PRCM_IDX_GPIOCR1, 15,	/* DBG_ETM_R4_CMD1*/
+				true, PRCM_IDX_GPIOCR1, 24	/* HW_OBS6 */
+	),
+	PRCM_GPIOCR_ALTCX(163,	true, PRCM_IDX_GPIOCR1, 4,	/* Hx_GPIO5 */
+				true, PRCM_IDX_GPIOCR1, 6,	/* PTM_A9_D5 */
+				true, PRCM_IDX_GPIOCR1, 15,	/* DBG_ETM_R4_CMD1*/
+				true, PRCM_IDX_GPIOCR1, 24	/* HW_OBS5 */
+	),
+	PRCM_GPIOCR_ALTCX(164,	true, PRCM_IDX_GPIOCR1, 4,	/* Hx_GPIO4 */
+				true, PRCM_IDX_GPIOCR1, 6,	/* PTM_A9_D4 */
+				true, PRCM_IDX_GPIOCR1, 15,	/* DBG_ETM_R4_CMD1*/
+				true, PRCM_IDX_GPIOCR1, 24	/* HW_OBS4 */
+	),
+	PRCM_GPIOCR_ALTCX(165,	true, PRCM_IDX_GPIOCR1, 4,	/* Hx_GPIO3 */
+				true, PRCM_IDX_GPIOCR1, 6,	/* PTM_A9_D3 */
+				true, PRCM_IDX_GPIOCR1, 15,	/* DBG_ETM_R4_CMD1*/
+				true, PRCM_IDX_GPIOCR1, 24	/* HW_OBS3 */
+	),
+	PRCM_GPIOCR_ALTCX(166,	true, PRCM_IDX_GPIOCR1, 4,	/* Hx_GPIO2 */
+				true, PRCM_IDX_GPIOCR1, 6,	/* PTM_A9_D2 */
+				true, PRCM_IDX_GPIOCR1, 15,	/* DBG_ETM_R4_CMD1*/
+				true, PRCM_IDX_GPIOCR1, 24	/* HW_OBS2 */
+	),
+	PRCM_GPIOCR_ALTCX(167,	true, PRCM_IDX_GPIOCR1, 4,	/* Hx_GPIO1 */
+				true, PRCM_IDX_GPIOCR1, 6,	/* PTM_A9_D1 */
+				true, PRCM_IDX_GPIOCR1, 15,	/* DBG_ETM_R4_CMD1*/
+				true, PRCM_IDX_GPIOCR1, 24	/* HW_OBS1 */
+	),
+	PRCM_GPIOCR_ALTCX(168,	true, PRCM_IDX_GPIOCR1, 4,	/* Hx_GPIO0 */
+				true, PRCM_IDX_GPIOCR1, 6,	/* PTM_A9_D0 */
+				true, PRCM_IDX_GPIOCR1, 15,	/* DBG_ETM_R4_CMD1*/
+				true, PRCM_IDX_GPIOCR1, 24	/* HW_OBS0 */
+	),
+	PRCM_GPIOCR_ALTCX(170,	true, PRCM_IDX_GPIOCR2, 2,	/* RF_INT */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(171,	true, PRCM_IDX_GPIOCR2, 0,	/* RF_CTRL */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(215,	true, PRCM_IDX_GPIOCR1, 23,	/* SPI2_TXD */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(216,	true, PRCM_IDX_GPIOCR1, 23,	/* SPI2_FRM */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(217,	true, PRCM_IDX_GPIOCR1, 23,	/* SPI2_CLK */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(218,	true, PRCM_IDX_GPIOCR1, 23,	/* SPI2_RXD */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+};
+
+static const u16 db8500_prcm_gpiocr_regs[] = {
+	[PRCM_IDX_GPIOCR1] = 0x138,
+	[PRCM_IDX_GPIOCR2] = 0x574,
+};
+
 static const struct nmk_pinctrl_soc_data nmk_db8500_soc = {
 	.gpio_ranges = nmk_db8500_ranges,
 	.gpio_num_ranges = ARRAY_SIZE(nmk_db8500_ranges),
@@ -869,6 +1147,9 @@ static const struct nmk_pinctrl_soc_data nmk_db8500_soc = {
 	.nfunctions = ARRAY_SIZE(nmk_db8500_functions),
 	.groups = nmk_db8500_groups,
 	.ngroups = ARRAY_SIZE(nmk_db8500_groups),
+	.altcx_pins = db8500_altcx_pins,
+	.npins_altcx = ARRAY_SIZE(db8500_altcx_pins),
+	.prcm_gpiocr_registers = db8500_prcm_gpiocr_regs,
 };
 
 void __devinit
diff --git a/drivers/pinctrl/pinctrl-nomadik-db8540.c b/drivers/pinctrl/pinctrl-nomadik-db8540.c
index 3daf665..52fc301 100644
--- a/drivers/pinctrl/pinctrl-nomadik-db8540.c
+++ b/drivers/pinctrl/pinctrl-nomadik-db8540.c
@@ -778,50 +778,50 @@ static const struct nmk_pingroup nmk_db8540_groups[] = {
 	DB8540_PIN_GROUP(spi0_c_1, NMK_GPIO_ALT_C),
 	DB8540_PIN_GROUP(i2c3_c_1, NMK_GPIO_ALT_C),
 
-	/* Other alt C1 column, these are still configured as alt C */
-	DB8540_PIN_GROUP(spi3_oc1_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(stmape_oc1_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(u2_oc1_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(remap0_oc1_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(remap1_oc1_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(modobsrefclk_oc1_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(modobspwrctrl_oc1_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(modobsclkout_oc1_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(moduart1_oc1_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(modprcmudbg_oc1_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(modobsresout_oc1_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(modaccgpo_oc1_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(kp_oc1_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(modxmip_oc1_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(i2c6_oc1_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(u2txrx_oc1_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(u2ctsrts_oc1_1, NMK_GPIO_ALT_C),
+	/* Other alt C1 column */
+	DB8540_PIN_GROUP(spi3_oc1_1, NMK_GPIO_ALT_C1),
+	DB8540_PIN_GROUP(stmape_oc1_1, NMK_GPIO_ALT_C1),
+	DB8540_PIN_GROUP(u2_oc1_1, NMK_GPIO_ALT_C1),
+	DB8540_PIN_GROUP(remap0_oc1_1, NMK_GPIO_ALT_C1),
+	DB8540_PIN_GROUP(remap1_oc1_1, NMK_GPIO_ALT_C1),
+	DB8540_PIN_GROUP(modobsrefclk_oc1_1, NMK_GPIO_ALT_C1),
+	DB8540_PIN_GROUP(modobspwrctrl_oc1_1, NMK_GPIO_ALT_C1),
+	DB8540_PIN_GROUP(modobsclkout_oc1_1, NMK_GPIO_ALT_C1),
+	DB8540_PIN_GROUP(moduart1_oc1_1, NMK_GPIO_ALT_C1),
+	DB8540_PIN_GROUP(modprcmudbg_oc1_1, NMK_GPIO_ALT_C1),
+	DB8540_PIN_GROUP(modobsresout_oc1_1, NMK_GPIO_ALT_C1),
+	DB8540_PIN_GROUP(modaccgpo_oc1_1, NMK_GPIO_ALT_C1),
+	DB8540_PIN_GROUP(kp_oc1_1, NMK_GPIO_ALT_C1),
+	DB8540_PIN_GROUP(modxmip_oc1_1, NMK_GPIO_ALT_C1),
+	DB8540_PIN_GROUP(i2c6_oc1_1, NMK_GPIO_ALT_C1),
+	DB8540_PIN_GROUP(u2txrx_oc1_1, NMK_GPIO_ALT_C1),
+	DB8540_PIN_GROUP(u2ctsrts_oc1_1, NMK_GPIO_ALT_C1),
 
-	/* Other alt C2 column, these are still configured as alt C */
-	DB8540_PIN_GROUP(sbag_oc2_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(hxclk_oc2_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(modaccuart_oc2_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(stmmod_oc2_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(moduartstmmux_oc2_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(hxgpio_oc2_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(sbag_oc2_2, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(modobsservice_oc2_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(moduart0_oc2_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(stmape_oc2_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(u2_oc2_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(modxmip_oc2_1, NMK_GPIO_ALT_C),
+	/* Other alt C2 column */
+	DB8540_PIN_GROUP(sbag_oc2_1, NMK_GPIO_ALT_C2),
+	DB8540_PIN_GROUP(hxclk_oc2_1, NMK_GPIO_ALT_C2),
+	DB8540_PIN_GROUP(modaccuart_oc2_1, NMK_GPIO_ALT_C2),
+	DB8540_PIN_GROUP(stmmod_oc2_1, NMK_GPIO_ALT_C2),
+	DB8540_PIN_GROUP(moduartstmmux_oc2_1, NMK_GPIO_ALT_C2),
+	DB8540_PIN_GROUP(hxgpio_oc2_1, NMK_GPIO_ALT_C2),
+	DB8540_PIN_GROUP(sbag_oc2_2, NMK_GPIO_ALT_C2),
+	DB8540_PIN_GROUP(modobsservice_oc2_1, NMK_GPIO_ALT_C2),
+	DB8540_PIN_GROUP(moduart0_oc2_1, NMK_GPIO_ALT_C2),
+	DB8540_PIN_GROUP(stmape_oc2_1, NMK_GPIO_ALT_C2),
+	DB8540_PIN_GROUP(u2_oc2_1, NMK_GPIO_ALT_C2),
+	DB8540_PIN_GROUP(modxmip_oc2_1, NMK_GPIO_ALT_C2),
 
-	/* Other alt C3 column, these are still configured as alt C */
-	DB8540_PIN_GROUP(modaccgpo_oc3_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(tpui_oc3_1, NMK_GPIO_ALT_C),
+	/* Other alt C3 column */
+	DB8540_PIN_GROUP(modaccgpo_oc3_1, NMK_GPIO_ALT_C3),
+	DB8540_PIN_GROUP(tpui_oc3_1, NMK_GPIO_ALT_C3),
 
-	/* Other alt C4 column, these are still configured as alt C */
-	DB8540_PIN_GROUP(hwobs_oc4_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(moduart1txrx_oc4_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(moduart1rtscts_oc4_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(modaccuarttxrx_oc4_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(modaccuartrtscts_oc4_1, NMK_GPIO_ALT_C),
-	DB8540_PIN_GROUP(stmmod_oc4_1, NMK_GPIO_ALT_C),
+	/* Other alt C4 column */
+	DB8540_PIN_GROUP(hwobs_oc4_1, NMK_GPIO_ALT_C4),
+	DB8540_PIN_GROUP(moduart1txrx_oc4_1, NMK_GPIO_ALT_C4),
+	DB8540_PIN_GROUP(moduart1rtscts_oc4_1, NMK_GPIO_ALT_C4),
+	DB8540_PIN_GROUP(modaccuarttxrx_oc4_1, NMK_GPIO_ALT_C4),
+	DB8540_PIN_GROUP(modaccuartrtscts_oc4_1, NMK_GPIO_ALT_C4),
+	DB8540_PIN_GROUP(stmmod_oc4_1, NMK_GPIO_ALT_C4),
 
 };
 
@@ -981,6 +981,265 @@ static const struct nmk_function nmk_db8540_functions[] = {
 	FUNCTION(usb)
 };
 
+static const struct prcm_gpiocr_altcx_pin_desc db8540_altcx_pins[] = {
+	PRCM_GPIOCR_ALTCX(8,	true, PRCM_IDX_GPIOCR1, 20,	/* SPI3_CLK */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(9,	true, PRCM_IDX_GPIOCR1, 20,	/* SPI3_RXD */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(10,	true, PRCM_IDX_GPIOCR1, 20,	/* SPI3_FRM */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(11,	true, PRCM_IDX_GPIOCR1, 20,	/* SPI3_TXD */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(23,	true, PRCM_IDX_GPIOCR1, 9,	/* STMAPE_CLK_a */
+				true, PRCM_IDX_GPIOCR2, 10,	/* SBAG_CLK_a */
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(24,	true, PRCM_IDX_GPIOCR3, 30,	/* U2_RXD_g */
+				true, PRCM_IDX_GPIOCR2, 10,	/* SBAG_VAL_a */
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(25,	true, PRCM_IDX_GPIOCR1, 9,	/* STMAPE_DAT_a[0] */
+				true, PRCM_IDX_GPIOCR2, 10,	/* SBAG_D_a[0] */
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(26,	true, PRCM_IDX_GPIOCR1, 9,	/* STMAPE_DAT_a[1] */
+				true, PRCM_IDX_GPIOCR2, 10,	/* SBAG_D_a[1] */
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(27,	true, PRCM_IDX_GPIOCR1, 9,	/* STMAPE_DAT_a[2] */
+				true, PRCM_IDX_GPIOCR2, 10,	/* SBAG_D_a[2] */
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(28,	true, PRCM_IDX_GPIOCR1, 9,	/* STMAPE_DAT_a[3] */
+				true, PRCM_IDX_GPIOCR2, 10,	/* SBAG_D_a[3] */
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(64,	true, PRCM_IDX_GPIOCR1, 15,	/* MODOBS_REFCLK_REQ */
+				false, 0, 0,
+				true, PRCM_IDX_GPIOCR1, 2,	/* TPIU_CTL */
+				true, PRCM_IDX_GPIOCR2, 23	/* HW_OBS_APE_PRCMU[17] */
+	),
+	PRCM_GPIOCR_ALTCX(65,	true, PRCM_IDX_GPIOCR1, 19,	/* MODOBS_PWRCTRL0 */
+				true, PRCM_IDX_GPIOCR1, 24,	/* Hx_CLK */
+				true, PRCM_IDX_GPIOCR1, 2,	/* TPIU_CLK */
+				true, PRCM_IDX_GPIOCR2, 24	/* HW_OBS_APE_PRCMU[16] */
+	),
+	PRCM_GPIOCR_ALTCX(66,	true, PRCM_IDX_GPIOCR1, 15,	/* MODOBS_CLKOUT1 */
+				false, 0, 0,
+				true, PRCM_IDX_GPIOCR1, 2,	/* TPIU_D[15] */
+				true, PRCM_IDX_GPIOCR2, 25	/* HW_OBS_APE_PRCMU[15] */
+	),
+	PRCM_GPIOCR_ALTCX(67,	true, PRCM_IDX_GPIOCR1, 1,	/* MODUART1_TXD_a */
+				true, PRCM_IDX_GPIOCR1, 6,	/* MODACCUART_TXD_a */
+				true, PRCM_IDX_GPIOCR1, 2,	/* TPIU_D[14] */
+				true, PRCM_IDX_GPIOCR2, 26	/* HW_OBS_APE_PRCMU[14] */
+	),
+	PRCM_GPIOCR_ALTCX(70,	true, PRCM_IDX_GPIOCR3, 6,	/* MOD_PRCMU_DEBUG[17] */
+				true, PRCM_IDX_GPIOCR1, 10,	/* STMMOD_CLK_b */
+				true, PRCM_IDX_GPIOCR1, 2,	/* TPIU_D[13] */
+				true, PRCM_IDX_GPIOCR2, 27	/* HW_OBS_APE_PRCMU[13] */
+	),
+	PRCM_GPIOCR_ALTCX(71,	true, PRCM_IDX_GPIOCR3, 6,	/* MOD_PRCMU_DEBUG[16] */
+				true, PRCM_IDX_GPIOCR1, 10,	/* STMMOD_DAT_b[3] */
+				true, PRCM_IDX_GPIOCR1, 2,	/* TPIU_D[12] */
+				true, PRCM_IDX_GPIOCR2, 27	/* HW_OBS_APE_PRCMU[12] */
+	),
+	PRCM_GPIOCR_ALTCX(72,	true, PRCM_IDX_GPIOCR3, 6,	/* MOD_PRCMU_DEBUG[15] */
+				true, PRCM_IDX_GPIOCR1, 10,	/* STMMOD_DAT_b[2] */
+				true, PRCM_IDX_GPIOCR1, 2,	/* TPIU_D[11] */
+				true, PRCM_IDX_GPIOCR2, 27	/* HW_OBS_APE_PRCMU[11] */
+	),
+	PRCM_GPIOCR_ALTCX(73,	true, PRCM_IDX_GPIOCR3, 6,	/* MOD_PRCMU_DEBUG[14] */
+				true, PRCM_IDX_GPIOCR1, 10,	/* STMMOD_DAT_b[1] */
+				true, PRCM_IDX_GPIOCR1, 2,	/* TPIU_D[10] */
+				true, PRCM_IDX_GPIOCR2, 27	/* HW_OBS_APE_PRCMU[10] */
+	),
+	PRCM_GPIOCR_ALTCX(74,	true, PRCM_IDX_GPIOCR3, 6,	/* MOD_PRCMU_DEBUG[13] */
+				true, PRCM_IDX_GPIOCR1, 10,	/* STMMOD_DAT_b[0] */
+				true, PRCM_IDX_GPIOCR1, 2,	/* TPIU_D[9] */
+				true, PRCM_IDX_GPIOCR2, 27	/* HW_OBS_APE_PRCMU[9] */
+	),
+	PRCM_GPIOCR_ALTCX(75,	true, PRCM_IDX_GPIOCR1, 12,	/* MODOBS_RESOUT0_N */
+				true, PRCM_IDX_GPIOCR2, 1,	/* MODUART_STMMUX_RXD_b */
+				true, PRCM_IDX_GPIOCR1, 2,	/* TPIU_D[8] */
+				true, PRCM_IDX_GPIOCR2, 28	/* HW_OBS_APE_PRCMU[8] */
+	),
+	PRCM_GPIOCR_ALTCX(76,	true, PRCM_IDX_GPIOCR3, 7,	/* MOD_PRCMU_DEBUG[12] */
+				true, PRCM_IDX_GPIOCR1, 25,	/* Hx_GPIO[7] */
+				true, PRCM_IDX_GPIOCR1, 2,	/* TPIU_D[7] */
+				true, PRCM_IDX_GPIOCR2, 29	/* HW_OBS_APE_PRCMU[7] */
+	),
+	PRCM_GPIOCR_ALTCX(77,	true, PRCM_IDX_GPIOCR3, 7,	/* MOD_PRCMU_DEBUG[11] */
+				true, PRCM_IDX_GPIOCR1, 25,	/* Hx_GPIO[6] */
+				true, PRCM_IDX_GPIOCR1, 2,	/* TPIU_D[6] */
+				true, PRCM_IDX_GPIOCR2, 29	/* HW_OBS_APE_PRCMU[6] */
+	),
+	PRCM_GPIOCR_ALTCX(78,	true, PRCM_IDX_GPIOCR3, 7,	/* MOD_PRCMU_DEBUG[10] */
+				true, PRCM_IDX_GPIOCR1, 25,	/* Hx_GPIO[5] */
+				true, PRCM_IDX_GPIOCR1, 2,	/* TPIU_D[5] */
+				true, PRCM_IDX_GPIOCR2, 29	/* HW_OBS_APE_PRCMU[5] */
+	),
+	PRCM_GPIOCR_ALTCX(79,	true, PRCM_IDX_GPIOCR3, 7,	/* MOD_PRCMU_DEBUG[9] */
+				true, PRCM_IDX_GPIOCR1, 25,	/* Hx_GPIO[4] */
+				true, PRCM_IDX_GPIOCR1, 2,	/* TPIU_D[4] */
+				true, PRCM_IDX_GPIOCR2, 29	/* HW_OBS_APE_PRCMU[4] */
+	),
+	PRCM_GPIOCR_ALTCX(80,	true, PRCM_IDX_GPIOCR1, 26,	/* MODACC_GPO[0] */
+				true, PRCM_IDX_GPIOCR1, 25,	/* Hx_GPIO[3] */
+				true, PRCM_IDX_GPIOCR1, 2,	/* TPIU_D[3] */
+				true, PRCM_IDX_GPIOCR2, 30	/* HW_OBS_APE_PRCMU[3] */
+	),
+	PRCM_GPIOCR_ALTCX(81,	true, PRCM_IDX_GPIOCR2, 17,	/* MODACC_GPO[1] */
+				true, PRCM_IDX_GPIOCR1, 25,	/* Hx_GPIO[2] */
+				true, PRCM_IDX_GPIOCR1, 2,	/* TPIU_D[2] */
+				true, PRCM_IDX_GPIOCR2, 30	/* HW_OBS_APE_PRCMU[2] */
+	),
+	PRCM_GPIOCR_ALTCX(82,	true, PRCM_IDX_GPIOCR3, 8,	/* MOD_PRCMU_DEBUG[8] */
+				true, PRCM_IDX_GPIOCR1, 25,	/* Hx_GPIO[1] */
+				true, PRCM_IDX_GPIOCR1, 2,	/* TPIU_D[1] */
+				true, PRCM_IDX_GPIOCR2, 31	/* HW_OBS_APE_PRCMU[1] */
+	),
+	PRCM_GPIOCR_ALTCX(83,	true, PRCM_IDX_GPIOCR3, 8,	/* MOD_PRCMU_DEBUG[7] */
+				true, PRCM_IDX_GPIOCR1, 25,	/* Hx_GPIO[0] */
+				true, PRCM_IDX_GPIOCR1, 2,	/* TPIU_D[0] */
+				true, PRCM_IDX_GPIOCR2, 31	/* HW_OBS_APE_PRCMU[0] */
+	),
+	PRCM_GPIOCR_ALTCX(84,	true, PRCM_IDX_GPIOCR3, 9,	/* MOD_PRCMU_DEBUG[6] */
+				true, PRCM_IDX_GPIOCR1, 8,	/* SBAG_CLK_b */
+				true, PRCM_IDX_GPIOCR1, 3,	/* TPIU_D[23] */
+				true, PRCM_IDX_GPIOCR1, 16	/* MODUART1_RXD_b */
+	),
+	PRCM_GPIOCR_ALTCX(85,	true, PRCM_IDX_GPIOCR3, 9,	/* MOD_PRCMU_DEBUG[5] */
+				true, PRCM_IDX_GPIOCR1, 8,	/* SBAG_D_b[3] */
+				true, PRCM_IDX_GPIOCR1, 3,	/* TPIU_D[22] */
+				true, PRCM_IDX_GPIOCR1, 16	/* MODUART1_TXD_b */
+	),
+	PRCM_GPIOCR_ALTCX(86,	true, PRCM_IDX_GPIOCR3, 9,	/* MOD_PRCMU_DEBUG[0] */
+				true, PRCM_IDX_GPIOCR2, 18,	/* STMAPE_DAT_b[0] */
+				true, PRCM_IDX_GPIOCR1, 14,	/* TPIU_D[25] */
+				true, PRCM_IDX_GPIOCR1, 11	/* STMMOD_DAT_c[0] */
+	),
+	PRCM_GPIOCR_ALTCX(87,	true, PRCM_IDX_GPIOCR3, 0,	/* MODACC_GPO_a[5] */
+				true, PRCM_IDX_GPIOCR2, 3,	/* U2_RXD_c */
+				true, PRCM_IDX_GPIOCR1, 4,	/* TPIU_D[24] */
+				true, PRCM_IDX_GPIOCR1, 21	/* MODUART_STMMUX_RXD_c */
+	),
+	PRCM_GPIOCR_ALTCX(151,	true, PRCM_IDX_GPIOCR1, 18,	/* REMAP0 */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(152,	true, PRCM_IDX_GPIOCR1, 18,	/* REMAP1 */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(153,	true, PRCM_IDX_GPIOCR3, 2,	/* KP_O_b[6] */
+				true, PRCM_IDX_GPIOCR1, 8,	/* SBAG_D_b[2] */
+				true, PRCM_IDX_GPIOCR1, 3,	/* TPIU_D[21] */
+				true, PRCM_IDX_GPIOCR1, 0	/* MODUART1_RTS */
+	),
+	PRCM_GPIOCR_ALTCX(154,	true, PRCM_IDX_GPIOCR3, 2,	/* KP_I_b[6] */
+				true, PRCM_IDX_GPIOCR1, 8,	/* SBAG_D_b[1] */
+				true, PRCM_IDX_GPIOCR1, 3,	/* TPIU_D[20] */
+				true, PRCM_IDX_GPIOCR1, 0	/* MODUART1_CTS */
+	),
+	PRCM_GPIOCR_ALTCX(155,	true, PRCM_IDX_GPIOCR3, 3,	/* KP_O_b[5] */
+				true, PRCM_IDX_GPIOCR1, 8,	/* SBAG_D_b[0] */
+				true, PRCM_IDX_GPIOCR1, 3,	/* TPIU_D[19] */
+				true, PRCM_IDX_GPIOCR1, 5	/* MODACCUART_RXD_c */
+	),
+	PRCM_GPIOCR_ALTCX(156,	true, PRCM_IDX_GPIOCR3, 3,	/* KP_O_b[4] */
+				true, PRCM_IDX_GPIOCR1, 8,	/* SBAG_VAL_b */
+				true, PRCM_IDX_GPIOCR1, 3,	/* TPIU_D[18] */
+				true, PRCM_IDX_GPIOCR1, 5	/* MODACCUART_TXD_b */
+	),
+	PRCM_GPIOCR_ALTCX(157,	true, PRCM_IDX_GPIOCR3, 4,	/* KP_I_b[5] */
+				true, PRCM_IDX_GPIOCR1, 23,	/* MODOBS_SERVICE_N */
+				true, PRCM_IDX_GPIOCR1, 3,	/* TPIU_D[17] */
+				true, PRCM_IDX_GPIOCR1, 14	/* MODACCUART_RTS */
+	),
+	PRCM_GPIOCR_ALTCX(158,	true, PRCM_IDX_GPIOCR3, 4,	/* KP_I_b[4] */
+				true, PRCM_IDX_GPIOCR2, 0,	/* U2_TXD_c */
+				true, PRCM_IDX_GPIOCR1, 3,	/* TPIU_D[16] */
+				true, PRCM_IDX_GPIOCR1, 14	/* MODACCUART_CTS */
+	),
+	PRCM_GPIOCR_ALTCX(159,	true, PRCM_IDX_GPIOCR3, 5,	/* KP_O_b[3] */
+				true, PRCM_IDX_GPIOCR3, 10,	/* MODUART0_RXD */
+				true, PRCM_IDX_GPIOCR1, 4,	/* TPIU_D[31] */
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(160,	true, PRCM_IDX_GPIOCR3, 5,	/* KP_I_b[3] */
+				true, PRCM_IDX_GPIOCR3, 10,	/* MODUART0_TXD */
+				true, PRCM_IDX_GPIOCR1, 4,	/* TPIU_D[30] */
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(161,	true, PRCM_IDX_GPIOCR3, 9,	/* MOD_PRCMU_DEBUG[4] */
+				true, PRCM_IDX_GPIOCR2, 18,	/* STMAPE_CLK_b */
+				true, PRCM_IDX_GPIOCR1, 4,	/* TPIU_D[29] */
+				true, PRCM_IDX_GPIOCR1, 11	/* STMMOD_CLK_c */
+	),
+	PRCM_GPIOCR_ALTCX(162,	true, PRCM_IDX_GPIOCR3, 9,	/* MOD_PRCMU_DEBUG[3] */
+				true, PRCM_IDX_GPIOCR2, 18,	/* STMAPE_DAT_b[3] */
+				true, PRCM_IDX_GPIOCR1, 4,	/* TPIU_D[28] */
+				true, PRCM_IDX_GPIOCR1, 11	/* STMMOD_DAT_c[3] */
+	),
+	PRCM_GPIOCR_ALTCX(163,	true, PRCM_IDX_GPIOCR3, 9,	/* MOD_PRCMU_DEBUG[2] */
+				true, PRCM_IDX_GPIOCR2, 18,	/* STMAPE_DAT_b[2] */
+				true, PRCM_IDX_GPIOCR1, 4,	/* TPIU_D[27] */
+				true, PRCM_IDX_GPIOCR1, 11	/* STMMOD_DAT_c[2] */
+	),
+	PRCM_GPIOCR_ALTCX(164,	true, PRCM_IDX_GPIOCR3, 9,	/* MOD_PRCMU_DEBUG[1] */
+				true, PRCM_IDX_GPIOCR2, 18,	/* STMAPE_DAT_b[1] */
+				true, PRCM_IDX_GPIOCR1, 4,	/* TPIU_D[26] */
+				true, PRCM_IDX_GPIOCR1, 11	/* STMMOD_DAT_c[1] */
+	),
+	PRCM_GPIOCR_ALTCX(204,	true, PRCM_IDX_GPIOCR2, 2,	/* U2_RXD_f */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(205,	true, PRCM_IDX_GPIOCR2, 2,	/* U2_TXD_f */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(206,	true, PRCM_IDX_GPIOCR2, 2,	/* U2_CTSn_b */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+	PRCM_GPIOCR_ALTCX(207,	true, PRCM_IDX_GPIOCR2, 2,	/* U2_RTSn_b */
+				false, 0, 0,
+				false, 0, 0,
+				false, 0, 0
+	),
+};
+
+static const u16 db8540_prcm_gpiocr_regs[] = {
+	[PRCM_IDX_GPIOCR1] = 0x138,
+	[PRCM_IDX_GPIOCR2] = 0x574,
+	[PRCM_IDX_GPIOCR3] = 0x2bc,
+};
+
 static const struct nmk_pinctrl_soc_data nmk_db8540_soc = {
 	.gpio_ranges = nmk_db8540_ranges,
 	.gpio_num_ranges = ARRAY_SIZE(nmk_db8540_ranges),
@@ -990,6 +1249,9 @@ static const struct nmk_pinctrl_soc_data nmk_db8540_soc = {
 	.nfunctions = ARRAY_SIZE(nmk_db8540_functions),
 	.groups = nmk_db8540_groups,
 	.ngroups = ARRAY_SIZE(nmk_db8540_groups),
+	.altcx_pins = db8540_altcx_pins,
+	.npins_altcx = ARRAY_SIZE(db8540_altcx_pins),
+	.prcm_gpiocr_registers = db8540_prcm_gpiocr_regs,
 };
 
 void __devinit
diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 6030a51..67a5ef6 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -30,6 +30,7 @@
 #include <linux/pinctrl/pinconf.h>
 /* Since we request GPIOs from ourself */
 #include <linux/pinctrl/consumer.h>
+#include <linux/mfd/dbx500-prcmu.h>
 
 #include <asm/mach/irq.h>
 
@@ -237,6 +238,89 @@ nmk_gpio_disable_lazy_irq(struct nmk_gpio_chip *nmk_chip, unsigned offset)
 	dev_dbg(nmk_chip->chip.dev, "%d: clearing interrupt mask\n", gpio);
 }
 
+static void nmk_prcm_altcx_set_mode(struct nmk_pinctrl *npct,
+	unsigned offset, unsigned alt_num)
+{
+	int i;
+	u16 reg;
+	u8 bit;
+	u8 alt_index;
+	const struct prcm_gpiocr_altcx_pin_desc *pin_desc;
+	const u16 *gpiocr_regs;
+
+	if (alt_num > PRCM_IDX_GPIOCR_ALTC_MAX) {
+		dev_err(npct->dev, "PRCM GPIOCR: alternate-C%i is invalid\n",
+			alt_num);
+		return;
+	}
+
+	for (i = 0 ; i < npct->soc->npins_altcx ; i++) {
+		if (npct->soc->altcx_pins[i].pin == offset)
+			break;
+	}
+	if (i == npct->soc->npins_altcx) {
+		dev_dbg(npct->dev, "PRCM GPIOCR: pin %i is not found\n",
+			offset);
+		return;
+	}
+
+	pin_desc = npct->soc->altcx_pins + i;
+	gpiocr_regs = npct->soc->prcm_gpiocr_registers;
+
+	/*
+	 * If alt_num is NULL, just clear current ALTCx selection
+	 * to make sure we come back to a pure ALTC selection
+	 */
+	if (!alt_num) {
+		for (i = 0 ; i < PRCM_IDX_GPIOCR_ALTC_MAX ; i++) {
+			if (pin_desc->altcx[i].used == true) {
+				reg = gpiocr_regs[pin_desc->altcx[i].reg_index];
+				bit = pin_desc->altcx[i].control_bit;
+				if (prcmu_read(reg) & BIT(bit)) {
+					prcmu_write_masked(reg, BIT(bit), 0);
+					dev_dbg(npct->dev,
+						"PRCM GPIOCR: pin %i: alternate-C%i has been disabled\n",
+						offset, i+1);
+				}
+			}
+		}
+		return;
+	}
+
+	alt_index = alt_num - 1;
+	if (pin_desc->altcx[alt_index].used == false) {
+		dev_warn(npct->dev,
+			"PRCM GPIOCR: pin %i: alternate-C%i does not exist\n",
+			offset, alt_num);
+		return;
+	}
+
+	/*
+	 * Check if any other ALTCx functions are activated on this pin
+	 * and disable it first.
+	 */
+	for (i = 0 ; i < PRCM_IDX_GPIOCR_ALTC_MAX ; i++) {
+		if (i == alt_index)
+			continue;
+		if (pin_desc->altcx[i].used == true) {
+			reg = gpiocr_regs[pin_desc->altcx[i].reg_index];
+			bit = pin_desc->altcx[i].control_bit;
+			if (prcmu_read(reg) & BIT(bit)) {
+				prcmu_write_masked(reg, BIT(bit), 0);
+				dev_dbg(npct->dev,
+					"PRCM GPIOCR: pin %i: alternate-C%i has been disabled\n",
+					offset, i+1);
+			}
+		}
+	}
+
+	reg = gpiocr_regs[pin_desc->altcx[alt_index].reg_index];
+	bit = pin_desc->altcx[alt_index].control_bit;
+	dev_dbg(npct->dev, "PRCM GPIOCR: pin %i: alternate-C%i has been selected\n",
+		offset, alt_index+1);
+	prcmu_write_masked(reg, BIT(bit), BIT(bit));
+}
+
 static void __nmk_config_pin(struct nmk_gpio_chip *nmk_chip, unsigned offset,
 			     pin_cfg_t cfg, bool sleep, unsigned int *slpmregs)
 {
@@ -1441,7 +1525,7 @@ static int nmk_pmx_enable(struct pinctrl_dev *pctldev, unsigned function,
 	 * IOFORCE will switch *all* ports to their sleepmode setting to as
 	 * to avoid glitches. (Not just one port!)
 	 */
-	glitch = (g->altsetting == NMK_GPIO_ALT_C);
+	glitch = ((g->altsetting & NMK_GPIO_ALT_C) == NMK_GPIO_ALT_C);
 
 	if (glitch) {
 		spin_lock_irqsave(&nmk_gpio_slpm_lock, flags);
@@ -1491,8 +1575,21 @@ static int nmk_pmx_enable(struct pinctrl_dev *pctldev, unsigned function,
 		 */
 		nmk_gpio_disable_lazy_irq(nmk_chip, bit);
 
-		__nmk_gpio_set_mode_safe(nmk_chip, bit, g->altsetting, glitch);
+		__nmk_gpio_set_mode_safe(nmk_chip, bit,
+			(g->altsetting & NMK_GPIO_ALT_C), glitch);
 		clk_disable(nmk_chip->clk);
+
+		/*
+		 * Call PRCM GPIOCR config function in case ALTC
+		 * has been selected:
+		 * - If selection is a ALTCx, some bits in PRCM GPIOCR registers
+		 *   must be set.
+		 * - If selection is pure ALTC and previous selection was ALTCx,
+		 *   then some bits in PRCM GPIOCR registers must be cleared.
+		 */
+		if ((g->altsetting & NMK_GPIO_ALT_C) == NMK_GPIO_ALT_C)
+			nmk_prcm_altcx_set_mode(npct, g->pins[i],
+				g->altsetting >> NMK_GPIO_ALT_CX_SHIFT);
 	}
 
 	/* When all pins are successfully reconfigured we get here */
diff --git a/drivers/pinctrl/pinctrl-nomadik.h b/drivers/pinctrl/pinctrl-nomadik.h
index 5c99f1c..eef316e 100644
--- a/drivers/pinctrl/pinctrl-nomadik.h
+++ b/drivers/pinctrl/pinctrl-nomadik.h
@@ -8,6 +8,78 @@
 #define PINCTRL_NMK_DB8500	1
 #define PINCTRL_NMK_DB8540	2
 
+#define PRCM_GPIOCR_ALTCX(pin_num,\
+	altc1_used, altc1_ri, altc1_cb,\
+	altc2_used, altc2_ri, altc2_cb,\
+	altc3_used, altc3_ri, altc3_cb,\
+	altc4_used, altc4_ri, altc4_cb)\
+{\
+	.pin = pin_num,\
+	.altcx[PRCM_IDX_GPIOCR_ALTC1] = {\
+		.used = altc1_used,\
+		.reg_index = altc1_ri,\
+		.control_bit = altc1_cb\
+	},\
+	.altcx[PRCM_IDX_GPIOCR_ALTC2] = {\
+		.used = altc2_used,\
+		.reg_index = altc2_ri,\
+		.control_bit = altc2_cb\
+	},\
+	.altcx[PRCM_IDX_GPIOCR_ALTC3] = {\
+		.used = altc3_used,\
+		.reg_index = altc3_ri,\
+		.control_bit = altc3_cb\
+	},\
+	.altcx[PRCM_IDX_GPIOCR_ALTC4] = {\
+		.used = altc4_used,\
+		.reg_index = altc4_ri,\
+		.control_bit = altc4_cb\
+	},\
+}
+
+/**
+ * enum prcm_gpiocr_reg_index
+ * Used to reference an PRCM GPIOCR register address.
+ */
+enum prcm_gpiocr_reg_index {
+	PRCM_IDX_GPIOCR1,
+	PRCM_IDX_GPIOCR2,
+	PRCM_IDX_GPIOCR3
+};
+/**
+ * enum prcm_gpiocr_altcx_index
+ * Used to reference an Other alternate-C function.
+ */
+enum prcm_gpiocr_altcx_index {
+	PRCM_IDX_GPIOCR_ALTC1,
+	PRCM_IDX_GPIOCR_ALTC2,
+	PRCM_IDX_GPIOCR_ALTC3,
+	PRCM_IDX_GPIOCR_ALTC4,
+	PRCM_IDX_GPIOCR_ALTC_MAX,
+};
+
+/**
+ * struct prcm_gpio_altcx - Other alternate-C function
+ * @used: other alternate-C function availability
+ * @reg_index: PRCM GPIOCR register index used to control the function
+ * @control_bit: PRCM GPIOCR bit used to control the function
+ */
+struct prcm_gpiocr_altcx {
+	bool used:1;
+	u8 reg_index:2;
+	u8 control_bit:5;
+} __packed;
+
+/**
+ * struct prcm_gpio_altcx_pin_desc - Other alternate-C pin
+ * @pin: The pin number
+ * @altcx: array of other alternate-C[1-4] functions
+ */
+struct prcm_gpiocr_altcx_pin_desc {
+	unsigned short pin;
+	struct prcm_gpiocr_altcx altcx[PRCM_IDX_GPIOCR_ALTC_MAX];
+};
+
 /**
  * struct nmk_function - Nomadik pinctrl mux function
  * @name: The name of the function, exported to pinctrl core.
@@ -50,6 +122,9 @@ struct nmk_pingroup {
  * @nfunction:	The number of entries in @functions.
  * @groups:	An array describing all pin groups the pin SoC supports.
  * @ngroups:	The number of entries in @groups.
+ * @altcx_pins:	The pins that support Other alternate-C function on this SoC
+ * @npins_altcx: The number of Other alternate-C pins
+ * @prcm_gpiocr_registers: The array of PRCM GPIOCR registers on this SoC
  */
 struct nmk_pinctrl_soc_data {
 	struct pinctrl_gpio_range *gpio_ranges;
@@ -60,6 +135,9 @@ struct nmk_pinctrl_soc_data {
 	unsigned nfunctions;
 	const struct nmk_pingroup *groups;
 	unsigned ngroups;
+	const struct prcm_gpiocr_altcx_pin_desc *altcx_pins;
+	unsigned npins_altcx;
+	const u16 *prcm_gpiocr_registers;
 };
 
 #ifdef CONFIG_PINCTRL_STN8815
-- 
1.7.11.3

