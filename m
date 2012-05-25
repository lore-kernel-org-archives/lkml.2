Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964935Ab2EYRE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 13:04:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933847Ab2EYRDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 13:03:50 -0400
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
Subject: [PATCH 14/35] autonuma: knuma_migrated per NUMA node queues
Date: Fri, 25 May 2012 19:02:18 +0200
Message-Id: <1337965359-29725-15-git-send-email-aarcange@redhat.com>
In-Reply-To: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements the knuma_migrated queues. The pages are added to
these queues through the NUMA hinting page faults (memory follow CPU
algorithm with false sharing evaluation) and knuma_migrated then is
waken with a certain hysteresis to migrate the memory in round robin
from all remote nodes to its local node.

The head that belongs to the local node that knuma_migrated runs on,
for now must be empty and it's not being used.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 include/linux/mmzone.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 41aa49b..8e578e6 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -666,6 +666,12 @@ typedef struct pglist_data {
 	struct task_struct *kswapd;
 	int kswapd_max_order;
 	enum zone_type classzone_idx;
+#ifdef CONFIG_AUTONUMA
+	spinlock_t autonuma_lock;
+	struct list_head autonuma_migrate_head[MAX_NUMNODES];
+	unsigned long autonuma_nr_migrate_pages;
+	wait_queue_head_t autonuma_knuma_migrated_wait;
+#endif
 } pg_data_t;
 
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
