Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031671Ab2I1Tr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:47:58 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47421 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965126Ab2I1S6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:58:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>
Subject: [ 099/262] hwmon: (ina2xx) Fix word size register read and write operations
Date: Fri, 28 Sep 2012 11:50:28 -0700
Message-Id: <20120928183009.744543109@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 080b98e9ab30734bda2f1b8b33cd55a4c4ef406a upstream.

The driver uses be16_to_cpu and cpu_to_be16 to convert data in SMBus word
operations from chip to host byte order. However, the data passed from and to
the SMBus word API functions is in host byte order, not in chip byte order.
Conversion should therefore use swab16 instead of be16 to change the byte order.

Replace driver internal word conversion functions with SMBus API functions to
solve the problem.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/ina2xx.c |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -69,22 +69,6 @@ struct ina2xx_data {
 	u16 regs[INA2XX_MAX_REGISTERS];
 };
 
-int ina2xx_read_word(struct i2c_client *client, int reg)
-{
-	int val = i2c_smbus_read_word_data(client, reg);
-	if (unlikely(val < 0)) {
-		dev_dbg(&client->dev,
-			"Failed to read register: %d\n", reg);
-		return val;
-	}
-	return be16_to_cpu(val);
-}
-
-void ina2xx_write_word(struct i2c_client *client, int reg, int data)
-{
-	i2c_smbus_write_word_data(client, reg, cpu_to_be16(data));
-}
-
 static struct ina2xx_data *ina2xx_update_device(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
@@ -102,7 +86,7 @@ static struct ina2xx_data *ina2xx_update
 
 		/* Read all registers */
 		for (i = 0; i < data->registers; i++) {
-			int rv = ina2xx_read_word(client, i);
+			int rv = i2c_smbus_read_word_swapped(client, i);
 			if (rv < 0) {
 				ret = ERR_PTR(rv);
 				goto abort;
@@ -279,22 +263,26 @@ static int ina2xx_probe(struct i2c_clien
 	switch (data->kind) {
 	case ina219:
 		/* device configuration */
-		ina2xx_write_word(client, INA2XX_CONFIG, INA219_CONFIG_DEFAULT);
+		i2c_smbus_write_word_swapped(client, INA2XX_CONFIG,
+					     INA219_CONFIG_DEFAULT);
 
 		/* set current LSB to 1mA, shunt is in uOhms */
 		/* (equation 13 in datasheet) */
-		ina2xx_write_word(client, INA2XX_CALIBRATION, 40960000 / shunt);
+		i2c_smbus_write_word_swapped(client, INA2XX_CALIBRATION,
+					     40960000 / shunt);
 		dev_info(&client->dev,
 			 "power monitor INA219 (Rshunt = %li uOhm)\n", shunt);
 		data->registers = INA219_REGISTERS;
 		break;
 	case ina226:
 		/* device configuration */
-		ina2xx_write_word(client, INA2XX_CONFIG, INA226_CONFIG_DEFAULT);
+		i2c_smbus_write_word_swapped(client, INA2XX_CONFIG,
+					     INA226_CONFIG_DEFAULT);
 
 		/* set current LSB to 1mA, shunt is in uOhms */
 		/* (equation 1 in datasheet)*/
-		ina2xx_write_word(client, INA2XX_CALIBRATION, 5120000 / shunt);
+		i2c_smbus_write_word_swapped(client, INA2XX_CALIBRATION,
+					     5120000 / shunt);
 		dev_info(&client->dev,
 			 "power monitor INA226 (Rshunt = %li uOhm)\n", shunt);
 		data->registers = INA226_REGISTERS;


