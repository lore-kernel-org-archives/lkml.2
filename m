Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965155Ab2B1BLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:11:51 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50501 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965074Ab2B1BLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:11:49 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.194.200 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010433.903015153@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:05:20 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris D Schimp <silverchris@gmail.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Roland Stigge <stigge@antcom.de>
Subject: [ 51/72] hwmon: (max6639) Fix PPR register initialization to set both channels
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris D Schimp <silverchris@gmail.com>

commit 2f2da1ac0ba5b6cc6e1957c4da5ff20e67d8442b upstream.

Initialize PPR register for both channels, and set correct PPR register bits.
Also remove unnecessary variable initializations.

Signed-off-by: Chris D Schimp <silverchris@gmail.com>
[guenter.roeck@ericsson.com: Merged two patches into one]
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Acked-by: Roland Stigge <stigge@antcom.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/max6639.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/hwmon/max6639.c
+++ b/drivers/hwmon/max6639.c
@@ -429,9 +429,9 @@ static int max6639_init_client(struct i2
 	struct max6639_data *data = i2c_get_clientdata(client);
 	struct max6639_platform_data *max6639_info =
 		client->dev.platform_data;
-	int i = 0;
+	int i;
 	int rpm_range = 1; /* default: 4000 RPM */
-	int err = 0;
+	int err;
 
 	/* Reset chip to default values, see below for GCONFIG setup */
 	err = i2c_smbus_write_byte_data(client, MAX6639_REG_GCONFIG,
@@ -446,11 +446,6 @@ static int max6639_init_client(struct i2
 	else
 		data->ppr = 2;
 	data->ppr -= 1;
-	err = i2c_smbus_write_byte_data(client,
-			MAX6639_REG_FAN_PPR(i),
-			data->ppr << 5);
-	if (err)
-		goto exit;
 
 	if (max6639_info)
 		rpm_range = rpm_range_to_reg(max6639_info->rpm_range);
@@ -458,6 +453,13 @@ static int max6639_init_client(struct i2
 
 	for (i = 0; i < 2; i++) {
 
+		/* Set Fan pulse per revolution */
+		err = i2c_smbus_write_byte_data(client,
+				MAX6639_REG_FAN_PPR(i),
+				data->ppr << 6);
+		if (err)
+			goto exit;
+
 		/* Fans config PWM, RPM */
 		err = i2c_smbus_write_byte_data(client,
 			MAX6639_REG_FAN_CONFIG1(i),


