Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163Ab2CMApr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:45:47 -0400
Received: from mail.windriver.com ([147.11.1.11]:48294 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758996Ab2CMAXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:40 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 119/196] Staging: rtl8192su: Fix procfs code for interfaces not named wlan0
Date: Mon, 12 Mar 2012 20:20:32 -0400
Message-Id: <1331598109-31424-74-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 41a38d9e632f7c9ec5ad8fc627567d97f4302c4a upstream.

The current code creates directories in procfs named after interfaces,
but doesn't handle renaming.  This can result in name collisions and
consequent WARNINGs.  It also means that the interface name cannot
reliably be used to remove the directory - in fact the current code
doesn't even try, and always uses "wlan0"!

Since the name of a proc_dir_entry is embedded in it, use that when
removing it.

Add a netdev notifier to catch interface renaming, and remove and
re-add the directory at this point.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/rtl8192su/r8192U_core.c |   35 ++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192su/r8192U_core.c b/drivers/staging/rtl8192su/r8192U_core.c
index 9848d08..7946cf6 100644
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -26,6 +26,7 @@
 
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
+#include <linux/notifier.h>
 
 #undef LOOP_TEST
 #undef DUMP_RX
@@ -161,6 +162,8 @@ MODULE_PARM_DESC(channels," Channel bitmask for specific locales. NYI");
 static int __devinit rtl8192_usb_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id);
 static void __devexit rtl8192_usb_disconnect(struct usb_interface *intf);
+static const struct net_device_ops rtl8192_netdev_ops;
+static struct notifier_block proc_netdev_notifier;
 
 static struct usb_driver rtl8192_usb_driver = {
 	.name		= RTL819xU_MODULE_NAME,	          /* Driver name   */
@@ -962,14 +965,22 @@ static int proc_get_stats_rx(char *page, char **start,
 
 int rtl8192_proc_module_init(void)
 {
+	int ret;
+
 	RT_TRACE(COMP_INIT, "Initializing proc filesystem");
 	rtl8192_proc=create_proc_entry(RTL819xU_MODULE_NAME, S_IFDIR, init_net.proc_net);
-	return rtl8192_proc ? 0 : -ENOMEM;
+	if (!rtl8192_proc)
+		return -ENOMEM;
+	ret = register_netdevice_notifier(&proc_netdev_notifier);
+	if (ret)
+		remove_proc_entry(RTL819xU_MODULE_NAME, init_net.proc_net);
+	return ret;
 }
 
 
 void rtl8192_proc_module_remove(void)
 {
+	unregister_netdevice_notifier(&proc_netdev_notifier);
 	remove_proc_entry(RTL819xU_MODULE_NAME, init_net.proc_net);
 }
 
@@ -997,8 +1008,7 @@ void rtl8192_proc_remove_one(struct net_device *dev)
 		remove_proc_entry("registers-e", priv->dir_dev);
 	//	remove_proc_entry("cck-registers",priv->dir_dev);
 	//	remove_proc_entry("ofdm-registers",priv->dir_dev);
-		//remove_proc_entry(dev->name, rtl8192_proc);
-		remove_proc_entry("wlan0", rtl8192_proc);
+		remove_proc_entry(priv->dir_dev->name, rtl8192_proc);
 		priv->dir_dev = NULL;
 	}
 }
@@ -1115,6 +1125,25 @@ void rtl8192_proc_init_one(struct net_device *dev)
 		      dev->name);
 	}
 }
+
+static int proc_netdev_event(struct notifier_block *this,
+			     unsigned long event, void *ptr)
+{
+	struct net_device *net_dev = ptr;
+
+	if (net_dev->netdev_ops == &rtl8192_netdev_ops &&
+	    event == NETDEV_CHANGENAME) {
+		rtl8192_proc_remove_one(net_dev);
+		rtl8192_proc_init_one(net_dev);
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block proc_netdev_notifier = {
+	.notifier_call = proc_netdev_event,
+};
+
 /****************************************************************************
    -----------------------------MISC STUFF-------------------------
 *****************************************************************************/
-- 
1.7.9.3

