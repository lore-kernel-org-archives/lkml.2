Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934605Ab1FWXNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:13:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7063 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934558Ab1FWXNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:13:04 -0400
From: Bryan Freed <bfreed@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: jic23@cam.ac.uk, jbrenner@taosinc.com, gregkh@suse.de, arnd@arndb.de,
        linux-iio@vger.kernel.org, Bryan Freed <bfreed@chromium.org>
Subject: [PATCH v2 1/3] light sensor: Add SMBUS support to the tsl2563 driver.
Date: Thu, 23 Jun 2011 16:12:28 -0700
Message-Id: <1308870748-20683-1-git-send-email-bfreed@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is so we can support it on x86 SMBUS adapters.

Since i2c adapters which do not provide an smbus_xfer interface fall
back to using their I2C master_xfer interface, all the i2c_master_send()
calls in this driver are changed to i2c_smbus_*() calls.
This will fail on an i2c adapter that implements a proper subset of
(SMBUS_BYTE | SMBUS_BYTE_DATA | SMBUS_WORD_DATA), but I do not see that
in any of our adapters today.

Signed-off-by: Bryan Freed <bfreed@chromium.org>
---
 drivers/staging/iio/light/tsl2563.c |   62 +++++++++++++++++------------------
 1 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/iio/light/tsl2563.c b/drivers/staging/iio/light/tsl2563.c
index 9cffa2e..14fc337 100644
--- a/drivers/staging/iio/light/tsl2563.c
+++ b/drivers/staging/iio/light/tsl2563.c
@@ -139,26 +139,33 @@ struct tsl2563_chip {
 
 static int tsl2563_write(struct i2c_client *client, u8 reg, u8 value)
 {
-	int ret;
-	u8 buf[2];
-
-	buf[0] = TSL2563_CMD | reg;
-	buf[1] = value;
+	return i2c_smbus_write_byte_data(client, TSL2563_CMD | reg, value);
+}
 
-	ret = i2c_master_send(client, buf, sizeof(buf));
-	return (ret == sizeof(buf)) ? 0 : ret;
+static int tsl2563_write_quick(struct i2c_client *client, u8 reg)
+{
+	return i2c_smbus_write_byte(client, TSL2563_CMD | reg);
 }
 
-static int tsl2563_read(struct i2c_client *client, u8 reg, void *buf, int len)
+static int tsl2563_read8(struct i2c_client *client, u8 reg, u8 *buf)
 {
 	int ret;
-	u8 cmd = TSL2563_CMD | reg;
 
-	ret = i2c_master_send(client, &cmd, sizeof(cmd));
-	if (ret != sizeof(cmd))
+	ret = i2c_smbus_read_byte_data(client, TSL2563_CMD | reg);
+	if (ret < 0)
 		return ret;
+	*buf = ret & 0xff;
+	return 0;
+}
+
+static int tsl2563_read16(struct i2c_client *client, u8 reg, u16 *buf)
+{
+	int ret;
 
-	return i2c_master_recv(client, buf, len);
+	ret = i2c_smbus_read_word_data(client, TSL2563_CMD | reg);
+	if (ret < 0)
+		return ret;
+	*buf = ret & 0xffff;
 }
 
 static int tsl2563_set_power(struct tsl2563_chip *chip, int on)
@@ -180,8 +187,8 @@ static int tsl2563_get_power(struct tsl2563_chip *chip)
 	int ret;
 	u8 val;
 
-	ret = tsl2563_read(client, TSL2563_REG_CTRL, &val, sizeof(val));
-	if (ret != sizeof(val))
+	ret = tsl2563_read8(client, TSL2563_REG_CTRL, &val);
+	if (ret)
 		return ret;
 
 	return (val & TSL2563_CTRL_POWER_MASK) == TSL2563_CMD_POWER_ON;
@@ -242,8 +249,8 @@ static int tsl2563_read_id(struct tsl2563_chip *chip, u8 *id)
 	struct i2c_client *client = chip->client;
 	int ret;
 
-	ret = tsl2563_read(client, TSL2563_REG_ID, id, sizeof(*id));
-	if (ret != sizeof(*id))
+	ret = tsl2563_read8(client, TSL2563_REG_ID, id);
+	if (ret)
 		return ret;
 
 	return 0;
@@ -327,7 +334,6 @@ static int tsl2563_adjust_gainlevel(struct tsl2563_chip *chip, u16 adc)
 static int tsl2563_get_adc(struct tsl2563_chip *chip)
 {
 	struct i2c_client *client = chip->client;
-	u8 buf0[2], buf1[2];
 	u16 adc0, adc1;
 	int retry = 1;
 	int ret = 0;
@@ -350,20 +356,14 @@ static int tsl2563_get_adc(struct tsl2563_chip *chip)
 	}
 
 	while (retry) {
-		ret = tsl2563_read(client,
-				   TSL2563_REG_DATA0LOW,
-				   buf0, sizeof(buf0));
-		if (ret != sizeof(buf0))
+		ret = tsl2563_read16(client, TSL2563_REG_DATA0LOW, &adc0);
+		if (ret)
 			goto out;
 
-		ret = tsl2563_read(client, TSL2563_REG_DATA1LOW,
-				   buf1, sizeof(buf1));
-		if (ret != sizeof(buf1))
+		ret = tsl2563_read16(client, TSL2563_REG_DATA1LOW, &adc1);
+		if (ret)
 			goto out;
 
-		adc0 = (buf0[1] << 8) + buf0[0];
-		adc1 = (buf1[1] << 8) + buf1[0];
-
 		retry = tsl2563_adjust_gainlevel(chip, adc0);
 	}
 
@@ -612,7 +612,6 @@ static irqreturn_t tsl2563_event_handler(int irq, void *private)
 {
 	struct iio_dev *dev_info = private;
 	struct tsl2563_chip *chip = iio_priv(dev_info);
-	u8 cmd = TSL2563_CMD | TSL2563_CLEARINT;
 
 	iio_push_event(dev_info, 0,
 		       IIO_UNMOD_EVENT_CODE(IIO_EV_CLASS_LIGHT,
@@ -622,7 +621,7 @@ static irqreturn_t tsl2563_event_handler(int irq, void *private)
 		       iio_get_time_ns());
 
 	/* clear the interrupt and push the event */
-	i2c_master_send(chip->client, &cmd, sizeof(cmd));
+	tsl2563_write_quick(chip->client, TSL2563_CLEARINT);
 	return IRQ_HANDLED;
 }
 
@@ -672,10 +671,9 @@ static int tsl2563_read_interrupt_config(struct iio_dev *indio_dev,
 	int ret;
 
 	mutex_lock(&chip->lock);
-	ret = tsl2563_read(chip->client, TSL2563_REG_INT,
-			   &rxbuf, sizeof(rxbuf));
+	ret = tsl2563_read8(chip->client, TSL2563_REG_INT, &rxbuf);
 	mutex_unlock(&chip->lock);
-	if (ret < 0)
+	if (ret)
 		goto error_ret;
 	ret = !!(rxbuf & 0x30);
 error_ret:
-- 
1.7.3.1

