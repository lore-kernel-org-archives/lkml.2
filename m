Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab2IEKCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:02:20 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:40846 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758468Ab2IEJ7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:59:54 -0400
From: Loic Pallardy <loic.pallardy-ext@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.com>
Cc: Lee Jones <lee.jones@linaro.org>, Loic Pallardy <loic.pallardy@gmail.com>,
        LT ST-Ericsson <st-ericsson@lists.linaro.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Loic Pallardy <loic.pallardy-ext@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>
Subject: [PATCH 14/17] mfd: db8500-prcmu: use db8500 legacy services
Date: Wed, 5 Sep 2012 11:59:10 +0200
Message-ID: <1346839153-6465-15-git-send-email-loic.pallardy-ext@stericsson.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
References: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch exposes db8500 legacy services which are
now available to support new baseband.
If different are needed, then services are overloaded.
This allows to reduce duplicate code between projects.

Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db8500-prcmu.c | 90 +++++++++++++++++++++++-----------------------
 drivers/mfd/dbx500-prcmu.h | 71 ++++++++++++++++++++++++++++++++++++
 2 files changed, 116 insertions(+), 45 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 73c98e5..b39441f 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -327,12 +327,12 @@ int db8500_prcmu_set_display_clocks(void)
 	return 0;
 }
 
-static u32 db8500_prcmu_read(unsigned int reg)
+u32 db8500_prcmu_read(unsigned int reg)
 {
 	return readl(_PRCMU_BASE + reg);
 }
 
-static void db8500_prcmu_write(unsigned int reg, u32 value)
+void db8500_prcmu_write(unsigned int reg, u32 value)
 {
 	unsigned long flags;
 
@@ -341,7 +341,7 @@ static void db8500_prcmu_write(unsigned int reg, u32 value)
 	spin_unlock_irqrestore(&prcmu_lock, flags);
 }
 
-static void db8500_prcmu_write_masked(unsigned int reg, u32 mask, u32 value)
+void db8500_prcmu_write_masked(unsigned int reg, u32 mask, u32 value)
 {
 	u32 val;
 	unsigned long flags;
@@ -517,7 +517,7 @@ int db8500_prcmu_set_power_state(u8 state, bool keep_ulp_clk, bool keep_ap_pll)
 	return 0;
 }
 
-static u8 db8500_prcmu_get_power_state_result(void)
+u8 db8500_prcmu_get_power_state_result(void)
 {
 	return readb(tcdm_legacy_base + PRCM_ACK_MB0_AP_PWRSTTR_STATUS);
 }
@@ -668,7 +668,7 @@ static void config_wakeups(void)
 	last_abb_events = abb_events;
 }
 
-static void db8500_prcmu_enable_wakeups(u32 wakeups)
+void db8500_prcmu_enable_wakeups(u32 wakeups)
 {
 	unsigned long flags;
 	u32 bits;
@@ -689,7 +689,7 @@ static void db8500_prcmu_enable_wakeups(u32 wakeups)
 	spin_unlock_irqrestore(&mb0->lock, flags);
 }
 
-static void db8500_prcmu_config_abb_event_readout(u32 abb_events)
+void db8500_prcmu_config_abb_event_readout(u32 abb_events)
 {
 	unsigned long flags;
 
@@ -701,7 +701,7 @@ static void db8500_prcmu_config_abb_event_readout(u32 abb_events)
 	spin_unlock_irqrestore(&mb0->lock, flags);
 }
 
