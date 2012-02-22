Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab2BVMsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 07:48:12 -0500
Received: from seven.medozas.de ([188.40.89.202]:52808 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab2BVMsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 07:48:09 -0500
Date: Wed, 22 Feb 2012 13:48:08 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] treewide: fix memory corruptions when TASK_COMM_LEN
 != 16
In-Reply-To: <20120131190109.b53347fd.akpm@linux-foundation.org>
Message-ID: <alpine.LNX.2.01.1202221343530.10125@frira.zrqbmnf.qr>
References: <1327183785-27023-1-git-send-email-jengelh@medozas.de> <20120124135443.2772d455.akpm@linux-foundation.org> <alpine.LNX.2.01.1201250121260.20692@frira.zrqbmnf.qr> <20120131172334.7f26f164.akpm@linux-foundation.org> <alpine.LNX.2.01.1202010224510.29848@frira.zrqbmnf.qr>
 <20120131174914.8ce5291d.akpm@linux-foundation.org> <alpine.LNX.2.01.1202010257240.29848@frira.zrqbmnf.qr> <20120131190109.b53347fd.akpm@linux-foundation.org>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2012-02-01 04:01, Andrew Morton wrote:
>> 
>> Ah yes, indeed. My reason for augmenting the size of t->comm was so
>> that `ps afx` could show a more complete name of certain kernel
>> threads' names. In this case, the kernel delivers the name via
>> procfs via seq_printf("%s, t->comm),
>
>Where does procfs do this?

In the handler for /proc/n/stat and status.

Meanwhile I have approached this from a different angle by using a
union. (And then I discovered that even psutils has a dumb 16-byte
buffer as well such that output is truncated -.- but that's another
story.)

parent b01543dfe67bb1d191998e90d20534dc354de059 (v3.3-rc4)
commit 726ff573fe3f2722ec7bd765b84750ceda5e518e
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Feb 21 06:21:38 2012 +0100

task: provide a larger task command buffer
---
 fs/exec.c               |   16 +++++++++++++---
 fs/proc/array.c         |    8 ++++----
 include/linux/binfmts.h |    5 ++++-
 include/linux/sched.h   |   20 ++++++++++++++++----
 kernel/exit.c           |    2 +-
 kernel/kthread.c        |    4 ++--
 6 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 92ce83a..1191a52 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1052,6 +1052,15 @@ char *get_task_comm(char *buf, struct task_struct *tsk)
 }
 EXPORT_SYMBOL_GPL(get_task_comm);
 
+char *get_task_comm_ex(char *buf, size_t z, struct task_struct *tsk)
+{
+	task_lock(tsk);
+	strlcpy(buf, tsk->comm_ex, z);
+	task_unlock(tsk);
+	return buf;
+}
+EXPORT_SYMBOL_GPL(get_task_comm_ex);
+
 void set_task_comm(struct task_struct *tsk, char *buf)
 {
 	task_lock(tsk);
@@ -1064,9 +1073,9 @@ void set_task_comm(struct task_struct *tsk, char *buf)
 	 * Readers without a lock may see incomplete new
 	 * names but are safe from non-terminating string reads.
 	 */
-	memset(tsk->comm, 0, TASK_COMM_LEN);
+	memset(tsk->comm_ex, 0, sizeof(tsk->comm_ex));
 	wmb();
-	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
+	strlcpy(tsk->comm_ex, buf, sizeof(tsk->comm_ex));
 	task_unlock(tsk);
 	perf_event_comm(tsk);
 }
@@ -1100,7 +1109,8 @@ int flush_old_exec(struct linux_binprm * bprm)
 
 	set_mm_exe_file(bprm->mm, bprm->file);
 
-	filename_to_taskname(bprm->tcomm, bprm->filename, sizeof(bprm->tcomm));
+	filename_to_taskname(bprm->tcomm_ex, bprm->filename,
+			     sizeof(bprm->tcomm_ex));
 	/*
 	 * Release all of the old mmap stuff
 	 */
