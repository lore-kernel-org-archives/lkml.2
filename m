Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933194Ab1INUGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 16:06:06 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:43666 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933140Ab1INUGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 16:06:03 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: xemul@parallels.com, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, mingo@elte.hu, a.p.zijlstra@chello.nl,
        jbottomley@parallels.com, Glauber Costa <glommer@parallels.com>
Subject: [PATCH 4/9] Include irq and softirq fields in cpuacct
Date: Wed, 14 Sep 2011 17:04:50 -0300
Message-Id: <1316030695-19826-5-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1316030695-19826-1-git-send-email-glommer@parallels.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 kernel/sched.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 93aa666..a36d995 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1448,6 +1448,8 @@ enum cpuacct_stat_index {
 	CPUACCT_STAT_USER,	/* ... user mode */
 	CPUACCT_STAT_NICE,	/* ... user nice */
 	CPUACCT_STAT_SYSTEM,	/* ... kernel mode */
+	CPUACCT_STAT_IRQ,	/* ... irq ticks */
+	CPUACCT_STAT_SOFTIRQ,	/* ... softirq ticks */
 
 	CPUACCT_STAT_NSTATS,
 };
@@ -3819,7 +3821,8 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
  */
 static inline
 void __account_system_time(struct task_struct *p, cputime_t cputime,
-			cputime_t cputime_scaled, cputime64_t *target_cputime64)
+			   cputime_t cputime_scaled,
+			   cputime64_t *target_cputime64, int stat)
 {
 	cputime64_t tmp = cputime_to_cputime64(cputime);
 
@@ -3830,10 +3833,10 @@ void __account_system_time(struct task_struct *p, cputime_t cputime,
 
 	/* Add system time to cpustat. */
 	*target_cputime64 = cputime64_add(*target_cputime64, tmp);
-	cpuacct_update_stats(p, CPUACCT_STAT_SYSTEM, cputime);
 
 	/* Account for system time used */
 	acct_update_integrals(p);
+	cpuacct_update_stats(p, stat, cputime);
 }
 
 /*
@@ -3848,20 +3851,23 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 {
 	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
 	cputime64_t *target_cputime64;
+	int stat = CPUACCT_STAT_SYSTEM;
 
 	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
 		account_guest_time(p, cputime, cputime_scaled);
 		return;
 	}
 
-	if (hardirq_count() - hardirq_offset)
+	if (hardirq_count() - hardirq_offset) {
 		target_cputime64 = &cpustat->irq;
-	else if (in_serving_softirq())
+		stat = CPUACCT_STAT_IRQ;
+	} else if (in_serving_softirq()) {
 		target_cputime64 = &cpustat->softirq;
-	else
+		stat = CPUACCT_STAT_SOFTIRQ;
+	} else
 		target_cputime64 = &cpustat->system;
 
-	__account_system_time(p, cputime, cputime_scaled, target_cputime64);
+	__account_system_time(p, cputime, cputime_scaled, target_cputime64, stat);
 }
 
 /*
@@ -3941,22 +3947,26 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
 	cputime64_t tmp = cputime_to_cputime64(cputime_one_jiffy);
 	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	int stat = CPUACCT_STAT_SYSTEM;
 
 	if (steal_account_process_tick())
 		return;
 
 	if (irqtime_account_hi_update()) {
 		cpustat->irq = cputime64_add(cpustat->irq, tmp);
+		cpuacct_update_stats(p, CPUACCT_STAT_IRQ, tmp);
 	} else if (irqtime_account_si_update()) {
 		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
+		cpuacct_update_stats(p, CPUACCT_STAT_SOFTIRQ, tmp);
 	} else if (this_cpu_ksoftirqd() == p) {
+		stat = CPUACCT_STAT_SOFTIRQ;
 		/*
 		 * ksoftirqd time do not get accounted in cpu_softirq_time.
 		 * So, we have to handle it separately here.
 		 * Also, p->stime needs to be updated for ksoftirqd.
 		 */
 		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
-					&cpustat->softirq);
+					&cpustat->softirq, stat);
 	} else if (user_tick) {
 		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
 	} else if (p == rq->idle) {
@@ -3965,7 +3975,7 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 		account_guest_time(p, cputime_one_jiffy, one_jiffy_scaled);
 	} else {
 		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
-					&cpustat->system);
+					&cpustat->system, stat);
 	}
 }
 
-- 
1.7.6

