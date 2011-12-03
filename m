Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab1LCJu4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 04:50:56 -0500
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:16980 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab1LCJuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 04:50:55 -0500
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Dec 2011 04:50:54 EST
From: Daniel Lezcano <daniel.lezcano@free.fr>
To: akpm@linux-foundation.org
Cc: serge.hallyn@canonical.com, oleg@redhat.com,
        containers@lists.linux-foundation.org, gkurz@fr.ibm.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Add reboot_pid_ns to handle the reboot syscall
Date: Sat,  3 Dec 2011 10:42:44 +0100
Message-Id: <1322905364-29538-1-git-send-email-daniel.lezcano@free.fr>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of a child pid namespace, rebooting the system does not
really makes sense. When the pid namespace is used in conjunction
with the other namespaces in order to create a linux container, the
reboot syscall leads to some problems.

A container can reboot the host. That can be fixed by dropping
the sys_reboot capability but we are unable to correctly to poweroff/
halt/reboot a container and the container stays stuck at the shutdown
time with the container's init process waiting indefinitively.

After several attempts, no solution from userspace was found to reliabily
handle the shutdown from a container.

This patch propose to store the reboot value in the 16 upper bits of the
exit code from the processes belonging to a pid namespace which has
rebooted. When the reboot syscall is called and we are not in the initial
pid namespace, we kill the pid namespace.

By this way the parent process of the child pid namespace to know if
it rebooted or not and take the right decision.

Signed-off-by: Daniel Lezcano <daniel.lezcano@free.fr>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
---
 include/linux/pid_namespace.h |    7 +++++++
 kernel/exit.c                 |    5 ++++-
 kernel/pid_namespace.c        |   25 +++++++++++++++++++++++++
 kernel/sys.c                  |    4 ++++
 4 files changed, 40 insertions(+), 1 deletions(-)

diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index e7cf666..b31d82a 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -32,6 +32,7 @@ struct pid_namespace {
 #endif
 	gid_t pid_gid;
 	int hide_pid;
+	int reboot;
 };
 
 extern struct pid_namespace init_pid_ns;
@@ -47,6 +48,7 @@ static inline struct pid_namespace *get_pid_ns(struct pid_namespace *ns)
 extern struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *ns);
 extern void free_pid_ns(struct kref *kref);
 extern void zap_pid_ns_processes(struct pid_namespace *pid_ns);
+extern int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd);
 
 static inline void put_pid_ns(struct pid_namespace *ns)
 {
@@ -79,6 +81,11 @@ static inline void zap_pid_ns_processes(struct pid_namespace *ns)
 {
 	BUG();
 }
+
+static inline int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd)
+{
+	return 0;
+}
 #endif /* CONFIG_PID_NS */
 
 extern struct pid_namespace *task_active_pid_ns(struct task_struct *tsk);
diff --git a/kernel/exit.c b/kernel/exit.c
index 09f8783..0a865885 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1192,6 +1192,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 	pid_t pid = task_pid_vnr(p);
 	uid_t uid = __task_cred(p)->uid;
 	struct siginfo __user *infop;
+	struct pid_namespace *pid_ns = task_active_pid_ns(p);
 
 	if (!likely(wo->wo_flags & WEXITED))
 		return 0;
@@ -1291,8 +1292,10 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
 	status = (p->signal->flags & SIGNAL_GROUP_EXIT)
 		? p->signal->group_exit_code : p->exit_code;
-	if (!retval && wo->wo_stat)
+	if (!retval && wo->wo_stat) {
+		status |= (pid_ns->reboot & ~0xffff);
 		retval = put_user(status, wo->wo_stat);
+	}
 
 	infop = wo->wo_info;
 	if (!retval && infop)
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index a896839..a1d342d 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -15,6 +15,7 @@
 #include <linux/acct.h>
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
+#include <linux/reboot.h>
 
 #define BITS_PER_PAGE		(PAGE_SIZE*8)
 
@@ -221,6 +222,30 @@ static struct ctl_table pid_ns_ctl_table[] = {
 
 static struct ctl_path kern_path[] = { { .procname = "kernel", }, { } };
 
+int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd)
+{
+	switch(cmd) {
+	case LINUX_REBOOT_CMD_RESTART2:
+	case LINUX_REBOOT_CMD_RESTART:
+		pid_ns->reboot = SYSTEM_RESTART << 16;
+		break;
+
+	case LINUX_REBOOT_CMD_HALT:
+		pid_ns->reboot = SYSTEM_HALT << 16;
+		break;
+
+	case LINUX_REBOOT_CMD_POWER_OFF:
+		pid_ns->reboot = SYSTEM_POWER_OFF << 16;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	force_sig(SIGKILL, pid_ns->child_reaper);
+
+	return 0;
+}
+
 static __init int pid_namespaces_init(void)
 {
 	pid_ns_cachep = KMEM_CACHE(pid_namespace, SLAB_PANIC);
diff --git a/kernel/sys.c b/kernel/sys.c
index ddf8155..02d9645 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -429,6 +429,7 @@ static DEFINE_MUTEX(reboot_mutex);
 SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 		void __user *, arg)
 {
+	struct pid_namespace *pid_ns = current->nsproxy->pid_ns;
 	char buffer[256];
 	int ret = 0;
 
@@ -450,6 +451,9 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 	if ((cmd == LINUX_REBOOT_CMD_POWER_OFF) && !pm_power_off)
 		cmd = LINUX_REBOOT_CMD_HALT;
 
+	if (pid_ns != &init_pid_ns)
+		return reboot_pid_ns(pid_ns, cmd);
+
 	mutex_lock(&reboot_mutex);
 	switch (cmd) {
 	case LINUX_REBOOT_CMD_RESTART:
-- 
1.7.5.4

