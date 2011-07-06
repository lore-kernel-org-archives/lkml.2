Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab1GFRZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 13:25:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755010Ab1GFRZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 13:25:18 -0400
Date: Wed, 6 Jul 2011 13:25:12 -0400
From: Jason Baron <jbaron@redhat.com>
To: gregkh@suse.de
Cc: joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
Message-Id: <f457c582af55869b20d4f735815647b71db3a680.1309967232.git.root@dhcp-100-18-164.bos.redhat.com>
In-Reply-To: <cover.1309967232.git.root@dhcp-100-18-164.bos.redhat.com>
References: <cover.1309967232.git.root@dhcp-100-18-164.bos.redhat.com>
Subject: [PATCH 09/10] dynamic_debug: consolidate repetitive struct _ddebug
 descriptor definitions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

Replace the repetitive  struct _ddebug descriptor definitions with
a new DYNAMIC_DEBUG_META_DATA(fmt) macro.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/dynamic_debug.h |   48 ++++++++++++++++------------------------
 1 files changed, 19 insertions(+), 29 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 7048e64..fdd3c0e 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -54,46 +54,36 @@ extern int __dynamic_netdev_dbg(struct _ddebug *descriptor,
 			     const char *fmt, ...)
 	__attribute__ ((format (printf, 3, 4)));
 
+#define DYNAMIC_DEBUG_METADATA(fmt)				\
+	static struct _ddebug descriptor			\
+	__used							\
+	__attribute__((section("__verbose"), aligned(8))) =	\
+	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,	\
+		_DPRINTK_FLAGS_DEFAULT };
+
 #define dynamic_pr_debug(fmt, ...) do {					\
-	static struct _ddebug descriptor				\
-	__used								\
-	__attribute__((section("__verbose"), aligned(8))) =		\
-	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
-		_DPRINTK_FLAGS_DEFAULT };				\
+	DYNAMIC_DEBUG_METADATA(fmt);					\
 	if (unlikely(descriptor.enabled))				\
-		__dynamic_pr_debug(&descriptor, pr_fmt(fmt), ##__VA_ARGS__); \
+		__dynamic_pr_debug(&descriptor, pr_fmt(fmt), ##__VA_ARGS__);\
 	} while (0)
 
 #define dynamic_dev_dbg(dev, fmt, ...) do {				\
-	static struct _ddebug descriptor				\
-	__used								\
-	__attribute__((section("__verbose"), aligned(8))) =		\
-	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
-		_DPRINTK_FLAGS_DEFAULT };				\
+	DYNAMIC_DEBUG_METADATA(fmt);					\
 	if (unlikely(descriptor.enabled))				\
-		__dynamic_dev_dbg(&descriptor, dev, fmt, ##__VA_ARGS__);	\
+		__dynamic_dev_dbg(&descriptor, dev, fmt, ##__VA_ARGS__);\
 	} while (0)
 
-#define dynamic_netdev_dbg(dev, fmt, ...) do {				\
-	static struct _ddebug descriptor				\
-	__used								\
-	__attribute__((section("__verbose"), aligned(8))) =		\
-	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
-		_DPRINTK_FLAGS_DEFAULT };				\
-	if (unlikely(descriptor.enabled))				\
+#define dynamic_netdev_dbg(dev, fmt, ...) do {				   \
+	DYNAMIC_DEBUG_METADATA(fmt);					   \
+	if (unlikely(descriptor.enabled))				   \
 		__dynamic_netdev_dbg(&descriptor, dev, fmt, ##__VA_ARGS__);\
 	} while (0)
 
-#define dynamic_netif_dbg(dev, cond, fmt, ...) do {			\
-	static struct _ddebug descriptor				\
-	__used								\
-	__attribute__((section("__verbose"), aligned(8))) =		\
-	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
-		_DPRINTK_FLAGS_DEFAULT };				\
-	if (unlikely(descriptor.enabled)) {				\
-		if (cond)						\
-			__dynamic_netdev_dbg(&descriptor, dev, fmt, ##__VA_ARGS__);\
-	}								\
+#define dynamic_netif_dbg(dev, cond, fmt, ...) do {			   \
+	DYNAMIC_DEBUG_METADATA(fmt);					   \
+	if (unlikely(descriptor.enabled) && (cond)) {			   \
+		__dynamic_netdev_dbg(&descriptor, dev, fmt, ##__VA_ARGS__);\
+	}								   \
 	} while (0)
 
 #else
-- 
1.7.5.4

