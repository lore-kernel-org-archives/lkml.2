Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab0DFRvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 13:51:05 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:46356 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab0DFRuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 13:50:55 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: linux-i2c@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Cc: Philby John <pjohn@in.mvista.com>,
       "Srinivasan, Nageswari" <nageswari@ti.com>,
       "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Chaithrika U S <chaithrika@ti.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] i2c: davinci: bus recovery procedure to clear the bus
Date: Tue,  6 Apr 2010 10:42:18 -0700
Message-Id: <1270575738-22388-7-git-send-email-khilman@deeprootsystems.com>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1270575738-22388-1-git-send-email-khilman@deeprootsystems.com>
References: <1270575738-22388-1-git-send-email-khilman@deeprootsystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philby John <pjohn@in.mvista.com>

Come out of i2c time out condition by following the
bus recovery procedure outlined in the i2c protocol v3 spec.
The kernel must be robust enough to gracefully recover
from i2c bus failure without having to reset the machine.
This is done by first NACKing the slave, pulsing the SCL
line 9 times and then sending the stop command.

This patch has been tested on a DM6446 and DM355

Signed-off-by: Philby John <pjohn@in.mvista.com>
Signed-off-by: Srinivasan, Nageswari <nageswari@ti.com>
Acked-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 drivers/i2c/busses/i2c-davinci.c |   57 +++++++++++++++++++++++++++++++++++--
 1 files changed, 53 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index fd7a155..0f71a7e 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -36,6 +36,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/cpufreq.h>
+#include <linux/gpio.h>
 
 #include <mach/hardware.h>
 #include <mach/i2c.h>
@@ -43,6 +44,7 @@
 /* ----- global defines ----------------------------------------------- */
 
 #define DAVINCI_I2C_TIMEOUT	(1*HZ)
+#define DAVINCI_I2C_MAX_TRIES	2
 #define I2C_DAVINCI_INTR_ALL    (DAVINCI_I2C_IMR_AAS | \
 				 DAVINCI_I2C_IMR_SCD | \
 				 DAVINCI_I2C_IMR_ARDY | \
@@ -130,6 +132,44 @@ static inline u16 davinci_i2c_read_reg(struct davinci_i2c_dev *i2c_dev, int reg)
 	return __raw_readw(i2c_dev->base + reg);
 }
 
+/* Generate a pulse on the i2c clock pin. */
+static void generic_i2c_clock_pulse(unsigned int scl_pin)
+{
+	u16 i;
+
+	if (scl_pin) {
+		/* Send high and low on the SCL line */
+		for (i = 0; i < 9; i++) {
+			gpio_set_value(scl_pin, 0);
+			udelay(20);
+			gpio_set_value(scl_pin, 1);
+			udelay(20);
+		}
+	}
+}
+
+/* This routine does i2c bus recovery as specified in the
+ * i2c protocol Rev. 03 section 3.16 titled "Bus clear"
+ */
+static void i2c_recover_bus(struct davinci_i2c_dev *dev)
+{
+	u32 flag = 0;
+	struct davinci_i2c_platform_data *pdata = dev->dev->platform_data;
+
+	dev_err(dev->dev, "initiating i2c bus recovery\n");
+	/* Send NACK to the slave */
+	flag = davinci_i2c_read_reg(dev, DAVINCI_I2C_MDR_REG);
+	flag |=  DAVINCI_I2C_MDR_NACK;
+	/* write the data into mode register */
+	davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, flag);
+	if (pdata)
+		generic_i2c_clock_pulse(pdata->scl_pin);
+	/* Send STOP */
+	flag = davinci_i2c_read_reg(dev, DAVINCI_I2C_MDR_REG);
+	flag |= DAVINCI_I2C_MDR_STP;
+	davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, flag);
+}
+
 static inline void davinci_i2c_reset_ctrl(struct davinci_i2c_dev *i2c_dev,
 								int val)
 {
@@ -235,14 +275,22 @@ static int i2c_davinci_wait_bus_not_busy(struct davinci_i2c_dev *dev,
 					 char allow_sleep)
 {
 	unsigned long timeout;
+	static u16 to_cnt;
 
 	timeout = jiffies + dev->adapter.timeout;
 	while (davinci_i2c_read_reg(dev, DAVINCI_I2C_STR_REG)
 	       & DAVINCI_I2C_STR_BB) {
-		if (time_after(jiffies, timeout)) {
-			dev_warn(dev->dev,
-				 "timeout waiting for bus ready\n");
-			return -ETIMEDOUT;
+		if (to_cnt <= DAVINCI_I2C_MAX_TRIES) {
+			if (time_after(jiffies, timeout)) {
+				dev_warn(dev->dev,
+				"timeout waiting for bus ready\n");
+				to_cnt++;
+				return -ETIMEDOUT;
+			} else {
+				to_cnt = 0;
+				i2c_recover_bus(dev);
+				i2c_davinci_init(dev);
+			}
 		}
 		if (allow_sleep)
 			schedule_timeout(1);
@@ -326,6 +374,7 @@ i2c_davinci_xfer_msg(struct i2c_adapter *adap, struct i2c_msg *msg, int stop)
 						      dev->adapter.timeout);
 	if (r == 0) {
 		dev_err(dev->dev, "controller timed out\n");
+		i2c_recover_bus(dev);
 		i2c_davinci_init(dev);
 		dev->buf_len = 0;
 		return -ETIMEDOUT;
-- 
1.7.0.2

