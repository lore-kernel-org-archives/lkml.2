Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab0CWTG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 15:06:26 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54816 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753220Ab0CWTGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 15:06:24 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>,
       Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched: prevent compiler from optimising sched_avg_update loop
Date: Tue, 23 Mar 2010 19:05:47 +0000
Message-Id: <1269371148-15314-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1269365805-17280-1-git-send-email-will.deacon@arm.com>
References: <1269365805-17280-1-git-send-email-will.deacon@arm.com>
X-OriginalArrivalTime: 23 Mar 2010 19:06:06.0233 (UTC) FILETIME=[E3C23090:01CACABB]
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

This patch [taken against 2.6.34-rc2] introduces a fake data hazard to
the loop body to prevent the compiler optimising the loop away.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 kernel/sched.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 9ab3cd7..0846815 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1240,6 +1240,12 @@ static void sched_avg_update(struct rq *rq)
 	s64 period = sched_avg_period();
 
 	while ((s64)(rq->clock - rq->age_stamp) > period) {
+		/*
+		 * Inline assembly required to prevent the compiler
+		 * optimising this loop into a divmod call.
+		 * See __iter_div_u64_rem() for another example of this.
+		 */
+		asm("" : "+rm" (rq->age_stamp));
 		rq->age_stamp += period;
 		rq->rt_avg /= 2;
 	}
-- 
1.6.3.3

