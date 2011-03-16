Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab1CPNwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:52:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:32862 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765Ab1CPNwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:52:32 -0400
Date: Wed, 16 Mar 2011 13:51:53 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf top: Remove redundant perf_top->sym_counter
Message-ID: <tip-ec52d9765a0f3603c62b4238482bf38897e4d42f@git.kernel.org>
Git-Commit-ID: ec52d9765a0f3603c62b4238482bf38897e4d42f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Mar 2011 13:51:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec52d9765a0f3603c62b4238482bf38897e4d42f
Gitweb:     http://git.kernel.org/tip/ec52d9765a0f3603c62b4238482bf38897e4d42f
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 11 Mar 2011 10:11:48 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Mar 2011 13:28:45 -0300

perf top: Remove redundant perf_top->sym_counter

We can get that counter index from perf_top->sym_evsel->idx instead.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |   11 ++++++-----
 tools/perf/util/top.c    |    2 +-
 tools/perf/util/top.h    |    2 +-
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 80c9e06..4bf6e02 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -515,24 +515,25 @@ static void handle_keypress(struct perf_session *session, int c)
 			break;
 		case 'E':
 			if (top.evlist->nr_entries > 1) {
+				int counter;
 				fprintf(stderr, "\nAvailable events:");
 
 				list_for_each_entry(top.sym_evsel, &top.evlist->entries, node)
 					fprintf(stderr, "\n\t%d %s", top.sym_evsel->idx, event_name(top.sym_evsel));
 
-				prompt_integer(&top.sym_counter, "Enter details event counter");
+				prompt_integer(&counter, "Enter details event counter");
 
-				if (top.sym_counter >= top.evlist->nr_entries) {
+				if (counter >= top.evlist->nr_entries) {
 					top.sym_evsel = list_entry(top.evlist->entries.next, struct perf_evsel, node);
-					top.sym_counter = 0;
 					fprintf(stderr, "Sorry, no such event, using %s.\n", event_name(top.sym_evsel));
 					sleep(1);
 					break;
 				}
 				list_for_each_entry(top.sym_evsel, &top.evlist->entries, node)
-					if (top.sym_evsel->idx == top.sym_counter)
+					if (top.sym_evsel->idx == counter)
 						break;
-			} else top.sym_counter = 0;
+			} else
+				top.sym_evsel = list_entry(top.evlist->entries.next, struct perf_evsel, node);
 			break;
 		case 'f':
 			prompt_integer(&top.count_filter, "Enter display event count filter");
diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index 75cfe4d..fcfb777 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -171,7 +171,7 @@ float perf_top__decay_samples(struct perf_top *top, struct rb_root *root)
 {
 	struct sym_entry *syme, *n;
 	float sum_ksamples = 0.0;
-	int snap = !top->display_weighted ? top->sym_counter : 0, j;
+	int snap = !top->display_weighted ? top->sym_evsel->idx : 0, j;
 
 	/* Sort the active symbols */
 	pthread_mutex_lock(&top->active_symbols_lock);
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index 96d1cb7..96a7831 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -41,7 +41,7 @@ struct perf_top {
 	u64		   exact_samples;
 	u64		   guest_us_samples, guest_kernel_samples;
 	int		   print_entries, count_filter, delay_secs;
-	int		   display_weighted, freq, rb_entries, sym_counter;
+	int		   display_weighted, freq, rb_entries;
 	pid_t		   target_pid, target_tid;
 	bool		   hide_kernel_symbols, hide_user_symbols, zero;
 	const char	   *cpu_list;
