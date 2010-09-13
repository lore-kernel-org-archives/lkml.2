Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab0IMPxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:53:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33851 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab0IMPxo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:53:44 -0400
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1284386179.10436.6.camel@marge.simson.net>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com> <1284231470.2251.52.camel@laptop>
	 <20100911195708.GA9273@Krystal> <1284288072.2251.91.camel@laptop>
	 <20100912203712.GD32327@Krystal>  <1284382387.2275.265.camel@laptop>
	 <1284383758.2275.283.camel@laptop>
	 <1284386179.10436.6.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Sep 2010 17:53:35 +0200
Message-ID: <1284393215.2275.383.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 15:56 +0200, Mike Galbraith wrote:
> > One option is to simply get rid of that stuff in check_preempt_tick()
> > and instead do a wakeup-preempt check on the leftmost task instead.
> 
> That's what I wanted to boil it down to instead of putting the extra
> preempt check in, but it kills the longish slices of low load.  IIRC,
> when I tried that, it demolished throughput. 

Hrm.. yes it would..

So the reason for all this:

        /*
         * Ensure that a task that missed wakeup preemption by a
         * narrow margin doesn't have to wait for a full slice.
         * This also mitigates buddy induced latencies under load.
         */

Is to avoid tasks getting too far ahead in virtual time due to buddies,
right?

Would something like the below work? Don't actually use delta_exec to
filter, but use wakeup_gran + min_gran on virtual time, (much like Steve
suggested) and then verify using __sched_gran().

Or have I now totally confused myself backwards?

 - delta_exec is walltime, and should thus we compared against a
   weighted unit like slice,
 - delta is a vruntime unit, and is thus weight free, hence we can use
   granularity/unweighted units.


---
 kernel/sched_fair.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 9b5b4f8..7f418de 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -485,6 +485,16 @@ static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	return slice;
 }
 
+static u64 __sched_gran(unsigned long nr_running)
+{
+	unsigned long latency = sysctl_sched_latency;
+
+	if (nr_running >= nr_latency)
+		return sysctl_sched_min_granularity;
+
+	return latency / nr_running;
+}
+
 /*
  * We calculate the vruntime slice of a to be inserted task
  *
@@ -865,14 +875,16 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
-	if (delta_exec < sysctl_sched_min_granularity)
-		return;
-
 	if (cfs_rq->nr_running > 1) {
 		struct sched_entity *se = __pick_next_entity(cfs_rq);
 		s64 delta = curr->vruntime - se->vruntime;
+		u64 wakeup_gran = sysctl_sched_wakeup_granularity;
+		u64 min_gran = sysctl_sched_min_granularity;
+
+		if (delta < wakeup_gran + min_gran)
+			return;
 
-		if (delta > ideal_runtime)
+		if (delta > wakeup_gran + __sched_gran(cfs_rq->nr_running))
 			resched_task(rq_of(cfs_rq)->curr);
 	}
 }

