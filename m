Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222Ab2BJOY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 09:24:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54253 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab2BJOY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 09:24:56 -0500
X-Authority-Analysis: v=2.0 cv=T9kOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5SG0PmZfjMsA:10 a=VwQbUJbxAAAA:8 a=LCxd8ErmRKd7R_v3th8A:9 a=MLJcH2Ry6vZkF3BcAhgA:7 a=PUjeQqilurYA:10 a=gnQZr6XTxGbrdj9V:21 a=0XMHUwLNksXyt939:21 a=O8nQGtb5u8MopAtwRykA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328883890.8273.5.camel@gandalf.stny.rr.com>
Subject: [ANNOUNCE] 3.0.20-rt36
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Fri, 10 Feb 2012 09:24:50 -0500
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-bYgpy5s6wfomuhmwxYP2"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bYgpy5s6wfomuhmwxYP2
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


Dear RT Folks,

I'm pleased to announce the 3.0.20-rt36 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: 0f5d3ef0d1b75cd975268f5f3ce80f7f1815c8af


Or to build 3.0.20-rt36 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.20.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.20-rt36.=
patch.xz


You can also build from 3.0.20-rt35 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/incr/patch-3.0.20-=
rt35-rt36.patch.xz



Enjoy,

-- Steve


Changes from 3.0.20-rt35:

---

Oleg Nesterov (1):
      signal/x86: Delay calling signals in atomic

Steven Rostedt (3):
      x86: Do not disable preemption in int3 on 32bit
      futex: Fix bug on when a requeued RT task times out
      Linux 3.0.20-rt36

Thomas Gleixner (4):
      genirq: Unmask oneshot irqs when thread was not woken
      genirq: Handle pending irqs in irq_startup()
      timer-fd: Prevent live lock
      genirq: Allow disabling of softirq processing in irq thread context

----
 arch/x86/include/asm/signal.h |   13 ++++++++++++
 arch/x86/kernel/signal.c      |    9 ++++++++
 arch/x86/kernel/traps.c       |   32 ++++++++++++++++++++++--------
 fs/timerfd.c                  |    2 +-
 include/linux/interrupt.h     |    2 +
 include/linux/irq.h           |    4 ++-
 include/linux/sched.h         |    4 +++
 kernel/irq/autoprobe.c        |    4 +-
 kernel/irq/chip.c             |   42 ++++++++++++++++++++++++++++++++-----=
---
 kernel/irq/internals.h        |    2 +-
 kernel/irq/manage.c           |   15 ++++++++++++-
 kernel/irq/settings.h         |   12 +++++++++++
 kernel/rtmutex.c              |   32 ++++++++++++++++++++++++++++++-
 kernel/rtmutex_common.h       |    1 +
 kernel/signal.c               |   37 ++++++++++++++++++++++++++++++++++-
 kernel/softirq.c              |    7 ++++++
 localversion-rt               |    2 +-
 17 files changed, 191 insertions(+), 29 deletions(-)
---------------------------
diff --git a/arch/x86/include/asm/signal.h b/arch/x86/include/asm/signal.h
index 598457c..1213ebd 100644
--- a/arch/x86/include/asm/signal.h
+++ b/arch/x86/include/asm/signal.h
@@ -31,6 +31,19 @@ typedef struct {
 	unsigned long sig[_NSIG_WORDS];
 } sigset_t;
=20
+/*
+ * Because some traps use the IST stack, we must keep
+ * preemption disabled while calling do_trap(), but do_trap()
+ * may call force_sig_info() which will grab the signal spin_locks
+ * for the task, which in PREEMPT_RT_FULL are mutexes.
+ * By defining ARCH_RT_DELAYS_SIGNAL_SEND the force_sig_info() will
+ * set TIF_NOTIFY_RESUME and set up the signal to be sent on exit
+ * of the trap.
+ */
+#if defined(CONFIG_PREEMPT_RT_FULL) && defined(CONFIG_X86_64)
+#define ARCH_RT_DELAYS_SIGNAL_SEND
+#endif
+
 #else
 /* Here we must cater to libcs that poke about in kernel headers.  */
=20
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 40a2493..7d88255 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -840,6 +840,15 @@ do_notify_resume(struct pt_regs *regs, void *unused, _=
_u32 thread_info_flags)
 		mce_notify_process();
 #endif /* CONFIG_X86_64 && CONFIG_X86_MCE */
