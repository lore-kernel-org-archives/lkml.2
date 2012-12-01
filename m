Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab2LALQQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 06:16:16 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:39180 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab2LALQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 06:16:14 -0500
Date: Sat, 1 Dec 2012 12:16:09 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC GIT PULL] scheduler fix for autogroups
Message-ID: <20121201111609.GA18679@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please [RFC] pull the latest sched-urgent-for-linus git tree 
from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   HEAD: 5258f386ea4e8454bc801fb443e8a4217da1947c sched/autogroup: Fix crash on reboot when autogroup is disabled

Larger and scarier than what I'd like to have so I marked it 
[RFC], but the autogroup fix looks important enough - it's 
enabled in a number of distros.

[ The other reason for the RFC: unfortunately the new feature 
  flag change "sched: Add WAKEUP_PREEMPTION feature flag, on by 
  default" got added weeks ago and got stuck below the autogroup 
  fix - I can rebase and untangle it if it's a problem. (It is 
  not expected to cause any change in behavior or problems.) ]

Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      sched: Add WAKEUP_PREEMPTION feature flag, on by default

Mike Galbraith (1):
      sched/autogroup: Fix crash on reboot when autogroup is disabled


 fs/proc/base.c            | 78 -----------------------------------------------
 kernel/sched/auto_group.c | 68 +++++++----------------------------------
 kernel/sched/auto_group.h |  9 +-----
 kernel/sched/fair.c       |  2 +-
 kernel/sched/features.h   |  5 +++
 kernel/sysctl.c           |  6 ++--
 6 files changed, 20 insertions(+), 148 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 1b6c84c..bb1d962 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1271,81 +1271,6 @@ static const struct file_operations proc_pid_sched_operations = {
 
 #endif
 
-#ifdef CONFIG_SCHED_AUTOGROUP
-/*
- * Print out autogroup related information:
- */
-static int sched_autogroup_show(struct seq_file *m, void *v)
-{
-	struct inode *inode = m->private;
-	struct task_struct *p;
-
-	p = get_proc_task(inode);
-	if (!p)
-		return -ESRCH;
-	proc_sched_autogroup_show_task(p, m);
-
-	put_task_struct(p);
-
-	return 0;
-}
-
-static ssize_t
-sched_autogroup_write(struct file *file, const char __user *buf,
-	    size_t count, loff_t *offset)
-{
-	struct inode *inode = file->f_path.dentry->d_inode;
-	struct task_struct *p;
-	char buffer[PROC_NUMBUF];
-	int nice;
-	int err;
-
-	memset(buffer, 0, sizeof(buffer));
-	if (count > sizeof(buffer) - 1)
-		count = sizeof(buffer) - 1;
-	if (copy_from_user(buffer, buf, count))
-		return -EFAULT;
-
-	err = kstrtoint(strstrip(buffer), 0, &nice);
-	if (err < 0)
-		return err;
-
-	p = get_proc_task(inode);
-	if (!p)
-		return -ESRCH;
-
-	err = proc_sched_autogroup_set_nice(p, nice);
-	if (err)
-		count = err;
-
-	put_task_struct(p);
-
-	return count;
-}
-
-static int sched_autogroup_open(struct inode *inode, struct file *filp)
-{
-	int ret;
-
-	ret = single_open(filp, sched_autogroup_show, NULL);
-	if (!ret) {
-		struct seq_file *m = filp->private_data;
-
-		m->private = inode;
-	}
-	return ret;
-}
-
-static const struct file_operations proc_pid_sched_autogroup_operations = {
-	.open		= sched_autogroup_open,
-	.read		= seq_read,
-	.write		= sched_autogroup_write,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-#endif /* CONFIG_SCHED_AUTOGROUP */
-
 static ssize_t comm_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *offset)
 {
@@ -3036,9 +2961,6 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
-#ifdef CONFIG_SCHED_AUTOGROUP
-	REG("autogroup",  S_IRUGO|S_IWUSR, proc_pid_sched_autogroup_operations),
-#endif
 	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	INF("syscall",    S_IRUGO, proc_pid_syscall),
diff --git a/kernel/sched/auto_group.c b/kernel/sched/auto_group.c
index 0984a21..0f1bacb 100644
--- a/kernel/sched/auto_group.c
+++ b/kernel/sched/auto_group.c
@@ -110,6 +110,9 @@ out_fail:
 
 bool task_wants_autogroup(struct task_struct *p, struct task_group *tg)
 {
+	if (!sysctl_sched_autogroup_enabled)
+		return false;
+
 	if (tg != &root_task_group)
 		return false;
 
@@ -143,15 +146,11 @@ autogroup_move_group(struct task_struct *p, struct autogroup *ag)
 
 	p->signal->autogroup = autogroup_kref_get(ag);
 
-	if (!ACCESS_ONCE(sysctl_sched_autogroup_enabled))
-		goto out;
-
 	t = p;
 	do {
 		sched_move_task(t);
 	} while_each_thread(p, t);
 
-out:
 	unlock_task_sighand(p, &flags);
 	autogroup_kref_put(prev);
 }
@@ -159,8 +158,11 @@ out:
 /* Allocates GFP_KERNEL, cannot be called under any spinlock */
 void sched_autogroup_create_attach(struct task_struct *p)
 {
-	struct autogroup *ag = autogroup_create();
+	struct autogroup *ag;
 
+	if (!sysctl_sched_autogroup_enabled)
+		return;
+	ag = autogroup_create();
 	autogroup_move_group(p, ag);
 	/* drop extra reference added by autogroup_create() */
 	autogroup_kref_put(ag);
@@ -176,11 +178,15 @@ EXPORT_SYMBOL(sched_autogroup_detach);
 
 void sched_autogroup_fork(struct signal_struct *sig)
 {
+	if (!sysctl_sched_autogroup_enabled)
+		return;
 	sig->autogroup = autogroup_task_get(current);
 }
 
 void sched_autogroup_exit(struct signal_struct *sig)
 {
+	if (!sysctl_sched_autogroup_enabled)
+		return;
 	autogroup_kref_put(sig->autogroup);
 }
 
@@ -193,58 +199,6 @@ static int __init setup_autogroup(char *str)
 
 __setup("noautogroup", setup_autogroup);
 
-#ifdef CONFIG_PROC_FS
-
-int proc_sched_autogroup_set_nice(struct task_struct *p, int nice)
-{
-	static unsigned long next = INITIAL_JIFFIES;
-	struct autogroup *ag;
-	int err;
-
-	if (nice < -20 || nice > 19)
-		return -EINVAL;
-
-	err = security_task_setnice(current, nice);
-	if (err)
-		return err;
-
-	if (nice < 0 && !can_nice(current, nice))
-		return -EPERM;
-
-	/* this is a heavy operation taking global locks.. */
-	if (!capable(CAP_SYS_ADMIN) && time_before(jiffies, next))
-		return -EAGAIN;
-
-	next = HZ / 10 + jiffies;
-	ag = autogroup_task_get(p);
-
-	down_write(&ag->lock);
-	err = sched_group_set_shares(ag->tg, prio_to_weight[nice + 20]);
-	if (!err)
-		ag->nice = nice;
-	up_write(&ag->lock);
-
-	autogroup_kref_put(ag);
-
-	return err;
-}
-
-void proc_sched_autogroup_show_task(struct task_struct *p, struct seq_file *m)
-{
-	struct autogroup *ag = autogroup_task_get(p);
-
-	if (!task_group_is_autogroup(ag->tg))
-		goto out;
-
-	down_read(&ag->lock);
-	seq_printf(m, "/autogroup-%ld nice %d\n", ag->id, ag->nice);
-	up_read(&ag->lock);
-
-out:
-	autogroup_kref_put(ag);
-}
-#endif /* CONFIG_PROC_FS */
-
 #ifdef CONFIG_SCHED_DEBUG
 int autogroup_path(struct task_group *tg, char *buf, int buflen)
 {
diff --git a/kernel/sched/auto_group.h b/kernel/sched/auto_group.h
index 8bd0471..4552c6b 100644
--- a/kernel/sched/auto_group.h
+++ b/kernel/sched/auto_group.h
@@ -4,11 +4,6 @@
 #include <linux/rwsem.h>
 
 struct autogroup {
-	/*
-	 * reference doesn't mean how many thread attach to this
-	 * autogroup now. It just stands for the number of task
-	 * could use this autogroup.
-	 */
 	struct kref		kref;
 	struct task_group	*tg;
 	struct rw_semaphore	lock;
@@ -29,9 +24,7 @@ extern bool task_wants_autogroup(struct task_struct *p, struct task_group *tg);
 static inline struct task_group *
 autogroup_task_group(struct task_struct *p, struct task_group *tg)
 {
-	int enabled = ACCESS_ONCE(sysctl_sched_autogroup_enabled);
-
-	if (enabled && task_wants_autogroup(p, tg))
+	if (task_wants_autogroup(p, tg))
 		return p->signal->autogroup->tg;
 
 	return tg;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6b800a1..f936552 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2907,7 +2907,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	 * Batch and idle tasks do not preempt non-idle tasks (their preemption
 	 * is driven by the tick):
 	 */
-	if (unlikely(p->policy != SCHED_NORMAL))
+	if (unlikely(p->policy != SCHED_NORMAL) || !sched_feat(WAKEUP_PREEMPTION))
 		return;
 
 	find_matching_se(&se, &pse);
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index eebefca..e68e69a 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -32,6 +32,11 @@ SCHED_FEAT(LAST_BUDDY, true)
 SCHED_FEAT(CACHE_HOT_BUDDY, true)
 
 /*
+ * Allow wakeup-time preemption of the current task:
+ */
+SCHED_FEAT(WAKEUP_PREEMPTION, true)
+
+/*
  * Use arch dependent cpu power functions
  */
 SCHED_FEAT(ARCH_POWER, true)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 81c7b1a..2914d0f 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -363,10 +363,8 @@ static struct ctl_table kern_table[] = {
 		.procname	= "sched_autogroup_enabled",
 		.data		= &sysctl_sched_autogroup_enabled,
 		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &one,
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_CFS_BANDWIDTH
