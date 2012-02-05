Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab2BETaH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 14:30:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab2BETaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 14:30:05 -0500
Date: Sun, 5 Feb 2012 20:23:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Andi Kleen <ak@linux.intel.com>, Clark Williams <williams@redhat.com>,
        Luis Goncalves <lgoncalv@redhat.com>, stable-rt@vger.kernel.org
Subject: Re: [PATCH RT 2/2 v4] preempt-rt/x86: Delay calling signals in int3
Message-ID: <20120205192305.GB12183@redhat.com>
References: <20120203182853.547078531@goodmis.org> <20120203183041.427463295@goodmis.org> <20120203184016.GA10413@redhat.com> <1328299833.5882.211.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328299833.5882.211.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03, Steven Rostedt wrote:
>
> If
> we can solve this in a clean way using the existing signal
> infrastructure, I'm all for that.

I am not sure, I know almost nothing about rt and about this
low-level stuff. But please look at my attempt below.

So. it is very simple. The patch simply changes force_sig_info() to
check in_atomic(), if it is true we offload the sending to
do_notify_resume(). Of course, I do not know if we can rely on this
check in rt kernels.

Note:

	- The patch adds the new code under CONFIG_PREEMPT_RT_FULL,
	  it should probably check X86_64 or defined(TIF_NOTIFY_RESUME)
	  as well.

	- I think we can later move task->forced_info into restart_block's
	  union.

	- We could modify get_signal_to_deliver() instead of the
	  arch-dependant do_notify_resume(). In this case we do not
	  need TIF_NOTIFY_RESUME, TIF_SIGPENDING is enough.

What do you think?

Oleg.
---

 arch/x86/kernel/signal.c |    9 +++++++++
 include/linux/sched.h    |    4 ++++
 kernel/signal.c          |   31 +++++++++++++++++++++++++++++--
 3 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 46a01bd..22cb8ff 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -816,6 +816,15 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 		mce_notify_process();
 #endif /* CONFIG_X86_64 && CONFIG_X86_MCE */
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+	if (unlikely(current->forced_info.si_signo)) {
+		struct task_struct *t = current;
+		force_sig_info(t->forced_info.si_signo,
+					&t->forced_info, t);
+		t->forced_info.si_signo = 0;
+	}
+#endif
+
 	/* deal with pending signal delivery */
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2234985..942c545 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1407,6 +1407,10 @@ struct task_struct {
 	sigset_t blocked, real_blocked;
 	sigset_t saved_sigmask;	/* restored if set_restore_sigmask() was used */
 	struct sigpending pending;
+#ifdef CONFIG_PREEMPT_RT_FULL
+	/* TODO: move me into ->restart_block ? */
+	struct siginfo forced_info;
+#endif
 
 	unsigned long sas_ss_sp;
 	size_t sas_ss_size;
diff --git a/kernel/signal.c b/kernel/signal.c
index c73c428..5c0b61a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1228,8 +1228,8 @@ int do_send_sig_info(int sig, struct siginfo *info, struct task_struct *p,
  * We don't want to have recursive SIGSEGV's etc, for example,
  * that is why we also clear SIGNAL_UNKILLABLE.
  */
-int
-force_sig_info(int sig, struct siginfo *info, struct task_struct *t)
+static int
+do_force_sig_info(int sig, struct siginfo *info, struct task_struct *t)
 {
 	unsigned long int flags;
 	int ret, blocked, ignored;
@@ -1254,6 +1254,33 @@ force_sig_info(int sig, struct siginfo *info, struct task_struct *t)
 	return ret;
 }
 
+int force_sig_info(int sig, struct siginfo *info, struct task_struct *t)
+{
+#ifdef CONFIG_PREEMPT_RT_FULL
+	if (in_atomic()) {
+		if (WARN_ON_ONCE(t != current))
+			return 0;
+		if (WARN_ON_ONCE(t->forced_info.si_signo))
+			return 0;
+
+		if (is_si_special(info)) {
+			WARN_ON_ONCE(info != SEND_SIG_PRIV);
+			t->forced_info.si_signo = sig;
+			t->forced_info.si_errno = 0;
+			t->forced_info.si_code = SI_KERNEL;
+			t->forced_info.si_pid = 0;
+			t->forced_info.si_uid = 0;
+		} else {
+			t->forced_info = *info;
+		}
+
+		set_tsk_thread_flag(t, TIF_NOTIFY_RESUME);
+		return 0;
+	}
+#endif
+	return do_force_sig_info(sig, info, t);
+}
+
 /*
  * Nuke all other threads in the group.
  */

