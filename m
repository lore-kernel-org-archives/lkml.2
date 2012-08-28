Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab2H1WHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 18:07:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51396 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab2H1WHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 18:07:09 -0400
MIME-Version: 1.0
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Wed, 29 Aug 2012 01:06:48 +0300
Message-ID: <CANg8OW+q0VumrJrQL57gecO0W0TrpB_WgspKhM-GeiPEdiSPDQ@mail.gmail.com>
Subject: [PATCH 12/13] perf tools: replace on_exit with atexit
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on_exit() is only available in new versions of glibc.
Using on_exit on Android leads to errors at compile time.

Replacing on_exit with its more portable version atexit.
This leads to using a global variable since on_exit supports
sending a parameters while atexit does not.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 tools/perf/builtin-record.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 3fc9bf9..f5daedf 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -66,6 +66,9 @@ struct perf_record {
     off_t            post_processing_offset;
 };

+/* for atexit */
+static struct perf_record *saved_rec;
+
 static void advance_output(struct perf_record *rec, size_t size)
 {
     rec->bytes_written += size;
@@ -143,9 +146,9 @@ static void sig_handler(int sig)
     signr = sig;
 }

-static void perf_record__sig_exit(int exit_status __maybe_unused, void *arg)
+static void perf_record__sig_exit(void)
 {
-    struct perf_record *rec = arg;
+    struct perf_record *rec = saved_rec;
     int status;

     if (rec->evlist->workload.pid > 0) {
@@ -335,9 +338,9 @@ static int process_buildids(struct perf_record *rec)
                           size, &build_id__mark_dso_hit_ops);
 }

-static void perf_record__exit(int status __maybe_unused, void *arg)
+static void perf_record__exit(void)
 {
-    struct perf_record *rec = arg;
+    struct perf_record *rec = saved_rec;

     if (!rec->opts.pipe_output) {
         rec->session->header.data_size += rec->bytes_written;
@@ -424,7 +427,8 @@ static int __cmd_record(struct perf_record *rec,
int argc, const char **argv)

     rec->page_size = sysconf(_SC_PAGE_SIZE);

-    on_exit(perf_record__sig_exit, rec);
+    saved_rec = rec;
+    atexit(perf_record__sig_exit);
     signal(SIGCHLD, sig_handler);
     signal(SIGINT, sig_handler);
     signal(SIGUSR1, sig_handler);
@@ -508,7 +512,7 @@ static int __cmd_record(struct perf_record *rec,
int argc, const char **argv)
     /*
      * perf_session__delete(session) will be called at perf_record__exit()
      */
-    on_exit(perf_record__exit, rec);
+    atexit(perf_record__exit);

     if (opts->pipe_output) {
         err = perf_header__write_pipe(output);
--
1.7.9.5
