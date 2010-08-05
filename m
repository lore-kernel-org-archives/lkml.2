Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406Ab0HEOoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:44:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:41198 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760656Ab0HEOim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:38:42 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 12/17] ftrace,kdb: Allow dumping a specific cpu's buffer with ftdump
Date: Thu,  5 Aug 2010 09:37:53 -0500
Message-Id: <1281019078-6636-13-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281019078-6636-12-git-send-email-jason.wessel@windriver.com>
References: <1281019078-6636-1-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-2-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-3-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-4-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-5-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-6-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-7-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-8-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-9-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-10-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-11-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-12-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Aug 2010 14:38:20.0824 (UTC) FILETIME=[D9CB9180:01CB34AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In systems with more than one processor it is desirable to look at the
per cpu trace buffers.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_kdb.c |   37 +++++++++++++++++++++++++++----------
 1 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
index 44cbda2..7b8ecd7 100644
--- a/kernel/trace/trace_kdb.c
+++ b/kernel/trace/trace_kdb.c
@@ -17,7 +17,7 @@
 #include "trace.h"
 #include "trace_output.h"
 
-static void ftrace_dump_buf(int skip_lines)
+static void ftrace_dump_buf(int skip_lines, long cpu_file)
 {
 	/* use static because iter can be a bit big for the stack */
 	static struct trace_iterator iter;
@@ -44,13 +44,20 @@ static void ftrace_dump_buf(int skip_lines)
 	iter.iter_flags |= TRACE_FILE_LAT_FMT;
 	iter.pos = -1;
 
-	for_each_tracing_cpu(cpu) {
-		iter.buffer_iter[cpu] =
+	if (cpu_file == TRACE_PIPE_ALL_CPU) {
+		for_each_tracing_cpu(cpu) {
+			iter.buffer_iter[cpu] =
 			ring_buffer_read_prepare(iter.tr->buffer, cpu);
-		ring_buffer_read_start(iter.buffer_iter[cpu]);
-		tracing_iter_reset(&iter, cpu);
+			ring_buffer_read_start(iter.buffer_iter[cpu]);
+			tracing_iter_reset(&iter, cpu);
+		}
+	} else {
+		iter.cpu_file = cpu_file;
+		iter.buffer_iter[cpu_file] =
+			ring_buffer_read_prepare(iter.tr->buffer, cpu_file);
+		ring_buffer_read_start(iter.buffer_iter[cpu_file]);
+		tracing_iter_reset(&iter, cpu_file);
 	}
-
 	if (!trace_empty(&iter))
 		trace_find_next_entry_inc(&iter);
 	while (!trace_empty(&iter)) {
@@ -91,9 +98,10 @@ out:
 static int kdb_ftdump(int argc, const char **argv)
 {
 	int skip_lines = 0;
+	long cpu_file;
 	char *cp;
 
-	if (argc > 1)
+	if (argc > 2)
 		return KDB_ARGCOUNT;
 
 	if (argc) {
@@ -102,8 +110,17 @@ static int kdb_ftdump(int argc, const char **argv)
 			skip_lines = 0;
 	}
 
+	if (argc == 2) {
+		cpu_file = simple_strtol(argv[2], &cp, 0);
+		if (*cp || cpu_file >= NR_CPUS || cpu_file < 0 ||
+		    !cpu_online(cpu_file))
+			return KDB_BADINT;
+	} else {
+		cpu_file = TRACE_PIPE_ALL_CPU;
+	}
+
 	kdb_trap_printk++;
-	ftrace_dump_buf(skip_lines);
+	ftrace_dump_buf(skip_lines, cpu_file);
 	kdb_trap_printk--;
 
 	return 0;
@@ -111,8 +128,8 @@ static int kdb_ftdump(int argc, const char **argv)
 
 static __init int kdb_ftrace_register(void)
 {
-	kdb_register_repeat("ftdump", kdb_ftdump, "", "Dump ftrace log",
-			    0, KDB_REPEAT_NONE);
+	kdb_register_repeat("ftdump", kdb_ftdump, "[skip_#lines] [cpu]",
+			    "Dump ftrace log", 0, KDB_REPEAT_NONE);
 	return 0;
 }
 
-- 
1.6.3.3