=20
+#ifdef ARCH_RT_DELAYS_SIGNAL_SEND
+	if (unlikely(current->forced_info.si_signo)) {
+		struct task_struct *t =3D current;
+		force_sig_info(t->forced_info.si_signo,
+					&t->forced_info, t);
+		t->forced_info.si_signo =3D 0;
+	}
+#endif
+
 	/* deal with pending signal delivery */
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b9b6716..5d47242 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -96,9 +96,21 @@ static inline void conditional_sti(struct pt_regs *regs)
 		local_irq_enable();
 }
=20
-static inline void preempt_conditional_sti(struct pt_regs *regs)
+static inline void conditional_sti_ist(struct pt_regs *regs)
 {
+#ifdef CONFIG_X86_64
+	/*
+	 * X86_64 uses a per CPU stack on the IST for certain traps
+	 * like int3. The task can not be preempted when using one
+	 * of these stacks, thus preemption must be disabled, otherwise
+	 * the stack can be corrupted if the task is scheduled out,
+	 * and another task comes in and uses this stack.
+	 *
+	 * On x86_32 the task keeps its own stack and it is OK if the
+	 * task schedules out.
+	 */
 	inc_preempt_count();
+#endif
 	if (regs->flags & X86_EFLAGS_IF)
 		local_irq_enable();
 }
@@ -109,11 +121,13 @@ static inline void conditional_cli(struct pt_regs *re=
gs)
 		local_irq_disable();
 }
=20
-static inline void preempt_conditional_cli(struct pt_regs *regs)
+static inline void conditional_cli_ist(struct pt_regs *regs)
 {
 	if (regs->flags & X86_EFLAGS_IF)
 		local_irq_disable();
+#ifdef CONFIG_X86_64
 	dec_preempt_count();
+#endif
 }
=20
 static void __kprobes
@@ -231,9 +245,9 @@ dotraplinkage void do_stack_segment(struct pt_regs *reg=
s, long error_code)
 	if (notify_die(DIE_TRAP, "stack segment", regs, error_code,
 			12, SIGBUS) =3D=3D NOTIFY_STOP)
 		return;
-	preempt_conditional_sti(regs);
+	conditional_sti_ist(regs);
 	do_trap(12, SIGBUS, "stack segment", regs, error_code, NULL);
-	preempt_conditional_cli(regs);
+	conditional_cli_ist(regs);
 }
=20
 dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
@@ -471,9 +485,9 @@ dotraplinkage void __kprobes do_int3(struct pt_regs *re=
gs, long error_code)
 		return;
 #endif
=20
-	preempt_conditional_sti(regs);
+	conditional_sti_ist(regs);
 	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
-	preempt_conditional_cli(regs);
+	conditional_cli_ist(regs);
 }
=20
 #ifdef CONFIG_X86_64
@@ -567,12 +581,12 @@ dotraplinkage void __kprobes do_debug(struct pt_regs =
*regs, long error_code)
 		return;
=20
 	/* It's safe to allow irq's after DR6 has been saved */
-	preempt_conditional_sti(regs);
+	conditional_sti_ist(regs);
=20
 	if (regs->flags & X86_VM_MASK) {
 		handle_vm86_trap((struct kernel_vm86_regs *) regs,
 				error_code, 1);
-		preempt_conditional_cli(regs);
+		conditional_cli_ist(regs);
 		return;
 	}
=20
@@ -591,7 +605,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *r=
egs, long error_code)
 	si_code =3D get_si_code(tsk->thread.debugreg6);
 	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS) || user_icebp)
 		send_sigtrap(tsk, regs, error_code, si_code);
-	preempt_conditional_cli(regs);
+	conditional_cli_ist(regs);
=20
 	return;
 }
diff --git a/fs/timerfd.c b/fs/timerfd.c
index dffeb37..57f0e4e 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -313,7 +313,7 @@ SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
 		if (hrtimer_try_to_cancel(&ctx->tmr) >=3D 0)
 			break;
 		spin_unlock_irq(&ctx->wqh.lock);
-		cpu_relax();
+		hrtimer_wait_for_timer(&ctx->tmr);
 	}
