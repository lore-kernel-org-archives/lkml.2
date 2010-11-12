Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab0KLDcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 22:32:31 -0500
Received: from smtp-out.google.com ([216.239.44.51]:3794 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab0KLDca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 22:32:30 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
	b=abA9IDsg9UOJbI5NflIDH6HlQfSSfsCqSr3Kw9tcTouTAphHL+Tr270Uu467Iui67
	DNLgSmtcn2vYWo3ZmBJNw==
Message-Id: <20101112032701.869302582@google.com>
References: <20101112032405.657789056@google.com>
User-Agent: quilt/0.46-1
Date: Thu, 11 Nov 2010 19:24:12 -0800
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
Subject: [tg_shares_up rewrite v3 07/11] sched: add sysctl_sched_shares_window
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

