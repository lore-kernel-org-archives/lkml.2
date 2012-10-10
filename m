Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab2JJK7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 06:59:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33700 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752372Ab2JJK66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 06:58:58 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2/2] firmware: Add /proc/fw_path entry to list the firmware paths
Date: Wed, 10 Oct 2012 11:56:25 +0100
Message-Id: <1349866585-24883-3-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.12.2
In-Reply-To: <1349866585-24883-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1349866585-24883-1-git-send-email-dp@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides the aforementioned procfs file that lists
the default firmware paths that are used during firmware lookup.

The file contains a white space separated list of paths.

There will be another patch on top of this that adds the functionality
to modify the paths at runtime.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/firmware_class.c | 55 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 2153eab..22cef4d 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -27,6 +27,8 @@
 #include <linux/pm.h>
 #include <linux/suspend.h>
 #include <linux/syscore_ops.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 
 #include <generated/utsrelease.h>
 
@@ -1430,6 +1432,56 @@ err_fwp_alloc:
 	return -ENOMEM;
 }
 
+static void *fw_path_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	return seq_list_start_head(&fw_path_list, *pos);
+}
+
+static void *fw_path_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	return seq_list_next(v, &fw_path_list, pos);
+}
+
+static int fw_path_seq_show(struct seq_file *seq, void *v)
+{
+	const struct fw_path_rec *fwp;
+	struct list_head *l = v;
+
+	if (l == &fw_path_list)
+		return 0;
+	fwp = list_entry(v, struct fw_path_rec, list);
+	seq_puts(seq, fwp->name);
+	if (l->next != &fw_path_list)
+		seq_putc(seq, ' ');
+	else
+		seq_putc(seq, '\n');
+	return 0;
+}
+
+static void fw_path_seq_stop(struct seq_file *seq, void *v)
+{
+}
+
+static const struct seq_operations fw_path_ops = {
+	.start = fw_path_seq_start,
+	.next = fw_path_seq_next,
+	.stop = fw_path_seq_stop,
+	.show = fw_path_seq_show,
+};
+
+static int fw_path_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &fw_path_ops);
+}
+
+static const struct file_operations fw_path_seq_fops = {
+	.owner = THIS_MODULE,
+	.open = fw_path_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release,
+};
+
 static void __init fw_cache_init(void)
 {
 	spin_lock_init(&fw_cache.lock);
@@ -1465,6 +1517,8 @@ static int __init firmware_class_init(void)
 		return ret;
 	}
 
+	proc_create("fw_path", S_IRUGO, NULL, &fw_path_seq_fops);
+
 	return class_register(&firmware_class);
 }
 
@@ -1474,6 +1528,7 @@ static void __exit firmware_class_exit(void)
 	unregister_syscore_ops(&fw_syscore_ops);
 	unregister_pm_notifier(&fw_cache.pm_notify);
 #endif
+	remove_proc_entry("fw_path", NULL);
 	fw_free_path_list();
 	class_unregister(&firmware_class);
 }
-- 
1.7.12.2

