Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab2KMBxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 20:53:09 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64882 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab2KMBxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 20:53:07 -0500
Date: Mon, 12 Nov 2012 17:53:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Artem S. Tashkinov" <t.artem@lycos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <dave@gnu.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [patch for-3.7] mm, oom: reintroduce /proc/pid/oom_adj
In-Reply-To: <CA+55aFwSxwjqK8CScNBWvzk=ExDqREAGAyRoZLW4zjOu4dyxqw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1211121747490.8225@chino.kir.corp.google.com>
References: <545706980.41498.1352739027798.JavaMail.mail@webmail19> <alpine.DEB.2.00.1211121339000.23347@chino.kir.corp.google.com> <CA+55aFz2Kgn0mVV4ozH0g1QGKw1VE6NpgCz9taxxfbCUz2a8VA@mail.gmail.com> <alpine.DEB.2.00.1211121717060.8225@chino.kir.corp.google.com>
 <CA+55aFwSxwjqK8CScNBWvzk=ExDqREAGAyRoZLW4zjOu4dyxqw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is mostly a revert of 01dc52ebdf47 ("oom: remove deprecated oom_adj") 
from Davidlohr Bueso.

It reintroduces /proc/pid/oom_adj for backwards compatibility with earlier 
kernels.  It simply scales the value linearly when /proc/pid/oom_score_adj 
is written.

The major difference is that its scheduled removal is no longer included 
in Documentation/feature-removal-schedule.txt.  We do warn users with a 
single printk, though, to suggest the more powerful and supported 
/proc/pid/oom_score_adj interface.

Reported-by: Artem S. Tashkinov <t.artem@lycos.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/filesystems/proc.txt |   16 ++++--
 fs/proc/base.c                     |  109 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/oom.h           |    9 +++
 3 files changed, 130 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -33,7 +33,7 @@ Table of Contents
   2	Modifying System Parameters
 
   3	Per-Process Parameters
-  3.1	/proc/<pid>/oom_score_adj - Adjust the oom-killer
+  3.1	/proc/<pid>/oom_adj & /proc/<pid>/oom_score_adj - Adjust the oom-killer
 								score
   3.2	/proc/<pid>/oom_score - Display current oom-killer score
   3.3	/proc/<pid>/io - Display the IO accounting fields
@@ -1320,10 +1320,10 @@ of the kernel.
 CHAPTER 3: PER-PROCESS PARAMETERS
 ------------------------------------------------------------------------------
 
-3.1 /proc/<pid>/oom_score_adj- Adjust the oom-killer score
+3.1 /proc/<pid>/oom_adj & /proc/<pid>/oom_score_adj- Adjust the oom-killer score
 --------------------------------------------------------------------------------
 
-This file can be used to adjust the badness heuristic used to select which
+These file can be used to adjust the badness heuristic used to select which
 process gets killed in out of memory conditions.
 
 The badness heuristic assigns a value to each candidate task ranging from 0
@@ -1361,6 +1361,12 @@ same system, cpuset, mempolicy, or memory controller resources to use at least
 equivalent to discounting 50% of the task's allowed memory from being considered
 as scoring against the task.
 
+For backwards compatibility with previous kernels, /proc/<pid>/oom_adj may also
+be used to tune the badness score.  Its acceptable values range from -16
+(OOM_ADJUST_MIN) to +15 (OOM_ADJUST_MAX) and a special value of -17
+(OOM_DISABLE) to disable oom killing entirely for that task.  Its value is
+scaled linearly with /proc/<pid>/oom_score_adj.
+
 The value of /proc/<pid>/oom_score_adj may be reduced no lower than the last
 value set by a CAP_SYS_RESOURCE process. To reduce the value any lower
 requires CAP_SYS_RESOURCE.
@@ -1375,7 +1381,9 @@ minimal amount of work.
 -------------------------------------------------------------
 
 This file can be used to check the current score used by the oom-killer is for
-any given <pid>.
+any given <pid>. Use it together with /proc/<pid>/oom_score_adj to tune which
+process should be killed in an out-of-memory situation.
+
 
 3.3  /proc/<pid>/io - Display the IO accounting fields
 -------------------------------------------------------
diff --git a/fs/proc/base.c b/fs/proc/base.c
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -873,6 +873,113 @@ static const struct file_operations proc_environ_operations = {
 	.release	= mem_release,
 };
 
