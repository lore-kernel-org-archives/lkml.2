Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab2FREPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 00:15:06 -0400
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:33174 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750903Ab2FREPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 00:15:03 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org
Cc: Iiro Valkonen <iiro.valkonen@atmel.com>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 20/22 v4] Input: atmel_mxt_ts - use T9 reportid range to init number of mt slots
Date: Mon, 18 Jun 2012 12:08:40 +0800
Message-Id: <1339992522-22073-21-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1339992522-22073-1-git-send-email-djkurtz@chromium.org>
References: <1339992522-22073-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atmel mxt devices can report one finger for each T9 reportid.
Therefore, this range can be used to report the max number of MT-B slots
to userspace instead of assuming a fixed 10.

Note that mxt_initialized() must complete early, since the input_dev
properties now depend on values in the object table.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index f5ca237..460c10f 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -212,8 +212,6 @@
 /* Touchscreen absolute values */
 #define MXT_MAX_AREA		0xff
 
-#define MXT_MAX_FINGER		10
-
 struct mxt_info {
 	u8 family_id;
 	u8 variant_id;
@@ -1056,6 +1054,7 @@ static int __devinit mxt_probe(struct i2c_client *client,
 	struct mxt_data *data;
 	struct input_dev *input_dev;
 	int error;
+	unsigned int num_mt_slots;
 
 	if (!pdata)
 		return -EINVAL;
@@ -1082,6 +1081,10 @@ static int __devinit mxt_probe(struct i2c_client *client,
 
 	mxt_calc_resolution(data);
 
+	error = mxt_initialize(data);
+	if (error)
+		goto err_free_object;
+
 	__set_bit(EV_ABS, input_dev->evbit);
 	__set_bit(EV_KEY, input_dev->evbit);
 	__set_bit(BTN_TOUCH, input_dev->keybit);
@@ -1095,9 +1098,10 @@ static int __devinit mxt_probe(struct i2c_client *client,
 			     0, 255, 0, 0);
 
 	/* For multi touch */
-	error = input_mt_init_slots(input_dev, MXT_MAX_FINGER);
+	num_mt_slots = data->T9_reportid_max - data->T9_reportid_min + 1;
+	error = input_mt_init_slots(input_dev, num_mt_slots);
 	if (error)
-		goto err_free_mem;
+		goto err_free_object;
 	input_set_abs_params(input_dev, ABS_MT_TOUCH_MAJOR,
 			     0, MXT_MAX_AREA, 0, 0);
 	input_set_abs_params(input_dev, ABS_MT_POSITION_X,
@@ -1110,10 +1114,6 @@ static int __devinit mxt_probe(struct i2c_client *client,
 	input_set_drvdata(input_dev, data);
 	i2c_set_clientdata(client, data);
 
-	error = mxt_initialize(data);
-	if (error)
-		goto err_free_object;
-
 	error = request_threaded_irq(client->irq, NULL, mxt_interrupt,
 			pdata->irqflags, client->name, data);
 	if (error) {
-- 
1.7.7.3

