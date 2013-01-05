Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab3AEMEB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 07:04:01 -0500
Received: from [216.228.121.140] ([216.228.121.140]:18025 "EHLO
	hqemgate03.nvidia.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab3AEMD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 07:03:58 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sat, 05 Jan 2013 04:03:15 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <linus.walleij@linaro.org>
CC: <praithatha@nvidia.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/2] pinctrl: tegra: add support for rcv-sel and drive type
Date: Sat, 5 Jan 2013 17:32:54 +0530
Message-ID: <1357387375-25919-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pritesh Raithatha <praithatha@nvidia.com>

NVIDIA's Tegra114 added two more configuration parameter in pinmux i.e.
rcv-sel and drive type.

rcv-sel: Select between High and Normal VIL/VIH receivers.
	RCVR_SEL=1: High VIL/VIH
	RCVR_SEL=0: Normal VIL/VIH

drv_type: Ouptput drive type:
	33-50 ohm driver: 0x1
	66-100ohm driver: 0x0

Add support of these parameters to be configure from DTS file.

Tegra20 and Tegra30 does not support this configuration and hence initialize their
pinmux structure with reg = -1.

Originally written by Pritesh Raithatha.
Changes by ldewangan:
	- remove drvtype_width as it is always 2.
	- Better describe the change.

Signed-off-by: Pritesh Raithatha <praithatha@nvidia.com>
Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/pinctrl/pinctrl-tegra.c   |   14 ++++++++++++++
 drivers/pinctrl/pinctrl-tegra.h   |   16 ++++++++++++++++
 drivers/pinctrl/pinctrl-tegra20.c |    6 ++++++
 drivers/pinctrl/pinctrl-tegra30.c |    4 ++++
 4 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c
