Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab1I2Wuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:50:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60150 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911Ab1I2WsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:48:20 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 06/16] perf top: Improve lost events warning
Date: Thu, 29 Sep 2011 19:48:00 -0300
Message-Id: <1317336490-19437-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317336490-19437-1-git-send-email-acme@infradead.org>
References: <1317336490-19437-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Now it warns everytime that new events are lost.

And the TUI also warns now.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-w1n168yrvrppnq6887s4u0wx@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c          |   34 +++++++++++++++++-----------------
 tools/perf/util/top.h             |    3 +++
 tools/perf/util/ui/browsers/top.c |   24 ++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 17 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index a43433f..23c4f71 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -250,7 +250,7 @@ static void __list_insert_active_sym(struct sym_entry *syme)
 	list_add(&syme->node, &top.active_symbols);
 }
 
-static void print_sym_table(struct perf_session *session)
+static void print_sym_table(void)
 {
 	char bf[160];
 	int printed = 0;
@@ -270,10 +270,11 @@ static void print_sym_table(struct perf_session *session)
 
 	printf("%-*.*s\n", win_width, win_width, graph_dotted_line);
 
-	if (session->hists.stats.total_lost != 0) {
+	if (top.total_lost_warned != top.session->hists.stats.total_lost) {
+		top.total_lost_warned = top.session->hists.stats.total_lost;
 		color_fprintf(stdout, PERF_COLOR_RED, "WARNING:");
 		printf(" LOST %" PRIu64 " events, Check IO/CPU overload\n",
-		       session->hists.stats.total_lost);
+		       top.total_lost_warned);
 	}
 
 	if (top.sym_filter_entry) {
@@ -474,7 +475,7 @@ static int key_mapped(int c)
 	return 0;
 }
 
-static void handle_keypress(struct perf_session *session, int c)
+static void handle_keypress(int c)
 {
 	if (!key_mapped(c)) {
 		struct pollfd stdin_poll = { .fd = 0, .events = POLLIN };
@@ -550,7 +551,7 @@ static void handle_keypress(struct perf_session *session, int c)
 		case 'Q':
 			printf("exiting.\n");
 			if (dump_symtab)
-				perf_session__fprintf_dsos(session, stderr);
+				perf_session__fprintf_dsos(top.session, stderr);
 			exit(0);
 		case 's':
 			prompt_symbol(&top.sym_filter_entry, "Enter details symbol");
@@ -602,7 +603,6 @@ static void *display_thread(void *arg __used)
 	struct pollfd stdin_poll = { .fd = 0, .events = POLLIN };
 	struct termios tc, save;
 	int delay_msecs, c;
-	struct perf_session *session = (struct perf_session *) arg;
 
 	tcgetattr(0, &save);
 	tc = save;
@@ -617,13 +617,13 @@ repeat:
 	getc(stdin);
 
 	do {
-		print_sym_table(session);
+		print_sym_table();
 	} while (!poll(&stdin_poll, 1, delay_msecs) == 1);
 
 	c = getc(stdin);
 	tcsetattr(0, TCSAFLUSH, &save);
 
-	handle_keypress(session, c);
+	handle_keypress(c);
 	goto repeat;
 
 	return NULL;
@@ -935,27 +935,27 @@ static int __cmd_top(void)
 	 * FIXME: perf_session__new should allow passing a O_MMAP, so that all this
 	 * mmap reading, etc is encapsulated in it. Use O_WRONLY for now.
 	 */
-	struct perf_session *session = perf_session__new(NULL, O_WRONLY, false, false, NULL);
-	if (session == NULL)
+	top.session = perf_session__new(NULL, O_WRONLY, false, false, NULL);
+	if (top.session == NULL)
 		return -ENOMEM;
 
 	if (top.target_tid != -1)
 		perf_event__synthesize_thread_map(top.evlist->threads,
-						  perf_event__process, session);
+						  perf_event__process, top.session);
 	else
-		perf_event__synthesize_threads(perf_event__process, session);
+		perf_event__synthesize_threads(perf_event__process, top.session);
 
 	start_counters(top.evlist);
-	session->evlist = top.evlist;
-	perf_session__update_sample_type(session);
+	top.session->evlist = top.evlist;
+	perf_session__update_sample_type(top.session);
 
 	/* Wait for a minimal set of events before starting the snapshot */
 	poll(top.evlist->pollfd, top.evlist->nr_fds, 100);
 
-	perf_session__mmap_read(session);
+	perf_session__mmap_read(top.session);
 
 	if (pthread_create(&thread, NULL, (use_browser > 0 ? display_thread_tui :
-							     display_thread), session)) {
+							     display_thread), NULL)) {
 		printf("Could not create display thread.\n");
 		exit(-1);
 	}
