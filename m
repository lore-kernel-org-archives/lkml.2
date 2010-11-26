Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab0KZHDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 02:03:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60331 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860Ab0KZHDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 02:03:35 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -tip] Remove unused argument dest_cpu to migrate_task()
Date: Fri, 26 Nov 2010 12:37:09 +0530
User-Agent: KMail/1.12.4 (Linux/2.6.31.14-0.4-default; KDE/4.3.5; x86_64; ; )
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011261237.09187.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused argument, 'dest_cpu' of migrate_task(), and pass runqueue,
as it is always known at the call site.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/kernel/sched.c b/kernel/sched.c
index 717bf7d..b6999bc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2060,10 +2060,8 @@ static int migration_cpu_stop(void *data);
  * The task's runqueue lock must be held.
  * Returns true if you have to wait for migration thread.
  */
-static bool migrate_task(struct task_struct *p, int dest_cpu)
+static bool migrate_task(struct task_struct *p, struct rq *rq)
 {
-	struct rq *rq = task_rq(p);
-
 	/*
 	 * If the task is not on a runqueue (and not running), then
 	 * the next wake-up will properly place the task.
@@ -3224,7 +3222,7 @@ void sched_exec(void)
 	 * select_task_rq() can race against ->cpus_allowed
 	 */
 	if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed) &&
-	    likely(cpu_active(dest_cpu)) && migrate_task(p, dest_cpu)) {
+	    likely(cpu_active(dest_cpu)) && migrate_task(p, rq)) {
 		struct migration_arg arg = { p, dest_cpu };
 
 		task_rq_unlock(rq, &flags);
@@ -5505,7 +5503,7 @@ again:
 		goto out;
 
 	dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
-	if (migrate_task(p, dest_cpu)) {
+	if (migrate_task(p, rq)) {
 		struct migration_arg arg = { p, dest_cpu };
 		/* Need help from migration thread: drop lock and wait. */
 		task_rq_unlock(rq, &flags);
