Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab1A2WTj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 17:19:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35648 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184Ab1A2WTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 17:19:33 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 4/7] perf top: Switch to non overwrite mode
Date: Sat, 29 Jan 2011 20:19:16 -0200
Message-Id: <1296339559-20914-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1296339559-20914-1-git-send-email-acme@infradead.org>
References: <1296339559-20914-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Just like 'perf record'. Warn the user when PERF_RECORD_LOST events
happen.

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
 tools/perf/builtin-top.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index ce2e50c..7f92ab7 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -464,7 +464,7 @@ static void rb_insert_active_sym(struct rb_root *tree, struct sym_entry *se)
 	rb_insert_color(&se->rb_node, tree);
 }
 
-static void print_sym_table(void)
+static void print_sym_table(struct perf_session *session)
 {
 	int printed = 0, j;
 	struct perf_evsel *counter;
@@ -513,7 +513,6 @@ static void print_sym_table(void)
 
 	puts(CONSOLE_CLEAR);
 
-	printf("%-*.*s\n", win_width, win_width, graph_dotted_line);
 	if (!perf_guest) {
 		printf("   PerfTop:%8.0f irqs/sec  kernel:%4.1f%%"
 			"  exact: %4.1f%% [",
@@ -578,6 +577,12 @@ static void print_sym_table(void)
 
 	printf("%-*.*s\n", win_width, win_width, graph_dotted_line);
 
+	if (session->hists.stats.total_lost != 0) {
+		color_fprintf(stdout, PERF_COLOR_RED, "WARNING:");
+		printf(" LOST %" PRIu64 " events, Check IO/CPU overload\n",
+		       session->hists.stats.total_lost);
+	}
+
 	if (sym_filter_entry) {
 		show_details(sym_filter_entry);
 		return;
@@ -919,7 +924,7 @@ repeat:
 	getc(stdin);
 
 	do {
-		print_sym_table();
+		print_sym_table(session);
 	} while (!poll(&stdin_poll, 1, delay_msecs) == 1);
 
 	c = getc(stdin);
@@ -1176,7 +1181,7 @@ try_again:
 		}
 	}
 
-	if (perf_evlist__mmap(evlist, cpus, threads, mmap_pages, true) < 0)
+	if (perf_evlist__mmap(evlist, cpus, threads, mmap_pages, false) < 0)
 		die("failed to mmap with %d (%s)\n", errno, strerror(errno));
 }
 
-- 
1.6.2.5

