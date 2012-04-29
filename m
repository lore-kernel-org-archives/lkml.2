Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab2D2Gpb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 02:45:31 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:61319 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab2D2Gp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 02:45:29 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: viro@zeniv.linux.org.uk, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        acme@ghostprotocols.net, james.l.morris@oracle.com,
        ebiederm@xmission.com, akpm@linux-foundation.org, tglx@linutronix.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-security-module@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH 07/14] watchdog,sysctl: remove proc input checks out of sysctl handlers
Date: Sun, 29 Apr 2012 08:45:30 +0200
Message-Id: <1335681937-3715-7-git-send-email-levinsasha928@gmail.com>
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
 include/linux/nmi.h |    3 +--
 kernel/sysctl.c     |    9 ++++++---
 kernel/watchdog.c   |   12 ++----------
 3 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index db50840..7a8030d 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -49,8 +49,7 @@ u64 hw_nmi_get_sample_period(int watchdog_thresh);
 extern int watchdog_enabled;
 extern int watchdog_thresh;
 struct ctl_table;
-extern int proc_dowatchdog(struct ctl_table *, int ,
-			   void __user *, size_t *, loff_t *);
+extern int proc_dowatchdog(void);
 #endif
 
 #endif
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index bde6087..2fac00a 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -737,7 +737,8 @@ static struct ctl_table kern_table[] = {
 		.data           = &watchdog_enabled,
 		.maxlen         = sizeof (int),
 		.mode           = 0644,
-		.proc_handler   = proc_dowatchdog,
+		.proc_handler	= proc_dointvec_minmax,
+		.callback	= proc_dowatchdog,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
@@ -746,7 +747,8 @@ static struct ctl_table kern_table[] = {
 		.data		= &watchdog_thresh,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dowatchdog,
+		.proc_handler	= proc_dointvec_minmax,
+		.callback	= proc_dowatchdog,
 		.extra1		= &neg_one,
 		.extra2		= &sixty,
 	},
@@ -764,7 +766,8 @@ static struct ctl_table kern_table[] = {
 		.data           = &watchdog_enabled,
 		.maxlen         = sizeof (int),
 		.mode           = 0644,
-		.proc_handler   = proc_dowatchdog,
+		.proc_handler	= proc_dointvec_minmax,
+		.callback	= proc_dowatchdog,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index e5e1d85..56bef16 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -535,22 +535,14 @@ static void watchdog_disable_all_cpus(void)
  * proc handler for /proc/sys/kernel/nmi_watchdog,watchdog_thresh
  */
 
-int proc_dowatchdog(struct ctl_table *table, int write,
-		    void __user *buffer, size_t *lenp, loff_t *ppos)
+int proc_dowatchdog(void)
 {
-	int ret;
-
-	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
-	if (ret || !write)
-		goto out;
-
 	if (watchdog_enabled && watchdog_thresh)
 		watchdog_enable_all_cpus();
 	else
 		watchdog_disable_all_cpus();
 
-out:
-	return ret;
+	return 0;
 }
 #endif /* CONFIG_SYSCTL */
 
-- 
1.7.8.5

