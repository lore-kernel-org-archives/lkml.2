Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab0LNNAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 08:00:38 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:51700 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759243Ab0LNNAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 08:00:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=HMoNBOKXZ4wtp7UFqmT49LD1VujElk+JAY438qkgi9Gotbj5KrAly9bdLmwuhQfIZp
         lTEBpVvBdynN6LJuA9w2etXnjuAWrQ/r9gn/3+xv1DV7FRalTtgbdWdtB/4JgeCHwiNA
         T+DWf3s2RuctPftAzJdxlrzEaMt2cY0t7bLmE=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 2/2] staging: ft1000: Fix kernel panic when use ioctl.
Date: Tue, 14 Dec 2010 14:02:55 +0100
Message-Id: <1292331775-3124-2-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292331775-3124-1-git-send-email-marek.belisko@open-nandra.com>
References: <1292331775-3124-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During ioctl testing was observed kernel panic beuase
file->private_data pointer was not correctly set when
debugfs file was created. Add correct pointer setup.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
index e398092..149ba59 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
@@ -174,7 +174,7 @@ int ft1000_create_dev(struct ft1000_device *dev)
 	}
 
 	file = debugfs_create_file("device", S_IRUGO | S_IWUSR, dir,
-					NULL, &ft1000fops);
+					dev, &ft1000fops);
 	if (IS_ERR(file)) {
 		result = PTR_ERR(file);
 		goto debug_file_fail;
@@ -398,7 +398,6 @@ static long ft1000_ioctl (struct file *file, unsigned int command,
                            unsigned long argument)
 {
     void __user *argp = (void __user *)argument;
-    struct net_device *dev;
 	struct ft1000_info *info;
     struct ft1000_device *ft1000dev;
     int result=0;
@@ -428,9 +427,8 @@ static long ft1000_ioctl (struct file *file, unsigned int command,
 
     //DEBUG("FT1000:ft1000_ioctl:command = 0x%x argument = 0x%8x\n", command, (u32)argument);
 
-    dev = file->private_data;
-	info = netdev_priv(dev);
-    ft1000dev = info->pFt1000Dev;
+	info = file->private_data;
+	ft1000dev = info->pFt1000Dev;
     cmd = _IOC_NR(command);
     //DEBUG("FT1000:ft1000_ioctl:cmd = 0x%x\n", cmd);
 
-- 
1.7.1

