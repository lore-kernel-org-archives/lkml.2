Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433Ab2J0SZn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 14:25:43 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:34942 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759406Ab2J0SZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 14:25:41 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/wJrx6nofwIozwmDRCTos1p4LCmgvdCmg7DHXyQR
	Vx40W7e6WzeVB1
Message-ID: <1351362370.4503.3.camel@maggy.simpson.net>
Subject: [PATCH] sched, autogroup: fix crash on reboot when autogroup is
 disabled
From: Mike Galbraith <efault@gmx.de>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Xiaotian Feng <dannyfeng@tencent.com>, Ingo Molnar <mingo@redhat.com>
Date: Sat, 27 Oct 2012 11:26:10 -0700
In-Reply-To: <1351283371.16639.111.camel@maggy.simpson.net>
References: <1350635770-9189-1-git-send-email-xtfeng@gmail.com>
	 <1350654126.2768.5.camel@twins>
	 <CAJn8CcE5McFB-FH981Pj+eahNOt8ck3ncJwD4xocU_LrAtjBHA@mail.gmail.com>
	 <1350736696.5123.24.camel@maggy.simpson.net>
	 <1351283371.16639.111.camel@maggy.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 13:29 -0700, Mike Galbraith wrote: 
> On Sat, 2012-10-20 at 08:38 -0400, Mike Galbraith wrote:
> 
> > So what I would do is either let the user decide once at boot, in which
> > case if off, creating groups would be stupid), or, just rip autogroup
> > completely out, since systemd is taking over the known universe anyway.
> 
> I'm traveling, but have somewhat functional connectivity ATM, so..
> 
> Peter: which would prefer.  Simple noautogroup -> autogroup one time
> only boottime enable, and autogroup lives on (I like it for my laptop)
> with backport for stable.

Like so, with bonus points for extra minus signs.

sched, autogroup: fix crash on reboot when autogroup is disabled

Between 8323f26ce and 800d4d30, autogroup is a wreck.  With both
applied, all you have to do to crash a box is disable autogroup
during boot up, then reboot.. boom, NULL pointer dereference due
to 800d4d30 not allowing autogroup to move things, and 8323f26ce
making that the only way to switch runqueues.

Remove all of the knobs, and make autogroup only go active if the
user provides 'autogroup' on the command line.  This allows distros
to offer it, once the user asks for it, it's on.  If the user then
fiddles with cgroups, tough, once tasks are moved, autogroup won't
mess with them again unless they call setsid().

No knobs, no glitz, nada, just a cute little thing folks can turn
on if they don't want to muck about with cgroups and/or systemd.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: stable@vger.kernel.org v3.6

---
 Documentation/kernel-parameters.txt |    4 -
 fs/proc/base.c                      |   78 ------------------------------------
 include/linux/sched.h               |    2 
 kernel/sched/auto_group.c           |   74 ++++++----------------------------
 kernel/sched/auto_group.h           |    9 ----
 kernel/sysctl.c                     |   11 -----
 6 files changed, 17 insertions(+), 161 deletions(-)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -367,6 +367,8 @@ bytes respectively. Such letter suffixes
 	autoconf=	[IPV6]
 			See Documentation/networking/ipv6.txt.
 
+	autogroup	Enable scheduler automatic task group creation.
+
 	show_lapic=	[APIC,X86] Advanced Programmable Interrupt Controller
 			Limit apic dumping. The parameter defines the maximal
 			number of local apics being dumped. Also it is possible
@@ -1810,8 +1812,6 @@ bytes respectively. Such letter suffixes
 	noapic		[SMP,APIC] Tells the kernel to not make use of any
 			IOAPICs that may be present in the system.
 
