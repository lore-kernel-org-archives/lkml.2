Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037Ab1BFP6P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 10:58:15 -0500
Received: from trinity.develer.com ([83.149.158.210]:48377 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab1BFP6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 10:58:14 -0500
X-Greylist: delayed 462 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Feb 2011 10:58:14 EST
From: Andrea Righi <arighi@develer.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>,
        =?UTF-8?q?Peter=20Nordstr=C3=B6m=20=28Palm=20GBU=29?= 
	<peter.nordstrom@palm.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] fb: fix potential deadlock between lock_fb_info and console_lock
Date: Sun,  6 Feb 2011 16:50:24 +0100
Message-Id: <1297007424-14656-1-git-send-email-arighi@develer.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function fb_set_suspend() must be called with the console semaphore
held, which means the code path coming in here will first take the
console_lock() and then call lock_fb_info().

However several framebuffer ioctl commands acquire these locks in
reverse order (lock_fb_info() and then console_lock()). This gives rise
to potential AB-BA deadlock.

Fix this by changing the order of acquisition in the ioctl commands that
make use of console_lock().

Reported-by: Peter Nordström (Palm GBU) <peter.nordstrom@palm.com>
Signed-off-by: Andrea Righi <arighi@develer.com>
---
 drivers/video/fbmem.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index e2bf953..def59f0 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1034,14 +1034,16 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 	case FBIOPUT_VSCREENINFO:
 		if (copy_from_user(&var, argp, sizeof(var)))
 			return -EFAULT;
-		if (!lock_fb_info(info))
-			return -ENODEV;
 		console_lock();
+		if (!lock_fb_info(info)) {
+			console_unlock();
+			return -ENODEV;
+		}
 		info->flags |= FBINFO_MISC_USEREVENT;
 		ret = fb_set_var(info, &var);
 		info->flags &= ~FBINFO_MISC_USEREVENT;
-		console_unlock();
 		unlock_fb_info(info);
+		console_unlock();
 		if (!ret && copy_to_user(argp, &var, sizeof(var)))
 			ret = -EFAULT;
 		break;
@@ -1070,12 +1072,14 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 	case FBIOPAN_DISPLAY:
 		if (copy_from_user(&var, argp, sizeof(var)))
 			return -EFAULT;
-		if (!lock_fb_info(info))
-			return -ENODEV;
 		console_lock();
+		if (!lock_fb_info(info)) {
+			console_unlock();
+			return -ENODEV;
+		}
 		ret = fb_pan_display(info, &var);
-		console_unlock();
 		unlock_fb_info(info);
+		console_unlock();
 		if (ret == 0 && copy_to_user(argp, &var, sizeof(var)))
 			return -EFAULT;
 		break;
@@ -1117,14 +1121,16 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 		unlock_fb_info(info);
 		break;
 	case FBIOBLANK:
-		if (!lock_fb_info(info))
-			return -ENODEV;
 		console_lock();
+		if (!lock_fb_info(info)) {
+			console_unlock();
+			return -ENODEV;
+		}
 		info->flags |= FBINFO_MISC_USEREVENT;
 		ret = fb_blank(info, arg);
 		info->flags &= ~FBINFO_MISC_USEREVENT;
-		console_unlock();
 		unlock_fb_info(info);
+		console_unlock();
 		break;
 	default:
 		if (!lock_fb_info(info))
-- 
1.7.1

