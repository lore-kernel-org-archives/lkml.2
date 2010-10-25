Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab0JYWbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 18:31:06 -0400
Received: from smtp-out.google.com ([216.239.44.51]:57080 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab0JYWbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 18:31:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=khwFjUgV2A9Y1s4MajE7bs+FyA/CwIEKygAQmWdCnwoR+u88WG7ODfbKmfUAQGuOtZ
         44gEATE/Sd2t8ONSH86w==
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
Subject: [PATCH 2/6] cleanup account_system_vtime with this_cpu_* -v1
Date: Mon, 25 Oct 2010 15:30:13 -0700
Message-Id: <1288045817-3135-3-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288045817-3135-1-git-send-email-venki@google.com>
References: <1288045817-3135-1-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this_cpu_* variants are optimal than per_cpu(). Cleanup
IRQ_TIME_ACCOUNTING account_system_vtime to use this_cpu_*.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 kernel/sched.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index fae668b..a37bb83 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1966,7 +1966,6 @@ static u64 irq_time_cpu(int cpu)
 void account_system_vtime(struct task_struct *curr)
 {
 	unsigned long flags;
-	int cpu;
 	u64 now, delta;
 
 	if (!sched_clock_irqtime)
@@ -1974,20 +1973,19 @@ void account_system_vtime(struct task_struct *curr)
 
 	local_irq_save(flags);
 
-	cpu = smp_processor_id();
-	now = sched_clock_cpu(cpu);
-	delta = now - per_cpu(irq_start_time, cpu);
-	per_cpu(irq_start_time, cpu) = now;
+	now = sched_clock_cpu(smp_processor_id());
+	delta = now - this_cpu_read(irq_start_time);
+	this_cpu_write(irq_start_time, now);
 	/*
 	 * We do not account for softirq time from ksoftirqd here.
 	 * We want to continue accounting softirq time to ksoftirqd thread
 	 * in that case, so as not to confuse scheduler with a special task
 	 * that do not consume any time, but still wants to run.
 	 */
-	if (hardirq_count())
-		per_cpu(cpu_hardirq_time, cpu) += delta;
+	if (in_irq())
+		this_cpu_add(cpu_hardirq_time, delta);
 	else if (in_serving_softirq() && curr != this_cpu_ksoftirqd())
-		per_cpu(cpu_softirq_time, cpu) += delta;
+		this_cpu_add(cpu_softirq_time, delta);
 
 	local_irq_restore(flags);
 }
-- 
1.7.1

