Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab0IWOBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 10:01:33 -0400
Received: from mtagate7.de.ibm.com ([195.212.17.167]:51382 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab0IWOBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 10:01:31 -0400
Subject: [RFC][PATCH 05/10] taskstats: Add "/proc/taskstats"
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1285249681.1837.28.camel@holzheu-laptop>
References: <1285249681.1837.28.camel@holzheu-laptop>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Thu, 23 Sep 2010 16:01:27 +0200
Message-ID: <1285250487.1837.89.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] taskstats: Add "/proc/taskstats"

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

Add procfs interface for the TASKSTATS_CMD_ATTR_PIDS taskstats command. A new
procfs file "/proc/taskstats" is introduced. With a ioctl the taskstats
command is defined. With a subsequent read system call the defined command
is executed and the result of the command is transferred into the read buffer.
This allows to get a complete and consistent snapshot with all tasks via two
system calls (ioctl + read), when a sufficiently large buffer is provided.
This is not possible with the existing netlink interface, because there we
have the socket buffer size as restricting factor.

GOALS OF THIS PATCH
-------------------
* Allow transfer of a complete and consistent taskstats snapshot to user space.
* Reduce CPU time for data transmission compared to netlink mechanism,
  because the proc solution is much more lightweight.
* User space code is much easier to write compared to netlink mechanism.

OPEN ISSUES
-----------
Currently only the TASKSTATS_CMD_ATTR_PIDS command is implemented. Implement
the following missing taskstasts commands:
* TASKSTATS_CMD_ATTR_PID
* TASKSTATS_CMD_ATTR_TGID

Use "_IOW()" macros for ioctl definition. For example:
* #define TASKSTATS_IOCTL_PIDS _IOW('t', 1, struct taskstats_cmd_pids)
* #define TASKSTATS_IOCTL_PID  _IOW('t', 2, int)

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 include/linux/taskstats_kern.h |    3 +
 kernel/Makefile                |    3 -
 kernel/taskstats.c             |    1 
 kernel/taskstats_proc.c        |   99 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 105 insertions(+), 1 deletion(-)

Index: git-linux-2.6/include/linux/taskstats_kern.h
===================================================================
--- git-linux-2.6.orig/include/linux/taskstats_kern.h	2010-09-23 14:16:17.000000000 +0200
+++ git-linux-2.6/include/linux/taskstats_kern.h	2010-09-23 14:16:23.000000000 +0200
@@ -32,6 +32,7 @@
 				  struct taskstats *stats);
 extern void taskstats_fill_sleep(struct task_struct *tsk,
 				 struct taskstats *stats);
+extern void taskstats_proc_init(void);
 #else
 static inline void taskstats_exit(struct task_struct *tsk, int group_dead)
 {}
@@ -39,6 +40,8 @@
 {}
 static inline void taskstats_init_early(void)
 {}
+static inline void taskstats_proc_init(void)
+{}
 #endif /* CONFIG_TASKSTATS */
 
 #endif
Index: git-linux-2.6/kernel/Makefile
===================================================================
--- git-linux-2.6.orig/kernel/Makefile	2010-09-23 14:16:17.000000000 +0200
+++ git-linux-2.6/kernel/Makefile	2010-09-23 14:16:23.000000000 +0200
@@ -89,7 +89,8 @@
 obj-$(CONFIG_RELAY) += relay.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
-obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o taskstats_snap.o
+obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o taskstats_snap.o \
+			   taskstats_proc.o
 obj-$(CONFIG_TRACEPOINTS) += tracepoint.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
 obj-$(CONFIG_BINFMT_ELF) += elfcore.o
Index: git-linux-2.6/kernel/taskstats.c
===================================================================
--- git-linux-2.6.orig/kernel/taskstats.c	2010-09-23 14:16:17.000000000 +0200
+++ git-linux-2.6/kernel/taskstats.c	2010-09-23 14:16:23.000000000 +0200
@@ -727,6 +727,7 @@
 	rc = genl_register_ops(&family, &cgroupstats_ops);
 	if (rc < 0)
 		goto err_cgroup_ops;
+	taskstats_proc_init();
 	family_registered = 1;
 	printk("registered taskstats version %d\n", TASKSTATS_GENL_VERSION);
 	return 0;
Index: git-linux-2.6/kernel/taskstats_proc.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ git-linux-2.6/kernel/taskstats_proc.c	2010-09-23 14:16:23.000000000 +0200
@@ -0,0 +1,99 @@
+/*
+ * taskstats_proc.c - Export per-task statistics to userland using procfs
+ *
+ * Copyright IBM Corp. 2010
+ * Author(s): Michael Holzheu <holzheu@linux.vnet.ibm.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/taskstats_kern.h>
+#include <linux/proc_fs.h>
+#include <linux/file.h>
+#include <asm/uaccess.h>
+
+static ssize_t cmd_attr_pids_proc(struct taskstats *stats_vec,
+				  struct taskstats_cmd_pids *cmd_pids)
+{
+	int rc;
+
+	rc = taskstats_snap_user(cmd_pids->pid, cmd_pids->cnt,
+				 cmd_pids->time_ns, stats_vec);
+	if (rc < 0)
+		return rc;
+	else
+		return rc * sizeof(struct taskstats);
+}
+
+struct proc_cmd {
+	int	no;
+	union {
+		struct taskstats_cmd_pids cmd_pids;
+		__u32	pid;
+	} d;
+};
+
+static int proc_taskstats_open(struct inode *inode, struct file *file)
+{
+	struct proc_cmd *proc_cmd;
+
+	proc_cmd = kmalloc(sizeof(*proc_cmd), GFP_KERNEL);
+	if (!proc_cmd)
+		return -ENOMEM;
+	proc_cmd->no = -1;
+	file->private_data = proc_cmd;
+	return 0;
+}
+
+static int proc_taskstats_close(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+	return 0;
+}
+
+static long proc_taskstats_ioctl(struct file *file, unsigned int no,
+				 unsigned long data)
+{
+	struct proc_cmd *proc_cmd = file->private_data;
+	int rc = 0;
+
+	switch (no) {
+	case TASKSTATS_CMD_ATTR_PIDS:
+		proc_cmd->no = no;
+		if (copy_from_user(&proc_cmd->d.cmd_pids, (void *) data,
+				   sizeof(proc_cmd->d.cmd_pids)))
+			rc = -EFAULT;
+		break;
+	default:
+		rc = -EINVAL;
+		break;
+	}
+	return rc;
+}
+
+static ssize_t proc_taskstats_read(struct file *file, char __user *buf,
+				   size_t size, loff_t *ppos)
+{
+	struct proc_cmd *proc_cmd = file->private_data;
+
+	switch (proc_cmd->no) {
+	case TASKSTATS_CMD_ATTR_PIDS:
+		if (*ppos != 0)
+			return -EINVAL;
+		return cmd_attr_pids_proc((struct taskstats *) buf,
+					  &proc_cmd->d.cmd_pids);
+	default:
+		return -EINVAL;
+	}
+}
+
+static const struct file_operations proc_taskstats_ops = {
+	.open		= proc_taskstats_open,
+	.release	= proc_taskstats_close,
+	.read		= proc_taskstats_read,
+	.unlocked_ioctl	= proc_taskstats_ioctl,
+};
+
+void __init taskstats_proc_init(void)
+{
+	proc_create("taskstats", 0444, NULL, &proc_taskstats_ops);
+}



