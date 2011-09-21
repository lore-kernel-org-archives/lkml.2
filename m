Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab1IUWBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 18:01:04 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48711 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab1IUVzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:55:51 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: joe@perches.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 02/26] dynamic_debug: make dynamic-debug supersede DEBUG ccflag
Date: Wed, 21 Sep 2011 15:54:51 -0600
Message-Id: <1316642115-20029-3-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
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
index 4639419..2e16503 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -857,14 +857,14 @@ static inline int _dev_info(const struct device *dev, const char *fmt, ...)
 
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
index ed7df3d..12ef233 100644
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
index 2797260..8c08fe0 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2641,14 +2641,14 @@ extern int netdev_info(const struct net_device *dev, const char *format, ...)
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
index 0101d55..1224b1d 100644
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
1.7.4.4

