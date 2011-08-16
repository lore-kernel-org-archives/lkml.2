Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab1HPHUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 03:20:50 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:61006 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab1HPHUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 03:20:48 -0400
Date: Tue, 16 Aug 2011 00:20:41 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Yufeng Shen <miletus@chromium.org>, linux-input@vger.kernel.org,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>, linux-kernel@vger.kernel.org,
        Michael Gong <Michael.Gong@atmel.com>,
        Alan Bowens <Alan.Bowens@atmel.com>
Subject: Re: [PATCH v3] Input: atmel_mxt_ts - Report pressure information
 from the driver
Message-ID: <20110816072041.GA20084@core.coreip.homeip.net>
References: <1313420550-5885-1-git-send-email-miletus@chromium.org>
 <20110816052738.GA25878@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110816052738.GA25878@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 07:27:38AM +0200, Henrik Rydberg wrote:
> On Mon, Aug 15, 2011 at 11:02:30AM -0400, Yufeng Shen wrote:
> > Atmel mxt1386 touch controller has the touch pressure information but
> > the current driver atmel_mxt_ts does not expose it to the user space.
> > This patch makes the driver report the touch pressure information to
> > user space.
> > 
> > ChangeLog:
> > v2: fixed indentation as commented by Wanlong Gao
> > v3: added signed-off-by
> > 

I think we should be reporting pressure for ST emulation as well. Does
the following version still work for you?

Thanks.

-- 
Dmitry

Input: atmel_mxt_ts - report pressure information from the driver

From: Yufeng Shen <miletus@chromium.org>

Atmel mxt1386 touch controller has the touch pressure information so
let's report it to the user space.

[dtor@mail.ru: added ABS_RESSURE reporting for ST emulation.]

Signed-off-by: Yufeng Shen <miletus@chromium.org>
Acked-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Acked-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/touchscreen/atmel_mxt_ts.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)


diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index c4f6b81..5bc2065 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -245,6 +245,7 @@ struct mxt_finger {
 	int x;
 	int y;
 	int area;
+	int pressure;
 };
 
 /* Each client has this additional data */
@@ -537,6 +538,8 @@ static void mxt_input_report(struct mxt_data *data, int single_id)
 					finger[id].x);
 			input_report_abs(input_dev, ABS_MT_POSITION_Y,
 					finger[id].y);
+			input_report_abs(input_dev, ABS_MT_PRESSURE,
+					finger[id].pressure);
 		} else {
 			finger[id].status = 0;
 		}
@@ -547,6 +550,8 @@ static void mxt_input_report(struct mxt_data *data, int single_id)
 	if (status != MXT_RELEASE) {
 		input_report_abs(input_dev, ABS_X, finger[single_id].x);
 		input_report_abs(input_dev, ABS_Y, finger[single_id].y);
+		input_report_abs(input_dev,
+				 ABS_PRESSURE, finger[single_id].pressure);
 	}
 
 	input_sync(input_dev);
@@ -561,6 +566,7 @@ static void mxt_input_touchevent(struct mxt_data *data,
 	int x;
 	int y;
 	int area;
+	int pressure;
 
 	/* Check the touch is present on the screen */
 	if (!(status & MXT_DETECT)) {
@@ -585,6 +591,7 @@ static void mxt_input_touchevent(struct mxt_data *data,
 		y = y >> 2;
 
 	area = message->message[4];
+	pressure = message->message[5];
 
 	dev_dbg(dev, "[%d] %s x: %d, y: %d, area: %d\n", id,
 		status & MXT_MOVE ? "moved" : "pressed",
@@ -595,6 +602,7 @@ static void mxt_input_touchevent(struct mxt_data *data,
 	finger[id].x = x;
 	finger[id].y = y;
 	finger[id].area = area;
+	finger[id].pressure = pressure;
 
 	mxt_input_report(data, id);
 }
@@ -1130,6 +1138,8 @@ static int __devinit mxt_probe(struct i2c_client *client,
 			     0, data->max_x, 0, 0);
 	input_set_abs_params(input_dev, ABS_Y,
 			     0, data->max_y, 0, 0);
+	input_set_abs_params(input_dev, ABS_PRESSURE,
+			     0, 255, 0, 0);
 
 	/* For multi touch */
 	input_mt_init_slots(input_dev, MXT_MAX_FINGER);
@@ -1139,6 +1149,8 @@ static int __devinit mxt_probe(struct i2c_client *client,
 			     0, data->max_x, 0, 0);
 	input_set_abs_params(input_dev, ABS_MT_POSITION_Y,
 			     0, data->max_y, 0, 0);
+	input_set_abs_params(input_dev, ABS_MT_PRESSURE,
+			     0, 255, 0, 0);
 
 	input_set_drvdata(input_dev, data);
 	i2c_set_clientdata(client, data);
