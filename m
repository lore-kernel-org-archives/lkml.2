Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab1H3S2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 14:28:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258Ab1H3S2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 14:28:48 -0400
Date: Tue, 30 Aug 2011 14:28:41 -0400
From: Jason Baron <jbaron@redhat.com>
To: gregkh@suse.de
Cc: joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
Message-Id: <94c0e3275b0bf7d2cad8e7909da1482a867e7bc6.1314725877.git.jbaron@redhat.com>
In-Reply-To: <cover.1314725877.git.jbaron@redhat.com>
References: <cover.1314725877.git.jbaron@redhat.com>
Subject: [PATCH 1/4] dynamic_debug: consolidate repetitive struct _ddebug descriptor definitions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the repetitive struct _ddebug descriptor definitions with
a new DECLARE_DYNAMIC_DEBUG_META_DATA(name, fmt) macro.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/dynamic_debug.h |   64 ++++++++++++++++++++++------------------
 1 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index feaac1e..8aec680 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -54,35 +54,41 @@ extern int __dynamic_netdev_dbg(struct _ddebug *descriptor,
 			     const char *fmt, ...)
 	__attribute__ ((format (printf, 3, 4)));
 
-#define dynamic_pr_debug(fmt, ...) do {					\
-	static struct _ddebug descriptor				\
-	__used								\
-	__attribute__((section("__verbose"), aligned(8))) =		\
-	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
-		_DPRINTK_FLAGS_DEFAULT };				\
-	if (unlikely(descriptor.enabled))				\
-		__dynamic_pr_debug(&descriptor, pr_fmt(fmt), ##__VA_ARGS__); \
-	} while (0)
-
-#define dynamic_dev_dbg(dev, fmt, ...) do {				\
-	static struct _ddebug descriptor				\
-	__used								\
-	__attribute__((section("__verbose"), aligned(8))) =		\
-	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
-		_DPRINTK_FLAGS_DEFAULT };				\
-	if (unlikely(descriptor.enabled))				\
-		__dynamic_dev_dbg(&descriptor, dev, fmt, ##__VA_ARGS__);	\
-	} while (0)
-
-#define dynamic_netdev_dbg(dev, fmt, ...) do {				\
-	static struct _ddebug descriptor				\
-	__used								\
-	__attribute__((section("__verbose"), aligned(8))) =		\
-	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
-		_DPRINTK_FLAGS_DEFAULT };				\
-	if (unlikely(descriptor.enabled))				\
-		__dynamic_netdev_dbg(&descriptor, dev, fmt, ##__VA_ARGS__);\
-	} while (0)
+#define DECLARE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
+	static struct _ddebug __used __aligned(8)		\
+	__attribute__((section("__verbose"))) name = {		\
+		.modname = KBUILD_MODNAME,			\
+		.function = __func__,				\
+		.filename = __FILE__,				\
+		.format = (fmt),				\
+		.lineno = __LINE__,				\
+		.flags =  _DPRINTK_FLAGS_DEFAULT,		\
+		.enabled = false,				\
+	}
+
+#define dynamic_pr_debug(fmt, ...)				\
+do {								\
+	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);	\
+	if (unlikely(descriptor.enabled))			\
+		__dynamic_pr_debug(&descriptor, pr_fmt(fmt),	\
+				   ##__VA_ARGS__);		\
+} while (0)
+
+#define dynamic_dev_dbg(dev, fmt, ...)				\
+do {								\
+	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);	\
+	if (unlikely(descriptor.enabled))			\
+		__dynamic_dev_dbg(&descriptor, dev, fmt,	\
+				  ##__VA_ARGS__);		\
+} while (0)
+
+#define dynamic_netdev_dbg(dev, fmt, ...)			\
+do {								\
+	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);	\
+	if (unlikely(descriptor.enabled))			\
+		__dynamic_netdev_dbg(&descriptor, dev, fmt,	\
+				     ##__VA_ARGS__);		\
+} while (0)
 
 #else
 
-- 
1.7.5.4

