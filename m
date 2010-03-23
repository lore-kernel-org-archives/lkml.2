Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab0CWRjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 13:39:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43654 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753425Ab0CWRjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 13:39:07 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>,
       Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched: prevent compiler from optimising sched_avg_update loop
Date: Tue, 23 Mar 2010 17:36:45 +0000
Message-Id: <1269365805-17280-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 23 Mar 2010 17:37:10.0832 (UTC) FILETIME=[779C9B00:01CACAAF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GCC 4.4.1 on ARM has been observed to replace the while loop
in sched_avg_update with a call to uldivmod, resulting in the
following build failure at link-time:

kernel/built-in.o: In function `sched_avg_update':
/linux-2.6/kernel/sched.c:1261: undefined reference to `__aeabi_uldivmod'
/linux-2.6/kernel/sched.c:1261: undefined reference to `__aeabi_uldivmod'
make: *** [.tmp_vmlinux1] Error 1

This patch [taken against 2.6.34-rc2] replaces the loop with a call to
div_s64 which allows the Kernel to link.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 kernel/sched.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 9ab3cd7..6b74f21 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1238,11 +1238,10 @@ static u64 sched_avg_period(void)
 static void sched_avg_update(struct rq *rq)
 {
 	s64 period = sched_avg_period();
+	s64 elapsed_periods = div_s64(rq->clock - rq->age_stamp - 1, period);
 
-	while ((s64)(rq->clock - rq->age_stamp) > period) {
-		rq->age_stamp += period;
-		rq->rt_avg /= 2;
-	}
+	rq->age_stamp += (u64)(elapsed_periods * period);
+	rq->rt_avg >>= elapsed_periods;
 }
 
 static void sched_rt_avg_update(struct rq *rq, u64 rt_delta)
-- 
1.6.3.3

