Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab0ENENI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 00:13:08 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:52482 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab0ENELg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 00:11:36 -0400
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/8] PM: suspend_block: Add debugfs file
Date: Thu, 13 May 2010 21:11:09 -0700
Message-Id: <1273810273-3039-5-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1273810273-3039-4-git-send-email-arve@android.com>
References: <1273810273-3039-1-git-send-email-arve@android.com>
 <1273810273-3039-2-git-send-email-arve@android.com>
 <1273810273-3039-3-git-send-email-arve@android.com>
 <1273810273-3039-4-git-send-email-arve@android.com>
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
 kernel/power/opportunistic_suspend.c |   43 +++++++++++++++++++++++++++++++++-
 1 files changed, 42 insertions(+), 1 deletions(-)

diff --git a/kernel/power/opportunistic_suspend.c b/kernel/power/opportunistic_suspend.c
index acc1651..c2dad76 100644
--- a/kernel/power/opportunistic_suspend.c
+++ b/kernel/power/opportunistic_suspend.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/rtc.h>
 #include <linux/suspend.h>
+#include <linux/debugfs.h>
 
 #include "power.h"
 
@@ -138,7 +139,8 @@ EXPORT_SYMBOL(suspend_blocker_register);
 /**
  * suspend_blocker_init - Initialize a suspend blocker's name and register it.
  * @blocker: Suspend blocker to initialize.
- * @name:    The name of the suspend blocker to show in debug messages.
+ * @name:    The name of the suspend blocker to show in debug messages and
+ *	     /sys/kernel/debug/suspend_blockers.
  *
  * The suspend blocker struct and name must not be freed before calling
  * suspend_blocker_unregister().
@@ -282,3 +284,42 @@ void __init opportunistic_suspend_init(void)
 	suspend_blocker_register(&main_suspend_blocker);
 	suspend_block(&main_suspend_blocker);
 }
+
+static struct dentry *suspend_blocker_stats_dentry;
+
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
+static int __init suspend_blocker_debugfs_init(void)
+{
+	suspend_blocker_stats_dentry = debugfs_create_file("suspend_blockers",
+			S_IRUGO, NULL, NULL, &suspend_blocker_stats_fops);
+	return 0;
+}
+
+postcore_initcall(suspend_blocker_debugfs_init);
-- 
1.6.5.1

