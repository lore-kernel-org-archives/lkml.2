Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab1BBBKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:10:09 -0500
Received: from mga14.intel.com ([143.182.124.37]:16719 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab1BBAnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960367"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: gorlik@penguintown.net, khali@linux-fr.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [17/139] hwmon: (adm1026) Fix setting fan_div
Message-Id: <20110202004331.999AF3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Gabriele Gorla <gorlik@penguintown.net>

commit 52bc9802ce849d0d287cc5fe76d06b0daa3986ca upstream.

Prevent setting fan_div from stomping on other fans that share the
same I2C register.

Signed-off-by: Gabriele Gorla <gorlik@penguintown.net>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/hwmon/adm1026.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

Index: linux-2.6.35.y/drivers/hwmon/adm1026.c
===================================================================
--- linux-2.6.35.y.orig/drivers/hwmon/adm1026.c
+++ linux-2.6.35.y/drivers/hwmon/adm1026.c
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
