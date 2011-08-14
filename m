Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab1HNQeU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:34:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:43848 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574Ab1HNQeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:34:19 -0400
Date: Sun, 14 Aug 2011 16:34:01 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Message-ID: <tip-8cb120d3e41a0464a559d639d519cef563717a4e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, seto.hidetoshi@jp.fujitsu.com, pjt@google.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110721184757.989000590@google.com>
References: <20110721184757.989000590@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Migrate throttled tasks on HOTPLUG
Git-Commit-ID: 8cb120d3e41a0464a559d639d519cef563717a4e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 16:34:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8cb120d3e41a0464a559d639d519cef563717a4e
Gitweb:     http://git.kernel.org/tip/8cb120d3e41a0464a559d639d519cef563717a4e
Author:     Paul Turner <pjt@google.com>
AuthorDate: Thu, 21 Jul 2011 09:43:38 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 12:03:44 +0200

sched: Migrate throttled tasks on HOTPLUG

Throttled tasks are invisisble to cpu-offline since they are not eligible for
selection by pick_next_task().  The regular 'escape' path for a thread that is
blocked at offline is via ttwu->select_task_rq, however this will not handle a
throttled group since there are no individual thread wakeups on an unthrottle.

Resolve this by unthrottling offline cpus so that threads can be migrated.

Signed-off-by: Paul Turner <pjt@google.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110721184757.989000590@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 5db05f6..3973172 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6335,6 +6335,30 @@ static void calc_global_load_remove(struct rq *rq)
 	rq->calc_load_active = 0;
 }
 
+#ifdef CONFIG_CFS_BANDWIDTH
+static void unthrottle_offline_cfs_rqs(struct rq *rq)
+{
+	struct cfs_rq *cfs_rq;
+
+	for_each_leaf_cfs_rq(rq, cfs_rq) {
+		struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
+
+		if (!cfs_rq->runtime_enabled)
+			continue;
+
+		/*
+		 * clock_task is not advancing so we just need to make sure
+		 * there's some valid quota amount
+		 */
+		cfs_rq->runtime_remaining = cfs_b->quota;
+		if (cfs_rq_throttled(cfs_rq))
+			unthrottle_cfs_rq(cfs_rq);
+	}
+}
+#else
+static void unthrottle_offline_cfs_rqs(struct rq *rq) {}
+#endif
+
 /*
  * Migrate all tasks from the rq, sleeping tasks will be migrated by
  * try_to_wake_up()->select_task_rq().
@@ -6360,6 +6384,9 @@ static void migrate_tasks(unsigned int dead_cpu)
 	 */
 	rq->stop = NULL;
 
+	/* Ensure any throttled groups are reachable by pick_next_task */
+	unthrottle_offline_cfs_rqs(rq);
+
 	for ( ; ; ) {
 		/*
 		 * There's this thread running, bail when that's the only
