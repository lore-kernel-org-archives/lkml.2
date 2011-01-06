Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab1AFBAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 20:00:47 -0500
Received: from kroah.org ([198.145.64.141]:35452 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918Ab1AFA3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:05 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:22:58 2011
Message-Id: <20110106002258.746649540@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Gabriele Gorla <gorlik@penguintown.net>,
        Jean Delvare <khali@linux-fr.org>
Subject: [022/152] hwmon: (adm1026) Fix setting fan_div
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Gabriele Gorla <gorlik@penguintown.net>

commit 52bc9802ce849d0d287cc5fe76d06b0daa3986ca upstream.

Prevent setting fan_div from stomping on other fans that share the
same I2C register.

Signed-off-by: Gabriele Gorla <gorlik@penguintown.net>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/adm1026.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/hwmon/adm1026.c
+++ b/drivers/hwmon/adm1026.c
@@ -916,7 +916,7 @@ static ssize_t set_fan_div(struct device
 	int nr = sensor_attr->index;
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adm1026_data *data = i2c_get_clientdata(client);
-	int val, orig_div, new_div, shift;
+	int val, orig_div, new_div;
 
 	val = simple_strtol(buf, NULL, 10);
 	new_div = DIV_TO_REG(val);
@@ -926,15 +926,17 @@ static ssize_t set_fan_div(struct device
 	data->fan_div[nr] = DIV_FROM_REG(new_div);
 
 	if (nr < 4) { /* 0 <= nr < 4 */
-		shift = 2 * nr;
 		adm1026_write_value(client, ADM1026_REG_FAN_DIV_0_3,
-			((DIV_TO_REG(orig_div) & (~(0x03 << shift))) |
-			(new_div << shift)));
+				    (DIV_TO_REG(data->fan_div[0]) << 0) |
+				    (DIV_TO_REG(data->fan_div[1]) << 2) |
+				    (DIV_TO_REG(data->fan_div[2]) << 4) |
+				    (DIV_TO_REG(data->fan_div[3]) << 6));
 	} else { /* 3 < nr < 8 */
-		shift = 2 * (nr - 4);
 		adm1026_write_value(client, ADM1026_REG_FAN_DIV_4_7,
-			((DIV_TO_REG(orig_div) & (~(0x03 << (2 * shift)))) |
-			(new_div << shift)));
+				    (DIV_TO_REG(data->fan_div[4]) << 0) |
+				    (DIV_TO_REG(data->fan_div[5]) << 2) |
+				    (DIV_TO_REG(data->fan_div[6]) << 4) |
+				    (DIV_TO_REG(data->fan_div[7]) << 6));
 	}
 
 	if (data->fan_div[nr] != orig_div) {