=20
 	/*
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 3142442..71c2c0b 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -61,6 +61,7 @@
  * IRQF_NO_THREAD - Interrupt cannot be threaded
  * IRQF_EARLY_RESUME - Resume IRQ early during syscore instead of at devic=
e
  *                resume time.
+ * IRQF_NO_SOFTIRQ_CALL - Do not process softirqs in the irq thread contex=
t (RT)
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -75,6 +76,7 @@
 #define IRQF_FORCE_RESUME	0x00008000
 #define IRQF_NO_THREAD		0x00010000
 #define IRQF_EARLY_RESUME	0x00020000
+#define IRQF_NO_SOFTIRQ_CALL	0x00040000
=20
 #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND | IRQF_NO_THREAD)
=20
diff --git a/include/linux/irq.h b/include/linux/irq.h
index baa397e..2df0acc 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -65,6 +65,7 @@ typedef	void (*irq_preflow_handler_t)(struct irq_data *da=
ta);
  * IRQ_NO_BALANCING		- Interrupt cannot be balanced (affinity set)
  * IRQ_MOVE_PCNTXT		- Interrupt can be migrated from process context
  * IRQ_NESTED_TRHEAD		- Interrupt nests into another thread
+ * IRQ_NO_SOFTIRQ_CALL		- No softirq processing in the irq thread context =
(RT)
  */
 enum {
 	IRQ_TYPE_NONE		=3D 0x00000000,
@@ -87,12 +88,13 @@ enum {
 	IRQ_MOVE_PCNTXT		=3D (1 << 14),
 	IRQ_NESTED_THREAD	=3D (1 << 15),
 	IRQ_NOTHREAD		=3D (1 << 16),
+	IRQ_NO_SOFTIRQ_CALL	=3D (1 << 18),
 };
=20
 #define IRQF_MODIFY_MASK	\
 	(IRQ_TYPE_SENSE_MASK | IRQ_NOPROBE | IRQ_NOREQUEST | \
 	 IRQ_NOAUTOEN | IRQ_MOVE_PCNTXT | IRQ_LEVEL | IRQ_NO_BALANCING | \
-	 IRQ_PER_CPU | IRQ_NESTED_THREAD)
+	 IRQ_PER_CPU | IRQ_NESTED_THREAD | IRQ_NO_SOFTIRQ_CALL)
=20
 #define IRQ_NO_BALANCING_MASK	(IRQ_PER_CPU | IRQ_NO_BALANCING)
=20
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4cd3278..77e132f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1405,6 +1405,10 @@ struct task_struct {
 	sigset_t blocked, real_blocked;
 	sigset_t saved_sigmask;	/* restored if set_restore_sigmask() was used */
 	struct sigpending pending;
+#ifdef CONFIG_PREEMPT_RT_FULL
+	/* TODO: move me into ->restart_block ? */
+	struct siginfo forced_info;
+#endif
=20
 	unsigned long sas_ss_sp;
 	size_t sas_ss_size;
diff --git a/kernel/irq/autoprobe.c b/kernel/irq/autoprobe.c
index 342d8f4..0119b9d 100644
--- a/kernel/irq/autoprobe.c
+++ b/kernel/irq/autoprobe.c
@@ -53,7 +53,7 @@ unsigned long probe_irq_on(void)
 			if (desc->irq_data.chip->irq_set_type)
 				desc->irq_data.chip->irq_set_type(&desc->irq_data,
 							 IRQ_TYPE_PROBE);
-			irq_startup(desc);
+			irq_startup(desc, false);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -70,7 +70,7 @@ unsigned long probe_irq_on(void)
 		raw_spin_lock_irq(&desc->lock);
 		if (!desc->action && irq_settings_can_probe(desc)) {
 			desc->istate |=3D IRQS_AUTODETECT | IRQS_WAITING;
-			if (irq_startup(desc))
+			if (irq_startup(desc, false))
 				desc->istate |=3D IRQS_PENDING;
 		}
 		raw_spin_unlock_irq(&desc->lock);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index dc5114b..ca14f5d 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -157,19 +157,22 @@ static void irq_state_set_masked(struct irq_desc *des=
c)
 	irqd_set(&desc->irq_data, IRQD_IRQ_MASKED);
 }
=20
-int irq_startup(struct irq_desc *desc)
+int irq_startup(struct irq_desc *desc, bool resend)
 {
+	int ret =3D 0;
+
 	irq_state_clr_disabled(desc);
 	desc->depth =3D 0;
=20
 	if (desc->irq_data.chip->irq_startup) {
-		int ret =3D desc->irq_data.chip->irq_startup(&desc->irq_data);
+		ret =3D desc->irq_data.chip->irq_startup(&desc->irq_data);
 		irq_state_clr_masked(desc);
-		return ret;
+	} else {
+		irq_enable(desc);
 	}
-
-	irq_enable(desc);
-	return 0;
+	if (resend)
+		check_irq_resend(desc, desc->irq_data.irq);
+	return ret;
 }
