Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab0D1Ecm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 00:32:42 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:57985 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab0D1Ec2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 00:32:28 -0400
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>
Subject: [PATCH 4/8] PM: suspend_block: Add debugfs file
Date: Tue, 27 Apr 2010 21:31:55 -0700
Message-Id: <1272429119-12103-5-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1272429119-12103-4-git-send-email-arve@android.com>
References: <1272429119-12103-1-git-send-email-arve@android.com>
 <1272429119-12103-2-git-send-email-arve@android.com>
 <1272429119-12103-3-git-send-email-arve@android.com>
 <1272429119-12103-4-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Report active and inactive suspend blockers in
/sys/kernel/debug/suspend_blockers.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 kernel/power/suspend_blocker.c |   44 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/kernel/power/suspend_blocker.c b/kernel/power/suspend_blocker.c
index 9459361..ee43490 100644
--- a/kernel/power/suspend_blocker.c
+++ b/kernel/power/suspend_blocker.c
@@ -17,6 +17,7 @@
 #include <linux/rtc.h>
 #include <linux/suspend.h>
 #include <linux/suspend_blocker.h>
+#include <linux/debugfs.h>
 #include "power.h"
 
 enum {
@@ -41,6 +42,7 @@ struct workqueue_struct *suspend_work_queue;
 struct suspend_blocker main_suspend_blocker;
 static suspend_state_t requested_suspend_state = PM_SUSPEND_MEM;
 static bool enable_suspend_blockers;
+static struct dentry *suspend_blocker_stats_dentry;
 
 #define pr_info_time(fmt, args...) \
 	do { \
@@ -54,6 +56,21 @@ static bool enable_suspend_blockers;
 			tm.tm_hour, tm.tm_min, tm.tm_sec, ts.tv_nsec); \
 	} while (0);
 
+static int suspend_blocker_stats_show(struct seq_file *m, void *unused)
+{
+	unsigned long irqflags;
+	struct suspend_blocker *blocker;
+
+	seq_puts(m, "name\tactive\n");
+	spin_lock_irqsave(&list_lock, irqflags);
+	list_for_each_entry(blocker, &inactive_blockers, link)
+		seq_printf(m, "\"%s\"\t0\n", blocker->name);
+	list_for_each_entry(blocker, &active_blockers, link)
+		seq_printf(m, "\"%s\"\t1\n", blocker->name);
+	spin_unlock_irqrestore(&list_lock, irqflags);
+	return 0;
+}
+
 static void print_active_blockers_locked(void)
 {
 	struct suspend_blocker *blocker;
@@ -105,8 +122,8 @@ static DECLARE_WORK(suspend_work, suspend_worker);
 /**
  * suspend_blocker_init() - Initialize a suspend blocker
  * @blocker:	The suspend blocker to initialize.
- * @name:	The name of the suspend blocker to show in debug messages.
- *
+ * @name:	The name of the suspend blocker to show in debug messages and
+ *		/sys/kernel/debug/suspend_blockers.
  * The suspend blocker struct and name must not be freed before calling
  * suspend_blocker_destroy.
  */
@@ -255,6 +272,19 @@ int request_suspend_state(suspend_state_t state)
 	return 0;
 }
 
+static int suspend_blocker_stats_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, suspend_blocker_stats_show, NULL);
+}
+
+static const struct file_operations suspend_blocker_stats_fops = {
+	.owner = THIS_MODULE,
+	.open = suspend_blocker_stats_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
 static int __init suspend_block_init(void)
 {
 	suspend_work_queue = create_singlethread_workqueue("suspend");
@@ -266,4 +296,14 @@ static int __init suspend_block_init(void)
 	return 0;
 }
 
+static int __init suspend_block_postcore_init(void)
+{
+	if (!suspend_work_queue)
+		return 0;
+	suspend_blocker_stats_dentry = debugfs_create_file("suspend_blockers",
+			S_IRUGO, NULL, NULL, &suspend_blocker_stats_fops);
+	return 0;
+}
+
 core_initcall(suspend_block_init);
+postcore_initcall(suspend_block_postcore_init);
-- 
1.6.5.1

