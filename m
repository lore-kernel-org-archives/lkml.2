Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933873Ab0KOXww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 18:52:52 -0500
Received: from smtp-out.google.com ([216.239.44.51]:37183 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933677Ab0KOXwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 18:52:49 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=dY4JEYxTvQp3Q/1qMLKP/2g9Z+yDXFnaQWRBeqr9cuycH2mLR9O9gl7f5phQu2py3
	gFWVgadWjRPiEX4qWaDkA==
Message-Id: <20101115234938.112173964@google.com>
User-Agent: quilt/0.48-1
Date: Mon, 15 Nov 2010 15:47:06 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>, Paul Turner <pjt@google.com>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Karl Rister <kmr@us.ibm.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>
Subject: [tg_shares_up rewrite v4 07/11] sched: add sysctl_sched_shares_window
References: <20101115234659.610333554@google.com>
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

Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
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
 
Index: tip/include/linux/sched.h
===================================================================
--- tip.orig/include/linux/sched.h
+++ tip/include/linux/sched.h
@@ -1904,6 +1904,7 @@ extern unsigned int sysctl_sched_migrati
 extern unsigned int sysctl_sched_nr_migrate;
 extern unsigned int sysctl_sched_time_avg;
 extern unsigned int sysctl_timer_migration;
+extern unsigned int sysctl_sched_shares_window;
 
 int sched_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *length,
Index: tip/kernel/sysctl.c
===================================================================
--- tip.orig/kernel/sysctl.c
+++ tip/kernel/sysctl.c
@@ -333,6 +333,13 @@ static struct ctl_table kern_table[] = {
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


