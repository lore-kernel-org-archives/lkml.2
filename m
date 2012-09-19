Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab2ISPlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:41:45 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:57575 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550Ab2ISPlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:41:42 -0400
Date: Wed, 19 Sep 2012 08:39:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RCU idle CPU detection is broken in linux-next
Message-ID: <20120919153934.GB2455@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <5050CCE0.4090403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5050CCE0.4090403@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091915-2398-0000-0000-00000B26D17B
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00175490; UDB=6.00039736; UTC=2012-09-19
 15:41:38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 07:56:48PM +0200, Sasha Levin wrote:
> Hi Paul,
> 
> While fuzzing using trinity inside a KVM tools guest, I've managed to trigger
> "RCU used illegally from idle CPU!" warnings several times.
> 
> There are a bunch of traces which seem to pop exactly at the same time and from
> different places around the kernel. Here are several of them:

Hello, Sasha,

OK, interesting.  Could you please try reproducing with the diagnostic
patch shown below?

							Thanx, Paul

> (1):
> 
> [   29.006532] ===============================
> [   29.007033] [ INFO: suspicious RCU usage. ]
> [   29.007033] 3.6.0-rc5-next-20120912-sasha-00001-gb0c9916-dirty #331 Tainted:
> G        W
> [   29.007033] -------------------------------
> [   29.007033] include/linux/rcupdate.h:737 rcu_read_lock() used illegally while
> idle!
> [   29.007033]
> [   29.007033] other info that might help us debug this:
> [   29.007033]
> [   29.007033]
> [   29.007033] RCU used illegally from idle CPU!
> [   29.007033] rcu_scheduler_active = 1, debug_locks = 1
> [   29.007033] RCU used illegally from extended quiescent state!
> [   29.007033] 2 locks held by rcu_preempt/11:
> [   29.007033]  #0:  (&rq->lock){-.-.-.}, at: [<ffffffff83742f50>]
> __schedule+0x180/0x8f0
> [   29.007033]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff8114ff1e>]
> cpuacct_charge+0xe/0x200
> [   29.007033]
> [   29.007033] stack backtrace:
> [   29.007033] Pid: 11, comm: rcu_preempt Tainted: G        W
> 3.6.0-rc5-next-20120912-sasha-00001-gb0c9916-dirty #331
> [   29.007033] Call Trace:
> [   29.007033]  [<ffffffff8117eaeb>] lockdep_rcu_suspicious+0x10b/0x120
> [   29.007033]  [<ffffffff8114ffa0>] cpuacct_charge+0x90/0x200
> [   29.007033]  [<ffffffff8114ff1e>] ? cpuacct_charge+0xe/0x200
> [   29.007033]  [<ffffffff811548a3>] update_curr+0x1a3/0x270
> [   29.007033]  [<ffffffff8115527a>] dequeue_entity+0x2a/0x210
> [   29.007033]  [<ffffffff811556b5>] dequeue_task_fair+0x45/0x130
> [   29.007033]  [<ffffffff81148149>] dequeue_task+0x89/0xa0
> [   29.007033]  [<ffffffff81148ebe>] deactivate_task+0x1e/0x20
> [   29.007033]  [<ffffffff83743649>] __schedule+0x879/0x8f0
> [   29.007033]  [<ffffffff8117a60d>] ? trace_hardirqs_on+0xd/0x10
> [   29.007033]  [<ffffffff83743715>] schedule+0x55/0x60
> [   29.007033]  [<ffffffff811c672d>] rcu_gp_kthread+0xdd/0xed0
> [   29.007033]  [<ffffffff83744ebb>] ? _raw_spin_unlock_irq+0x2b/0x80
> [   29.007033]  [<ffffffff81137210>] ? abort_exclusive_wait+0xb0/0xb0
> [   29.007033]  [<ffffffff811c6650>] ? rcu_gp_fqs+0x80/0x80
> [   29.007033]  [<ffffffff81135e43>] kthread+0xe3/0xf0
> [   29.007033]  [<ffffffff83747a84>] kernel_thread_helper+0x4/0x10
> [   29.007033]  [<ffffffff83745df4>] ? retint_restore_args+0x13/0x13
> [   29.007033]  [<ffffffff81135d60>] ? insert_kthread_work+0x90/0x90
> [   29.007033]  [<ffffffff83747a80>] ? gs_change+0x13/0x13
> 
> (2):
> 
> [   28.876466] ===============================
> [   28.876466] [ INFO: suspicious RCU usage. ]
> [   28.876466] 3.6.0-rc5-next-20120912-sasha-00001-gb0c9916-dirty #331 Tainted:
> G        W
> [   28.876466] -------------------------------
> [   28.876466] include/linux/rcupdate.h:758 rcu_read_unlock() used illegally
> while idle!
> [   28.876466]
> [   28.876466] other info that might help us debug this:
> [   28.876466]
> [   28.876466]
> [   28.876466] RCU used illegally from idle CPU!
> [   28.876466] rcu_scheduler_active = 1, debug_locks = 1
> [   28.876466] RCU used illegally from extended quiescent state!
> [   28.876466] 2 locks held by trinity-child58/5966:
> [   28.876466]  #0:  (&(&sighand->siglock)->rlock){-.-...}, at:
> [<ffffffff8111f548>] force_sig_info+0x38/0x100
> [   28.876466]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff8111d410>]
> __sigqueue_alloc+0x0/0x230
> [   28.876466]
> [   28.876466] stack backtrace:
> [   28.876466] Pid: 5966, comm: trinity-child58 Tainted: G        W
> 3.6.0-rc5-next-20120912-sasha-00001-gb0c9916-dirty #331
> [   28.876466] Call Trace:
> [   28.876466]  [<ffffffff8117eaeb>] lockdep_rcu_suspicious+0x10b/0x120
> [   28.876466]  [<ffffffff8111d558>] __sigqueue_alloc+0x148/0x230
> [   28.876466]  [<ffffffff8111d410>] ? check_kill_permission+0x220/0x220
> [   28.876466]  [<ffffffff8111e91a>] __send_signal+0x51a/0x580
> [   28.876466]  [<ffffffff8111f500>] ? do_signal_stop+0x2c0/0x2d0
> [   28.876466]  [<ffffffff8111e9c0>] send_signal+0x40/0x80
> [   28.876466]  [<ffffffff8111f548>] ? force_sig_info+0x38/0x100
> [   28.876466]  [<ffffffff811c38ad>] ? rcu_user_enter+0xed/0x110
> [   28.876466]  [<ffffffff8111f5d3>] force_sig_info+0xc3/0x100
> [   28.876466]  [<ffffffff811203a1>] force_sig+0x11/0x20
> [   28.876466]  [<ffffffff8106da1d>] do_general_protection+0xfd/0x170
> [   28.876466]  [<ffffffff83746075>] general_protection+0x25/0x30
> 
> (3):
> 
> [   28.876466] ===============================
> [   28.876466] [ INFO: suspicious RCU usage. ]
> [   28.876466] 3.6.0-rc5-next-20120912-sasha-00001-gb0c9916-dirty #331 Tainted:
> G        W
> [   28.876466] -------------------------------
> [   28.876466] kernel/signal.c:366 suspicious rcu_dereference_check() usage!
> [   28.876466]
> [   28.876466] other info that might help us debug this:
> [   28.876466]
> [   28.876466]
> [   28.876466] RCU used illegally from idle CPU!
> [   28.876466] rcu_scheduler_active = 1, debug_locks = 1
> [   28.876466] RCU used illegally from extended quiescent state!
> [   28.876466] 2 locks held by trinity-child58/5966:
> [   28.876466]  #0:  (&(&sighand->siglock)->rlock){-.-...}, at:
> [<ffffffff8111f548>] force_sig_info+0x38/0x100
> [   28.876466]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff8111d410>]
> __sigqueue_alloc+0x0/0x230
> [   28.876466]
> [   28.876466] stack backtrace:
> [   28.876466] Pid: 5966, comm: trinity-child58 Tainted: G        W
> 3.6.0-rc5-next-20120912-sasha-00001-gb0c9916-dirty #331
> [   28.876466] Call Trace:
> [   28.876466]  [<ffffffff8117eaeb>] lockdep_rcu_suspicious+0x10b/0x120
> [   28.876466]  [<ffffffff8111d50f>] __sigqueue_alloc+0xff/0x230
> [   28.876466]  [<ffffffff8111d410>] ? check_kill_permission+0x220/0x220
> [   28.876466]  [<ffffffff8111e91a>] __send_signal+0x51a/0x580
> [   28.876466]  [<ffffffff8111f500>] ? do_signal_stop+0x2c0/0x2d0
> [   28.876466]  [<ffffffff8111e9c0>] send_signal+0x40/0x80
> [   28.876466]  [<ffffffff8111f548>] ? force_sig_info+0x38/0x100
> [   28.876466]  [<ffffffff811c38ad>] ? rcu_user_enter+0xed/0x110
> [   28.876466]  [<ffffffff8111f5d3>] force_sig_info+0xc3/0x100
> [   28.876466]  [<ffffffff811203a1>] force_sig+0x11/0x20
> [   28.876466]  [<ffffffff8106da1d>] do_general_protection+0xfd/0x170
> [   28.876466]  [<ffffffff83746075>] general_protection+0x25/0x30

