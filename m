Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583Ab1IUVzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:55:53 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49731 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab1IUVzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:55:48 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: joe@perches.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 01/26] dynamic_debug: drop enabled field from struct _ddebug, use flags & _DPRINTK_FLAGS_PRINT
Date: Wed, 21 Sep 2011 15:54:50 -0600
Message-Id: <1316642115-20029-2-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Currently any enabled dynamic-debug flag on a pr_debug callsite will enable
printing, even if _DPRINTK_FLAGS_PRINT is off.  Checking print flag directly
allows "-p" to disable callsites without fussing with other flags, so
the following disables everything:

	echo -p > $DBGFS/dynamic_debug/control

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 include/linux/dynamic_debug.h |    8 +++-----
 lib/dynamic_debug.c           |    4 ----
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 8aec680..ed7df3d 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -28,7 +28,6 @@ struct _ddebug {
 #define _DPRINTK_FLAGS_INCL_TID		(1<<4)
 #define _DPRINTK_FLAGS_DEFAULT 0
 	unsigned int flags:8;
-	char enabled;
 } __attribute__((aligned(8)));
 
 
@@ -63,13 +62,12 @@ extern int __dynamic_netdev_dbg(struct _ddebug *descriptor,
 		.format = (fmt),				\
 		.lineno = __LINE__,				\
 		.flags =  _DPRINTK_FLAGS_DEFAULT,		\
-		.enabled = false,				\
 	}
 
 #define dynamic_pr_debug(fmt, ...)				\
 do {								\
 	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);	\
-	if (unlikely(descriptor.enabled))			\
+	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))	\
 		__dynamic_pr_debug(&descriptor, pr_fmt(fmt),	\
 				   ##__VA_ARGS__);		\
 } while (0)
@@ -77,7 +75,7 @@ do {								\
 #define dynamic_dev_dbg(dev, fmt, ...)				\
 do {								\
 	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);	\
-	if (unlikely(descriptor.enabled))			\
+	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))	\
 		__dynamic_dev_dbg(&descriptor, dev, fmt,	\
 				  ##__VA_ARGS__);		\
 } while (0)
@@ -85,7 +83,7 @@ do {								\
 #define dynamic_netdev_dbg(dev, fmt, ...)			\
 do {								\
 	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);	\
-	if (unlikely(descriptor.enabled))			\
+	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))	\
 		__dynamic_netdev_dbg(&descriptor, dev, fmt,	\
 				     ##__VA_ARGS__);		\
 } while (0)
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 4138574..f2fb0c0 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -152,10 +152,6 @@ static void ddebug_change(const struct ddebug_query *query,
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
1.7.4.4