=20
 void irq_shutdown(struct irq_desc *desc)
@@ -312,6 +315,24 @@ out_unlock:
 }
 EXPORT_SYMBOL_GPL(handle_simple_irq);
=20
+/*
+ * Called unconditionally from handle_level_irq() and only for oneshot
+ * interrupts from handle_fasteoi_irq()
+ */
+static void cond_unmask_irq(struct irq_desc *desc)
+{
+	/*
+	 * We need to unmask in the following cases:
+	 * - Standard level irq (IRQF_ONESHOT is not set)
+	 * - Oneshot irq which did not wake the thread (caused by a
+	 *   spurious interrupt or a primary handler handling it
+	 *   completely).
+	 */
+	if (!irqd_irq_disabled(&desc->irq_data) &&
+	    irqd_irq_masked(&desc->irq_data) && !desc->threads_oneshot)
+		unmask_irq(desc);
+}
+
 /**
  *	handle_level_irq - Level type irq handler
  *	@irq:	the interrupt number
@@ -344,8 +365,8 @@ handle_level_irq(unsigned int irq, struct irq_desc *des=
c)
=20
 	handle_irq_event(desc);
=20
-	if (!irqd_irq_disabled(&desc->irq_data) && !(desc->istate & IRQS_ONESHOT)=
)
-		unmask_irq(desc);
+	cond_unmask_irq(desc);
+
 out_unlock:
 	raw_spin_unlock(&desc->lock);
 }
@@ -399,6 +420,9 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *d=
esc)
 	preflow_handler(desc);
 	handle_irq_event(desc);
=20
+	if (desc->istate & IRQS_ONESHOT)
+		cond_unmask_irq(desc);
+
 out_eoi:
 	desc->irq_data.chip->irq_eoi(&desc->irq_data);
 out_unlock:
@@ -575,7 +599,7 @@ __irq_set_handler(unsigned int irq, irq_flow_handler_t =
handle, int is_chained,
 		irq_settings_set_noprobe(desc);
 		irq_settings_set_norequest(desc);
 		irq_settings_set_nothread(desc);
-		irq_startup(desc);
+		irq_startup(desc, true);
 	}
 out:
 	irq_put_desc_busunlock(desc, flags);
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 6546431..62efdc4 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -67,7 +67,7 @@ extern int __irq_set_trigger(struct irq_desc *desc, unsig=
ned int irq,
 extern void __disable_irq(struct irq_desc *desc, unsigned int irq, bool su=
sp);
 extern void __enable_irq(struct irq_desc *desc, unsigned int irq, bool res=
ume);
=20
-extern int irq_startup(struct irq_desc *desc);
+extern int irq_startup(struct irq_desc *desc, bool resend);
 extern void irq_shutdown(struct irq_desc *desc);
 extern void irq_enable(struct irq_desc *desc);
 extern void irq_disable(struct irq_desc *desc);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index e1bd49d..cd98592 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -739,7 +739,15 @@ irq_forced_thread_fn(struct irq_desc *desc, struct irq=
action *action)
 	local_bh_disable();
 	ret =3D action->thread_fn(action->irq, action->dev_id);
 	irq_finalize_oneshot(desc, action, false);
-	local_bh_enable();
+	/*
+	 * Interrupts which have real time requirements can be set up
+	 * to avoid softirq processing in the thread handler. This is
+	 * safe as these interrupts do not raise soft interrupts.
+	 */
+	if (irq_settings_no_softirq_call(desc))
+		_local_bh_enable();
+	else
+		local_bh_enable();
 	return ret;
 }
=20
@@ -1020,7 +1028,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, =
struct irqaction *new)
 			desc->istate |=3D IRQS_ONESHOT;
=20
 		if (irq_settings_can_autoenable(desc))
-			irq_startup(desc);
+			irq_startup(desc, true);
 		else
 			/* Undo nested disables: */
 			desc->depth =3D 1;
@@ -1031,6 +1039,9 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, =
struct irqaction *new)
 			irqd_set(&desc->irq_data, IRQD_NO_BALANCING);
 		}
=20
+		if (new->flags & IRQF_NO_SOFTIRQ_CALL)
+			irq_settings_set_no_softirq_call(desc);
+
 		/* Set default affinity mask once everything is setup */
 		setup_affinity(irq, desc, mask);