rcu: Track RCU idle periods using lockdep

There have been several bugs involving illegal use of RCU read-side
critical sections from the idle loop.  Most of these have been easy to
track down, but any number of bugs involving unbalanced idle entry/exit
calls could be difficult to locate.  This commit therefore adds lockdep
support for tracking RCU idle entry and exit in order to provide more
information for locating unbalanced idle entry/exit calls.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 7c968e4..b5b7863 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -297,6 +297,7 @@ static inline void rcu_lock_release(struct lockdep_map *map)
 extern struct lockdep_map rcu_lock_map;
 extern struct lockdep_map rcu_bh_lock_map;
 extern struct lockdep_map rcu_sched_lock_map;
+extern struct lockdep_map rcu_idle_map;
 extern int debug_lockdep_rcu_enabled(void);
 
 /**
diff --git a/kernel/rcu.h b/kernel/rcu.h
index 8ba99cd..3aa1e59 100644
--- a/kernel/rcu.h
+++ b/kernel/rcu.h
@@ -55,6 +55,22 @@
 #define DYNTICK_TASK_EXIT_IDLE	   (DYNTICK_TASK_NEST_VALUE + \
 				    DYNTICK_TASK_FLAG)
 
+
+/* Lockdep tracking for extended quiescent state idle entry and exit. */
+static inline void rcu_eqs_enter_lockdep(void)
+{
+#ifdef CONFIG_PROVE_RCU
+	rcu_lock_acquire(&rcu_idle_map);
+#endif /* #ifdef CONFIG_PROVE_RCU */
+}
+static inline void rcu_eqs_exit_lockdep(void)
+{
+#ifdef CONFIG_PROVE_RCU
+	rcu_lock_release(&rcu_idle_map);
+#endif /* #ifdef CONFIG_PROVE_RCU */
+}
+
+
 /*
  * debug_rcu_head_queue()/debug_rcu_head_unqueue() are used internally
  * by call_rcu() and rcu callback execution, and are therefore not part of the
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 29ca1c6..ce129f3 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -142,6 +142,11 @@ static struct lock_class_key rcu_sched_lock_key;
 struct lockdep_map rcu_sched_lock_map =
 	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock_sched", &rcu_sched_lock_key);
 EXPORT_SYMBOL_GPL(rcu_sched_lock_map);
+
+static struct lock_class_key rcu_idle_key;
+struct lockdep_map rcu_idle_map =
+	STATIC_LOCKDEP_MAP_INIT("rcu_idle", &rcu_idle_key);
+EXPORT_SYMBOL_GPL(rcu_idle_map);
 #endif
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 2e073a2..c620f16 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -75,6 +75,7 @@ static void rcu_idle_enter_common(long long newval)
 			  current->pid, current->comm,
 			  idle->pid, idle->comm); /* must be idle task! */
 	}