index ae1e4bb..f195d77 100644
--- a/drivers/pinctrl/pinctrl-tegra.c
+++ b/drivers/pinctrl/pinctrl-tegra.c
@@ -201,6 +201,7 @@ static const struct cfg_param {
 	{"nvidia,open-drain",		TEGRA_PINCONF_PARAM_OPEN_DRAIN},
 	{"nvidia,lock",			TEGRA_PINCONF_PARAM_LOCK},
 	{"nvidia,io-reset",		TEGRA_PINCONF_PARAM_IORESET},
+	{"nvidia,rcv-sel",		TEGRA_PINCONF_PARAM_RCV_SEL},
 	{"nvidia,high-speed-mode",	TEGRA_PINCONF_PARAM_HIGH_SPEED_MODE},
 	{"nvidia,schmitt",		TEGRA_PINCONF_PARAM_SCHMITT},
 	{"nvidia,low-power-mode",	TEGRA_PINCONF_PARAM_LOW_POWER_MODE},
@@ -208,6 +209,7 @@ static const struct cfg_param {
 	{"nvidia,pull-up-strength",	TEGRA_PINCONF_PARAM_DRIVE_UP_STRENGTH},
 	{"nvidia,slew-rate-falling",	TEGRA_PINCONF_PARAM_SLEW_RATE_FALLING},
 	{"nvidia,slew-rate-rising",	TEGRA_PINCONF_PARAM_SLEW_RATE_RISING},
+	{"nvidia,drive-type",		TEGRA_PINCONF_PARAM_DRIVE_TYPE},
 };
 
 static int tegra_pinctrl_dt_subnode_to_map(struct device *dev,
@@ -450,6 +452,12 @@ static int tegra_pinconf_reg(struct tegra_pmx *pmx,
 		*bit = g->ioreset_bit;
 		*width = 1;
 		break;
+	case TEGRA_PINCONF_PARAM_RCV_SEL:
+		*bank = g->rcv_sel_bank;
+		*reg = g->rcv_sel_reg;
+		*bit = g->rcv_sel_bit;
+		*width = 1;
+		break;
 	case TEGRA_PINCONF_PARAM_HIGH_SPEED_MODE:
 		*bank = g->drv_bank;
 		*reg = g->drv_reg;
@@ -492,6 +500,12 @@ static int tegra_pinconf_reg(struct tegra_pmx *pmx,
 		*bit = g->slwr_bit;
 		*width = g->slwr_width;
 		break;
+	case TEGRA_PINCONF_PARAM_DRIVE_TYPE:
+		*bank = g->drvtype_bank;
+		*reg = g->drvtype_reg;
+		*bit = g->drvtype_bit;
+		*width = 2;
+		break;
 	default:
 		dev_err(pmx->dev, "Invalid config param %04x\n", param);
 		return -ENOTSUPP;
diff --git a/drivers/pinctrl/pinctrl-tegra.h b/drivers/pinctrl/pinctrl-tegra.h
index 62e3809..817f706 100644
--- a/drivers/pinctrl/pinctrl-tegra.h
+++ b/drivers/pinctrl/pinctrl-tegra.h
@@ -30,6 +30,8 @@ enum tegra_pinconf_param {
 	/* argument: Boolean */
 	TEGRA_PINCONF_PARAM_IORESET,
 	/* argument: Boolean */
+	TEGRA_PINCONF_PARAM_RCV_SEL,
+	/* argument: Boolean */
 	TEGRA_PINCONF_PARAM_HIGH_SPEED_MODE,
 	/* argument: Boolean */
 	TEGRA_PINCONF_PARAM_SCHMITT,
@@ -43,6 +45,8 @@ enum tegra_pinconf_param {
 	TEGRA_PINCONF_PARAM_SLEW_RATE_FALLING,
 	/* argument: Integer, range is HW-dependant */
 	TEGRA_PINCONF_PARAM_SLEW_RATE_RISING,
+	/* argument: Integer, range is HW-dependant */
+	TEGRA_PINCONF_PARAM_DRIVE_TYPE,
 };
 
 enum tegra_pinconf_pull {
@@ -95,6 +99,9 @@ struct tegra_function {
  * @ioreset_reg:	IO reset register offset. -1 if unsupported.
  * @ioreset_bank:	IO reset register bank. 0 if unsupported.
  * @ioreset_bit:	IO reset register bit. 0 if unsupported.
+ * @rcv_sel_reg:	Receiver select offset. -1 if unsupported.
+ * @rcv_sel_bank:	Receiver select bank. 0 if unsupported.
+ * @rcv_sel_bit:	Receiver select bit. 0 if unsupported.
  * @drv_reg:		Drive fields register offset. -1 if unsupported.
  *			This register contains the hsm, schmitt, lpmd, drvdn,
  *			drvup, slwr, and slwf parameters.
@@ -110,6 +117,9 @@ struct tegra_function {
  * @slwr_width:		Slew Rising field width. 0 if unsupported.
  * @slwf_bit:		Slew Falling register bit. 0 if unsupported.
  * @slwf_width:		Slew Falling field width. 0 if unsupported.
+ * @drvtype_reg:	Drive type fields register offset. -1 if unsupported.
+ * @drvtype_bank:	Drive type fields register bank. 0 if unsupported.
+ * @drvtype_bit:	Drive type register bit. 0 if unsupported.
  *
  * A representation of a group of pins (possibly just one pin) in the Tegra
  * pin controller. Each group allows some parameter or parameters to be
@@ -131,15 +141,19 @@ struct tegra_pingroup {
 	s16 odrain_reg;
 	s16 lock_reg;
 	s16 ioreset_reg;
+	s16 rcv_sel_reg;
 	s16 drv_reg;
+	s16 drvtype_reg;
 	u32 mux_bank:2;
 	u32 pupd_bank:2;
 	u32 tri_bank:2;
 	u32 einput_bank:2;
 	u32 odrain_bank:2;
 	u32 ioreset_bank:2;
+	u32 rcv_sel_bank:2;
 	u32 lock_bank:2;
 	u32 drv_bank:2;
+	u32 drvtype_bank:2;
 	u32 mux_bit:5;
 	u32 pupd_bit:5;
 	u32 tri_bit:5;
@@ -147,6 +161,7 @@ struct tegra_pingroup {
 	u32 odrain_bit:5;
 	u32 lock_bit:5;
 	u32 ioreset_bit:5;
+	u32 rcv_sel_bit:5;
 	u32 hsm_bit:5;
 	u32 schmitt_bit:5;
 	u32 lpmd_bit:5;
@@ -154,6 +169,7 @@ struct tegra_pingroup {
 	u32 drvup_bit:5;
 	u32 slwr_bit:5;
 	u32 slwf_bit:5;
+	u32 drvtype_bit:5;
 	u32 drvdn_width:6;
 	u32 drvup_width:6;
 	u32 slwr_width:6;
diff --git a/drivers/pinctrl/pinctrl-tegra20.c b/drivers/pinctrl/pinctrl-tegra20.c
index e848189..fcfb7d0 100644
--- a/drivers/pinctrl/pinctrl-tegra20.c
+++ b/drivers/pinctrl/pinctrl-tegra20.c
@@ -2624,7 +2624,9 @@ static const struct tegra_function tegra20_functions[] = {
 		.odrain_reg = -1,				\
 		.lock_reg = -1,					\
 		.ioreset_reg = -1,				\
+		.rcv_sel_reg = -1,				\
 		.drv_reg = -1,					\
+		.drvtype_reg = -1,				\
 	}
 
 /* Pin groups with only pull up and pull down control */
@@ -2642,7 +2644,9 @@ static const struct tegra_function tegra20_functions[] = {
 		.odrain_reg = -1,				\
 		.lock_reg = -1,					\
 		.ioreset_reg = -1,				\
+		.rcv_sel_reg = -1,				\
 		.drv_reg = -1,					\
+		.drvtype_reg = -1,				\
 	}
 
 /* Pin groups for drive strength registers (configurable version) */
@@ -2660,6 +2664,7 @@ static const struct tegra_function tegra20_functions[] = {
 		.odrain_reg = -1,				\
 		.lock_reg = -1,					\
 		.ioreset_reg = -1,				\
+		.rcv_sel_reg = -1,				\
 		.drv_reg = ((r) - PINGROUP_REG_A),		\
 		.drv_bank = 3,					\
 		.hsm_bit = hsm_b,				\
@@ -2673,6 +2678,7 @@ static const struct tegra_function tegra20_functions[] = {
 		.slwr_width = slwr_w,				\
 		.slwf_bit = slwf_b,				\
 		.slwf_width = slwf_w,				\
+		.drvtype_reg = -1,				\
 	}
 
 /* Pin groups for drive strength registers (simple version) */
diff --git a/drivers/pinctrl/pinctrl-tegra30.c b/drivers/pinctrl/pinctrl-tegra30.c
index 9ad87ea..2300deb 100644
--- a/drivers/pinctrl/pinctrl-tegra30.c
+++ b/drivers/pinctrl/pinctrl-tegra30.c
@@ -3384,7 +3384,9 @@ static const struct tegra_function tegra30_functions[] = {
 		.ioreset_reg = PINGROUP_REG_##ior(r),		\
 		.ioreset_bank = 1,				\
 		.ioreset_bit = 8,				\
+		.rcv_sel_reg = -1,				\
 		.drv_reg = -1,					\
+		.drvtype_reg = -1,				\
 	}
 
 #define DRV_PINGROUP(pg_name, r, hsm_b, schmitt_b, lpmd_b,	\
@@ -3401,6 +3403,7 @@ static const struct tegra_function tegra30_functions[] = {
 		.odrain_reg = -1,				\
 		.lock_reg = -1,					\
 		.ioreset_reg = -1,				\
+		.rcv_sel_reg = -1,				\
 		.drv_reg = ((r) - DRV_PINGROUP_REG_A),		\
 		.drv_bank = 0,					\
 		.hsm_bit = hsm_b,				\
@@ -3414,6 +3417,7 @@ static const struct tegra_function tegra30_functions[] = {
 		.slwr_width = slwr_w,				\
 		.slwf_bit = slwf_b,				\
 		.slwf_width = slwf_w,				\
+		.drvtype_reg = -1,				\
 	}
 
 static const struct tegra_pingroup tegra30_groups[] = {
-- 
1.7.1.1

