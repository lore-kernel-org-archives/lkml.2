Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab2LBSvN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 13:51:13 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:45147 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab2LBSpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 13:45:06 -0500
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
Subject: [PATCH 31/52] sched: Introduce staged average NUMA faults
Date: Sun,  2 Dec 2012 19:43:23 +0100
Message-Id: <1354473824-19229-32-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354473824-19229-1-git-send-email-mingo@kernel.org>
References: <1354473824-19229-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current way of building the p->numa_faults[2][node] faults
statistics has a sampling artifact:

The continuous and immediate nature of propagating new fault
stats to the numa_faults array creates a 'pulsating' dynamic,
that starts at the average value at the beginning of the scan,
increases monotonically until we finish the scan to about twice
the average, and then drops back to half of its value due to
the running average.

Since we rely on these values to balance tasks, the pulsating
nature resulted in false migrations and general noise in the
stats.

To solve this, introduce buffering of the current scan via
p->task_numa_faults_curr[]. The array is co-allocated with the
p->task_numa[] for efficiency reasons, but it is otherwise an
ordinary separate array.

At the end of the scan we propagate the latest stats into the
average stats value. Most of the balancing code stays unmodified.

The cost of this change is that we delay the effects of the latest
round of faults by 1 scan - but using the partial faults info was
creating artifacts.

This instantly stabilized the page fault stats and improved
numa02-alike workloads by making them faster to converge.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9c46b45..1ab11be 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -852,12 +852,26 @@ static void task_numa_placement(struct task_struct *p)
 
 	p->numa_scan_seq = seq;
 
+	/*
+	 * Update the fault average with the result of the latest
+	 * scan:
+	 */
 	for (node = 0; node < nr_node_ids; node++) {
 		faults = 0;
 		for (priv = 0; priv < 2; priv++) {
-			faults += p->numa_faults[2*node + priv];
-			total[priv] += p->numa_faults[2*node + priv];
-			p->numa_faults[2*node + priv] /= 2;
+			unsigned int new_faults;
+			unsigned int idx;
+
+			idx = 2*node + priv;
+			new_faults = p->numa_faults_curr[idx];
+			p->numa_faults_curr[idx] = 0;
+
+			/* Keep a simple running average: */
+			p->numa_faults[idx] += new_faults;
+			p->numa_faults[idx] /= 2;
+
+			faults += p->numa_faults[idx];
+			total[priv] += p->numa_faults[idx];
 		}
 		if (faults > max_faults) {
 			max_faults = faults;
-- 
1.7.11.7

