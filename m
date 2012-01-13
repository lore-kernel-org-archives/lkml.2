Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329Ab2AMPVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:21:15 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:38658 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932449Ab2AMPVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:21:12 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Daniel Willerud <daniel.willerud@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 8/8] mfd/db8500-prcmu: add initial prcmu register access api
Date: Fri, 13 Jan 2012 16:21:00 +0100
Message-ID: <1326468060-11935-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias Nilsson <mattias.i.nilsson@stericsson.com>

This patch adds an initial PRCMU register access API, which
for now should only be used for a very limited set of registers.

The idea about this API is that we split the PRCMU driver in
one part that deals with interaction with the PRCMU firmware
and one part that simply provide write accessors in the PRCMU
register range. The latter are just a collection of registers
exposed in the PRCMU register range for various purposes and
not related to the PRCMU firmware.

Currently we support some limited GPIO, SPI and UART settings
through this API.

Signed-off-by: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db8500-prcmu.c       |   36 +++++------
 include/linux/mfd/db8500-prcmu.h |   44 ++++++++++----
 include/linux/mfd/dbx500-prcmu.h |  122 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 171 insertions(+), 31 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 0ee8015..128b5f4 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -417,8 +417,8 @@ static struct {
 static atomic_t ac_wake_req_state = ATOMIC_INIT(0);
 
 /* Spinlocks */
+static DEFINE_SPINLOCK(prcmu_lock);
 static DEFINE_SPINLOCK(clkout_lock);
-static DEFINE_SPINLOCK(gpiocr_lock);
 
 /* Global var to runtime determine TCDM base for v2 or v1 */
 static __iomem void *tcdm_base;
@@ -639,32 +639,30 @@ int db8500_prcmu_set_display_clocks(void)
 	return 0;
 }
 
-/**
- * prcmu_enable_spi2 - Enables pin muxing for SPI2 on OtherAlternateC1.
- */
-void prcmu_enable_spi2(void)
+u32 db8500_prcmu_read(unsigned int reg)
+{
+	return readl(_PRCMU_BASE + reg);
+}
+
+void db8500_prcmu_write(unsigned int reg, u32 value)
 {
-	u32 reg;
 	unsigned long flags;
 
-	spin_lock_irqsave(&gpiocr_lock, flags);
-	reg = readl(PRCM_GPIOCR);
-	writel(reg | PRCM_GPIOCR_SPI2_SELECT, PRCM_GPIOCR);
-	spin_unlock_irqrestore(&gpiocr_lock, flags);
+	spin_lock_irqsave(&prcmu_lock, flags);
+	writel(value, (_PRCMU_BASE + reg));
+	spin_unlock_irqrestore(&prcmu_lock, flags);
 }
 
-/**
- * prcmu_disable_spi2 - Disables pin muxing for SPI2 on OtherAlternateC1.
- */
-void prcmu_disable_spi2(void)
+void db8500_prcmu_write_masked(unsigned int reg, u32 mask, u32 value)
 {
-	u32 reg;
+	u32 val;
 	unsigned long flags;
 
-	spin_lock_irqsave(&gpiocr_lock, flags);
-	reg = readl(PRCM_GPIOCR);
-	writel(reg & ~PRCM_GPIOCR_SPI2_SELECT, PRCM_GPIOCR);
-	spin_unlock_irqrestore(&gpiocr_lock, flags);
+	spin_lock_irqsave(&prcmu_lock, flags);
+	val = readl(_PRCMU_BASE + reg);
+	val = ((val & ~mask) | (value & mask));
+	writel(val, (_PRCMU_BASE + reg));
+	spin_unlock_irqrestore(&prcmu_lock, flags);
 }
 
 struct prcmu_fw_version *prcmu_get_fw_version(void)
diff --git a/include/linux/mfd/db8500-prcmu.h b/include/linux/mfd/db8500-prcmu.h
index 841342c..636423b 100644
--- a/include/linux/mfd/db8500-prcmu.h
+++ b/include/linux/mfd/db8500-prcmu.h
@@ -11,6 +11,24 @@
 #define __MFD_DB8500_PRCMU_H
 
 #include <linux/interrupt.h>
