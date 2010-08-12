Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336Ab0HLALh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:11:37 -0400
Received: from kroah.org ([198.145.64.141]:47954 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933172Ab0HLAI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:08:58 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:18 2010
Message-Id: <20100812000618.032248444@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:06:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [58/67] sched: Revert nohz_ratelimit() for now
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 396e894d289d69bacf5acd983c97cd6e21a14c08 upstream.

Norbert reported that nohz_ratelimit() causes his laptop to burn about
4W (40%) extra. For now back out the change and see if we can adjust
the power management code to make better decisions.

Reported-by: Norbert Preining <preining@logic.at>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Mike Galbraith <efault@gmx.de>
Cc: Arjan van de Ven <arjan@infradead.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/sched.h    |    6 ------
 kernel/sched.c           |   10 ----------
 kernel/time/tick-sched.c |    2 +-
 3 files changed, 1 insertion(+), 17 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -274,17 +274,11 @@ extern cpumask_var_t nohz_cpu_mask;
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
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -325,7 +325,7 @@ void tick_nohz_stop_sched_tick(int inidl
 	} while (read_seqretry(&xtime_lock, seq));
 
 	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
-	    arch_needs_cpu(cpu) || nohz_ratelimit(cpu)) {
+	    arch_needs_cpu(cpu)) {
 		next_jiffies = last_jiffies + 1;
 		delta_jiffies = 1;
 	} else {


