Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab1FUWzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 18:55:13 -0400
Received: from smtp-out.google.com ([74.125.121.67]:12293 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab1FUWzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 18:55:11 -0400
From: Bryan Freed <bfreed@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: jic23@cam.ac.uk, jbrenner@taosinc.com, gregkh@suse.de, arnd@arndb.de,
        Bryan Freed <bfreed@chromium.org>
Subject: [PATCH 1/3] light sensor: Add SMBUS support to the tsl2563 driver.
Date: Tue, 21 Jun 2011 15:54:55 -0700
Message-Id: <1308696897-25161-1-git-send-email-bfreed@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is so we can support it on x86 SMBUS adapters.

Signed-off-by: Bryan Freed <bfreed@chromium.org>
---
 drivers/staging/iio/light/tsl2563.c |   29 ++++++++++++++++++++++++++++-
 1 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/iio/light/tsl2563.c b/drivers/staging/iio/light/tsl2563.c
index 9cffa2e..04aa155 100644
--- a/drivers/staging/iio/light/tsl2563.c
+++ b/drivers/staging/iio/light/tsl2563.c
@@ -137,6 +137,8 @@ struct tsl2563_chip {
 	u32			data1;
 };
 
+static int use_smbus;
+
 static int tsl2563_write(struct i2c_client *client, u8 reg, u8 value)
 {
 	int ret;
@@ -145,15 +147,35 @@ static int tsl2563_write(struct i2c_client *client, u8 reg, u8 value)
 	buf[0] = TSL2563_CMD | reg;
 	buf[1] = value;
 
+	if (use_smbus) {
+		ret = i2c_smbus_write_byte_data(client, buf[0], value);
+		return ret;
+	}
+
 	ret = i2c_master_send(client, buf, sizeof(buf));
 	return (ret == sizeof(buf)) ? 0 : ret;
 }
 
-static int tsl2563_read(struct i2c_client *client, u8 reg, void *buf, int len)
+static int tsl2563_read(struct i2c_client *client, u8 reg, u8 *buf, int len)
 {
 	int ret;
 	u8 cmd = TSL2563_CMD | reg;
 
+	if (use_smbus) {
+		if (len == 1) {
+			ret = i2c_smbus_read_byte_data(client, cmd);
+			buf[0] = ret & 0xff;
+		} else if (len == 2) {
+			ret = i2c_smbus_read_word_data(client, cmd);
+			buf[0] = ret & 0xff;
+			buf[1] = (ret >> 8) & 0xff;
+		} else
+			ret = -1;
+		if (ret < 0)
+			return 0; /* failure */
+		return len; /* success */
+	}
+
 	ret = i2c_master_send(client, &cmd, sizeof(cmd));
 	if (ret != sizeof(cmd))
 		return ret;
@@ -712,6 +734,11 @@ static int __devinit tsl2563_probe(struct i2c_client *client,
 	int err = 0;
 	int ret;
 	u8 id;
+	u32 smbus_func = I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA;
+
+	/* We support both I2C and SMBUS adapter interfaces. */
+	if (i2c_check_functionality(client->adapter, smbus_func))
+		use_smbus = 1;
 
 	indio_dev = iio_allocate_device(sizeof(*chip));
 	if (!indio_dev)
-- 
1.7.3.1

