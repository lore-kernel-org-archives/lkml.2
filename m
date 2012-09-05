Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606Ab2IEKDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:03:07 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:39925 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758431Ab2IEJ7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:59:53 -0400
From: Loic Pallardy <loic.pallardy-ext@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.com>
Cc: Lee Jones <lee.jones@linaro.org>, Loic Pallardy <loic.pallardy@gmail.com>,
        LT ST-Ericsson <st-ericsson@lists.linaro.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Loic Pallardy <loic.pallardy-ext@stericsson.com>,
        Michel JAOUEN <michel.jaouen@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>
Subject: [PATCH 10/17] mfd: prcmu: dbx500-prmcu creation
Date: Wed, 5 Sep 2012 11:59:06 +0200
Message-ID: <1346839153-6465-11-git-send-email-loic.pallardy-ext@stericsson.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
References: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a generic drivers/mfd/dbx500-prcmu.c
Allow supporting and managing several PRCMU IP versions
Use dbx500-prcmu new interfaces to abstract prcmu services.

Signed-off-by: Michel JAOUEN <michel.jaouen@stericsson.com>
Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/Kconfig              |  10 +
 drivers/mfd/Makefile             |   1 +
 drivers/mfd/db8500-prcmu.c       | 303 ++++++++++++---
 drivers/mfd/dbx500-prcmu.c       | 813 +++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/db8500-prcmu.h | 250 +-----------
 include/linux/mfd/dbx500-prcmu.h | 547 ++++++++++----------------
 6 files changed, 1288 insertions(+), 636 deletions(-)
 create mode 100644 drivers/mfd/dbx500-prcmu.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index b1a1462..3420844 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -801,10 +801,20 @@ config AB8500_GPADC
 	help
 	  AB8500 GPADC driver used to convert Acc and battery/ac/usb voltage
 
+config DBX500_PRCMU
+	bool "ST-Ericsson DBX500 Power Reset Control Management Unit"
+	depends on UX500_SOC_DB8500
+	help
+	  Select this option to enable support for generic DBX500 Power
+	  Reset and Control Management Unit. you have to select it for
+	  enabling interface with other components like cpufreq,
+	  cpuidle, prcmu-qos-power.
+
 config MFD_DB8500_PRCMU
 	bool "ST-Ericsson DB8500 Power Reset Control Management Unit"
 	depends on UX500_SOC_DB8500
 	select MFD_CORE
+	select DBX500_PRCMU
 	help
 	  Select this option to enable support for the DB8500 Power Reset
 	  and Control Management Unit. This is basically an autonomous
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 79dd22d..42d703a 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -106,6 +106,7 @@ obj-$(CONFIG_AB3100_CORE)	+= ab3100-core.o
 obj-$(CONFIG_AB3100_OTP)	+= ab3100-otp.o
 obj-$(CONFIG_AB8500_DEBUG)	+= ab8500-debugfs.o
 obj-$(CONFIG_AB8500_GPADC)	+= ab8500-gpadc.o
+obj-$(CONFIG_DBX500_PRCMU)      += dbx500-prcmu.o
 obj-$(CONFIG_MFD_DB8500_PRCMU)	+= db8500-prcmu.o
 # ab8500-core need to come after db8500-prcmu (which provides the channel)
 obj-$(CONFIG_AB8500_CORE)	+= ab8500-core.o ab8500-sysctrl.o
diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index eb327f3..36f7c1d 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -615,12 +615,12 @@ int db8500_prcmu_set_display_clocks(void)
 	return 0;
 }
 
-u32 db8500_prcmu_read(unsigned int reg)
+static u32 db8500_prcmu_read(unsigned int reg)
 {
 	return readl(_PRCMU_BASE + reg);
 }
 
-void db8500_prcmu_write(unsigned int reg, u32 value)
+static void db8500_prcmu_write(unsigned int reg, u32 value)
 {
 	unsigned long flags;
 
@@ -629,7 +629,7 @@ void db8500_prcmu_write(unsigned int reg, u32 value)
 	spin_unlock_irqrestore(&prcmu_lock, flags);
 }
 
-void db8500_prcmu_write_masked(unsigned int reg, u32 mask, u32 value)
+static void db8500_prcmu_write_masked(unsigned int reg, u32 mask, u32 value)
 {
 	u32 val;
 	unsigned long flags;
@@ -641,12 +641,12 @@ void db8500_prcmu_write_masked(unsigned int reg, u32 mask, u32 value)
 	spin_unlock_irqrestore(&prcmu_lock, flags);
 }
 
-struct prcmu_fw_version *prcmu_get_fw_version(void)
+static struct prcmu_fw_version *db8500_prcmu_get_fw_version(void)
 {
 	return fw_info.valid ? &fw_info.version : NULL;
 }
 
-bool prcmu_has_arm_maxopp(void)
+static bool db8500_prcmu_has_arm_maxopp(void)
 {
 	return (readb(tcdm_base + PRCM_AVS_VARM_MAX_OPP) &
 		PRCM_AVS_ISMODEENABLE_MASK) == PRCM_AVS_ISMODEENABLE_MASK;
@@ -700,7 +700,7 @@ enum ap_pwrst prcmu_get_xp70_current_state(void)
 }
 
 /**
- * prcmu_config_clkout - Configure one of the programmable clock outputs.
+ * db8500_prcmu_config_clkout - Configure one of the programmable clock outputs.
  * @clkout:	The CLKOUT number (0 or 1).
  * @source:	The clock to be used (one of the PRCMU_CLKSRC_*).
  * @div:	The divider to be applied.
@@ -709,7 +709,7 @@ enum ap_pwrst prcmu_get_xp70_current_state(void)
  * @div should be in the range [1,63] to request a configuration, or 0 to
  * inform that the configuration is no longer requested.
  */
-int prcmu_config_clkout(u8 clkout, u8 source, u8 div)
+static int db8500_prcmu_config_clkout(u8 clkout, u8 source, u8 div)
 {
 	static int requests[2];
 	int r = 0;
@@ -794,7 +794,7 @@ int db8500_prcmu_set_power_state(u8 state, bool keep_ulp_clk, bool keep_ap_pll)
 	return 0;
 }
 
-u8 db8500_prcmu_get_power_state_result(void)
+static u8 db8500_prcmu_get_power_state_result(void)
 {
 	return readb(tcdm_legacy_base + PRCM_ACK_MB0_AP_PWRSTTR_STATUS);
 }
@@ -945,7 +945,7 @@ static void config_wakeups(void)
 	last_abb_events = abb_events;
 }
 
-void db8500_prcmu_enable_wakeups(u32 wakeups)
+static void db8500_prcmu_enable_wakeups(u32 wakeups)
 {
 	unsigned long flags;
 	u32 bits;
@@ -966,7 +966,7 @@ void db8500_prcmu_enable_wakeups(u32 wakeups)
 	spin_unlock_irqrestore(&mb0_transfer.lock, flags);
 }
 
-void db8500_prcmu_config_abb_event_readout(u32 abb_events)
+static void db8500_prcmu_config_abb_event_readout(u32 abb_events)
 {
 	unsigned long flags;
 
@@ -978,7 +978,7 @@ void db8500_prcmu_config_abb_event_readout(u32 abb_events)
 	spin_unlock_irqrestore(&mb0_transfer.lock, flags);
 }
 
