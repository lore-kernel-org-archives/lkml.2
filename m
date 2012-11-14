Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964842Ab2KNQ1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:27:21 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39817 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161278Ab2KNQ1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 11:27:16 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 4/4] vtime: No need to disable irqs on vtime_account()
Date: Wed, 14 Nov 2012 17:26:53 +0100
Message-Id: <1352910413-10759-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1352910413-10759-1-git-send-email-fweisbec@gmail.com>
References: <1352910413-10759-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vtime_account() is only called from irq entry. irqs
are always disabled at this point so we can safely
remove the irq disabling guards on that function.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/sched/cputime.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 2e8d34a..80b2fd5 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -467,16 +467,10 @@ void vtime_task_switch(struct task_struct *prev)
 #ifndef __ARCH_HAS_VTIME_ACCOUNT
 void vtime_account(struct task_struct *tsk)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);
-
 	if (in_interrupt() || !is_idle_task(tsk))
 		vtime_account_system(tsk);
 	else
 		vtime_account_idle(tsk);
-
-	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(vtime_account);
 #endif /* __ARCH_HAS_VTIME_ACCOUNT */
-- 
1.7.5.4

