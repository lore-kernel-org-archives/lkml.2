Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab0KNFHh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 00:07:37 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49982 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab0KNFHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 00:07:19 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Revert oom rewrite series
Cc: kosaki.motohiro@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ying Han <yinghan@google.com>, Bodo Eggert <7eggert@web.de>,
        Mandeep Singh Baines <msb@google.com>,
        "Figo.zhang" <figo1802@gmail.com>
Message-Id: <20101114133543.E00A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun, 14 Nov 2010 14:07:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please apply this. this patch revert commits of oom changes since v2.6.35.

briefly says, "oom: badness heuristic rewrite" was merges by mistaken.
It haven't been passed our design nor code review. then multiple bug reports
has been popped up. I believe evey patches should pass a usecase and a code
review :-/

The problem is, DavidR patches don't refrect real world usecase at all
and breaking them. He can talk about the userland is wrong. but such
excuse doesn't solve real world issue. it makes no sense.

I hope every developers keep honestly development. googlers are NOT 
exception.


David, at least rss based oom score was passed our design review. 
So, if you will resubmit such part, we will ack it. please remember it.
Also, I can accept oom_score_adj feature if you can remove imcomatibility 
issue. OK?

Linus, if you want to check the patch. please use following way.
  % git diff a63d83f427fbce97a6cea0db2e64b0eb8435cd10^ mm/oom_kill.c include/linux/oom.h fs/proc/base.c


Thanks.

--------------------------------------------------------------------------
Subject: [PATCH] Revert oom rewrite series

This reverts following commits. They has broke an ABI and made multiple
enduser claim.

9c28ab662a8e3d19d07077ac0a8931c015e8afec Revert "oom: badness heuristic rewrite"
74cd8c6cb3e093c4d67ac3eb3581e246e4981dad Revert "oom: deprecate oom_adj tunable"
79a0bd5796e754c4b4e22071c4edddef3517d010 Revert "memcg: use find_lock_task_mm() in memory cgroups oom"
a465ef80c2a9fe73c85029fcea5c68ffee8dbb69 Revert "oom: always return a badness score of non-zero for eligible tas
516fcbb0c45d943df1b739d3be3d417aee2275f3 Revert "oom: filter unkillable tasks from tasklist dump"
b1c98f95a7954c450dadd809280f86863ea9d05d Revert "oom: add per-mm oom disable count"
fd79f3f47c82a0af5288afe7556905dd171bfc43 Revert "oom: avoid killing a task if a thread sharing its mm cannot be
2d72175528870dcef577db4a2a0b49d819c6eaff Revert "oom: kill all threads sharing oom killed task's mm"
be212960618ddcdb9526ce2cb73fd081fd3e90ea Revert "oom: rewrite error handling for oom_adj and oom_score_adj tunab
1b17c41599c594c7d11ef415a92d47c205fe89ea Revert "oom: fix locking for oom_adj and oom_score_adj"

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 Documentation/feature-removal-schedule.txt |   25 ---
 Documentation/filesystems/proc.txt         |   97 ++++-----
 fs/exec.c                                  |    5 -
 fs/proc/base.c                             |  176 ++--------------
 include/linux/memcontrol.h                 |    8 -
 include/linux/mm_types.h                   |    2 -
 include/linux/oom.h                        |   19 +--
 include/linux/sched.h                      |    3 +-
 kernel/exit.c                              |    3 -
 kernel/fork.c                              |   16 +--
 mm/memcontrol.c                            |   28 +---
 mm/oom_kill.c                              |  323 ++++++++++++++--------------
 12 files changed, 227 insertions(+), 478 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index d8f36f9..9af16b9 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -166,31 +166,6 @@ Who:	Eric Biederman <ebiederm@xmission.com>
 
 ---------------------------
 
