Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab1COUFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:05:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:38965 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757677Ab1COUFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 16:05:11 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 01/12] perf top: Remove redundant perf_top->sym_counter
Date: Tue, 15 Mar 2011 17:04:50 -0300
Message-Id: <1300219501-15085-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1300219501-15085-1-git-send-email-acme@infradead.org>
References: <1300219501-15085-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
-- 
1.6.2.5

