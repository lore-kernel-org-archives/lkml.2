Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab1AZQpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 11:45:43 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33285 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab1AZQpm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 11:45:42 -0500
Subject: Re: [PATCH 16/16] KVM-GST: adjust scheduler cpu power
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>
In-Reply-To: <1296056617.3591.26.camel@mothafucka.localdomain>
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>
	 <1295892397-11354-17-git-send-email-glommer@redhat.com>
	 <1295893920.28776.468.camel@laptop>
	 <1295895083.15920.9.camel@mothafucka.localdomain>
	 <1295898690.28776.472.camel@laptop>
	 <1295985756.15920.33.camel@mothafucka.localdomain>
	 <1295986386.28776.1101.camel@laptop>
	 <1295988455.15920.35.camel@mothafucka.localdomain>
	 <1295989664.28776.1124.camel@laptop>
	 <1295990853.15920.37.camel@mothafucka.localdomain>
	 <1296035871.28776.1132.camel@laptop>
	 <1296056617.3591.26.camel@mothafucka.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 Jan 2011 17:46:26 +0100
Message-ID: <1296060386.28776.1312.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 13:43 -0200, Glauber Costa wrote:

> yes, but once this delta is subtracted from rq->clock_task, this value is not
> used to dictate power, unless I am mistaken.
> 
> power is adjusted according to scale_rt_power(), which does it using the
> values of rq->rt_avg, rq->age_stamp, and rq->clock.
> 
> So whatever I store into rq->clock_task, but not rq->clock (which
> correct me if I'm wrong, is expected to be walltime), will not be used
> to adjust cpu power, which is what I'm trying to achieve.

No, see the below, it uses a per-cpu virt_steal_time() clock which is
expected to return steal-time in ns.

All time not accounted to ->clock_task is accumulated in lost, and
passed into sched_rt_avg_update() and thus affects the cpu_power.

If it finds that 50% of the (recent) time is steal time, its cpu_power
will be 50%.

---
 kernel/sched.c          |   44 ++++++++++++++++++++++++++++----------------
 kernel/sched_features.h |    2 +-
 2 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 18d38e4..c71384c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -523,6 +523,9 @@ struct rq {
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 	u64 prev_irq_time;
 #endif
+#ifdef CONFIG_SCHED_PARAVIRT
+	u64 prev_steal_time;
+#endif
 
 	/* calc_load related fields */
 	unsigned long calc_load_update;
@@ -1888,11 +1891,15 @@ void account_system_vtime(struct task_struct *curr)
 }
 EXPORT_SYMBOL_GPL(account_system_vtime);
 
+#endif /* CONFIG_IRQ_TIME_ACCOUNTING */
+
 static void update_rq_clock_task(struct rq *rq, s64 delta)
 {
-	s64 irq_delta;
+	s64 lost_delta __maybe_unused;
+	s64 lost = 0;
 
-	irq_delta = irq_time_read(cpu_of(rq)) - rq->prev_irq_time;
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+	lost_delta = irq_time_read(cpu_of(rq)) - rq->prev_irq_time;
 
 	/*
 	 * Since irq_time is only updated on {soft,}irq_exit, we might run into
@@ -1909,26 +1916,31 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 	 * the current rq->clock timestamp, except that would require using
 	 * atomic ops.
 	 */
-	if (irq_delta > delta)
-		irq_delta = delta;
+	if (lost_delta > delta)
+		lost_delta = delta;
 
-	rq->prev_irq_time += irq_delta;
-	delta -= irq_delta;
-	rq->clock_task += delta;
+	rq->prev_irq_time += lost_delta;
+	lost += lost_delta;
+#endif
+#ifdef CONFIG_SCHED_PARAVIRT
+	lost_delta = virt_steal_time(cpu_of(rq)) - rq->prev_steal_time;
+	
+	/*
+	 * unlikely, unless steal_time accounting is iffy
+	 */
+	if (lost + lost_delta > delta)
+		lost_delta = delta - lost;
 
-	if (irq_delta && sched_feat(NONIRQ_POWER))
-		sched_rt_avg_update(rq, irq_delta);
-}
+	rq->prev_steal_time += lost_delta;
+	lost += lost_delta
+#endif
 
-#else /* CONFIG_IRQ_TIME_ACCOUNTING */
+	rq->clock_task += delta - lost;
 
-static void update_rq_clock_task(struct rq *rq, s64 delta)
-{
-	rq->clock_task += delta;
+	if (lost && sched_feat(NONTASK_POWER))
+		sched_rt_avg_update(rq, lost);
 }
 
-#endif /* CONFIG_IRQ_TIME_ACCOUNTING */
-
 #include "sched_idletask.c"
 #include "sched_fair.c"
 #include "sched_rt.c"
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 68e69ac..b334a2d 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -63,4 +63,4 @@ SCHED_FEAT(OWNER_SPIN, 1)
 /*
  * Decrement CPU power based on irq activity
  */
-SCHED_FEAT(NONIRQ_POWER, 1)
+SCHED_FEAT(NONTASK_POWER, 1)

