Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab2JWMyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 08:54:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51369 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757006Ab2JWMyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 08:54:45 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2/3 v2] firmware: Add /proc/firmware_path entry to list the firmware paths
Date: Tue, 23 Oct 2012 13:52:55 +0100
Message-Id: <1350996776-17864-3-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1350996776-17864-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1350996776-17864-1-git-send-email-dp@opensource.wolfsonmicro.com>
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
index d76152b..322fff3 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -27,6 +27,8 @@
 #include <linux/pm.h>
 #include <linux/suspend.h>
 #include <linux/syscore_ops.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 
 #include <generated/utsrelease.h>
 
@@ -1468,6 +1470,56 @@ err_fwp_alloc:
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
@@ -1501,6 +1553,8 @@ static int __init firmware_class_init(void)
 		return ret;
 	}
 
+	proc_create("firmware_path", S_IRUGO, NULL, &fw_path_seq_fops);
+
 	return class_register(&firmware_class);
 }
 
@@ -1510,6 +1564,7 @@ static void __exit firmware_class_exit(void)
 	unregister_syscore_ops(&fw_syscore_ops);
 	unregister_pm_notifier(&fw_cache.pm_notify);
 #endif
+	remove_proc_entry("firmware_path", NULL);
 	fw_free_path_list();
 	class_unregister(&firmware_class);
 }
-- 
1.8.0