+static ssize_t oom_adj_read(struct file *file, char __user *buf, size_t count,
+			    loff_t *ppos)
+{
+	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
+	char buffer[PROC_NUMBUF];
+	int oom_adj = OOM_ADJUST_MIN;
+	size_t len;
+	unsigned long flags;
+
+	if (!task)
+		return -ESRCH;
+	if (lock_task_sighand(task, &flags)) {
+		if (task->signal->oom_score_adj == OOM_SCORE_ADJ_MAX)
+			oom_adj = OOM_ADJUST_MAX;
+		else
+			oom_adj = (task->signal->oom_score_adj * -OOM_DISABLE) /
+				  OOM_SCORE_ADJ_MAX;
+		unlock_task_sighand(task, &flags);
+	}
+	put_task_struct(task);
+	len = snprintf(buffer, sizeof(buffer), "%d\n", oom_adj);
+	return simple_read_from_buffer(buf, count, ppos, buffer, len);
+}
+
+static ssize_t oom_adj_write(struct file *file, const char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	struct task_struct *task;
+	char buffer[PROC_NUMBUF];
+	int oom_adj;
+	unsigned long flags;
+	int err;
+
+	memset(buffer, 0, sizeof(buffer));
+	if (count > sizeof(buffer) - 1)
+		count = sizeof(buffer) - 1;
+	if (copy_from_user(buffer, buf, count)) {
+		err = -EFAULT;
+		goto out;
+	}
+
+	err = kstrtoint(strstrip(buffer), 0, &oom_adj);
+	if (err)
+		goto out;
+	if ((oom_adj < OOM_ADJUST_MIN || oom_adj > OOM_ADJUST_MAX) &&
+	     oom_adj != OOM_DISABLE) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	task = get_proc_task(file->f_path.dentry->d_inode);
+	if (!task) {
+		err = -ESRCH;
+		goto out;
+	}
+
+	task_lock(task);
+	if (!task->mm) {
+		err = -EINVAL;
+		goto err_task_lock;
+	}
+
+	if (!lock_task_sighand(task, &flags)) {
+		err = -ESRCH;
+		goto err_task_lock;
+	}
+
+	/*
+	 * Scale /proc/pid/oom_score_adj appropriately ensuring that a maximum
+	 * value is always attainable.
+	 */
+	if (oom_adj == OOM_ADJUST_MAX)
+		oom_adj = OOM_SCORE_ADJ_MAX;
+	else
+		oom_adj = (oom_adj * OOM_SCORE_ADJ_MAX) / -OOM_DISABLE;
+
+	if (oom_adj < task->signal->oom_score_adj &&
+	    !capable(CAP_SYS_RESOURCE)) {
+		err = -EACCES;
+		goto err_sighand;
+	}
+
+	/*
+	 * /proc/pid/oom_adj is provided for legacy purposes, ask users to use
+	 * /proc/pid/oom_score_adj instead.
+	 */
+	printk_once(KERN_WARNING "%s (%d): /proc/%d/oom_adj is deprecated, please use /proc/%d/oom_score_adj instead.\n",
+		  current->comm, task_pid_nr(current), task_pid_nr(task),
+		  task_pid_nr(task));
+
+	task->signal->oom_score_adj = oom_adj;
+	trace_oom_score_adj_update(task);
+err_sighand:
+	unlock_task_sighand(task, &flags);
+err_task_lock:
+	task_unlock(task);
+	put_task_struct(task);
+out:
+	return err < 0 ? err : count;
+}
+
+static const struct file_operations proc_oom_adj_operations = {
+	.read		= oom_adj_read,
+	.write		= oom_adj_write,
+	.llseek		= generic_file_llseek,
+};
+
 static ssize_t oom_score_adj_read(struct file *file, char __user *buf,
 					size_t count, loff_t *ppos)
 {
@@ -2598,6 +2705,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("cgroup",  S_IRUGO, proc_cgroup_operations),
 #endif
 	INF("oom_score",  S_IRUGO, proc_oom_score),
+	REG("oom_adj",    S_IRUGO|S_IWUSR, proc_oom_adj_operations),
 	REG("oom_score_adj", S_IRUGO|S_IWUSR, proc_oom_score_adj_operations),
 #ifdef CONFIG_AUDITSYSCALL
 	REG("loginuid",   S_IWUSR|S_IRUGO, proc_loginuid_operations),
@@ -2964,6 +3072,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("cgroup",  S_IRUGO, proc_cgroup_operations),
 #endif
 	INF("oom_score", S_IRUGO, proc_oom_score),
+	REG("oom_adj",   S_IRUGO|S_IWUSR, proc_oom_adj_operations),
 	REG("oom_score_adj", S_IRUGO|S_IWUSR, proc_oom_score_adj_operations),
 #ifdef CONFIG_AUDITSYSCALL
 	REG("loginuid",  S_IWUSR|S_IRUGO, proc_loginuid_operations),
diff --git a/include/uapi/linux/oom.h b/include/uapi/linux/oom.h
--- a/include/uapi/linux/oom.h
+++ b/include/uapi/linux/oom.h
@@ -8,4 +8,13 @@
 #define OOM_SCORE_ADJ_MIN	(-1000)
 #define OOM_SCORE_ADJ_MAX	1000
 
+/*
+ * /proc/<pid>/oom_adj set to -17 protects from the oom killer for legacy
+ * purposes.
+ */
+#define OOM_DISABLE (-17)
+/* inclusive */
+#define OOM_ADJUST_MIN (-16)
+#define OOM_ADJUST_MAX 15
+
 #endif /* _UAPI__INCLUDE_LINUX_OOM_H */