diff --git a/fs/proc/array.c b/fs/proc/array.c
index c602b8d..4bdbeb0 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -91,9 +91,9 @@ static inline void task_name(struct seq_file *m, struct task_struct *p)
 	int i;
 	char *buf, *end;
 	char *name;
-	char tcomm[sizeof(p->comm)];
+	char tcomm[sizeof(p->comm_ex)];
 
-	get_task_comm(tcomm, p);
+	get_task_comm_ex(tcomm, sizeof(tcomm), p);
 
 	seq_puts(m, "Name:\t");
 	end = m->buf + m->size;
@@ -375,7 +375,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	cputime_t cutime, cstime, utime, stime;
 	cputime_t cgtime, gtime;
 	unsigned long rsslim = 0;
-	char tcomm[sizeof(task->comm)];
+	char tcomm[sizeof(task->comm_ex)];
 	unsigned long flags;
 
 	state = *get_task_state(task);
@@ -390,7 +390,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		}
 	}
 
-	get_task_comm(tcomm, task);
+	get_task_comm_ex(tcomm, sizeof(tcomm), task);
 
 	sigemptyset(&sigign);
 	sigemptyset(&sigcatch);
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 0092102..a19d1d1 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -58,7 +58,10 @@ struct linux_binprm {
 	unsigned interp_flags;
 	unsigned interp_data;
 	unsigned long loader, exec;
-	char tcomm[TASK_COMM_LEN];
+	union {
+		char tcomm[TASK_COMM_LEN];
+		char tcomm_ex[32];
+	};
 };
 
 #define BINPRM_FLAGS_ENFORCE_NONDUMP_BIT 0
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7d379a6..977eced 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1378,10 +1378,21 @@ struct task_struct {
 					 * credentials (COW) */
 	struct cred *replacement_session_keyring; /* for KEYCTL_SESSION_TO_PARENT */
 
-	char comm[TASK_COMM_LEN]; /* executable name excluding path
-				     - access with [gs]et_task_comm (which lock
-				       it with task_lock())
-				     - initialized normally by setup_new_exec */
+	union {
+		/*
+		 * Executable name excluding path. Access it with
+		 * [gs]et_task_comm (which lock it with task_lock()).
+		 * Initialized normally by setup_new_exec.
+		 */
+		char comm[TASK_COMM_LEN];
+		/*
+		 * The .comm member is kept, while we try to identify the codes
+		 * that unfortunately rely on its exact size of 16. Apparently
+		 * not all those sites have been spotted in previous attempts
+		 * of mine to enlarge comm.
+		 */
+		char comm_ex[32];
+	};
 /* file system info */
 	int link_count, total_link_count;
 #ifdef CONFIG_SYSVIPC
@@ -2295,6 +2306,7 @@ struct task_struct *fork_idle(int);
 
 extern void set_task_comm(struct task_struct *tsk, char *from);
 extern char *get_task_comm(char *to, struct task_struct *tsk);
+extern char *get_task_comm_ex(char *to, size_t z, struct task_struct *tsk);
 
 #ifdef CONFIG_SMP
 void scheduler_ipi(void);
diff --git a/kernel/exit.c b/kernel/exit.c
index 4b4042f..2c9569a 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -414,7 +414,7 @@ void daemonize(const char *name, ...)
 	sigset_t blocked;
 
 	va_start(args, name);
-	vsnprintf(current->comm, sizeof(current->comm), name, args);
+	vsnprintf(current->comm_ex, sizeof(current->comm_ex), name, args);
 	va_end(args);
 
 	/*
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 3d3de63..09dba54 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -196,8 +196,8 @@ struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
 		va_list args;
 
 		va_start(args, namefmt);
-		vsnprintf(create.result->comm, sizeof(create.result->comm),
-			  namefmt, args);
+		vsnprintf(create.result->comm_ex,
+			  sizeof(create.result->comm_ex), namefmt, args);
 		va_end(args);
 		/*
 		 * root may have changed our (kthreadd's) priority or CPU mask.
-- 
# Created with git-export-patch