-What:	/proc/<pid>/oom_adj
-When:	August 2012
-Why:	/proc/<pid>/oom_adj allows userspace to influence the oom killer's
-	badness heuristic used to determine which task to kill when the kernel
-	is out of memory.
-
-	The badness heuristic has since been rewritten since the introduction of
-	this tunable such that its meaning is deprecated.  The value was
-	implemented as a bitshift on a score generated by the badness()
-	function that did not have any precise units of measure.  With the
-	rewrite, the score is given as a proportion of available memory to the
-	task allocating pages, so using a bitshift which grows the score
-	exponentially is, thus, impossible to tune with fine granularity.
-
-	A much more powerful interface, /proc/<pid>/oom_score_adj, was
-	introduced with the oom killer rewrite that allows users to increase or
-	decrease the badness() score linearly.  This interface will replace
-	/proc/<pid>/oom_adj.
-
-	A warning will be emitted to the kernel log if an application uses this
-	deprecated interface.  After it is printed once, future warnings will be
-	suppressed until the kernel is rebooted.
-
----------------------------
-
 What:	remove EXPORT_SYMBOL(kernel_thread)
 When:	August 2006
 Files:	arch/*/kernel/*_ksyms.c
diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index e73df27..030e3a1 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -33,8 +33,7 @@ Table of Contents
   2	Modifying System Parameters
 
   3	Per-Process Parameters
-  3.1	/proc/<pid>/oom_adj & /proc/<pid>/oom_score_adj - Adjust the oom-killer
-								score
+  3.1	/proc/<pid>/oom_adj - Adjust the oom-killer score
   3.2	/proc/<pid>/oom_score - Display current oom-killer score
   3.3	/proc/<pid>/io - Display the IO accounting fields
   3.4	/proc/<pid>/coredump_filter - Core dump filtering settings
@@ -1246,64 +1245,42 @@ of the kernel.
 CHAPTER 3: PER-PROCESS PARAMETERS
 ------------------------------------------------------------------------------
 
-3.1 /proc/<pid>/oom_adj & /proc/<pid>/oom_score_adj- Adjust the oom-killer score
---------------------------------------------------------------------------------
-
-These file can be used to adjust the badness heuristic used to select which
-process gets killed in out of memory conditions.
-
-The badness heuristic assigns a value to each candidate task ranging from 0
-(never kill) to 1000 (always kill) to determine which process is targeted.  The
-units are roughly a proportion along that range of allowed memory the process
-may allocate from based on an estimation of its current memory and swap use.
-For example, if a task is using all allowed memory, its badness score will be
-1000.  If it is using half of its allowed memory, its score will be 500.
-
-There is an additional factor included in the badness score: root
-processes are given 3% extra memory over other tasks.
-
-The amount of "allowed" memory depends on the context in which the oom killer
-was called.  If it is due to the memory assigned to the allocating task's cpuset
-being exhausted, the allowed memory represents the set of mems assigned to that
-cpuset.  If it is due to a mempolicy's node(s) being exhausted, the allowed
-memory represents the set of mempolicy nodes.  If it is due to a memory
-limit (or swap limit) being reached, the allowed memory is that configured
-limit.  Finally, if it is due to the entire system being out of memory, the
-allowed memory represents all allocatable resources.
-
-The value of /proc/<pid>/oom_score_adj is added to the badness score before it
-is used to determine which task to kill.  Acceptable values range from -1000
-(OOM_SCORE_ADJ_MIN) to +1000 (OOM_SCORE_ADJ_MAX).  This allows userspace to
-polarize the preference for oom killing either by always preferring a certain
-task or completely disabling it.  The lowest possible value, -1000, is
-equivalent to disabling oom killing entirely for that task since it will always
-report a badness score of 0.
-
-Consequently, it is very simple for userspace to define the amount of memory to
-consider for each task.  Setting a /proc/<pid>/oom_score_adj value of +500, for
-example, is roughly equivalent to allowing the remainder of tasks sharing the
-same system, cpuset, mempolicy, or memory controller resources to use at least
-50% more memory.  A value of -500, on the other hand, would be roughly
-equivalent to discounting 50% of the task's allowed memory from being considered
-as scoring against the task.
-
-For backwards compatibility with previous kernels, /proc/<pid>/oom_adj may also
-be used to tune the badness score.  Its acceptable values range from -16
-(OOM_ADJUST_MIN) to +15 (OOM_ADJUST_MAX) and a special value of -17
-(OOM_DISABLE) to disable oom killing entirely for that task.  Its value is
-scaled linearly with /proc/<pid>/oom_score_adj.
-
-Writing to /proc/<pid>/oom_score_adj or /proc/<pid>/oom_adj will change the
-other with its scaled value.
-
-NOTICE: /proc/<pid>/oom_adj is deprecated and will be removed, please see
-Documentation/feature-removal-schedule.txt.
-
-Caveat: when a parent task is selected, the oom killer will sacrifice any first
-generation children with seperate address spaces instead, if possible.  This
-avoids servers and important system daemons from being killed and loses the
-minimal amount of work.
-
+3.1 /proc/<pid>/oom_adj - Adjust the oom-killer score
+------------------------------------------------------
+
+This file can be used to adjust the score used to select which processes
+should be killed in an  out-of-memory  situation.  Giving it a high score will
+increase the likelihood of this process being killed by the oom-killer.  Valid
+values are in the range -16 to +15, plus the special value -17, which disables
+oom-killing altogether for this process.
+
+The process to be killed in an out-of-memory situation is selected among all others
+based on its badness score. This value equals the original memory size of the process
+and is then updated according to its CPU time (utime + stime) and the
+run time (uptime - start time). The longer it runs the smaller is the score.
+Badness score is divided by the square root of the CPU time and then by
+the double square root of the run time.
+
+Swapped out tasks are killed first. Half of each child's memory size is added to
+the parent's score if they do not share the same memory. Thus forking servers
+are the prime candidates to be killed. Having only one 'hungry' child will make
+parent less preferable than the child.
+
+/proc/<pid>/oom_score shows process' current badness score.
+
+The following heuristics are then applied:
+ * if the task was reniced, its score doubles
+ * superuser or direct hardware access tasks (CAP_SYS_ADMIN, CAP_SYS_RESOURCE
+ 	or CAP_SYS_RAWIO) have their score divided by 4
+ * if oom condition happened in one cpuset and checked process does not belong
+ 	to it, its score is divided by 8
+ * the resulting score is multiplied by two to the power of oom_adj, i.e.
+	points <<= oom_adj when it is positive and
+	points >>= -(oom_adj) otherwise
+
+The task with the highest badness score is then selected and its children
+are killed, process itself will be killed in an OOM situation when it does
+not have children or some of them disabled oom like described above.
 
 3.2 /proc/<pid>/oom_score - Display current oom-killer score
 -------------------------------------------------------------
diff --git a/fs/exec.c b/fs/exec.c
index 99d33a1..47986fb 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -54,7 +54,6 @@
 #include <linux/fsnotify.h>
 #include <linux/fs_struct.h>
 #include <linux/pipe_fs_i.h>
-#include <linux/oom.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -766,10 +765,6 @@ static int exec_mmap(struct mm_struct *mm)
 	tsk->mm = mm;
 	tsk->active_mm = mm;
 	activate_mm(active_mm, mm);
-	if (old_mm && tsk->signal->oom_score_adj == OOM_SCORE_ADJ_MIN) {
-		atomic_dec(&old_mm->oom_disable_count);
-		atomic_inc(&tsk->mm->oom_disable_count);
-	}
 	task_unlock(tsk);
 	arch_pick_mmap_layout(mm);
 	if (old_mm) {
diff --git a/fs/proc/base.c b/fs/proc/base.c
index f3d02ca..ed7d18e 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -63,7 +63,6 @@
 #include <linux/namei.h>
 #include <linux/mnt_namespace.h>
 #include <linux/mm.h>
-#include <linux/swap.h>
 #include <linux/rcupdate.h>
 #include <linux/kallsyms.h>
 #include <linux/stacktrace.h>
@@ -431,11 +430,12 @@ static const struct file_operations proc_lstats_operations = {
 static int proc_oom_score(struct task_struct *task, char *buffer)
 {
 	unsigned long points = 0;
+	struct timespec uptime;
 
+	do_posix_clock_monotonic_gettime(&uptime);
 	read_lock(&tasklist_lock);
 	if (pid_alive(task))
-		points = oom_badness(task, NULL, NULL,
-					totalram_pages + total_swap_pages);
+		points = badness(task, NULL, NULL, uptime.tv_sec);
 	read_unlock(&tasklist_lock);
 	return sprintf(buffer, "%lu\n", points);
 }
@@ -1025,74 +1025,36 @@ static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
 	memset(buffer, 0, sizeof(buffer));
 	if (count > sizeof(buffer) - 1)
 		count = sizeof(buffer) - 1;
-	if (copy_from_user(buffer, buf, count)) {
-		err = -EFAULT;
-		goto out;
-	}
+	if (copy_from_user(buffer, buf, count))
+		return -EFAULT;
 
 	err = strict_strtol(strstrip(buffer), 0, &oom_adjust);
 	if (err)
-		goto out;
+		return -EINVAL;
 	if ((oom_adjust < OOM_ADJUST_MIN || oom_adjust > OOM_ADJUST_MAX) &&
-	     oom_adjust != OOM_DISABLE) {
-		err = -EINVAL;
-		goto out;
-	}
+	     oom_adjust != OOM_DISABLE)
+		return -EINVAL;
 
 	task = get_proc_task(file->f_path.dentry->d_inode);
-	if (!task) {
-		err = -ESRCH;
-		goto out;
-	}
-
-	task_lock(task);
-	if (!task->mm) {
-		err = -EINVAL;
-		goto err_task_lock;
-	}
-
+	if (!task)
+		return -ESRCH;
 	if (!lock_task_sighand(task, &flags)) {
-		err = -ESRCH;
-		goto err_task_lock;
+		put_task_struct(task);
+		return -ESRCH;
 	}
 
 	if (oom_adjust < task->signal->oom_adj && !capable(CAP_SYS_RESOURCE)) {
-		err = -EACCES;
-		goto err_sighand;
-	}
-
-	if (oom_adjust != task->signal->oom_adj) {
-		if (oom_adjust == OOM_DISABLE)
-			atomic_inc(&task->mm->oom_disable_count);
-		if (task->signal->oom_adj == OOM_DISABLE)
-			atomic_dec(&task->mm->oom_disable_count);
+		unlock_task_sighand(task, &flags);
+		put_task_struct(task);
+		return -EACCES;
 	}
 
-	/*
-	 * Warn that /proc/pid/oom_adj is deprecated, see
-	 * Documentation/feature-removal-schedule.txt.
-	 */
-	printk_once(KERN_WARNING "%s (%d): /proc/%d/oom_adj is deprecated, "
-			"please use /proc/%d/oom_score_adj instead.\n",
-			current->comm, task_pid_nr(current),
-			task_pid_nr(task), task_pid_nr(task));
 	task->signal->oom_adj = oom_adjust;
