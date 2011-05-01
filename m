Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab1EABqL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:46:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62471 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab1EABh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=oGHWg07j2Js2UIhUJ2oAQcQ8+tvYdETrygc1evwbK86SnNmGn5eXWb5tqylAUh18v0
         /URyl425swsUBMylp8CBCyLNeT3cUpFq7EztSvW7/B/7y16NKLkCQb3qe8x+UfKH/hC9
         VwVk6BFTjgC3f21pqE4/98HiMFaP2l/zjyxxw=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 57/69] sysctl: no-child: manually register fs/inotify
Date: Sun,  1 May 2011 03:36:27 +0200
Message-Id: <1304213799-10257-58-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 fs/notify/inotify/inotify_user.c |   22 +++++++++++++++++++---
 include/linux/inotify.h          |    2 --
 kernel/sysctl.c                  |    7 -------
 3 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 8445fbc..ba618c2 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -51,13 +51,13 @@ static int inotify_max_user_watches __read_mostly;
 static struct kmem_cache *inotify_inode_mark_cachep __read_mostly;
 struct kmem_cache *event_priv_cachep __read_mostly;
 
-#ifdef CONFIG_SYSCTL
+#if defined(CONFIG_SYSCTL) && defined(CONFIG_MMU)
 
 #include <linux/sysctl.h>
 
 static int zero;
 
-ctl_table inotify_table[] = {
+static struct ctl_table inotify_table[] = {
 	{
 		.procname	= "max_user_instances",
 		.data		= &inotify_max_user_instances,
@@ -84,7 +84,22 @@ ctl_table inotify_table[] = {
 	},
 	{ }
 };
-#endif /* CONFIG_SYSCTL */
+static const __initdata struct ctl_path inotify_path[] = {
+	{ .procname = "fs" },
+	{ .procname = "inotify" },
+	{ }
+};
+static struct ctl_table_header *inotify_header;
+static int __init register_inotify_sysctls(void)
+{
+	inotify_header = register_sysctl_paths(inotify_path, inotify_table);
+	if (inotify_header == NULL)
+		return -ENOMEM;
+	return 0;
+}
+#else /* CONFIG_SYSCTL && CONFIG_MMU */
+static int __init register_inotify_sysctls(void) { return 0; }
+#endif /* CONFIG_SYSCTL && CONFIG_MMU */
 
 static inline __u32 inotify_arg_to_mask(u32 arg)
 {
@@ -862,6 +877,7 @@ static int __init inotify_user_setup(void)
 	inotify_max_user_instances = 128;
 	inotify_max_user_watches = 8192;
 
+	register_inotify_sysctls();
 	return 0;
 }
 module_init(inotify_user_setup);
diff --git a/include/linux/inotify.h b/include/linux/inotify.h
index d33041e..89b3bfe 100644
--- a/include/linux/inotify.h
+++ b/include/linux/inotify.h
@@ -71,8 +71,6 @@ struct inotify_event {
 #define IN_NONBLOCK O_NONBLOCK
 
 #ifdef __KERNEL__
-#include <linux/sysctl.h>
-extern struct ctl_table inotify_table[]; /* for sysctl */
 
 #define ALL_INOTIFY_BITS (IN_ACCESS | IN_MODIFY | IN_ATTRIB | IN_CLOSE_WRITE | \
 			  IN_CLOSE_NOWRITE | IN_OPEN | IN_MOVED_FROM | \
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4e63701..5961046 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1439,13 +1439,6 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= proc_doulongvec_minmax,
 	},
 #endif /* CONFIG_AIO */
-#ifdef CONFIG_INOTIFY_USER
-	{
-		.procname	= "inotify",
-		.mode		= 0555,
-		.child		= inotify_table,
-	},
-#endif	
 #ifdef CONFIG_EPOLL
 	{
 		.procname	= "epoll",
-- 
1.7.5.134.g1c08b