-	noautogroup	Disable scheduler automatic task group creation.
-
 	nobats		[PPC] Do not use BATs for mapping kernel lowmem
 			on "Classic" PPC cores.
 
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1165,81 +1165,6 @@ static const struct file_operations proc
 
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
@@ -2550,9 +2475,6 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
-#ifdef CONFIG_SCHED_AUTOGROUP
-	REG("autogroup",  S_IRUGO|S_IWUSR, proc_pid_sched_autogroup_operations),
-#endif
 	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	INF("syscall",    S_IRUGO, proc_pid_syscall),
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2020,8 +2020,6 @@ int sched_rt_handler(struct ctl_table *t
 		loff_t *ppos);
 
 #ifdef CONFIG_SCHED_AUTOGROUP
-extern unsigned int sysctl_sched_autogroup_enabled;
-
 extern void sched_autogroup_create_attach(struct task_struct *p);
 extern void sched_autogroup_detach(struct task_struct *p);
 extern void sched_autogroup_fork(struct signal_struct *sig);
--- a/kernel/sched/auto_group.c
+++ b/kernel/sched/auto_group.c
@@ -9,7 +9,7 @@
 #include <linux/security.h>
 #include <linux/export.h>
 
-unsigned int __read_mostly sysctl_sched_autogroup_enabled = 1;
+unsigned int __read_mostly autogroup_enabled = 0;
 static struct autogroup autogroup_default;
 static atomic_t autogroup_seq_nr;
 
@@ -110,6 +110,9 @@ static inline struct autogroup *autogrou
 
 bool task_wants_autogroup(struct task_struct *p, struct task_group *tg)
 {
+	if (!autogroup_enabled)
+		return false;
+
 	if (tg != &root_task_group)
 		return false;
 
@@ -143,15 +146,11 @@ autogroup_move_group(struct task_struct
 
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
@@ -159,8 +158,11 @@ autogroup_move_group(struct task_struct
 /* Allocates GFP_KERNEL, cannot be called under any spinlock */
 void sched_autogroup_create_attach(struct task_struct *p)
 {
-	struct autogroup *ag = autogroup_create();
+	struct autogroup *ag;
 
+	if (!autogroup_enabled)
+		return;
+	ag = autogroup_create();
 	autogroup_move_group(p, ag);
 	/* drop extra reference added by autogroup_create() */
 	autogroup_kref_put(ag);
@@ -176,74 +178,26 @@ EXPORT_SYMBOL(sched_autogroup_detach);
 
 void sched_autogroup_fork(struct signal_struct *sig)
 {
+	if (!autogroup_enabled)
+		return;
 	sig->autogroup = autogroup_task_get(current);
 }
 
 void sched_autogroup_exit(struct signal_struct *sig)
 {
+	if (!autogroup_enabled)
+		return;
 	autogroup_kref_put(sig->autogroup);
 }
 
 static int __init setup_autogroup(char *str)
 {
-	sysctl_sched_autogroup_enabled = 0;
+	autogroup_enabled = 1;
 
 	return 1;
 }
 
-__setup("noautogroup", setup_autogroup);
-
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
+__setup("autogroup", setup_autogroup);
 
 #ifdef CONFIG_SCHED_DEBUG
 int autogroup_path(struct task_group *tg, char *buf, int buflen)
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
@@ -29,9 +24,7 @@ extern bool task_wants_autogroup(struct
 static inline struct task_group *
 autogroup_task_group(struct task_struct *p, struct task_group *tg)
 {
-	int enabled = ACCESS_ONCE(sysctl_sched_autogroup_enabled);
-
-	if (enabled && task_wants_autogroup(p, tg))
+	if (task_wants_autogroup(p, tg))
 		return p->signal->autogroup->tg;
 
 	return tg;
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -362,17 +362,6 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= sched_rt_handler,
 	},
-#ifdef CONFIG_SCHED_AUTOGROUP
-	{
-		.procname	= "sched_autogroup_enabled",
-		.data		= &sysctl_sched_autogroup_enabled,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
-		.extra2		= &one,
-	},
-#endif
 #ifdef CONFIG_CFS_BANDWIDTH
 	{
 		.procname	= "sched_cfs_bandwidth_slice_us",


