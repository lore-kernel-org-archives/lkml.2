Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967047Ab2EQQ01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:26:27 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39204 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760707Ab2EQQZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:25:39 -0400
Message-Id: <20120517162534.755208902@openvz.org>
User-Agent: quilt/0.48-1
Date: Thu, 17 May 2012 20:07:41 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        linux-fsdevel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [rfc 3/4] fs, eventfd: Add procfs fdinfo helper
References: <20120517160738.116113099@openvz.org>
Content-Disposition: inline; filename=seq-fdinfo-eventfd-2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allow us to print out raw counter value.
So the /proc/pid/fdinfo/fd look like

 | pos:	0
 | flags:	04002
 | eventfd-count:               5a

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 fs/eventfd.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

Index: linux-2.6.git/fs/eventfd.c
===================================================================
--- linux-2.6.git.orig/fs/eventfd.c
+++ linux-2.6.git/fs/eventfd.c
@@ -19,6 +19,8 @@
 #include <linux/export.h>
 #include <linux/kref.h>
 #include <linux/eventfd.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 
 struct eventfd_ctx {
 	struct kref kref;
@@ -437,3 +439,58 @@ SYSCALL_DEFINE1(eventfd, unsigned int, c
 	return sys_eventfd2(count, 0);
 }
 
+#ifdef CONFIG_PROC_FS
+
+static void *seq_start(struct seq_file *m, loff_t *pos)
+{
+	struct proc_fdinfo_extra *extra = m->private;
+	return *pos == 1 ? extra->fd_file : NULL;
+}
+
+static void seq_stop(struct seq_file *m, void *v)
+{
+}
+
+static void *seq_next(struct seq_file *m, void *p, loff_t *pos)
+{
+	struct proc_fdinfo_extra *extra = m->private;
+	return ++*pos == 1 ? extra->fd_file : NULL;
+}
+
+static int seq_show(struct seq_file *m, void *v)
+{
+	struct eventfd_ctx *ctx = ((struct file *)v)->private_data;
+
+	spin_lock_irq(&ctx->wqh.lock);
+	seq_printf(m, "eventfd-count: %16llx\n",
+		   (unsigned long long)ctx->count);
+	spin_unlock_irq(&ctx->wqh.lock);
+
+	return 0;
+}
+
+static const struct seq_operations eventfd_fdinfo_ops = {
+	.start	= seq_start,
+	.next	= seq_next,
+	.stop	= seq_stop,
+	.show	= seq_show,
+};
+
+static int eventfd_fdinfo_probe(struct file *file)
+{
+	return file->f_op == &eventfd_fops;
+}
+
+static struct proc_fdinfo_helper eventfd_fdinfo_helper = {
+	.name	= "evetfd",
+	.ops	= &eventfd_fdinfo_ops,
+	.probe	= eventfd_fdinfo_probe,
+};
+
+static int __init eventfd_init(void)
+{
+	return proc_register_fdinfo_helper(&eventfd_fdinfo_helper);
+}
+fs_initcall(eventfd_init);
+
+#endif /* CONFIG_PROC_FS */

