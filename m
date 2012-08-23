Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030419Ab2HWKtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:49:15 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43061 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933949Ab2HWKrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:47:33 -0400
Message-Id: <20120823104726.244520020@openvz.org>
User-Agent: quilt/0.48-1
Date: Thu, 23 Aug 2012 14:43:32 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 9/9] fdinfo: Show sigmask for signalfd fd v2
References: <20120823104323.040550004@openvz.org>
Content-Disposition: inline; filename=seq-fdinfo-signalfd-3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: James Bottomley <jbottomley@parallels.com>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Matthew Helsley <matt.helsley@gmail.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/proc/array.c         |    2 +-
 fs/signalfd.c           |   26 ++++++++++++++++++++++++++
 include/linux/proc_fs.h |    3 +++
 3 files changed, 30 insertions(+), 1 deletion(-)

Index: linux-2.6.git/fs/proc/array.c
===================================================================
--- linux-2.6.git.orig/fs/proc/array.c
+++ linux-2.6.git/fs/proc/array.c
@@ -220,7 +220,7 @@ static inline void task_state(struct seq
 	seq_putc(m, '\n');
 }
 
-static void render_sigset_t(struct seq_file *m, const char *header,
+void render_sigset_t(struct seq_file *m, const char *header,
 				sigset_t *set)
 {
 	int i;
Index: linux-2.6.git/fs/signalfd.c
===================================================================
--- linux-2.6.git.orig/fs/signalfd.c
+++ linux-2.6.git/fs/signalfd.c
@@ -29,6 +29,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/signalfd.h>
 #include <linux/syscalls.h>
+#include <linux/proc_fs.h>
 
 void signalfd_cleanup(struct sighand_struct *sighand)
 {
@@ -46,6 +47,7 @@ void signalfd_cleanup(struct sighand_str
 }
 
 struct signalfd_ctx {
+	seqcount_t cnt;
 	sigset_t sigmask;
 };
 
@@ -227,7 +229,28 @@ static ssize_t signalfd_read(struct file
 	return total ? total: ret;
 }
 
+#ifdef CONFIG_PROC_FS
+static int signalfd_show_fdinfo(struct seq_file *m, struct file *f)
+{
+	struct signalfd_ctx *ctx = f->private_data;
+	sigset_t sigmask;
+	unsigned seq;
+
+	do {
+		seq = read_seqcount_begin(&ctx->cnt);
+		sigmask = ctx->sigmask;
+	} while (read_seqcount_retry(&ctx->cnt, seq));
+
+	signotset(&sigmask);
+	render_sigset_t(m, "sigmask:\t", &sigmask);
+	return 0;
+}
+#endif
+
 static const struct file_operations signalfd_fops = {
+#ifdef CONFIG_PROC_FS
+	.show_fdinfo	= signalfd_show_fdinfo,
+#endif
 	.release	= signalfd_release,
 	.poll		= signalfd_poll,
 	.read		= signalfd_read,
@@ -259,6 +282,7 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sig
 			return -ENOMEM;
 
 		ctx->sigmask = sigmask;
+		seqcount_init(&ctx->cnt);
 
 		/*
 		 * When we call this, the initialization must be complete, since
@@ -279,7 +303,9 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sig
 			return -EINVAL;
 		}
 		spin_lock_irq(&current->sighand->siglock);
+		write_seqcount_begin(&ctx->cnt);
 		ctx->sigmask = sigmask;
+		write_seqcount_end(&ctx->cnt);
 		spin_unlock_irq(&current->sighand->siglock);
 
 		wake_up(&current->sighand->signalfd_wqh);
Index: linux-2.6.git/include/linux/proc_fs.h
===================================================================
--- linux-2.6.git.orig/include/linux/proc_fs.h
+++ linux-2.6.git/include/linux/proc_fs.h
@@ -290,4 +290,7 @@ static inline struct net *PDE_NET(struct
 	return pde->parent->data;
 }
 
+#include <asm/signal.h>
+
+void render_sigset_t(struct seq_file *m, const char *header, sigset_t *set);
 #endif /* _LINUX_PROC_FS_H */

