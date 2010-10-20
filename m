Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab0JTWuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 18:50:19 -0400
Received: from smtp-out.google.com ([74.125.121.35]:51060 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab0JTWuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 18:50:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ngyetHd/5yNt8R+5VYrvhEVhhosqi4ZVZl7qjlkBItVRIRYomBVwNhAzIUq2PXJA90
         EnUnxY78fBjL1bccs6EQ==
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
Subject: [PATCH 3/6] Refactor account_system_time separating id and actual update
Date: Wed, 20 Oct 2010 15:48:59 -0700
Message-Id: <1287614941-32325-4-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287614941-32325-1-git-send-email-venki@google.com>
References: <1287614941-32325-1-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor account_system_time, to separate out the logic of
identifying the update needed and code that does actual updating.

This is used by following patch for IRQ_TIME_ACCOUNTING,
which has different identification logic and same update logic.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 kernel/sched.c |   46 +++++++++++++++++++++++++++++++---------------
 1 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 5d4afe9..8b97958 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3501,6 +3501,32 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
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
@@ -3511,31 +3537,21 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
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

