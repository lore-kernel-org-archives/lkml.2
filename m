Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab0IRTL1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:11:27 -0400
Received: from kroah.org ([198.145.64.141]:51776 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055Ab0IRTCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:17 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:01 2010
Message-Id: <20100918190001.382076701@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:59:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Oleg Nesterov <oleg@redhat.com>,
        Mike Galbraith <efault@gmx.de>
Subject: [100/123] sched: Optimize task_rq_lock()
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-optimize-task_rq_lock.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 65cc8e4859ff29a9ddc989c88557d6059834c2a2 upstream

Now that we hold the rq->lock over set_task_cpu() again, we can do
away with most of the TASK_WAKING checks and reduce them again to
set_cpus_allowed_ptr().

Removes some conditionals from scheduling hot-paths.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -942,8 +942,8 @@ static inline void finish_lock_switch(st
 #endif /* __ARCH_WANT_UNLOCKED_CTXSW */
 
 /*
- * Check whether the task is waking, we use this to synchronize against
- * ttwu() so that task_cpu() reports a stable number.
+ * Check whether the task is waking, we use this to synchronize ->cpus_allowed
+ * against ttwu().
  */
 static inline int task_is_waking(struct task_struct *p)
 {
@@ -960,11 +960,9 @@ static inline struct rq *__task_rq_lock(
 	struct rq *rq;
 
 	for (;;) {
-		while (task_is_waking(p))
-			cpu_relax();
 		rq = task_rq(p);
 		spin_lock(&rq->lock);
-		if (likely(rq == task_rq(p) && !task_is_waking(p)))
+		if (likely(rq == task_rq(p)))
 			return rq;
 		spin_unlock(&rq->lock);
 	}
@@ -981,12 +979,10 @@ static struct rq *task_rq_lock(struct ta
 	struct rq *rq;
 
 	for (;;) {
-		while (task_is_waking(p))
-			cpu_relax();
 		local_irq_save(*flags);
 		rq = task_rq(p);
 		spin_lock(&rq->lock);
-		if (likely(rq == task_rq(p) && !task_is_waking(p)))
+		if (likely(rq == task_rq(p)))
 			return rq;
 		spin_unlock_irqrestore(&rq->lock, *flags);
 	}
@@ -7213,7 +7209,18 @@ int set_cpus_allowed_ptr(struct task_str
 	struct rq *rq;
 	int ret = 0;
 
+	/*
+	 * Serialize against TASK_WAKING so that ttwu() and wunt() can
+	 * drop the rq->lock and still rely on ->cpus_allowed.
+	 */
+again:
+	while (task_is_waking(p))
+		cpu_relax();
 	rq = task_rq_lock(p, &flags);
+	if (task_is_waking(p)) {
+		task_rq_unlock(rq, &flags);
+		goto again;
+	}
 
 	if (!cpumask_intersects(new_mask, cpu_active_mask)) {
 		ret = -EINVAL;


