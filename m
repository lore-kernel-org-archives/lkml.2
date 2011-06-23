Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab1FWHRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 03:17:45 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:20264 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754082Ab1FWHRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 03:17:44 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Qi Wang <qi.wang@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH] i2c-eg20t : Fix the issue of Combined R/W transfer mode
Date: Thu, 23 Jun 2011 16:17:10 +0900
Message-Id: <1308813430-2697-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

issue-1
In case combined transfer mode fails halfway, the processing must be stopped halfway.
However currently, the processing is continued.
This patch breaks the processing.

issue-2
Currently, pch_i2c_xfer returns read/write size at that time.
However pch_i2c_xfer must return the number of messages to be read/written.
This patch modifies correctly.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/i2c/busses/i2c-eg20t.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index b2f94dc..4bc272e 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -672,7 +672,7 @@ static s32 pch_i2c_xfer(struct i2c_adapter *i2c_adap,
 	/* transfer not completed */
 	adap->pch_i2c_xfer_in_progress = true;
 
-	for (i = 0; i < num; i++) {
+	for (i = 0; i < num && ret >= 0; i++) {
 		pmsg = &msgs[i];
 		pmsg->flags |= adap->pch_buff_mode_en;
 		status = pmsg->flags;
@@ -698,7 +698,7 @@ static s32 pch_i2c_xfer(struct i2c_adapter *i2c_adap,
 
 	mutex_unlock(&pch_mutex);
 
-	return ret;
+	return (ret < 0) ? ret : num;
 }
 
 /**
-- 
1.7.4.4

