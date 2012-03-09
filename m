Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807Ab2CIVOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 16:14:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33790 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab2CIVOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 16:14:02 -0500
Date: Fri, 9 Mar 2012 13:13:17 -0800
From: tip-bot for Alexander Gordeev <agordeev@redhat.com>
Message-ID: <tip-5234ffb9f74cfa8993d174782bc861dd9b7b5bfb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@redhat.com, oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120309135958.GD2114@dhcp-26-207.brq.redhat.com>
References: <20120309135958.GD2114@dhcp-26-207.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Get rid of unnecessary IRQTF_DIED flag
Git-Commit-ID: 5234ffb9f74cfa8993d174782bc861dd9b7b5bfb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Mar 2012 13:13:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5234ffb9f74cfa8993d174782bc861dd9b7b5bfb
Gitweb:     http://git.kernel.org/tip/5234ffb9f74cfa8993d174782bc861dd9b7b5bfb
Author:     Alexander Gordeev <agordeev@redhat.com>
AuthorDate: Fri, 9 Mar 2012 14:59:59 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 9 Mar 2012 17:19:09 +0100

genirq: Get rid of unnecessary IRQTF_DIED flag

Currently IRQTF_DIED flag is set when a IRQ thread handler calls do_exit()
But also PF_EXITING per process flag gets set when a thread exits. This
fix eliminates the duplicate by using PF_EXITING flag.

Also, there is a race condition in exit_irq_thread(). In case a thread's
bit is cleared in desc->threads_oneshot (and the IRQ line gets unmasked),
but before IRQTF_DIED flag is set, a new interrupt might come in and set
just cleared bit again, this time forever. This fix throws IRQTF_DIED flag
away, eliminating the race as a result.

[ tglx: Test THREAD_EXITING first as suggested by Oleg ]

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Link: http://lkml.kernel.org/r/20120309135958.GD2114@dhcp-26-207.brq.redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/exit.c          |    4 ++--
 kernel/irq/handle.c    |    2 +-
 kernel/irq/internals.h |    2 --
 kernel/irq/manage.c    |   11 +----------
 4 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 4b4042f..752d2c0 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -935,8 +935,6 @@ void do_exit(long code)
 		schedule();
 	}
 
-	exit_irq_thread();
-
 	exit_signals(tsk);  /* sets PF_EXITING */
 	/*
 	 * tsk->flags are checked in the futex code to protect against
@@ -945,6 +943,8 @@ void do_exit(long code)
 	smp_mb();
 	raw_spin_unlock_wait(&tsk->pi_lock);
 
+	exit_irq_thread();
+
 	if (unlikely(in_atomic()))
 		printk(KERN_INFO "note: %s[%d] exited with preempt_count %d\n",
 				current->comm, task_pid_nr(current),
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 470d08c..500aaf6 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -60,7 +60,7 @@ static void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
 	 * device interrupt, so no irq storm is lurking. If the
 	 * RUNTHREAD bit is already set, nothing to do.
 	 */
-	if (test_bit(IRQTF_DIED, &action->thread_flags) ||
+	if ((action->thread->flags & PF_EXITING) ||
 	    test_and_set_bit(IRQTF_RUNTHREAD, &action->thread_flags))
 		return;
 
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index b795231..5c233e0 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -20,14 +20,12 @@ extern bool noirqdebug;
 /*
  * Bits used by threaded handlers:
  * IRQTF_RUNTHREAD - signals that the interrupt handler thread should run
- * IRQTF_DIED      - handler thread died
  * IRQTF_WARNED    - warning "IRQ_WAKE_THREAD w/o thread_fn" has been printed
  * IRQTF_AFFINITY  - irq thread is requested to adjust affinity
  * IRQTF_FORCED_THREAD  - irq action is force threaded
  */
 enum {
 	IRQTF_RUNTHREAD,
-	IRQTF_DIED,
 	IRQTF_WARNED,
 	IRQTF_AFFINITY,
 	IRQTF_FORCED_THREAD,
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 3feab4a..a94466d 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -845,17 +845,8 @@ void exit_irq_thread(void)
 
 	desc = irq_to_desc(action->irq);
 
-	/*
-	 * Prevent a stale desc->threads_oneshot. Must be called
-	 * before setting the IRQTF_DIED flag.
-	 */
+	/* Prevent a stale desc->threads_oneshot */
 	irq_finalize_oneshot(desc, action, true);
-
-	/*
-	 * Set the THREAD DIED flag to prevent further wakeups of the
-	 * soon to be gone threaded handler.
-	 */
-	set_bit(IRQTF_DIED, &action->flags);
 }
 
 static void irq_setup_forced_threading(struct irqaction *new)