+	rcu_eqs_enter_lockdep();
 	barrier();
 	rcu_dynticks_nesting = newval;
 	rcu_sched_qs(0); /* implies rcu_bh_qsctr_inc(0) */
@@ -126,6 +127,7 @@ static void rcu_idle_exit_common(long long oldval)
 		return;
 	}
 	RCU_TRACE(trace_rcu_dyntick("End", oldval, rcu_dynticks_nesting));
+	rcu_eqs_exit_lockdep();
 	if (!is_idle_task(current)) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 6eff63d..fc9c8a0 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -343,6 +343,7 @@ static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
 			  current->pid, current->comm,
 			  idle->pid, idle->comm); /* must be idle task! */
 	}
+	rcu_eqs_enter_lockdep();
 	rcu_prepare_for_idle(smp_processor_id());
 	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
 	smp_mb__before_atomic_inc();  /* See above. */
@@ -500,6 +501,7 @@ static void rcu_eqs_exit_common(struct rcu_dynticks *rdtp, long long oldval,
 	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
 	smp_mb__after_atomic_inc();  /* See above. */
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
+	rcu_eqs_exit_lockdep();
 	rcu_cleanup_after_idle(smp_processor_id());
 	trace_rcu_dyntick("End", oldval, rdtp->dynticks_nesting);
 	if (!user && !is_idle_task(current)) {

