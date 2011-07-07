Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab1GGFep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 01:34:45 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49151 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab1GGFdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 01:33:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=Q4l3PkTQEmeeZUzOSBvK1IKU3b5W+U/sOIbZZW/WQR2cdL3cJvNDPvqejVcrgUJkx
	+DxI2K+uIYk/Ux+FNXk1Q==
Message-Id: <20110707053100.919183671@google.com>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jul 2011 22:30:49 -0700
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Hu Tao <hutao@cn.fujitsu.com>
Subject: [patch 13/17] sched: migrate throttled tasks on HOTPLUG
References: <20110707053036.173186930@google.com>
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
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

---
 kernel/sched.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -6269,6 +6269,30 @@ static void calc_global_load_remove(stru
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
@@ -6294,6 +6318,9 @@ static void migrate_tasks(unsigned int d
 	 */
 	rq->stop = NULL;
 
+	/* Ensure any throttled groups are reachable by pick_next_task */
+	unthrottle_offline_cfs_rqs(rq);
+
 	for ( ; ; ) {
 		/*
 		 * There's this thread running, bail when that's the only


