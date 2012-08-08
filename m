Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab2HHXIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 19:08:19 -0400
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:47073 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758821Ab2HHXIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 19:08:05 -0400
From: Fernando Guzman Lugo <fernando.lugo@ti.com>
To: <ohad@wizery.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>
Subject: [PATCH 3/3] remoteproc: create debugfs entry to disable/enable recovery dynamically
Date: Wed,  8 Aug 2012 18:07:44 -0500
Message-Id: <1344467264-5128-4-git-send-email-fernando.lugo@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1344467264-5128-1-git-send-email-fernando.lugo@ti.com>
References: <1344467264-5128-1-git-send-email-fernando.lugo@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a debugfs entry (named recovery) so that recovery can be disabled
dynamically at runtime. This entry is very useful when you are trying to
debug a rproc crash. Without this a recovery will take place making
impossible to debug the issue.

Original idea from Ohad Ben-Cohen and contributions from
Subramaniam Chanderashekarapuram

Example:
-disabling recovery:
$ echo disabled > <debugfs>/remoteproc/remoteproc0/recovery

-enabling recovery:
$ echo enabled > <debugfs>/remoteproc/remoteproc0/recovery

-in case you have disabled recovery and you want to continue
 debugging you can recover the remoteproc once using recover.
 This will not change the state of the recovery entry, it will
 only recovery the rproc if its state is RPROC_CRASHED
$ echo recover > <debugfs>/remoteproc/remoteproc0/recovery

Signed-off-by: Fernando Guzman Lugo <fernando.lugo@ti.com>
---
 drivers/remoteproc/remoteproc_core.c    |    3 +-
 drivers/remoteproc/remoteproc_debugfs.c |   83 +++++++++++++++++++++++++++++++
 include/linux/remoteproc.h              |    2 +
 3 files changed, 87 insertions(+), 1 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index c879069..0b52169 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -932,7 +932,8 @@ static void rproc_crash_handler_work(struct work_struct *work)
 		++rproc->crash_cnt, rproc->name);
 	mutex_unlock(&rproc->lock);
 
-	rproc_trigger_recover(rproc);
+	if (!rproc->recovery_disabled)
+		rproc_trigger_recover(rproc);
 }
 
 /**
diff --git a/drivers/remoteproc/remoteproc_debugfs.c b/drivers/remoteproc/remoteproc_debugfs.c
index 0383385..aa95cde 100644
--- a/drivers/remoteproc/remoteproc_debugfs.c
+++ b/drivers/remoteproc/remoteproc_debugfs.c
@@ -28,6 +28,9 @@
 #include <linux/debugfs.h>
 #include <linux/remoteproc.h>
 #include <linux/device.h>
+#include <linux/uaccess.h>
+
+#include "remoteproc_internal.h"
 
 /* remoteproc debugfs parent dir */
 static struct dentry *rproc_dbg;
@@ -111,6 +114,84 @@ static const struct file_operations rproc_name_ops = {
 	.llseek	= generic_file_llseek,
 };
 
+/* expose recovery flag via debugfs */
+static ssize_t rproc_recovery_read(struct file *filp, char __user *userbuf,
+		size_t count, loff_t *ppos)
+{
+	struct rproc *rproc = filp->private_data;
+	char *buf = rproc->recovery_disabled ? "disabled\n" : "enabled\n";
+
+	return simple_read_from_buffer(userbuf, count, ppos, buf, strlen(buf));
+}
+
+
+/*
+ * Writing to the recovey debugfs entry we can change the behavior of the
+ * recovery dynamically. The default value of this entry is "enabled".
+ *
+ * There are 3 possible options you can write to the recovery debug entry:
+ * "enabled", "disabled" and "recover"
+ *
+ * enabled:	In this case recovery will be enabled, every time there is a
+ *		rproc crashed the rproc will be recovered. If recovery has been
+ *		disabled and it crashed and you enable recovery it will be
+ *		recover as soon as you enable recovery.
+ * disabled:	In this case recovery will be disabled, that means if a rproc
+ *		crashes it will remain in crashed state. Therefore the rproc
+ *		won't be functional any more. But this option is used for
+ *		debugging purposes. Otherwise, debugging a crash would not be
+ *		possible.
+ * recover:	This function will trigger a recovery without taking care of
+ *		the recovery state (enabled/disabled) and without changing it.
+ *		This useful for the cases when you are debugging a crash and
+ *		after enabling recovery you get another crash immediately. As
+ *		the recovery state will be enabled it will recover the rproc
+ *		without let you debug the new crash. So, it is recommended to
+ *		disabled recovery, then starting debugging and use "recovery"
+ *		command while still debugging and when you are done then you
+ *		case use enabled command.
+ */
+static ssize_t rproc_recovery_write(struct file *filp,
+		const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	struct rproc *rproc = filp->private_data;
+	char buf[10];
+	int ret;
+
+	if (count > sizeof(buf))
+		return count;
+
+	ret = copy_from_user(buf, user_buf, count);
+	if (ret)
+		return ret;
+
+	/* remove end of line */
+	if (buf[count - 1] == '\n')
+		buf[count - 1] = '\0';
+
+	if (!strncmp(buf, "enabled", count)) {
+		rproc->recovery_disabled = false;
+		/* if rproc has crashed trigger recovery */
+		if (rproc->state == RPROC_CRASHED)
+			rproc_trigger_recover(rproc);
+	} else if (!strncmp(buf, "disabled", count)) {
+		rproc->recovery_disabled = true;
+	} else if (!strncmp(buf, "recover", count)) {
+		/* if rproc has crashed trigger recovery */
+		if (rproc->state == RPROC_CRASHED)
+			rproc_trigger_recover(rproc);
+	}
+
+	return count;
+}
+
+static const struct file_operations rproc_recovery_ops = {
+	.read = rproc_recovery_read,
+	.write = rproc_recovery_write,
+	.open = simple_open,
+	.llseek = generic_file_llseek,
+};
+
 void rproc_remove_trace_file(struct dentry *tfile)
 {
 	debugfs_remove(tfile);
@@ -154,6 +235,8 @@ void rproc_create_debug_dir(struct rproc *rproc)
 					rproc, &rproc_name_ops);
 	debugfs_create_file("state", 0400, rproc->dbg_dir,
 					rproc, &rproc_state_ops);
+	debugfs_create_file("recovery", 0400, rproc->dbg_dir,
+					rproc, &rproc_recovery_ops);
 }
 
 void __init rproc_init_debugfs(void)
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index a46ed27..1f73c75 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -398,6 +398,7 @@ enum rproc_crash_type {
  * @index: index of this rproc device
  * @crash_handler: workqueue for handling a crash
  * @crash_cnt: crash counter
+ * @recovery_disabled: flag that state if recovery was disabled
  */
 struct rproc {
 	struct klist_node node;
@@ -423,6 +424,7 @@ struct rproc {
 	int index;
 	struct work_struct crash_handler;
 	unsigned crash_cnt;
+	bool recovery_disabled;
 };
 
 /* we currently support only two vrings per rvdev */
-- 
1.7.1

