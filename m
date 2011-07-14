Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab1GNQJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 12:09:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932090Ab1GNQJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 12:09:55 -0400
Date: Thu, 14 Jul 2011 12:09:49 -0400
From: Jason Baron <jbaron@redhat.com>
To: gregkh@suse.de
Cc: joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
Message-Id: <1091cc96c6164e181118b0d81e48d53154d813a8.1310657068.git.jbaron@redhat.com>
In-Reply-To: <cover.1310657068.git.jbaron@redhat.com>
References: <cover.1310657068.git.jbaron@redhat.com>
Subject: [PATCH 09/11] dynamic_debug: consolidate repetitive struct _ddebug descriptor definitions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

Replace the repetitive  struct _ddebug descriptor definitions with
a new DYNAMIC_DEBUG_META_DATA(fmt) macro.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/dynamic_debug.h |   33 ++++++++++++++-------------------
 1 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index feaac1e..bc75472 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -54,33 +54,28 @@ extern int __dynamic_netdev_dbg(struct _ddebug *descriptor,
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
 
-- 
1.7.5.4

