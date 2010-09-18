Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710Ab0IRTr3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:47:29 -0400
Received: from kroah.org ([198.145.64.141]:51546 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755792Ab0IRTBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:54 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:58 2010
Message-Id: <20100918185958.621131329@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Mike Galbraith <efault@gmx.de>
Subject: [068/123] sched: Remove rq->clock coupling from set_task_cpu()
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-remove-rq-clock-coupling-from-set_task_cpu.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 5afcdab706d6002cb02b567ba46e650215e694e8 upstream

set_task_cpu() should be rq invariant and only touch task state, it
currently fails to do so, which opens up a few races, since not all
callers hold both rq->locks.

Remove the relyance on rq->clock, as any site calling set_task_cpu()
should also do a remote clock update, which should ensure the observed
time between these two cpus is monotonic, as per
kernel/sched_clock.c:sched_clock_remote().

Therefore we can simply remove the clock_offset bits and be happy.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2069,23 +2069,12 @@ task_hot(struct task_struct *p, u64 now,
 void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 {
 	int old_cpu = task_cpu(p);
-	struct rq *old_rq = cpu_rq(old_cpu), *new_rq = cpu_rq(new_cpu);
+	struct rq *old_rq = cpu_rq(old_cpu);
 	struct cfs_rq *old_cfsrq = task_cfs_rq(p),
 		      *new_cfsrq = cpu_cfs_rq(old_cfsrq, new_cpu);
-	u64 clock_offset;
-
-	clock_offset = old_rq->clock - new_rq->clock;
 
 	trace_sched_migrate_task(p, new_cpu);
 
-#ifdef CONFIG_SCHEDSTATS
-	if (p->se.wait_start)
-		p->se.wait_start -= clock_offset;
-	if (p->se.sleep_start)
-		p->se.sleep_start -= clock_offset;
-	if (p->se.block_start)
-		p->se.block_start -= clock_offset;
-#endif
 	if (old_cpu != new_cpu) {
 		p->se.nr_migrations++;
 #ifdef CONFIG_SCHEDSTATS


