Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab2BDMRM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 07:17:12 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:45711 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753943Ab2BDMRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 07:17:07 -0500
From: Aneesh V <aneesh@ti.com>
To: linux-omap@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Aneesh V <aneesh@ti.com>
Subject: [RFC PATCH 5/8] misc: emif: handle frequency and voltage change events
Date: Sat,  4 Feb 2012 17:46:08 +0530
Message-Id: <1328357771-31644-6-git-send-email-aneesh@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1328357771-31644-1-git-send-email-aneesh@ti.com>
References: <1328357771-31644-1-git-send-email-aneesh@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change SDRAM timings and other settings as necessary
on voltage and frequency changes. We calculate these
register settings based on data from the device data
sheet and inputs such a frequency, voltage state(stable
or ramping), temperature level etc.

Signed-off-by: Aneesh V <aneesh@ti.com>
---
 drivers/misc/emif.c  |  741 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/emif.h |   97 +++++++
 2 files changed, 838 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/emif.c b/drivers/misc/emif.c
index ba1e3f9..36ba6f4 100644
--- a/drivers/misc/emif.c
+++ b/drivers/misc/emif.c
@@ -62,6 +62,527 @@ struct emif_data {
 };
 
 static struct emif_data *emif1;
+static u32 t_ck; /* DDR clock period in ps */
+
+/*
+ * Calculate the period of DDR clock from frequency value
+ */
+static void set_ddr_clk_period(u32 freq)
+{
+	/* Divide 10^12 by frequency to get period in ps */
+	t_ck = (u32)DIV_ROUND_UP_ULL(1000000000000ull, freq);
+}
+
+/*
+ * Get the CL from SDRAM_CONFIG register
+ */
+static u32 get_cl(struct emif_data *emif)
+{
+	u32		cl;
+	void __iomem	*base = emif->base;
+
+	cl = (readl(base + EMIF_SDRAM_CONFIG) & CL_MASK) >> CL_SHIFT;
+
+	return cl;
+}
+
+static void do_freq_update(void)
+{
+	/* TODO: Add an implementation when DVFS framework is available */
+}
+
+/* Find addressing table entry based on the device's type and density */
+static const struct lpddr2_addressing *get_addressing_table(
+	const struct ddr_device_info *device_info)
+{
+	u32		index, type, density;
+
+	type = device_info->type;
+	density = device_info->density;
+
+	switch (type) {
+	case DDR_TYPE_LPDDR2_S4:
+		index = density - 1;
+		break;
+	case DDR_TYPE_LPDDR2_S2:
+		switch (density) {
+		case DDR_DENSITY_1Gb:
+		case DDR_DENSITY_2Gb:
+			index = density + 3;
+			break;
+		default:
+			index = density - 1;
+		}
+		break;
+	default:
+		return NULL;
+	}
+
+	return &lpddr2_jedec_addressing_table[index];
+}
+
+/*
+ * Find the the right timing table from the array of timing
+ * tables of the device using DDR clock frequency
+ */
+static const struct lpddr2_timings *get_timings_table(struct emif_data *emif,
+		u32 freq)
+{
+	u32				i, min, max, freq_nearest;
+	const struct lpddr2_timings	*timings = NULL;
+	const struct lpddr2_timings	*timings_arr = emif->plat_data->timings;
+	struct				device *dev = emif->dev;
+
+	/* Start with a very high frequency - 1GHz */
+	freq_nearest = 1000000000;
+
+	/*
+	 * Find the timings table such that:
+	 *  1. the frequency range covers the required frequency(safe) AND
+	 *  2. the max_freq is closest to the required frequency(optimal)
+	 */
+	for (i = 0; i < emif->plat_data->timings_arr_size; i++) {
+		max = timings_arr[i].max_freq;
+		min = timings_arr[i].min_freq;
+		if ((freq >= min) && (freq <= max) && (max < freq_nearest)) {
+			freq_nearest = max;
+			timings = &timings_arr[i];
+		}
+	}
+
+	if (!timings)
+		dev_err(dev, "Couldn't find timings for - %dHz\n", freq);
+
+	dev_dbg(dev, "timings table: freq %d, speed bin freq %d\n",
+		freq, freq_nearest);
+
+	return timings;
+}
+
+static u32 get_sdram_ref_ctrl_shdw(u32 freq,
+		const struct lpddr2_addressing *addressing)
+{
+	u32 ref_ctrl_shdw = 0, val = 0, freq_khz, t_refi;
+
+	/* Scale down frequency and t_refi to avoid overflow */
+	freq_khz = freq / 1000;
+	t_refi = addressing->tREFI_ns / 100;
+
+	/*
+	 * refresh rate to be set is 'tREFI(in us) * freq in MHz
+	 * division by 10000 to account for change in units
+	 */
+	val = t_refi * freq_khz / 10000;
+	ref_ctrl_shdw |= val << REFRESH_RATE_SHIFT;
+
+	return ref_ctrl_shdw;
+}
+
+static u32 get_sdram_tim_1_shdw(const struct lpddr2_timings *timings,
+		const struct lpddr2_min_tck *min_tck,
+		const struct lpddr2_addressing *addressing,
+		u32 ip_rev)
+{
+	u32 tim1 = 0, val = 0;
+
+	val = max(min_tck->tWTR, DIV_ROUND_UP(timings->tWTR, t_ck)) - 1;
+	tim1 |= val << T_WTR_SHIFT;
+
+	if (addressing->num_banks == B8)
+		val = DIV_ROUND_UP(timings->tFAW, t_ck*4);
+	else
+		val = max(min_tck->tRRD, DIV_ROUND_UP(timings->tRRD, t_ck));
+	tim1 |= (val - 1) << T_RRD_SHIFT;
+
+	val = DIV_ROUND_UP(timings->tRAS_min + timings->tRPab, t_ck) - 1;
+	tim1 |= val << T_RC_SHIFT;
+
+	val = max(min_tck->tRASmin, DIV_ROUND_UP(timings->tRAS_min, t_ck));
+	tim1 |= (val - 1) << T_RAS_SHIFT;
+
+	val = max(min_tck->tWR, DIV_ROUND_UP(timings->tWR, t_ck)) - 1;
+	tim1 |= val << T_WR_SHIFT;
+
+	val = max(min_tck->tRCD, DIV_ROUND_UP(timings->tRCD, t_ck)) - 1;
+	tim1 |= val << T_RCD_SHIFT;
+
+	val = max(min_tck->tRPab, DIV_ROUND_UP(timings->tRPab, t_ck)) - 1;
+	tim1 |= val << T_RP_SHIFT;
+
+	if (ip_rev == EMIF_4D5) {
+		val = DIV_ROUND_UP(timings->tRTW, t_ck) - 1;
+		tim1 |= val << T_RTW_SHIFT;
+	}
+
+	return tim1;
+}
+
+static u32 get_sdram_tim_1_shdw_derated(const struct lpddr2_timings *timings,
+		const struct lpddr2_min_tck *min_tck,
+		const struct lpddr2_addressing *addressing, u32 ip_rev)
+{
+	u32 tim1 = 0, val = 0;
+
+	val = max(min_tck->tWTR, DIV_ROUND_UP(timings->tWTR, t_ck)) - 1;
+	tim1 = val << T_WTR_SHIFT;
+
+	/*
+	 * tFAW is approximately 4 times tRRD. So add 1875*4 = 7500ps
+	 * to tFAW for de-rating
+	 */
+	if (addressing->num_banks == B8) {
+		val = DIV_ROUND_UP(timings->tFAW + 7500, 4 * t_ck) - 1;
+	} else {
+		val = DIV_ROUND_UP(timings->tRRD + 1875, t_ck);
+		val = max(min_tck->tRRD, val) - 1;
+	}
+	tim1 |= val << T_RRD_SHIFT;
+
+	val = DIV_ROUND_UP(timings->tRAS_min + timings->tRPab + 1875, t_ck);
+	tim1 |= (val - 1) << T_RC_SHIFT;
+
+	val = DIV_ROUND_UP(timings->tRAS_min + 1875, t_ck);
+	val = max(min_tck->tRASmin, val) - 1;
+	tim1 |= val << T_RAS_SHIFT;
+
+	val = max(min_tck->tWR, DIV_ROUND_UP(timings->tWR, t_ck)) - 1;
+	tim1 |= val << T_WR_SHIFT;
+
+	val = max(min_tck->tRCD, DIV_ROUND_UP(timings->tRCD + 1875, t_ck));
+	tim1 |= (val - 1) << T_RCD_SHIFT;
+
+	val = max(min_tck->tRPab, DIV_ROUND_UP(timings->tRPab + 1875, t_ck));
+	tim1 |= (val - 1) << T_RP_SHIFT;
+
+	if (ip_rev == EMIF_4D5) {
+		val = DIV_ROUND_UP(timings->tRTW, t_ck) - 1;
+		tim1 |= val << T_RTW_SHIFT;
+	}
+
+	return tim1;
+}
+
+static u32 get_sdram_tim_2_shdw(const struct lpddr2_timings *timings,
+		const struct lpddr2_min_tck *min_tck,
+		const struct lpddr2_addressing *addressing,
+		u32 type, u32 ip_rev)
+{
+	u32 tim2 = 0, val = 0;
+
+	val = min_tck->tCKE - 1;
+	tim2 |= val << T_CKE_SHIFT;
+
+	val = max(min_tck->tRTP, DIV_ROUND_UP(timings->tRTP, t_ck)) - 1;
+	tim2 |= val << T_RTP_SHIFT;
+
+	/* tXSNR = tRFCab_ps + 10 ns(tRFCab_ps for LPDDR2). */
+	val = DIV_ROUND_UP(addressing->tRFCab_ps + 10000, t_ck) - 1;
+	tim2 |= val << T_XSNR_SHIFT;
+
+	/* XSRD same as XSNR for LPDDR2 */
+	tim2 |= val << T_XSRD_SHIFT;
+
+	if (ip_rev == EMIF_4D5) {
+		val = DIV_ROUND_UP(timings->tAONPD, t_ck) - 1;
+		tim2 |= val << T_ODT_SHIFT;
+	}
+
+	val = max(min_tck->tXP, DIV_ROUND_UP(timings->tXP, t_ck)) - 1;
+	tim2 |= val << T_XP_SHIFT;
+
+	return tim2;
+}
+
+static u32 get_sdram_tim_3_shdw(const struct lpddr2_timings *timings,
+		const struct lpddr2_min_tck *min_tck,
+		const struct lpddr2_addressing *addressing,
+		u32 type, u32 ip_rev, u32 derated)
+{
+	u32 tim3 = 0, val = 0;
+
+	val = timings->tRAS_max_ns / addressing->tREFI_ns - 1;
+	val = val > 0xF ? 0xF : val;
+	tim3 |= val << T_RAS_MAX_SHIFT;
+
+	val = DIV_ROUND_UP(addressing->tRFCab_ps, t_ck) - 1;
+	tim3 |= val << T_RFC_SHIFT;
+
+	if (ip_rev == EMIF_4D5)
+		val = DIV_ROUND_UP(timings->tDQSCK_max + 1000, t_ck) - 1;
+	else
+		val = DIV_ROUND_UP(timings->tDQSCK_max, t_ck) - 1;
+
+	tim3 |= val << T_TDQSCKMAX_SHIFT;
+
+	val = DIV_ROUND_UP(timings->tZQCS, t_ck) - 1;
+	tim3 |= val << ZQ_ZQCS_SHIFT;
+
+	val = DIV_ROUND_UP(timings->tCKESR, t_ck);
+	val = max(min_tck->tCKESR, val) - 1;
+	tim3 |= val << T_CKESR_SHIFT;
+
+	if (ip_rev == EMIF_4D5) {
+		tim3 |= (EMIF_T_CSTA - 1) << T_CSTA_SHIFT;
+
+		val = DIV_ROUND_UP(EMIF_T_PDLL_UL, 128) - 1;
+		tim3 |= val << T_PDLL_UL_SHIFT;
+	}
+
+	return tim3;
+}
+
+static u32 get_read_idle_ctrl_shdw(u8 volt_ramp)
+{
+	u32 idle = 0, val = 0;
+
+	/*
+	 * Maximum value in normal conditions and increased frequency
+	 * when voltage is ramping
+	 */
+	if (volt_ramp)
+		val = READ_IDLE_INTERVAL_DVFS / t_ck / 64 - 1;
+	else
+		val = 0x1FF;
+
+	/*
+	 * READ_IDLE_CTRL register in EMIF4D has same offset and fields
+	 * as DLL_CALIB_CTRL in EMIF4D5, so use the same shifts
+	 */
+	idle |= val << DLL_CALIB_INTERVAL_SHIFT;
+	idle |= EMIF_READ_IDLE_LEN_VAL << ACK_WAIT_SHIFT;
+
+	return idle;
+}
+
+static u32 get_dll_calib_ctrl_shdw(u8 volt_ramp)
+{
+	u32 calib = 0, val = 0;
+
+	if (volt_ramp == DDR_VOLTAGE_RAMPING)
+		val = DLL_CALIB_INTERVAL_DVFS / t_ck / 16 - 1;
+	else
+		val = 0; /* Disabled when voltage is stable */
+
+	calib |= val << DLL_CALIB_INTERVAL_SHIFT;
+	calib |= DLL_CALIB_ACK_WAIT_VAL << ACK_WAIT_SHIFT;
+
+	return calib;
+}
+
+static u32 get_ddr_phy_ctrl_1_attilaphy_4d(const struct lpddr2_timings *timings,
+	u32 freq, u8 RL)
+{
+	u32 phy = EMIF_DDR_PHY_CTRL_1_BASE_VAL_ATTILAPHY, val = 0;
+
+	val = RL + DIV_ROUND_UP(timings->tDQSCK_max, t_ck) - 1;
+	phy |= val << READ_LATENCY_SHIFT_4D;
+
+	if (freq <= 100000000)
+		val = EMIF_DLL_SLAVE_DLY_CTRL_100_MHZ_AND_LESS_ATTILAPHY;
+	else if (freq <= 200000000)
+		val = EMIF_DLL_SLAVE_DLY_CTRL_200_MHZ_ATTILAPHY;
+	else
+		val = EMIF_DLL_SLAVE_DLY_CTRL_400_MHZ_ATTILAPHY;
+
+	phy |= val << DLL_SLAVE_DLY_CTRL_SHIFT_4D;
+
+	return phy;
+}
+
+static u32 get_phy_ctrl_1_intelliphy_4d5(u32 freq, u8 cl)
+{
+	u32 phy = EMIF_DDR_PHY_CTRL_1_BASE_VAL_INTELLIPHY, half_delay;
+
+	/*
+	 * DLL operates at 266 MHz. If DDR frequency is near 266 MHz,
+	 * half-delay is not needed else set half-delay
+	 */
+	if (freq >= 265000000 && freq < 267000000)
+		half_delay = 0;
+	else
+		half_delay = 1;
+
+	phy |= half_delay << DLL_HALF_DELAY_SHIFT_4D5;
+	phy |= ((cl + DIV_ROUND_UP(EMIF_PHY_TOTAL_READ_LATENCY_INTELLIPHY_PS,
+			t_ck) - 1) << READ_LATENCY_SHIFT_4D5);
+
+	return phy;
+}
+
+static u32 get_ext_phy_ctrl_2_intelliphy_4d5(void)
+{
+	u32 fifo_we_slave_ratio;
+
+	fifo_we_slave_ratio =  DIV_ROUND_CLOSEST(
+		EMIF_INTELLI_PHY_DQS_GATE_OPENING_DELAY_PS * 256 , t_ck);
+
+	return fifo_we_slave_ratio | fifo_we_slave_ratio << 11 |
+		fifo_we_slave_ratio << 22;
+}
+
+static u32 get_ext_phy_ctrl_3_intelliphy_4d5(void)
+{
+	u32 fifo_we_slave_ratio;
+
+	fifo_we_slave_ratio =  DIV_ROUND_CLOSEST(
+		EMIF_INTELLI_PHY_DQS_GATE_OPENING_DELAY_PS * 256 , t_ck);
+
+	return fifo_we_slave_ratio >> 10 | fifo_we_slave_ratio << 1 |
+		fifo_we_slave_ratio << 12 | fifo_we_slave_ratio << 23;
+}
+
+static u32 get_ext_phy_ctrl_4_intelliphy_4d5(void)
+{
+	u32 fifo_we_slave_ratio;
+
+	fifo_we_slave_ratio =  DIV_ROUND_CLOSEST(
+		EMIF_INTELLI_PHY_DQS_GATE_OPENING_DELAY_PS * 256 , t_ck);
+
+	return fifo_we_slave_ratio >> 9 | fifo_we_slave_ratio << 2 |
+		fifo_we_slave_ratio << 13;
+}
+
+static u32 get_pwr_mgmt_ctrl(u32 freq, struct emif_data *emif, u32 ip_rev)
+{
+	u32 pwr_mgmt_ctrl	= 0, timeout;
+	u32 lpmode		= EMIF_LP_MODE_SELF_REFRESH;
+	u32 timeout_perf	= EMIF_LP_MODE_TIMEOUT_PERFORMANCE;
+	u32 timeout_pwr		= EMIF_LP_MODE_TIMEOUT_POWER;
+	u32 freq_threshold	= EMIF_LP_MODE_FREQ_THRESHOLD;
+
+	struct emif_custom_configs *cust_cfgs = emif->plat_data->custom_configs;
+
+	if (cust_cfgs && (cust_cfgs->mask & EMIF_CUSTOM_CONFIG_LPMODE)) {
+		lpmode		= cust_cfgs->lpmode;
+		timeout_perf	= cust_cfgs->lpmode_timeout_performance;
+		timeout_pwr	= cust_cfgs->lpmode_timeout_power;
+		freq_threshold  = cust_cfgs->lpmode_freq_threshold;
+	}
+
+	/* Timeout based on DDR frequency */
+	timeout = freq >= freq_threshold ? timeout_perf : timeout_pwr;
+
+	/* The value to be set in register is "log2(timeout) - 3" */
+	if (timeout < 16) {
+		timeout = 0;
+	} else {
+		timeout = __fls(timeout) - 3;
+		if (timeout & (timeout - 1))
+			timeout++;
+	}
+
+	switch (lpmode) {
+	case EMIF_LP_MODE_CLOCK_STOP:
+		pwr_mgmt_ctrl = (timeout << CS_TIM_SHIFT) |
+					SR_TIM_MASK | PD_TIM_MASK;
+		break;
+	case EMIF_LP_MODE_SELF_REFRESH:
+		pwr_mgmt_ctrl = (timeout << SR_TIM_SHIFT) |
+					CS_TIM_MASK | PD_TIM_MASK;
+		break;
+	case EMIF_LP_MODE_PWR_DN:
+		pwr_mgmt_ctrl = (timeout << PD_TIM_SHIFT) |
+					CS_TIM_MASK | SR_TIM_MASK;
+		break;
+	case EMIF_LP_MODE_DISABLE:
+	default:
+		pwr_mgmt_ctrl = CS_TIM_MASK |
+					PD_TIM_MASK | SR_TIM_MASK;
+	}
+
+	/* No CS_TIM in EMIF_4D5 */
+	if (ip_rev == EMIF_4D5)
+		pwr_mgmt_ctrl &= ~CS_TIM_MASK;
+
+	pwr_mgmt_ctrl |= lpmode << LP_MODE_SHIFT;
+
+	return pwr_mgmt_ctrl;
+}
+
+/*
+ * Program EMIF shadow registers that are not dependent on temperature
+ * or voltage
+ */
+static void setup_registers(struct emif_data *emif, struct emif_regs *regs)
+{
+	void __iomem	*base = emif->base;
+
+	writel(regs->sdram_tim2_shdw, base + EMIF_SDRAM_TIMING_2_SHDW);
+	writel(regs->phy_ctrl_1_shdw, base + EMIF_DDR_PHY_CTRL_1_SHDW);
+
+	/* Settings specific for EMIF4D5 */
+	if (emif->plat_data->ip_rev != EMIF_4D5)
+		return;
+	writel(regs->ext_phy_ctrl_2_shdw, base + EMIF_EXT_PHY_CTRL_2_SHDW);
+	writel(regs->ext_phy_ctrl_3_shdw, base + EMIF_EXT_PHY_CTRL_3_SHDW);
+	writel(regs->ext_phy_ctrl_4_shdw, base + EMIF_EXT_PHY_CTRL_4_SHDW);
+}
+
+/*
+ * When voltage ramps dll calibration and forced read idle should
+ * happen more often
+ */
+static void setup_volt_sensitive_regs(struct emif_data *emif,
+		struct emif_regs *regs, u32 volt_state)
+{
+	u32		calib_ctrl;
+	void __iomem	*base = emif->base;
+
+	/*
+	 * EMIF_READ_IDLE_CTRL in EMIF4D refers to the same register as
+	 * EMIF_DLL_CALIB_CTRL in EMIF4D5 and dll_calib_ctrl_shadow_*
+	 * is an alias of the respective read_idle_ctrl_shdw_* (members of
+	 * a union). So, the below code takes care of both cases
+	 */
+	if (volt_state == DDR_VOLTAGE_RAMPING)
+		calib_ctrl = regs->dll_calib_ctrl_shdw_volt_ramp;
+	else
+		calib_ctrl = regs->dll_calib_ctrl_shdw_normal;
+
+	writel(calib_ctrl, base + EMIF_DLL_CALIB_CTRL_SHDW);
+}
+
+/*
+ * setup_temperature_sensitive_regs() - set the timings for temperature
+ * sensitive registers. This happens once at initialisation time based
+ * on the temperature at boot time and subsequently based on the temperature
+ * alert interrupt. Temperature alert can happen when the temperature
+ * increases or drops. So this function can have the effect of either
+ * derating the timings or going back to nominal values.
+ */
+static void setup_temperature_sensitive_regs(struct emif_data *emif,
+		struct emif_regs *regs)
+{
+	u32		tim1, tim3, ref_ctrl, type, irqs;
+	void __iomem	*base = emif->base;
+	u32		temperature;
+
+	type = emif->plat_data->device_info->type;
+
+	tim1 = regs->sdram_tim1_shdw;
+	tim3 = regs->sdram_tim3_shdw;
+	ref_ctrl = regs->ref_ctrl_shdw;
+
+	spin_lock_irqsave(&emif->lock, irqs);
+	/* No de-rating for non-lpddr2 devices */
+	if (type != DDR_TYPE_LPDDR2_S2 && type != DDR_TYPE_LPDDR2_S4)
+		goto out;
+
+	temperature_level = emif->temperature_level;
+	if (temperature == SDRAM_TEMP_HIGH_DERATE_REFRESH) {
+		ref_ctrl = regs->ref_ctrl_shdw_derated;
+	} else if (temperature == SDRAM_TEMP_HIGH_DERATE_REFRESH_AND_TIMINGS) {
+		tim1 = regs->sdram_tim1_shdw_derated;
+		tim3 = regs->sdram_tim3_shdw_derated;
+		ref_ctrl = regs->ref_ctrl_shdw_derated;
+	}
+
+out:
+	writel(tim1, base + EMIF_SDRAM_TIMING_1_SHDW);
+	writel(tim3, base + EMIF_SDRAM_TIMING_3_SHDW);
+	writel(ref_ctrl, base + EMIF_SDRAM_REFRESH_CTRL_SHDW);
+	spin_unlock_irqrestore(&emif->lock, irqs);
+}
 
 static void __exit cleanup_emif(struct emif_data *emif)
 {
@@ -239,6 +760,8 @@ static int __init emif_probe(struct platform_device *pdev)
 	if (!emif1)
 		emif1 = emif;
 
+	emif->addressing = get_addressing_table(emif->plat_data->device_info);
+
 	/* Save pointers to each other in emif and device structures */
 	emif->dev = &pdev->dev;
 	platform_set_drvdata(pdev, emif);
@@ -275,6 +798,224 @@ static int __exit emif_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static int get_emif_reg_values(struct emif_data *emif, u32 freq,
+		struct emif_regs *regs)
+{
+	u32				cs1_used, ip_rev, phy_type;
+	u32				cl, type;
+	const struct lpddr2_timings	*timings;
+	const struct lpddr2_min_tck	*min_tck;
+	const struct ddr_device_info	*device_info;
+	const struct lpddr2_addressing	*addressing;
+	struct emif_data		*emif_for_calc;
+	struct device			*dev;
+	const struct emif_custom_configs *custom_configs;
+
+	dev = emif->dev;
+	/*
+	 * If the devices on this EMIF instance is duplicate of EMIF1,
+	 * use EMIF1 details for the calculation
+	 */
+	emif_for_calc	= emif->duplicate ? emif1 : emif;
+	timings		= get_timings_table(emif_for_calc, freq);
+	addressing	= emif_for_calc->addressing;
+	if (!timings || !addressing) {
+		dev_err(dev, "not enough data available for %dHz", freq);
+		return -1;
+	}
+
+	device_info	= emif_for_calc->plat_data->device_info;
+	type		= device_info->type;
+	cs1_used	= device_info->cs1_used;
+	ip_rev		= emif_for_calc->plat_data->ip_rev;
+	phy_type	= emif_for_calc->plat_data->phy_type;
+
+	min_tck		= emif_for_calc->plat_data->min_tck;
+	custom_configs	= emif_for_calc->plat_data->custom_configs;
+
+	set_ddr_clk_period(freq);
+
+	regs->ref_ctrl_shdw = get_sdram_ref_ctrl_shdw(freq, addressing);
+	regs->sdram_tim1_shdw = get_sdram_tim_1_shdw(timings, min_tck,
+			addressing, ip_rev);
+	regs->sdram_tim2_shdw = get_sdram_tim_2_shdw(timings, min_tck,
+			addressing, type, ip_rev);
+	regs->sdram_tim3_shdw = get_sdram_tim_3_shdw(timings, min_tck,
+		addressing, type, ip_rev, EMIF_NORMAL_TIMINGS);
+
+	cl = get_cl(emif);
+
+	if (phy_type == EMIF_PHY_TYPE_ATTILAPHY && ip_rev == EMIF_4D) {
+		regs->phy_ctrl_1_shdw = get_ddr_phy_ctrl_1_attilaphy_4d(
+			timings, freq, cl);
+	} else if (phy_type == EMIF_PHY_TYPE_INTELLIPHY && ip_rev == EMIF_4D5) {
+		regs->phy_ctrl_1_shdw = get_phy_ctrl_1_intelliphy_4d5(freq, cl);
+		regs->ext_phy_ctrl_2_shdw = get_ext_phy_ctrl_2_intelliphy_4d5();
+		regs->ext_phy_ctrl_3_shdw = get_ext_phy_ctrl_3_intelliphy_4d5();
+		regs->ext_phy_ctrl_4_shdw = get_ext_phy_ctrl_4_intelliphy_4d5();
+	} else {
+		return -1;
+	}
+
+	/* Only timeout values in pwr_mgmt_ctrl_shdw register */
+	regs->pwr_mgmt_ctrl_shdw =
+		get_pwr_mgmt_ctrl(freq, emif_for_calc, ip_rev) &
+		(CS_TIM_MASK | SR_TIM_MASK | PD_TIM_MASK);
+
+	if (ip_rev & EMIF_4D) {
+		regs->read_idle_ctrl_shdw_normal =
+			get_read_idle_ctrl_shdw(DDR_VOLTAGE_STABLE);
+
+		regs->read_idle_ctrl_shdw_volt_ramp =
+			get_read_idle_ctrl_shdw(DDR_VOLTAGE_RAMPING);
+	} else if (ip_rev & EMIF_4D5) {
+		regs->dll_calib_ctrl_shdw_normal =
+			get_dll_calib_ctrl_shdw(DDR_VOLTAGE_STABLE);
+
+		regs->dll_calib_ctrl_shdw_volt_ramp =
+			get_dll_calib_ctrl_shdw(DDR_VOLTAGE_RAMPING);
+	}
+
+	if (type == DDR_TYPE_LPDDR2_S2 || type == DDR_TYPE_LPDDR2_S4) {
+		regs->ref_ctrl_shdw_derated = get_sdram_ref_ctrl_shdw(freq / 4,
+			addressing);
+
+		regs->sdram_tim3_shdw_derated = get_sdram_tim_3_shdw(timings,
+			min_tck, addressing, type, ip_rev,
+			EMIF_DERATED_TIMINGS);
+
+		regs->sdram_tim1_shdw_derated =
+			get_sdram_tim_1_shdw_derated(timings, min_tck,
+				addressing, ip_rev);
+	}
+
+	regs->freq = freq;
+
+	return 0;
+}
+
+/*
+ * get_regs() - gets the cached emif_regs structure for a given EMIF instance
+ * given frequency(freq):
+ *
+ * As an optimisation, every EMIF instance other than EMIF1 shares the
+ * register cache with EMIF1 if the devices connected on this instance
+ * are same as that on EMIF1(indicated by the duplicate flag)
+ *
+ * If we do not have an entry corresponding to the frequency given, we
+ * allocate a new entry and calculate the values
+ *
+ * Upon finding the right reg dump, save it in curr_regs. It can be
+ * directly used for thermal de-rating and voltage ramping changes.
+ */
+static struct emif_regs *get_regs(struct emif_data *emif, u32 freq)
+{
+	int			i;
+	struct emif_regs	**regs_cache;
+	struct emif_regs	*regs = NULL;
+	struct device		*dev;
+
+	dev = emif->dev;
+	if (emif->curr_regs && emif->curr_regs->freq == freq) {
+		dev_dbg(dev, "Using curr_regs - %u Hz", freq);
+		return emif->curr_regs;
+	}
+
+	if (emif->duplicate)
+		regs_cache = emif1->regs_cache;
+	else
+		regs_cache = emif->regs_cache;
+
+	for (i = 0; i < EMIF_MAX_NUM_FREQUENCIES && regs_cache[i]; i++) {
+		if (regs_cache[i]->freq == freq) {
+			regs = regs_cache[i];
+			dev_dbg(dev, "Reg dump found in reg cache for %u Hz\n",
+				freq);
+			break;
+		}
+	}
+
+	/*
+	 * If we don't have an entry for this frequency in the cache create one
+	 * and calculate the values
+	 */
+	if (!regs) {
+		regs = kmalloc(sizeof(struct emif_regs), GFP_ATOMIC);
+		if (!regs)
+			return NULL;
+
+		if (get_emif_reg_values(emif, freq, regs)) {
+			kfree(regs);
+			return NULL;
+		}
+
+		/*
+		 * Now look for an un-used entry in the cache and save the
+		 * newly created struct. If there are no free entries
+		 * over-write the last entry
+		 */
+		for (i = 0; i < EMIF_MAX_NUM_FREQUENCIES && regs_cache[i]; i++)
+			;
+
+		if (i >= EMIF_MAX_NUM_FREQUENCIES) {
+			dev_warn(dev, "regs_cache full - reusing a slot!!\n");
+			i = EMIF_MAX_NUM_FREQUENCIES - 1;
+			kfree(regs_cache[i]);
+		}
+		regs_cache[i] = regs;
+	}
+
+	return regs;
+}
+
+/*
+ * Function un-used right now. Will be used later when DVFS framework
+ * is available
+ */
+static void __attribute__((unused)) do_volt_notify_handling(
+		struct emif_data *emif, u32 volt_state)
+{
+	dev_dbg(emif->dev, "voltage notification : %d", volt_state);
+
+	if (!emif->curr_regs) {
+		dev_err(emif->dev,
+			"Volt-notify before registers are ready: %d\n",
+			volt_state);
+		return;
+	}
+
+	setup_volt_sensitive_regs(emif, emif->curr_regs, volt_state);
+	do_freq_update();
+}
+
+/*
+ * Function un-used right now. Will be used later when DVFS framework
+ * is available
+ */
+static void __attribute__((unused)) do_freq_pre_notify_handling(void *emif_data,
+		u32 new_freq)
+{
+	struct emif_regs *regs;
+	struct emif_data *emif = emif_data;
+
+	regs = get_regs(emif, new_freq);
+	if (!regs)
+		return;
+
+	emif->curr_regs = regs;
+
+	/*
+	 * Update the shadow registers:
+	 * Temperature and voltage-ramp sensitive settings are also configured
+	 * in terms of DDR cycles. So, we need to update them too when there
+	 * is a freq change
+	 */
+	dev_dbg(emif->dev, "setting up shadow registers for %uHz", new_freq);
+	setup_registers(emif, regs);
+	setup_temperature_sensitive_regs(emif, regs);
+	setup_volt_sensitive_regs(emif, regs, DDR_VOLTAGE_STABLE);
+}
+
 static struct platform_driver emif_driver = {
 	.remove		= __exit_p(emif_remove),
 	.driver = {
diff --git a/include/linux/emif.h b/include/linux/emif.h
index 4ddf20b..347125f 100644
--- a/include/linux/emif.h
+++ b/include/linux/emif.h
@@ -22,6 +22,49 @@
  */
 #define EMIF_MAX_NUM_FREQUENCIES	6
 
+/* State of the core voltage */
+#define DDR_VOLTAGE_STABLE		0
+#define DDR_VOLTAGE_RAMPING		1
+
+/* Defines for timing De-rating */
+#define EMIF_NORMAL_TIMINGS		0
+#define EMIF_DERATED_TIMINGS		1
+
+/* Length of the forced read idle period in terms of cycles */
+#define EMIF_READ_IDLE_LEN_VAL		5
+
+/*
+ * forced read idle interval to be used when voltage
+ * is changed as part of DVFS/DPS - 1ms
+ */
+#define READ_IDLE_INTERVAL_DVFS		(1*1000000)
+
+/*
+ * Forced read idle interval to be used when voltage is stable
+ * 50us - or maximum value will do
+ */
+#define READ_IDLE_INTERVAL_NORMAL	(50*1000000)
+
+/* DLL calibration interval when voltage is NOT stable - 1us */
+#define DLL_CALIB_INTERVAL_DVFS		(1*1000000)
+
+#define DLL_CALIB_ACK_WAIT_VAL		5
+
+/* Interval between ZQCS commands - hw team recommended value */
+#define EMIF_ZQCS_INTERVAL_US		(50*1000)
+/* Enable ZQ Calibration on exiting Self-refresh */
+#define ZQ_SFEXITEN_ENABLE		1
+/*
+ * ZQ Calibration simultaneously on both chip-selects:
+ * Needs one calibration resistor per CS
+ */
+#define	ZQ_DUALCALEN_DISABLE		0
+#define	ZQ_DUALCALEN_ENABLE		1
+
+#define T_ZQCS_DEFAULT_NS		90
+#define T_ZQCL_DEFAULT_NS		360
+#define T_ZQINIT_DEFAULT_NS		1000
+
 /* EMIF_PWR_MGMT_CTRL register */
 /* Low power modes */
 #define EMIF_LP_MODE_DISABLE		0
@@ -29,6 +72,35 @@
 #define EMIF_LP_MODE_SELF_REFRESH	2
 #define EMIF_LP_MODE_PWR_DN		4
 
+/* DPD_EN */
+#define DPD_DISABLE			0
+#define DPD_ENABLE			1
+
+/*
+ * Default values for the low-power entry to be used if not provided by user.
+ * OMAP4/5 has a hw bug(i735) due to which this value can not be less than 512
+ * Timeout values are in DDR clock 'cycles' and frequency threshold in Hz
+ */
+#define EMIF_LP_MODE_TIMEOUT_PERFORMANCE			2048
+#define EMIF_LP_MODE_TIMEOUT_POWER				512
+#define EMIF_LP_MODE_FREQ_THRESHOLD				400000000
+
+/* DDR_PHY_CTRL_1 values for EMIF4D - ATTILA PHY combination */
+#define EMIF_DDR_PHY_CTRL_1_BASE_VAL_ATTILAPHY			0x049FF000
+#define EMIF_DLL_SLAVE_DLY_CTRL_400_MHZ_ATTILAPHY		0x41
+#define EMIF_DLL_SLAVE_DLY_CTRL_200_MHZ_ATTILAPHY		0x80
+#define EMIF_DLL_SLAVE_DLY_CTRL_100_MHZ_AND_LESS_ATTILAPHY	0xFF
+
+/* DDR_PHY_CTRL_1 values for EMIF4D5 INTELLIPHY combination */
+#define EMIF_DDR_PHY_CTRL_1_BASE_VAL_INTELLIPHY			0x0E084200
+#define EMIF_PHY_TOTAL_READ_LATENCY_INTELLIPHY_PS		10000
+
+/* TEMP_ALERT_CONFIG - corresponding to temp gradient 5 C/s */
+#define TEMP_ALERT_POLL_INTERVAL_DEFAULT_MS			360
+
+#define EMIF_T_CSTA			3
+#define EMIF_T_PDLL_UL			128
+
 /* Hardware capabilities */
 #define	EMIF_HW_CAPS_LL_INTERFACE	0x00000001
 
@@ -44,6 +116,31 @@
 #define EMIF_CUSTOM_CONFIG_LPMODE			0x00000001
 #define EMIF_CUSTOM_CONFIG_TEMP_ALERT_POLL_INTERVAL	0x00000002
 
+/* External PHY control registers magic values */
+#define EMIF_EXT_PHY_CTRL_1_VAL				0x04020080
+#define EMIF_EXT_PHY_CTRL_5_VAL				0x04010040
+#define EMIF_EXT_PHY_CTRL_6_VAL				0x01004010
+#define EMIF_EXT_PHY_CTRL_7_VAL				0x00001004
+#define EMIF_EXT_PHY_CTRL_8_VAL				0x04010040
+#define EMIF_EXT_PHY_CTRL_9_VAL				0x01004010
+#define EMIF_EXT_PHY_CTRL_10_VAL			0x00001004
+#define EMIF_EXT_PHY_CTRL_11_VAL			0x00000000
+#define EMIF_EXT_PHY_CTRL_12_VAL			0x00000000
+#define EMIF_EXT_PHY_CTRL_13_VAL			0x00000000
+#define EMIF_EXT_PHY_CTRL_14_VAL			0x80080080
+#define EMIF_EXT_PHY_CTRL_15_VAL			0x00800800
+#define EMIF_EXT_PHY_CTRL_16_VAL			0x08102040
+#define EMIF_EXT_PHY_CTRL_17_VAL			0x00000001
+#define EMIF_EXT_PHY_CTRL_18_VAL			0x540A8150
+#define EMIF_EXT_PHY_CTRL_19_VAL			0xA81502A0
+#define EMIF_EXT_PHY_CTRL_20_VAL			0x002A0540
+#define EMIF_EXT_PHY_CTRL_21_VAL			0x00000000
+#define EMIF_EXT_PHY_CTRL_22_VAL			0x00000000
+#define EMIF_EXT_PHY_CTRL_23_VAL			0x00000000
+#define EMIF_EXT_PHY_CTRL_24_VAL			0x00000077
+
+#define EMIF_INTELLI_PHY_DQS_GATE_OPENING_DELAY_PS	1200
+
 /*
  * Structure containing shadow of important registers in EMIF
  * The calculation function fills in this structure to be later used for
-- 
1.7.1

