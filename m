Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab1AaMud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 07:50:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:33167 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508Ab1AaMu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 07:50:28 -0500
Date: Mon, 31 Jan 2011 12:49:50 GMT
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
Subject: [tip:perf/core] perf top: Switch to non overwrite mode
Message-ID: <tip-93fc64f14472ae24fd640bf3834a178f59142842@git.kernel.org>
Git-Commit-ID: 93fc64f14472ae24fd640bf3834a178f59142842
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 12:49:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  93fc64f14472ae24fd640bf3834a178f59142842
Gitweb:     http://git.kernel.org/tip/93fc64f14472ae24fd640bf3834a178f59142842
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 29 Jan 2011 12:08:00 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 29 Jan 2011 16:24:57 -0200

perf top: Switch to non overwrite mode

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
 
