Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab2ISPMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:12:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52620 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab2ISPMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:12:34 -0400
Date: Wed, 19 Sep 2012 08:12:13 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-60b7d14af46ef07778e89556429ec9ab5a7fad0b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1347415866-303-2-git-send-email-namhyung@kernel.org>
References: <1347415866-303-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sched: Fixup for the die() removal
Git-Commit-ID: 60b7d14af46ef07778e89556429ec9ab5a7fad0b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 19 Sep 2012 08:12:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60b7d14af46ef07778e89556429ec9ab5a7fad0b
Gitweb:     http://git.kernel.org/tip/60b7d14af46ef07778e89556429ec9ab5a7fad0b
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 12 Sep 2012 11:11:06 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 14 Sep 2012 15:48:38 -0300

perf sched: Fixup for the die() removal

The commit a116e05dcf61 ("perf sched: Remove die() calls") replaced
die() call to pr_debug + return -1, but it should be pr_err otherwise
it'll not show up unless -v option is given.  Fix it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1347415866-303-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index af305f5..9b9e32e 100644
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
 