=20
diff --git a/kernel/irq/settings.h b/kernel/irq/settings.h
index f166783..e1f617f 100644
--- a/kernel/irq/settings.h
+++ b/kernel/irq/settings.h
@@ -13,6 +13,7 @@ enum {
 	_IRQ_MOVE_PCNTXT	=3D IRQ_MOVE_PCNTXT,
 	_IRQ_NO_BALANCING	=3D IRQ_NO_BALANCING,
 	_IRQ_NESTED_THREAD	=3D IRQ_NESTED_THREAD,
+	_IRQ_NO_SOFTIRQ_CALL	=3D IRQ_NO_SOFTIRQ_CALL,
 	_IRQF_MODIFY_MASK	=3D IRQF_MODIFY_MASK,
 };
=20
@@ -24,6 +25,7 @@ enum {
 #define IRQ_NOTHREAD		GOT_YOU_MORON
 #define IRQ_NOAUTOEN		GOT_YOU_MORON
 #define IRQ_NESTED_THREAD	GOT_YOU_MORON
+#define IRQ_NO_SOFTIRQ_CALL	GOT_YOU_MORON
 #undef IRQF_MODIFY_MASK
 #define IRQF_MODIFY_MASK	GOT_YOU_MORON
=20
@@ -34,6 +36,16 @@ irq_settings_clr_and_set(struct irq_desc *desc, u32 clr,=
 u32 set)
 	desc->status_use_accessors |=3D (set & _IRQF_MODIFY_MASK);
 }