+#include <linux/bitops.h>
+
+/*
+ * Registers
+ */
+#define DB8500_PRCM_GPIOCR 0x138
+#define DB8500_PRCM_GPIOCR_DBG_UARTMOD_CMD0	BIT(0)
+#define DB8500_PRCM_GPIOCR_DBG_STM_APE_CMD	BIT(9)
+#define DB8500_PRCM_GPIOCR_DBG_STM_MOD_CMD1	BIT(11)
+#define DB8500_PRCM_GPIOCR_SPI2_SELECT		BIT(23)
+
+#define DB8500_PRCM_LINE_VALUE 0x170
+#define DB8500_PRCM_LINE_VALUE_HSI_CAWAKE0	BIT(3)
+
+#define DB8500_PRCM_DSI_SW_RESET 0x324
+#define DB8500_PRCM_DSI_SW_RESET_DSI0_SW_RESETN BIT(0)
+#define DB8500_PRCM_DSI_SW_RESET_DSI1_SW_RESETN BIT(1)
+#define DB8500_PRCM_DSI_SW_RESET_DSI2_SW_RESETN BIT(2)
 
 /* This portion previously known as <mach/prcmu-fw-defs_v1.h> */
 
@@ -552,8 +570,6 @@ int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size);
 void prcmu_ac_wake_req(void);
 void prcmu_ac_sleep_req(void);
 void db8500_prcmu_modem_reset(void);
-void prcmu_enable_spi2(void);
-void prcmu_disable_spi2(void);
 
 int db8500_prcmu_config_a9wdog(u8 num, bool sleep_auto_off);
 int db8500_prcmu_enable_a9wdog(u8 id);
@@ -582,6 +598,10 @@ int db8500_prcmu_get_ape_opp(void);
 int db8500_prcmu_set_ddr_opp(u8 opp);
 int db8500_prcmu_get_ddr_opp(void);
 
+u32 db8500_prcmu_read(unsigned int reg);
+void db8500_prcmu_write(unsigned int reg, u32 value);
+void db8500_prcmu_write_masked(unsigned int reg, u32 mask, u32 value);
+
 #else /* !CONFIG_MFD_DB8500_PRCMU */
 
 static inline void db8500_prcmu_early_init(void) {}
@@ -703,16 +723,6 @@ static inline void db8500_prcmu_modem_reset(void) {}
 
 static inline void db8500_prcmu_system_reset(u16 reset_code) {}
 
-static inline int prcmu_enable_spi2(void)
-{
-	return 0;
-}
-
-static inline int prcmu_disable_spi2(void)
-{
-	return 0;
-}
-
 static inline int db8500_prcmu_set_power_state(u8 state, bool keep_ulp_clk,
 	bool keep_ap_pll)
 {
@@ -805,6 +815,16 @@ static inline int db8500_prcmu_get_arm_opp(void)
 	return 0;
 }
 
+static inline u32 db8500_prcmu_read(unsigned int reg)
+{
+	return 0;
+}
+
+static inline void db8500_prcmu_write(unsigned int reg, u32 value) {}
+
+static inline void db8500_prcmu_write_masked(unsigned int reg, u32 mask,
+	u32 value) {}
+
 #endif /* !CONFIG_MFD_DB8500_PRCMU */
 
 #endif /* __MFD_DB8500_PRCMU_H */
diff --git a/include/linux/mfd/dbx500-prcmu.h b/include/linux/mfd/dbx500-prcmu.h
index 432a2d3..b3b5adf 100644
--- a/include/linux/mfd/dbx500-prcmu.h
+++ b/include/linux/mfd/dbx500-prcmu.h
@@ -480,6 +480,30 @@ static inline int prcmu_stop_temp_sense(void)
 		return  db8500_prcmu_stop_temp_sense();
 }
 
+static inline u32 prcmu_read(unsigned int reg)
+{
+	if (cpu_is_u5500())
+		return -EINVAL;
+	else
+		return db8500_prcmu_read(reg);
+}
+
+static inline void prcmu_write(unsigned int reg, u32 value)
+{
+	if (cpu_is_u5500())
+		return;
+	else
+		db8500_prcmu_write(reg, value);
+}
+
+static inline void prcmu_write_masked(unsigned int reg, u32 mask, u32 value)
+{
+	if (cpu_is_u5500())
+		return;
+	else
+		db8500_prcmu_write_masked(reg, mask, value);
+}
+
 static inline int prcmu_enable_a9wdog(u8 id)
 {
 	if (cpu_is_u5500())
@@ -668,6 +692,104 @@ static inline int prcmu_stop_temp_sense(void)
 	return 0;
 }
 
