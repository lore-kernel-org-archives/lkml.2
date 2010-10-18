Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab0JRWpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 18:45:12 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:58086 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756575Ab0JRWpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 18:45:10 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Cc: device-drivers-devel@blackfin.uclinux.org,
        Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH] video: backlight: adp8860: fix ambient light zone overwrite handling
Date: Mon, 18 Oct 2010 18:47:53 -0400
Message-Id: <1287442073-7094-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

This affects the get/set of the current Ambient Light Zone.  Reading
should return an integer between 1..3 (1 = Daylight, 2 = office,
3 = dark).  Writing a value between 1..3 forces the backlight controller
to enter the corresponding Ambient Light Zone.  Writing 0 returns to
normal operation.

Fix valid range checking so we don't write invalid values to the
controller, and make sure we subtract 1, since this is what the
register definition (CFGR:BLV) requires.  Otherwise the values
written don't work correctly.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/video/backlight/adp8860_bl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/adp8860_bl.c b/drivers/video/backlight/adp8860_bl.c
index 3ec2460..a447c92 100644
--- a/drivers/video/backlight/adp8860_bl.c
+++ b/drivers/video/backlight/adp8860_bl.c
@@ -614,7 +614,7 @@ static ssize_t adp8860_bl_ambient_light_zone_store(struct device *dev,
 	if (val == 0) {
 		/* Enable automatic ambient light sensing */
 		adp8860_set_bits(data->client, ADP8860_MDCR, CMP_AUTOEN);
-	} else if ((val > 0) && (val < 6)) {
+	} else if ((val > 0) && (val <= 3)) {
 		/* Disable automatic ambient light sensing */
 		adp8860_clr_bits(data->client, ADP8860_MDCR, CMP_AUTOEN);
 
@@ -622,7 +622,7 @@ static ssize_t adp8860_bl_ambient_light_zone_store(struct device *dev,
 		mutex_lock(&data->lock);
 		adp8860_read(data->client, ADP8860_CFGR, &reg_val);
 		reg_val &= ~(CFGR_BLV_MASK << CFGR_BLV_SHIFT);
-		reg_val |= val << CFGR_BLV_SHIFT;
+		reg_val |= (val - 1) << CFGR_BLV_SHIFT;
 		adp8860_write(data->client, ADP8860_CFGR, reg_val);
 		mutex_unlock(&data->lock);
 	}
-- 
1.7.3.1

