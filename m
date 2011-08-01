Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab1HAX0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:26:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38379 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890Ab1HAXZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:25:39 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:51 2011
Message-Id: <20110801232051.470488160@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [09/70] hwmon: (lm95241) Fix negative temperature results
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Guenter Roeck <guenter.roeck@ericsson.com>

commit 0c2a40e2fe4f4af0410f57e84b95b817ec15aa70 upstream.

Negative temperatures were returned in degrees C instead of milli-Degrees C.
Also, negative temperatures were reported for remote temperature sensors even
if the chip was configured for positive-only results.

Fix by detecting temperature modes, and by treating negative temperatures
similar to positive temperatures, with appropriate sign extension.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/lm95241.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/hwmon/lm95241.c
+++ b/drivers/hwmon/lm95241.c
@@ -98,11 +98,16 @@ struct lm95241_data {
 };
 
 /* Conversions */
-static int TempFromReg(u8 val_h, u8 val_l)
+static int temp_from_reg_signed(u8 val_h, u8 val_l)
 {
-	if (val_h & 0x80)
-		return val_h - 0x100;
-	return val_h * 1000 + val_l * 1000 / 256;
+	s16 val_hl = (val_h << 8) | val_l;
+	return val_hl * 1000 / 256;
+}
+
+static int temp_from_reg_unsigned(u8 val_h, u8 val_l)
+{
+	u16 val_hl = (val_h << 8) | val_l;
+	return val_hl * 1000 / 256;
 }
 
 static struct lm95241_data *lm95241_update_device(struct device *dev)
@@ -135,10 +140,13 @@ static ssize_t show_input(struct device
 			  char *buf)
 {
 	struct lm95241_data *data = lm95241_update_device(dev);
+	int index = to_sensor_dev_attr(attr)->index;
 
 	return snprintf(buf, PAGE_SIZE - 1, "%d\n",
-		TempFromReg(data->temp[to_sensor_dev_attr(attr)->index],
-			    data->temp[to_sensor_dev_attr(attr)->index + 1]));
+			index == 0 || (data->config & (1 << (index / 2))) ?
+		temp_from_reg_signed(data->temp[index], data->temp[index + 1]) :
+		temp_from_reg_unsigned(data->temp[index],
+				       data->temp[index + 1]));
 }
 
 static ssize_t show_type(struct device *dev, struct device_attribute *attr,


