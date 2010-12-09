Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab0LIKYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 05:24:38 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:57067 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab0LIKYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 05:24:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=xOyhN8/QVsGZcpKNwibKAUhyt3p5bahKl91lrWs9yHHPOHYrzd75fVAx6GuvsUJr9b
         UNZOgeyo9eLGnSneKcueW47nBvtJ9PRfXkQZmVJmhfJ2cxZF3bT5+owZiOqLUXYChOXp
         QxFs70RdBH/3kHeQ+hlHM1ooH4oUOxboevKGk=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 1/8] staging: ft1000: Convert char device to debugfs.
Date: Thu,  9 Dec 2010 11:26:46 +0100
Message-Id: <1291890413-15255-2-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291890413-15255-1-git-send-email-marek.belisko@open-nandra.com>
References: <1291890413-15255-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Character device was used only for debugging purposes.
Convert it to debugfs functionality. For every plugged device
create new directory with one file.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c |   68 +++++++++++++++------
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c    |    1 +
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h   |    8 +++
 3 files changed, 57 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
index 1aec926..1238b77 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -37,7 +37,7 @@
 #include <linux/kmod.h>
 #include <linux/ioctl.h>
 #include <linux/unistd.h>
-
+#include <linux/debugfs.h>
 #include "ft1000_usb.h"
 //#include "ft1000_ioctl.h"
 
@@ -156,9 +156,11 @@ int ft1000_CreateDevice(struct ft1000_device *dev)
 	struct ft1000_info *info = netdev_priv(dev->net);
     int result;
     int i;
+	struct dentry *dir, *file;
+	struct ft1000_debug_dirs *tmp;
 
     // make a new device name
-    sprintf(info->DeviceName, "%s%d", "FT100", info->CardNumber);
+    sprintf(info->DeviceName, "%s%d", "FT1000_", info->CardNumber);
 
     DEBUG("ft1000_CreateDevice: number of instance = %d\n", ft1000_flarion_cnt);
     DEBUG("DeviceCreated = %x\n", info->DeviceCreated);
@@ -179,21 +181,31 @@ int ft1000_CreateDevice(struct ft1000_device *dev)
     DEBUG("ft1000_CreateDevice: \"%s\" device registration\n", info->DeviceName);
     info->DeviceMajor = 0;
 
-    result = register_chrdev(info->DeviceMajor, info->DeviceName, &ft1000fops);
-    if (result < 0)
-    {
-	DEBUG("ft1000_CreateDevice: unable to get major %d\n", info->DeviceMajor);
-	return result;
-    }
+	tmp = kmalloc(sizeof(struct ft1000_debug_dirs), GFP_KERNEL);
+	if (tmp == NULL) {
+		result = -1;
+		goto fail;
+	}
 
-    DEBUG("ft1000_CreateDevice: registered char device \"%s\"\n", info->DeviceName);
+	dir = debugfs_create_dir(info->DeviceName, 0);
+	if (IS_ERR(dir)) {
+		result = PTR_ERR(dir);
+		goto debug_dir_fail;
+	}
 
-    // save a dynamic device major number
-    if (info->DeviceMajor == 0)
-    {
-	info->DeviceMajor = result;
-	DEBUG("ft1000_PcdCreateDevice: device major = %d\n", info->DeviceMajor);
-    }
+	file = debugfs_create_file("device", S_IRUGO | S_IWUGO, dir,
+					NULL, &ft1000fops);
+	if (IS_ERR(file)) {
+		result = PTR_ERR(file);
+		goto debug_file_fail;
+	}
+
+	tmp->dent = dir;
+	tmp->file = file;
+	tmp->int_number = info->CardNumber;
+	list_add(&(tmp->list), &(info->nodes.list));
+
+    DEBUG("ft1000_CreateDevice: registered char device \"%s\"\n", info->DeviceName);
 
     // initialize application information
 
@@ -243,7 +255,14 @@ int ft1000_CreateDevice(struct ft1000_device *dev)
     info->DeviceCreated = TRUE;
     ft1000_flarion_cnt++;
 
-    return result;
+	return 0;
+
+debug_file_fail:
+	debugfs_remove(dir);
+debug_dir_fail:
+	kfree(tmp);
+fail:
+	return result;
 }
 
 //---------------------------------------------------------------------------
@@ -259,10 +278,11 @@ int ft1000_CreateDevice(struct ft1000_device *dev)
 void ft1000_DestroyDevice(struct net_device *dev)
 {
 	struct ft1000_info *info = netdev_priv(dev);
-    int result = 0;
 		int i;
 	struct dpram_blk *pdpram_blk;
 	struct dpram_blk *ptr;
+	struct list_head *pos, *q;
+	struct ft1000_debug_dirs *dir;
 
     DEBUG("ft1000_chdev:ft1000_DestroyDevice called\n");
 
@@ -271,9 +291,17 @@ void ft1000_DestroyDevice(struct net_device *dev)
     if (info->DeviceCreated)
 	{
         ft1000_flarion_cnt--;
-		unregister_chrdev(info->DeviceMajor, info->DeviceName);
-		DEBUG("ft1000_DestroyDevice: unregistered device \"%s\", result = %d\n",
-					   info->DeviceName, result);
+		list_for_each_safe(pos, q, &info->nodes.list) {
+			dir = list_entry(pos, struct ft1000_debug_dirs, list);
+			if (dir->int_number == info->CardNumber) {
+				debugfs_remove(dir->file);
+				debugfs_remove(dir->dent);
+				list_del(pos);
+				kfree(dir);
+			}
+		}
+		DEBUG("ft1000_DestroyDevice: unregistered device \"%s\"\n",
+					   info->DeviceName);
 
         // Make sure we free any memory reserve for slow Queue
         for (i=0; i<MAX_NUM_APP; i++) {
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 1ca01e2..22536da 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -851,6 +851,7 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
 
     INIT_LIST_HEAD(&pInfo->prov_list);
 
+	INIT_LIST_HEAD(&pInfo->nodes.list);
 //mbelian
 #ifdef HAVE_NET_DEVICE_OPS
 	netdev->netdev_ops = &ftnet_ops;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index a07db26..5bead63 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -473,6 +473,13 @@ struct ft1000_device
 //	struct net_device_stats stats; //mbelian
 } __attribute__ ((packed));
 
+struct ft1000_debug_dirs {
+	struct list_head list;
+	struct dentry *dent;
+	struct dentry *file;
+	int int_number;
+};
+
 struct ft1000_info {
     struct ft1000_device *pFt1000Dev;
     struct net_device_stats stats;
@@ -508,6 +515,7 @@ struct ft1000_info {
     u8 CardNumber;
     u8 DeviceName[15];
     int DeviceMajor;
+    struct ft1000_debug_dirs nodes;
     int registered;
     int mediastate;
     int dhcpflg;
-- 
1.7.1

