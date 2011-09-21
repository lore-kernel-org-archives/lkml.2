Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab1IUV4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:56:53 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62277 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab1IUV4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:56:49 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: joe@perches.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 25/26] dynamic_debug: add pr_fmt_dbg() for dynamic_pr_debug
Date: Wed, 21 Sep 2011 15:55:14 -0600
Message-Id: <1316642115-20029-26-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

dynamic_pr_debug can add module, function, file, and line selectively,
so theres no need to also add them via pr_fmt.  Moreover, using pr_fmt
to add KBUILD_MODNAME ": ", as is typical for pr_info etc, causes
pr_debug() to double-print those fields added by the flag-settings.

So define pr_fmt_dbg(fmt), and use it in dynamic_pr_debug().  This lets
users use pr_fmt() for pr_info and friends, without affecting pr_debug().
For non-dynamic-debug builds, pr_fmt_dbg() uses pr_fmt(), preserving
existing print info.

It also allows incrementally converting modules by dropping NAME
from pr_debug(NAME ": ...") and adding it once via pr_fmt_dbg().
Later, if/when module-name is added to dynamic-debug's default,
modules can drop their pr_fmt_dbg()s, and get it via header defns
for both non- and dynamic-debug builds.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 include/linux/dynamic_debug.h |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 5622e04..722a4f5 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -69,11 +69,15 @@ extern int __dynamic_netdev_dbg(struct _ddebug *descriptor,
 		.flags =  _DPRINTK_FLAGS_DEFAULT,		\
 	}
 
+#ifndef pr_fmt_dbg
+#define pr_fmt_dbg(fmt) fmt
+#endif
+
 #define dynamic_pr_debug(fmt, ...)				\
 do {								\
 	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);	\
 	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))	\
-		__dynamic_pr_debug(&descriptor, pr_fmt(fmt),	\
+		__dynamic_pr_debug(&descriptor, pr_fmt_dbg(fmt),\
 				   ##__VA_ARGS__);		\
 } while (0)
 
@@ -100,10 +104,16 @@ static inline int ddebug_remove_module(const char *mod)
 	return 0;
 }
 
+#ifndef pr_fmt_dbg
+#define pr_fmt_dbg(fmt) pr_fmt(fmt)
+#endif
+
 #define dynamic_pr_debug(fmt, ...)					\
-	do { if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); } while (0)
+	do { if (0) printk(KERN_DEBUG pr_fmt_dbg(fmt), ##__VA_ARGS__);	\
+	} while (0)
 #define dynamic_dev_dbg(dev, fmt, ...)					\
-	do { if (0) dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__); } while (0)
+	do { if (0) dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);	\
+	} while (0)
 #endif
 
 #endif
-- 
1.7.4.4

