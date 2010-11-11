Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab0KKDzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 22:55:19 -0500
Received: from smtp-out.google.com ([74.125.121.35]:43836 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab0KKDzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 22:55:14 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
	b=wjUiHWTFO4E0SE6LSGArQYsQcR4MJcSH+xnNgsASJR9Za45/9hqQ5fqwJKfb8X9aC
	9V/Lps4cSg/z0kSsRcVVA==
Message-Id: <20101111035050.920197940@google.com>
References: <20101111035005.443640006@google.com>
User-Agent: quilt/0.46-1
Date: Wed, 10 Nov 2010 19:50:12 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>, Paul Turner <pjt@google.com>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Karl Rister <kmr@us.ibm.com>, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [tg_shares_up rewrite v2 07/11] sched: add sysctl_sched_shares_window
Content-Disposition: inline; filename=sched-tg-add-shares_window_sysctl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new sysctl for the shares window and disambiguate it from
sched_time_avg.

A 10ms window appears to be a good compromise between accuracy and performance.

Signed-off-by: Paul Turner <pjt@google.com>

---
 include/linux/sched.h |    1 +
 kernel/sched_fair.c   |    9 ++++++++-
 kernel/sysctl.c       |    7 +++++++
 3 files changed, 16 insertions(+), 1 deletion(-)

Index: kernel/sched_fair.c
===================================================================
--- kernel/sched_fair.c.orig
+++ kernel/sched_fair.c
@@ -89,6 +89,13 @@ unsigned int normalized_sysctl_sched_wak
 
 const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
 
+/*
+ * The exponential sliding  window over which load is averaged for shares
+ * distribution.
+ * (default: 10msec)
+ */
+unsigned int __read_mostly sysctl_sched_shares_window = 10000000UL;
+
 static const struct sched_class fair_sched_class;
 
 /**************************************************************
@@ -688,7 +695,7 @@ account_entity_dequeue(struct cfs_rq *cf
 #if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
 static void update_cfs_load(struct cfs_rq *cfs_rq)
 {
-	u64 period = sched_avg_period();
+	u64 period = sysctl_sched_shares_window;
 	u64 now, delta;
 	unsigned long load = cfs_rq->load.weight;
 
Index: include/linux/sched.h
===================================================================
--- include/linux/sched.h.orig
+++ include/linux/sched.h
@@ -1883,6 +1883,7 @@ extern unsigned int sysctl_sched_migrati
 extern unsigned int sysctl_sched_nr_migrate;
 extern unsigned int sysctl_sched_time_avg;
 extern unsigned int sysctl_timer_migration;
+extern unsigned int sysctl_sched_shares_window;
 
 int sched_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *length,
Index: kernel/sysctl.c
===================================================================
--- kernel/sysctl.c.orig
+++ kernel/sysctl.c
@@ -337,6 +337,13 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
+		.procname	= "sched_shares_window",
+		.data		= &sysctl_sched_shares_window,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
 		.procname	= "timer_migration",
 		.data		= &sysctl_timer_migration,
 		.maxlen		= sizeof(unsigned int),

-- 

