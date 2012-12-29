Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab2L2QrH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 11:47:07 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:45928 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab2L2Qno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 11:43:44 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 13/27] sched: Update rq clock on nohz CPU before setting fair group shares
Date: Sat, 29 Dec 2012 17:42:52 +0100
Message-Id: <1356799386-4212-14-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
References: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because we may update the execution time (sched_group_set_shares()->
	update_cfs_shares()->reweight_entity()->update_curr()) before
reweighting the entity after updating the group shares and this requires
an uptodate version of the runqueue clock. Let's update it on the target
CPU if it runs tickless because scheduler_tick() is not there to maintain
it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/fair.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5eea870..a96f0f2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6068,6 +6068,11 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 		se = tg->se[i];
 		/* Propagate contribution to hierarchy */
 		raw_spin_lock_irqsave(&rq->lock, flags);
+		/*
+		 * We may call update_curr() which needs an up-to-date
+		 * version of rq clock if the CPU runs tickless.
+		 */
+		update_nohz_rq_clock(rq);
 		for_each_sched_entity(se)
 			update_cfs_shares(group_cfs_rq(se));
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
-- 
1.7.5.4