@@ -973,7 +973,7 @@ static int __cmd_top(void)
 	while (1) {
 		u64 hits = top.samples;
 
-		perf_session__mmap_read(session);
+		perf_session__mmap_read(top.session);
 
 		if (hits == top.samples)
 			ret = poll(top.evlist->pollfd, top.evlist->nr_fds, 100);
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index bfbf95b..b07b041 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -10,6 +10,7 @@
 
 struct perf_evlist;
 struct perf_evsel;
+struct perf_session;
 
 struct sym_entry {
 	struct rb_node		rb_node;
@@ -38,6 +39,7 @@ struct perf_top {
 	u64		   kernel_samples, us_samples;
 	u64		   exact_samples;
 	u64		   guest_us_samples, guest_kernel_samples;
+	u64		   total_lost_warned;
 	int		   print_entries, count_filter, delay_secs;
 	int		   display_weighted, freq, rb_entries;
 	pid_t		   target_pid, target_tid;
@@ -45,6 +47,7 @@ struct perf_top {
 	const char	   *cpu_list;
 	struct sym_entry   *sym_filter_entry;
 	struct perf_evsel  *sym_evsel;
+	struct perf_session *session;
 };
 
 size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size);
diff --git a/tools/perf/util/ui/browsers/top.c b/tools/perf/util/ui/browsers/top.c
index 9d93810..9b6b43b 100644
--- a/tools/perf/util/ui/browsers/top.c
+++ b/tools/perf/util/ui/browsers/top.c
@@ -11,10 +11,12 @@
 #include "../helpline.h"
 #include "../libslang.h"
 #include "../util.h"
+#include "../ui.h"
 #include "../../evlist.h"
 #include "../../hist.h"
 #include "../../sort.h"
 #include "../../symbol.h"
+#include "../../session.h"
 #include "../../top.h"
 
 struct perf_top_browser {
@@ -143,6 +145,25 @@ do_annotation:
 	symbol__tui_annotate(sym, syme->map, 0, top->delay_secs * 1000);
 }
 
+static void perf_top_browser__warn_lost(struct perf_top_browser *browser)
+{
+	struct perf_top *top = browser->b.priv;
+	char msg[128];
+	int len;
+
+	top->total_lost_warned = top->session->hists.stats.total_lost;
+	pthread_mutex_lock(&ui__lock);
+	ui_browser__set_color(&browser->b, HE_COLORSET_TOP);
+	len = snprintf(msg, sizeof(msg),
+		      " WARNING: LOST %" PRIu64 " events, Check IO/CPU overload",
+		      top->total_lost_warned);
+	if (len > browser->b.width)
+		len = browser->b.width;
+	SLsmg_gotorc(0, browser->b.width - len);
+	slsmg_write_nstring(msg, len);
+	pthread_mutex_unlock(&ui__lock);
+}
+
 static int perf_top_browser__run(struct perf_top_browser *browser)
 {
 	int key;
@@ -174,6 +195,9 @@ static int perf_top_browser__run(struct perf_top_browser *browser)
 			ui_browser__set_color(&browser->b, NEWT_COLORSET_ROOT);
 			SLsmg_gotorc(0, 0);
 			slsmg_write_nstring(title, browser->b.width);
+
+			if (top->total_lost_warned != top->session->hists.stats.total_lost)
+				perf_top_browser__warn_lost(browser);
 			break;
 		case 'a':
 		case NEWT_KEY_RIGHT:
-- 
1.6.2.5

