Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751116Ab2AURll (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 12:41:41 -0500
Received: from seven.medozas.de ([188.40.89.202]:44827 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab2AURlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 12:41:40 -0500
Date: Sat, 21 Jan 2012 18:41:38 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: TASK_COMM_LEN>16 leads to boot crashes
Message-ID: <alpine.LNX.2.01.1201211839490.7649@frira.zrqbmnf.qr>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Attempting to bump TASK_COMM_LEN above 16 still crashes the box on 
bootup despite the patch below.


parent dcd6c92267155e70a94b3927bce681ce74b80d1f (v3.3-rc1)
commit 1445ffe96a82db8cced73b27f41162d4c9086354
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sat Jan 21 16:57:47 2012 +0100

kernel: fix memory scribble when TASK_COMM_LEN > 16

When bumping TASK_COMM_LEN to something larger than 16, various parts
of the system start to scribble beyond boundaries when they attempt
strncpy/memcpy(toosmall, task->comm, TASK_COMM_LEN) or similar.
hrtimer is the first thing that crashes the system after bootup.
cn_proc for example has [16] hardcoded in what seems to be a binary
protocol, so in this patch, size limiting is added when doing these
copy operations.

---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000608
IP: [<ffffffff813a68d1>] _raw_spin_lock_irqsave+0xe/0x25
PGD 0
Oops: 0002 [#1] SMP
CPU 0
Modules linked in:

Pid: 0, comm: swapper Not tainted 3.1.9-jng2-default #1 innotek GmbH VirtualBox
RIP: 0010:[<ffffffff813a68d1>]  [<ffffffff813a68d1>] _raw_spin_lock_irqsave+0xe/0x25
RSP: 0018:ffff88001f803e58  EFLAGS: 00010092
RAX: 0000000000000092 RBX: 0000000000000608 RCX: 0000000000000000
RDX: 0000000000010000 RSI: 000000000000000f RDI: 0000000000000608
RBP: ffff88001f803ea8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 7fffffffffffffff R12: 0000000000000000
R13: 0000000000000608 R14: 7fffffffffffffff R15: 000000000000000f
FS:  0000000000000000(0000) GS:ffff88001f800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000608 CR3: 0000000001805000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff81800000, task ffffffff8180d020)
Stack:
 0000000000000000 ffffffff8103629b 0000000000000000 ffff88001e1cc448
 ffff88001f803eb8 ffffffff81801e78 ffff88001f80d5b0 ffff88001f803f50
 7fffffffffffffff ffffffff8108f5fb 0000000000000000 ffffffff8108f62f
Call Trace:
 [<ffffffff8103629b>] try_to_wake_up+0x29/0x133
 [<ffffffff8108f62f>] watchdog_timer_fn+0x34/0x13b
 [<ffffffff810583ca>] __run_hrtimer+0xa0/0x144
 [<ffffffff81058ba9>] hrtimer_interrupt+0xdb/0x195
 [<ffffffff8101743c>] smp_apic_timer_interrupt+0x6e/0x80
 [<ffffffff813ad45e>] apic_timer_interrupt+0x6e/0x80
 [<ffffffff8101ee0c>] native_safe_halt+0x2/0x3
 [<ffffffff8100848c>] default_idle+0x47/0x7f
 [<ffffffff8100120a>] cpu_idle+0x5b/0x95
 [<ffffffff81930b0f>] start_kernel+0x388/0x393
 [<ffffffff819303af>] x86_64_start_kernel+0xcf/0xdc
Code: be 01 00 00 00 e9 cf fe ff ff e8 cb 06 cc ff 85 c0 0f 95 c0 0f b6 c0 c3 e9 a2 06 cc ff 53 48 89 fb e8 68 06 cc ff ba 00 00 01 00 <f0> 0f c1 13 0f b7 ca c1 ea 10 39 d1 74 07 f3 90 0f b7 0b eb f5
RIP  [<ffffffff813a68d1>] _raw_spin_lock_irqsave+0xe/0x25
 RSP <ffff88001f803e58>
CR2: 0000000000000608
BUG: unable to handle kernel
---[ end trace 93d72a36b9146f22 ]---

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 drivers/connector/cn_proc.c |    3 ++-
 drivers/misc/pti.c          |    2 +-
 drivers/tty/tty_audit.c     |    2 +-
 drivers/tty/tty_ldisc.c     |    4 +++-
 fs/exec.c                   |    4 ++--
 fs/proc/array.c             |    4 ++--
 include/linux/sched.h       |    2 +-
 kernel/auditsc.c            |    2 +-
 kernel/capability.c         |    4 ++--
 kernel/hrtimer.c            |    3 ++-
 kernel/sys.c                |    2 +-
 11 files changed, 18 insertions(+), 14 deletions(-)

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
diff --git a/fs/exec.c b/fs/exec.c
index aeb135c..66a8cb0 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1042,11 +1042,11 @@ static void flush_old_files(struct files_struct * files)
 	spin_unlock(&files->file_lock);
 }
 
-char *get_task_comm(char *buf, struct task_struct *tsk)
+char *get_task_comm(char *buf, size_t s, struct task_struct *tsk)
 {
 	/* buf must be at least sizeof(tsk->comm) in size */
 	task_lock(tsk);
-	strncpy(buf, tsk->comm, sizeof(tsk->comm));
+	strncpy(buf, tsk->comm, min(s, sizeof(tsk->comm)));
 	task_unlock(tsk);
 	return buf;
 }
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
index caaea6e..15eb0f3 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1161,7 +1161,7 @@ static void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk
 
 	/* tsk == current */
 
-	get_task_comm(name, tsk);
+	get_task_comm(name, sizeof(name), tsk);
 	audit_log_format(ab, " comm=");
 	audit_log_untrustedstring(ab, name);
 
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
index ae34bf5..9b53491 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -774,7 +774,8 @@ static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
 	if (timer->start_site)
 		return;
 	timer->start_site = __builtin_return_address(0);
-	memcpy(timer->start_comm, current->comm, TASK_COMM_LEN);
+	memcpy(timer->start_comm, current->comm,
+	       min(sizeof(timer->start_comm), sizeof(current->comm)));
 	timer->start_pid = current->pid;
 #endif
 }
diff --git a/kernel/sys.c b/kernel/sys.c
index 4070153..c5be142 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1883,7 +1883,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			proc_comm_connector(me);
 			return 0;
 		case PR_GET_NAME:
-			get_task_comm(comm, me);
+			get_task_comm(comm, sizeof(comm), me);
 			if (copy_to_user((char __user *)arg2, comm,
 					 sizeof(comm)))
 				return -EFAULT;
-- 
# Created with git-export-patch
