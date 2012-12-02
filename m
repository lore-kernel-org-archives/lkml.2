Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab2LBStp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 13:49:45 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:45147 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab2LBSpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 13:45:16 -0500
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: [PATCH 36/52] sched: Add hysteresis to p->numa_shared
Date: Sun,  2 Dec 2012 19:43:28 +0100
Message-Id: <1354473824-19229-37-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354473824-19229-1-git-send-email-mingo@kernel.org>
References: <1354473824-19229-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make p->numa_shared flip/flop less around unstable equilibriums,
instead require a significant move in either direction to trigger
'dominantly shared accesses' versus 'dominantly private accesses'
NUMA status.

Suggested-by: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 46d23c7..f3fb508 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1111,7 +1111,20 @@ static void task_numa_placement(struct task_struct *p)
 	 * we might want to consider a different equation below to reduce
 	 * the impact of a little private memory accesses.
 	 */
-	shared = (total[0] >= total[1] / 2);
+	shared = p->numa_shared;
+
+	if (shared < 0) {
+		shared = (total[0] >= total[1]);
+	} else if (shared == 0) {
+		/* If it was private before, make it harder to become shared: */
+		if (total[0] >= total[1]*2)
+			shared = 1;
+	} else if (shared == 1 ) {
+		 /* If it was shared before, make it harder to become private: */
+		if (total[0]*2 <= total[1])
+			shared = 0;
+	}
+
 	if (shared)
 		p->ideal_cpu = sched_update_ideal_cpu_shared(p);
 	else
-- 
1.7.11.7

