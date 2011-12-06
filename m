Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab1LFTSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:18:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56514 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab1LFTMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:12:16 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 04/25] dynamic_debug: make dynamic-debug supersede DEBUG ccflag
Date: Tue,  6 Dec 2011 12:11:14 -0700
Message-Id: <1323198694-7186-5-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>, <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
 <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

if CONFIG_DYNAMIC_DEBUG is defined, honor it over DEBUG, so that
pr_debug()s are controllable, instead of always-on.  When DEBUG is
also defined, change _DPRINTK_FLAGS_DEFAULT to enable printing by
default.

Also adding _DPRINTK_FLAGS_INCL_MODNAME would be nice, but there are
numerous cases of pr_debug(NAME ": ...), which would result in double
printing of module-name.  So defer this until things settle.

CC: Joe Perches <joe@perches.com>
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 include/linux/device.h        |    8 ++++----
 include/linux/dynamic_debug.h |    4 ++++
 include/linux/netdevice.h     |    8 ++++----
 include/linux/printk.h        |    8 ++++----
 4 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 3136ede..c9468c1 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -872,14 +872,14 @@ int _dev_info(const struct device *dev, const char *fmt, ...)
 
 #define dev_info(dev, fmt, arg...) _dev_info(dev, fmt, ##arg)
 
-#if defined(DEBUG)
-#define dev_dbg(dev, format, arg...)		\
-	dev_printk(KERN_DEBUG, dev, format, ##arg)
-#elif defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG)
 #define dev_dbg(dev, format, ...)		     \
 do {						     \
 	dynamic_dev_dbg(dev, format, ##__VA_ARGS__); \
 } while (0)
+#elif defined(DEBUG)
+#define dev_dbg(dev, format, arg...)		\
+	dev_printk(KERN_DEBUG, dev, format, ##arg)
 #else
 #define dev_dbg(dev, format, arg...)				\
 ({								\
diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index f71a6b04..29ea09a 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -26,7 +26,11 @@ struct _ddebug {
 #define _DPRINTK_FLAGS_INCL_FUNCNAME	(1<<2)
 #define _DPRINTK_FLAGS_INCL_LINENO	(1<<3)
 #define _DPRINTK_FLAGS_INCL_TID		(1<<4)
+#if defined DEBUG
+#define _DPRINTK_FLAGS_DEFAULT _DPRINTK_FLAGS_PRINT
+#else
 #define _DPRINTK_FLAGS_DEFAULT 0
+#endif
 	unsigned int flags:8;
 } __attribute__((aligned(8)));
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index cbeb586..f8b71a3c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2643,14 +2643,14 @@ int netdev_info(const struct net_device *dev, const char *format, ...);
 #define MODULE_ALIAS_NETDEV(device) \
 	MODULE_ALIAS("netdev-" device)
 
-#if defined(DEBUG)
-#define netdev_dbg(__dev, format, args...)			\
-	netdev_printk(KERN_DEBUG, __dev, format, ##args)
-#elif defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG)
 #define netdev_dbg(__dev, format, args...)			\
 do {								\
 	dynamic_netdev_dbg(__dev, format, ##args);		\
 } while (0)
+#elif defined(DEBUG)
+#define netdev_dbg(__dev, format, args...)			\
+	netdev_printk(KERN_DEBUG, __dev, format, ##args)
 #else
 #define netdev_dbg(__dev, format, args...)			\
 ({								\
diff --git a/include/linux/printk.h b/include/linux/printk.h
index f0e22f7..f9abd93 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -180,13 +180,13 @@ extern void dump_stack(void) __cold;
 #endif
 
 /* If you are writing a driver, please use dev_dbg instead */
-#if defined(DEBUG)
-#define pr_debug(fmt, ...) \
-	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
-#elif defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG)
 /* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
 #define pr_debug(fmt, ...) \
 	dynamic_pr_debug(fmt, ##__VA_ARGS__)
+#elif defined(DEBUG)
+#define pr_debug(fmt, ...) \
+	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #else
 #define pr_debug(fmt, ...) \
 	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
-- 
1.7.7.3

