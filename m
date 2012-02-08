Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab2BHBmD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 20:42:03 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57676 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414Ab2BHBmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 20:42:00 -0500
Date: Wed, 8 Feb 2012 05:41:57 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Dave Jones <davej@redhat.com>, Russell King <linux@arm.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Nicolas Pitre <nico@fluxnic.net>, Mike Chan <mike@android.com>,
        Todd Poynor <toddpoynor@google.com>, cpufreq@vger.kernel.org,
        kernel-team@android.com, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] sched: Introduce idle notifiers API
Message-ID: <20120208014157.GA459@panacea>
References: <20120208013959.GA24535@panacea>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120208013959.GA24535@panacea>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Idle notifiers may be used as a hint to the code that needs to know when
there are no tasks to execute, and the scheduler is idling, or when the
idling period ends. This patch implements a simple notifiers API.

Notes:

- Unlike x86 "CPU idle" notifiers API, these notifiers do not run on
  every invocation or exit from cpuidle. Instead it is only used
  to notify about scheduler state changes, not HW states.

  In other words, CPU idle notifiers work inside while(!need_resched())
  loop, and scheduler idle notifiers will work outside of this loop.

- rcu_idle_{enter,exit} are wired as built-ins, bypassing
  sched_idle_notifier chain.

  We might change it later to get rid of sched_idle_enter_condrcu()
  stuff on powerpc and x86. But that's just an implementation detail,
  so let's keep things simple for now.

- tick_nohz_idle_enter() is also wired as built-in, there is no much
  gain in moving to to sched_idle_notifier chain.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 include/linux/sched.h |   10 ++++++++++
 kernel/sched/core.c   |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4032ec1..e82f721 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1960,6 +1960,16 @@ extern void sched_clock_idle_sleep_event(void);
 extern void sched_clock_idle_wakeup_event(u64 delta_ns);
 #endif
 
+#define SCHED_IDLE_START	1
+#define SCHED_IDLE_END		2
+extern void sched_idle_notifier_register(struct notifier_block *nb);
+extern void sched_idle_notifier_unregister(struct notifier_block *nb);
+extern void sched_idle_notifier_call_chain(unsigned long val);
+extern void sched_idle_enter_condrcu(bool idle_uses_rcu);
+extern void sched_idle_exit_condrcu(bool idle_uses_rcu);
+static inline void sched_idle_enter(void) { sched_idle_enter_condrcu(0); }
+static inline void sched_idle_exit(void) { sched_idle_exit_condrcu(0); }
+
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 /*
  * An i/f to runtime opt-in for irq time accounting based off of sched_clock.
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fd7b25e..62798ac 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1810,6 +1810,44 @@ void wake_up_new_task(struct task_struct *p)
 	task_rq_unlock(rq, p, &flags);
 }
 
+static ATOMIC_NOTIFIER_HEAD(sched_idle_notifier);
+
+void sched_idle_notifier_register(struct notifier_block *nb)
+{
+	atomic_notifier_chain_register(&sched_idle_notifier, nb);
+}
+EXPORT_SYMBOL_GPL(sched_idle_notifier_register);
+
+void sched_idle_notifier_unregister(struct notifier_block *nb)
+{
+	atomic_notifier_chain_unregister(&sched_idle_notifier, nb);
+}
+EXPORT_SYMBOL_GPL(sched_idle_notifier_unregister);
+
+void sched_idle_notifier_call_chain(unsigned long val)
+{
+	atomic_notifier_call_chain(&sched_idle_notifier, val, NULL);
+}
+EXPORT_SYMBOL_GPL(sched_idle_notifier_call_chain);
+
+void sched_idle_enter_condrcu(bool idle_uses_rcu)
+{
+	tick_nohz_idle_enter();
+	if (!idle_uses_rcu)
+		rcu_idle_enter();
+	sched_idle_notifier_call_chain(SCHED_IDLE_START);
+}
+EXPORT_SYMBOL_GPL(sched_idle_enter_condrcu);
+
+void sched_idle_exit_condrcu(bool idle_uses_rcu)
+{
+	sched_idle_notifier_call_chain(SCHED_IDLE_END);
+	if (!idle_uses_rcu)
+		rcu_idle_exit();
+	tick_nohz_idle_exit();
+}
+EXPORT_SYMBOL_GPL(sched_idle_exit_condrcu);
+
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 
 /**
-- 
1.7.7.6

