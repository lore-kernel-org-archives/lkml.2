Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760Ab2D0MY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 08:24:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51505 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758577Ab2D0MYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 08:24:54 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <greg@kroah.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Aneesh V <aneesh@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v5 6/7] memory: emif: add one-time settings
Date: Fri, 27 Apr 2012 17:54:08 +0530
Message-ID: <1335529449-28046-7-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335529449-28046-1-git-send-email-santosh.shilimkar@ti.com>
References: <y>
 <1335529449-28046-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh V <aneesh@ti.com>

Add settings that are not dependent on frequency
or any other transient parameters. This includes
- power managment control init
- impedence calibration control
- frequency independent phy configuration registers
- initialization of temperature polling

Signed-off-by: Aneesh V <aneesh@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reviewed-by: Benoit Cousson <b-cousson@ti.com>
[santosh.shilimkar@ti.com: Moved to drivers/memory from drivers/misc]
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Tested-by: Lokesh Vutla <lokeshvutla@ti.com>
Cc: Greg KH <greg@kroah.com>
---
 drivers/memory/emif.c |  148 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 148 insertions(+), 0 deletions(-)

diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index a8dcf35..3dfffbb 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -78,6 +78,24 @@ static void set_ddr_clk_period(u32 freq)
 }
 
 /*
+ * Get bus width used by EMIF. Note that this may be different from the
+ * bus width of the DDR devices used. For instance two 16-bit DDR devices
+ * may be connected to a given CS of EMIF. In this case bus width as far
+ * as EMIF is concerned is 32, where as the DDR bus width is 16 bits.
+ */
+static u32 get_emif_bus_width(struct emif_data *emif)
+{
+	u32		width;
+	void __iomem	*base = emif->base;
+
+	width = (readl(base + EMIF_SDRAM_CONFIG) & NARROW_MODE_MASK)
+			>> NARROW_MODE_SHIFT;
+	width = width == 0 ? 32 : 16;
+
+	return width;
+}
+
+/*
  * Get the CL from SDRAM_CONFIG register
  */
 static u32 get_cl(struct emif_data *emif)
@@ -372,6 +390,70 @@ static u32 get_sdram_tim_3_shdw(const struct lpddr2_timings *timings,
 	return tim3;
 }
 
+static u32 get_zq_config_reg(const struct lpddr2_addressing *addressing,
+		bool cs1_used, bool cal_resistors_per_cs)
+{
+	u32 zq = 0, val = 0;
+
+	val = EMIF_ZQCS_INTERVAL_US * 1000 / addressing->tREFI_ns;
+	zq |= val << ZQ_REFINTERVAL_SHIFT;
+
+	val = DIV_ROUND_UP(T_ZQCL_DEFAULT_NS, T_ZQCS_DEFAULT_NS) - 1;
+	zq |= val << ZQ_ZQCL_MULT_SHIFT;
+
+	val = DIV_ROUND_UP(T_ZQINIT_DEFAULT_NS, T_ZQCL_DEFAULT_NS) - 1;
+	zq |= val << ZQ_ZQINIT_MULT_SHIFT;
+
+	zq |= ZQ_SFEXITEN_ENABLE << ZQ_SFEXITEN_SHIFT;
+
+	if (cal_resistors_per_cs)
+		zq |= ZQ_DUALCALEN_ENABLE << ZQ_DUALCALEN_SHIFT;
+	else
+		zq |= ZQ_DUALCALEN_DISABLE << ZQ_DUALCALEN_SHIFT;
+
+	zq |= ZQ_CS0EN_MASK; /* CS0 is used for sure */
+
+	val = cs1_used ? 1 : 0;
+	zq |= val << ZQ_CS1EN_SHIFT;
+
+	return zq;
+}
+
+static u32 get_temp_alert_config(const struct lpddr2_addressing *addressing,
+		const struct emif_custom_configs *custom_configs, bool cs1_used,
+		u32 sdram_io_width, u32 emif_bus_width)
+{
+	u32 alert = 0, interval, devcnt;
+
+	if (custom_configs && (custom_configs->mask &
+				EMIF_CUSTOM_CONFIG_TEMP_ALERT_POLL_INTERVAL))
+		interval = custom_configs->temp_alert_poll_interval_ms;
+	else
+		interval = TEMP_ALERT_POLL_INTERVAL_DEFAULT_MS;
+
+	interval *= 1000000;			/* Convert to ns */
+	interval /= addressing->tREFI_ns;	/* Convert to refresh cycles */
+	alert |= (interval << TA_REFINTERVAL_SHIFT);
+
+	/*
+	 * sdram_io_width is in 'log2(x) - 1' form. Convert emif_bus_width
+	 * also to this form and subtract to get TA_DEVCNT, which is
+	 * in log2(x) form.
+	 */
+	emif_bus_width = __fls(emif_bus_width) - 1;
+	devcnt = emif_bus_width - sdram_io_width;
+	alert |= devcnt << TA_DEVCNT_SHIFT;
+
+	/* DEVWDT is in 'log2(x) - 3' form */
+	alert |= (sdram_io_width - 2) << TA_DEVWDT_SHIFT;
+
+	alert |= 1 << TA_SFEXITEN_SHIFT;
+	alert |= 1 << TA_CS0EN_SHIFT;
+	alert |= (cs1_used ? 1 : 0) << TA_CS1EN_SHIFT;
+
+	return alert;
+}
+
 static u32 get_read_idle_ctrl_shdw(u8 volt_ramp)
 {
 	u32 idle = 0, val = 0;
@@ -815,6 +897,71 @@ static int __init_or_module setup_interrupts(struct emif_data *emif, u32 irq)
 
 }
 
