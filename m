Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759910Ab0GQLNS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 07:13:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:41449 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759831Ab0GQLNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 07:13:16 -0400
Date: Sat, 17 Jul 2010 11:12:38 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, preining@logic.at,
        arjan@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: arjan@infradead.org, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        tglx@linutronix.de, preining@logic.at, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Revert nohz_ratelimit() for now
Message-ID: <tip-396e894d289d69bacf5acd983c97cd6e21a14c08@git.kernel.org>
Git-Commit-ID: 396e894d289d69bacf5acd983c97cd6e21a14c08
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 17 Jul 2010 11:12:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  396e894d289d69bacf5acd983c97cd6e21a14c08
Gitweb:     http://git.kernel.org/tip/396e894d289d69bacf5acd983c97cd6e21a14c08
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 9 Jul 2010 15:12:27 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 17 Jul 2010 12:05:44 +0200

sched: Revert nohz_ratelimit() for now

Norbert reported that nohz_ratelimit() causes his laptop to burn about
4W (40%) extra. For now back out the change and see if we can adjust
the power management code to make better decisions.

Reported-by: Norbert Preining <preining@logic.at>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Mike Galbraith <efault@gmx.de>
Cc: Arjan van de Ven <arjan@infradead.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h    |    6 ------
 kernel/sched.c           |   10 ----------
 kernel/time/tick-sched.c |    2 +-
 3 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 747fcae..6e0bb86 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -273,17 +273,11 @@ extern cpumask_var_t nohz_cpu_mask;
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
 extern int select_nohz_load_balancer(int cpu);
 extern int get_nohz_load_balancer(void);
-extern int nohz_ratelimit(int cpu);
 #else
 static inline int select_nohz_load_balancer(int cpu)
 {
 	return 0;
 }
-
-static inline int nohz_ratelimit(int cpu)
-{
-	return 0;
-}
 #endif
 
 /*
diff --git a/kernel/sched.c b/kernel/sched.c
index f52a880..63b4a14 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1232,16 +1232,6 @@ void wake_up_idle_cpu(int cpu)
 		smp_send_reschedule(cpu);
 }
 
-int nohz_ratelimit(int cpu)
-{
-	struct rq *rq = cpu_rq(cpu);
-	u64 diff = rq->clock - rq->nohz_stamp;
-
-	rq->nohz_stamp = rq->clock;
-
-	return diff < (NSEC_PER_SEC / HZ) >> 1;
-}
-
 #endif /* CONFIG_NO_HZ */
 
 static u64 sched_avg_period(void)
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 813993b..f898af6 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -325,7 +325,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 	} while (read_seqretry(&xtime_lock, seq));
 
 	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
-	    arch_needs_cpu(cpu) || nohz_ratelimit(cpu)) {
+	    arch_needs_cpu(cpu)) {
 		next_jiffies = last_jiffies + 1;
 		delta_jiffies = 1;
 	} else {
