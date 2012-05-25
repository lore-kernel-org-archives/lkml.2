Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964907Ab2EYRJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 13:09:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932867Ab2EYRDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 13:03:35 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>
Subject: [PATCH 34/35] autonuma: boost khugepaged scanning rate
Date: Fri, 25 May 2012 19:02:38 +0200
Message-Id: <1337965359-29725-35-git-send-email-aarcange@redhat.com>
In-Reply-To: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until THP native migration is implemented it's safer to boost
khugepaged scanning rate because all memory migration are splitting
the hugepages. So the regular rate of scanning becomes too low when
lots of memory is migrated.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 mm/huge_memory.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 017c0a3..b919c0c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -573,6 +573,14 @@ static int __init hugepage_init(void)
 
 	set_recommended_min_free_kbytes();
 
+#ifdef CONFIG_AUTONUMA
+	/* Hack, remove after THP native migration */
+	if (num_possible_nodes() > 1) {
+		khugepaged_scan_sleep_millisecs = 100;
+		khugepaged_alloc_sleep_millisecs = 10000;
+	}
+#endif
+
 	return 0;
 out:
 	hugepage_exit_sysfs(hugepage_kobj);
