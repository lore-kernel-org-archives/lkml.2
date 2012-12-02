Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab2LBSpQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 13:45:16 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:45147 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab2LBSpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 13:45:11 -0500
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
Subject: [PATCH 34/52] sched: Average the fault stats longer
Date: Sun,  2 Dec 2012 19:43:26 +0100
Message-Id: <1354473824-19229-35-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354473824-19229-1-git-send-email-mingo@kernel.org>
References: <1354473824-19229-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will rely on the per CPU fault statistics and its
shared/private derivative even more in the future, so
stabilize this metric even better.

The staged updates introduced in commit:

   sched: Introduce staged average NUMA faults

Already stabilized this key metric significantly, but in
real workloads it was still reacting to temporary load
balancing transients too quickly.

Slow down by weighting the average. The weighting value was
found via experimentation.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 24a5588..a5f3ad7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -914,8 +914,8 @@ static void task_numa_placement(struct task_struct *p)
 			p->numa_faults_curr[idx] = 0;
 
 			/* Keep a simple running average: */
-			p->numa_faults[idx] += new_faults;
-			p->numa_faults[idx] /= 2;
+			p->numa_faults[idx] = p->numa_faults[idx]*7 + new_faults;
+			p->numa_faults[idx] /= 8;
 
 			faults += p->numa_faults[idx];
 			total[priv] += p->numa_faults[idx];
-- 
1.7.11.7

