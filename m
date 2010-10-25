Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab0JYWbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 18:31:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:57111 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab0JYWbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 18:31:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZTn4loAicSuL7Y5pPM63y86cRYdbqmWIbN2cmB/JsoBi9Ko7tPF/srG5TYFaSNAqbD
         Hi6jQt5ShhVs7G49SofQ==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 4/6] Refactor account_system_time separating id-update -v1
Date: Mon, 25 Oct 2010 15:30:15 -0700
Message-Id: <1288045817-3135-5-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288045817-3135-1-git-send-email-venki@google.com>
References: <1288045817-3135-1-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor account_system_time, to separate out the logic of
identifying the update needed and code that does actual updating.

This is used by following patch for IRQ_TIME_ACCOUNTING,
which has different identification logic and same update logic.

Tested-by: Shaun Ruffell <sruffell@digium.com>

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 kernel/sched.c |   46 +++++++++++++++++++++++++++++++---------------
 1 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index a37bb83..f291f3d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3499,6 +3499,32 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 }
 
 /*
+ * Account system cpu time to a process and desired cpustat field
+ * @p: the process that the cpu time gets accounted to
+ * @cputime: the cpu time spent in kernel space since the last update
+ * @cputime_scaled: cputime scaled by cpu frequency
+ * @target_cputime64: pointer to cpustat field that needs updating
+ */
+static inline
+void __account_system_time(struct task_struct *p, cputime_t cputime,
+			cputime_t cputime_scaled, cputime64_t *target_cputime64)
+{
+	cputime64_t tmp = cputime_to_cputime64(cputime);
+
+	/* Add system time to process. */
+	p->stime = cputime_add(p->stime, cputime);
+	p->stimescaled = cputime_add(p->stimescaled, cputime_scaled);
+	account_group_system_time(p, cputime);
+
+	/* Add system time to cpustat. */
+	*target_cputime64 = cputime64_add(*target_cputime64, tmp);
+	cpuacct_update_stats(p, CPUACCT_STAT_SYSTEM, cputime);
+
+	/* Account for system time used */
+	acct_update_integrals(p);
+}
+
+/*
  * Account system cpu time to a process.
  * @p: the process that the cpu time gets accounted to
  * @hardirq_offset: the offset to subtract from hardirq_count()
@@ -3509,31 +3535,21 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 			 cputime_t cputime, cputime_t cputime_scaled)
 {
 	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
-	cputime64_t tmp;
+	cputime64_t *target_cputime64;
 
 	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
 		account_guest_time(p, cputime, cputime_scaled);
 		return;
 	}
 
-	/* Add system time to process. */
-	p->stime = cputime_add(p->stime, cputime);
-	p->stimescaled = cputime_add(p->stimescaled, cputime_scaled);
-	account_group_system_time(p, cputime);
-
-	/* Add system time to cpustat. */
-	tmp = cputime_to_cputime64(cputime);
 	if (hardirq_count() - hardirq_offset)
-		cpustat->irq = cputime64_add(cpustat->irq, tmp);
+		target_cputime64 = &cpustat->irq;
 	else if (in_serving_softirq())
-		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
+		target_cputime64 = &cpustat->softirq;
 	else
-		cpustat->system = cputime64_add(cpustat->system, tmp);
+		target_cputime64 = &cpustat->system;
 
-	cpuacct_update_stats(p, CPUACCT_STAT_SYSTEM, cputime);
-
-	/* Account for system time used */
-	acct_update_integrals(p);
+	__account_system_time(p, cputime, cputime_scaled, target_cputime64);
 }
 
 /*
-- 
1.7.1