-static void db8500_prcmu_get_abb_event_buffer(void __iomem **buf)
+void db8500_prcmu_get_abb_event_buffer(void __iomem **buf)
 {
 	if (readb(tcdm_legacy_base + PRCM_ACK_MB0_READ_POINTER) & 1)
 		*buf = (tcdm_legacy_base + PRCM_ACK_MB0_WAKEUP_1_4500);
@@ -1002,7 +1002,7 @@ static int request_pll(u8 clock, bool enable)
  * This function sets the state of a EPOD (power domain). It may not be called
  * from interrupt context.
  */
-static int db8500_prcmu_set_epod(u16 epod_id, u8 epod_state)
+int db8500_prcmu_set_epod(u16 epod_id, u8 epod_state)
 {
 	int r = 0;
 	bool ram_retention = false;
@@ -1068,7 +1068,7 @@ unlock_and_return:
  * @sleep: Configuration for ApSleep.
  * @idle:  Configuration for ApIdle.
  */
-static void db8500_prcmu_configure_auto_pm(struct prcmu_auto_pm_config *sleep,
+void db8500_prcmu_configure_auto_pm(struct prcmu_auto_pm_config *sleep,
 	struct prcmu_auto_pm_config *idle)
 {
 	u32 sleep_cfg;
@@ -1844,7 +1844,7 @@ static int prcmu_a9wdog(u8 cmd, u8 d0, u8 d1, u8 d2, u8 d3)
 
 }
 
-static int db8500_prcmu_config_a9wdog(u8 num, bool sleep_auto_off)
+int db8500_prcmu_config_a9wdog(u8 num, bool sleep_auto_off)
 {
 	BUG_ON(num == 0 || num > 0xf);
 	return prcmu_a9wdog(MB4H_A9WDOG_CONF, num, 0, 0,
@@ -1852,17 +1852,17 @@ static int db8500_prcmu_config_a9wdog(u8 num, bool sleep_auto_off)
 			    A9WDOG_AUTO_OFF_DIS);
 }
 
-static int db8500_prcmu_enable_a9wdog(u8 id)
+int db8500_prcmu_enable_a9wdog(u8 id)
 {
 	return prcmu_a9wdog(MB4H_A9WDOG_EN, id, 0, 0, 0);
 }
 
-static int db8500_prcmu_disable_a9wdog(u8 id)
+int db8500_prcmu_disable_a9wdog(u8 id)
 {
 	return prcmu_a9wdog(MB4H_A9WDOG_DIS, id, 0, 0, 0);
 }
 
-static int db8500_prcmu_kick_a9wdog(u8 id)
+int db8500_prcmu_kick_a9wdog(u8 id)
 {
 	return prcmu_a9wdog(MB4H_A9WDOG_KICK, id, 0, 0, 0);
 }
@@ -1870,7 +1870,7 @@ static int db8500_prcmu_kick_a9wdog(u8 id)
 /*
  * timeout is 28 bit, in ms.
  */
-static int db8500_prcmu_load_a9wdog(u8 id, u32 timeout)
+int db8500_prcmu_load_a9wdog(u8 id, u32 timeout)
 {
 	return prcmu_a9wdog(MB4H_A9WDOG_LOAD,
 			    (id & A9WDOG_ID_MASK) |
@@ -1894,7 +1894,7 @@ static int db8500_prcmu_load_a9wdog(u8 id, u32 timeout)
  * Reads register value(s) from the ABB.
  * @size has to be 1 for the current firmware version.
  */
-static int db8500_prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
+int db8500_prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
 {
 	int r;
 
@@ -1945,7 +1945,7 @@ static int db8500_prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
  * will be written. The other bits are not changed.
  * @size has to be 1 for the current firmware version.
  */
-static int db8500_prcmu_abb_write_masked(u8 slave, u8 reg, u8 *value, u8 *mask,
+int db8500_prcmu_abb_write_masked(u8 slave, u8 reg, u8 *value, u8 *mask,
 		u8 size)
 {
 	int r;
@@ -1991,7 +1991,7 @@ static int db8500_prcmu_abb_write_masked(u8 slave, u8 reg, u8 *value, u8 *mask,
  * Writes register value(s) to the ABB.
  * @size has to be 1 for the current firmware version.
  */
-static int db8500_prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
+int db8500_prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
 {
 	u8 mask = ~0;
 
@@ -2081,7 +2081,7 @@ static bool db8500_prcmu_is_ac_wake_requested(void)
  * Saves the reset reason code and then sets the APE_SOFTRST register which
  * fires interrupt to fw
  */
-static void db8500_prcmu_system_reset(u16 reset_code)
+void db8500_prcmu_system_reset(u16 reset_code)
 {
 	writew(reset_code, (tcdm_legacy_base + PRCM_SW_RST_REASON));
 	writel(1, PRCM_APE_SOFTRST);
@@ -2142,7 +2142,7 @@ static inline void print_unknown_header_warning(u8 n, u8 header)
 		header, n);
 }
 
-static bool read_mailbox_0(void)
+bool db8500_prcmu_read_mailbox_0(void)
 {
 	bool r;
 	u32 ev;
@@ -2182,7 +2182,7 @@ static bool read_mailbox_0(void)
 	return r;
 }
 
-static bool read_mailbox_1(void)
+bool db8500_prcmu_read_mailbox_1(void)
 {
 	mb1->ack.header = readb(tcdm_legacy_base +
 			PRCM_MBOX_HEADER_REQ_MB1);
@@ -2197,7 +2197,7 @@ static bool read_mailbox_1(void)
 	return false;
 }
 
-static bool read_mailbox_2(void)
+bool db8500_prcmu_read_mailbox_2(void)
 {
 	mb2->ack.status = readb(tcdm_legacy_base
 			+ PRCM_ACK_MB2_DPS_STATUS);
@@ -2206,13 +2206,13 @@ static bool read_mailbox_2(void)
 	return false;
 }
 
-static bool read_mailbox_3(void)
+bool db8500_prcmu_read_mailbox_3(void)
 {
 	writel(MBOX_BIT(3), PRCM_ARM_IT1_CLR);
 	return false;
 }
 
-static bool read_mailbox_4(void)
+bool db8500_prcmu_read_mailbox_4(void)
 {
 	u8 header;
 	bool do_complete = true;
@@ -2243,7 +2243,7 @@ static bool read_mailbox_4(void)
 	return false;
 }
 
-static bool read_mailbox_5(void)
+bool db8500_prcmu_read_mailbox_5(void)
 {
 	mb5->ack.status = readb(tcdm_legacy_base
 			+ PRCM_ACK_MB5_I2C_STATUS);
@@ -2253,32 +2253,32 @@ static bool read_mailbox_5(void)
 	return false;
 }
 
-static bool read_mailbox_6(void)
+bool db8500_prcmu_read_mailbox_6(void)
 {
 	writel(MBOX_BIT(6), PRCM_ARM_IT1_CLR);
 	return false;
 }
 
-static bool read_mailbox_7(void)
+bool db8500_prcmu_read_mailbox_7(void)
 {
 	writel(MBOX_BIT(7), PRCM_ARM_IT1_CLR);
 	return false;
 }
 
 static bool (*db8500_read_mailbox[NUM_MB])(void) = {
-	read_mailbox_0,
-	read_mailbox_1,
-	read_mailbox_2,
-	read_mailbox_3,
-	read_mailbox_4,
-	read_mailbox_5,
-	read_mailbox_6,
-	read_mailbox_7
+	db8500_prcmu_read_mailbox_0,
+	db8500_prcmu_read_mailbox_1,
+	db8500_prcmu_read_mailbox_2,
+	db8500_prcmu_read_mailbox_3,
+	db8500_prcmu_read_mailbox_4,
+	db8500_prcmu_read_mailbox_5,
+	db8500_prcmu_read_mailbox_6,
+	db8500_prcmu_read_mailbox_7
 };
 
 static bool (**read_mailbox)(void);
 
-static irqreturn_t prcmu_irq_handler(int irq, void *data)
+irqreturn_t db8500_prcmu_irq_handler(int irq, void *data)
 {
 	u32 bits;
 	u8 n;
@@ -2299,7 +2299,7 @@ static irqreturn_t prcmu_irq_handler(int irq, void *data)
 	return r;
 }
 
-static irqreturn_t prcmu_irq_thread_fn(int irq, void *data)
+irqreturn_t db8500_prcmu_irq_thread_fn(int irq, void *data)
 {
 	ack_dbb_wakeup();
 	return IRQ_HANDLED;
@@ -2389,7 +2389,7 @@ static inline void db8500_prcmu_clear(unsigned int reg, u32 bits)
 }
 
 
-static int db8500_prcmu_enable_spi2(void)
+int db8500_prcmu_enable_spi2(void)
 {
 	db8500_prcmu_set(DB8500_PRCM_GPIOCR, DB8500_PRCM_GPIOCR_SPI2_SELECT);
 	return 0;
@@ -2398,7 +2398,7 @@ static int db8500_prcmu_enable_spi2(void)
 /**
  * prcmu_disable_spi2 - Disables pin muxing for SPI2 on OtherAlternateC1.
  */
-static int db8500_prcmu_disable_spi2(void)
+int db8500_prcmu_disable_spi2(void)
 {
 	db8500_prcmu_clear(DB8500_PRCM_GPIOCR, DB8500_PRCM_GPIOCR_SPI2_SELECT);
 	return 0;
@@ -2408,7 +2408,7 @@ static int db8500_prcmu_disable_spi2(void)
  * prcmu_enable_stm_mod_uart - Enables pin muxing for STMMOD
  * and UARTMOD on OtherAlternateC3.
  */
-static int db8500_prcmu_enable_stm_mod_uart(void)
+int db8500_prcmu_enable_stm_mod_uart(void)
 {
 	db8500_prcmu_set(DB8500_PRCM_GPIOCR,
 			(DB8500_PRCM_GPIOCR_DBG_STM_MOD_CMD1 |
@@ -2420,7 +2420,7 @@ static int db8500_prcmu_enable_stm_mod_uart(void)
  * prcmu_disable_stm_mod_uart - Disables pin muxing for STMMOD
  * and UARTMOD on OtherAlternateC3.
  */
-static int db8500_prcmu_disable_stm_mod_uart(void)
+int db8500_prcmu_disable_stm_mod_uart(void)
 {
 	db8500_prcmu_clear(DB8500_PRCM_GPIOCR,
 			(DB8500_PRCM_GPIOCR_DBG_STM_MOD_CMD1 |
@@ -2431,7 +2431,7 @@ static int db8500_prcmu_disable_stm_mod_uart(void)
 /**
  * prcmu_enable_stm_ape - Enables pin muxing for STM APE on OtherAlternateC1.
  */
-static int db8500_prcmu_enable_stm_ape(void)
+int db8500_prcmu_enable_stm_ape(void)
 {
 	db8500_prcmu_set(DB8500_PRCM_GPIOCR,
 			DB8500_PRCM_GPIOCR_DBG_STM_APE_CMD);
@@ -2441,7 +2441,7 @@ static int db8500_prcmu_enable_stm_ape(void)
 /**
  * prcmu_disable_stm_ape - Disables pin muxing for STM APE on OtherAlternateC1.
  */
-static int db8500_prcmu_disable_stm_ape(void)
+int db8500_prcmu_disable_stm_ape(void)
 {
 	db8500_prcmu_clear(DB8500_PRCM_GPIOCR,
 			DB8500_PRCM_GPIOCR_DBG_STM_APE_CMD);
@@ -2645,7 +2645,7 @@ static struct irq_domain_ops db8500_irq_ops = {
         .xlate  = irq_domain_xlate_twocell,
 };
 
-static int db8500_irq_init(struct device_node *np)
+int db8500_irq_init(struct device_node *np)
 {
 	db8500_irq_domain = irq_domain_add_legacy(
 		np, NUM_PRCMU_WAKEUPS, IRQ_PRCMU_BASE,
@@ -3034,8 +3034,8 @@ static int __devinit db8500_prcmu_probe(struct platform_device *pdev)
 	if (!np || irq <= 0)
 		irq = IRQ_DB8500_PRCMU1;
 
-	err = request_threaded_irq(irq, prcmu_irq_handler,
-	        prcmu_irq_thread_fn, IRQF_NO_SUSPEND, "prcmu", NULL);
+	err = request_threaded_irq(irq, db8500_prcmu_irq_handler,
+		db8500_prcmu_irq_thread_fn, IRQF_NO_SUSPEND, "prcmu", NULL);
 	if (err < 0) {
 		pr_err("prcmu: Failed to allocate IRQ_DB8500_PRCMU1.\n");
 		err = -EBUSY;
diff --git a/drivers/mfd/dbx500-prcmu.h b/drivers/mfd/dbx500-prcmu.h
index ce0e519..037695d 100644
--- a/drivers/mfd/dbx500-prcmu.h
+++ b/drivers/mfd/dbx500-prcmu.h
@@ -392,3 +392,74 @@ struct prcmu_context {
 	bool (**read_mbox)(void);
 };
 
+/* initialization */
+int db8500_prcmu_context_init(struct prcmu_context *context);
+int db8500_irq_init(struct device_node *np);
+int db8500_prcmu_clean_mailbox_irq(void);
+char *fw_project_name(u32 project);
+
+/* interrupt management */
+irqreturn_t db8500_prcmu_irq_handler(int irq, void *data);
+irqreturn_t db8500_prcmu_irq_thread_fn(int irq, void *data);
+
+/*  debug */
+void db8500_prcmu_debug_dump(const char *func,
+				bool dump_prcmu, bool dump_abb);
+
+/* mailbox services */
+int db8500_prcmu_init_mb0(struct mb0_transfer *mb);
+int db8500_prcmu_init_mb1(struct mb1_transfer *mb);
+int db8500_prcmu_init_mb2(struct mb2_transfer *mb);
+int db8500_prcmu_init_mb3(struct mb3_transfer *mb);
+int db8500_prcmu_init_mb4(struct mb4_transfer *mb);
+int db8500_prcmu_init_mb5(struct mb5_transfer *mb);
+
+bool db8500_prcmu_read_mailbox_0(void);
+bool db8500_prcmu_read_mailbox_1(void);
+bool db8500_prcmu_read_mailbox_2(void);
+bool db8500_prcmu_read_mailbox_3(void);
+bool db8500_prcmu_read_mailbox_4(void);
+bool db8500_prcmu_read_mailbox_5(void);
+bool db8500_prcmu_read_mailbox_6(void);
+bool db8500_prcmu_read_mailbox_7(void);
+
+/* PRCMU services */
+void db8500_prcmu_system_reset(u16 reset_code);
+
+/* direct access */
+u32 db8500_prcmu_read(unsigned int reg);
+void db8500_prcmu_write(unsigned int reg, u32 value);
+void db8500_prcmu_write_masked(unsigned int reg, u32 mask, u32 value);
+
+void db8500_prcmu_vc(bool enable);
+int db8500_prcmu_set_epod(u16 epod_id, u8 epod_state);
+
+int db8500_prcmu_set_power_state(u8 state, bool keep_ulp_clk, bool keep_ap_pll);
+u8 db8500_prcmu_get_power_state_result(void);
+void db8500_prcmu_enable_wakeups(u32 wakeups);
+void db8500_prcmu_configure_auto_pm(struct prcmu_auto_pm_config *sleep,
+	struct prcmu_auto_pm_config *idle);
+
+/* ABB access */
+void db8500_prcmu_config_abb_event_readout(u32 abb_events);
+void db8500_prcmu_get_abb_event_buffer(void __iomem **buf);
+
+int db8500_prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size);
+int db8500_prcmu_abb_read_no_irq(u8 slave, u8 reg, u8 *value, u8 size);
+int db8500_prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size);
+int db8500_prcmu_abb_write_masked(u8 slave, u8 reg, u8 *value, u8 *mask, u8 size);
+
+/* a9 watchdog */
+int db8500_prcmu_config_a9wdog(u8 num, bool sleep_auto_off);
+int db8500_prcmu_enable_a9wdog(u8 id);
+int db8500_prcmu_disable_a9wdog(u8 id);
+int db8500_prcmu_kick_a9wdog(u8 id);
+int db8500_prcmu_load_a9wdog(u8 id, u32 timeout);
+
+/* peripheral management */
+int db8500_prcmu_enable_spi2(void);
+int db8500_prcmu_disable_spi2(void);
+int db8500_prcmu_enable_stm_mod_uart(void);
+int db8500_prcmu_disable_stm_mod_uart(void);
+int db8500_prcmu_enable_stm_ape(void);
+int db8500_prcmu_disable_stm_ape(void);
-- 
1.7.11.1

