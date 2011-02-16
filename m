Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab1BPBxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:53:38 -0500
Received: from kroah.org ([198.145.64.141]:49413 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758597Ab1BPBwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:52:08 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:05 2011
Message-Id: <20110216014705.252861817@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:46:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Subject: [110/115] sched: Fix cross-sched-class wakeup preemption
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

Commit: 1e5a74059f9059d330744eac84873b1b99657008 upstream

Instead of dealing with sched classes inside each check_preempt_curr()
implementation, pull out this logic into the generic wakeup preemption
path.

This fixes a hang in KVM (and others) where we are waiting for the
stop machine thread to run ...

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Tested-by: Marcelo Tosatti <mtosatti@redhat.com>
Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1288891946.2039.31.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -594,11 +594,7 @@ struct rq {
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 
-static inline
-void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
-{
-	rq->curr->sched_class->check_preempt_curr(rq, p, flags);
-}
+static void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags);
 
 static inline int cpu_of(struct rq *rq)
 {
@@ -2392,6 +2388,24 @@ void task_oncpu_function_call(struct tas
 	preempt_enable();
 }
 
+static void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
+{
+	const struct sched_class *class;
+
+	if (p->sched_class == rq->curr->sched_class) {
+		rq->curr->sched_class->check_preempt_curr(rq, p, flags);
+	} else {
+		for_each_class(class) {
+			if (class == rq->curr->sched_class)
+				break;
+			if (class == p->sched_class) {
+				resched_task(rq->curr);
+				break;
+			}
+		}
+	}
+}
+
 #ifdef CONFIG_SMP
 /*
  * ->cpus_allowed is protected by either TASK_WAKING or rq->lock held.


