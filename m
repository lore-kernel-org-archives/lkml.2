Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab1DKLPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 07:15:52 -0400
Received: from mail.aknet.ru ([78.158.192.28]:54991 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754232Ab1DKLPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 07:15:50 -0400
Message-ID: <4DA2E2E2.5000006@aknet.ru>
Date: Mon, 11 Apr 2011 15:15:46 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command
References: <20110224132906.GA15733@redhat.com> <4D6675B0.2010700@aknet.ru> <20110224153221.GA22770@redhat.com> <4D94A788.1050806@aknet.ru> <20110331170244.GA13271@redhat.com> <4D99D6E6.4070008@aknet.ru> <20110404160351.GA23655@redhat.com> <4D9A24A0.5050105@aknet.ru> <20110405151549.GB17490@redhat.com> <4D9B4265.6080403@aknet.ru> <20110405164557.GA23248@redhat.com>
In-Reply-To: <20110405164557.GA23248@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------000901080504080408070206"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000901080504080408070206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Oleg.

In the attached patch I finally reparent the whole group.
How does that look?

--------------000901080504080408070206
Content-Type: text/plain;
 name="pr_detach4.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="pr_detach4.diff"

commit c95ea73afce29a9c47bab29787d6eb014a8de9e6
Author: Stas <stas@stas.(none)>
Date:   Mon Apr 11 15:06:33 2011 +0400

    implement PR_DETACH

diff --git a/include/asm-generic/siginfo.h b/include/asm-generic/siginfo.h
index 942d30b..1da9c20 100644
--- a/include/asm-generic/siginfo.h
+++ b/include/asm-generic/siginfo.h
@@ -218,7 +218,8 @@ typedef struct siginfo {
 #define CLD_TRAPPED	(__SI_CHLD|4)	/* traced child has trapped */
 #define CLD_STOPPED	(__SI_CHLD|5)	/* child has stopped */
 #define CLD_CONTINUED	(__SI_CHLD|6)	/* stopped child has continued */
-#define NSIGCHLD	6
+#define CLD_DETACHED	(__SI_CHLD|7)	/* child has detached */
+#define NSIGCHLD	7
 
 /*
  * SIGPOLL si_codes
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index caa151f..fdf71a9 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -158,6 +158,8 @@ extern struct cred init_cred;
 	.parent		= &tsk,						\
 	.children	= LIST_HEAD_INIT(tsk.children),			\
 	.sibling	= LIST_HEAD_INIT(tsk.sibling),			\
+	.detached_children	= LIST_HEAD_INIT(tsk.detached_children),\
+	.detached_sibling	= LIST_HEAD_INIT(tsk.detached_sibling),	\
 	.group_leader	= &tsk,						\
 	RCU_INIT_POINTER(.real_cred, &init_cred),			\
 	RCU_INIT_POINTER(.cred, &init_cred),				\
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index a3baeb2..fbd2451 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -102,4 +102,6 @@
 
 #define PR_MCE_KILL_GET 34
 
+#define PR_DETACH 35
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e74882f..c8a1741 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1260,6 +1260,9 @@ struct task_struct {
 /* task state */
 	int exit_state;
 	int exit_code, exit_signal;
+	int detach_code;
+	int detaching;
+	int is_detaching:1;
 	int pdeath_signal;  /*  The signal sent when the parent dies  */
 	/* ??? */
 	unsigned int personality;
@@ -1292,6 +1295,8 @@ struct task_struct {
 	 */
 	struct list_head children;	/* list of my children */
 	struct list_head sibling;	/* linkage in my parent's children list */
+	struct list_head detached_children;	/* list of my detached children */
+	struct list_head detached_sibling;	/* linkage in my parent's detached children list */
 	struct task_struct *group_leader;	/* threadgroup leader */
 
 	/*
diff --git a/kernel/exit.c b/kernel/exit.c
index 2aa64e8..a2c5cfb 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -69,6 +69,7 @@ static void __unhash_process(struct task_struct *p, bool group_dead)
 
 		list_del_rcu(&p->tasks);
 		list_del_init(&p->sibling);
+		list_del_init(&p->detached_sibling);
 		__this_cpu_dec(process_counts);
 	}
 	list_del_rcu(&p->thread_group);
@@ -804,6 +805,17 @@ static void forget_original_parent(struct task_struct *father)
 		} while_each_thread(p, t);
 		reparent_leader(father, p, &dead_children);
 	}
+	list_for_each_entry_safe(p, n, &father->detached_children,
+			detached_sibling) {
+		int signal;
+		p->detaching = 0;
+		p->is_detaching = 0;
+		list_del_init(&p->detached_sibling);
+		if (p->exit_state == EXIT_ZOMBIE) {
+			signal = do_notify_parent(p, SIGCHLD);
+			BUG_ON(signal == DEATH_REAP);
+		}
+	}
 	write_unlock_irq(&tasklist_lock);
 
 	BUG_ON(!list_empty(&father->children));
@@ -858,7 +870,8 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 		tsk->exit_signal = SIGCHLD;
 
 	signal = tracehook_notify_death(tsk, &cookie, group_dead);
-	if (signal >= 0)
+	/* delay parent notification for detaching tasks */
+	if (signal >= 0 && !tsk->is_detaching)
 		signal = do_notify_parent(tsk, signal);
 
 	tsk->exit_state = signal == DEATH_REAP ? EXIT_DEAD : EXIT_ZOMBIE;
@@ -1507,6 +1520,54 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
 	return retval;
 }
 
+static int wait_task_detached(struct wait_opts *wo, struct task_struct *p)
+{
+	int dt, signal, retval = 0;
+	pid_t pid;
+	uid_t uid;
+
+	if (!likely(wo->wo_flags & WEXITED))
+		return 0;
+
+	if (unlikely(wo->wo_flags & WNOWAIT)) {
+		get_task_struct(p);
+		read_unlock(&tasklist_lock);
+		pid = task_pid_vnr(p);
+		uid = __task_cred(p)->uid;
+		return wait_noreap_copyout(wo, p, pid, uid, CLD_DETACHED,
+			p->detach_code >> 8);
+	}
+
+	dt = xchg(&p->detaching, 0);
+	if (dt != 1)
+		return 0;
+	get_task_struct(p);
+	read_unlock(&tasklist_lock);
+
+	write_lock_irq(&tasklist_lock);
+	list_del_init(&p->detached_sibling);
+	if (p->exit_state == EXIT_ZOMBIE) {
+		signal = do_notify_parent(p, SIGCHLD);
+		BUG_ON(signal == DEATH_REAP);
+	}
+	p->is_detaching = 0;
+	write_unlock_irq(&tasklist_lock);
+
+	if (wo->wo_stat)
+		retval = put_user(p->detach_code, wo->wo_stat);
+
+	if (!retval) {
+		pid = task_pid_vnr(p);
+		uid = __task_cred(p)->uid;
+		retval = wait_noreap_copyout(wo, p, pid, uid, CLD_DETACHED,
+			p->detach_code >> 8);
+	} else {
+		put_task_struct(p);
+	}
+
+	return retval;
+}
+
 static int can_wait_task_common(struct wait_opts *wo, struct task_struct *p)
 {
 	int ret = eligible_child(wo, p);
@@ -1572,7 +1633,8 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 	/*
 	 * We don't reap group leaders with subthreads.
 	 */
-	if (p->exit_state == EXIT_ZOMBIE && !delay_group_leader(p))
+	if (p->exit_state == EXIT_ZOMBIE && !delay_group_leader(p) &&
+			!p->is_detaching)
 		return wait_task_zombie(wo, p);
 
 	/*
@@ -1610,6 +1672,15 @@ static int do_wait_thread(struct wait_opts *wo, struct task_struct *tsk)
 			return ret;
 	}
 
+	list_for_each_entry(p, &tsk->detached_children, detached_sibling) {
+		ret = can_wait_task(wo, p);
+		if (!ret)
+			continue;
+		ret = wait_task_detached(wo, p);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 25e4291..feadef7 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1070,6 +1070,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	copy_flags(clone_flags, p);
 	INIT_LIST_HEAD(&p->children);
 	INIT_LIST_HEAD(&p->sibling);
+	INIT_LIST_HEAD(&p->detached_children);
+	INIT_LIST_HEAD(&p->detached_sibling);
 	rcu_copy_process(p);
 	p->vfork_done = NULL;
 	spin_lock_init(&p->alloc_lock);
@@ -1233,6 +1235,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->exit_signal = (clone_flags & CLONE_THREAD) ? -1 : (clone_flags & CSIGNAL);
 	p->pdeath_signal = 0;
 	p->exit_state = 0;
+	p->detaching = 0;
+	p->is_detaching = 0;
 
 	/*
 	 * Ok, make it visible to the rest of the system.
diff --git a/kernel/sys.c b/kernel/sys.c
index 18da702..1d88ee8 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -28,6 +28,7 @@
 #include <linux/suspend.h>
 #include <linux/tty.h>
 #include <linux/signal.h>
+#include <linux/tracehook.h>
 #include <linux/cn_proc.h>
 #include <linux/getcpu.h>
 #include <linux/task_io_accounting_ops.h>
@@ -1736,6 +1737,41 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			else
 				error = PR_MCE_KILL_DEFAULT;
 			break;
+		case PR_DETACH: {
+			struct task_struct *p, *leader;
+			int notif;
+			struct pid_namespace *pid_ns = task_active_pid_ns(me);
+			error = -EPERM;
+			/* not detaching from init */
+			if (same_thread_group(me->real_parent,
+					pid_ns->child_reaper))
+				break;
+			if (arg2 & ~0x7f)
+				break;
+			write_lock_irq(&tasklist_lock);
+			leader = me->group_leader;
+			leader->detach_code = arg2 << 8;
+			notif = do_signal_parent(leader, leader->exit_signal,
+					CLD_DETACHED, arg2);
+			if (notif != DEATH_REAP) {
+				list_add_tail(&leader->detached_sibling,
+					&leader->real_parent->detached_children);
+				leader->detaching = 1;
+				leader->is_detaching = 1;
+			}
+			p = leader;
+			do {
+				if (!task_ptrace(p))
+					p->parent = pid_ns->child_reaper;
+				p->real_parent = pid_ns->child_reaper;
+			} while_each_thread(leader, p);
+			list_move_tail(&leader->sibling,
+					&leader->real_parent->children);
+			leader->exit_signal = SIGCHLD;
+			write_unlock_irq(&tasklist_lock);
+			error = 0;
+			break;
+		}
 		default:
 			error = -EINVAL;
 			break;

--------------000901080504080408070206--
