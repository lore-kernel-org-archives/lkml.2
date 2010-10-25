Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836Ab0JYWbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 18:31:18 -0400
Received: from smtp-out.google.com ([74.125.121.35]:47173 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab0JYWbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 18:31:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XqDWQen5XqGZXMfdRbxtVEABQGywnPW8YGypIhNQLYBssZm9mewu9CFQx80mg7N8WV
         bNErLU+7/Qelk01UEa/A==
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
Subject: [PATCH 6/6] Account ksoftirqd time as cpustat softirq -v1
Date: Mon, 25 Oct 2010 15:30:17 -0700
Message-Id: <1288045817-3135-7-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288045817-3135-1-git-send-email-venki@google.com>
References: <1288045817-3135-1-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

softirq time in ksoftirqd context is not accounted in ns granularity
per cpu softirq stats, as we want that to be a part of ksoftirqd
exec_runtime.

Accounting them as softirq on /proc/stat separately.

Tested-by: Shaun Ruffell <sruffell@digium.com>

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 kernel/sched.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 49f6f61..0955050 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3617,6 +3617,14 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 		cpustat->irq = cputime64_add(cpustat->irq, tmp);
 	} else if (irqtime_account_si_update()) {
 		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
+	} else if (this_cpu_ksoftirqd() == p) {
+		/*
+		 * ksoftirqd time do not get accounted in cpu_softirq_time.
+		 * So, we have to handle it separately here.
+		 * Also, p->stime needs to be updated for ksoftirqd.
+		 */
+		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
+					&cpustat->softirq);
 	} else if (user_tick) {
 		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
 	} else if (p == rq->idle) {
-- 
1.7.1

