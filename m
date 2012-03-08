Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774Ab2CHNCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 08:02:32 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:54200 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757632Ab2CHNC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 08:02:29 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/4] mfd/prcmu-db8500: add prcmu_abb_write_masked
Date: Thu, 8 Mar 2012 14:02:05 +0100
Message-ID: <1331211725-9835-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias Nilsson <mattias.i.nilsson@stericsson.com>

This patch adds driver support for the I2C read-modify-write
service in the U8500 PRCMU firmware.

Signed-off-by: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db8500-prcmu.c       |   28 +++++++++++++++++++++++++---
 include/linux/mfd/dbx500-prcmu.h |    7 +++++++
 2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index af8e0ef..931d5e0 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -1675,6 +1675,7 @@ int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(5))
 		cpu_relax();
 
+	writeb(0, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB5));
 	writeb(PRCMU_I2C_READ(slave), (tcdm_base + PRCM_REQ_MB5_I2C_SLAVE_OP));
 	writeb(PRCMU_I2C_STOP_EN, (tcdm_base + PRCM_REQ_MB5_I2C_HW_BITS));
 	writeb(reg, (tcdm_base + PRCM_REQ_MB5_I2C_REG));
@@ -1700,16 +1701,19 @@ int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
 }
 
 /**
- * prcmu_abb_write() - Write register value(s) to the ABB.
+ * prcmu_abb_write_masked() - Write masked register value(s) to the ABB.
  * @slave:	The I2C slave address.
  * @reg:	The (start) register address.
  * @value:	The value(s) to write.
+ * @mask:	The mask(s) to use.
  * @size:	The number of registers to write.
  *
- * Reads register value(s) from the ABB.
+ * Writes masked register value(s) to the ABB.
+ * For each @value, only the bits set to 1 in the corresponding @mask
+ * will be written. The other bits are not changed.
  * @size has to be 1 for the current firmware version.
  */
-int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
+int prcmu_abb_write_masked(u8 slave, u8 reg, u8 *value, u8 *mask, u8 size)
 {
 	int r;
 
@@ -1721,6 +1725,7 @@ int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(5))
 		cpu_relax();
 
+	writeb(~*mask, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB5));
 	writeb(PRCMU_I2C_WRITE(slave), (tcdm_base + PRCM_REQ_MB5_I2C_SLAVE_OP));
 	writeb(PRCMU_I2C_STOP_EN, (tcdm_base + PRCM_REQ_MB5_I2C_HW_BITS));
 	writeb(reg, (tcdm_base + PRCM_REQ_MB5_I2C_REG));
@@ -1743,6 +1748,23 @@ int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
 }
 
 /**
+ * prcmu_abb_write() - Write register value(s) to the ABB.
+ * @slave:	The I2C slave address.
+ * @reg:	The (start) register address.
+ * @value:	The value(s) to write.
+ * @size:	The number of registers to write.
+ *
+ * Writes register value(s) to the ABB.
+ * @size has to be 1 for the current firmware version.
+ */
+int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
+{
+	u8 mask = ~0;
+
+	return prcmu_abb_write_masked(slave, reg, value, &mask, size);
+}
+
+/**
  * prcmu_ac_wake_req - should be called whenever ARM wants to wakeup Modem
  */
 void prcmu_ac_wake_req(void)
diff --git a/include/linux/mfd/dbx500-prcmu.h b/include/linux/mfd/dbx500-prcmu.h
index bac942f..19a0ff5 100644
--- a/include/linux/mfd/dbx500-prcmu.h
+++ b/include/linux/mfd/dbx500-prcmu.h
@@ -276,6 +276,7 @@ static inline void prcmu_get_abb_event_buffer(void __iomem **buf)
 
 int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size);
 int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size);
+int prcmu_abb_write_masked(u8 slave, u8 reg, u8 *value, u8 *mask, u8 size);
 
 int prcmu_config_clkout(u8 clkout, u8 source, u8 div);
 
@@ -395,6 +396,12 @@ static inline int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
 	return -ENOSYS;
 }
 
+static inline int prcmu_abb_write_masked(u8 slave, u8 reg, u8 *value, u8 *mask,
+	u8 size)
+{
+	return -ENOSYS;
+}
+
 static inline int prcmu_config_clkout(u8 clkout, u8 source, u8 div)
 {
 	return 0;
-- 
1.7.8

