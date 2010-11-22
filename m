Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab0KVJnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 04:43:16 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39441 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab0KVJnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 04:43:15 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH] backlight: grab ops_lock before testing bd->ops
Date: Mon, 22 Nov 2010 10:43:09 +0100
Message-Id: <1290418989-27653-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the comment describing ops_lock in the definition of
struct backlight_device and when comparing with other functions in
backlight.c the mutex must be hold when checking ops to be non-NULL.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/video/backlight/backlight.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index e207810..0870329 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -197,12 +197,12 @@ static int backlight_suspend(struct device *dev, pm_message_t state)
 {
 	struct backlight_device *bd = to_backlight_device(dev);
 
-	if (bd->ops->options & BL_CORE_SUSPENDRESUME) {
-		mutex_lock(&bd->ops_lock);
+	mutex_lock(&bd->ops_lock);
+	if (bd->ops && bd->ops->options & BL_CORE_SUSPENDRESUME) {
 		bd->props.state |= BL_CORE_SUSPENDED;
 		backlight_update_status(bd);
-		mutex_unlock(&bd->ops_lock);
 	}
+	mutex_unlock(&bd->ops_lock);
 
 	return 0;
 }
@@ -211,12 +211,12 @@ static int backlight_resume(struct device *dev)
 {
 	struct backlight_device *bd = to_backlight_device(dev);
 
-	if (bd->ops->options & BL_CORE_SUSPENDRESUME) {
-		mutex_lock(&bd->ops_lock);
+	mutex_lock(&bd->ops_lock);
+	if (bd->ops && bd->ops->options & BL_CORE_SUSPENDRESUME) {
 		bd->props.state &= ~BL_CORE_SUSPENDED;
 		backlight_update_status(bd);
-		mutex_unlock(&bd->ops_lock);
 	}
+	mutex_unlock(&bd->ops_lock);
 
 	return 0;
 }
-- 
1.7.2.3

