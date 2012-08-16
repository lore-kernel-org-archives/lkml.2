Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab2HPIKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 04:10:43 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:63392 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129Ab2HPIK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 04:10:26 -0400
X-AuditID: 9c93016f-b7cc0ae000000e9f-ce-502caaee56a4
From: Namhyung Kim <namhyung@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH] sched/debug: Limit sd->*_idx range on sysctl
Date: Thu, 16 Aug 2012 17:03:24 +0900
Message-Id: <1345104204-8317-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.2
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Various sd->*_idx's are used for refering the rq's load average table
when selecting a cpu to run.  However they can be set to any number
with sysctl knobs so that it can crash the kernel if something bad is
given. Fix it by limiting them into the actual range.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
I'm not sure it needs to go to stable also.

 kernel/sched/core.c | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4376c9f34790..e71523eec3e4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5463,16 +5463,25 @@ static void sd_free_ctl_entry(struct ctl_table **tablep)
 	*tablep = NULL;
 }
 
+static const int min_load_idx = 0;
+static const int max_load_idx = CPU_LOAD_IDX_MAX;
+
 static void
 set_table_entry(struct ctl_table *entry,
 		const char *procname, void *data, int maxlen,
-		umode_t mode, proc_handler *proc_handler)
+		umode_t mode, proc_handler *proc_handler,
+		bool load_idx)
 {
 	entry->procname = procname;
 	entry->data = data;
 	entry->maxlen = maxlen;
 	entry->mode = mode;
 	entry->proc_handler = proc_handler;
+
+	if (load_idx) {
+		entry->extra1 = &min_load_idx;
+		entry->extra2 = &max_load_idx;
+	}
 }
 
 static struct ctl_table *
@@ -5484,30 +5493,30 @@ sd_alloc_ctl_domain_table(struct sched_domain *sd)
 		return NULL;
 
 	set_table_entry(&table[0], "min_interval", &sd->min_interval,
-		sizeof(long), 0644, proc_doulongvec_minmax);
+		sizeof(long), 0644, proc_doulongvec_minmax, false);
 	set_table_entry(&table[1], "max_interval", &sd->max_interval,
-		sizeof(long), 0644, proc_doulongvec_minmax);
+		sizeof(long), 0644, proc_doulongvec_minmax, false);
 	set_table_entry(&table[2], "busy_idx", &sd->busy_idx,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, true);
 	set_table_entry(&table[3], "idle_idx", &sd->idle_idx,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, true);
 	set_table_entry(&table[4], "newidle_idx", &sd->newidle_idx,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, true);
 	set_table_entry(&table[5], "wake_idx", &sd->wake_idx,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, true);
 	set_table_entry(&table[6], "forkexec_idx", &sd->forkexec_idx,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, true);
 	set_table_entry(&table[7], "busy_factor", &sd->busy_factor,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, false);
 	set_table_entry(&table[8], "imbalance_pct", &sd->imbalance_pct,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, false);
 	set_table_entry(&table[9], "cache_nice_tries",
 		&sd->cache_nice_tries,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, false);
 	set_table_entry(&table[10], "flags", &sd->flags,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, false);
 	set_table_entry(&table[11], "name", sd->name,
-		CORENAME_MAX_SIZE, 0444, proc_dostring);
+		CORENAME_MAX_SIZE, 0444, proc_dostring, false);
 	/* &table[12] is terminator */
 
 	return table;
-- 
1.7.11.2

