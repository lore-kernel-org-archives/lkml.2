Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501Ab2ILCSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 22:18:24 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44338 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757410Ab2ILCSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 22:18:15 -0400
X-AuditID: 9c93016f-b7bffae000003557-99-504ff0e1dfb9
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 2/2] perf sched: Fixup for the die() removal
Date: Wed, 12 Sep 2012 11:11:06 +0900
Message-Id: <1347415866-303-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347415866-303-1-git-send-email-namhyung@kernel.org>
References: <1347415866-303-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The commit a116e05dcf61 ("perf sched: Remove die() calls") replaced
die() call to pr_debug + return -1, but it should be pr_err otherwise
it'll not show up unless -v option is given.  Fix it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-sched.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index af305f57bd22..9b9e32eaa805 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -438,8 +438,8 @@ static int self_open_counters(void)
 	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
 
 	if (fd < 0)
-		pr_debug("Error: sys_perf_event_open() syscall returned"
-			 "with %d (%s)\n", fd, strerror(errno));
+		pr_err("Error: sys_perf_event_open() syscall returned "
+		       "with %d (%s)\n", fd, strerror(errno));
 	return fd;
 }
 
@@ -700,7 +700,7 @@ static int replay_switch_event(struct perf_sched *sched,
 		delta = 0;
 
 	if (delta < 0) {
-		pr_debug("hm, delta: %" PRIu64 " < 0 ?\n", delta);
+		pr_err("hm, delta: %" PRIu64 " < 0 ?\n", delta);
 		return -1;
 	}
 
@@ -990,7 +990,7 @@ static int latency_runtime_event(struct perf_sched *sched,
 			return -1;
 		atoms = thread_atoms_search(&sched->atom_root, thread, &sched->cmp_pid);
 		if (!atoms) {
-			pr_debug("in-event: Internal tree error");
+			pr_err("in-event: Internal tree error");
 			return -1;
 		}
 		if (add_sched_out_event(atoms, 'R', timestamp))
@@ -1024,7 +1024,7 @@ static int latency_wakeup_event(struct perf_sched *sched,
 			return -1;
 		atoms = thread_atoms_search(&sched->atom_root, wakee, &sched->cmp_pid);
 		if (!atoms) {
-			pr_debug("wakeup-event: Internal tree error");
+			pr_err("wakeup-event: Internal tree error");
 			return -1;
 		}
 		if (add_sched_out_event(atoms, 'S', timestamp))
@@ -1079,7 +1079,7 @@ static int latency_migrate_task_event(struct perf_sched *sched,
 		register_pid(sched, migrant->pid, migrant->comm);
 		atoms = thread_atoms_search(&sched->atom_root, migrant, &sched->cmp_pid);
 		if (!atoms) {
-			pr_debug("migration-event: Internal tree error");
+			pr_err("migration-event: Internal tree error");
 			return -1;
 		}
 		if (add_sched_out_event(atoms, 'R', timestamp))
@@ -1286,7 +1286,7 @@ static int map_switch_event(struct perf_sched *sched, struct perf_evsel *evsel,
 		delta = 0;
 
 	if (delta < 0) {
-		pr_debug("hm, delta: %" PRIu64 " < 0 ?\n", delta);
+		pr_err("hm, delta: %" PRIu64 " < 0 ?\n", delta);
 		return -1;
 	}
 
-- 
1.7.11.4

