Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab2AUWKD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 17:10:03 -0500
Received: from seven.medozas.de ([188.40.89.202]:46258 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737Ab2AUWJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 17:09:48 -0500
From: Jan Engelhardt <jengelh@medozas.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 1/2] treewide: fix memory corruptions when TASK_COMM_LEN != 16
Date: Sat, 21 Jan 2012 23:09:44 +0100
Message-Id: <1327183785-27023-1-git-send-email-jengelh@medozas.de>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found that the kernel BUG()s out, already during boot, when bumping
TASK_COMM_LEN to a value larger than 16 (and I can imagine the same
problem unfolding as well if it is set to something smaller).

Various places do insufficient length checks, simply assume certain
sizes or hardcode things. Even though e.g. get_task_comm clearly
documents that its buffer ought to be TASK_COMM_LEN long, I do believe
that an extra size parameter, such as added in this patch, is a lot
more robust than relying on callers getting the buffer size right.

With this patch, I no longer experience crashes, but that is not to
say that there are not any further places (e.g. in modules I never
use) with flakey ->comm handling.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 arch/x86/ia32/sys_ia32.c    |    2 +-
 drivers/connector/cn_proc.c |    3 ++-
 drivers/misc/pti.c          |    2 +-
 drivers/scsi/sg.c           |    4 ++--
 drivers/tty/tty_audit.c     |    2 +-
 drivers/tty/tty_ldisc.c     |    4 +++-
 fs/binfmt_elf.c             |    2 +-
 fs/exec.c                   |    7 +++----
 fs/proc/array.c             |    4 ++--
 include/linux/sched.h       |    2 +-
 kernel/auditsc.c            |    9 +++++----
 kernel/capability.c         |    4 ++--
 kernel/hrtimer.c            |    2 +-
 kernel/sched/core.c         |    3 ++-
 kernel/sys.c                |    6 +++---
 net/core/sock.c             |    4 ++--
 net/ipv6/ndisc.c            |    5 +++--
 17 files changed, 35 insertions(+), 30 deletions(-)

diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index f6f5c53..1c9d77e 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -506,7 +506,7 @@ long sys32_vm86_warning(void)
 		compat_printk(KERN_INFO
 			      "%s: vm86 mode not supported on 64 bit kernel\n",
 			      me->comm);
-		strncpy(lastcomm, me->comm, sizeof(lastcomm));
+		strlcpy(lastcomm, me->comm, sizeof(lastcomm));
 	}
 	return -ENOSYS;
 }
diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 77e1e6c..b4482d7 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -223,7 +223,8 @@ void proc_comm_connector(struct task_struct *task)
 	ev->what = PROC_EVENT_COMM;
 	ev->event_data.comm.process_pid  = task->pid;
 	ev->event_data.comm.process_tgid = task->tgid;
-	get_task_comm(ev->event_data.comm.comm, task);
+	get_task_comm(ev->event_data.comm.comm,
+		      sizeof(ev->event_data.comm.comm), task);
 
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index 0b56e3f..943ca09 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -178,7 +178,7 @@ static void pti_control_frame_built_and_sent(struct pti_masterchannel *mc,
 
 	if (!thread_name) {
 		if (!in_interrupt())
-			get_task_comm(comm, current);
+			get_task_comm(comm, sizeof(comm), current);
 		else
 			strncpy(comm, "Interrupt", TASK_COMM_LEN);
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index eacd46b..f61a7bb 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -627,7 +627,7 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	 */
 	if (hp->dxfer_direction == SG_DXFER_TO_FROM_DEV) {
 		static char cmd[TASK_COMM_LEN];
-		if (strcmp(current->comm, cmd)) {
+		if (strncmp(cmd, current->comm, sizeof(cmd))) {
 			printk_ratelimited(KERN_WARNING
 					   "sg_write: data in/out %d/%d bytes "
 					   "for SCSI command 0x%x-- guessing "
@@ -636,7 +636,7 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 					   old_hdr.reply_len - (int)SZ_SG_HEADER,
 					   input_size, (unsigned int) cmnd[0],
 					   current->comm);
-			strcpy(cmd, current->comm);
+			strlcpy(cmd, current->comm, sizeof(cmd));
 		}
 	}
 	k = sg_common_write(sfp, srp, cmnd, sfp->timeout, blocking);
diff --git a/drivers/tty/tty_audit.c b/drivers/tty/tty_audit.c
index 7c58669..3e6e5bd 100644
--- a/drivers/tty/tty_audit.c
+++ b/drivers/tty/tty_audit.c
@@ -75,7 +75,7 @@ static void tty_audit_log(const char *description, struct task_struct *tsk,
 				 "major=%d minor=%d comm=", description,
 				 tsk->pid, uid, loginuid, sessionid,
 				 major, minor);
-		get_task_comm(name, tsk);
+		get_task_comm(name, sizeof(name), tsk);
 		audit_log_untrustedstring(ab, name);
 		audit_log_format(ab, " data=");
 		audit_log_n_hex(ab, data, size);
diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 24b95db..bf2f831 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -836,7 +836,9 @@ retry:
 				timeout = MAX_SCHEDULE_TIMEOUT;
 				printk_ratelimited(KERN_WARNING
 					"%s: waiting (%s) for %s took too long, but we keep waiting...\n",
-					__func__, get_task_comm(cur_n, current),
+					__func__,
+					get_task_comm(cur_n, sizeof(cur_n),
+						      current),
 					tty_name(tty, tty_n));
 			}
 			mutex_unlock(&tty->ldisc_mutex);
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index bcb884e..2bb6da1 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1345,7 +1345,7 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
 	SET_UID(psinfo->pr_uid, cred->uid);
 	SET_GID(psinfo->pr_gid, cred->gid);
 	rcu_read_unlock();
-	strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
+	strlcpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
 	
 	return 0;
 }
diff --git a/fs/exec.c b/fs/exec.c
index aeb135c..52f1a08 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1042,11 +1042,10 @@ static void flush_old_files(struct files_struct * files)
 	spin_unlock(&files->file_lock);
 }
 