-void db8500_prcmu_get_abb_event_buffer(void __iomem **buf)
+static void db8500_prcmu_get_abb_event_buffer(void __iomem **buf)
 {
 	if (readb(tcdm_legacy_base + PRCM_ACK_MB0_READ_POINTER) & 1)
 		*buf = (tcdm_legacy_base + PRCM_ACK_MB0_WAKEUP_1_4500);
@@ -993,7 +993,7 @@ void db8500_prcmu_get_abb_event_buffer(void __iomem **buf)
  *
  * This function sets the the operating point of the ARM.
  */
-int db8500_prcmu_set_arm_opp(u8 opp)
+static int db8500_prcmu_set_arm_opp(u8 opp)
 {
 	int r;
 
@@ -1028,7 +1028,7 @@ int db8500_prcmu_set_arm_opp(u8 opp)
  *
  * Returns: the current ARM OPP
  */
-int db8500_prcmu_get_arm_opp(void)
+static int db8500_prcmu_get_arm_opp(void)
 {
 	return readb(tcdm_legacy_base + PRCM_ACK_MB1_CURRENT_ARM_OPP);
 }
@@ -1038,7 +1038,7 @@ int db8500_prcmu_get_arm_opp(void)
  *
  * Returns: the current DDR OPP
  */
-int db8500_prcmu_get_ddr_opp(void)
+static int db8500_prcmu_get_ddr_opp(void)
 {
 	return readb(PRCM_DDR_SUBSYS_APE_MINBW);
 }
@@ -1050,7 +1050,7 @@ int db8500_prcmu_get_ddr_opp(void)
  *
  * This function sets the operating point of the DDR.
  */
-int db8500_prcmu_set_ddr_opp(u8 opp)
+static int db8500_prcmu_set_ddr_opp(u8 opp)
 {
 	if (opp < DDR_100_OPP || opp > DDR_25_OPP)
 		return -EINVAL;
@@ -1114,7 +1114,7 @@ unlock_and_return:
  *
  * This function sets the operating point of the APE.
  */
-int db8500_prcmu_set_ape_opp(u8 opp)
+static int db8500_prcmu_set_ape_opp(u8 opp)
 {
 	int r = 0;
 
@@ -1161,18 +1161,18 @@ skip_message:
  *
  * Returns: the current APE OPP
  */
-int db8500_prcmu_get_ape_opp(void)
+static int db8500_prcmu_get_ape_opp(void)
 {
 	return readb(tcdm_legacy_base + PRCM_ACK_MB1_CURRENT_APE_OPP);
 }
 
 /**
- * prcmu_request_ape_opp_100_voltage - Request APE OPP 100% voltage
+ * db8500_prcmu_request_ape_opp_100_voltage - Request APE OPP 100% voltage
  * @enable: true to request the higher voltage, false to drop a request.
  *
  * Calls to this function to enable and disable requests must be balanced.
  */
-int prcmu_request_ape_opp_100_voltage(bool enable)
+static int db8500_prcmu_request_ape_opp_100_voltage(bool enable)
 {
 	int r = 0;
 	u8 header;
@@ -1279,7 +1279,7 @@ static int request_pll(u8 clock, bool enable)
  * This function sets the state of a EPOD (power domain). It may not be called
  * from interrupt context.
  */
-int db8500_prcmu_set_epod(u16 epod_id, u8 epod_state)
+static int db8500_prcmu_set_epod(u16 epod_id, u8 epod_state)
 {
 	int r = 0;
 	bool ram_retention = false;
@@ -1341,11 +1341,11 @@ unlock_and_return:
 }
 
 /**
- * prcmu_configure_auto_pm - Configure autonomous power management.
+ * db8500_prcmu_configure_auto_pm - Configure autonomous power management.
  * @sleep: Configuration for ApSleep.
  * @idle:  Configuration for ApIdle.
  */
-void prcmu_configure_auto_pm(struct prcmu_auto_pm_config *sleep,
+static void db8500_prcmu_configure_auto_pm(struct prcmu_auto_pm_config *sleep,
 	struct prcmu_auto_pm_config *idle)
 {
 	u32 sleep_cfg;
@@ -1386,7 +1386,6 @@ void prcmu_configure_auto_pm(struct prcmu_auto_pm_config *sleep,
 
 	spin_unlock_irqrestore(&mb2_transfer.auto_pm_lock, flags);
 }
-EXPORT_SYMBOL(prcmu_configure_auto_pm);
 
 bool prcmu_is_auto_pm_enabled(void)
 {
@@ -1701,7 +1700,7 @@ static unsigned long dsiescclk_rate(u8 n)
 	return clock_rate(PRCMU_TVCLK) / max((u32)1, div);
 }
 
-unsigned long prcmu_clock_rate(u8 clock)
+static unsigned long db8500_prcmu_clock_rate(u8 clock)
 {
 	if (clock < PRCMU_NUM_REG_CLOCKS)
 		return clock_rate(clock);
@@ -1850,7 +1849,7 @@ static long round_dsiescclk_rate(unsigned long rate)
 	return rounded_rate;
 }
 
-long prcmu_round_clock_rate(u8 clock, unsigned long rate)
+static long db8500_prcmu_round_clock_rate(u8 clock, unsigned long rate)
 {
 	if (clock < PRCMU_NUM_REG_CLOCKS)
 		return round_clock_rate(clock, rate);
@@ -1861,7 +1860,7 @@ long prcmu_round_clock_rate(u8 clock, unsigned long rate)
 	else if ((PRCMU_DSI0ESCCLK <= clock) && (clock <= PRCMU_DSI2ESCCLK))
 		return round_dsiescclk_rate(rate);
 	else
-		return (long)prcmu_clock_rate(clock);
+		return (long)db8500_prcmu_clock_rate(clock);
 }
 
 static void set_clock_rate(u8 clock, unsigned long rate)
@@ -1989,7 +1988,7 @@ static void set_dsiescclk_rate(u8 n, unsigned long rate)
 	writel(val, PRCM_DSITVCLK_DIV);
 }
 
-int prcmu_set_clock_rate(u8 clock, unsigned long rate)
+static int db8500_prcmu_set_clock_rate(u8 clock, unsigned long rate)
 {
 	if (clock < PRCMU_NUM_REG_CLOCKS)
 		set_clock_rate(clock, rate);
@@ -2002,7 +2001,7 @@ int prcmu_set_clock_rate(u8 clock, unsigned long rate)
 	return 0;
 }
 
-int db8500_prcmu_config_esram0_deep_sleep(u8 state)
+static int db8500_prcmu_config_esram0_deep_sleep(u8 state)
 {
 	if ((state > ESRAM0_DEEP_SLEEP_STATE_RET) ||
 	    (state < ESRAM0_DEEP_SLEEP_STATE_OFF))
@@ -2122,7 +2121,7 @@ static int prcmu_a9wdog(u8 cmd, u8 d0, u8 d1, u8 d2, u8 d3)
 
 }
 
-int db8500_prcmu_config_a9wdog(u8 num, bool sleep_auto_off)
+static int db8500_prcmu_config_a9wdog(u8 num, bool sleep_auto_off)
 {
 	BUG_ON(num == 0 || num > 0xf);
 	return prcmu_a9wdog(MB4H_A9WDOG_CONF, num, 0, 0,
@@ -2130,17 +2129,17 @@ int db8500_prcmu_config_a9wdog(u8 num, bool sleep_auto_off)
 			    A9WDOG_AUTO_OFF_DIS);
 }
 
-int db8500_prcmu_enable_a9wdog(u8 id)
+static int db8500_prcmu_enable_a9wdog(u8 id)
 {
 	return prcmu_a9wdog(MB4H_A9WDOG_EN, id, 0, 0, 0);
 }
 
-int db8500_prcmu_disable_a9wdog(u8 id)
+static int db8500_prcmu_disable_a9wdog(u8 id)
 {
 	return prcmu_a9wdog(MB4H_A9WDOG_DIS, id, 0, 0, 0);
 }
 
-int db8500_prcmu_kick_a9wdog(u8 id)
+static int db8500_prcmu_kick_a9wdog(u8 id)
 {
 	return prcmu_a9wdog(MB4H_A9WDOG_KICK, id, 0, 0, 0);
 }
@@ -2148,7 +2147,7 @@ int db8500_prcmu_kick_a9wdog(u8 id)
 /*
  * timeout is 28 bit, in ms.
  */
-int db8500_prcmu_load_a9wdog(u8 id, u32 timeout)
+static int db8500_prcmu_load_a9wdog(u8 id, u32 timeout)
 {
 	return prcmu_a9wdog(MB4H_A9WDOG_LOAD,
 			    (id & A9WDOG_ID_MASK) |
@@ -2163,7 +2162,7 @@ int db8500_prcmu_load_a9wdog(u8 id, u32 timeout)
 }
 
 /**
- * prcmu_abb_read() - Read register value(s) from the ABB.
+ * db8500_prcmu_abb_read() - Read register value(s) from the ABB.
  * @slave:	The I2C slave address.
  * @reg:	The (start) register address.
  * @value:	The read out value(s).
@@ -2172,7 +2171,7 @@ int db8500_prcmu_load_a9wdog(u8 id, u32 timeout)
  * Reads register value(s) from the ABB.
  * @size has to be 1 for the current firmware version.
  */
-int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
+static int db8500_prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
 {
 	int r;
 
@@ -2211,7 +2210,7 @@ int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
 }
 
 /**
- * prcmu_abb_write_masked() - Write masked register value(s) to the ABB.
+ * db8500_prcmu_abb_write_masked() - Write masked register value(s) to the ABB.
  * @slave:	The I2C slave address.
  * @reg:	The (start) register address.
  * @value:	The value(s) to write.
@@ -2223,7 +2222,8 @@ int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
  * will be written. The other bits are not changed.
  * @size has to be 1 for the current firmware version.
  */
-int prcmu_abb_write_masked(u8 slave, u8 reg, u8 *value, u8 *mask, u8 size)
+static int db8500_prcmu_abb_write_masked(u8 slave, u8 reg, u8 *value, u8 *mask,
+		u8 size)
 {
 	int r;
 
@@ -2259,7 +2259,7 @@ int prcmu_abb_write_masked(u8 slave, u8 reg, u8 *value, u8 *mask, u8 size)
 }
 
 /**
- * prcmu_abb_write() - Write register value(s) to the ABB.
+ * db8500_prcmu_abb_write() - Write register value(s) to the ABB.
  * @slave:	The I2C slave address.
  * @reg:	The (start) register address.
  * @value:	The value(s) to write.
@@ -2268,7 +2268,7 @@ int prcmu_abb_write_masked(u8 slave, u8 reg, u8 *value, u8 *mask, u8 size)
  * Writes register value(s) to the ABB.
  * @size has to be 1 for the current firmware version.
  */
-int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
+static int db8500_prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
 {
 	u8 mask = ~0;
 
@@ -2347,7 +2347,7 @@ unlock_and_return:
 	mutex_unlock(&mb0_transfer.ac_wake_lock);
 }
 
-bool db8500_prcmu_is_ac_wake_requested(void)
+static bool db8500_prcmu_is_ac_wake_requested(void)
 {
 	return (atomic_read(&ac_wake_req_state) != 0);
 }
@@ -2358,7 +2358,7 @@ bool db8500_prcmu_is_ac_wake_requested(void)
  * Saves the reset reason code and then sets the APE_SOFTRST register which
  * fires interrupt to fw
  */
-void db8500_prcmu_system_reset(u16 reset_code)
+static void db8500_prcmu_system_reset(u16 reset_code)
 {
 	writew(reset_code, (tcdm_legacy_base + PRCM_SW_RST_REASON));
 	writel(1, PRCM_APE_SOFTRST);
@@ -2370,7 +2370,7 @@ void db8500_prcmu_system_reset(u16 reset_code)
  * Retrieves the reset reason code stored by prcmu_system_reset() before
  * last restart.
  */
-u16 db8500_prcmu_get_reset_code(void)
+static u16 db8500_prcmu_get_reset_code(void)
 {
 	return readw(tcdm_legacy_base + PRCM_SW_RST_REASON);
 }
@@ -2378,7 +2378,7 @@ u16 db8500_prcmu_get_reset_code(void)
 /**
  * db8500_prcmu_reset_modem - ask the PRCMU to reset modem
  */
-void db8500_prcmu_modem_reset(void)
+static void db8500_prcmu_modem_reset(void)
 {
 	mutex_lock(&mb1_transfer.lock);
 
@@ -2651,6 +2651,202 @@ static char *fw_project_name(u8 project)
 	}
 }
 
+static inline void db8500_prcmu_set(unsigned int reg, u32 bits)
+{
+	db8500_prcmu_write_masked(reg, bits, bits);
+}
+
+static inline void db8500_prcmu_clear(unsigned int reg, u32 bits)
+{
+	db8500_prcmu_write_masked(reg, bits, 0);
+}
+
+
+static int db8500_prcmu_enable_spi2(void)
+{
+	db8500_prcmu_set(DB8500_PRCM_GPIOCR, DB8500_PRCM_GPIOCR_SPI2_SELECT);
+	return 0;
+}
+
+/**
+ * prcmu_disable_spi2 - Disables pin muxing for SPI2 on OtherAlternateC1.
+ */
+static int db8500_prcmu_disable_spi2(void)
+{
+	db8500_prcmu_clear(DB8500_PRCM_GPIOCR, DB8500_PRCM_GPIOCR_SPI2_SELECT);
+	return 0;
+}
+
+/**
+ * prcmu_enable_stm_mod_uart - Enables pin muxing for STMMOD
+ * and UARTMOD on OtherAlternateC3.
+ */
+static int db8500_prcmu_enable_stm_mod_uart(void)
+{
+	db8500_prcmu_set(DB8500_PRCM_GPIOCR,
+			(DB8500_PRCM_GPIOCR_DBG_STM_MOD_CMD1 |
+			 DB8500_PRCM_GPIOCR_DBG_UARTMOD_CMD0));
+	return 0;
+}
+
+/**
+ * prcmu_disable_stm_mod_uart - Disables pin muxing for STMMOD
+ * and UARTMOD on OtherAlternateC3.
+ */
+static int db8500_prcmu_disable_stm_mod_uart(void)
+{
+	db8500_prcmu_clear(DB8500_PRCM_GPIOCR,
+			(DB8500_PRCM_GPIOCR_DBG_STM_MOD_CMD1 |
+			 DB8500_PRCM_GPIOCR_DBG_UARTMOD_CMD0));
+	return 0;
+}
+
+/**
+ * prcmu_enable_stm_ape - Enables pin muxing for STM APE on OtherAlternateC1.
+ */
+static int db8500_prcmu_enable_stm_ape(void)
+{
+	db8500_prcmu_set(DB8500_PRCM_GPIOCR,
+			DB8500_PRCM_GPIOCR_DBG_STM_APE_CMD);
+	return 0;
+}
+
+/**
+ * prcmu_disable_stm_ape - Disables pin muxing for STM APE on OtherAlternateC1.
+ */
+static int db8500_prcmu_disable_stm_ape(void)
+{
+	db8500_prcmu_clear(DB8500_PRCM_GPIOCR,
+			DB8500_PRCM_GPIOCR_DBG_STM_APE_CMD);
+	return 0;
+}
+
+static  struct prcmu_val_data db8500_val_tab[] = {
+	{
+		.val = APE_OPP,
+		.set_val = db8500_prcmu_set_ape_opp,
+		.get_val = db8500_prcmu_get_ape_opp,
+	},
+	{
+		.val = DDR_OPP,
+		.set_val = db8500_prcmu_set_ddr_opp,
+		.get_val = db8500_prcmu_get_ddr_opp,
+	},
+	{
+		.val = ARM_OPP,
+		.set_val = db8500_prcmu_set_arm_opp,
+		.get_val = db8500_prcmu_get_arm_opp,
+	}
+};
+static struct prcmu_out_data db8500_out_tab[] = {
+	{
+		.out = SPI2_MUX,
+		.enable =  db8500_prcmu_enable_spi2,
+		.disable = db8500_prcmu_disable_spi2,
+	},
+	{
+		.out = STM_APE_MUX,
+		.enable = db8500_prcmu_enable_stm_ape,
+		.disable = db8500_prcmu_disable_stm_ape,
+	},
+	{
+		.out = STM_MOD_UART_MUX,
+		.enable = db8500_prcmu_enable_stm_mod_uart,
+		.disable = db8500_prcmu_disable_stm_mod_uart,
+	}
+};
+
+static struct prcmu_early_data db8500_early_fops = {
+	/*  system reset  */
+	.system_reset = db8500_prcmu_system_reset,
+
+	/*  clock service */
+	.config_clkout = db8500_prcmu_config_clkout,
+	.request_clock = db8500_prcmu_request_clock,
+
+	/*  direct register access */
+	.read = db8500_prcmu_read,
+	.write =  db8500_prcmu_write,
+	.write_masked = db8500_prcmu_write_masked,
+	/* others */
+	.round_clock_rate = db8500_prcmu_round_clock_rate,
+	.set_clock_rate = db8500_prcmu_set_clock_rate,
+	.clock_rate = db8500_prcmu_clock_rate,
+	.get_fw_version = db8500_prcmu_get_fw_version,
+	.has_arm_maxopp = db8500_prcmu_has_arm_maxopp,
+};
+
+static struct prcmu_fops_register db8500_early_tab[] = {
+	{
+		.fops = PRCMU_EARLY,
+		.data.pearly = &db8500_early_fops
+	},
+	{
+		.fops = PRCMU_VAL,
+		.size = ARRAY_SIZE(db8500_val_tab),
+		.data.pval = db8500_val_tab
+	},
+	{
+		.fops = PRCMU_OUT,
+		.size = ARRAY_SIZE(db8500_out_tab),
+		.data.pout = db8500_out_tab
+	}
+};
+
+static struct prcmu_fops_register_data db8500_early_data = {
+	.size = ARRAY_SIZE(db8500_early_tab),
+	.tab = db8500_early_tab
+};
+
+struct prcmu_probe_data db8500_probe_fops = {
+	/* sysfs soc inf */
+	.get_reset_code = db8500_prcmu_get_reset_code,
+
+	/* pm/suspend.c/cpu freq */
+	.config_esram0_deep_sleep = db8500_prcmu_config_esram0_deep_sleep,
+	.set_power_state = db8500_prcmu_set_power_state,
+	.get_power_state_result = db8500_prcmu_get_power_state_result,
+	.enable_wakeups = db8500_prcmu_enable_wakeups,
+	.is_ac_wake_requested = db8500_prcmu_is_ac_wake_requested,
+
+	/* modem */
+	.modem_reset = db8500_prcmu_modem_reset,
+
+	/* no used at all */
+	.config_abb_event_readout = db8500_prcmu_config_abb_event_readout,
+	.get_abb_event_buffer = db8500_prcmu_get_abb_event_buffer,
+
+	/* abb access */
+	.abb_read = db8500_prcmu_abb_read,
+	.abb_write = db8500_prcmu_abb_write,
+	/*  other u8500 specific */
+	.request_ape_opp_100_voltage = db8500_prcmu_request_ape_opp_100_voltage,
+	.configure_auto_pm = db8500_prcmu_configure_auto_pm,
+	.set_epod = db8500_prcmu_set_epod,
+
+	/* abb specific access */
+	.abb_write_masked = db8500_prcmu_abb_write_masked,
+
+	/* watchdog */
+	.config_a9wdog = db8500_prcmu_config_a9wdog,
+	.enable_a9wdog = db8500_prcmu_enable_a9wdog,
+	.disable_a9wdog = db8500_prcmu_disable_a9wdog,
+	.kick_a9wdog = db8500_prcmu_kick_a9wdog,
+	.load_a9wdog = db8500_prcmu_load_a9wdog,
+};
+
+static struct prcmu_fops_register db8500_probe_tab[] = {
+	{
+		.fops = PRCMU_PROBE,
+		.data.pprobe = &db8500_probe_fops,
+	},
+};
+
+struct prcmu_fops_register_data db8500_probe_data = {
+	.size = ARRAY_SIZE(db8500_probe_tab),
+	.tab = db8500_probe_tab,
+};
+
 static int db8500_irq_map(struct irq_domain *d, unsigned int virq,
 				irq_hw_number_t hwirq)
 {
@@ -2680,7 +2876,8 @@ static int db8500_irq_init(struct device_node *np)
 	return 0;
 }
 
-void __init db8500_prcmu_early_init(struct prcmu_tcdm_map *map)
+struct prcmu_fops_register_data *__init
+			db8500_prcmu_early_init(struct prcmu_tcdm_map *map)
 {
 		void *tcpm_base = ioremap_nocache(U8500_PRCMU_TCPM_BASE, SZ_4K);
 
@@ -2720,6 +2917,9 @@ void __init db8500_prcmu_early_init(struct prcmu_tcdm_map *map)
 	init_completion(&mb5_transfer.work);
 
 	INIT_WORK(&mb0_transfer.mask_work, prcmu_mask_work);
+
+	/*  early init of dbx500-prcmu */
+	return &db8500_early_data;
 }
 
 static void __init init_prcm_registers(void)
@@ -2976,6 +3176,11 @@ static struct resource ab8500_resources[] = {
 
 static struct mfd_cell db8500_prcmu_devs[] = {
 	{
+		.name = "dbx500-prcmu",
+		.platform_data = &db8500_probe_data,
+		.pdata_size = sizeof(db8500_probe_data),
+	},
+	{
 		.name = "db8500-prcmu-regulators",
 		.of_compatible = "stericsson,db8500-prcmu-regulator",
 		.platform_data = &db8500_regulators,
@@ -2996,6 +3201,11 @@ static struct mfd_cell db8500_prcmu_devs[] = {
 
 static struct mfd_cell db9540_prcmu_devs[] = {
 	{
+		.name = "dbx500-prcmu",
+		.platform_data = &db8500_probe_data,
+		.pdata_size = sizeof(db8500_probe_data),
+	},
+	{
 		.name = "db8500-prcmu-regulators",
 		.of_compatible = "stericsson,db8500-prcmu-regulator",
 		.platform_data = &db8500_regulators,
@@ -3048,12 +3258,13 @@ static int __devinit db8500_prcmu_probe(struct platform_device *pdev)
 	for (i = 0; i < ARRAY_SIZE(db8500_prcmu_devs); i++) {
 		if (!strcmp(db8500_prcmu_devs[i].name, "ab8500-core")) {
 			db8500_prcmu_devs[i].platform_data = ab8500_platdata;
-			db8500_prcmu_devs[i].pdata_size = sizeof(struct ab8500_platform_data);
+			db8500_prcmu_devs[i].pdata_size =
+				sizeof(struct ab8500_platform_data);
 		}
 	}
 
 	if (cpu_is_u8500v20_or_later() && !cpu_is_u9540())
-		prcmu_config_esram0_deep_sleep(ESRAM0_DEEP_SLEEP_STATE_RET);
+		db8500_prcmu_config_esram0_deep_sleep(ESRAM0_DEEP_SLEEP_STATE_RET);
 
 	if (cpu_is_u9540())
 			err = mfd_add_devices(&pdev->dev, 0, db9540_prcmu_devs,
diff --git a/drivers/mfd/dbx500-prcmu.c b/drivers/mfd/dbx500-prcmu.c
new file mode 100644
index 0000000..1823ab7
--- /dev/null
+++ b/drivers/mfd/dbx500-prcmu.c
@@ -0,0 +1,813 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010. All rights reserved.
+ * This code is ST-Ericsson proprietary and confidential.
+ * Any use of the code for whatever purpose is subject to
+ * specific written permission of ST-Ericsson SA.
+ *
+ * Author: Michel Jaouen <michel.jaouen@stericsson.com> for
+ * ST-Ericsson.
+ * License terms: GNU Gereral Public License (GPL) version 2
+ *
+ */
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/dbx500-prcmu.h>
+#include <linux/hwmon.h>
+#include <linux/sysfs.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/jiffies.h>
+#include <linux/mutex.h>
+#include <linux/pm.h>
+#include <linux/io.h>
+#include <mach/hardware.h>
+
+#define dbx500_prcmu_warn(a)					\
+	pr_warn("%s : dbx500-prcmu driver %s",			\
+	__func__, a);
+
+#define dbx500_prcmu_error(a)					\
+	pr_err("%s : dbx500-prcmu driver %s",			\
+	__func__, a);
+
+#define dbx500_prcmu_early_trap_void				\
+	pr_err("%s called :dbx500-prcmu driver not initialized",\
+		__func__);					\
+
+#define dbx500_prcmu_early_trap(a) do {				\
+	pr_err("%s called :dbx500-prcmu driver not initialized",\
+		__func__);					\
+	return a;						\
+	} while (0)
+
+#define dbx500_prcmu_trap(a) do {				\
+	pr_err("%s called : dbx500-prcmu driver not probed",	\
+	__func__);						\
+	return a;						\
+	} while (0)
+
+#define dbx500_prcmu_trap_void					\
+	pr_err("%s called : dbx500-prcmu driver not probed",	\
+	__func__);
+
+/* dummy handler */
+
+static int dummy_set_power_state(u8 state, bool keep_ulp_clk,
+		bool keep_ap_pll) {
+	dbx500_prcmu_trap(-EINVAL);
+}
+
+static u8  dummy_get_power_state_result(void)
+{
+	dbx500_prcmu_trap(-EINVAL);
+}
+
+static int dummy_config_clkout(u8 clkout, u8 source, u8 div)
+{
+	dbx500_prcmu_early_trap(-EINVAL);
+}
+
+static int dummy_request_clock(u8 clock, bool enable)
+{
+	dbx500_prcmu_early_trap(-EINVAL);
+}
+
+static long dummy_round_clock_rate(u8 clock, unsigned long rate)
+{
+	dbx500_prcmu_early_trap(-EINVAL);
+}
+
+static int dummy_set_clock_rate(u8 clock, unsigned long rate)
+{
+	dbx500_prcmu_early_trap(-EINVAL);
+}
+
+static	unsigned long dummy_clock_rate(u8 clock)
+{
+	dbx500_prcmu_early_trap(-EINVAL);
+}
+
+static	int dummy_set_val(enum prcmu_val type, u8 value)
+{
+	dbx500_prcmu_early_trap(-EINVAL);
+}
+
+static	int dummy_get_val(enum prcmu_val type)
+{
+	dbx500_prcmu_early_trap(-EINVAL);
+}
+
+static	void dummy_system_reset(u16 reset_code)
+{
+	dbx500_prcmu_early_trap_void;
+}
+static	u16 dummy_get_reset_code(void)
+{
+	dbx500_prcmu_trap(-EINVAL);
+}
+static	u32 dummy_get_reset_status(void)
+{
+	dbx500_prcmu_trap(-EINVAL);
+}
+
+static	void dummy_enable_wakeups(u32 wakeups)
+{
+	dbx500_prcmu_trap_void;
+}
+
+static	bool dummy_is_ac_wake_requested(void)
+{
+	dbx500_prcmu_trap(false);
+}
+
+static	int  dummy_disable(enum prcmu_out out)
+{
+	dbx500_prcmu_early_trap(-EINVAL);
+}
+
+static	int  dummy_enable(enum prcmu_out out)
+{
+	dbx500_prcmu_early_trap(-EINVAL);
+}
+
+static	u32  dummy_read(unsigned int reg)
+{
+	dbx500_prcmu_early_trap(-EINVAL);
+}
+
+static	void  dummy_write(unsigned int reg, u32 value)
+{
+	dbx500_prcmu_early_trap_void;
+}
+
+static	void  default_write_masked(unsigned int reg, u32 mask, u32 value)
+{
+	u32 val;
+	val = readl(_PRCMU_BASE + reg);
+	val = ((val & ~mask) | (value & mask));
+	writel(val, (_PRCMU_BASE + reg));
+}
+
+static	int  dummy_config_esram0_deep_sleep(u8 state)
+{
+	dbx500_prcmu_trap(-EINVAL);
+}
+
+static	void  dummy_config_abb_event_readout(u32 abb_events)
+{
+	dbx500_prcmu_trap_void;
+}
+
+static	void  dummy_get_abb_event_buffer(void __iomem **buf)
+{
+	dbx500_prcmu_trap_void;
+}
+
+static int  dummy_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
+{
+	dbx500_prcmu_trap(-EINVAL);
+}
+
+static	int  dummy_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
+{
+	dbx500_prcmu_trap(-EINVAL);
+}
+
+static	int  dummy_abb_write_masked(u8 slave, u8 reg, u8 *value,
+		u8 *mask, u8 size)
+{
+	dbx500_prcmu_trap(-EINVAL);
+}
+
+static	void  dummy_modem_reset(void)
+{
+	dbx500_prcmu_trap_void;
+}
+
+static bool dummy_has_arm_maxopp(void)
+{
+	dbx500_prcmu_early_trap(-EINVAL);
+}
+
+static	struct prcmu_fw_version *dummy_get_fw_version(void)
+{
+	dbx500_prcmu_early_trap(NULL);
+}
+
+static int dummy_request_ape_opp_100_voltage(bool enable)
+{
+	dbx500_prcmu_trap(-EINVAL);
+}
+
+static void dummy_configure_auto_pm(struct prcmu_auto_pm_config *sleep,
+	struct prcmu_auto_pm_config *idle)
+{
+	dbx500_prcmu_trap_void;
+}
+
+static int dummy_config_a9wdog(u8 num, bool sleep_auto_off)
+{
+	dbx500_prcmu_trap(-EINVAL);
+}
+
+static int dummy_enable_a9wdog(u8 id)
+{
+	dbx500_prcmu_trap(-EINVAL);
+}
+
+static int dummy_disable_a9wdog(u8 id)
+{
+	dbx500_prcmu_trap(-EINVAL);
+}
+
+static int dummy_kick_a9wdog(u8 id)
+{
+	dbx500_prcmu_trap(-EINVAL);
+}
+
+static int dummy_load_a9wdog(u8 id, u32 timeout)
+{
+	dbx500_prcmu_trap(-EINVAL);
+}
+
+struct prcmu_probe_data dummy_fops = {
+	/* sysfs soc inf */
+	.get_reset_code = dummy_get_reset_code,
+
+	/* pm/suspend.c/cpu freq */
+	.config_esram0_deep_sleep = dummy_config_esram0_deep_sleep,
+	.set_power_state = dummy_set_power_state,
+	.get_power_state_result = dummy_get_power_state_result,
+	.enable_wakeups = dummy_enable_wakeups,
+	.is_ac_wake_requested = dummy_is_ac_wake_requested,
+
+	/* modem */
+	.modem_reset = dummy_modem_reset,
+
+	/* no used at all */
+	.config_abb_event_readout = dummy_config_abb_event_readout,
+	.get_abb_event_buffer = dummy_get_abb_event_buffer,
+
+	/* abb access */
+	.abb_read = dummy_abb_read,
+	.abb_write = dummy_abb_write,
+	.get_reset_status = dummy_get_reset_status,
+	/*  other u8500 specific */
+	.request_ape_opp_100_voltage = dummy_request_ape_opp_100_voltage,
+	.configure_auto_pm = dummy_configure_auto_pm,
+
+	/* abb specific access */
+	.abb_write_masked = dummy_abb_write_masked,
+
+	/* watchdog */
+	.config_a9wdog = dummy_config_a9wdog,
+	.enable_a9wdog = dummy_enable_a9wdog,
+	.disable_a9wdog = dummy_disable_a9wdog,
+	.kick_a9wdog = dummy_kick_a9wdog,
+	.load_a9wdog = dummy_load_a9wdog,
+};
+
+static struct prcmu_early_data default_early_fops = {
+	/*  system reset  */
+	.system_reset = dummy_system_reset,
+
+	/*  clock service */
+	.config_clkout = dummy_config_clkout,
+	.request_clock = dummy_request_clock,
+
+	/*  direct register access */
+	.read = dummy_read,
+	.write =  dummy_write,
+	.write_masked = default_write_masked,
+	/* others */
+	.round_clock_rate = dummy_round_clock_rate,
+	.set_clock_rate = dummy_set_clock_rate,
+	.clock_rate = dummy_clock_rate,
+	.get_fw_version = dummy_get_fw_version,
+	.has_arm_maxopp = dummy_has_arm_maxopp,
+};
+
+static struct {
+	struct prcmu_early_data *pearly;
+	struct prcmu_probe_data *pprobe;
+	struct prcmu_probe_cpuhp_data *pprobe_cpuhp;
+	struct prcmu_val_data tab_val[PRCMU_VAL_MAX];
+	int (*set_val)(enum prcmu_val type, u8 val);
+	int (*get_val) (enum prcmu_val type);
+	struct prcmu_out_data tab_out[PRCMU_OUT_MAX];
+	int (*disable) (enum prcmu_out out);
+	int (*enable) (enum prcmu_out out);
+	bool (*check_ape_age)(void);
+} dbx500_prcmu_context = {
+	.pearly = &default_early_fops,
+	.pprobe = &dummy_fops,
+	.set_val = dummy_set_val,
+	.get_val = dummy_get_val,
+	.disable = dummy_disable,
+	.enable = dummy_enable,
+};
+
+/* early service */
+
+struct prcmu_fw_version *prcmu_get_fw_version(void)
+{
+	return dbx500_prcmu_context.pearly->get_fw_version();
+}
+
+bool prcmu_has_arm_maxopp(void)
+{
+	return dbx500_prcmu_context.pearly->has_arm_maxopp();
+}
+
+void prcmu_system_reset(u16 reset_code)
+{
+	dbx500_prcmu_context.pearly->system_reset(reset_code);
+}
+
+u32 prcmu_read(unsigned int reg)
+{
+	return	dbx500_prcmu_context.pearly->read(reg);
+}
+
+void prcmu_write(unsigned int reg, u32 value)
+{
+	return	dbx500_prcmu_context.pearly->write(reg, value);
+}
+
+void prcmu_write_masked(unsigned int reg, u32 mask, u32 value)
+{
+	 dbx500_prcmu_context.pearly->write_masked(reg, mask, value);
+}
+
+int prcmu_config_clkout(u8 clkout, u8 source, u8 div)
+{
+	return dbx500_prcmu_context.pearly->config_clkout(clkout, source, div);
+}
+
+int prcmu_request_clock(u8 clock, bool enable)
+{
+	return  dbx500_prcmu_context.pearly->request_clock(clock, enable);
+}
+
+unsigned long prcmu_clock_rate(u8 clock)
+{
+	return   dbx500_prcmu_context.pearly->clock_rate(clock);
+}
+
+long prcmu_round_clock_rate(u8 clock, unsigned long rate)
+{
+	return  dbx500_prcmu_context.pearly->round_clock_rate(clock, rate);
+}
+
+int prcmu_set_clock_rate(u8 clock, unsigned long rate)
+{
+	return  dbx500_prcmu_context.pearly->set_clock_rate(clock, rate);
+}
+
+int prcmu_set_val(enum prcmu_val type, u32 value)
+{
+	return dbx500_prcmu_context.set_val(type, value);
+}
+
+int prcmu_get_val(enum prcmu_val type)
+{
+	return dbx500_prcmu_context.get_val(type);
+}
+
+int prcmu_enable_out(enum prcmu_out out)
+{
+	return dbx500_prcmu_context.enable(out);
+}
+
+int prcmu_disable_out(enum prcmu_out out)
+{
+	return dbx500_prcmu_context.disable(out);
+}
+
+int prcmu_set_ddr_opp(u8 opp)
+{
+	return dbx500_prcmu_context.set_val(DDR_OPP, opp);
+}
+
+int prcmu_get_ddr_opp(void)
+{
+	return dbx500_prcmu_context.get_val(DDR_OPP);
+}
+
+int prcmu_set_arm_opp(u8 opp)
+{
+	return dbx500_prcmu_context.set_val(ARM_OPP, opp);
+}
+
+int prcmu_get_arm_opp(void)
+{
+	return dbx500_prcmu_context.get_val(ARM_OPP);
+}
+
+int prcmu_set_ape_opp(u8 opp)
+{
+	return dbx500_prcmu_context.set_val(APE_OPP, opp);
+}
+
+int prcmu_get_ape_opp(void)
+{
+	return dbx500_prcmu_context.get_val(APE_OPP);
+}
+
+int prcmu_gic_decouple(void)
+{
+	return db8500_prcmu_gic_decouple();
+}
+int prcmu_gic_recouple(void)
+{
+	return db8500_prcmu_gic_recouple();
+}
+bool prcmu_gic_pending_irq(void)
+{
+	return db8500_prcmu_gic_pending_irq();
+}
+
+bool prcmu_is_cpu_in_wfi(int cpu)
+{
+	return db8500_prcmu_is_cpu_in_wfi(cpu);
+}
+
+int prcmu_copy_gic_settings(void)
+{
+	return db8500_prcmu_copy_gic_settings();
+}
+
+bool prcmu_pending_irq(void)
+{
+	return db8500_prcmu_pending_irq();
+}
+
+/*  other service available after the probe */
+
+int prcmu_set_power_state(u8 state, bool keep_ulp_clk,
+		bool keep_ap_pll)
+{
+	return	 dbx500_prcmu_context.pprobe->set_power_state(state,
+			keep_ulp_clk,
+			keep_ap_pll);
+}
+
+u8 prcmu_get_power_state_result(void)
+{
+	return	dbx500_prcmu_context.pprobe->get_power_state_result();
+}
+
+void prcmu_enable_wakeups(u32 wakeups)
+{
+	dbx500_prcmu_context.pprobe->enable_wakeups(wakeups);
+}
+
+void prcmu_disable_wakeups(void)
+{
+	dbx500_prcmu_context.pprobe->enable_wakeups(0);
+}
+
+void prcmu_config_abb_event_readout(u32 abb_events)
+{
+	dbx500_prcmu_context.pprobe->config_abb_event_readout(abb_events);
+}
+
+void prcmu_get_abb_event_buffer(void __iomem **buf)
+{
+	dbx500_prcmu_context.pprobe->get_abb_event_buffer(buf);
+}
+
+u16 prcmu_get_reset_code(void)
+{
+	return dbx500_prcmu_context.pprobe->get_reset_code();
+}
+
+void prcmu_modem_reset(void)
+{
+	dbx500_prcmu_context.pprobe->modem_reset();
+}
+
+int  prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
+{
+	return dbx500_prcmu_context.pprobe->abb_read(slave, reg, value, size);
+}
+
+int  prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
+{
+	return dbx500_prcmu_context.pprobe->abb_write(slave, reg, value, size);
+}
+
+int  prcmu_abb_write_masked(u8 slave, u8 reg, u8 *value,
+		u8 *mask, u8 size)
+{
+	return dbx500_prcmu_context.pprobe->abb_write_masked(
+			slave, reg, value, mask, size);
+}
+
+u32  prcmu_get_reset_status(void)
+{
+	return dbx500_prcmu_context.pprobe->get_reset_status();
+}
+
+bool prcmu_is_ac_wake_requested(void)
+{
+	return dbx500_prcmu_context.pprobe->is_ac_wake_requested();
+}
+
+int prcmu_config_esram0_deep_sleep(u8 state)
+{
+	 return dbx500_prcmu_context.pprobe->config_esram0_deep_sleep(state);
+}
+
+int prcmu_set_epod(u16 epod_id, u8 epod_state)
+{
+	return dbx500_prcmu_context.pprobe->set_epod(epod_id, epod_state);
+}
+
+/**
+ * prcmu_enable_spi2 - Enables pin muxing for SPI2 on OtherAlternateC1.
+ */
+void prcmu_enable_spi2(void)
+{
+	 dbx500_prcmu_context.enable(SPI2_MUX);
+}
+
+/**
+ * prcmu_disable_spi2 - Disables pin muxing for SPI2 on OtherAlternateC1.
+ */
+void prcmu_disable_spi2(void)
+{
+	dbx500_prcmu_context.disable(SPI2_MUX);
+}
+
+/**
+ * prcmu_enable_stm_mod_uart - Enables pin muxing for STMMOD
+ * and UARTMOD on OtherAlternateC3.
+ */
+void prcmu_enable_stm_mod_uart(void)
+{
+	dbx500_prcmu_context.enable(STM_MOD_UART_MUX);
+}
+
+/**
+ * prcmu_disable_stm_mod_uart - Disables pin muxing for STMMOD
+ * and UARTMOD on OtherAlternateC3.
+ */
+void prcmu_disable_stm_mod_uart(void)
+{
+	dbx500_prcmu_context.disable(STM_MOD_UART_MUX);
+}
+
+/**
+ * prcmu_enable_stm_ape - Enables pin muxing for STM APE on OtherAlternateC1.
+ */
+void prcmu_enable_stm_ape(void)
+{
+	dbx500_prcmu_context.enable(STM_APE_MUX);
+}
+
+/**
+ * prcmu_disable_stm_ape - Disables pin muxing for STM APE on OtherAlternateC1.
+ */
+void prcmu_disable_stm_ape(void)
+{
+	dbx500_prcmu_context.disable(STM_APE_MUX);
+}
+
+void prcmu_configure_auto_pm(struct prcmu_auto_pm_config *sleep,
+	struct prcmu_auto_pm_config *idle)
+{
+	dbx500_prcmu_context.pprobe->configure_auto_pm(sleep, idle);
+}
+EXPORT_SYMBOL(prcmu_configure_auto_pm);
+
+int prcmu_request_ape_opp_100_voltage(bool enable)
+{
+	return	dbx500_prcmu_context.
+		pprobe->request_ape_opp_100_voltage(enable);
+}
+
+static int dbx500_prcmu_set_val(enum prcmu_val type, u8 value)
+{
+	if (type < PRCMU_VAL_MAX)
+		return dbx500_prcmu_context.tab_val[type].set_val(value);
+	dbx500_prcmu_error("request out of range");
+		return -EIO;
+
+}
+
+static int dbx500_prcmu_get_val(enum prcmu_val type)
+{
+	if (type < PRCMU_VAL_MAX)
+		return dbx500_prcmu_context.tab_val[type].get_val();
+	dbx500_prcmu_error("request out of range");
+		return -EIO;
+
+}
+
+static int dbx500_prcmu_enable_out(enum prcmu_out out)
+{
+	if (out < PRCMU_OUT_MAX)
+		return dbx500_prcmu_context.tab_out[out].enable();
+	dbx500_prcmu_error("request out of range");
+		return -EIO;
+}
+
+static int dbx500_prcmu_disable_out(enum prcmu_out out)
+{
+	if (out < PRCMU_OUT_MAX)
+		return	dbx500_prcmu_context.tab_out[out].disable();
+	dbx500_prcmu_error("request out of range");
+		return -EIO;
+}
+
+/*  used for enable , disable and get */
+static int dbx500_default_handler(void)
+{
+	return 0;
+}
+static int dbx500_default_set(u8 val)
+{
+	return 0;
+}
+static int default_get_ape_opp(void)
+{
+	return APE_100_OPP;
+}
+
+
+static int default_get_ddr_opp(void)
+{
+	return DDR_100_OPP;
+}
+
+static struct prcmu_val_data default_ape = {
+	.set_val = dbx500_default_set,
+	.get_val = default_get_ape_opp,
+};
+
+
+static struct prcmu_val_data default_ddr = {
+	.set_val = dbx500_default_set,
+	.get_val = default_get_ddr_opp,
+};
+
+static struct prcmu_out_data default_out = {
+	.enable = dbx500_default_handler,
+	.disable = dbx500_default_handler,
+};
+
+static struct prcmu_val_data default_val = {
+	.set_val = dbx500_default_set,
+	.get_val = dbx500_default_handler,
+};
+
+static void dbx500_prcmu_init_ctx(void)
+{
+	int i;
+	struct prcmu_val_data *pdefault;
+	for (i = 0; i < PRCMU_VAL_MAX; i++) {
+		switch (i) {
+		case DDR_OPP:
+			pdefault = &default_ddr;
+			break;
+		case APE_OPP:
+			pdefault = &default_ape;
+			break;
+		default:
+			pdefault = &default_val;
+		}
+
+		memcpy(&dbx500_prcmu_context.tab_val[i], pdefault,
+				sizeof(struct prcmu_val_data));
+	}
+
+	for (i = 0; i < PRCMU_OUT_MAX; i++)
+		memcpy(&dbx500_prcmu_context.tab_out[i], &default_out,
+				sizeof(struct prcmu_out_data));
+	dbx500_prcmu_context.enable = dbx500_prcmu_enable_out;
+	dbx500_prcmu_context.disable = dbx500_prcmu_disable_out;
+	dbx500_prcmu_context.set_val = dbx500_prcmu_set_val;
+	dbx500_prcmu_context.get_val = dbx500_prcmu_get_val;
+}
+
+static void dbx500_prcmu_register_pout(struct prcmu_out_data *data, int size)
+{
+	int i;
+	for (i = 0; i < size; i++)
+		if (data[i].out < PRCMU_OUT_MAX)
+			memcpy(&dbx500_prcmu_context.tab_out[data[i].out],
+				&data[i], sizeof(struct prcmu_out_data));
+		else
+			dbx500_prcmu_error("ops out of range");
+}
+
+static void dbx500_prcmu_register_pval(struct prcmu_val_data *data, int size)
+{
+	int i;
+	for (i = 0; i < size; i++)
+		if (data[i].val < PRCMU_VAL_MAX)
+			memcpy(&dbx500_prcmu_context.tab_val[data[i].val],
+				&data[i], sizeof(struct prcmu_val_data));
+		else
+			dbx500_prcmu_error("registering ops out of range");
+}
+
+/**
+ * @brief register prcmu handler
+ *
+ * @param fops
+ */
+void __init prcmu_early_init(struct prcmu_tcdm_map *map)
+{
+	int i, ret = 0;
+	struct prcmu_fops_register_data *data;
+
+	data = db8500_prcmu_early_init(map);
+
+	if (data == NULL)
+		return;
+
+	dbx500_prcmu_init_ctx();
+
+	for (i = 0; i < data->size; i++) {
+		switch (data->tab[i].fops) {
+		case PRCMU_EARLY:
+			dbx500_prcmu_context.pearly = data->tab[i].data.pearly;
+			break;
+		case PRCMU_VAL:
+			dbx500_prcmu_register_pval(data->tab[i].data.pval,
+					data->tab[i].size);
+			break;
+		case PRCMU_OUT:
+			dbx500_prcmu_register_pout(data->tab[i].data.pout,
+					data->tab[i].size);
+			break;
+		default:
+			dbx500_prcmu_error("ops out of range");
+			ret = -EIO;
+		}
+	}
+	return;
+}
+
+/**
+ * @brief dbx500-prcmu probe function
+ *
+ * @param pdev
+ *
+ * @return
+ */
+static int __devinit dbx500_prcmu_probe(struct platform_device *pdev)
+{
+	struct prcmu_fops_register_data *data = dev_get_platdata(&pdev->dev);
+	int i, ret = 0;
+	for (i = 0; i < data->size; i++) {
+		switch (data->tab[i].fops) {
+		case PRCMU_VAL:
+			dbx500_prcmu_register_pval(data->tab[i].data.pval,
+					data->tab[i].size);
+			break;
+		case PRCMU_OUT:
+			dbx500_prcmu_register_pout(data->tab[i].data.pout,
+					data->tab[i].size);
+			break;
+		case PRCMU_PROBE:
+			dbx500_prcmu_context.pprobe =
+				data->tab[i].data.pprobe;
+			break;
+		case PRCMU_PROBE_CPU_HP:
+			dbx500_prcmu_context.pprobe_cpuhp =
+				data->tab[i].data.pprobe_cpuhp;
+			break;
+		default:
+			dbx500_prcmu_error("ops out of range");
+			ret = -EIO;
+		}
+	}
+	return ret;
+}
+
+/* No action required in suspend/resume, thus the lack of functions */
+static struct platform_driver dbx500_prcmu_driver = {
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "dbx500-prcmu",
+	},
+	.probe = dbx500_prcmu_probe,
+};
+
+static int __init dbx500_prcmu_init(void)
+{
+	return platform_driver_register(&dbx500_prcmu_driver);
+}
+
+MODULE_AUTHOR("Michel JAOUEN <michel.jaouen@stericsson.com>");
+MODULE_DESCRIPTION("DBX500 PRCMU DRIVER");
+MODULE_LICENSE("GPL");
+
+core_initcall(dbx500_prcmu_init);
+
diff --git a/include/linux/mfd/db8500-prcmu.h b/include/linux/mfd/db8500-prcmu.h
index f932a56..a6d7298 100644
--- a/include/linux/mfd/db8500-prcmu.h
+++ b/include/linux/mfd/db8500-prcmu.h
@@ -140,29 +140,6 @@ enum ap_pwrst {
 };
 
 /**
- * enum ap_pwrst_trans - Transition states defined in PRCMU firmware
- * @NO_TRANSITION: No power state transition
- * @APEXECUTE_TO_APSLEEP: Power state transition from ApExecute to ApSleep
- * @APIDLE_TO_APSLEEP: Power state transition from ApIdle to ApSleep
- * @APBOOT_TO_APEXECUTE: Power state transition from ApBoot to ApExecute
- * @APEXECUTE_TO_APDEEPSLEEP: Power state transition from ApExecute to
- *                          ApDeepSleep
- * @APEXECUTE_TO_APIDLE: Power state transition from ApExecute to ApIdle
- */
-enum ap_pwrst_trans {
-	PRCMU_AP_NO_CHANGE		= 0x00,
-	APEXECUTE_TO_APSLEEP		= 0x01,
-	APIDLE_TO_APSLEEP		= 0x02, /* To be removed */
-	PRCMU_AP_SLEEP			= 0x01,
-	APBOOT_TO_APEXECUTE		= 0x03,
-	APEXECUTE_TO_APDEEPSLEEP	= 0x04, /* To be removed */
-	PRCMU_AP_DEEP_SLEEP		= 0x04,
-	APEXECUTE_TO_APIDLE		= 0x05, /* To be removed */
-	PRCMU_AP_IDLE			= 0x05,
-	PRCMU_AP_DEEP_IDLE		= 0x07,
-};
-
-/**
  * enum hw_acc_state - State definition for hardware accelerator
  * @HW_NO_CHANGE: The hardware accelerator state must remain unchanged
  * @HW_OFF: The hardware accelerator must be switched off
@@ -509,71 +486,41 @@ struct prcmu_fw_version {
 
 #ifdef CONFIG_MFD_DB8500_PRCMU
 
-void db8500_prcmu_early_init(struct prcmu_tcdm_map *map);
+struct prcmu_fops_register_data *db8500_prcmu_early_init(
+		struct prcmu_tcdm_map *map);
 int prcmu_set_rc_a2p(enum romcode_write);
 enum romcode_read prcmu_get_rc_p2a(void);
 enum ap_pwrst prcmu_get_xp70_current_state(void);
-bool prcmu_has_arm_maxopp(void);
-struct prcmu_fw_version *prcmu_get_fw_version(void);
-int prcmu_request_ape_opp_100_voltage(bool enable);
+
 int prcmu_release_usb_wakeup_state(void);
-void prcmu_configure_auto_pm(struct prcmu_auto_pm_config *sleep,
-	struct prcmu_auto_pm_config *idle);
-bool prcmu_is_auto_pm_enabled(void);
 
-int prcmu_config_clkout(u8 clkout, u8 source, u8 div);
-int prcmu_set_clock_divider(u8 clock, u8 divider);
 int db8500_prcmu_config_hotdog(u8 threshold);
 int db8500_prcmu_config_hotmon(u8 low, u8 high);
 int db8500_prcmu_start_temp_sense(u16 cycles32k);
 int db8500_prcmu_stop_temp_sense(void);
-int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size);
-int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size);
+
 
 int prcmu_ac_wake_req(void);
 void prcmu_ac_sleep_req(void);
-void db8500_prcmu_modem_reset(void);
-
-int db8500_prcmu_config_a9wdog(u8 num, bool sleep_auto_off);
-int db8500_prcmu_enable_a9wdog(u8 id);
-int db8500_prcmu_disable_a9wdog(u8 id);
-int db8500_prcmu_kick_a9wdog(u8 id);
-int db8500_prcmu_load_a9wdog(u8 id, u32 val);
 
-void db8500_prcmu_system_reset(u16 reset_code);
-int db8500_prcmu_set_power_state(u8 state, bool keep_ulp_clk, bool keep_ap_pll);
-u8 db8500_prcmu_get_power_state_result(void);
 int db8500_prcmu_gic_decouple(void);
 int db8500_prcmu_gic_recouple(void);
 int db8500_prcmu_copy_gic_settings(void);
 bool db8500_prcmu_gic_pending_irq(void);
 bool db8500_prcmu_pending_irq(void);
 bool db8500_prcmu_is_cpu_in_wfi(int cpu);
-void db8500_prcmu_enable_wakeups(u32 wakeups);
-int db8500_prcmu_set_epod(u16 epod_id, u8 epod_state);
-int db8500_prcmu_request_clock(u8 clock, bool enable);
+
 int db8500_prcmu_set_display_clocks(void);
 int db8500_prcmu_disable_dsipll(void);
 int db8500_prcmu_enable_dsipll(void);
-void db8500_prcmu_config_abb_event_readout(u32 abb_events);
-void db8500_prcmu_get_abb_event_buffer(void __iomem **buf);
-int db8500_prcmu_config_esram0_deep_sleep(u8 state);
-u16 db8500_prcmu_get_reset_code(void);
-bool db8500_prcmu_is_ac_wake_requested(void);
-int db8500_prcmu_set_arm_opp(u8 opp);
-int db8500_prcmu_get_arm_opp(void);
-int db8500_prcmu_set_ape_opp(u8 opp);
-int db8500_prcmu_get_ape_opp(void);
-int db8500_prcmu_set_ddr_opp(u8 opp);
-int db8500_prcmu_get_ddr_opp(void);
-
-u32 db8500_prcmu_read(unsigned int reg);
-void db8500_prcmu_write(unsigned int reg, u32 value);
-void db8500_prcmu_write_masked(unsigned int reg, u32 mask, u32 value);
 
 #else /* !CONFIG_MFD_DB8500_PRCMU */
 
-static inline void db8500_prcmu_early_init(struct prcmu_tcdm_map *map) {}
+static struct prcmu_fops_register_data *db8500_prcmu_early_init(
+		struct prcmu_tcdm_map *map)
+{
+	return NULL;
+}
 
 static inline int prcmu_set_rc_a2p(enum romcode_write code)
 {
@@ -590,66 +537,12 @@ static inline enum ap_pwrst prcmu_get_xp70_current_state(void)
 	return AP_EXECUTE;
 }
 
-static inline bool prcmu_has_arm_maxopp(void)
-{
-	return false;
-}
-
-static inline struct prcmu_fw_version *prcmu_get_fw_version(void)
-{
-	return NULL;
-}
-
-static inline int db8500_prcmu_set_ape_opp(u8 opp)
-{
-	return 0;
-}
-
-static inline int db8500_prcmu_get_ape_opp(void)
-{
-	return APE_100_OPP;
-}
-
-static inline int prcmu_request_ape_opp_100_voltage(bool enable)
-{
-	return 0;
-}
-
-static inline int prcmu_release_usb_wakeup_state(void)
-{
-	return 0;
-}
-
-static inline int db8500_prcmu_set_ddr_opp(u8 opp)
-{
-	return 0;
-}
-
-static inline int db8500_prcmu_get_ddr_opp(void)
-{
-	return DDR_100_OPP;
-}
-
-static inline void prcmu_configure_auto_pm(struct prcmu_auto_pm_config *sleep,
-	struct prcmu_auto_pm_config *idle)
-{
-}
 
 static inline bool prcmu_is_auto_pm_enabled(void)
 {
 	return false;
 }
 
-static inline int prcmu_config_clkout(u8 clkout, u8 source, u8 div)
-{
-	return 0;
-}
-
-static inline int prcmu_set_clock_divider(u8 clock, u8 divider)
-{
-	return 0;
-}
-
 static inline int db8500_prcmu_config_hotdog(u8 threshold)
 {
 	return 0;
@@ -670,129 +563,6 @@ static inline int db8500_prcmu_stop_temp_sense(void)
 	return 0;
 }
 
-static inline int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
-{
-	return -ENOSYS;
-}
-
-static inline int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
-{
-	return -ENOSYS;
-}
-
-static inline int prcmu_ac_wake_req(void)
-{
-	return 0;
-}
-
-static inline void prcmu_ac_sleep_req(void) {}
-
-static inline void db8500_prcmu_modem_reset(void) {}
-
-static inline void db8500_prcmu_system_reset(u16 reset_code) {}
-
-static inline int db8500_prcmu_set_power_state(u8 state, bool keep_ulp_clk,
-	bool keep_ap_pll)
-{
-	return 0;
-}
-
-static inline u8 db8500_prcmu_get_power_state_result(void)
-{
-	return 0;
-}
-
-static inline void db8500_prcmu_enable_wakeups(u32 wakeups) {}
-
-static inline int db8500_prcmu_set_epod(u16 epod_id, u8 epod_state)
-{
-	return 0;
-}
-
-static inline int db8500_prcmu_request_clock(u8 clock, bool enable)
-{
-	return 0;
-}
-
-static inline int db8500_prcmu_set_display_clocks(void)
-{
-	return 0;
-}
-
-static inline int db8500_prcmu_disable_dsipll(void)
-{
-	return 0;
-}
-
-static inline int db8500_prcmu_enable_dsipll(void)
-{
-	return 0;
-}
-
-static inline int db8500_prcmu_config_esram0_deep_sleep(u8 state)
-{
-	return 0;
-}
-
-static inline void db8500_prcmu_config_abb_event_readout(u32 abb_events) {}
-
-static inline void db8500_prcmu_get_abb_event_buffer(void __iomem **buf) {}
-
-static inline u16 db8500_prcmu_get_reset_code(void)
-{
-	return 0;
-}
-
-static inline int db8500_prcmu_config_a9wdog(u8 num, bool sleep_auto_off)
-{
-	return 0;
-}
-
-static inline int db8500_prcmu_enable_a9wdog(u8 id)
-{
-	return 0;
-}
-
-static inline int db8500_prcmu_disable_a9wdog(u8 id)
-{
-	return 0;
-}
-
-static inline int db8500_prcmu_kick_a9wdog(u8 id)
-{
-	return 0;
-}
-
-static inline int db8500_prcmu_load_a9wdog(u8 id, u32 val)
-{
-	return 0;
-}
-
-static inline bool db8500_prcmu_is_ac_wake_requested(void)
-{
-	return 0;
-}
-
-static inline int db8500_prcmu_set_arm_opp(u8 opp)
-{
-	return 0;
-}
-
-static inline int db8500_prcmu_get_arm_opp(void)
-{
-	return 0;
-}
-
-static inline u32 db8500_prcmu_read(unsigned int reg)
-{
-	return 0;
-}
-
-static inline void db8500_prcmu_write(unsigned int reg, u32 value) {}
-
-static inline void db8500_prcmu_write_masked(unsigned int reg, u32 mask,
-	u32 value) {}
-
 #endif /* !CONFIG_MFD_DB8500_PRCMU */
 
 #endif /* __MFD_DB8500_PRCMU_H */
diff --git a/include/linux/mfd/dbx500-prcmu.h b/include/linux/mfd/dbx500-prcmu.h
index aab183d..d76114e 100644
--- a/include/linux/mfd/dbx500-prcmu.h
+++ b/include/linux/mfd/dbx500-prcmu.h
@@ -213,6 +213,23 @@ enum ddr_pwrst {
 	DDR_PWR_STATE_OFFHIGHLAT    = 0x03
 };
 
+/**
+ * enum ap_pwrst_trans - Transition states defined in PRCMU firmware
+ * @NO_TRANSITION: No power state transition
+ * @APEXECUTE_TO_APSLEEP: Power state transition from ApExecute to ApSleep
+ * @APIDLE_TO_APSLEEP: Power state transition from ApIdle to ApSleep
+ * @APEXECUTE_TO_APDEEPSLEEP: Power state transition from ApExecute to
+ *                          ApDeepSleep
+ * @APEXECUTE_TO_APIDLE: Power state transition from ApExecute to ApIdle
+ */
+enum ap_pwrst_trans {
+	PRCMU_AP_NO_CHANGE		= 0x00,
+	PRCMU_AP_SLEEP,
+	PRCMU_AP_DEEP_SLEEP,
+	PRCMU_AP_IDLE,
+	PRCMU_AP_DEEP_IDLE,
+};
+
 struct prcmu_tcdm_map {
 	u32 tcdm_size;
 	u32 legacy_offset;
@@ -224,77 +241,25 @@ struct prcmu_tcdm_map {
 
 #include <mach/id.h>
 
-static inline void __init prcmu_early_init(struct prcmu_tcdm_map *map)
-{
-	return db8500_prcmu_early_init(map);
-}
-
-static inline int prcmu_set_power_state(u8 state, bool keep_ulp_clk,
-		bool keep_ap_pll)
-{
-	return db8500_prcmu_set_power_state(state, keep_ulp_clk,
-		keep_ap_pll);
-}
-
-static inline u8 prcmu_get_power_state_result(void)
-{
-	return db8500_prcmu_get_power_state_result();
-}
-
-static inline int prcmu_gic_decouple(void)
-{
-	return db8500_prcmu_gic_decouple();
-}
-
-static inline int prcmu_gic_recouple(void)
-{
-	return db8500_prcmu_gic_recouple();
-}
-
-static inline bool prcmu_gic_pending_irq(void)
-{
-	return db8500_prcmu_gic_pending_irq();
-}
-
-static inline bool prcmu_is_cpu_in_wfi(int cpu)
-{
-	return db8500_prcmu_is_cpu_in_wfi(cpu);
-}
-
-static inline int prcmu_copy_gic_settings(void)
-{
-	return db8500_prcmu_copy_gic_settings();
-}
-
-static inline bool prcmu_pending_irq(void)
-{
-	return db8500_prcmu_pending_irq();
-}
+void prcmu_early_init(struct prcmu_tcdm_map *map);
 
-static inline int prcmu_set_epod(u16 epod_id, u8 epod_state)
-{
-	return db8500_prcmu_set_epod(epod_id, epod_state);
-}
+int prcmu_set_power_state(u8 state, bool keep_ulp_clk, bool keep_ap_pll);
+u8 prcmu_get_power_state_result(void);
 
-static inline void prcmu_enable_wakeups(u32 wakeups)
-{
-	db8500_prcmu_enable_wakeups(wakeups);
-}
+int prcmu_gic_decouple(void);
+int prcmu_gic_recouple(void);
+bool prcmu_gic_pending_irq(void);
+bool prcmu_is_cpu_in_wfi(int cpu);
+int prcmu_copy_gic_settings(void);
+bool prcmu_pending_irq(void);
 
-static inline void prcmu_disable_wakeups(void)
-{
-	prcmu_enable_wakeups(0);
-}
+int prcmu_set_epod(u16 epod_id, u8 epod_state);
 
-static inline void prcmu_config_abb_event_readout(u32 abb_events)
-{
-	db8500_prcmu_config_abb_event_readout(abb_events);
-}
+void prcmu_enable_wakeups(u32 wakeups);
+void prcmu_disable_wakeups(void);
 
-static inline void prcmu_get_abb_event_buffer(void __iomem **buf)
-{
-	db8500_prcmu_get_abb_event_buffer(buf);
-}
+void prcmu_config_abb_event_readout(u32 abb_events);
+void prcmu_get_abb_event_buffer(void __iomem **buf);
 
 int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size);
 int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size);
@@ -302,65 +267,35 @@ int prcmu_abb_write_masked(u8 slave, u8 reg, u8 *value, u8 *mask, u8 size);
 
 int prcmu_config_clkout(u8 clkout, u8 source, u8 div);
 
-static inline int prcmu_request_clock(u8 clock, bool enable)
-{
-	return db8500_prcmu_request_clock(clock, enable);
-}
+int prcmu_request_clock(u8 clock, bool enable);
 
 unsigned long prcmu_clock_rate(u8 clock);
 long prcmu_round_clock_rate(u8 clock, unsigned long rate);
 int prcmu_set_clock_rate(u8 clock, unsigned long rate);
 
-static inline int prcmu_set_ddr_opp(u8 opp)
-{
-	return db8500_prcmu_set_ddr_opp(opp);
-}
-static inline int prcmu_get_ddr_opp(void)
-{
-	return db8500_prcmu_get_ddr_opp();
-}
+int prcmu_set_ddr_opp(u8 opp);
+int prcmu_get_ddr_opp(void);
 
-static inline int prcmu_set_arm_opp(u8 opp)
-{
-	return db8500_prcmu_set_arm_opp(opp);
-}
+int prcmu_set_arm_opp(u8 opp);
 
-static inline int prcmu_get_arm_opp(void)
-{
-	return db8500_prcmu_get_arm_opp();
-}
+int prcmu_get_arm_opp(void);
 
-static inline int prcmu_set_ape_opp(u8 opp)
-{
-	return db8500_prcmu_set_ape_opp(opp);
-}
+int prcmu_set_ape_opp(u8 opp);
 
-static inline int prcmu_get_ape_opp(void)
-{
-	return db8500_prcmu_get_ape_opp();
-}
+int prcmu_get_ape_opp(void);
 
-static inline void prcmu_system_reset(u16 reset_code)
-{
-	return db8500_prcmu_system_reset(reset_code);
-}
+void prcmu_system_reset(u16 reset_code);
 
-static inline u16 prcmu_get_reset_code(void)
-{
-	return db8500_prcmu_get_reset_code();
-}
+u16 prcmu_get_reset_code(void);
 
 int prcmu_ac_wake_req(void);
 void prcmu_ac_sleep_req(void);
-static inline void prcmu_modem_reset(void)
-{
-	return db8500_prcmu_modem_reset();
-}
 
-static inline bool prcmu_is_ac_wake_requested(void)
-{
-	return db8500_prcmu_is_ac_wake_requested();
-}
+void prcmu_modem_reset(void);
+
+bool prcmu_is_ac_wake_requested(void);
+
+bool prcmu_has_arm_maxopp(void);
 
 static inline int prcmu_set_display_clocks(void)
 {
@@ -377,10 +312,7 @@ static inline int prcmu_enable_dsipll(void)
 	return db8500_prcmu_enable_dsipll();
 }
 
-static inline int prcmu_config_esram0_deep_sleep(u8 state)
-{
-	return db8500_prcmu_config_esram0_deep_sleep(state);
-}
+int prcmu_config_esram0_deep_sleep(u8 state);
 
 static inline int prcmu_config_hotdog(u8 threshold)
 {
@@ -402,300 +334,215 @@ static inline int prcmu_stop_temp_sense(void)
 	return  db8500_prcmu_stop_temp_sense();
 }
 
-static inline u32 prcmu_read(unsigned int reg)
-{
-	return db8500_prcmu_read(reg);
-}
-
-static inline void prcmu_write(unsigned int reg, u32 value)
-{
-	db8500_prcmu_write(reg, value);
-}
-
-static inline void prcmu_write_masked(unsigned int reg, u32 mask, u32 value)
-{
-	db8500_prcmu_write_masked(reg, mask, value);
-}
-
-static inline int prcmu_enable_a9wdog(u8 id)
-{
-	return db8500_prcmu_enable_a9wdog(id);
-}
-
-static inline int prcmu_disable_a9wdog(u8 id)
-{
-	return db8500_prcmu_disable_a9wdog(id);
-}
-
-static inline int prcmu_kick_a9wdog(u8 id)
-{
-	return db8500_prcmu_kick_a9wdog(id);
-}
-
-static inline int prcmu_load_a9wdog(u8 id, u32 timeout)
-{
-	return db8500_prcmu_load_a9wdog(id, timeout);
-}
-
-static inline int prcmu_config_a9wdog(u8 num, bool sleep_auto_off)
-{
-	return db8500_prcmu_config_a9wdog(num, sleep_auto_off);
-}
-#else
-
-static inline void __init prcmu_early_init(struct prcmu_tcdm_map *map) {}
-
-static inline int prcmu_set_power_state(u8 state, bool keep_ulp_clk,
-	bool keep_ap_pll)
-{
-	return 0;
-}
-
-static inline int prcmu_set_epod(u16 epod_id, u8 epod_state)
-{
-	return 0;
-}
-
-static inline void prcmu_enable_wakeups(u32 wakeups) {}
-
-static inline void prcmu_disable_wakeups(void) {}
-
-static inline int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
-{
-	return -ENOSYS;
-}
-
-static inline int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
-{
-	return -ENOSYS;
-}
-
-static inline int prcmu_abb_write_masked(u8 slave, u8 reg, u8 *value, u8 *mask,
-	u8 size)
-{
-	return -ENOSYS;
-}
-
-static inline int prcmu_config_clkout(u8 clkout, u8 source, u8 div)
-{
-	return 0;
-}
-
-static inline int prcmu_request_clock(u8 clock, bool enable)
-{
-	return 0;
-}
+u32 prcmu_read(unsigned int reg);
+void prcmu_write(unsigned int reg, u32 value);
+void prcmu_write_masked(unsigned int reg, u32 mask, u32 value);
 
-static inline long prcmu_round_clock_rate(u8 clock, unsigned long rate)
-{
-	return 0;
-}
+int prcmu_enable_a9wdog(u8 id);
+int prcmu_disable_a9wdog(u8 id);
+int prcmu_kick_a9wdog(u8 id);
+int prcmu_load_a9wdog(u8 id, u32 timeout);
+int prcmu_config_a9wdog(u8 num, bool sleep_auto_off);
 
-static inline int prcmu_set_clock_rate(u8 clock, unsigned long rate)
-{
-	return 0;
-}
 
-static inline unsigned long prcmu_clock_rate(u8 clock)
-{
-	return 0;
-}
+/* prcmu_get_val /prcmu_set_val */
+enum prcmu_val {
+	DDR_OPP,
+	ARM_OPP,
+	APE_OPP,
 
-static inline int prcmu_set_ape_opp(u8 opp)
-{
-	return 0;
-}
+	PRCMU_VAL_MAX /*  used for dimensioning */
+};
 
-static inline int prcmu_get_ape_opp(void)
-{
-	return APE_100_OPP;
-}
+int prcmu_set_val(enum prcmu_val type, u32 value);
+int prcmu_get_val(enum prcmu_val type);
 
-static inline int prcmu_set_arm_opp(u8 opp)
-{
-	return 0;
-}
+/*  prcmu_enable/prcmu_disable */
+enum prcmu_out {
+	SPI2_MUX,
+	STM_MOD_UART_MUX,
+	STM_APE_MUX,
 
-static inline int prcmu_get_arm_opp(void)
-{
-	return ARM_100_OPP;
-}
+	PRCMU_OUT_MAX /* used for dimensioning  */
+};
 
-static inline int prcmu_set_ddr_opp(u8 opp)
-{
-	return 0;
-}
+int prcmu_enable(enum prcmu_out out);
+int prcmu_disable(enum prcmu_out out);
 
-static inline int prcmu_get_ddr_opp(void)
-{
-	return DDR_100_OPP;
-}
 
-static inline void prcmu_system_reset(u16 reset_code) {}
+struct prcmu_out_data {
+	enum prcmu_out out;
+	int (*enable)(void);
+	int (*disable)(void);
+};
 
-static inline u16 prcmu_get_reset_code(void)
-{
-	return 0;
-}
+struct prcmu_val_data {
+	enum prcmu_val val;
+	int (*get_val)(void);
+	int (*set_val)(u8 value);
+};
 
-static inline int prcmu_ac_wake_req(void)
-{
-	return 0;
-}
 
-static inline void prcmu_ac_sleep_req(void) {}
+/**
+ * @brief mfd device dbx500-prmcu early fops
+ */
+struct prcmu_early_data {
+	/* reset */
+	void (*system_reset) (u16 reset_code);
 
-static inline void prcmu_modem_reset(void) {}
+	/*  clock api  */
+	int (*config_clkout) (u8 clkout, u8 source, u8 div);
+	int (*request_clock) (u8 clock, bool enable);
 
-static inline bool prcmu_is_ac_wake_requested(void)
-{
-	return false;
-}
+	/* direct access to prcmu reg */
+	u32 (*read) (unsigned int reg);
+	void (*write) (unsigned int reg, u32 value);
+	void (*write_masked) (unsigned int reg, u32 mask, u32 value);
 
-static inline int prcmu_set_display_clocks(void)
-{
-	return 0;
-}
 
-static inline int prcmu_disable_dsipll(void)
-{
-	return 0;
-}
+	/*  other specific 8500 */
+	long (*round_clock_rate) (u8 clock, unsigned long rate);
+	int (*set_clock_rate) (u8 clock, unsigned long rate);
+	unsigned long (*clock_rate) (u8 clock);
+	/*  clock specific */
+	struct prcmu_fw_version *(*get_fw_version) (void);
+	bool (*has_arm_maxopp)(void);
 
-static inline int prcmu_enable_dsipll(void)
-{
-	return 0;
-}
+};
 
-static inline int prcmu_config_esram0_deep_sleep(u8 state)
-{
-	return 0;
-}
+/**
+ * @brief mfd device dbx500-prmcu platform data
+ */
+struct prcmu_probe_data {
+	/* ux500 soc sysfs */
+	u16 (*get_reset_code) (void);
+
+	/* pm/suspend.c  */
+	int (*config_esram0_deep_sleep) (u8 state);
+	void (*enable_wakeups)(u32 wakeups);
+	bool (*is_ac_wake_requested) (void);
+	int (*set_power_state) (u8 state, bool keep_ulp_clk,
+			bool keep_ap_pll);
+	u8  (*get_power_state_result) (void);
+
+	/* modem */
+	void (*modem_reset)(void);
+
+	/* no used at all */
+	void (*config_abb_event_readout) (u32 abb_events);
+	void (*get_abb_event_buffer) (void __iomem **buf);
+
+	/* abb access */
+	int (*abb_read) (u8 slave, u8 reg, u8 *value, u8 size);
+	int (*abb_write) (u8 slave, u8 reg, u8 *value, u8 size);
+
+	u32 (*get_reset_status)(void);
+	/*  other u8500 specific */
+	int (*request_ape_opp_100_voltage) (bool enable);
+	void (*configure_auto_pm) (struct prcmu_auto_pm_config *sleep,
+	struct prcmu_auto_pm_config *idle);
+	int (*set_epod) (u16 epod_id, u8 epod_state);
+
+	/* abb specific */
+	int (*abb_write_masked) (u8 slave, u8 reg, u8 *value,
+		u8 *mask, u8 size);
+
+	/* watchdog */
+	int (*config_a9wdog) (u8 num, bool sleep_auto_off);
+	int (*enable_a9wdog) (u8 id);
+	int (*disable_a9wdog) (u8 id);
+	int (*kick_a9wdog) (u8 id);
+	int (*load_a9wdog) (u8 id, u32 val);
+};
 
-static inline void prcmu_config_abb_event_readout(u32 abb_events) {}
+/* on u8500 default behaviour return 0 */
+struct prcmu_probe_cpuhp_data {
+	int (*stay_in_wfi_check)(void);
+	int (*replug_cpu1) (void);
+	int (*unplug_cpu1) (void);
+};
 
-static inline void prcmu_get_abb_event_buffer(void __iomem **buf)
-{
-	*buf = NULL;
-}
 
-static inline int prcmu_config_hotdog(u8 threshold)
-{
-	return 0;
-}
+enum prcmu_fops_type {
+	PRCMU_VAL,
+	PRCMU_OUT,
+	PRCMU_EARLY,
+	PRCMU_PROBE,
+	PRCMU_PROBE_CPU_HP,
+	PRCMU_APE_AGE,
+};
 
-static inline int prcmu_config_hotmon(u8 low, u8 high)
-{
-	return 0;
-}
+struct prcmu_fops_register {
+	enum prcmu_fops_type fops;
+	int size;
+	union {
+		struct prcmu_val_data *pval;
+		struct prcmu_out_data *pout;
+		struct prcmu_early_data *pearly;
+		struct prcmu_probe_data *pprobe;
+		struct prcmu_probe_cpuhp_data *pprobe_cpuhp;
+		bool (*check_ape_age)(void);
+	} data;
+};
 
-static inline int prcmu_start_temp_sense(u16 cycles32k)
-{
-	return 0;
-}
+/**
+ * @brief mfd device dbx500-prcmu platform data
+ */
+struct prcmu_fops_register_data {
+	int size;
+	struct prcmu_fops_register *tab;
+};
 
-static inline int prcmu_stop_temp_sense(void)
-{
-	return 0;
-}
+/**
+ * struct dbx500_regulator_init_data - mfd device prcmu-regulators data
+ *
+ */
+struct dbx500_regulator_init_data {
+	int (*set_epod) (u16 epod_id, u8 epod_state);
+	void *regulators;
+	int reg_num;
+};
 
-static inline u32 prcmu_read(unsigned int reg)
-{
-	return 0;
-}
+#else
 
-static inline void prcmu_write(unsigned int reg, u32 value) {}
+static inline void __init prcmu_early_init(struct prcmu_tcdm_map *map) {}
 
-static inline void prcmu_write_masked(unsigned int reg, u32 mask, u32 value) {}
 
 #endif
 
-static inline void prcmu_set(unsigned int reg, u32 bits)
-{
-	prcmu_write_masked(reg, bits, bits);
-}
-
-static inline void prcmu_clear(unsigned int reg, u32 bits)
-{
-	prcmu_write_masked(reg, bits, 0);
-}
 
 #if defined(CONFIG_UX500_SOC_DB8500)
 
 /**
  * prcmu_enable_spi2 - Enables pin muxing for SPI2 on OtherAlternateC1.
  */
-static inline void prcmu_enable_spi2(void)
-{
-	if (cpu_is_u8500())
-		prcmu_set(DB8500_PRCM_GPIOCR, DB8500_PRCM_GPIOCR_SPI2_SELECT);
-}
+void prcmu_enable_spi2(void);
 
 /**
  * prcmu_disable_spi2 - Disables pin muxing for SPI2 on OtherAlternateC1.
  */
-static inline void prcmu_disable_spi2(void)
-{
-	if (cpu_is_u8500())
-		prcmu_clear(DB8500_PRCM_GPIOCR, DB8500_PRCM_GPIOCR_SPI2_SELECT);
-}
-
+void prcmu_disable_spi2(void);
 /**
  * prcmu_enable_stm_mod_uart - Enables pin muxing for STMMOD
  * and UARTMOD on OtherAlternateC3.
  */
-static inline void prcmu_enable_stm_mod_uart(void)
-{
-	if (cpu_is_u8500()) {
-		prcmu_set(DB8500_PRCM_GPIOCR,
-			(DB8500_PRCM_GPIOCR_DBG_STM_MOD_CMD1 |
-			 DB8500_PRCM_GPIOCR_DBG_UARTMOD_CMD0));
-	}
-}
+void prcmu_enable_stm_mod_uart(void);
 
 /**
  * prcmu_disable_stm_mod_uart - Disables pin muxing for STMMOD
  * and UARTMOD on OtherAlternateC3.
  */
-static inline void prcmu_disable_stm_mod_uart(void)
-{
-	if (cpu_is_u8500()) {
-		prcmu_clear(DB8500_PRCM_GPIOCR,
-			(DB8500_PRCM_GPIOCR_DBG_STM_MOD_CMD1 |
-			 DB8500_PRCM_GPIOCR_DBG_UARTMOD_CMD0));
-	}
-}
+void prcmu_disable_stm_mod_uart(void);
 
 /**
  * prcmu_enable_stm_ape - Enables pin muxing for STM APE on OtherAlternateC1.
  */
-static inline void prcmu_enable_stm_ape(void)
-{
-	if (cpu_is_u8500()) {
-		prcmu_set(DB8500_PRCM_GPIOCR,
-			DB8500_PRCM_GPIOCR_DBG_STM_APE_CMD);
-	}
-}
+void prcmu_enable_stm_ape(void);
 
 /**
  * prcmu_disable_stm_ape - Disables pin muxing for STM APE on OtherAlternateC1.
  */
-static inline void prcmu_disable_stm_ape(void)
-{
-	if (cpu_is_u8500()) {
-		prcmu_clear(DB8500_PRCM_GPIOCR,
-			DB8500_PRCM_GPIOCR_DBG_STM_APE_CMD);
-	}
-}
-
-#else
-
-static inline void prcmu_enable_spi2(void) {}
-static inline void prcmu_disable_spi2(void) {}
-static inline void prcmu_enable_stm_mod_uart(void) {}
-static inline void prcmu_disable_stm_mod_uart(void) {}
-static inline void prcmu_enable_stm_ape(void) {}
-static inline void prcmu_disable_stm_ape(void) {}
+void prcmu_disable_stm_ape(void);
 
 #endif
 
-- 
1.7.11.1

