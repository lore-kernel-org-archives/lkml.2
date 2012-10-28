Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab2J1TTA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 15:19:00 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:50587 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752248Ab2J1TS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 15:18:58 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1928RgZf8d2iZ77r8DHDQPddRTvCWMuusBYNBgoc4
	V9FvHNhy3ePajg
Message-ID: <1351451963.4999.8.camel@maggy.simpson.net>
Subject: [PATCH] V2 sched, autogroup: fix crash on reboot when autogroup is
 disabled
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Xiaotian Feng <xtfeng@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Xiaotian Feng <dannyfeng@tencent.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Sun, 28 Oct 2012 12:19:23 -0700
In-Reply-To: <20121028140544.GA28216@gmail.com>
References: <1350635770-9189-1-git-send-email-xtfeng@gmail.com>
	 <1350654126.2768.5.camel@twins>
	 <CAJn8CcE5McFB-FH981Pj+eahNOt8ck3ncJwD4xocU_LrAtjBHA@mail.gmail.com>
	 <1350736696.5123.24.camel@maggy.simpson.net>
	 <1351283371.16639.111.camel@maggy.simpson.net>
	 <1351362370.4503.3.camel@maggy.simpson.net>
	 <20121028102520.GA7711@gmail.com>
	 <1351430004.8685.17.camel@maggy.simpson.net>
	 <20121028131950.GA15159@gmail.com>
	 <1351431201.8685.22.camel@maggy.simpson.net>
	 <20121028140544.GA28216@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-10-28 at 15:05 +0100, Ingo Molnar wrote: 
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Sun, 2012-10-28 at 14:19 +0100, Ingo Molnar wrote: 
> > > * Mike Galbraith <efault@gmx.de> wrote:
> > > 
> > > > On Sun, 2012-10-28 at 11:25 +0100, Ingo Molnar wrote: 
> > > > > * Mike Galbraith <efault@gmx.de> wrote:
> > > > > 
> > > > 
> > > > > > No knobs, no glitz, nada, just a cute little thing folks can turn
> > > > > > on if they don't want to muck about with cgroups and/or systemd.
> > > > > 
> > > > > Please also keep the Kconfig switch and reuse it to turn on 
> > > > > the 'autogroups' knob.
> > > > > 
> > > > > That way people with existing .config's don't have to change 
> > > > > a thing to get this functionality.
> > > > 
> > > > The Kconfig option is still there.  The noautogroup -> 
> > > > autogroup arg change just makes it off by default (since an 
> > > > on/off switch would have to be a full move everybody thing 
> > > > post 8323f26ce race fix), so distros can make it available in 
> > > > their swiss army knife config, but it'll be out of the way 
> > > > unless specifically asked for by the user at boot.
> > > > 
> > > > I can make it default 'on' by removing that arg change if you 
> > > > think that's the better way to go, but opt in at boot sounded 
> > > > better to me given there is no runtime on/off switch at all 
> > > > now.
> > > 
> > > If I got your patch right then adding a command line option to 
> > > turn it on will disable it in essence for pretty much everyone 
> > > who has CONFIG_SCHED_AUTOGROUP=y in their .config today.
> > 
> > With no user intervention, yes.
> 
> 'No user intervention' is what happens with new kernel 
> commandline options, in 99.9999% of the cases.
> 
> > > The patch should not change the defaults for existing 
> > > .config's.
> > > 
> > > I.e. if autogroups was off, it should stay off, but if 
> > > autogroups was enabled in the .config and the kernel booted 
> > > with it enabled, then it should continue to do so in the 
> > > future as well.
> > > 
> > > Adding a boot tweak and removing the runtime knobs is OK - 
> > > changing the current default functionality is not.
> > 
> > Ok, I'll whack the arg change and respin.
> 
> Thanks!
> 
> I'd also suggest to still expose the state of autosched in 
> /proc/sys, read-only, so that its status can be checked.

Done.  Autogroup remains default on with noautogroup opt out at boot
time as before.  Sysctl remains intact, read only.  Knobs are gone.

sched, autogroup: fix crash on reboot when autogroup is disabled

Between 8323f26ce and 800d4d30, autogroup is a wreck.  With both
applied, all you have to do to crash a box is disable autogroup
during boot up, then reboot.. boom, NULL pointer dereference due
to 800d4d30 not allowing autogroup to move things, and 8323f26ce
making that the only way to switch runqueues.

Remove all of the knobs, as what wasn't broken would be by making
autogroup exclusively either on or off from boot, with off meaning
autogroups are not created, so unavailable for proc interface.

If the user fiddles with cgroups hereafter, tough, once tasks are
moved, autogroup won't mess with them again unless they call setsid().

No knobs, no glitz, nada, just a cute little thing folks can turn
on if they don't want to muck about with cgroups and/or systemd.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: stable@vger.kernel.org v3.6

---
 fs/proc/base.c            |   78 ----------------------------------------------
 kernel/sched/auto_group.c |   68 ++++++----------------------------------
 kernel/sched/auto_group.h |    9 -----
 kernel/sysctl.c           |    6 +--
 4 files changed, 14 insertions(+), 147 deletions(-)

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
--- a/kernel/sched/auto_group.c
+++ b/kernel/sched/auto_group.c
@@ -110,6 +110,9 @@ static inline struct autogroup *autogrou
 
 bool task_wants_autogroup(struct task_struct *p, struct task_group *tg)
 {
+	if (!sysctl_sched_autogroup_enabled)
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
 
@@ -193,58 +199,6 @@ static int __init setup_autogroup(char *
 
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
@@ -367,10 +367,8 @@ static struct ctl_table kern_table[] = {
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


