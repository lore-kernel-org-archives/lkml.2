Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab2E3NjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 09:39:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38429 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab2E3NjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 09:39:08 -0400
Date: Wed, 30 May 2012 06:38:51 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-b654f7de41b0e3903ee2b51d3b8db77fe52ce728@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, rientjes@google.com
In-Reply-To: <1337688268.9698.29.camel@twins>
References: <1337688268.9698.29.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched:
  Make sure to not re-read variables after validation
Git-Commit-ID: b654f7de41b0e3903ee2b51d3b8db77fe52ce728
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 30 May 2012 06:38:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b654f7de41b0e3903ee2b51d3b8db77fe52ce728
Gitweb:     http://git.kernel.org/tip/b654f7de41b0e3903ee2b51d3b8db77fe52ce728
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 22 May 2012 14:04:28 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 30 May 2012 14:02:24 +0200

sched: Make sure to not re-read variables after validation

We could re-read rq->rt_avg after we validated it was smaller than
total, invalidating the check and resulting in an unintended negative.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Rientjes <rientjes@google.com>
Link: http://lkml.kernel.org/r/1337688268.9698.29.camel@twins
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f0380d4..2b449a7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3503,15 +3503,22 @@ unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
 unsigned long scale_rt_power(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
-	u64 total, available;
+	u64 total, available, age_stamp, avg;
 
-	total = sched_avg_period() + (rq->clock - rq->age_stamp);
+	/*
+	 * Since we're reading these variables without serialization make sure
+	 * we read them once before doing sanity checks on them.
+	 */
+	age_stamp = ACCESS_ONCE(rq->age_stamp);
+	avg = ACCESS_ONCE(rq->rt_avg);
+
+	total = sched_avg_period() + (rq->clock - age_stamp);
 
-	if (unlikely(total < rq->rt_avg)) {
+	if (unlikely(total < avg)) {
 		/* Ensures that power won't end up being negative */
 		available = 0;
 	} else {
-		available = total - rq->rt_avg;
+		available = total - avg;
 	}
 
 	if (unlikely((s64)total < SCHED_POWER_SCALE))
