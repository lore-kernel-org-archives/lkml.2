Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab2KPL1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 06:27:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33147 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906Ab2KPLXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 06:23:40 -0500
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 30/43] sched: numa: Slowly increase the scanning period as NUMA faults are handled
Date: Fri, 16 Nov 2012 11:22:40 +0000
Message-Id: <1353064973-26082-31-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1353064973-26082-1-git-send-email-mgorman@suse.de>
References: <1353064973-26082-1-git-send-email-mgorman@suse.de>
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

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 kernel/sched/fair.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1bf97b5..14bd61a8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -811,6 +811,15 @@ void task_numa_fault(int node, int pages)
 
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
 
@@ -857,7 +866,7 @@ void task_numa_work(struct callback_head *work)
 	if (WARN_ON_ONCE(p->numa_scan_period) == 0)
 		p->numa_scan_period = sysctl_balance_numa_scan_period_min;
 
-	next_scan = now + 2*msecs_to_jiffies(p->numa_scan_period);
+	next_scan = now + msecs_to_jiffies(p->numa_scan_period);
 	if (cmpxchg(&mm->numa_next_scan, migrate, next_scan) != migrate)
 		return;
 
-- 
1.7.9.2