+static inline u32 prcmu_read(unsigned int reg)
+{
+	return 0;
+}
+
+static inline void prcmu_write(unsigned int reg, u32 value) {}
+
+static inline void prcmu_write_masked(unsigned int reg, u32 mask, u32 value) {}
+
+#endif
+
+static inline void prcmu_set(unsigned int reg, u32 bits)
+{
+	prcmu_write_masked(reg, bits, bits);
+}
+
+static inline void prcmu_clear(unsigned int reg, u32 bits)
+{
+	prcmu_write_masked(reg, bits, 0);
+}
+
+#if defined(CONFIG_UX500_SOC_DB8500) || defined(CONFIG_UX500_SOC_DB5500)
+
+/**
+ * prcmu_enable_spi2 - Enables pin muxing for SPI2 on OtherAlternateC1.
+ */
+static inline void prcmu_enable_spi2(void)
+{
+	if (cpu_is_u8500())
+		prcmu_set(DB8500_PRCM_GPIOCR, DB8500_PRCM_GPIOCR_SPI2_SELECT);
+}
+
+/**
+ * prcmu_disable_spi2 - Disables pin muxing for SPI2 on OtherAlternateC1.
+ */
+static inline void prcmu_disable_spi2(void)
+{
+	if (cpu_is_u8500())
+		prcmu_clear(DB8500_PRCM_GPIOCR, DB8500_PRCM_GPIOCR_SPI2_SELECT);
+}
+
+/**
+ * prcmu_enable_stm_mod_uart - Enables pin muxing for STMMOD
+ * and UARTMOD on OtherAlternateC3.
+ */
+static inline void prcmu_enable_stm_mod_uart(void)
+{
+	if (cpu_is_u8500()) {
+		prcmu_set(DB8500_PRCM_GPIOCR,
+			(DB8500_PRCM_GPIOCR_DBG_STM_MOD_CMD1 |
+			 DB8500_PRCM_GPIOCR_DBG_UARTMOD_CMD0));
+	}
+}
+
+/**
+ * prcmu_disable_stm_mod_uart - Disables pin muxing for STMMOD
+ * and UARTMOD on OtherAlternateC3.
+ */
+static inline void prcmu_disable_stm_mod_uart(void)
+{
+	if (cpu_is_u8500()) {
+		prcmu_clear(DB8500_PRCM_GPIOCR,
+			(DB8500_PRCM_GPIOCR_DBG_STM_MOD_CMD1 |
+			 DB8500_PRCM_GPIOCR_DBG_UARTMOD_CMD0));
+	}
+}
+
+/**
+ * prcmu_enable_stm_ape - Enables pin muxing for STM APE on OtherAlternateC1.
+ */
+static inline void prcmu_enable_stm_ape(void)
+{
+	if (cpu_is_u8500()) {
+		prcmu_set(DB8500_PRCM_GPIOCR,
+			DB8500_PRCM_GPIOCR_DBG_STM_APE_CMD);
+	}
+}
+
+/**
+ * prcmu_disable_stm_ape - Disables pin muxing for STM APE on OtherAlternateC1.
+ */
+static inline void prcmu_disable_stm_ape(void)
+{
+	if (cpu_is_u8500()) {
+		prcmu_clear(DB8500_PRCM_GPIOCR,
+			DB8500_PRCM_GPIOCR_DBG_STM_APE_CMD);
+	}
+}
+
+#else
+
+static inline void prcmu_enable_spi2(void) {}
+static inline void prcmu_disable_spi2(void) {}
+static inline void prcmu_enable_stm_mod_uart(void) {}
+static inline void prcmu_disable_stm_mod_uart(void) {}
+static inline void prcmu_enable_stm_ape(void) {}
+static inline void prcmu_disable_stm_ape(void) {}
+
 #endif
 
 /* PRCMU QoS APE OPP class */
-- 
1.7.8

