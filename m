Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372Ab1GYO6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 10:58:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:49758 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab1GYO6a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 10:58:30 -0400
Subject: Re: [patch 00/18] CFS Bandwidth Control v7.2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Jason Baron <jbaron@redhat.com>
In-Reply-To: <20110721164325.231521704@google.com>
References: <20110721164325.231521704@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 25 Jul 2011 16:58:01 +0200
Message-ID: <1311605881.24752.2.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How about something like the below on top?


---
 kernel/sched.c |   33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -9228,9 +9228,19 @@ long tg_get_cfs_quota(struct task_group 
 	return quota_us;
 }
 
+int tg_set_cfs_period_down(struct task_group *tg, void *data)
+{
+	u64 period = *(u64 *)data;
+	if (ktime_to_ns(tg->cfs_bandwidth.period) == period)
+		return 0;
+
+	return tg_set_cfs_bandwidth(tg, period, tg->cfs_bandwidth.quota);
+}
+
 int tg_set_cfs_period(struct task_group *tg, long cfs_period_us)
 {
 	u64 quota, period;
+	int ret;
 
 	period = (u64)cfs_period_us * NSEC_PER_USEC;
 	quota = tg_cfs_bandwidth(tg)->quota;
@@ -9238,7 +9248,28 @@ int tg_set_cfs_period(struct task_group 
 	if (period <= 0)
 		return -EINVAL;
 
-	return tg_set_cfs_bandwidth(tg, period, quota);
+	/*
+	 * If the parent is bandwidth constrained all its children will
+	 * have to have the same period.
+	 */
+	if (tg->parent && tg->parent->cfs_bandwidth.quota != RUNTIME_INF)
+		return -EINVAL;
+
+	ret = tg_set_cfs_bandwidth(tg, period, quota);
+	if (!ret) {
+		rcu_read_lock();
+		ret = walk_tg_tree_from(tg, tg_set_cfs_period_down, NULL, &period);
+		rcu_read_unlock();
+
+		/*
+		 * If we could change the period on the parent we should be
+		 * able to change the period on all its children since their
+		 * quote is constrained to be equal or less than our.
+		 */
+		WARN_ON_ONCE(ret);
+	}
+
+	return ret;
 }
 
 long tg_get_cfs_period(struct task_group *tg)

