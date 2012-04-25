Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab2DYIXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 04:23:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041Ab2DYIXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 04:23:48 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/4] ftrace: Remove unused ftrace_update_time variable/code
Date: Wed, 25 Apr 2012 10:23:37 +0200
Message-Id: <1335342219-2782-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1335342219-2782-1-git-send-email-jolsa@redhat.com>
References: <1335342219-2782-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The update time of the records update is meassured but never
used. It was probably dropped along the way, removing it.

Also changing ftrace_update_cnt static variable into automatic,
since it's used only in ftrace_update_code function.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/ftrace.c |   18 ++++--------------
 1 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 6e6c51a..b3ceecd 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1920,9 +1920,7 @@ static void ftrace_shutdown_sysctl(void)
 		ftrace_run_update_code(FTRACE_DISABLE_CALLS);
 }
 
-static cycle_t		ftrace_update_time;
-static unsigned long	ftrace_update_cnt;
-unsigned long		ftrace_update_tot_cnt;
+unsigned long ftrace_update_tot_cnt;
 
 static int ops_traces_mod(struct ftrace_ops *ops)
 {
@@ -1936,8 +1934,7 @@ static int ftrace_update_code(struct module *mod)
 {
 	struct ftrace_page *pg;
 	struct dyn_ftrace *p;
-	cycle_t start, stop;
-	unsigned long ref = 0;
+	unsigned long ref = 0, cnt = 0;
 	int i;
 
 	/*
@@ -1957,9 +1954,6 @@ static int ftrace_update_code(struct module *mod)
 		}
 	}
 
-	start = ftrace_now(raw_smp_processor_id());
-	ftrace_update_cnt = 0;
-
 	for (pg = ftrace_new_pgs; pg; pg = pg->next) {
 
 		for (i = 0; i < pg->index; i++) {
@@ -1977,7 +1971,7 @@ static int ftrace_update_code(struct module *mod)
 			if (!ftrace_code_disable(mod, p))
 				break;
 
-			ftrace_update_cnt++;
+			cnt++;
 
 			/*
 			 * If the tracing is enabled, go ahead and enable the record.
@@ -1997,11 +1991,7 @@ static int ftrace_update_code(struct module *mod)
 	}
 
 	ftrace_new_pgs = NULL;
-
-	stop = ftrace_now(raw_smp_processor_id());
-	ftrace_update_time = stop - start;
-	ftrace_update_tot_cnt += ftrace_update_cnt;
-
+	ftrace_update_tot_cnt += cnt;
 	return 0;
 }
 
-- 
1.7.1

