Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab1HBSrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 14:47:14 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:37579 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab1HBSrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 14:47:07 -0400
From: Vladimir Zapolskiy <vzapolskiy@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Vladimir Zapolskiy <vzapolskiy@gmail.com>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] connector: add comm change event report to proc connector
Date: Tue,  2 Aug 2011 21:46:51 +0300
Message-Id: <1312310811-17327-1-git-send-email-vzapolskiy@gmail.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds an event to monitor comm value changes of tasks. Such
an event becomes vital, if someone desires to control threads of a
process in different manner.

A natural characteristic of threads is its comm value, and helpfully
application developers have an opportunity to change it in runtime.
Reporting about such events via proc connector allows to fine-grain
monitoring and control potentials, for instance a process control
daemon listening to proc connector and following comm value policies
can place specific threads to assigned cgroup partitions.

It might be possible to achieve a pale partial one-shot likeness
without this update, if an application changes comm value of a thread
generator task beforehand, then a new thread is cloned, and after
that proc connector listener gets the fork event and reads new
thread's comm value from procfs stat file, but this change visibly
simplifies and extends the matter.

Signed-off-by: Vladimir Zapolskiy <vzapolskiy@gmail.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/connector/cn_proc.c |   26 ++++++++++++++++++++++++++
 include/linux/cn_proc.h     |   11 +++++++++++
 kernel/sys.c                |    1 +
 3 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 3ee1fdb..f80ebd9 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -201,6 +201,32 @@ void proc_ptrace_connector(struct task_struct *task, int ptrace_id)
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
+void proc_comm_connector(struct task_struct *task)
+{
+	struct cn_msg *msg;
+	struct proc_event *ev;
+	struct timespec ts;
+	__u8 buffer[CN_PROC_MSG_SIZE];
+
+	if (atomic_read(&proc_event_num_listeners) < 1)
+		return;
+
+	msg = (struct cn_msg *)buffer;
+	ev = (struct proc_event *)msg->data;
+	get_seq(&msg->seq, &ev->cpu);
+	ktime_get_ts(&ts); /* get high res monotonic timestamp */
+	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
+	ev->what = PROC_EVENT_COMM;
+	ev->event_data.comm.process_pid  = task->pid;
+	ev->event_data.comm.process_tgid = task->tgid;
+	get_task_comm(ev->event_data.comm.comm, task);
+
+	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
+	msg->ack = 0; /* not used */
+	msg->len = sizeof(*ev);
+	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
+}
+
 void proc_exit_connector(struct task_struct *task)
 {
 	struct cn_msg *msg;
diff --git a/include/linux/cn_proc.h b/include/linux/cn_proc.h
index 12c517b..d03612b 100644
--- a/include/linux/cn_proc.h
+++ b/include/linux/cn_proc.h
@@ -54,6 +54,7 @@ struct proc_event {
 		PROC_EVENT_GID  = 0x00000040,
 		PROC_EVENT_SID  = 0x00000080,
 		PROC_EVENT_PTRACE = 0x00000100,
+		PROC_EVENT_COMM = 0x00000200,
 		/* "next" should be 0x00000400 */
 		/* "last" is the last process event: exit */
 		PROC_EVENT_EXIT = 0x80000000
@@ -103,6 +104,12 @@ struct proc_event {
 			__kernel_pid_t tracer_tgid;
 		} ptrace;
 
+		struct comm_proc_event {
+			__kernel_pid_t process_pid;
+			__kernel_pid_t process_tgid;
+			char           comm[16];
+		} comm;
+
 		struct exit_proc_event {
 			__kernel_pid_t process_pid;
 			__kernel_pid_t process_tgid;
@@ -118,6 +125,7 @@ void proc_exec_connector(struct task_struct *task);
 void proc_id_connector(struct task_struct *task, int which_id);
 void proc_sid_connector(struct task_struct *task);
 void proc_ptrace_connector(struct task_struct *task, int which_id);
+void proc_comm_connector(struct task_struct *task);
 void proc_exit_connector(struct task_struct *task);
 #else
 static inline void proc_fork_connector(struct task_struct *task)
@@ -133,6 +141,9 @@ static inline void proc_id_connector(struct task_struct *task,
 static inline void proc_sid_connector(struct task_struct *task)
 {}
 
+static inline void proc_comm_connector(struct task_struct *task)
+{}
+
 static inline void proc_ptrace_connector(struct task_struct *task,
 					 int ptrace_id)
 {}
diff --git a/kernel/sys.c b/kernel/sys.c
index a101ba3..21850f5 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1714,6 +1714,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 					      sizeof(me->comm) - 1) < 0)
 				return -EFAULT;
 			set_task_comm(me, comm);
+			proc_comm_connector(me);
 			return 0;
 		case PR_GET_NAME:
 			get_task_comm(comm, me);
-- 
1.7.5.1

