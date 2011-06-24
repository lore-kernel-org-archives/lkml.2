Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab1FXUlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 16:41:21 -0400
Received: from smtp-out.google.com ([74.125.121.67]:61073 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab1FXUlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 16:41:17 -0400
From: Bryan Freed <bfreed@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: jic23@cam.ac.uk, jbrenner@taosinc.com, gregkh@suse.de, arnd@arndb.de,
        linux-iio@vger.kernel.org, Bryan Freed <bfreed@chromium.org>
Subject: [PATCH v3 1/3] light sensor: Add SMBUS support to the tsl2563 driver.
Date: Fri, 24 Jun 2011 13:40:47 -0700
Message-Id: <1308948047-20488-1-git-send-email-bfreed@chromium.org>
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

This results in a few wrapper functions that provide little additional
functionality, so remove them and call the smbus functions directly from
the general driver code.

Signed-off-by: Bryan Freed <bfreed@chromium.org>
---
 drivers/staging/iio/light/tsl2563.c |  106 +++++++++++++++--------------------
 1 files changed, 45 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/iio/light/tsl2563.c b/drivers/staging/iio/light/tsl2563.c
index 9cffa2e..c60656f 100644
--- a/drivers/staging/iio/light/tsl2563.c
+++ b/drivers/staging/iio/light/tsl2563.c
@@ -137,37 +137,14 @@ struct tsl2563_chip {
 	u32			data1;
 };
 
-static int tsl2563_write(struct i2c_client *client, u8 reg, u8 value)
-{
-	int ret;
-	u8 buf[2];
-
-	buf[0] = TSL2563_CMD | reg;
-	buf[1] = value;
-
-	ret = i2c_master_send(client, buf, sizeof(buf));
-	return (ret == sizeof(buf)) ? 0 : ret;
-}
-
-static int tsl2563_read(struct i2c_client *client, u8 reg, void *buf, int len)
-{
-	int ret;
-	u8 cmd = TSL2563_CMD | reg;
-
-	ret = i2c_master_send(client, &cmd, sizeof(cmd));
-	if (ret != sizeof(cmd))
-		return ret;
-
-	return i2c_master_recv(client, buf, len);
-}
-
 static int tsl2563_set_power(struct tsl2563_chip *chip, int on)
 {
 	struct i2c_client *client = chip->client;
 	u8 cmd;
 
 	cmd = on ? TSL2563_CMD_POWER_ON : TSL2563_CMD_POWER_OFF;
-	return tsl2563_write(client, TSL2563_REG_CTRL, cmd);
+	return i2c_smbus_write_byte_data(client,
+					 TSL2563_CMD | TSL2563_REG_CTRL, cmd);
 }
 
 /*
@@ -178,36 +155,40 @@ static int tsl2563_get_power(struct tsl2563_chip *chip)
 {
 	struct i2c_client *client = chip->client;
 	int ret;
-	u8 val;
 
-	ret = tsl2563_read(client, TSL2563_REG_CTRL, &val, sizeof(val));
-	if (ret != sizeof(val))
+	ret = i2c_smbus_read_byte_data(client, TSL2563_CMD | TSL2563_REG_CTRL);
+	if (ret < 0)
 		return ret;
 
-	return (val & TSL2563_CTRL_POWER_MASK) == TSL2563_CMD_POWER_ON;
+	return (ret & TSL2563_CTRL_POWER_MASK) == TSL2563_CMD_POWER_ON;
 }
 
 static int tsl2563_configure(struct tsl2563_chip *chip)
 {
 	int ret;
 
-	ret = tsl2563_write(chip->client, TSL2563_REG_TIMING,
+	ret = i2c_smbus_write_byte_data(chip->client,
+			TSL2563_CMD | TSL2563_REG_TIMING,
 			chip->gainlevel->gaintime);
 	if (ret)
 		goto error_ret;
-	ret = tsl2563_write(chip->client, TSL2563_REG_HIGHLOW,
+	ret = i2c_smbus_write_byte_data(chip->client,
+			TSL2563_CMD | TSL2563_REG_HIGHLOW,
 			chip->high_thres & 0xFF);
 	if (ret)
 		goto error_ret;
-	ret = tsl2563_write(chip->client, TSL2563_REG_HIGHHIGH,
+	ret = i2c_smbus_write_byte_data(chip->client,
+			TSL2563_CMD | TSL2563_REG_HIGHHIGH,
 			(chip->high_thres >> 8) & 0xFF);
 	if (ret)
 		goto error_ret;
-	ret = tsl2563_write(chip->client, TSL2563_REG_LOWLOW,
+	ret = i2c_smbus_write_byte_data(chip->client,
+			TSL2563_CMD | TSL2563_REG_LOWLOW,
 			chip->low_thres & 0xFF);
 	if (ret)
 		goto error_ret;
-	ret = tsl2563_write(chip->client, TSL2563_REG_LOWHIGH,
+	ret = i2c_smbus_write_byte_data(chip->client,
+			TSL2563_CMD | TSL2563_REG_LOWHIGH,
 			(chip->low_thres >> 8) & 0xFF);
 /* Interrupt register is automatically written anyway if it is relevant
    so is not here */
@@ -242,8 +223,8 @@ static int tsl2563_read_id(struct tsl2563_chip *chip, u8 *id)
 	struct i2c_client *client = chip->client;
 	int ret;
 
-	ret = tsl2563_read(client, TSL2563_REG_ID, id, sizeof(*id));
-	if (ret != sizeof(*id))
+	ret = i2c_smbus_read_byte_data(client, TSL2563_CMD | TSL2563_REG_ID);
+	if (ret < 0)
 		return ret;
 
 	return 0;
@@ -313,8 +294,9 @@ static int tsl2563_adjust_gainlevel(struct tsl2563_chip *chip, u16 adc)
 		(adc > chip->gainlevel->max) ?
 			chip->gainlevel++ : chip->gainlevel--;
 
-		tsl2563_write(client, TSL2563_REG_TIMING,
-			      chip->gainlevel->gaintime);
+		i2c_smbus_write_byte_data(client,
+					  TSL2563_CMD | TSL2563_REG_TIMING,
+					  chip->gainlevel->gaintime);
 
 		tsl2563_wait_adc(chip);
 		tsl2563_wait_adc(chip);
@@ -327,7 +309,6 @@ static int tsl2563_adjust_gainlevel(struct tsl2563_chip *chip, u16 adc)
 static int tsl2563_get_adc(struct tsl2563_chip *chip)
 {
 	struct i2c_client *client = chip->client;
-	u8 buf0[2], buf1[2];
 	u16 adc0, adc1;
 	int retry = 1;
 	int ret = 0;
@@ -350,19 +331,17 @@ static int tsl2563_get_adc(struct tsl2563_chip *chip)
 	}
 
 	while (retry) {
-		ret = tsl2563_read(client,
-				   TSL2563_REG_DATA0LOW,
-				   buf0, sizeof(buf0));
-		if (ret != sizeof(buf0))
+		ret = i2c_smbus_read_word_data(client,
+				TSL2563_CMD | TSL2563_REG_DATA0LOW);
+		if (ret < 0)
 			goto out;
+		adc0 = ret;
 
-		ret = tsl2563_read(client, TSL2563_REG_DATA1LOW,
-				   buf1, sizeof(buf1));
-		if (ret != sizeof(buf1))
+		ret = i2c_smbus_read_word_data(client,
+				TSL2563_CMD | TSL2563_REG_DATA1LOW);
+		if (ret < 0)
 			goto out;
-
-		adc0 = (buf0[1] << 8) + buf0[0];
-		adc1 = (buf1[1] << 8) + buf1[0];
+		adc1 = ret;
 
 		retry = tsl2563_adjust_gainlevel(chip, adc0);
 	}
@@ -592,11 +571,13 @@ static ssize_t tsl2563_write_thresh(struct iio_dev *indio_dev,
 	else
 		address = TSL2563_REG_LOWLOW;
 	mutex_lock(&chip->lock);
-	ret = tsl2563_write(chip->client, address, val & 0xFF);
+	ret = i2c_smbus_write_byte_data(chip->client, TSL2563_CMD | address,
+					val & 0xFF);
 	if (ret)
 		goto error_ret;
-	ret = tsl2563_write(chip->client, address + 1,
-			(val >> 8) & 0xFF);
+	ret = i2c_smbus_write_byte_data(chip->client,
+					TSL2563_CMD | (address + 1),
+					(val >> 8) & 0xFF);
 	if (IIO_EVENT_CODE_EXTRACT_DIR(event_code) == IIO_EV_DIR_RISING)
 		chip->high_thres = val;
 	else
@@ -612,7 +593,6 @@ static irqreturn_t tsl2563_event_handler(int irq, void *private)
 {
 	struct iio_dev *dev_info = private;
 	struct tsl2563_chip *chip = iio_priv(dev_info);
-	u8 cmd = TSL2563_CMD | TSL2563_CLEARINT;
 
 	iio_push_event(dev_info, 0,
 		       IIO_UNMOD_EVENT_CODE(IIO_EV_CLASS_LIGHT,
@@ -622,7 +602,7 @@ static irqreturn_t tsl2563_event_handler(int irq, void *private)
 		       iio_get_time_ns());
 
 	/* clear the interrupt and push the event */
-	i2c_master_send(chip->client, &cmd, sizeof(cmd));
+	i2c_smbus_write_byte(chip->client, TSL2563_CMD | TSL2563_CLEARINT);
 	return IRQ_HANDLED;
 }
 
@@ -647,13 +627,17 @@ static int tsl2563_write_interrupt_config(struct iio_dev *indio_dev,
 			if (ret)
 				goto out;
 		}
-		ret = tsl2563_write(chip->client, TSL2563_REG_INT, chip->intr);
+		ret = i2c_smbus_write_byte_data(chip->client,
+						TSL2563_CMD | TSL2563_REG_INT,
+						chip->intr);
 		chip->int_enabled = true;
 	}
 
 	if (!state && (chip->intr & 0x30)) {
 		chip->intr |= ~0x30;
-		ret = tsl2563_write(chip->client, TSL2563_REG_INT, chip->intr);
+		ret = i2c_smbus_write_byte_data(chip->client,
+						TSL2563_CMD | TSL2563_REG_INT,
+						chip->intr);
 		chip->int_enabled = false;
 		/* now the interrupt is not enabled, we can go to sleep */
 		schedule_delayed_work(&chip->poweroff_work, 5 * HZ);
@@ -668,16 +652,15 @@ static int tsl2563_read_interrupt_config(struct iio_dev *indio_dev,
 					   int event_code)
 {
 	struct tsl2563_chip *chip = iio_priv(indio_dev);
-	u8 rxbuf;
 	int ret;
 
 	mutex_lock(&chip->lock);
-	ret = tsl2563_read(chip->client, TSL2563_REG_INT,
-			   &rxbuf, sizeof(rxbuf));
+	ret = i2c_smbus_read_byte_data(chip->client,
+				       TSL2563_CMD | TSL2563_REG_INT);
 	mutex_unlock(&chip->lock);
 	if (ret < 0)
 		goto error_ret;
-	ret = !!(rxbuf & 0x30);
+	ret = !!(ret & 0x30);
 error_ret:
 
 	return ret;
@@ -797,7 +780,8 @@ static int tsl2563_remove(struct i2c_client *client)
 		cancel_delayed_work(&chip->poweroff_work);
 	/* Ensure that interrupts are disabled - then flush any bottom halves */
 	chip->intr |= ~0x30;
-	tsl2563_write(chip->client, TSL2563_REG_INT, chip->intr);
+	i2c_smbus_write_byte_data(chip->client, TSL2563_CMD | TSL2563_REG_INT,
+				  chip->intr);
 	flush_scheduled_work();
 	tsl2563_set_power(chip, 0);
 	if (client->irq)
-- 
1.7.3.1

