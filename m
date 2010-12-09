Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab0LIPLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:11:30 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:36848 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab0LIPL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:11:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=wpcTZZB3P4G1vu8n4+FVfXsM/X86wqMwUG3Sf78M8LDiSpmalKzZsYdtmXTxpgnJVA
         0zndj5Xy0Jz+grAAZOeg0nYwwmS+39dDaRPS7k3n+10t1ano7GqTbs4wLt3GzKjGt3cU
         cgvVEU0CG+O7gBmtkLM8dyzV+a98vNidYaSr0=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 1/8] staging: ft1000: Fix proc initialization handling.
Date: Thu,  9 Dec 2010 16:13:47 +0100
Message-Id: <1291907634-22437-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaning proc entries when error occures was not handled correctly.
So fix and also add proper cleaning.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c |   40 +++++++++++++++--------
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h  |    2 +-
 2 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
index 105846d..dbd4a1c 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
@@ -193,32 +193,44 @@ static struct notifier_block ft1000_netdev_notifier = {
 };
 
 
-void
-ft1000InitProc (struct net_device *dev)
+int ft1000InitProc(struct net_device *dev)
 {
 	struct ft1000_info *info;
   struct proc_dir_entry *ft1000_proc_file;
-	info = netdev_priv(dev);
+	int ret = 0;
 
+	info = netdev_priv(dev);
 
   info->ft1000_proc_dir = proc_mkdir (FT1000_PROC_DIR, FTNET_PROC);
-  if (info->ft1000_proc_dir == NULL)
-    {
-      remove_proc_entry (FT1000_PROC_DIR, FTNET_PROC);
-    }
-
+	if (info->ft1000_proc_dir == NULL) {
+		printk(KERN_WARNING "Unable to create %s dir.\n",
+			FT1000_PROC_DIR);
+		ret = -EINVAL;
+		goto fail;
+	}
 
   ft1000_proc_file =
     create_proc_read_entry (dev->name, 0644, info->ft1000_proc_dir,
 			    ft1000ReadProc, dev);
-  if (ft1000_proc_file == NULL)
-    {
-      remove_proc_entry (info->netdevname, info->ft1000_proc_dir);
-    }
+	if (ft1000_proc_file == NULL) {
+		printk(KERN_WARNING "Unable to create /proc entry.\n");
+		ret = -EINVAL;
+		goto fail_entry;
+	}
 
   snprintf (info->netdevname, IFNAMSIZ, "%s", dev->name);
-  register_netdevice_notifier (&ft1000_netdev_notifier);
-  return;
+	ret = register_netdevice_notifier(&ft1000_netdev_notifier);
+	if (ret)
+		goto fail_notif;
+
+	return 0;
+
+fail_notif:
+	remove_proc_entry(info->netdevname, info->ft1000_proc_dir);
+fail_entry:
+	remove_proc_entry(FT1000_PROC_DIR, FTNET_PROC);
+fail:
+	return ret;
 }
 
 void
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 045ef30..4a91469 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -594,7 +594,7 @@ struct usb_interface;
 int reg_ft1000_netdev(struct ft1000_device *ft1000dev, struct usb_interface *intf);
 int ft1000_poll(void* dev_id);
 
-void ft1000InitProc(struct net_device *dev);
+int ft1000InitProc(struct net_device *dev);
 void ft1000CleanupProc(struct ft1000_info *info);
 
 
-- 
1.7.1

