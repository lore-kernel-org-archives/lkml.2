Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab2HTJ1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 05:27:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:48961 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab2HTJ1J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 05:27:09 -0400
Message-ID: <1345454817.23018.27.camel@twins>
Subject: Re: Add rq->nr_uninterruptible count to dest cpu's rq while CPU
 goes down.
From: Peter Zijlstra <peterz@infradead.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        paulmck <paulmck@linux.vnet.ibm.com>
Date: Mon, 20 Aug 2012 11:26:57 +0200
In-Reply-To: <CADZ9YHgNhTGWicX0kFfrNoL17JkxfZcXryqqa-wHLVLh05SvAg@mail.gmail.com>
References: <1345124749.31092.2.camel@localhost.localdomain>
	 <1345125384.29668.30.camel@twins>
	 <CADZ9YHjPjExzuJWjziiezBch03Am0imQzDG4EDfG-NTWfz4V8A@mail.gmail.com>
	 <1345128138.29668.42.camel@twins>
	 <CADZ9YHjzNVz6nSqbnTgVYfwi2hz0KYuXC89GHw6UjL2GyGZ64A@mail.gmail.com>
	 <1345139199.29668.46.camel@twins>
	 <CADZ9YHgNhTGWicX0kFfrNoL17JkxfZcXryqqa-wHLVLh05SvAg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-17 at 19:39 +0600, Rakib Mullick wrote:
> On 8/16/12, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, 2012-08-16 at 21:32 +0600, Rakib Mullick wrote:
> >> And also I think migrate_nr_uninterruptible() is meaning less too.
> >
> > Hmm, I think I see a problem.. we forget to migrate the effective delta
> > created by rq->calc_load_active.
> >
> And rq->calc_load_active needs to be migrated to the proper dest_rq
> not like currently picking any random rq.


OK, so how about something like the below, it would also solve Paul's
issue with that code.


Please do double check the logic, I've had all of 4 hours sleep and its
far too warm for a brain to operate in any case.

---
Subject: sched: Fix load avg vs cpu-hotplug

Rabik and Paul reported two different issues related to the same few
lines of code.

Rabik's issue is that the nr_uninterruptible migration code is wrong in
that he sees artifacts due to this (Rabik please do expand in more
detail).

Paul's issue is that this code as it stands relies on us using
stop_machine() for unplug, we all would like to remove this assumption
so that eventually we can remove this stop_machine() usage altogether.

The only reason we'd have to migrate nr_uninterruptible is so that we
could use for_each_online_cpu() loops in favour of
for_each_possible_cpu() loops, however since nr_uninterruptible() is the
only such loop and its using possible lets not bother at all.

The problem Rabik sees is (probably) caused by the fact that by
migrating nr_uninterruptible we screw rq->calc_load_active for both rqs
involved.

So don't bother with fancy migration schemes (meaning we now have to
keep using for_each_possible_cpu()) and instead fold any nr_active delta
after we migrate all tasks away to make sure we don't have any skewed
nr_active accounting.


Reported-by: Rakib Mullick <rakib.mullick@gmail.com>
Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched/core.c | 31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4376c9f..06d23c6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5338,27 +5338,17 @@ void idle_task_exit(void)
 }
 
 /*
- * While a dead CPU has no uninterruptible tasks queued at this point,
- * it might still have a nonzero ->nr_uninterruptible counter, because
- * for performance reasons the counter is not stricly tracking tasks to
- * their home CPUs. So we just add the counter to another CPU's counter,
- * to keep the global sum constant after CPU-down:
- */
-static void migrate_nr_uninterruptible(struct rq *rq_src)
-{
-	struct rq *rq_dest = cpu_rq(cpumask_any(cpu_active_mask));
-
-	rq_dest->nr_uninterruptible += rq_src->nr_uninterruptible;
-	rq_src->nr_uninterruptible = 0;
-}
-
-/*
- * remove the tasks which were accounted by rq from calc_load_tasks.
+ * Since this CPU is going 'away' for a while, fold any nr_active delta
+ * we might have. Assumes we're called after migrate_tasks() so that the
+ * nr_active count is stable.
+ *
+ * Also see the comment "Global load-average calculations".
  */
-static void calc_global_load_remove(struct rq *rq)
+static void calc_load_migrate(struct rq *rq)
 {
-	atomic_long_sub(rq->calc_load_active, &calc_load_tasks);
-	rq->calc_load_active = 0;
+	long delta = calc_load_fold_active(rq);
+	if (delta)
+		atomic_long_add(delta, &calc_load_tasks);
 }
 
 /*
@@ -5652,8 +5642,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		BUG_ON(rq->nr_running != 1); /* the migration thread */
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
 
-		migrate_nr_uninterruptible(rq);
-		calc_global_load_remove(rq);
+		calc_load_migrate(rq);
 		break;
 #endif
 	}

