Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab2EUPqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:46:20 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:35522 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267Ab2EUPqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:46:17 -0400
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 1/2] sched: readd FAIR_SLEEPERS feature
Date: Mon, 21 May 2012 17:45:36 +0200
Message-Id: <1337615137-55111-2-git-send-email-schwidefsky@de.ibm.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1337615137-55111-1-git-send-email-schwidefsky@de.ibm.com>
References: <1337615137-55111-1-git-send-email-schwidefsky@de.ibm.com>
x-cbid: 12052115-0542-0000-0000-000001EC61A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

git commit 5ca9880c6f4ba4c8 "sched: Remove FAIR_SLEEPERS features" removed
the ability to disable sleeper fairness. The benefit is a saved branch
on desktop systems where preemption is important and fair sleepers are
always enabled. But the control is important for server systems where
disabling sleeper fairness has a performance benefit.

Readd the fair sleepers control but add a compile time option to be able to
disable the control again. The default is no control, if an architecture
wants to have the control CONFIG_SCHED_FAIR_SLEEPERS needs to be selected.

Reported-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 init/Kconfig            |    3 +++
 kernel/sched/fair.c     |   14 +++++++++++++-
 kernel/sched/features.h |    9 +++++++++
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index 6cfd71d..ddfd2c2 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -865,6 +865,9 @@ config SCHED_AUTOGROUP
 	  desktop applications.  Task group autogeneration is currently based
 	  upon task session.
 
+config SCHED_FAIR_SLEEPERS
+	bool
+
 config MM_OWNER
 	bool
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e955364..a791a9d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1046,6 +1046,18 @@ static void check_spread(struct cfs_rq *cfs_rq, struct sched_entity *se)
 #endif
 }
 
+#ifdef CONFIG_SCHED_FAIR_SLEEPERS
+static inline is_fair_sleeper(int initial)
+{
+	return !initial && sched_feat(FAIR_SLEEPERS);
+}
+#else /* CONFIG_SCHED_FAIR_SLEEPERS */
+static inline is_fair_sleeper(int initial)
+{
+	return !initial;
+}
+#endif /* CONFIG_SCHED_FAIR_SLEEPERS */
+
 static void
 place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 {
@@ -1061,7 +1073,7 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 		vruntime += sched_vslice(cfs_rq, se);
 
 	/* sleeps up to a single latency don't count. */
-	if (!initial) {
+	if (is_fair_sleeper(initial)) {
 		unsigned long thresh = sysctl_sched_latency;
 
 		/*
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index de00a48..e72dc7a 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -1,3 +1,12 @@
+#ifdef CONFIG_SCHED_FAIR_SLEEPERS
+/*
+ * Disregards a certain amount of sleep time (sched_latency_ns) and
+ * considers the task to be running during that period. This gives it
+ * a service deficit on wakeup, allowing it to run sooner.
+ */
+SCHED_FEAT(FAIR_SLEEPERS, false)
+#endif
+
 /*
  * Only give sleepers 50% of their service deficit. This allows
  * them to run sooner, but does not allow tons of sleepers to
-- 
1.7.10.2

