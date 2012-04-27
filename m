Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280Ab2D0Hlb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 03:41:31 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:40054 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953Ab2D0Hl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 03:41:29 -0400
Message-ID: <4F9A4DA0.7070608@linux.vnet.ibm.com>
Date: Fri, 27 Apr 2012 15:41:20 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Paul Turner <pjt@google.com>, Dhaval Giani <dhaval.giani@gmail.com>
Subject: [PATCH 1/2] linsched: add the functions for setting scheduler proc
 parameters
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12042707-8878-0000-0000-000002326E73
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

This patch add the functions for setting scheduler proc parameters.
Currently support:
	sysctl_sched_child_runs_first;
	sysctl_sched_min_granularity;
	sysctl_sched_latency;
	sysctl_sched_wakeup_granularity;

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 arch/linsched/kernel/misc.c     |    3 --
 tools/linsched/Makefile.inc     |    3 +-
 tools/linsched/linsched_proc.c  |   46 +++++++++++++++++++++++++++++++++++++++
 tools/linsched/linsched_proc.h  |    6 +++++
 tools/linsched/linux_linsched.c |    1 +
 5 files changed, 55 insertions(+), 4 deletions(-)
 create mode 100644 tools/linsched/linsched_proc.c
 create mode 100644 tools/linsched/linsched_proc.h

diff --git a/arch/linsched/kernel/misc.c b/arch/linsched/kernel/misc.c
index abb1cb4..a76d397 100644
--- a/arch/linsched/kernel/misc.c
+++ b/arch/linsched/kernel/misc.c
@@ -334,8 +334,5 @@ int proc_dointvec(struct ctl_table *table, int write,
 int proc_dointvec_minmax(struct ctl_table *table, int write,
 		    void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-	/* should be unused */
-	BUG();
-
 	return 0;
 }
diff --git a/tools/linsched/Makefile.inc b/tools/linsched/Makefile.inc
index 441f7e3..15a344b 100644
--- a/tools/linsched/Makefile.inc
+++ b/tools/linsched/Makefile.inc
@@ -25,7 +25,8 @@ LINSCHED_OBJS = ${LINSCHED_DIR}/linux_linsched.o \
 		${LINSCHED_DIR}/nohz_tracking.o \
 		${LINSCHED_DIR}/linsched_rand.o \
 		${LINSCHED_DIR}/linsched_sim.o \
-		${LINSCHED_DIR}/stubs/sched.o
+		${LINSCHED_DIR}/stubs/sched.o \
+		${LINSCHED_DIR}/linsched_proc.o
 
 LINUX_OBJS =	${LINUXDIR}/kernel/notifier.o \
 		${LINUXDIR}/kernel/timer.o \
diff --git a/tools/linsched/linsched_proc.c b/tools/linsched/linsched_proc.c
new file mode 100644
index 0000000..7731da6
--- /dev/null
+++ b/tools/linsched/linsched_proc.c
@@ -0,0 +1,46 @@
+#include "linsched_proc.h"
+#include "linsched.h"
+
+int min_sched_granularity_ns = 100000;           /* 100 usecs */
+int max_sched_granularity_ns = NSEC_PER_SEC;     /* 1 second */
+
+enum {
+	MIN_GRANULARITY,
+	LATENCY,
+	WAKEUP_GRANULARITY
+};
+
+void linsched_sched_proc_update_handler(int key, unsigned long value)
+{
+	if (value < min_sched_granularity_ns || value > max_sched_granularity_ns)
+		return;
+
+	switch (key) {
+		case MIN_GRANULARITY:
+			sysctl_sched_min_granularity = value;
+			break;
+		case LATENCY:
+			sysctl_sched_latency = value;
+			break;
+		case WAKEUP_GRANULARITY:
+			sysctl_sched_wakeup_granularity = value;
+			break;
+		default:
+			break;
+	}
+        sched_proc_update_handler(NULL,1,NULL,NULL,NULL);
+}
+
+void set_linsched_proc(char *procname, unsigned long value)
+{
+	if (!strcmp(procname, "sched_child_runs_first")) {
+		sysctl_sched_child_runs_first = value;
+	} else if (!strcmp(procname, "sched_min_granularity_ns")) {
+		linsched_sched_proc_update_handler(MIN_GRANULARITY, value);	
+	} else if (!strcmp(procname, "sched_latency_ns")) {
+		linsched_sched_proc_update_handler(LATENCY, value);	
+	} else if (!strcmp(procname, "sched_wakeup_granularity_ns")) {
+		linsched_sched_proc_update_handler(WAKEUP_GRANULARITY, value);	
+	}
+}
+
diff --git a/tools/linsched/linsched_proc.h b/tools/linsched/linsched_proc.h
new file mode 100644
index 0000000..4c27297
--- /dev/null
+++ b/tools/linsched/linsched_proc.h
@@ -0,0 +1,6 @@
+#ifndef LINSCHED_PROC_H
+#define LINSCHED_PROC_H
+
+void set_linsched_proc(char *procname, unsigned long value);
+
+#endif
diff --git a/tools/linsched/linux_linsched.c b/tools/linsched/linux_linsched.c
index ca07a73..6c24578 100644
--- a/tools/linsched/linux_linsched.c
+++ b/tools/linsched/linux_linsched.c
@@ -41,6 +41,7 @@
 
 #include "linsched_rand.h"
 #include "load_balance_score.h"
+#include "linsched_proc.h"
 
 /* linsched variables and functions */
 
-- 
1.7.1

