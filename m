Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab1EPVTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:19:37 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:56085 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756033Ab1EPVT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:19:29 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, "Ted Ts'o" <tytso@mit.edu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: [PATCH 1/3] comm: Introduce comm_lock seqlock to protect task->comm access
Date: Mon, 16 May 2011 14:19:15 -0700
Message-Id: <1305580757-13175-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1305580757-13175-1-git-send-email-john.stultz@linaro.org>
References: <1305580757-13175-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The implicit rules for current->comm access being safe without locking
are no longer true. Accessing current->comm without holding the task
lock may result in null or incomplete strings (however, access won't
run off the end of the string).

In order to properly fix this, I've introduced a comm_lock spinlock
which will protect comm access and modified get_task_comm() and
set_task_comm() to use it.

Since there are a number of cases where comm access is open-coded
safely grabbing the task_lock(), we preserve the task locking in
set_task_comm, so those users are also safe.

With this patch, users that access current->comm without a lock
are still prone to null/incomplete comm strings, but it should
be no worse then it is now.

The next step is to go through and convert all comm accesses to
use get_task_comm(). This is substantial, but can be done bit by
bit, reducing the race windows with each patch.

CC: Ted Ts'o <tytso@mit.edu>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: David Rientjes <rientjes@google.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 fs/exec.c                 |   19 ++++++++++++++++---
 include/linux/init_task.h |    1 +
 include/linux/sched.h     |    5 ++---
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 5e62d26..34fa611 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -998,17 +998,28 @@ static void flush_old_files(struct files_struct * files)
 
 char *get_task_comm(char *buf, struct task_struct *tsk)
 {
-	/* buf must be at least sizeof(tsk->comm) in size */
-	task_lock(tsk);
+	unsigned long flags;
+
+	spin_lock_irqsave(&tsk->comm_lock, flags);
 	strncpy(buf, tsk->comm, sizeof(tsk->comm));
-	task_unlock(tsk);
+	spin_unlock_irqrestore(&tsk->comm_lock, flags);
 	return buf;
 }
 
 void set_task_comm(struct task_struct *tsk, char *buf)
 {
+	unsigned long flags;
+
+	/*
+	 * XXX - Even though comm is protected by comm_lock,
+	 * we take the task_lock here to serialize against
+	 * current users that directly access comm.
+	 * Once those users are removed, we can drop the
+	 * task locking & memsetting.
+	 */
 	task_lock(tsk);
 
+	spin_lock_irqsave(&tsk->comm_lock, flags);
 	/*
 	 * Threads may access current->comm without holding
 	 * the task lock, so write the string carefully.
@@ -1018,6 +1029,8 @@ void set_task_comm(struct task_struct *tsk, char *buf)
 	memset(tsk->comm, 0, TASK_COMM_LEN);
 	wmb();
 	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
+	spin_unlock_irqrestore(&tsk->comm_lock, flags);
+
 	task_unlock(tsk);
 	perf_event_comm(tsk);
 }
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index caa151f..b69d94b 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -161,6 +161,7 @@ extern struct cred init_cred;
 	.group_leader	= &tsk,						\
 	RCU_INIT_POINTER(.real_cred, &init_cred),			\
 	RCU_INIT_POINTER(.cred, &init_cred),				\
+	.comm_lock	= __SPIN_LOCK_UNLOCKED(tsk.comm_lock),		\
 	.comm		= "swapper",					\
 	.thread		= INIT_THREAD,					\
 	.fs		= &init_fs,					\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 18d63ce..f8a7cdf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1333,10 +1333,9 @@ struct task_struct {
 	const struct cred __rcu *cred;	/* effective (overridable) subjective task
 					 * credentials (COW) */
 	struct cred *replacement_session_keyring; /* for KEYCTL_SESSION_TO_PARENT */
-
+	spinlock_t comm_lock;		/* protect's comm */
 	char comm[TASK_COMM_LEN]; /* executable name excluding path
-				     - access with [gs]et_task_comm (which lock
-				       it with task_lock())
+				     - access with [gs]et_task_comm
 				     - initialized normally by setup_new_exec */
 /* file system info */
 	int link_count, total_link_count;
-- 
1.7.3.2.146.gca209

