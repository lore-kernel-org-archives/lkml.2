Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab1BHSOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 13:14:34 -0500
Received: from smtp-out.google.com ([74.125.121.67]:56319 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab1BHSOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 13:14:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kxog1CYUZJB9ERMPhh8j+wiyoOGcOGhhiMYJdH3Y9+qm+LtBfcqE50ZThRbh6SgMzs
         pDrDaGI8vI1jWe+1VaHA==
From: Venkatesh Pallipadi <venki@google.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Nick Piggin <npiggin@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 3/3] sched: newidle balance set idle_timestamp only on successful pull
Date: Tue,  8 Feb 2011 10:13:39 -0800
Message-Id: <1297188819-19999-4-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <AANLkTikmWfLv3iMNUky7TRvQtUknLckftiQ4-Br614Rm@mail.gmail.com>
References: <AANLkTikmWfLv3iMNUky7TRvQtUknLckftiQ4-Br614Rm@mail.gmail.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

load_balance() could return a negative value in the case of
SMT sibling CPU being busy. Code in idle_balance() though, uses this
return value as an indicator of successful task pull, ignoring the
-1 return value.

This has two problems:
1) Resets idle_stamp even when this return value is -1.
Specific case is on SMT capable system, CPU A is idle and its sibling
CPU B is busy. In this case, CPU A avg_idle will not depend on
a task sleeping/waking up on it. Instead it will continue to hold stale
avg_idle value for extended period of time.

Simple test case of driving avg_idle on a CPU to desired value by using
a usleep loop and then starting a 100% busy loop on its sibling and
changing the usleep rate on original CPU (or removing it completely),
I see the avg_idle on this CPU not updating at all in this case.

2) Breaks out of idle_balance, skipping all higher level domains.
Case can be made that breaking out here is a 'feature' and not a 'bug'.
Periodic balance uses this signal to drop down to busy balance for
higher level domains. But, is simple break out of balancing good for
newidle case?

We do see results in our workload, that this break increases idle time
and reduces both throughput and latency measurably. Also, as newidle
balance itself is ratelimited with avg_idle, would it be OK to continue
balancing upper domains in this case of SMT sibling busy? Or may be
reduce it to CPU_NOT_IDLE from CPU_NEWLY_IDLE? Change here goes with
the former option.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 91227d9..56ab3a6 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3483,7 +3483,7 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 		interval = msecs_to_jiffies(sd->balance_interval);
 		if (time_after(next_balance, sd->last_balance + interval))
 			next_balance = sd->last_balance + interval;
-		if (pulled_task) {
+		if (pulled_task > 0) {
 			this_rq->idle_stamp = 0;
 			break;
 		}
-- 
1.7.3.1

