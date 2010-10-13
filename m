Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab0JMNpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 09:45:40 -0400
Received: from smtp.nokia.com ([192.100.105.134]:35751 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab0JMNph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 09:45:37 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: khali@linux-fr.org, tony@atomide.com
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] drivers: i2c-omap: Add support for shorten I2C timeout
Date: Wed, 13 Oct 2010 16:45:10 +0300
Message-Id: <1286977510-16702-3-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1286977510-16702-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1286977510-16702-1-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 13 Oct 2010 13:45:18.0258 (UTC) FILETIME=[DF574920:01CB6ADC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use short I2C timeout if requested by i2c-message flag.
This is for cases where the it is known that target chip causes timeout.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/i2c/busses/i2c-omap.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index b33c785..d7ed7ca 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -50,6 +50,7 @@
 
 /* timeout waiting for the controller to respond */
 #define OMAP_I2C_TIMEOUT (msecs_to_jiffies(1000))
+#define OMAP_I2C_SHORT_TIMEOUT (msecs_to_jiffies(50))
 
 /* For OMAP3 I2C_IV has changed to I2C_WE (wakeup enable) */
 enum {
@@ -548,6 +549,7 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *adap,
 			     struct i2c_msg *msg, int stop)
 {
 	struct omap_i2c_dev *dev = i2c_get_adapdata(adap);
+	unsigned long timeout;
 	int r;
 	u16 w;
 
@@ -618,8 +620,13 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *adap,
 	 */
 	if (dev->set_mpu_wkup_lat != NULL)
 		dev->set_mpu_wkup_lat(dev->dev, dev->latency);
+	if (unlikely((msg->flags & I2C_M_SHORT_TIMEOUT)))
+		timeout = OMAP_I2C_SHORT_TIMEOUT;
+	else
+		timeout = OMAP_I2C_TIMEOUT;
+
 	r = wait_for_completion_timeout(&dev->cmd_complete,
-					OMAP_I2C_TIMEOUT);
+					timeout);
 	if (dev->set_mpu_wkup_lat != NULL)
 		dev->set_mpu_wkup_lat(dev->dev, -1);
 	dev->buf_len = 0;
-- 
1.6.0.4

