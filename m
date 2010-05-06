Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab0EFJcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 05:32:48 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:54182 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab0EFJcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 05:32:46 -0400
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
       h.mitake@gmail.com, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH] perf lock: track only specified threads
Date: Thu,  6 May 2010 18:32:56 +0900
Message-Id: <1273138376-23323-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <4BE28C8D.8000408@dcl.info.waseda.ac.jp>
References: <4BE28C8D.8000408@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I implemented the feature of tracking only specified threads to perf lock.
With -t option, users can specify which threads should be tracked.

Example of usage:
| % sudo ./perf lock info -t                    # info -t is convenient with this feature
|  Thread ID: comm
|          0: swapper
|          1: init
|         12: migration/3
|         13: ksoftirqd/3
|         27: events/0
|         28: events/1
|         29: events/2
|         30: events/3
|         31: events/4
|        857: kondemand/0
|        858: kondemand/1
|        859: kondemand/2
| ...
| % sudo ./perf lock -t 27,28,29,30,31 report   # track only these threads
|                 Name   acquired  contended total wait (ns)   max wait (ns)   min wait (ns)
|
|  &(&cwq->lock)->r...          4          0               0               0               0
|  &(&cwq->lock)->r...          4          0               0               0               0
|                  key          2          0               0               0               0
|                  key          2          0               0               0               0
|  &(&tty->buf.lock...          2          0               0               0               0
|  &(&tty->buf.lock...          2          0               0               0               0
|       tty_ldisc_lock          2          0               0               0               0
|  &(&base->lock)->...          2          0               0               0               0
|  &(&(&(*({ do { c...          2          0               0               0               0
|  &(&(&(*({ do { c...          2          0               0               0               0
|  &(&cwq->lock)->r...          2          0               0               0               0

I believe that this is convenient feature because perf itself acquires lots of locks.
Could you queue this, Frederic?

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
---
 tools/perf/builtin-lock.c |   71 +++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 010a7c8..7c75c44 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -23,6 +23,7 @@
 #include <linux/list.h>
 #include <linux/hash.h>
 
+static int do_info;
 static struct perf_session *session;
 
 /* based on kernel/lockdep.c */
@@ -34,6 +35,27 @@ static struct list_head lockhash_table[LOCKHASH_SIZE];
 #define __lockhashfn(key)	hash_long((unsigned long)key, LOCKHASH_BITS)
 #define lockhashentry(key)	(lockhash_table + __lockhashfn((key)))
 
+static u32 *track_thread_array;
+static int track_thread_array_length;
+
+static int is_track_thread_do(u32 tid)
+{
+	int i;
+
+	for (i = 0; i < track_thread_array_length; i++) {
+		if (track_thread_array[i] == tid)
+			return 1;
+	}
+	return 0;
+}
+
+static int is_track_thread_nop(u32 tid __used)
+{
+	return 1;
+}
+
+static int (*is_track_thread)(u32) = is_track_thread_nop;
+
 struct lock_stat {
 	struct list_head	hash_entry;
 	struct rb_node		rb;		/* used for sorting */
@@ -315,6 +337,7 @@ alloc_failed:
 }
 
 static char			const *input_name = "perf.data";
+static char			const *track_threads_str;
 
 struct raw_event_sample {
 	u32			size;
@@ -829,6 +852,9 @@ static int process_sample_event(event_t *self, struct perf_session *s)
 	bzero(&data, sizeof(data));
 	event__parse_sample(self, s->sample_type, &data);
 
+	if (!do_info && !is_track_thread(data.tid))
+		return 0;
+
 	thread = perf_session__findnew(s, data.tid);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
@@ -868,8 +894,41 @@ static void sort_result(void)
 	}
 }
 
+static void parse_track_threads(void)
+{
+	char *tmp, *tok, *str;
+
+	if (!track_threads_str)
+		return;
+
+	str = strdup(track_threads_str);
+	if (!str)
+		die("Memory allocation failed\n");
+
+	tok = strtok_r(str, ", ", &tmp);
+	if (!tok)
+		return;
+	track_thread_array = zalloc(sizeof(u32));
+	if (!track_thread_array)
+		die("Memory allocation failed\n");
+	track_thread_array[0] = atoi(tok);
+	track_thread_array_length = 1;
+	is_track_thread = is_track_thread_do;
+
+	for (tok = strtok_r(NULL, ", ", &tmp);
+	     tok; tok = strtok_r(NULL, ", ", &tmp)) {
+		track_thread_array = realloc(track_thread_array,
+					     sizeof(u32) *
+					     ++track_thread_array_length);
+		if (!track_thread_array)
+			die("Memory allocation failed\n");
+		track_thread_array[track_thread_array_length - 1] = atoi(tok);
+	}
+}
+
 static void __cmd_report(void)
 {
+	parse_track_threads();
 	setup_pager();
 	select_key();
 	read_events();
@@ -908,9 +967,14 @@ static const char * const lock_usage[] = {
 };
 
 static const struct option lock_options[] = {
-	OPT_STRING('i', "input", &input_name, "file", "input file name"),
-	OPT_INCR('v', "verbose", &verbose, "be more verbose (show symbol address, etc)"),
-	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace, "dump raw trace in ASCII"),
+	OPT_STRING('i', "input", &input_name,
+		   "file", "input file name"),
+	OPT_INCR('v', "verbose", &verbose,
+		 "be more verbose (show symbol address, etc)"),
+	OPT_BOOLEAN('D', "dump-raw-trace",
+		    &dump_trace, "dump raw trace in ASCII"),
+	OPT_STRING('t', "threads", &track_threads_str,
+		   NULL, "thread IDs to track"),
 	OPT_END()
 };
 
@@ -981,6 +1045,7 @@ int cmd_lock(int argc, const char **argv, const char *prefix __used)
 				usage_with_options(info_usage, info_options);
 		}
 		/* recycling report_lock_ops */
+		do_info = 1;
 		trace_handler = &report_lock_ops;
 		setup_pager();
 		read_events();
-- 
1.6.5.2

