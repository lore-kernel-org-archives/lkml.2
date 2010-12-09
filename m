Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab0LIKYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 05:24:39 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:36647 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002Ab0LIKYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 05:24:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=CHRkzlSeRdsbc75inRhTrL40tk0eDsDB9BPt6KudE7Cywg/QVBktfIbfp4DN88bMhY
         aM0b0BiqqHlBuO7BmrMVZB94MbruhNi8LFZo1ogrNgxyBtzTuw0t6ffEIMlKwD5BZUc2
         MjnoxftJfDjnZU4YJ48kYyHiZ7ZAKJVVpEuhw=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 2/8] staging: ft1000: Fix private data pointer usage.
Date: Thu,  9 Dec 2010 11:26:47 +0100
Message-Id: <1291890413-15255-3-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291890413-15255-1-git-send-email-marek.belisko@open-nandra.com>
References: <1291890413-15255-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assign private data pointer to device for usage in file operations.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
index 1238b77..8b735e4 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -347,12 +347,15 @@ void ft1000_DestroyDevice(struct net_device *dev)
 static int ft1000_ChOpen (struct inode *Inode, struct file *File)
 {
 	struct ft1000_info *info;
+	struct ft1000_device *dev = (struct ft1000_device *)Inode->i_private;
     int i,num;
 
     DEBUG("ft1000_ChOpen called\n");
     num = (MINOR(Inode->i_rdev) & 0xf);
     DEBUG("ft1000_ChOpen: minor number=%d\n", num);
 
+	info = File->private_data = netdev_priv(dev->net);
+
     for (i=0; i<5; i++)
         DEBUG("pdevobj[%d]=%p\n", i, pdevobj[i]); //aelias [+] reason: down
 
@@ -393,8 +396,6 @@ static int ft1000_ChOpen (struct inode *Inode, struct file *File)
     info->app_info[i].nTxMsgReject = 0;
     info->app_info[i].nRxMsgMiss = 0;
 
-    File->private_data = pdevobj[num]->net;
-
 	nonseekable_open(Inode, File);
     return 0;
 }
-- 
1.7.1

