Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964809Ab2EWKko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 06:40:44 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39568 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab2EWKkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 06:40:36 -0400
Message-Id: <20120523104031.003232538@openvz.org>
User-Agent: quilt/0.48-1
Date: Wed, 23 May 2012 14:25:45 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>, ebiederm@xmission.com,
        tj@kernel.org, skinsbursky@openvz.org,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [rfc v2 4/7] fs, eventfd: Add procfs fdinfo helper
References: <20120523102541.382837149@openvz.org>
Content-Disposition: inline; filename=seq-fdinfo-eventfd-6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allow us to print out raw counter value.
The /proc/pid/fdinfo/fd output is

 | pos:	0
 | flags:	04002
 | eventfd-count:               5a

This feature is CONFIG_CHECKPOINT_RESTORE only.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: James Bottomley <jbottomley@parallels.com>
---
 fs/eventfd.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

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
@@ -437,3 +439,56 @@ SYSCALL_DEFINE1(eventfd, unsigned int, c
 	return sys_eventfd2(count, 0);
 }
 
+#if defined(CONFIG_PROC_FS) && defined(CONFIG_CHECKPOINT_RESTORE)
+
+static void *seq_start(struct seq_file *m, loff_t *pos)
+{
+	struct proc_fdinfo_extra *extra = m->private;
+	return *pos == 0 ? extra->f_file : NULL;
+}
+
+static void *seq_next(struct seq_file *m, void *p, loff_t *pos)
+{
+	++*pos;
+	return NULL;
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
+static void seq_stop(struct seq_file *p, void *v) { }
+
+static const struct seq_operations eventfd_fdinfo_ops = {
+	.start	= seq_start,
+	.next	= seq_next,
+	.stop	= seq_stop,
+	.show	= seq_show,
+};
+
+static int is_eventfd_file(struct file *file)
+{
+	return file->f_op == &eventfd_fops;
+}
+
+static struct proc_fdinfo_driver eventfd_fdinfo = {
+	.name	= "eventfd",
+	.ops	= &eventfd_fdinfo_ops,
+	.probe	= is_eventfd_file,
+};
+
+static int __init eventfd_init(void)
+{
+	return proc_register_fdinfo_driver(&eventfd_fdinfo);
+}
+fs_initcall(eventfd_init);
+
+#endif /* CONFIG_PROC_FS && CONFIG_CHECKPOINT_RESTORE */

