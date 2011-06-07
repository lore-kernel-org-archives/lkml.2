Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab1FGOpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:45:53 -0400
Received: from smtp-out.google.com ([74.125.121.67]:10236 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab1FGOpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:45:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=qpr0BPjluMkSachHPNbjPmLQL4nRBwZmb/1Da57aGkGQt3Able5/ZzwaNPLyGXsGdx
         5z/fsS6wosOVgG+vSZIw==
Date: Tue, 7 Jun 2011 16:45:29 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, acme@redhat.com
Subject: [PATCH] perf: bug fixes and cleanups for perf sched
Message-ID: <20110607144528.GA7342@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


perf sched latency was printing garbage because it was using
stale pointers from a deleted session structure. This patches
fixes the problem.

The patch also cleans up the data structure definitions for all
the arrays used to store the processor name (comm).

Finally, the patch updates the man page and help text to reflect
the actual options of the command. perf sched trace does not
exist anymore, AFAICT. Without this change, users get an error
when invoking perf sched trace but they have no idea why.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/Documentation/perf-sched.txt b/tools/perf/Documentation/perf-sched.txt
index 46822d5..ad764cc 100644
--- a/tools/perf/Documentation/perf-sched.txt
+++ b/tools/perf/Documentation/perf-sched.txt
@@ -8,7 +8,7 @@ perf-sched - Tool to trace/measure scheduler properties (latencies)
 SYNOPSIS
 --------
 [verse]
-'perf sched' {record|latency|map|replay|trace}
+'perf sched' {record|latency|map|replay|script}
 
 DESCRIPTION
 -----------
@@ -20,7 +20,7 @@ There are five variants of perf sched:
   'perf sched latency' to report the per task scheduling latencies
   and other scheduling properties of the workload.
 
-  'perf sched trace' to see a detailed trace of the workload that
+  'perf sched script' to see a detailed trace of the workload that
   was recorded.
 
   'perf sched replay' to simulate the workload that was recorded
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index dcfe887..d5a9d9e 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -649,11 +649,11 @@ struct trace_switch_event {
 	u32 common_pid;
 	u32 common_tgid;
 
-	char prev_comm[16];
+	char prev_comm[COMM_LEN];
 	u32 prev_pid;
 	u32 prev_prio;
 	u64 prev_state;
-	char next_comm[16];
+	char next_comm[COMM_LEN];
 	u32 next_pid;
 	u32 next_prio;
 };
@@ -667,7 +667,7 @@ struct trace_runtime_event {
 	u32 common_pid;
 	u32 common_tgid;
 
-	char comm[16];
+	char comm[COMM_LEN];
 	u32 pid;
 	u64 runtime;
 	u64 vruntime;
@@ -682,7 +682,7 @@ struct trace_wakeup_event {
 	u32 common_pid;
 	u32 common_tgid;
 
-	char comm[16];
+	char comm[COMM_LEN];
 	u32 pid;
 
 	u32 prio;
@@ -699,9 +699,9 @@ struct trace_fork_event {
 	u32 common_pid;
 	u32 common_tgid;
 
-	char parent_comm[16];
+	char parent_comm[COMM_LEN];
 	u32 parent_pid;
-	char child_comm[16];
+	char child_comm[COMM_LEN];
 	u32 child_pid;
 };
 
@@ -714,7 +714,7 @@ struct trace_migrate_task_event {
 	u32 common_pid;
 	u32 common_tgid;
 
-	char comm[16];
+	char comm[COMM_LEN];
 	u32 pid;
 
 	u32 prio;
@@ -1651,8 +1651,12 @@ static int read_events(void)
 		nr_lost_events = session->hists.stats.total_lost;
 		nr_lost_chunks = session->hists.stats.nr_events[PERF_RECORD_LOST];
 	}
-
-	perf_session__delete(session);
+	/*
+	 * cannot delete session because cmd_lat() is relying on work_atoms
+	 * which point to fields (e.g., thread) which are part of the session.
+	 *
+	 * perf_session__delete(session);
+	 */
 	return err;
 }
 
@@ -1769,7 +1773,7 @@ static void __cmd_replay(void)
 
 
 static const char * const sched_usage[] = {
-	"perf sched [<options>] {record|latency|map|replay|trace}",
+	"perf sched [<options>] {record|latency|map|replay|script}",
 	NULL
 };
 
