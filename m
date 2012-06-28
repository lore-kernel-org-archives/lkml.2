Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab2F1NIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 09:08:46 -0400
Received: from mail-gg0-f202.google.com ([209.85.161.202]:61500 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122Ab2F1NIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 09:08:41 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, Yufeng Shen <miletus@chromium.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 20/23 v6] Input: atmel_mxt_ts - refactor reportid checking in mxt_interrupt
Date: Thu, 28 Jun 2012 21:08:21 +0800
Message-Id: <1340888904-15620-21-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340888904-15620-1-git-send-email-djkurtz@chromium.org>
References: <1340888904-15620-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small refactor is in preparation for checking more report types
in the mxt_interrupt message processing loop.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 48f3637..a9e0b54 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -554,6 +554,12 @@ static void mxt_input_touchevent(struct mxt_data *data,
 	input_sync(input_dev);
 }
 
+static bool mxt_is_T9_message(struct mxt_data *data, struct mxt_message *msg)
+{
+	u8 id = msg->reportid;
+	return (id >= data->T9_reportid_min && id <= data->T9_reportid_max);
+}
+
 static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 {
 	struct mxt_data *data = dev_id;
@@ -561,8 +567,6 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 	struct device *dev = &data->client->dev;
 	int id;
 	u8 reportid;
-	u8 max_reportid;
-	u8 min_reportid;
 
 	do {
 		if (mxt_read_message(data, &message)) {
@@ -572,11 +576,9 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 
 		reportid = message.reportid;
 
-		max_reportid = data->T9_reportid_max;
-		min_reportid = data->T9_reportid_min;
-		id = reportid - min_reportid;
+		id = reportid - data->T9_reportid_min;
 
-		if (reportid >= min_reportid && reportid <= max_reportid)
+		if (mxt_is_T9_message(data, &message))
 			mxt_input_touchevent(data, &message, id);
 		else
 			mxt_dump_message(dev, &message);
-- 
1.7.7.3