-char *get_task_comm(char *buf, struct task_struct *tsk)
+char *get_task_comm(char *buf, size_t s, struct task_struct *tsk)
 {
-	/* buf must be at least sizeof(tsk->comm) in size */
 	task_lock(tsk);
-	strncpy(buf, tsk->comm, sizeof(tsk->comm));
+	strlcpy(buf, tsk->comm, s);
 	task_unlock(tsk);
 	return buf;
 }
@@ -1064,7 +1063,7 @@ void set_task_comm(struct task_struct *tsk, char *buf)
 	 * Readers without a lock may see incomplete new
 	 * names but are safe from non-terminating string reads.
 	 */
-	memset(tsk->comm, 0, TASK_COMM_LEN);
+	memset(tsk->comm, 0, sizeof(tsk->comm));
 	wmb();
 	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
 	task_unlock(tsk);
diff --git a/fs/proc/array.c b/fs/proc/array.c
index c602b8d..60fb78c 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -93,7 +93,7 @@ static inline void task_name(struct seq_file *m, struct task_struct *p)
 	char *name;
 	char tcomm[sizeof(p->comm)];
 
-	get_task_comm(tcomm, p);
+	get_task_comm(tcomm, sizeof(tcomm), p);
 
 	seq_puts(m, "Name:\t");
 	end = m->buf + m->size;
@@ -390,7 +390,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		}
 	}
 
