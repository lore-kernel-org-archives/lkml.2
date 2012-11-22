Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab2KVTmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:42:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40111 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755475Ab2KVT0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:26:51 -0500
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 34/40] sched: numa: Slowly increase the scanning period as NUMA faults are handled
Date: Thu, 22 Nov 2012 19:25:47 +0000
Message-Id: <1353612353-1576-35-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1353612353-1576-1-git-send-email-mgorman@suse.de>
References: <1353612353-1576-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the rate of scanning for an address space is controlled
by the individual tasks. The next scan is simply determined by
2*p->numa_scan_period.

The 2*p->numa_scan_period is arbitrary and never changes. At this point
there is still no proper policy that decides if a task or process is
properly placed. It just scans and assumes the next NUMA fault will
place it properly. As it is assumed that pages will get properly placed
over time, increase the scan window each time a fault is incurred. This
is a big assumption as noted in the comments.

It should be noted that changing to p->numa_scan_period will increase
system CPU usage because now the scanning rate has effectively doubled.
If that is a problem then the min_rate should be made 200ms instead of
restoring the 2* logic.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 kernel/sched/fair.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 357057c..3c632448 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -812,6 +812,15 @@ void task_numa_fault(int node, int pages)
 
 	/* FIXME: Allocate task-specific structure for placement policy here */
 
+	/*
+	 * Assume that as faults occur that pages are getting properly placed
+	 * and fewer NUMA hints are required. Note that this is a big
+	 * assumption, it assumes processes reach a steady steady with no
+	 * further phase changes.
+	 */
+	p->numa_scan_period = min(sysctl_balance_numa_scan_period_max,
+				p->numa_scan_period + jiffies_to_msecs(2));
+
 	task_numa_placement(p);
 }
 
@@ -858,7 +867,7 @@ void task_numa_work(struct callback_head *work)
 	if (p->numa_scan_period == 0)
 		p->numa_scan_period = sysctl_balance_numa_scan_period_min;
 
-	next_scan = now + 2*msecs_to_jiffies(p->numa_scan_period);
+	next_scan = now + msecs_to_jiffies(p->numa_scan_period);
 	if (cmpxchg(&mm->numa_next_scan, migrate, next_scan) != migrate)
 		return;
 
-- 
1.7.9.2

