Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab1HOPDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:03:04 -0400
Received: from smtp-out.google.com ([216.239.44.51]:58444 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952Ab1HOPDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:03:00 -0400
From: Yufeng Shen <miletus@chromium.org>
To: linux-input@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Yufeng Shen <miletus@chromium.org>, linux-kernel@vger.kernel.org,
        Michael Gong <Michael.Gong@atmel.com>,
        Alan Bowens <Alan.Bowens@atmel.com>
Subject: [PATCH v3] Input: atmel_mxt_ts - Report pressure information from the driver
Date: Mon, 15 Aug 2011 11:02:30 -0400
Message-Id: <1313420550-5885-1-git-send-email-miletus@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atmel mxt1386 touch controller has the touch pressure information but
the current driver atmel_mxt_ts does not expose it to the user space.
This patch makes the driver report the touch pressure information to
user space.

ChangeLog:
v2: fixed indentation as commented by Wanlong Gao
v3: added signed-off-by

Change-Id: Ie0e4683a3cd5ec79222f7682b0ddc24f909af543
Signed-off-by: Yufeng Shen <miletus@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index ae00604..9bdf4e0 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -244,6 +244,7 @@ struct mxt_finger {
 	int x;
 	int y;
 	int area;
+	int pressure;
 };
 
 /* Each client has this additional data */
@@ -536,6 +537,8 @@ static void mxt_input_report(struct mxt_data *data, int single_id)
 					finger[id].x);
 			input_report_abs(input_dev, ABS_MT_POSITION_Y,
 					finger[id].y);
+			input_report_abs(input_dev, ABS_MT_PRESSURE,
+					finger[id].pressure);
 		} else {
 			finger[id].status = 0;
 		}
@@ -560,6 +563,7 @@ static void mxt_input_touchevent(struct mxt_data *data,
 	int x;
 	int y;
 	int area;
+	int pressure;
 
 	/* Check the touch is present on the screen */
 	if (!(status & MXT_DETECT)) {
@@ -584,6 +588,7 @@ static void mxt_input_touchevent(struct mxt_data *data,
 		y = y >> 2;
 
 	area = message->message[4];
+	pressure = message->message[5];
 
 	dev_dbg(dev, "[%d] %s x: %d, y: %d, area: %d\n", id,
 		status & MXT_MOVE ? "moved" : "pressed",
@@ -594,6 +599,7 @@ static void mxt_input_touchevent(struct mxt_data *data,
 	finger[id].x = x;
 	finger[id].y = y;
 	finger[id].area = area;
+	finger[id].pressure = pressure;
 
 	mxt_input_report(data, id);
 }
@@ -1125,6 +1131,8 @@ static int __devinit mxt_probe(struct i2c_client *client,
 			     0, data->max_x, 0, 0);
 	input_set_abs_params(input_dev, ABS_MT_POSITION_Y,
 			     0, data->max_y, 0, 0);
+	input_set_abs_params(input_dev, ABS_MT_PRESSURE,
+			     0, 255, 0, 0);
 
 	input_set_drvdata(input_dev, data);
 	i2c_set_clientdata(client, data);
-- 
1.7.3.1

