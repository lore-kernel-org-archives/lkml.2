Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123Ab2LGKZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 05:25:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42403 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933024Ab2LGKZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 05:25:09 -0500
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Hillf Danton <dhillf@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 42/49] mm: sched: numa: Control enabling and disabling of NUMA balancing if !SCHED_DEBUG
Date: Fri,  7 Dec 2012 10:23:45 +0000
Message-Id: <1354875832-9700-43-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1354875832-9700-1-git-send-email-mgorman@suse.de>
References: <1354875832-9700-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "mm: sched: numa: Control enabling and disabling of NUMA balancing"
depends on scheduling debug being enabled but it's perfectly legimate to
disable automatic NUMA balancing even without this option. This should
take care of it.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 kernel/sched/core.c  |    9 +++++++++
 kernel/sched/sched.h |    8 +++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4841f4f..161079c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1558,6 +1558,7 @@ static void __sched_fork(struct task_struct *p)
 }
 
 #ifdef CONFIG_BALANCE_NUMA
+#ifdef CONFIG_SCHED_DEBUG
 void set_balancenuma_state(bool enabled)
 {
 	if (enabled)
@@ -1565,6 +1566,14 @@ void set_balancenuma_state(bool enabled)
 	else
 		sched_feat_set("NO_NUMA");
 }
+#else
+__read_mostly bool balancenuma_enabled;
+
+void set_balancenuma_state(bool enabled)
+{
+	balancenuma_enabled = enabled;
+}
+#endif /* CONFIG_SCHED_DEBUG */
 #endif /* CONFIG_BALANCE_NUMA */
 
 /*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 9a43241..03dce73 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -650,9 +650,15 @@ extern struct static_key sched_feat_keys[__SCHED_FEAT_NR];
 
 #ifdef CONFIG_BALANCE_NUMA
 #define sched_feat_numa(x) sched_feat(x)
+#ifdef CONFIG_SCHED_DEBUG
+#define balancenuma_enabled sched_feat_numa(NUMA)
+#else
+extern bool balancenuma_enabled;
+#endif /* CONFIG_SCHED_DEBUG */
 #else
 #define sched_feat_numa(x) (0)
-#endif
+#define balancenuma_enabled (0)
+#endif /* CONFIG_BALANCE_NUMA */
 
 static inline u64 global_rt_period(void)
 {
-- 
1.7.9.2

