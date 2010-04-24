Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab0DXKnf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 06:43:35 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:50531 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab0DXKnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 06:43:33 -0400
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
       h.mitake@gmail.com, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH] perf lock: add "info" subcommand for dumping misc information
Date: Sat, 24 Apr 2010 19:43:33 +0900
Message-Id: <1272105813-10465-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1272074742-3654-2-git-send-regression-fweisbec@gmail.com>
References: <1272074742-3654-2-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

I added "info" subcommand to perf lock,
this can be used as dumping metadata like thread or address of lock instances.
"map" was removed because info should do the work of it.

This will be useful not only for debugging but also for ordinary analyzing.

I made this patch on perf/core of your tree, could you queue this?

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 tools/perf/builtin-lock.c |   68 +++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 65 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index ce27675..c54211e 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -778,18 +778,61 @@ static void print_result(void)
 	}
 }
 
+static int			info_threads;
+static int			info_map;
+
+static void rec_dump_threads(struct rb_node *node)
+{
+	struct thread_stat *st;
+	struct thread *t;
+
+	if (!node)
+		return;
+
+	if (node->rb_left)
+		rec_dump_threads(node->rb_left);
+
+	st = container_of(node, struct thread_stat, rb);
+	BUG_ON(!st);
+	t = perf_session__findnew(session, st->tid);
+	BUG_ON(!t);
+
+	printf("%10d: %s\n", st->tid, t->comm);
+
+	if (node->rb_right)
+		rec_dump_threads(node->rb_right);
+}
+
+static void dump_threads(void)
+{
+	printf("%10s: comm\n", "Thread ID");
+	rec_dump_threads(thread_stats.rb_node);
+}
+
 static void dump_map(void)
 {
 	unsigned int i;
 	struct lock_stat *st;
 
+	printf("Address of instance: name of class\n");
 	for (i = 0; i < LOCKHASH_SIZE; i++) {
 		list_for_each_entry(st, &lockhash_table[i], hash_entry) {
-			printf("%p: %s\n", st->addr, st->name);
+			printf(" %p: %s\n", st->addr, st->name);
 		}
 	}
 }
 
+static void dump_info(void)
+{
+	/* ugly... */
+	if (info_threads)
+		dump_threads();
+	else if (info_map)
+		dump_map();
+	else
+		die("Unknown type of information\n");
+}
+
 static int process_sample_event(event_t *self, struct perf_session *s)
 {
 	struct sample_data data;
@@ -858,6 +901,19 @@ static const struct option report_options[] = {
 	OPT_END()
 };
 
+static const char * const info_usage[] = {
+	"perf lock info [<options>]",
+	NULL
+};
+
+static const struct option info_options[] = {
+	OPT_BOOLEAN('t', "threads", &info_threads,
+		    "dump thread list in perf.data"),
+	OPT_BOOLEAN('m', "map", &info_map,
+		    "map of lock instances (name:address table)"),
+	OPT_END()
+};
+
 static const char * const lock_usage[] = {
 	"perf lock [<options>] {record|trace|report}",
 	NULL
@@ -929,12 +985,18 @@ int cmd_lock(int argc, const char **argv, const char *prefix __used)
 	} else if (!strcmp(argv[0], "trace")) {
 		/* Aliased to 'perf trace' */
 		return cmd_trace(argc, argv, prefix);
-	} else if (!strcmp(argv[0], "map")) {
+	} else if (!strcmp(argv[0], "info")) {
+		if (argc) {
+			argc = parse_options(argc, argv,
+					     info_options, info_usage, 0);
+			if (argc)
+				usage_with_options(info_usage, info_options);
+		}
 		/* recycling report_lock_ops */
 		trace_handler = &report_lock_ops;
 		setup_pager();
 		read_events();
-		dump_map();
+		dump_info();
 	} else {
 		usage_with_options(lock_usage, lock_options);
 	}
-- 
1.6.5.2

