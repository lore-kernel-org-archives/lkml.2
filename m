Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab1JKREI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:04:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33272 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070Ab1JKREF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:04:05 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Tue Oct 11 10:57:09 2011
Message-Id: <20111011165709.528188720@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 11 Oct 2011 10:55:18 -0600
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [08/38] sched/rt: Migrate equal priority tasks to available CPUs
In-Reply-To: <20111011165903.GA30976@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Shawn Bohrer <sbohrer@rgmadvisors.com>

commit 3be209a8e22cedafc1b6945608b7bb8d9887ab61 upstream.

Commit 43fa5460fe60dea5c610490a1d263415419c60f6 ("sched: Try not to
migrate higher priority RT tasks") also introduced a change in behavior
which keeps RT tasks on the same CPU if there is an equal priority RT
task currently running even if there are empty CPUs available.

This can cause unnecessary wakeup latencies, and can prevent the
scheduler from balancing all RT tasks across available CPUs.

This change causes an RT task to search for a new CPU if an equal
priority RT task is already running on wakeup.  Lower priority tasks
will still have to wait on higher priority tasks, but the system should
still balance out because there is always the possibility that if there
are both a high and low priority RT tasks on a given CPU that the high
priority task could wakeup while the low priority task is running and
force it to search for a better runqueue.

Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Tested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1315837684-18733-1-git-send-email-sbohrer@rgmadvisors.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched_rt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1038,7 +1038,7 @@ select_task_rq_rt(struct task_struct *p,
 	 */
 	if (curr && unlikely(rt_task(curr)) &&
 	    (curr->rt.nr_cpus_allowed < 2 ||
-	     curr->prio < p->prio) &&
+	     curr->prio <= p->prio) &&
 	    (p->rt.nr_cpus_allowed > 1)) {
 		int target = find_lowest_rq(p);
 
@@ -1569,7 +1569,7 @@ static void task_woken_rt(struct rq *rq,
 	    p->rt.nr_cpus_allowed > 1 &&
 	    rt_task(rq->curr) &&
 	    (rq->curr->rt.nr_cpus_allowed < 2 ||
-	     rq->curr->prio < p->prio))
+	     rq->curr->prio <= p->prio))
 		push_rt_tasks(rq);
 }
 


