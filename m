Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759703Ab2IEWEB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 18:04:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43549 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759597Ab2IEWEA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 18:04:00 -0400
Message-ID: <1346882630.2600.59.camel@twins>
Subject: Re: [tip:sched/core] sched: Fix load avg vs cpu-hotplug
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: paulmck@linux.vnet.ibm.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rakib.mullick@gmail.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Date: Thu, 06 Sep 2012 00:03:50 +0200
In-Reply-To: <1346864493.2600.27.camel@twins>
References: <1345454817.23018.27.camel@twins>
	 <tip-f319da0c6894fcf55e21320e40506418a2aad629@git.kernel.org>
	 <1346848616.2600.26.camel@twins> <20120905132939.GA3480@gmail.com>
	 <1346864493.2600.27.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 19:01 +0200, Peter Zijlstra wrote:
> > Please do a delta.

OK, so I suppose something like the below ought to do. Paul its slightly
different than the one in your tree, given the changelog below, do you
see anything wrong with it?

Rakib, again, sorry for getting your name wrong, and this time for
getting it merged :/

---
Subject: sched: Fix load avg vs cpu-hotplug mk-II

Commit f319da0c68 ("sched: Fix load avg vs cpu-hotplug") was a known
broken version that got in by accident.

In particular, the problem is that at the point it calls
calc_load_migrate() nr_running := 1 (the stopper thread), so move the
call to CPU_DEAD where we're sure that nr_running := 0.

Also note that we can call calc_load_migrate() without serialization, we
know the state of rq is stable since its cpu is dead, and we modify the
global state using appropriate atomic ops. 

Suggested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c46a011..8c089cb 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5086,7 +5086,9 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		migrate_tasks(cpu);
 		BUG_ON(rq->nr_running != 1); /* the migration thread */
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
+		break;
 
+	case CPU_DEAD:
 		calc_load_migrate(rq);
 		break;
 #endif

