Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab1I0WbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 18:31:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159Ab1I0Wa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 18:30:59 -0400
From: Doug Ledford <dledford@redhat.com>
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, joe.korty@ccur.com, amwang@redhat.com,
        Doug Ledford <dledford@redhat.com>
Subject: [PATCH 1/4] ipc/mqueue: cleanup definition names and locations
Date: Tue, 27 Sep 2011 18:30:10 -0400
Message-Id: <1317162613-11060-2-git-send-email-dledford@redhat.com>
In-Reply-To: <1317162613-11060-1-git-send-email-dledford@redhat.com>
References: <1317162613-11060-1-git-send-email-dledford@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The various defines for minimums and maximums of the sysctl controllable
mqueue values are scattered amongst different files and named
inconsistently.  Move them all into ipc_namespace.h and make them have
consistent names.  Additionally, make the number of queues per namespace
also have a minimum and maximum and use the same sysctl function as the
other two settable variables.

Signed-off-by: Doug Ledford <dledford@redhat.com>
---
 include/linux/ipc_namespace.h |    5 +++++
 ipc/mq_sysctl.c               |   31 ++++++++-----------------------
 2 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index 8a297a5..1372b56 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -91,10 +91,15 @@ static inline void shm_destroy_orphaned(struct ipc_namespace *ns) {}
 #ifdef CONFIG_POSIX_MQUEUE
 extern int mq_init_ns(struct ipc_namespace *ns);
 /* default values */
+#define MIN_QUEUESMAX  1
 #define DFLT_QUEUESMAX 256     /* max number of message queues */
+#define HARD_QUEUESMAX 1024
+#define MIN_MSGMAX     1
 #define DFLT_MSGMAX    10      /* max number of messages in each queue */
 #define HARD_MSGMAX    (32768*sizeof(void *)/4)
+#define MIN_MSGSIZEMAX  128
 #define DFLT_MSGSIZEMAX 8192   /* max message size */
+#define HARD_MSGSIZEMAX (8192*128)
 #else
 static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
 #endif
diff --git a/ipc/mq_sysctl.c b/ipc/mq_sysctl.c
index 0c09366..e22336a 100644
--- a/ipc/mq_sysctl.c
+++ b/ipc/mq_sysctl.c
@@ -13,15 +13,6 @@
 #include <linux/ipc_namespace.h>
 #include <linux/sysctl.h>
 
-/*
- * Define the ranges various user-specified maximum values can
- * be set to.
- */
-#define MIN_MSGMAX	1		/* min value for msg_max */
-#define MAX_MSGMAX	HARD_MSGMAX	/* max value for msg_max */
-#define MIN_MSGSIZEMAX	128		/* min value for msgsize_max */
-#define MAX_MSGSIZEMAX	(8192*128)	/* max value for msgsize_max */
-
 #ifdef CONFIG_PROC_SYSCTL
 static void *get_mq(ctl_table *table)
 {
@@ -31,16 +22,6 @@ static void *get_mq(ctl_table *table)
 	return which;
 }
 
-static int proc_mq_dointvec(ctl_table *table, int write,
-	void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	struct ctl_table mq_table;
-	memcpy(&mq_table, table, sizeof(mq_table));
-	mq_table.data = get_mq(table);
-
-	return proc_dointvec(&mq_table, write, buffer, lenp, ppos);
-}
-
 static int proc_mq_dointvec_minmax(ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -52,15 +33,17 @@ static int proc_mq_dointvec_minmax(ctl_table *table, int write,
 					lenp, ppos);
 }
 #else
-#define proc_mq_dointvec NULL
 #define proc_mq_dointvec_minmax NULL
 #endif
 
+static int msg_queues_limit_min = MIN_QUEUESMAX;
+static int msg_queues_limit_max = HARD_QUEUESMAX;
+
 static int msg_max_limit_min = MIN_MSGMAX;
-static int msg_max_limit_max = MAX_MSGMAX;
+static int msg_max_limit_max = HARD_MSGMAX;
 
 static int msg_maxsize_limit_min = MIN_MSGSIZEMAX;
-static int msg_maxsize_limit_max = MAX_MSGSIZEMAX;
+static int msg_maxsize_limit_max = HARD_MSGSIZEMAX;
 
 static ctl_table mq_sysctls[] = {
 	{
@@ -68,7 +51,9 @@ static ctl_table mq_sysctls[] = {
 		.data		= &init_ipc_ns.mq_queues_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_mq_dointvec,
+		.proc_handler	= proc_mq_dointvec_minmax,
+		.extra1		= &msg_queues_limit_min,
+		.extra2		= &msg_queues_limit_max,
 	},
 	{
 		.procname	= "msg_max",
-- 
1.7.6

