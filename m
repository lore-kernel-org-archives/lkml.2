Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab1CWDKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 23:10:39 -0400
Received: from smtp-out.google.com ([74.125.121.67]:56672 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab1CWDKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 23:10:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=IOmooQ9GR10An6VvZr4akd6F8QD0gJkuZovhhhQeBuAbmbtkExC/kjzpJsCwY0n4R
	RfzImn7IiQD3Rk09vw7Lw==
Message-Id: <20110323030449.434436052@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 22 Mar 2011 20:03:34 -0700
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: [patch 08/15] sched: migrate throttled tasks on HOTPLUG
References: <20110323030326.789836913@google.com>
Content-Disposition: inline; filename=sched-bwc-migrate_dead.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Throttled tasks are invisisble to cpu-offline since they are not eligible for
selection by pick_next_task().  The regular 'escape' path for a thread that is
blocked at offline is via ttwu->select_task_rq, however this will not handle a
throttled group since there are no individual thread wakeups on an unthrottle.

Resolve this by unthrottling offline cpus so that threads can be migrated.

Signed-off-by: Paul Turner <pjt@google.com>
---
 kernel/sched.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -6119,6 +6119,30 @@ static void calc_global_load_remove(stru
 	rq->calc_load_active = 0;
 }
 
+#ifdef CONFIG_CFS_BANDWIDTH
+static void unthrottle_offline_cfs_rqs(struct rq *rq)
+{
+	struct cfs_rq *cfs_rq;
+
+	for_each_leaf_cfs_rq(rq, cfs_rq) {
+		if (!cfs_rq->quota_enabled)
+			continue;
+
+		/*
+		 * clock_task is not advancing so we just need to make sure
+		 * there's some valid quota amount
+		 */
+		cfs_rq->quota_remaining = tg_cfs_bandwidth(cfs_rq->tg)->quota;
+		if (cfs_rq_throttled(cfs_rq))
+			unthrottle_cfs_rq(cfs_rq);
+	}
+}
+#else
+static void unthrottle_offline_cfs_rqs(struct rq *rq)
+{
+}
+#endif
+
 /*
  * Migrate all tasks from the rq, sleeping tasks will be migrated by
  * try_to_wake_up()->select_task_rq().
@@ -6144,6 +6168,9 @@ static void migrate_tasks(unsigned int d
 	 */
 	rq->stop = NULL;
 
+	/* Ensure any throttled groups are reachable by pick_next_task */
+	unthrottle_offline_cfs_rqs(rq);
+
 	for ( ; ; ) {
 		/*
 		 * There's this thread running, bail when that's the only