=20
+static inline bool irq_settings_no_softirq_call(struct irq_desc *desc)
+{
+	return desc->status_use_accessors & _IRQ_NO_SOFTIRQ_CALL;
+}
+
+static inline void irq_settings_set_no_softirq_call(struct irq_desc *desc)
+{
+	desc->status_use_accessors |=3D _IRQ_NO_SOFTIRQ_CALL;
+}
+
 static inline bool irq_settings_is_per_cpu(struct irq_desc *desc)
 {
 	return desc->status_use_accessors & _IRQ_PER_CPU;
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 15eaf30..789744a 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -75,7 +75,8 @@ static void fixup_rt_mutex_waiters(struct rt_mutex *lock)
=20
 static int rt_mutex_real_waiter(struct rt_mutex_waiter *waiter)
 {
-	return waiter && waiter !=3D PI_WAKEUP_INPROGRESS;
+	return waiter && waiter !=3D PI_WAKEUP_INPROGRESS &&
+		waiter !=3D PI_REQUEUE_INPROGRESS;
 }
=20
 /*
@@ -1345,6 +1346,35 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 		return 1;
 	}
=20
+#ifdef CONFIG_PREEMPT_RT_FULL
+	/*
+	 * In PREEMPT_RT there's an added race.
+	 * If the task, that we are about to requeue, times out,
+	 * it can set the PI_WAKEUP_INPROGRESS. This tells the requeue
+	 * to skip this task. But right after the task sets
+	 * its pi_blocked_on to PI_WAKEUP_INPROGRESS it can then
+	 * block on the spin_lock(&hb->lock), which in RT is an rtmutex.
+	 * This will replace the PI_WAKEUP_INPROGRESS with the actual
+	 * lock that it blocks on. We *must not* place this task
+	 * on this proxy lock in that case.
+	 *
+	 * To prevent this race, we first take the task's pi_lock
+	 * and check if it has updated its pi_blocked_on. If it has,
+	 * we assume that it woke up and we return -EAGAIN.
+	 * Otherwise, we set the task's pi_blocked_on to
+	 * PI_REQUEUE_INPROGRESS, so that if the task is waking up
+	 * it will know that we are in the process of requeuing it.
+	 */
+	raw_spin_lock(&task->pi_lock);
+	if (task->pi_blocked_on) {
+		raw_spin_unlock(&task->pi_lock);
+		raw_spin_unlock(&lock->wait_lock);
+		return -EAGAIN;
+	}
+	task->pi_blocked_on =3D PI_REQUEUE_INPROGRESS;
+	raw_spin_unlock(&task->pi_lock);
+#endif
+
 	ret =3D task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
=20
 	if (ret && !rt_mutex_owner(lock)) {
diff --git a/kernel/rtmutex_common.h b/kernel/rtmutex_common.h
index a688a29..6ec3dc1 100644
--- a/kernel/rtmutex_common.h
+++ b/kernel/rtmutex_common.h
@@ -105,6 +105,7 @@ static inline struct task_struct *rt_mutex_owner(struct=
 rt_mutex *lock)
  * PI-futex support (proxy locking functions, etc.):
  */
 #define PI_WAKEUP_INPROGRESS	((struct rt_mutex_waiter *) 1)
+#define PI_REQUEUE_INPROGRESS	((struct rt_mutex_waiter *) 2)
=20
 extern struct task_struct *rt_mutex_next_owner(struct rt_mutex *lock);
 extern void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
diff --git a/kernel/signal.c b/kernel/signal.c
index 3f15914..6650b2c 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1200,8 +1200,8 @@ int do_send_sig_info(int sig, struct siginfo *info, s=
truct task_struct *p,
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
@@ -1226,6 +1226,39 @@ force_sig_info(int sig, struct siginfo *info, struct=
 task_struct *t)
 	return ret;
 }
=20
+int force_sig_info(int sig, struct siginfo *info, struct task_struct *t)
+{
+/*
+ * On some archs, PREEMPT_RT has to delay sending a signal from a trap
+ * since it can not enable preemption, and the signal code's spin_locks
+ * turn into mutexes. Instead, it must set TIF_NOTIFY_RESUME which will
+ * send the signal on exit of the trap.
+ */
+#ifdef ARCH_RT_DELAYS_SIGNAL_SEND
+	if (in_atomic()) {
+		if (WARN_ON_ONCE(t !=3D current))
+			return 0;
+		if (WARN_ON_ONCE(t->forced_info.si_signo))
+			return 0;
+
+		if (is_si_special(info)) {
+			WARN_ON_ONCE(info !=3D SEND_SIG_PRIV);
+			t->forced_info.si_signo =3D sig;
+			t->forced_info.si_errno =3D 0;
+			t->forced_info.si_code =3D SI_KERNEL;
+			t->forced_info.si_pid =3D 0;
+			t->forced_info.si_uid =3D 0;
+		} else {
+			t->forced_info =3D *info;
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
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 3489d06..729cd0c 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -431,6 +431,13 @@ void local_bh_enable_ip(unsigned long ip)
 }
 EXPORT_SYMBOL(local_bh_enable_ip);
=20
+void _local_bh_enable(void)
+{
+	current->softirq_nestcnt--;
+	migrate_enable();
+}
+EXPORT_SYMBOL(_local_bh_enable);
+
 /* For tracing */
 int notrace __in_softirq(void)
 {
diff --git a/localversion-rt b/localversion-rt
index 366440d..2294034 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt35
+-rt36


--=-bYgpy5s6wfomuhmwxYP2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPNSiyAAoJEIy3vGnGbaoAaQ4QAJhaexEWJ8604CvXpTSj9vWN
0R5S/oTPDUGb3rgzD3UcVrxWRjk+D20RQ+UWQPMk7h3Bys5nAxvT0CWz7A5R+6fe
KngNcVkL0wQ3ysFrs8c6DURY/o4N2btkNO8EKDId0GSXMdI5ko/mekCs+EPnOsqB
n+8ucXn+YqXRQ5wm96RfJ0wBTmaapO8JkFGf6b5Vkhj/KLY0WHtR+VzCBo//BlBS
Mu3jVZbrfIwRQ0AXgHTjQeZstGsKff2DcB+2g7gGqDcksCNmO/BMt5HkMqK5RDAE
Sm2e5pHPQbvWADVGkA8FKgni3np0c6aGbeJptnE+qRlXggWICVBLUPxBcMFAWr+N
2eicOlOYtJ7k1De2G5jfOO4M7Fl9jxWU4BOc/bAfuB4WxjXcmNpPmBw8uyHTyutG
kI60ZIRNRLiQGFav2jTl20uyL5BY8vISjn/YNZq5KIWiBHAvW93M56d3AtL47aKi
IoHWUg3EalNJ9eMkSLiRGBAd7qdlo5/MzM7z4ohf7tlE6nad2yqHQibCBpX3uL+g
StJz6phrGyOIqViue21Jw70D/18V3iZn/XCkPHetJ+ZFytIG9AburEQQOnK1nR/T
1Gzzcx6Z+8sTTOEGU4BRR3pkciJKK8Lba8SRVskJTMgGa6/DQWkPWXFLd+BWqO6l
/qW+hYXg59mWutp7tXQ6
=z5Ld
-----END PGP SIGNATURE-----

--=-bYgpy5s6wfomuhmwxYP2--

