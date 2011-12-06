Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab1LFTMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:12:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52815 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab1LFTMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:12:14 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 03/25] dynamic_debug: drop enabled field from struct _ddebug, use _DPRINTK_FLAGS_PRINT
Date: Tue,  6 Dec 2011 12:11:13 -0700
Message-Id: <1323198694-7186-4-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>, <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
 <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Currently any enabled dynamic-debug flag on a pr_debug callsite will
enable printing, even if _DPRINTK_FLAGS_PRINT is off.  Checking print
flag directly allows "-p" to disable callsites without fussing with
other flags, so the following disables everything, without altering
flags user may have set:

	echo -p > $DBGFS/dynamic_debug/control

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 include/linux/dynamic_debug.h |   10 ++++------
 lib/dynamic_debug.c           |    4 ----
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 0564e3c..f71a6b04 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -28,7 +28,6 @@ struct _ddebug {
 #define _DPRINTK_FLAGS_INCL_TID		(1<<4)
 #define _DPRINTK_FLAGS_DEFAULT 0
 	unsigned int flags:8;
-	char enabled;
 } __attribute__((aligned(8)));
 
 
@@ -62,21 +61,20 @@ int __dynamic_netdev_dbg(struct _ddebug *descriptor,
 		.format = (fmt),				\
 		.lineno = __LINE__,				\
 		.flags =  _DPRINTK_FLAGS_DEFAULT,		\
-		.enabled = false,				\
 	}
 
 #define dynamic_pr_debug(fmt, ...)				\
 do {								\
 	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);		\
-	if (unlikely(descriptor.enabled))			\
+	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))	\
 		__dynamic_pr_debug(&descriptor, pr_fmt(fmt),	\
 				   ##__VA_ARGS__);		\
 } while (0)
 
 #define dynamic_dev_dbg(dev, fmt, ...)				\
 do {								\
-	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);	\
-	if (unlikely(descriptor.enabled))			\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);		\
+	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))	\
 		__dynamic_dev_dbg(&descriptor, dev, fmt,	\
 				  ##__VA_ARGS__);		\
 } while (0)
@@ -84,7 +82,7 @@ do {								\
 #define dynamic_netdev_dbg(dev, fmt, ...)			\
 do {								\
 	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);		\
-	if (unlikely(descriptor.enabled))			\
+	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))	\
 		__dynamic_netdev_dbg(&descriptor, dev, fmt,	\
 				     ##__VA_ARGS__);		\
 } while (0)
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index e487d13..416c079 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -151,10 +151,6 @@ static void ddebug_change(const struct ddebug_query *query,
 			if (newflags == dp->flags)
 				continue;
 			dp->flags = newflags;
-			if (newflags)
-				dp->enabled = 1;
-			else
-				dp->enabled = 0;
 			if (verbose)
 				pr_info("changed %s:%d [%s]%s %s\n",
 					dp->filename, dp->lineno,
-- 
1.7.7.3