-	/*
-	 * Scale /proc/pid/oom_score_adj appropriately ensuring that a maximum
-	 * value is always attainable.
-	 */
-	if (task->signal->oom_adj == OOM_ADJUST_MAX)
-		task->signal->oom_score_adj = OOM_SCORE_ADJ_MAX;
-	else
-		task->signal->oom_score_adj = (oom_adjust * OOM_SCORE_ADJ_MAX) /
-								-OOM_DISABLE;
-err_sighand:
+
 	unlock_task_sighand(task, &flags);
-err_task_lock:
-	task_unlock(task);
 	put_task_struct(task);
-out:
-	return err < 0 ? err : count;
+
+	return count;
 }
 
 static const struct file_operations proc_oom_adjust_operations = {
@@ -1101,106 +1063,6 @@ static const struct file_operations proc_oom_adjust_operations = {
 	.llseek		= generic_file_llseek,
 };
 
-static ssize_t oom_score_adj_read(struct file *file, char __user *buf,
-					size_t count, loff_t *ppos)
-{
-	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
-	char buffer[PROC_NUMBUF];
-	int oom_score_adj = OOM_SCORE_ADJ_MIN;
-	unsigned long flags;
-	size_t len;
-
-	if (!task)
-		return -ESRCH;
-	if (lock_task_sighand(task, &flags)) {
-		oom_score_adj = task->signal->oom_score_adj;
-		unlock_task_sighand(task, &flags);
-	}
-	put_task_struct(task);
-	len = snprintf(buffer, sizeof(buffer), "%d\n", oom_score_adj);
-	return simple_read_from_buffer(buf, count, ppos, buffer, len);
-}
-
-static ssize_t oom_score_adj_write(struct file *file, const char __user *buf,
-					size_t count, loff_t *ppos)
-{
-	struct task_struct *task;
-	char buffer[PROC_NUMBUF];
-	unsigned long flags;
-	long oom_score_adj;
-	int err;
-
-	memset(buffer, 0, sizeof(buffer));
-	if (count > sizeof(buffer) - 1)
-		count = sizeof(buffer) - 1;
-	if (copy_from_user(buffer, buf, count)) {
-		err = -EFAULT;
-		goto out;
-	}
-
-	err = strict_strtol(strstrip(buffer), 0, &oom_score_adj);
-	if (err)
-		goto out;
-	if (oom_score_adj < OOM_SCORE_ADJ_MIN ||
-			oom_score_adj > OOM_SCORE_ADJ_MAX) {
-		err = -EINVAL;
-		goto out;
-	}
-
-	task = get_proc_task(file->f_path.dentry->d_inode);
-	if (!task) {
-		err = -ESRCH;
-		goto out;
-	}
-
-	task_lock(task);
-	if (!task->mm) {
-		err = -EINVAL;
-		goto err_task_lock;
-	}
-
-	if (!lock_task_sighand(task, &flags)) {
-		err = -ESRCH;
-		goto err_task_lock;
-	}
-
-	if (oom_score_adj < task->signal->oom_score_adj &&
-			!capable(CAP_SYS_RESOURCE)) {
-		err = -EACCES;
-		goto err_sighand;
-	}
-
-	if (oom_score_adj != task->signal->oom_score_adj) {
-		if (oom_score_adj == OOM_SCORE_ADJ_MIN)
-			atomic_inc(&task->mm->oom_disable_count);
-		if (task->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
-			atomic_dec(&task->mm->oom_disable_count);
-	}
-	task->signal->oom_score_adj = oom_score_adj;
-	/*
-	 * Scale /proc/pid/oom_adj appropriately ensuring that OOM_DISABLE is
-	 * always attainable.
-	 */
-	if (task->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
-		task->signal->oom_adj = OOM_DISABLE;
-	else
-		task->signal->oom_adj = (oom_score_adj * OOM_ADJUST_MAX) /
-							OOM_SCORE_ADJ_MAX;
-err_sighand:
-	unlock_task_sighand(task, &flags);
-err_task_lock:
-	task_unlock(task);
-	put_task_struct(task);
-out:
-	return err < 0 ? err : count;
-}
-
-static const struct file_operations proc_oom_score_adj_operations = {
-	.read		= oom_score_adj_read,
-	.write		= oom_score_adj_write,
-	.llseek		= default_llseek,
-};
-
 #ifdef CONFIG_AUDITSYSCALL
 #define TMPBUFLEN 21
 static ssize_t proc_loginuid_read(struct file * file, char __user * buf,
@@ -2779,7 +2641,6 @@ static const struct pid_entry tgid_base_stuff[] = {
 #endif
 	INF("oom_score",  S_IRUGO, proc_oom_score),
 	REG("oom_adj",    S_IRUGO|S_IWUSR, proc_oom_adjust_operations),
-	REG("oom_score_adj", S_IRUGO|S_IWUSR, proc_oom_score_adj_operations),
 #ifdef CONFIG_AUDITSYSCALL
 	REG("loginuid",   S_IWUSR|S_IRUGO, proc_loginuid_operations),
 	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
@@ -3115,7 +2976,6 @@ static const struct pid_entry tid_base_stuff[] = {
 #endif
 	INF("oom_score", S_IRUGO, proc_oom_score),
 	REG("oom_adj",   S_IRUGO|S_IWUSR, proc_oom_adjust_operations),
-	REG("oom_score_adj", S_IRUGO|S_IWUSR, proc_oom_score_adj_operations),
 #ifdef CONFIG_AUDITSYSCALL
 	REG("loginuid",  S_IWUSR|S_IRUGO, proc_loginuid_operations),
 	REG("sessionid",  S_IRUSR, proc_sessionid_operations),
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 159a076..b13fc2a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -124,8 +124,6 @@ static inline bool mem_cgroup_disabled(void)
 void mem_cgroup_update_file_mapped(struct page *page, int val);
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
 						gfp_t gfp_mask);
-u64 mem_cgroup_get_limit(struct mem_cgroup *mem);
-
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct mem_cgroup;
 
@@ -305,12 +303,6 @@ unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
 	return 0;
 }
 
-static inline
-u64 mem_cgroup_get_limit(struct mem_cgroup *mem)
-{
-	return 0;
-}
-
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #endif /* _LINUX_MEMCONTROL_H */
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index bb7288a..cb57d65 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -310,8 +310,6 @@ struct mm_struct {
 #ifdef CONFIG_MMU_NOTIFIER
 	struct mmu_notifier_mm *mmu_notifier_mm;
 #endif
-	/* How many tasks sharing this mm are OOM_DISABLE */
-	atomic_t oom_disable_count;
 };
 
 /* Future-safe accessor for struct mm_struct's cpu_vm_mask. */
diff --git a/include/linux/oom.h b/include/linux/oom.h
index 5e3aa83..40e5e3a 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -1,27 +1,14 @@
 #ifndef __INCLUDE_LINUX_OOM_H
 #define __INCLUDE_LINUX_OOM_H
 
-/*
- * /proc/<pid>/oom_adj is deprecated, see
- * Documentation/feature-removal-schedule.txt.
- *
- * /proc/<pid>/oom_adj set to -17 protects from the oom-killer
- */
+/* /proc/<pid>/oom_adj set to -17 protects from the oom-killer */
 #define OOM_DISABLE (-17)
 /* inclusive */
 #define OOM_ADJUST_MIN (-16)
 #define OOM_ADJUST_MAX 15
 
-/*
- * /proc/<pid>/oom_score_adj set to OOM_SCORE_ADJ_MIN disables oom killing for
- * pid.
- */
-#define OOM_SCORE_ADJ_MIN	(-1000)
-#define OOM_SCORE_ADJ_MAX	1000
-
 #ifdef __KERNEL__
 
-#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/nodemask.h>
 
@@ -40,8 +27,6 @@ enum oom_constraint {
 	CONSTRAINT_MEMCG,
 };
 
-extern unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
-			const nodemask_t *nodemask, unsigned long totalpages);
 extern int try_set_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 extern void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 
@@ -66,8 +51,6 @@ static inline void oom_killer_enable(void)
 extern unsigned long badness(struct task_struct *p, struct mem_cgroup *mem,
 		      const nodemask_t *nodemask, unsigned long uptime);
 
-extern struct task_struct *find_lock_task_mm(struct task_struct *p);
-
 /* sysctls */
 extern int sysctl_oom_dump_tasks;
 extern int sysctl_oom_kill_allocating_task;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d0036e5..a35acb6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -624,8 +624,7 @@ struct signal_struct {
 	struct tty_audit_buf *tty_audit_buf;
 #endif
 
-	int oom_adj;		/* OOM kill score adjustment (bit shift) */
-	int oom_score_adj;	/* OOM kill score adjustment */
+	int oom_adj;	/* OOM kill score adjustment (bit shift) */
 
 	struct mutex cred_guard_mutex;	/* guard against foreign influences on
 					 * credential calculations
diff --git a/kernel/exit.c b/kernel/exit.c
index 21aa7b3..c806406 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -50,7 +50,6 @@
 #include <linux/perf_event.h>
 #include <trace/events/sched.h>
 #include <linux/hw_breakpoint.h>
-#include <linux/oom.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -696,8 +695,6 @@ static void exit_mm(struct task_struct * tsk)
 	enter_lazy_tlb(mm, current);
 	/* We don't want this task to be frozen prematurely */
 	clear_freeze_flag(tsk);
-	if (tsk->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
-		atomic_dec(&mm->oom_disable_count);
 	task_unlock(tsk);
 	mm_update_next_owner(mm);
 	mmput(mm);
diff --git a/kernel/fork.c b/kernel/fork.c
index 3b159c5..cca5e8b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -65,7 +65,6 @@
 #include <linux/perf_event.h>
 #include <linux/posix-timers.h>
 #include <linux/user-return-notifier.h>
-#include <linux/oom.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -489,7 +488,6 @@ static struct mm_struct * mm_init(struct mm_struct * mm, struct task_struct *p)
 	mm->cached_hole_size = ~0UL;
 	mm_init_aio(mm);
 	mm_init_owner(mm, p);
-	atomic_set(&mm->oom_disable_count, 0);
 
 	if (likely(!mm_alloc_pgd(mm))) {
 		mm->def_flags = 0;
@@ -743,8 +741,6 @@ good_mm:
 	/* Initializing for Swap token stuff */
 	mm->token_priority = 0;
 	mm->last_interval = 0;
-	if (tsk->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
-		atomic_inc(&mm->oom_disable_count);
 
 	tsk->mm = mm;
 	tsk->active_mm = mm;
@@ -906,7 +902,6 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	tty_audit_fork(sig);
 
 	sig->oom_adj = current->signal->oom_adj;
-	sig->oom_score_adj = current->signal->oom_score_adj;
 
 	mutex_init(&sig->cred_guard_mutex);
 
@@ -1305,13 +1300,8 @@ bad_fork_cleanup_io:
 bad_fork_cleanup_namespaces:
 	exit_task_namespaces(p);
 bad_fork_cleanup_mm:
-	if (p->mm) {
-		task_lock(p);
-		if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
-			atomic_dec(&p->mm->oom_disable_count);
-		task_unlock(p);
+	if (p->mm)
 		mmput(p->mm);
-	}
 bad_fork_cleanup_signal:
 	if (!(clone_flags & CLONE_THREAD))
 		free_signal_struct(p->signal);
@@ -1704,10 +1694,6 @@ SYSCALL_DEFINE1(unshare, unsigned long, unshare_flags)
 			active_mm = current->active_mm;
 			current->mm = new_mm;
 			current->active_mm = new_mm;
-			if (current->signal->oom_score_adj == OOM_SCORE_ADJ_MIN) {
-				atomic_dec(&mm->oom_disable_count);
-				atomic_inc(&new_mm->oom_disable_count);
-			}
 			activate_mm(active_mm, new_mm);
 			new_mm = mm;
 		}
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9a99cfa..c628370 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -47,7 +47,6 @@
 #include <linux/mm_inline.h>
 #include <linux/page_cgroup.h>
 #include <linux/cpu.h>
-#include <linux/oom.h>
 #include "internal.h"
 
 #include <asm/uaccess.h>
@@ -917,13 +916,10 @@ int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem)
 {
 	int ret;
 	struct mem_cgroup *curr = NULL;
-	struct task_struct *p;
 
-	p = find_lock_task_mm(task);
-	if (!p)
-		return 0;
-	curr = try_get_mem_cgroup_from_mm(p->mm);
-	task_unlock(p);
+	task_lock(task);
+	curr = try_get_mem_cgroup_from_mm(task->mm);
+	task_unlock(task);
 	if (!curr)
 		return 0;
 	/*
@@ -1297,24 +1293,6 @@ static int mem_cgroup_count_children(struct mem_cgroup *mem)
 }
 
 /*
- * Return the memory (and swap, if configured) limit for a memcg.
- */
-u64 mem_cgroup_get_limit(struct mem_cgroup *memcg)
-{
-	u64 limit;
-	u64 memsw;
-
-	limit = res_counter_read_u64(&memcg->res, RES_LIMIT) +
-			total_swap_pages;
-	memsw = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
-	/*
-	 * If memsw is finite and limits the amount of swap space available
-	 * to this memcg, return that limit.
-	 */
-	return min(limit, memsw);
-}
-
-/*
  * Visit the first child (need not be the first child as per the ordering
  * of the cgroup list, since we track last_scanned_child) of @mem and use
  * that to reclaim free pages from.
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 7dcca55..f251ddb 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -4,8 +4,6 @@
  *  Copyright (C)  1998,2000  Rik van Riel
  *	Thanks go out to Claus Fischer for some serious inspiration and
  *	for goading me into coding this file...
- *  Copyright (C)  2010  Google, Inc.
- *	Rewritten by David Rientjes
  *
  *  The routines in this file are used to kill a process when
  *  we're seriously out of memory. This gets called from __alloc_pages()
@@ -36,6 +34,7 @@ int sysctl_panic_on_oom;
 int sysctl_oom_kill_allocating_task;
 int sysctl_oom_dump_tasks = 1;
 static DEFINE_SPINLOCK(zone_scan_lock);
+/* #define DEBUG */
 
 #ifdef CONFIG_NUMA
 /**
@@ -106,7 +105,7 @@ static void boost_dying_task_prio(struct task_struct *p,
  * pointer.  Return p, or any of its subthreads with a valid ->mm, with
  * task_lock() held.
  */
-struct task_struct *find_lock_task_mm(struct task_struct *p)
+static struct task_struct *find_lock_task_mm(struct task_struct *p)
 {
 	struct task_struct *t = p;
 
@@ -121,8 +120,8 @@ struct task_struct *find_lock_task_mm(struct task_struct *p)
 }
 
 /* return true if the task is not adequate as candidate victim task. */
-static bool oom_unkillable_task(struct task_struct *p,
-		const struct mem_cgroup *mem, const nodemask_t *nodemask)
+static bool oom_unkillable_task(struct task_struct *p, struct mem_cgroup *mem,
+			   const nodemask_t *nodemask)
 {
 	if (is_global_init(p))
 		return true;
@@ -141,82 +140,137 @@ static bool oom_unkillable_task(struct task_struct *p,
 }
 
 /**
- * oom_badness - heuristic function to determine which candidate task to kill
+ * badness - calculate a numeric value for how bad this task has been
  * @p: task struct of which task we should calculate
- * @totalpages: total present RAM allowed for page allocation
+ * @uptime: current uptime in seconds
  *
- * The heuristic for determining which task to kill is made to be as simple and
- * predictable as possible.  The goal is to return the highest value for the
- * task consuming the most memory to avoid subsequent oom failures.
+ * The formula used is relatively simple and documented inline in the
+ * function. The main rationale is that we want to select a good task
+ * to kill when we run out of memory.
+ *
+ * Good in this context means that:
+ * 1) we lose the minimum amount of work done
+ * 2) we recover a large amount of memory
+ * 3) we don't kill anything innocent of eating tons of memory
+ * 4) we want to kill the minimum amount of processes (one)
+ * 5) we try to kill the process the user expects us to kill, this
+ *    algorithm has been meticulously tuned to meet the principle
+ *    of least surprise ... (be careful when you change it)
  */
-unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
-		      const nodemask_t *nodemask, unsigned long totalpages)
+unsigned long badness(struct task_struct *p, struct mem_cgroup *mem,
+		      const nodemask_t *nodemask, unsigned long uptime)
 {
-	int points;
+	unsigned long points, cpu_time, run_time;
+	struct task_struct *child;
+	struct task_struct *c, *t;
+	int oom_adj = p->signal->oom_adj;
+	struct task_cputime task_time;
+	unsigned long utime;
+	unsigned long stime;
 
 	if (oom_unkillable_task(p, mem, nodemask))
 		return 0;
+	if (oom_adj == OOM_DISABLE)
+		return 0;
 
 	p = find_lock_task_mm(p);
 	if (!p)
 		return 0;
 
 	/*
-	 * Shortcut check for a thread sharing p->mm that is OOM_SCORE_ADJ_MIN
-	 * so the entire heuristic doesn't need to be executed for something
-	 * that cannot be killed.
+	 * The memory size of the process is the basis for the badness.
 	 */
-	if (atomic_read(&p->mm->oom_disable_count)) {
-		task_unlock(p);
-		return 0;
-	}
+	points = p->mm->total_vm;
+	task_unlock(p);
 
 	/*
-	 * When the PF_OOM_ORIGIN bit is set, it indicates the task should have
-	 * priority for oom killing.
+	 * swapoff can easily use up all memory, so kill those first.
 	 */
-	if (p->flags & PF_OOM_ORIGIN) {
-		task_unlock(p);
-		return 1000;
-	}
+	if (p->flags & PF_OOM_ORIGIN)
+		return ULONG_MAX;
 
 	/*
-	 * The memory controller may have a limit of 0 bytes, so avoid a divide
-	 * by zero, if necessary.
+	 * Processes which fork a lot of child processes are likely
+	 * a good choice. We add half the vmsize of the children if they
+	 * have an own mm. This prevents forking servers to flood the
+	 * machine with an endless amount of children. In case a single
+	 * child is eating the vast majority of memory, adding only half
+	 * to the parents will make the child our kill candidate of choice.
 	 */
-	if (!totalpages)
-		totalpages = 1;
+	t = p;
+	do {
+		list_for_each_entry(c, &t->children, sibling) {
+			child = find_lock_task_mm(c);
+			if (child) {
+				if (child->mm != p->mm)
+					points += child->mm->total_vm/2 + 1;
+				task_unlock(child);
+			}
+		}
+	} while_each_thread(p, t);
 
 	/*
-	 * The baseline for the badness score is the proportion of RAM that each
-	 * task's rss and swap space use.
+	 * CPU time is in tens of seconds and run time is in thousands
+         * of seconds. There is no particular reason for this other than
+         * that it turned out to work very well in practice.
 	 */
-	points = (get_mm_rss(p->mm) + get_mm_counter(p->mm, MM_SWAPENTS)) * 1000 /
-			totalpages;
-	task_unlock(p);
+	thread_group_cputime(p, &task_time);
+	utime = cputime_to_jiffies(task_time.utime);
+	stime = cputime_to_jiffies(task_time.stime);
+	cpu_time = (utime + stime) >> (SHIFT_HZ + 3);
+
+
+	if (uptime >= p->start_time.tv_sec)
+		run_time = (uptime - p->start_time.tv_sec) >> 10;
+	else
+		run_time = 0;
+
+	if (cpu_time)
+		points /= int_sqrt(cpu_time);
+	if (run_time)
+		points /= int_sqrt(int_sqrt(run_time));
 
 	/*
-	 * Root processes get 3% bonus, just like the __vm_enough_memory()
-	 * implementation used by LSMs.
+	 * Niced processes are most likely less important, so double
+	 * their badness points.
 	 */
-	if (has_capability_noaudit(p, CAP_SYS_ADMIN))
-		points -= 30;
+	if (task_nice(p) > 0)
+		points *= 2;
 
 	/*
-	 * /proc/pid/oom_score_adj ranges from -1000 to +1000 such that it may
-	 * either completely disable oom killing or always prefer a certain
-	 * task.
+	 * Superuser processes are usually more important, so we make it
+	 * less likely that we kill those.
 	 */
-	points += p->signal->oom_score_adj;
+	if (has_capability_noaudit(p, CAP_SYS_ADMIN) ||
+	    has_capability_noaudit(p, CAP_SYS_RESOURCE))
+		points /= 4;
 
 	/*
-	 * Never return 0 for an eligible task that may be killed since it's
-	 * possible that no single user task uses more than 0.1% of memory and
-	 * no single admin tasks uses more than 3.0%.
+	 * We don't want to kill a process with direct hardware access.
+	 * Not only could that mess up the hardware, but usually users
+	 * tend to only have this flag set on applications they think
+	 * of as important.
 	 */
-	if (points <= 0)
-		return 1;
-	return (points < 1000) ? points : 1000;
+	if (has_capability_noaudit(p, CAP_SYS_RAWIO))
+		points /= 4;
+
+	/*
+	 * Adjust the score by oom_adj.
+	 */
+	if (oom_adj) {
+		if (oom_adj > 0) {
+			if (!points)
+				points = 1;
+			points <<= oom_adj;
+		} else
+			points >>= -(oom_adj);
+	}
+
+#ifdef DEBUG
+	printk(KERN_DEBUG "OOMkill: task %d (%s) got %lu points\n",
+	p->pid, p->comm, points);
+#endif
+	return points;
 }
 
 /*
@@ -224,20 +278,12 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
  */
 #ifdef CONFIG_NUMA
 static enum oom_constraint constrained_alloc(struct zonelist *zonelist,
-				gfp_t gfp_mask, nodemask_t *nodemask,
-				unsigned long *totalpages)
+				    gfp_t gfp_mask, nodemask_t *nodemask)
 {
 	struct zone *zone;
 	struct zoneref *z;
 	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
-	bool cpuset_limited = false;
-	int nid;
-
-	/* Default to all available memory */
-	*totalpages = totalram_pages + total_swap_pages;
 
-	if (!zonelist)
-		return CONSTRAINT_NONE;
 	/*
 	 * Reach here only when __GFP_NOFAIL is used. So, we should avoid
 	 * to kill current.We have to random task kill in this case.
@@ -247,37 +293,26 @@ static enum oom_constraint constrained_alloc(struct zonelist *zonelist,
 		return CONSTRAINT_NONE;
 
 	/*
-	 * This is not a __GFP_THISNODE allocation, so a truncated nodemask in
-	 * the page allocator means a mempolicy is in effect.  Cpuset policy
-	 * is enforced in get_page_from_freelist().
+	 * The nodemask here is a nodemask passed to alloc_pages(). Now,
+	 * cpuset doesn't use this nodemask for its hardwall/softwall/hierarchy
+	 * feature. mempolicy is an only user of nodemask here.
+	 * check mempolicy's nodemask contains all N_HIGH_MEMORY
 	 */
-	if (nodemask && !nodes_subset(node_states[N_HIGH_MEMORY], *nodemask)) {
-		*totalpages = total_swap_pages;
-		for_each_node_mask(nid, *nodemask)
-			*totalpages += node_spanned_pages(nid);
+	if (nodemask && !nodes_subset(node_states[N_HIGH_MEMORY], *nodemask))
 		return CONSTRAINT_MEMORY_POLICY;
-	}
 
 	/* Check this allocation failure is caused by cpuset's wall function */
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 			high_zoneidx, nodemask)
 		if (!cpuset_zone_allowed_softwall(zone, gfp_mask))
-			cpuset_limited = true;
+			return CONSTRAINT_CPUSET;
 
-	if (cpuset_limited) {
-		*totalpages = total_swap_pages;
-		for_each_node_mask(nid, cpuset_current_mems_allowed)
-			*totalpages += node_spanned_pages(nid);
-		return CONSTRAINT_CPUSET;
-	}
 	return CONSTRAINT_NONE;
 }
 #else
 static enum oom_constraint constrained_alloc(struct zonelist *zonelist,
-				gfp_t gfp_mask, nodemask_t *nodemask,
-				unsigned long *totalpages)
+				gfp_t gfp_mask, nodemask_t *nodemask)
 {
-	*totalpages = totalram_pages + total_swap_pages;
 	return CONSTRAINT_NONE;
 }
 #endif
@@ -288,16 +323,17 @@ static enum oom_constraint constrained_alloc(struct zonelist *zonelist,
  *
  * (not docbooked, we don't want this one cluttering up the manual)
  */
-static struct task_struct *select_bad_process(unsigned int *ppoints,
-		unsigned long totalpages, struct mem_cgroup *mem,
-		const nodemask_t *nodemask)
+static struct task_struct *select_bad_process(unsigned long *ppoints,
+		struct mem_cgroup *mem, const nodemask_t *nodemask)
 {
 	struct task_struct *p;
 	struct task_struct *chosen = NULL;
+	struct timespec uptime;
 	*ppoints = 0;
 
+	do_posix_clock_monotonic_gettime(&uptime);
 	for_each_process(p) {
-		unsigned int points;
+		unsigned long points;
 
 		if (oom_unkillable_task(p, mem, nodemask))
 			continue;
@@ -329,11 +365,11 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
 				return ERR_PTR(-1UL);
 
 			chosen = p;
-			*ppoints = 1000;
+			*ppoints = ULONG_MAX;
 		}
 
-		points = oom_badness(p, mem, nodemask, totalpages);
-		if (points > *ppoints) {
+		points = badness(p, mem, nodemask, uptime.tv_sec);
+		if (points > *ppoints || !chosen) {
 			chosen = p;
 			*ppoints = points;
 		}
@@ -345,24 +381,27 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
 /**
  * dump_tasks - dump current memory state of all system tasks
  * @mem: current's memory controller, if constrained
- * @nodemask: nodemask passed to page allocator for mempolicy ooms
  *
- * Dumps the current memory state of all eligible tasks.  Tasks not in the same
- * memcg, not in the same cpuset, or bound to a disjoint set of mempolicy nodes
- * are not shown.
+ * Dumps the current memory state of all system tasks, excluding kernel threads.
  * State information includes task's pid, uid, tgid, vm size, rss, cpu, oom_adj
- * value, oom_score_adj value, and name.
+ * score, and name.
+ *
+ * If the actual is non-NULL, only tasks that are a member of the mem_cgroup are
+ * shown.
  *
  * Call with tasklist_lock read-locked.
  */
-static void dump_tasks(const struct mem_cgroup *mem, const nodemask_t *nodemask)
+static void dump_tasks(const struct mem_cgroup *mem)
 {
 	struct task_struct *p;
 	struct task_struct *task;
 
-	pr_info("[ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name\n");
+	printk(KERN_INFO "[ pid ]   uid  tgid total_vm      rss cpu oom_adj "
+	       "name\n");
 	for_each_process(p) {
-		if (oom_unkillable_task(p, mem, nodemask))
+		if (p->flags & PF_KTHREAD)
+			continue;
+		if (mem && !task_in_mem_cgroup(p, mem))
 			continue;
 
 		task = find_lock_task_mm(p);
@@ -375,69 +414,43 @@ static void dump_tasks(const struct mem_cgroup *mem, const nodemask_t *nodemask)
 			continue;
 		}
 
-		pr_info("[%5d] %5d %5d %8lu %8lu %3u     %3d         %5d %s\n",
+		pr_info("[%5d] %5d %5d %8lu %8lu %3u     %3d %s\n",
 			task->pid, task_uid(task), task->tgid,
 			task->mm->total_vm, get_mm_rss(task->mm),
-			task_cpu(task), task->signal->oom_adj,
-			task->signal->oom_score_adj, task->comm);
+			task_cpu(task), task->signal->oom_adj, task->comm);
 		task_unlock(task);
 	}
 }
 
 static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
-			struct mem_cgroup *mem, const nodemask_t *nodemask)
+							struct mem_cgroup *mem)
 {
 	task_lock(current);
 	pr_warning("%s invoked oom-killer: gfp_mask=0x%x, order=%d, "
-		"oom_adj=%d, oom_score_adj=%d\n",
-		current->comm, gfp_mask, order, current->signal->oom_adj,
-		current->signal->oom_score_adj);
+		"oom_adj=%d\n",
+		current->comm, gfp_mask, order, current->signal->oom_adj);
 	cpuset_print_task_mems_allowed(current);
 	task_unlock(current);
 	dump_stack();
 	mem_cgroup_print_oom_info(mem, p);
 	show_mem();
 	if (sysctl_oom_dump_tasks)
-		dump_tasks(mem, nodemask);
+		dump_tasks(mem);
 }
 
 #define K(x) ((x) << (PAGE_SHIFT-10))
 static int oom_kill_task(struct task_struct *p, struct mem_cgroup *mem)
 {
-	struct task_struct *q;
-	struct mm_struct *mm;
-
 	p = find_lock_task_mm(p);
 	if (!p)
 		return 1;
 
-	/* mm cannot be safely dereferenced after task_unlock(p) */
-	mm = p->mm;
-
 	pr_err("Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
 		task_pid_nr(p), p->comm, K(p->mm->total_vm),
 		K(get_mm_counter(p->mm, MM_ANONPAGES)),
 		K(get_mm_counter(p->mm, MM_FILEPAGES)));
 	task_unlock(p);
 
-	/*
-	 * Kill all processes sharing p->mm in other thread groups, if any.
-	 * They don't get access to memory reserves or a higher scheduler
-	 * priority, though, to avoid depletion of all memory or task
-	 * starvation.  This prevents mm->mmap_sem livelock when an oom killed
-	 * task cannot exit because it requires the semaphore and its contended
-	 * by another thread trying to allocate memory itself.  That thread will
-	 * now get access to memory reserves since it has a pending fatal
-	 * signal.
-	 */
-	for_each_process(q)
-		if (q->mm == mm && !same_thread_group(q, p)) {
-			task_lock(q);	/* Protect ->comm from prctl() */
-			pr_err("Kill process %d (%s) sharing same memory\n",
-				task_pid_nr(q), q->comm);
-			task_unlock(q);
-			force_sig(SIGKILL, q);
-		}
 
 	set_tsk_thread_flag(p, TIF_MEMDIE);
 	force_sig(SIGKILL, p);
@@ -454,17 +467,17 @@ static int oom_kill_task(struct task_struct *p, struct mem_cgroup *mem)
 #undef K
 
 static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
-			    unsigned int points, unsigned long totalpages,
-			    struct mem_cgroup *mem, nodemask_t *nodemask,
-			    const char *message)
+			    unsigned long points, struct mem_cgroup *mem,
+			    nodemask_t *nodemask, const char *message)
 {
 	struct task_struct *victim = p;
 	struct task_struct *child;
 	struct task_struct *t = p;
-	unsigned int victim_points = 0;
+	unsigned long victim_points = 0;
+	struct timespec uptime;
 
 	if (printk_ratelimit())
-		dump_header(p, gfp_mask, order, mem, nodemask);
+		dump_header(p, gfp_mask, order, mem);
 
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
@@ -477,7 +490,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 	}
 
 	task_lock(p);
-	pr_err("%s: Kill process %d (%s) score %d or sacrifice child\n",
+	pr_err("%s: Kill process %d (%s) score %lu or sacrifice child\n",
 		message, task_pid_nr(p), p->comm, points);
 	task_unlock(p);
 
@@ -487,15 +500,14 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 	 * parent.  This attempts to lose the minimal amount of work done while
 	 * still freeing memory.
 	 */
+	do_posix_clock_monotonic_gettime(&uptime);
 	do {
 		list_for_each_entry(child, &t->children, sibling) {
-			unsigned int child_points;
+			unsigned long child_points;
 
-			/*
-			 * oom_badness() returns 0 if the thread is unkillable
-			 */
-			child_points = oom_badness(child, mem, nodemask,
-								totalpages);
+			/* badness() returns 0 if the thread is unkillable */
+			child_points = badness(child, mem, nodemask,
+					       uptime.tv_sec);
 			if (child_points > victim_points) {
 				victim = child;
 				victim_points = child_points;
@@ -510,7 +522,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
  * Determines whether the kernel must panic because of the panic_on_oom sysctl.
  */
 static void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
-				int order, const nodemask_t *nodemask)
+				int order)
 {
 	if (likely(!sysctl_panic_on_oom))
 		return;
@@ -524,7 +536,7 @@ static void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
 			return;
 	}
 	read_lock(&tasklist_lock);
-	dump_header(NULL, gfp_mask, order, NULL, nodemask);
+	dump_header(NULL, gfp_mask, order, NULL);
 	read_unlock(&tasklist_lock);
 	panic("Out of memory: %s panic_on_oom is enabled\n",
 		sysctl_panic_on_oom == 2 ? "compulsory" : "system-wide");
@@ -533,19 +545,17 @@ static void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask)
 {
-	unsigned long limit;
-	unsigned int points = 0;
+	unsigned long points = 0;
 	struct task_struct *p;
 
-	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, 0, NULL);
-	limit = mem_cgroup_get_limit(mem) >> PAGE_SHIFT;
+	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, 0);
 	read_lock(&tasklist_lock);
 retry:
-	p = select_bad_process(&points, limit, mem, NULL);
+	p = select_bad_process(&points, mem, NULL);
 	if (!p || PTR_ERR(p) == -1UL)
 		goto out;
 
-	if (oom_kill_process(p, gfp_mask, 0, points, limit, mem, NULL,
+	if (oom_kill_process(p, gfp_mask, 0, points, mem, NULL,
 				"Memory cgroup out of memory"))
 		goto retry;
 out:
@@ -669,11 +679,9 @@ static void clear_system_oom(void)
 void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 		int order, nodemask_t *nodemask)
 {
-	const nodemask_t *mpol_mask;
 	struct task_struct *p;
-	unsigned long totalpages;
 	unsigned long freed = 0;
-	unsigned int points;
+	unsigned long points;
 	enum oom_constraint constraint = CONSTRAINT_NONE;
 	int killed = 0;
 
@@ -697,40 +705,41 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 	 * Check if there were limitations on the allocation (only relevant for
 	 * NUMA) that may require different handling.
 	 */
-	constraint = constrained_alloc(zonelist, gfp_mask, nodemask,
-						&totalpages);
-	mpol_mask = (constraint == CONSTRAINT_MEMORY_POLICY) ? nodemask : NULL;
-	check_panic_on_oom(constraint, gfp_mask, order, mpol_mask);
+	if (zonelist)
+		constraint = constrained_alloc(zonelist, gfp_mask, nodemask);
+	check_panic_on_oom(constraint, gfp_mask, order);
 
 	read_lock(&tasklist_lock);
 	if (sysctl_oom_kill_allocating_task &&
 	    !oom_unkillable_task(current, NULL, nodemask) &&
-	    current->mm && !atomic_read(&current->mm->oom_disable_count)) {
+	    (current->signal->oom_adj != OOM_DISABLE)) {
 		/*
 		 * oom_kill_process() needs tasklist_lock held.  If it returns
 		 * non-zero, current could not be killed so we must fallback to
 		 * the tasklist scan.
 		 */
-		if (!oom_kill_process(current, gfp_mask, order, 0, totalpages,
-				NULL, nodemask,
+		if (!oom_kill_process(current, gfp_mask, order, 0, NULL,
+				nodemask,
 				"Out of memory (oom_kill_allocating_task)"))
 			goto out;
 	}
 
 retry:
-	p = select_bad_process(&points, totalpages, NULL, mpol_mask);
+	p = select_bad_process(&points, NULL,
+			constraint == CONSTRAINT_MEMORY_POLICY ? nodemask :
+								 NULL);
 	if (PTR_ERR(p) == -1UL)
 		goto out;
 
 	/* Found nothing?!?! Either we hang forever, or we panic. */
 	if (!p) {
-		dump_header(NULL, gfp_mask, order, NULL, mpol_mask);
+		dump_header(NULL, gfp_mask, order, NULL);
 		read_unlock(&tasklist_lock);
 		panic("Out of memory and no killable processes...\n");
 	}
 
-	if (oom_kill_process(p, gfp_mask, order, points, totalpages, NULL,
-				nodemask, "Out of memory"))
+	if (oom_kill_process(p, gfp_mask, order, points, NULL, nodemask,
+			     "Out of memory"))
 		goto retry;
 	killed = 1;
 out:
-- 
1.6.5.2



