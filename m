Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab2D2Gs1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 02:48:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53699 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab2D2GpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 02:45:03 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: viro@zeniv.linux.org.uk, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        acme@ghostprotocols.net, james.l.morris@oracle.com,
        ebiederm@xmission.com, akpm@linux-foundation.org, tglx@linutronix.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-security-module@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH 03/14] sched rt,sysctl: remove proc input checks out of sysctl handlers
Date: Sun, 29 Apr 2012 08:45:26 +0200
Message-Id: <1335681937-3715-3-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <1335681937-3715-1-git-send-email-levinsasha928@gmail.com>
References: <1335681937-3715-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify sysctl handler by removing user input checks and using the callback
provided by the sysctl table.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 include/linux/sched.h |    4 +---
 kernel/sched/core.c   |   25 ++++++++++---------------
 kernel/sysctl.c       |    6 ++++--
 3 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 722da9a..9509d80 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2152,9 +2152,7 @@ static inline unsigned int get_sysctl_timer_migration(void)
 extern unsigned int sysctl_sched_rt_period;
 extern int sysctl_sched_rt_runtime;
 
-int sched_rt_handler(struct ctl_table *table, int write,
-		void __user *buffer, size_t *lenp,
-		loff_t *ppos);
+int sched_rt_handler(void);
 
 #ifdef CONFIG_SCHED_AUTOGROUP
 extern unsigned int sysctl_sched_autogroup_enabled;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 477b998..ca4a806 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7573,9 +7573,7 @@ static int sched_rt_global_constraints(void)
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
 
-int sched_rt_handler(struct ctl_table *table, int write,
-		void __user *buffer, size_t *lenp,
-		loff_t *ppos)
+int sched_rt_handler(void)
 {
 	int ret;
 	int old_period, old_runtime;
@@ -7585,19 +7583,16 @@ int sched_rt_handler(struct ctl_table *table, int write,
 	old_period = sysctl_sched_rt_period;
 	old_runtime = sysctl_sched_rt_runtime;
 
-	ret = proc_dointvec(table, write, buffer, lenp, ppos);
-
-	if (!ret && write) {
-		ret = sched_rt_global_constraints();
-		if (ret) {
-			sysctl_sched_rt_period = old_period;
-			sysctl_sched_rt_runtime = old_runtime;
-		} else {
-			def_rt_bandwidth.rt_runtime = global_rt_runtime();
-			def_rt_bandwidth.rt_period =
-				ns_to_ktime(global_rt_period());
-		}
+	ret = sched_rt_global_constraints();
+	if (ret) {
+		sysctl_sched_rt_period = old_period;
+		sysctl_sched_rt_runtime = old_runtime;
+	} else {
+		def_rt_bandwidth.rt_runtime = global_rt_runtime();
+		def_rt_bandwidth.rt_period =
+			ns_to_ktime(global_rt_period());
 	}
+
 	mutex_unlock(&mutex);
 
 	return ret;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 23f1ac6..fad9ff6 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -347,14 +347,16 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_rt_period,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= sched_rt_handler,
+		.proc_handler	= proc_dointvec,
+		.callback	= sched_rt_handler,
 	},
 	{
 		.procname	= "sched_rt_runtime_us",
 		.data		= &sysctl_sched_rt_runtime,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= sched_rt_handler,
+		.proc_handler	= proc_dointvec,
+		.callback	= sched_rt_handler,
 	},
 #ifdef CONFIG_SCHED_AUTOGROUP
 	{
-- 
1.7.8.5

