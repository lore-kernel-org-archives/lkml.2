Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab0CQIm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 04:42:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:59040 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553Ab0CQImX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 04:42:23 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, sivanich@sgi.com,
       heiko.carstens@de.ibm.com, torvalds@linux-foundation.org, mingo@elte.hu,
       dipankar@in.ibm.com, josh@freedesktop.org, paulmck@linux.vnet.ibm.com,
       oleg@redhat.com, akpm@linux-foundation.org, peterz@infradead.org,
       arjan@infradead.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/4] scheduler: kill paranoia check in synchronize_sched_expedited()
Date: Wed, 17 Mar 2010 17:40:51 +0900
Message-Id: <1268815251-31407-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1268815251-31407-1-git-send-email-tj@kernel.org>
References: <1268815251-31407-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Mar 2010 08:41:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The paranoid check which verifies that the hog callback is actually
called on all online cpus is completely superflous.  It's guaranteed
by cpuhog facility and if it didn't work as advertised other things
would go horribly wrong and trying to recover using
synchronize_sched() wouldn't be very meaningful.

Kill the paranoid check.  Removal of this feature is done as a
separate step so that it can serve as a bisection point if something
actually goes wrong.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Josh Triplett <josh@freedesktop.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
---
 kernel/sched.c |   39 +++------------------------------------
 1 files changed, 3 insertions(+), 36 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 926b8bd..dc726a2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8891,14 +8891,6 @@ static atomic_t synchronize_sched_expedited_count = ATOMIC_INIT(0);
 
 static int synchronize_sched_expedited_hog(void *data)
 {
-	static DEFINE_SPINLOCK(done_mask_lock);
-	struct cpumask *done_mask = data;
-
-	if (done_mask) {
-		spin_lock(&done_mask_lock);
-		cpumask_set_cpu(smp_processor_id(), done_mask);
-		spin_unlock(&done_mask_lock);
-	}
 	return 0;
 }
 
@@ -8914,53 +8906,28 @@ static int synchronize_sched_expedited_hog(void *data)
  */
 void synchronize_sched_expedited(void)
 {
-	cpumask_var_t done_mask_var;
-	struct cpumask *done_mask = NULL;
 	int snap, trycount = 0;
 
-	/*
-	 * done_mask is used to check that all cpus actually have
-	 * finished running the hog, which is guaranteed by hog_cpus()
-	 * if it's called with cpu hotplug blocked.  Keep the paranoia
-	 * for now but it's best effort if cpumask is off stack.
-	 */
-	if (zalloc_cpumask_var(&done_mask_var, GFP_ATOMIC))
-		done_mask = done_mask_var;
-
 	smp_mb();  /* ensure prior mod happens before capturing snap. */
 	snap = atomic_read(&synchronize_sched_expedited_count) + 1;
 	get_online_cpus();
 	while (try_hog_cpus(cpu_online_mask, synchronize_sched_expedited_hog,
-			    done_mask) == -EAGAIN) {
+			    NULL) == -EAGAIN) {
 		put_online_cpus();
 		if (trycount++ < 10)
 			udelay(trycount * num_online_cpus());
 		else {
 			synchronize_sched();
-			goto free_out;
+			return;
 		}
 		if (atomic_read(&synchronize_sched_expedited_count) - snap > 0) {
 			smp_mb(); /* ensure test happens before caller kfree */
-			goto free_out;
+			return;
 		}
 		get_online_cpus();
 	}
 	atomic_inc(&synchronize_sched_expedited_count);
-	if (done_mask)
-		cpumask_xor(done_mask, done_mask, cpu_online_mask);
 	put_online_cpus();
-
-	/* paranoia - this can't happen */
-	if (done_mask && cpumask_weight(done_mask)) {
-		char buf[80];
-
-		cpulist_scnprintf(buf, sizeof(buf), done_mask);
-		WARN_ONCE(1, "synchronize_sched_expedited: cpu online and done masks disagree on %d cpus: %s\n",
-			  cpumask_weight(done_mask), buf);
-		synchronize_sched();
-	}
-free_out:
-	free_cpumask_var(done_mask_var);
 }
 EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
 
-- 
1.6.4.2