+static void __init_or_module emif_onetime_settings(struct emif_data *emif)
+{
+	u32				pwr_mgmt_ctrl, zq, temp_alert_cfg;
+	void __iomem			*base = emif->base;
+	const struct lpddr2_addressing	*addressing;
+	const struct ddr_device_info	*device_info;
+
+	device_info = emif->plat_data->device_info;
+	addressing = get_addressing_table(device_info);
+
+	/*
+	 * Init power management settings
+	 * We don't know the frequency yet. Use a high frequency
+	 * value for a conservative timeout setting
+	 */
+	pwr_mgmt_ctrl = get_pwr_mgmt_ctrl(1000000000, emif,
+			emif->plat_data->ip_rev);
+	emif->lpmode = (pwr_mgmt_ctrl & LP_MODE_MASK) >> LP_MODE_SHIFT;
+	writel(pwr_mgmt_ctrl, base + EMIF_POWER_MANAGEMENT_CONTROL);
+
+	/* Init ZQ calibration settings */
+	zq = get_zq_config_reg(addressing, device_info->cs1_used,
+		device_info->cal_resistors_per_cs);
+	writel(zq, base + EMIF_SDRAM_OUTPUT_IMPEDANCE_CALIBRATION_CONFIG);
+
+	/* Check temperature level temperature level*/
+	get_temperature_level(emif);
+	if (emif->temperature_level == SDRAM_TEMP_VERY_HIGH_SHUTDOWN)
+		dev_emerg(emif->dev, "SDRAM temperature exceeds operating limit.. Needs shut down!!!\n");
+
+	/* Init temperature polling */
+	temp_alert_cfg = get_temp_alert_config(addressing,
+		emif->plat_data->custom_configs, device_info->cs1_used,
+		device_info->io_width, get_emif_bus_width(emif));
+	writel(temp_alert_cfg, base + EMIF_TEMPERATURE_ALERT_CONFIG);
+
+	/*
+	 * Program external PHY control registers that are not frequency
+	 * dependent
+	 */
+	if (emif->plat_data->phy_type != EMIF_PHY_TYPE_INTELLIPHY)
+		return;
+	writel(EMIF_EXT_PHY_CTRL_1_VAL, base + EMIF_EXT_PHY_CTRL_1_SHDW);
+	writel(EMIF_EXT_PHY_CTRL_5_VAL, base + EMIF_EXT_PHY_CTRL_5_SHDW);
+	writel(EMIF_EXT_PHY_CTRL_6_VAL, base + EMIF_EXT_PHY_CTRL_6_SHDW);
+	writel(EMIF_EXT_PHY_CTRL_7_VAL, base + EMIF_EXT_PHY_CTRL_7_SHDW);
+	writel(EMIF_EXT_PHY_CTRL_8_VAL, base + EMIF_EXT_PHY_CTRL_8_SHDW);
+	writel(EMIF_EXT_PHY_CTRL_9_VAL, base + EMIF_EXT_PHY_CTRL_9_SHDW);
+	writel(EMIF_EXT_PHY_CTRL_10_VAL, base + EMIF_EXT_PHY_CTRL_10_SHDW);
+	writel(EMIF_EXT_PHY_CTRL_11_VAL, base + EMIF_EXT_PHY_CTRL_11_SHDW);
+	writel(EMIF_EXT_PHY_CTRL_12_VAL, base + EMIF_EXT_PHY_CTRL_12_SHDW);
+	writel(EMIF_EXT_PHY_CTRL_13_VAL, base + EMIF_EXT_PHY_CTRL_13_SHDW);
+	writel(EMIF_EXT_PHY_CTRL_14_VAL, base + EMIF_EXT_PHY_CTRL_14_SHDW);
+	writel(EMIF_EXT_PHY_CTRL_15_VAL, base + EMIF_EXT_PHY_CTRL_15_SHDW);
+	writel(EMIF_EXT_PHY_CTRL_16_VAL, base + EMIF_EXT_PHY_CTRL_16_SHDW);
+	writel(EMIF_EXT_PHY_CTRL_17_VAL, base + EMIF_EXT_PHY_CTRL_17_SHDW);
+	writel(EMIF_EXT_PHY_CTRL_18_VAL, base + EMIF_EXT_PHY_CTRL_18_SHDW);
+	writel(EMIF_EXT_PHY_CTRL_19_VAL, base + EMIF_EXT_PHY_CTRL_19_SHDW);
+	writel(EMIF_EXT_PHY_CTRL_20_VAL, base + EMIF_EXT_PHY_CTRL_20_SHDW);
+	writel(EMIF_EXT_PHY_CTRL_21_VAL, base + EMIF_EXT_PHY_CTRL_21_SHDW);
+	writel(EMIF_EXT_PHY_CTRL_22_VAL, base + EMIF_EXT_PHY_CTRL_22_SHDW);
+	writel(EMIF_EXT_PHY_CTRL_23_VAL, base + EMIF_EXT_PHY_CTRL_23_SHDW);
+	writel(EMIF_EXT_PHY_CTRL_24_VAL, base + EMIF_EXT_PHY_CTRL_24_SHDW);
+}
+
 static void get_default_timings(struct emif_data *emif)
 {
 	struct emif_platform_data *pd = emif->plat_data;
@@ -1027,6 +1174,7 @@ static int __init_or_module emif_probe(struct platform_device *pdev)
 		goto error;
 	}
 
+	emif_onetime_settings(emif);
 	disable_and_clear_all_interrupts(emif);
 	setup_interrupts(emif, irq);
 
-- 
1.7.5.4

