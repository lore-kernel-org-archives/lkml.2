Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089Ab2CAMSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:18:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37496 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab2CAMSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:18:13 -0500
Date: Thu, 1 Mar 2012 04:17:29 -0800
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-wxx7btox7coby6ifv5vzhzgp@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt: Add schedule_preempt_disabled()
Git-Commit-ID: c5491ea779793f977d282754db478157cc409d82
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 01 Mar 2012 04:17:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c5491ea779793f977d282754db478157cc409d82
Gitweb:     http://git.kernel.org/tip/c5491ea779793f977d282754db478157cc409d82
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 21 Mar 2011 12:09:35 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 1 Mar 2012 10:28:03 +0100

sched/rt: Add schedule_preempt_disabled()

Add helper to get rid of the ever repeating:

    preempt_enable_no_resched();
    schedule();
    preempt_disable();

patterns.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-wxx7btox7coby6ifv5vzhzgp@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    1 +
 kernel/sched/core.c   |   12 ++++++++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1a63984..03dd224 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -361,6 +361,7 @@ extern signed long schedule_timeout_interruptible(signed long timeout);
 extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
 asmlinkage void schedule(void);
+extern void schedule_preempt_disabled(void);
 extern int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner);
 
 struct nsproxy;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 91fe6a0..7302239 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3246,6 +3246,18 @@ asmlinkage void __sched schedule(void)
 }
 EXPORT_SYMBOL(schedule);
 
+/**
+ * schedule_preempt_disabled - called with preemption disabled
+ *
+ * Returns with preemption disabled. Note: preempt_count must be 1
+ */
+void __sched schedule_preempt_disabled(void)
+{
+	preempt_enable_no_resched();
+	schedule();
+	preempt_disable();
+}
+
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
 
 static inline bool owner_running(struct mutex *lock, struct task_struct *owner)
