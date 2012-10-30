Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933655Ab2J3MaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:30:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41376 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab2J3MaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:30:17 -0400
Date: Tue, 30 Oct 2012 05:28:41 -0700
From: tip-bot for Mike Galbraith <efault@gmx.de>
Message-ID: <tip-5258f386ea4e8454bc801fb443e8a4217da1947c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, efault@gmx.de,
        akpm@linux-foundation.org, dannyfeng@tencent.com, oleg@redhat.com,
        tglx@linutronix.de, xtfeng@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, efault@gmx.de, peterz@infradead.org,
        akpm@linux-foundation.org, dannyfeng@tencent.com, tglx@linutronix.de,
        oleg@redhat.com, xtfeng@gmail.com
In-Reply-To: <1351451963.4999.8.camel@maggy.simpson.net>
References: <1351451963.4999.8.camel@maggy.simpson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/autogroup:
  Fix crash on reboot when autogroup is disabled
Git-Commit-ID: 5258f386ea4e8454bc801fb443e8a4217da1947c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 30 Oct 2012 05:28:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5258f386ea4e8454bc801fb443e8a4217da1947c
Gitweb:     http://git.kernel.org/tip/5258f386ea4e8454bc801fb443e8a4217da1947c
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Sun, 28 Oct 2012 12:19:23 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Oct 2012 10:26:04 +0100

sched/autogroup: Fix crash on reboot when autogroup is disabled

Due to these two commits:

  8323f26ce342 sched: Fix race in task_group()
  800d4d30c8f2 sched, autogroup: Stop going ahead if autogroup is disabled

... autogroup scheduling's dynamic knobs are wrecked.

With both patches applied, all you have to do to crash a box is
disable autogroup during boot up, then reboot.. boom, NULL pointer
dereference due to 800d4d30 not allowing autogroup to move things,
and 8323f26ce making that the only way to switch runqueues.

Remove most of the (dysfunctional) knobs and turn the remaining
sched_autogroup_enabled knob readonly.

If the user fiddles with cgroups hereafter, once tasks
are moved, autogroup won't mess with them again unless
they call setsid().

No knobs, no glitz, nada, just a cute little thing folks can
turn on if they don't want to muck about with cgroups and/or
systemd.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Xiaotian Feng <xtfeng@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Xiaotian Feng <dannyfeng@tencent.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org> # v3.6
Link: http://lkml.kernel.org/r/1351451963.4999.8.camel@maggy.simpson.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 fs/proc/base.c            |   78 ---------------------------------------------
 kernel/sched/auto_group.c |   68 ++++++---------------------------------
 kernel/sched/auto_group.h |    9 +-----
 kernel/sysctl.c           |    6 +--
 4 files changed, 14 insertions(+), 147 deletions(-)

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
