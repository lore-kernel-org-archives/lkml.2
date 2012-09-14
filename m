Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab2INGOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:14:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48950 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab2INGO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:14:28 -0400
Date: Thu, 13 Sep 2012 23:14:08 -0700
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-08bedae1d0acd8c9baf514fb69fa199d0c8345f6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1346882630.2600.59.camel@twins>
References: <1346882630.2600.59.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix load avg vs. cpu-hotplug
Git-Commit-ID: 08bedae1d0acd8c9baf514fb69fa199d0c8345f6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 23:14:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  08bedae1d0acd8c9baf514fb69fa199d0c8345f6
Gitweb:     http://git.kernel.org/tip/08bedae1d0acd8c9baf514fb69fa199d0c8345f6
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 6 Sep 2012 00:03:50 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 13 Sep 2012 16:52:05 +0200

sched: Fix load avg vs. cpu-hotplug

Commit f319da0c68 ("sched: Fix load avg vs cpu-hotplug") was an
incomplete fix:

In particular, the problem is that at the point it calls
calc_load_migrate() nr_running := 1 (the stopper thread), so move the
call to CPU_DEAD where we're sure that nr_running := 0.

Also note that we can call calc_load_migrate() without serialization, we
know the state of rq is stable since its cpu is dead, and we modify the
global state using appropriate atomic ops.

Suggested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1346882630.2600.59.camel@twins
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 8b51b2d..ba144b1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5048,7 +5048,9 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		migrate_tasks(cpu);
 		BUG_ON(rq->nr_running != 1); /* the migration thread */
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
+		break;
 
+	case CPU_DEAD:
 		calc_load_migrate(rq);
 		break;
 #endif
