Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab0EIUpl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 16:45:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34161 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab0EIUnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 16:43:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=boNQqw1G4N8x6CIOryixDJkhsb8ScLAmxQES0vkMerZx1FEQC/A4xTo1/OMaxzIyJd
         hqhsriq5i8Q+zxp5oPvctcGfj/O82KhSR/uVlCtW9uM9lLZWb2MgVuU3BjPOg9x6W/WW
         7DWcJV2616myN9veSYeAmlwbgbDAD7iyG/q5Y=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 01/10] perf lock: Add "info" subcommand for dumping misc information
Date: Sun,  9 May 2010 22:43:29 +0200
Message-Id: <1273437818-8130-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1273437818-8130-1-git-send-regression-fweisbec@gmail.com>
References: <1273437818-8130-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>

This adds the "info" subcommand to perf lock which can be used
to dump metadata like threads or addresses of lock instances.
"map" was removed because info should do the work for it.

This will be useful not only for debugging but also for ordinary
analyzing.

v2: adding example of usage
% sudo ./perf lock info -t
 | Thread ID: comm
 | 	 0: swapper
 |         1: init
 |        18: migration/5
 |        29: events/2
 |        32: events/5
 |        33: events/6
...

% sudo ./perf lock info -m
| Address of instance: name of class
|  0xffff8800b95adae0: &(&sighand->siglock)->rlock
|  0xffff8800bbb41ae0: &(&sighand->siglock)->rlock
|  0xffff8800bf165ae0: &(&sighand->siglock)->rlock
|  0xffff8800b9576a98: &p->cred_guard_mutex
|  0xffff8800bb890a08: &(&p->alloc_lock)->rlock
|  0xffff8800b9522a08: &(&p->alloc_lock)->rlock
|  0xffff8800bb8aaa08: &(&p->alloc_lock)->rlock
|  0xffff8800bba72a08: &(&p->alloc_lock)->rlock
|  0xffff8800bf18ea08: &(&p->alloc_lock)->rlock
|  0xffff8800b8a0d8a0: &(&ip->i_lock)->mr_lock
|  0xffff88009bf818a0: &(&ip->i_lock)->mr_lock
|  0xffff88004c66b8a0: &(&ip->i_lock)->mr_lock
|  0xffff8800bb6478a0: &(shost->host_lock)->rlock

v3: fixed some problems Frederic pointed out
 * better rbtree tracking in dump_threads()
 * removed printf() and used pr_info() and pr_debug()

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
LKML-Reference: <1272863520-16179-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/builtin-lock.c |   96 ++++++++++++++++++++++++++++++++++-----------
 1 files changed, 73 insertions(+), 23 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 6605000..c4eb854 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -720,15 +720,15 @@ static void print_result(void)
 	char cut_name[20];
 	int bad, total;
 
-	printf("%20s ", "Name");
-	printf("%10s ", "acquired");
-	printf("%10s ", "contended");
+	pr_info("%20s ", "Name");
+	pr_info("%10s ", "acquired");
+	pr_info("%10s ", "contended");
 
-	printf("%15s ", "total wait (ns)");
-	printf("%15s ", "max wait (ns)");
-	printf("%15s ", "min wait (ns)");
+	pr_info("%15s ", "total wait (ns)");
+	pr_info("%15s ", "max wait (ns)");
+	pr_info("%15s ", "min wait (ns)");
 
-	printf("\n\n");
+	pr_info("\n\n");
 
 	bad = total = 0;
 	while ((st = pop_from_result())) {
@@ -741,7 +741,7 @@ static void print_result(void)
 
 		if (strlen(st->name) < 16) {
 			/* output raw name */
-			printf("%20s ", st->name);
+			pr_info("%20s ", st->name);
 		} else {
 			strncpy(cut_name, st->name, 16);
 			cut_name[16] = '.';
@@ -749,17 +749,17 @@ static void print_result(void)
 			cut_name[18] = '.';
 			cut_name[19] = '\0';
 			/* cut off name for saving output style */
-			printf("%20s ", cut_name);
+			pr_info("%20s ", cut_name);
 		}
 
-		printf("%10u ", st->nr_acquired);
-		printf("%10u ", st->nr_contended);
+		pr_info("%10u ", st->nr_acquired);
+		pr_info("%10u ", st->nr_contended);
 
-		printf("%15llu ", st->wait_time_total);
-		printf("%15llu ", st->wait_time_max);
-		printf("%15llu ", st->wait_time_min == ULLONG_MAX ?
+		pr_info("%15llu ", st->wait_time_total);
+		pr_info("%15llu ", st->wait_time_max);
+		pr_info("%15llu ", st->wait_time_min == ULLONG_MAX ?
 		       0 : st->wait_time_min);
-		printf("\n");
+		pr_info("\n");
 	}
 
 	{
@@ -768,28 +768,59 @@ static void print_result(void)
 		const char *name[4] =
 			{ "acquire", "acquired", "contended", "release" };
 
-		printf("\n=== output for debug===\n\n");
-		printf("bad:%d, total:%d\n", bad, total);
-		printf("bad rate:%f\n", (double)(bad / total));
+		pr_debug("\n=== output for debug===\n\n");
+		pr_debug("bad:%d, total:%d\n", bad, total);
+		pr_debug("bad rate:%f\n", (double)(bad / total));
 
-		printf("histogram of events caused bad sequence\n");
+		pr_debug("histogram of events caused bad sequence\n");
 		for (i = 0; i < 4; i++)
-			printf(" %10s: %d\n", name[i], bad_hist[i]);
+			pr_debug(" %10s: %d\n", name[i], bad_hist[i]);
 	}
 }
 
+static int			info_threads;
+static int			info_map;
+
+static void dump_threads(void)
+{
+	struct thread_stat *st;
+	struct rb_node *node;
+	struct thread *t;
+
+	pr_info("%10s: comm\n", "Thread ID");
+
+	node = rb_first(&thread_stats);
+	while (node) {
+		st = container_of(node, struct thread_stat, rb);
+		t = perf_session__findnew(session, st->tid);
+		pr_info("%10d: %s\n", st->tid, t->comm);
+		node = rb_next(node);
+	};
+}
+
 static void dump_map(void)
 {
 	unsigned int i;
 	struct lock_stat *st;
 
+	pr_info("Address of instance: name of class\n");
 	for (i = 0; i < LOCKHASH_SIZE; i++) {
 		list_for_each_entry(st, &lockhash_table[i], hash_entry) {
-			printf("%p: %s\n", st->addr, st->name);
+			pr_info(" %p: %s\n", st->addr, st->name);
 		}
 	}
 }
 
+static void dump_info(void)
+{
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
@@ -858,6 +889,19 @@ static const struct option report_options[] = {
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
@@ -929,12 +973,18 @@ int cmd_lock(int argc, const char **argv, const char *prefix __used)
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
1.6.2.3

