Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab2KMQVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 11:21:05 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:53146 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab2KMQVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:21:03 -0500
Date: Tue, 13 Nov 2012 20:20:56 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <jbottomley@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + fs-epoll-add-procfs-fdinfo-helper.patch added to -mm tree
Message-ID: <20121113162056.GK7808@moon>
References: <20121113145050.GA13691@redhat.com>
 <20121113155313.GU6511@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121113155313.GU6511@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 07:53:13PM +0400, Cyrill Gorcunov wrote:
> On Tue, Nov 13, 2012 at 03:50:50PM +0100, Oleg Nesterov wrote:
> > This doesn't look right.
> > 
> > The problem is, the current locking is broken, ->siglock can not serialize
> > ->sigmask changes. Just suppose the the child inherits sigfd from parent
> > and they both do sys_signalfd4() at the same time.
> > 
> > Nothing really bad can happen, that is why nobody bothers to fix this.
> > But this patch makes the thing worse, write_seqcount_begin() must be
> > serialized correctly.
> 
> Thanks a lot, Oleg! I'll update.

Something like below?
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: fdinfo: Show sigmask for signalfd fd v3

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
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
 fs/signalfd.c           |   24 ++++++++++++++++++++++++
 include/linux/proc_fs.h |    3 +++
 3 files changed, 28 insertions(+), 1 deletion(-)

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
+	rwlock_t lock;
 	sigset_t sigmask;
 };
 
@@ -227,7 +229,26 @@ static ssize_t signalfd_read(struct file
 	return total ? total: ret;
 }
 
+#ifdef CONFIG_PROC_FS
+static int signalfd_show_fdinfo(struct seq_file *m, struct file *f)
+{
+	struct signalfd_ctx *ctx = f->private_data;
+	sigset_t sigmask;
+
+	read_lock(&ctx->lock);
+	sigmask = ctx->sigmask;
+	read_unlock(&ctx->lock);
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
@@ -259,6 +280,7 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sig
 			return -ENOMEM;
 
 		ctx->sigmask = sigmask;
+		rwlock_init(&ctx->lock);
 
 		/*
 		 * When we call this, the initialization must be complete, since
@@ -278,7 +300,9 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sig
 			return -EINVAL;
 		}
 		spin_lock_irq(&current->sighand->siglock);
+		write_lock(&ctx->lock);
 		ctx->sigmask = sigmask;
+		write_unlock(&ctx->lock);
 		spin_unlock_irq(&current->sighand->siglock);
 
 		wake_up(&current->sighand->signalfd_wqh);
Index: linux-2.6.git/include/linux/proc_fs.h
===================================================================
--- linux-2.6.git.orig/include/linux/proc_fs.h
+++ linux-2.6.git/include/linux/proc_fs.h
@@ -290,4 +290,7 @@ static inline struct net *PDE_NET(struct
 	return pde->parent->data;
 }
 
+#include <linux/signal.h>
+
+void render_sigset_t(struct seq_file *m, const char *header, sigset_t *set);
 #endif /* _LINUX_PROC_FS_H */
