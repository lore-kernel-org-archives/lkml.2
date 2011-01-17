Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770Ab1AQP77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 10:59:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:52409 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab1AQP76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 10:59:58 -0500
Subject: Re: Bug in scheduler when using rt_mutex
From: Peter Zijlstra <peterz@infradead.org>
To: samu.p.onkalo@nokia.com
Cc: mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>
In-Reply-To: <1295275365.12840.13.camel@kolo>
References: <1295275365.12840.13.camel@kolo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 17 Jan 2011 17:00:32 +0100
Message-ID: <1295280032.30950.128.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-17 at 16:42 +0200, Onkalo Samu wrote:
> 
> Failure case:
> - user process locks rt_mutex
> - and goes to sleep (wait_for_completion etc.)
> - user process is dequeued to sleep state
> -> vruntime is not updated in dequeue_entity
> 

Does the below (completely untested) patch help?

---
 kernel/sched.c      |    6 +++++-
 kernel/sched_fair.c |   11 +++++++++++
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index a0eb094..be09581 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8108,8 +8108,10 @@ EXPORT_SYMBOL(__might_sleep);
 #ifdef CONFIG_MAGIC_SYSRQ
 static void normalize_task(struct rq *rq, struct task_struct *p)
 {
+	struct sched_class *prev_class = p->sched_class;
+	int old_prio = p->prio;
 	int on_rq;
-
+       
 	on_rq = p->se.on_rq;
 	if (on_rq)
 		deactivate_task(rq, p, 0);
@@ -8118,6 +8120,8 @@ static void normalize_task(struct rq *rq, struct task_struct *p)
 		activate_task(rq, p, 0);
 		resched_task(rq->curr);
 	}
+
+	check_class_changed(rq, p, prev_class, old_prio, task_current(rq, p));
 }
 
 void normalize_rt_tasks(void)
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c62ebae..0a27b00 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -4072,6 +4072,17 @@ static void prio_changed_fair(struct rq *rq, struct task_struct *p,
 static void switched_to_fair(struct rq *rq, struct task_struct *p,
 			     int running)
 {
+	struct sched_entity *se = &p->se;
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+
+	if (se->on_rq && cfs_rq->curr != se)
+		__dequeue_entity(cfs_rq, se);
+
+	place_entity(cfs_rq, se, 0);
+
+	if (se->on_rq && cfs_rq->curr != se)
+		__enqueue_entity(cfs_rq, se);
+
 	/*
 	 * We were most likely switched from sched_rt, so
 	 * kick off the schedule if running, otherwise just see

