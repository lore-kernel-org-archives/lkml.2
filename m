Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259Ab2FZG6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 02:58:18 -0400
Received: from mail-wi0-f202.google.com ([209.85.212.202]:41729 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535Ab2FZG5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 02:57:21 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org
Cc: Iiro Valkonen <iiro.valkonen@atmel.com>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 20/21 v5] Input: atmel_mxt_ts - send all MT-B slots in one input report
Date: Tue, 26 Jun 2012 14:57:08 +0800
Message-Id: <1340693829-18665-21-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340693829-18665-1-git-send-email-djkurtz@chromium.org>
References: <1340693829-18665-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each interrupt contains information for all contacts with changing
properties.  Process all of this information at once, and send it all in a
a single input report (ie input events ending in EV_SYN/SYN_REPORT).

This patch was tested using an MXT224E.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index b218b5f..f9a9be9 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -546,9 +546,6 @@ static void mxt_input_touchevent(struct mxt_data *data,
 		input_report_abs(input_dev, ABS_MT_PRESSURE, pressure);
 		input_report_abs(input_dev, ABS_MT_TOUCH_MAJOR, area);
 	}
-
-	input_mt_report_pointer_emulation(input_dev, false);
-	input_sync(input_dev);
 }
 
 static irqreturn_t mxt_interrupt(int irq, void *dev_id)
@@ -560,6 +557,7 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 	u8 reportid;
 	u8 max_reportid;
 	u8 min_reportid;
+	bool update_input = false;
 
 	do {
 		if (mxt_read_message(data, &message)) {
@@ -573,12 +571,19 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 		min_reportid = data->T9_reportid_min;
 		id = reportid - min_reportid;
 
-		if (reportid >= min_reportid && reportid <= max_reportid)
+		if (reportid >= min_reportid && reportid <= max_reportid) {
 			mxt_input_touchevent(data, &message, id);
-		else
+			update_input = true;
+		} else {
 			mxt_dump_message(dev, &message);
+		}
 	} while (reportid != 0xff);
 
+	if (update_input) {
+		input_mt_report_pointer_emulation(data->input_dev, false);
+		input_sync(data->input_dev);
+	}
+
 end:
 	return IRQ_HANDLED;
 }
-- 
1.7.7.3

