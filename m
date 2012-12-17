Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab2LQOGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 09:06:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56408 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab2LQOF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 09:05:59 -0500
Date: Mon, 17 Dec 2012 14:05:53 +0000
From: Mel Gorman <mgorman@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Hillf Danton <dhillf@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: numa: Fix build error if CONFIG_NUMA_BALANCING &&
 !CONFIG_TRANSPARENT_HUGEPAGE
Message-ID: <20121217140553.GG9887@suse.de>
References: <20121212100338.GS1009@suse.de>
 <CA+55aFzedbhcuo-WObUjigrXGuG2VGLqDOvh_HFA9Cn_BRkwjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFzedbhcuo-WObUjigrXGuG2VGLqDOvh_HFA9Cn_BRkwjQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko reported that the following build error occurs if
CONFIG_NUMA_BALANCING is set without THP support

kernel/sched/fair.c: In function ‘task_numa_work’:
kernel/sched/fair.c:932:55: error: call to ‘__build_bug_failed’ declared with attribute error: BUILD_BUG failed

The problem is that HPAGE_PMD_SHIFT triggers a BUILD_BUG() on
!CONFIG_TRANSPARENT_HUGEPAGE. This patch addresses the problem.

Reported-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9af5af9..4603d6c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -929,7 +929,7 @@ void task_numa_work(struct callback_head *work)
 			continue;
 
 		/* Skip small VMAs. They are not likely to be of relevance */
-		if (((vma->vm_end - vma->vm_start) >> PAGE_SHIFT) < HPAGE_PMD_NR)
+		if (vma->vm_end - vma->vm_start < HPAGE_SIZE)
 			continue;
 
 		do {

