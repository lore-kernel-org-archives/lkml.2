Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab1EHWxr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:53:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47346 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932492Ab1EHWlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:41:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=s8FXRHRAmRkVovFobz2sOB86U2r0zK1EvYabzA2nTI3xTuGfTuIwTEsBt9AGeiBAzT
         mx8QworWGNgbD6J8WOU0Q2KvMuqooQfFaH4wfJsTQuSChVI2id6hDl2x43pXzMy8ab+h
         hvDsuUuhcJnDOTf2LhPYXRuBTbcPD4J3hGv6w=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 058/115] sysctl: no-child: manually register fs/inotify
Date: Mon,  9 May 2011 00:39:10 +0200
Message-Id: <1304894407-32201-59-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
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
index 33d5e2e..9520e2b 100644
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

