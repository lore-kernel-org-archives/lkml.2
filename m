Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283Ab0KROMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:12:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:52138 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022Ab0KROMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:12:50 -0500
Date: Thu, 18 Nov 2010 14:12:18 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20101115234938.112173964@google.com>
References: <20101115234938.112173964@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Add sysctl_sched_shares_window
Message-ID: <tip-a7a4f8a752ec734b2eab904fc863d5dc873de338@git.kernel.org>
Git-Commit-ID: a7a4f8a752ec734b2eab904fc863d5dc873de338
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 14:12:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a7a4f8a752ec734b2eab904fc863d5dc873de338
Gitweb:     http://git.kernel.org/tip/a7a4f8a752ec734b2eab904fc863d5dc873de338
Author:     Paul Turner <pjt@google.com>
AuthorDate: Mon, 15 Nov 2010 15:47:06 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Nov 2010 13:27:49 +0100

sched: Add sysctl_sched_shares_window

Introduce a new sysctl for the shares window and disambiguate it from
sched_time_avg.

A 10ms window appears to be a good compromise between accuracy and performance.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20101115234938.112173964@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    1 +
 kernel/sched_fair.c   |    9 ++++++++-
 kernel/sysctl.c       |    7 +++++++
 3 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8abb8aa..840f127 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1900,6 +1900,7 @@ extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
 extern unsigned int sysctl_sched_time_avg;
 extern unsigned int sysctl_timer_migration;
+extern unsigned int sysctl_sched_shares_window;
 
 int sched_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *length,
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index b320753..6c84439 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -89,6 +89,13 @@ unsigned int normalized_sysctl_sched_wakeup_granularity = 1000000UL;
 
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
@@ -688,7 +695,7 @@ account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 #if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
 static void update_cfs_load(struct cfs_rq *cfs_rq)
 {
-	u64 period = sched_avg_period();
+	u64 period = sysctl_sched_shares_window;
 	u64 now, delta;
 	unsigned long load = cfs_rq->load.weight;
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 3132b25..9b520d7 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
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
