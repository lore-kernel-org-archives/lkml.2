Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab0KKRIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 12:08:23 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:49963 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab0KKRIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:08:18 -0500
Message-Id: <20101111170814.229165018@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Thu, 11 Nov 2010 18:03:54 +0100
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [RFC][PATCH v2 2/7] taskstats: Add "/proc/taskstats"
References: <20101111170352.732381138@linux.vnet.ibm.com>
Content-Disposition: inline; filename=02-taskstats-top-proc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

CHANGE HISTORY OF THIS PATCH
----------------------------
Version 2
---------
Replace ioctl interface with write interface (requested by Andrew Morton)

The taskstats command is now set by one sys_write() with a buffer that
contains first the taskstats command number (32 bit) and directly after that
number the command payload.

DESCRIPTION
-----------
Add procfs interface for the TASKSTATS_CMD_ATTR_PIDS taskstats command. A new
procfs file "/proc/taskstats" is introduced. With sys_write() the taskstats
command is defined. With a subsequent read system call the defined command
is executed and the result of the command is transferred into the read buffer.
This allows to get a complete and consistent snapshot with all tasks via two
system calls (write + read), when a sufficiently large buffer is provided.
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

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 include/linux/taskstats_kern.h |    3 +
 kernel/Makefile                |    3 -
 kernel/taskstats.c             |    1 
 kernel/taskstats_proc.c        |  107 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 113 insertions(+), 1 deletion(-)

--- a/include/linux/taskstats_kern.h
+++ b/include/linux/taskstats_kern.h
@@ -32,6 +32,7 @@ extern void taskstats_fill_atomic(struct
 				  struct taskstats *stats);
 extern void taskstats_fill_sleep(struct task_struct *tsk,
 				 struct taskstats *stats);
+extern void taskstats_proc_init(void);
 #else
 static inline void taskstats_exit(struct task_struct *tsk, int group_dead)
 {}
@@ -39,6 +40,8 @@ static inline void taskstats_tgid_free(s
 {}
 static inline void taskstats_init_early(void)
 {}
+static inline void taskstats_proc_init(void)
+{}
 #endif /* CONFIG_TASKSTATS */
 
 #endif
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -90,7 +90,8 @@ obj-$(CONFIG_TINY_PREEMPT_RCU) += rcutin
 obj-$(CONFIG_RELAY) += relay.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
-obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o taskstats_snap.o
+obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o taskstats_snap.o \
+			   taskstats_proc.o
 obj-$(CONFIG_TRACEPOINTS) += tracepoint.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
 obj-$(CONFIG_BINFMT_ELF) += elfcore.o
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -733,6 +733,7 @@ static int __init taskstats_init(void)
 	rc = genl_register_ops(&family, &cgroupstats_ops);
 	if (rc < 0)
 		goto err_cgroup_ops;
+	taskstats_proc_init();
 	family_registered = 1;
 	printk("registered taskstats version %d\n", TASKSTATS_GENL_VERSION);
 	return 0;
--- /dev/null
+++ b/kernel/taskstats_proc.c
@@ -0,0 +1,107 @@
+/*
+ * taskstats_proc.c - Export per-task statistics to userland using procfs
+ *
+ * Copyright IBM Corp. 2010
+ * Author(s): Michael Holzheu <holzheu@linux.vnet.ibm.com>
+ */
+
+#include <linux/taskstats_kern.h>
+#include <linux/proc_fs.h>
+#include <linux/kernel.h>
+#include <linux/file.h>
+#include <asm/uaccess.h>
+
+struct proc_cmd {
+	u32 no;
+	union {
+		struct taskstats_cmd_pids cmd_pids;
+		u32 pid;
+	} d;
+};
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
+static ssize_t proc_taskstats_write(struct file *file,
+				    const char __user *buf, size_t count,
+				    loff_t *ppos)
+{
+	struct proc_cmd *proc_cmd = file->private_data;
+	u32 no;
+
+	if (*ppos != 0)
+		return -EINVAL;
+	if (count < sizeof(no))
+		return -EINVAL;
+	if (copy_from_user(&no, buf, sizeof(no)))
+		return -EFAULT;
+	switch (no) {
+	case TASKSTATS_CMD_ATTR_PIDS:
+		if (count - sizeof(no) < sizeof(proc_cmd->d.cmd_pids))
+		    	return -EINVAL;
+		if (copy_from_user(&proc_cmd->d.cmd_pids, buf + sizeof(no),
+				   sizeof(proc_cmd->d.cmd_pids)))
+			return -EFAULT;
+		break;
+	default:
+		return -EINVAL;
+	}
+	proc_cmd->no = no;
+	return count;
+}
+
+static ssize_t proc_taskstats_read(struct file *file, char __user *buf,
+				   size_t size, loff_t *ppos)
+{
+	struct proc_cmd *proc_cmd = file->private_data;
+
+	if (*ppos != 0)
+		return -EINVAL;
+	switch (proc_cmd->no) {
+	case TASKSTATS_CMD_ATTR_PIDS:
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
+	.write		= proc_taskstats_write,
+};
+
+void __init taskstats_proc_init(void)
+{
+	proc_create("taskstats", 0666, NULL, &proc_taskstats_ops);
+}

