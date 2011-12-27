Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab1L0ORI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 09:17:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53688 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754395Ab1L0OQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 09:16:19 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jingoo Han <jg1.han@samsung.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 6/6] video: s3c-fb: Don't keep device runtime active when open
Date: Tue, 27 Dec 2011 14:16:12 +0000
Message-Id: <1324995372-3410-6-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1324995372-3410-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20111227141550.GA3331@opensource.wolfsonmicro.com>
 <1324995372-3410-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the controller to be runtime suspended when the screen is blanked
by not taking a runtime reference while the device is open. This allows
greater system wide power savings when used with a standard application
layer and ensures that the screen does not blank unless requested.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/video/s3c-fb.c |   22 ----------------------
 1 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
index 84cf631..0c63b69 100644
--- a/drivers/video/s3c-fb.c
+++ b/drivers/video/s3c-fb.c
@@ -1070,30 +1070,8 @@ static int s3c_fb_ioctl(struct fb_info *info, unsigned int cmd,
 	return ret;
 }
 
-static int s3c_fb_open(struct fb_info *info, int user)
-{
-	struct s3c_fb_win *win = info->par;
-	struct s3c_fb *sfb = win->parent;
-
-	pm_runtime_get_sync(sfb->dev);
-
-	return 0;
-}
-
-static int s3c_fb_release(struct fb_info *info, int user)
-{
-	struct s3c_fb_win *win = info->par;
-	struct s3c_fb *sfb = win->parent;
-
-	pm_runtime_put_sync(sfb->dev);
-
-	return 0;
-}
-
 static struct fb_ops s3c_fb_ops = {
 	.owner		= THIS_MODULE,
-	.fb_open	= s3c_fb_open,
-	.fb_release	= s3c_fb_release,
 	.fb_check_var	= s3c_fb_check_var,
 	.fb_set_par	= s3c_fb_set_par,
 	.fb_blank	= s3c_fb_blank,
-- 
1.7.7.3