-	get_task_comm(tcomm, task);
+	get_task_comm(tcomm, sizeof(tcomm), task);
 
 	sigemptyset(&sigign);
 	sigemptyset(&sigcatch);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4032ec1..d2ba148 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2288,7 +2288,7 @@ extern long do_fork(unsigned long, unsigned long, struct pt_regs *, unsigned lon
 struct task_struct *fork_idle(int);
 
 extern void set_task_comm(struct task_struct *tsk, char *from);
-extern char *get_task_comm(char *to, struct task_struct *tsk);
+extern char *get_task_comm(char *to, size_t tosize, struct task_struct *tsk);
 
 #ifdef CONFIG_SMP
 void scheduler_ipi(void);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index caaea6e..5523440 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1161,7 +1161,7 @@ static void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk
 
 	/* tsk == current */
 
-	get_task_comm(name, tsk);
+	get_task_comm(name, sizeof(name), tsk);
 	audit_log_format(ab, " comm=");
 	audit_log_untrustedstring(ab, name);
 
@@ -2528,7 +2528,7 @@ void __audit_ptrace(struct task_struct *t)
 	context->target_uid = task_uid(t);
 	context->target_sessionid = audit_get_sessionid(t);
 	security_task_getsecid(t, &context->target_sid);
-	memcpy(context->target_comm, t->comm, TASK_COMM_LEN);
+	strlcpy(context->target_comm, t->comm, sizeof(context->target_comm));
 }
 
 /**
@@ -2567,7 +2567,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
 		ctx->target_uid = t_uid;
 		ctx->target_sessionid = audit_get_sessionid(t);
 		security_task_getsecid(t, &ctx->target_sid);
-		memcpy(ctx->target_comm, t->comm, TASK_COMM_LEN);
+		strlcpy(ctx->target_comm, t->comm, sizeof(ctx->target_comm));
 		return 0;
 	}
 
@@ -2588,7 +2588,8 @@ int __audit_signal_info(int sig, struct task_struct *t)
 	axp->target_uid[axp->pid_count] = t_uid;
 	axp->target_sessionid[axp->pid_count] = audit_get_sessionid(t);
 	security_task_getsecid(t, &axp->target_sid[axp->pid_count]);
-	memcpy(axp->target_comm[axp->pid_count], t->comm, TASK_COMM_LEN);
+	strlcpy(axp->target_comm[axp->pid_count], t->comm,
+		sizeof(*axp->target_comm));
 	axp->pid_count++;
 
 	return 0;
diff --git a/kernel/capability.c b/kernel/capability.c
index 3f1adb6..a68a788 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -48,7 +48,7 @@ static void warn_legacy_capability_use(void)
 
 		printk(KERN_INFO "warning: `%s' uses 32-bit capabilities"
 		       " (legacy support in use)\n",
-		       get_task_comm(name, current));
+		       get_task_comm(name, sizeof(name), current));
 		warned = 1;
 	}
 }
@@ -78,7 +78,7 @@ static void warn_deprecated_v2(void)
 
 		printk(KERN_INFO "warning: `%s' uses deprecated v2"
 		       " capabilities in a way that may be insecure.\n",
-		       get_task_comm(name, current));
+		       get_task_comm(name, sizeof(name), current));
 		warned = 1;
 	}
 }
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ae34bf5..8806c64 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -774,7 +774,7 @@ static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
 	if (timer->start_site)
 		return;
 	timer->start_site = __builtin_return_address(0);
-	memcpy(timer->start_comm, current->comm, TASK_COMM_LEN);
+	strlcpy(timer->start_comm, current->comm, sizeof(timer->start_comm));
 	timer->start_pid = current->pid;
 #endif
 }
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index df00cb0..c968185 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4881,7 +4881,8 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	idle->sched_class = &idle_sched_class;
 	ftrace_graph_init_idle_task(idle, cpu);
 #if defined(CONFIG_SMP)
-	sprintf(idle->comm, "%s/%d", INIT_TASK_COMM, cpu);
+	snprintf(idle->comm, sizeof(idle->comm), "%s/%d",
+		 INIT_TASK_COMM, cpu);
 #endif
 }
 
diff --git a/kernel/sys.c b/kernel/sys.c
index 4070153..666c380 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1875,15 +1875,15 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			break;
 
 		case PR_SET_NAME:
-			comm[sizeof(me->comm)-1] = 0;
+			comm[sizeof(comm)-1] = 0;
 			if (strncpy_from_user(comm, (char __user *)arg2,
-					      sizeof(me->comm) - 1) < 0)
+					      sizeof(comm) - 1) < 0)
 				return -EFAULT;
 			set_task_comm(me, comm);
 			proc_comm_connector(me);
 			return 0;
 		case PR_GET_NAME:
-			get_task_comm(comm, me);
+			get_task_comm(comm, sizeof(comm), me);
 			if (copy_to_user((char __user *)arg2, comm,
 					 sizeof(comm)))
 				return -EFAULT;
diff --git a/net/core/sock.c b/net/core/sock.c
index 5c5af998..a5c284c 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -313,8 +313,8 @@ static void sock_warn_obsolete_bsdism(const char *name)
 {
 	static int warned;
 	static char warncomm[TASK_COMM_LEN];
-	if (strcmp(warncomm, current->comm) && warned < 5) {
-		strcpy(warncomm,  current->comm);
+	if (strncmp(warncomm, current->comm, sizeof(warncomm)) && warned < 5) {
+		strlcpy(warncomm,  current->comm, sizeof(warncomm));
 		printk(KERN_WARNING "process `%s' is using obsolete "
 		       "%s SO_BSDCOMPAT\n", warncomm, name);
 		warned++;
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index d8f02ef..5efb524 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1748,8 +1748,9 @@ static void ndisc_warn_deprecated_sysctl(struct ctl_table *ctl,
 {
 	static char warncomm[TASK_COMM_LEN];
 	static int warned;
-	if (strcmp(warncomm, current->comm) && warned < 5) {
-		strcpy(warncomm, current->comm);
+	if (strncmp(warncomm, current->comm, sizeof(warncomm)) &&
+	    warned < 5) {
+		strlcpy(warncomm, current->comm, sizeof(warncomm));
 		printk(KERN_WARNING
 			"process `%s' is using deprecated sysctl (%s) "
 			"net.ipv6.neigh.%s.%s; "
-- 
1.7.7

