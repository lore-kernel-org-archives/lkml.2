Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003Ab0EMUUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:20:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58356 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932899Ab0EMUTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:19:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
       "David S. Miller" <davem@davemloft.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/4] perf tools: change event inheritance logic in stat and record
Date: Thu, 13 May 2010 17:19:23 -0300
Message-Id: <1273781964-29552-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273781964-29552-1-git-send-email-acme@infradead.org>
References: <1273781964-29552-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

By default, event inheritance across fork and pthread_create was on but the -i
option of stat and record, which enabled inheritance, led to believe it was off
by default.

This patch fixes this logic by inverting the meaning of the -i option.  By
default inheritance is on whether you attach to a process (-p), a thread (-t)
or start a process. If you pass -i, then you turn off inheritance. Turning off
inheritance if you don't need it, helps limit perf resource usage as well.

The patch also fixes perf stat -t xxxx and perf record -t xxxx which did not
start the counters.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <4bea9d2f.d60ce30a.0b5b.08e1@mx.google.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-record.txt |    4 ++--
 tools/perf/Documentation/perf-stat.txt   |    4 ++--
 tools/perf/builtin-record.c              |   12 ++++++------
 tools/perf/builtin-stat.c                |   10 +++++-----
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 020d871..34e255f 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -69,8 +69,8 @@ OPTIONS
 	Output file name.
 
 -i::
---inherit::
-	Child tasks inherit counters.
+--no-inherit::
+	Child tasks do not inherit counters.
 -F::
 --freq=::
 	Profile at this frequency.
diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index 484080d..2cab8e8 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -31,8 +31,8 @@ OPTIONS
 	 hexadecimal event descriptor.
 
 -i::
---inherit::
-        child tasks inherit counters
+--no-inherit::
+        child tasks do not inherit counters
 -p::
 --pid=<pid>::
         stat events on existing pid
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 6b77b28..0f467cf 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -54,7 +54,7 @@ static pid_t			target_tid			=     -1;
 static pid_t			*all_tids			=      NULL;
 static int			thread_num			=      0;
 static pid_t			child_pid			=     -1;
-static bool			inherit				=   true;
+static bool			no_inherit			=  false;
 static enum write_mode_t	write_mode			= WRITE_FORCE;
 static bool			call_graph			=  false;
 static bool			inherit_stat			=  false;
@@ -298,8 +298,8 @@ static void create_counter(int counter, int cpu)
 
 	attr->mmap		= track;
 	attr->comm		= track;
-	attr->inherit		= inherit;
-	if (target_pid == -1 && !system_wide) {
+	attr->inherit		= !no_inherit;
+	if (target_pid == -1 && target_tid == -1 && !system_wide) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
@@ -641,7 +641,7 @@ static int __cmd_record(int argc, const char **argv)
 		close(child_ready_pipe[0]);
 	}
 
-	if ((!system_wide && !inherit) || profile_cpu != -1) {
+	if ((!system_wide && no_inherit) || profile_cpu != -1) {
 		open_counters(profile_cpu);
 	} else {
 		nr_cpus = read_cpu_map();
@@ -821,8 +821,8 @@ static const struct option options[] = {
 		    "event period to sample"),
 	OPT_STRING('o', "output", &output_name, "file",
 		    "output file name"),
-	OPT_BOOLEAN('i', "inherit", &inherit,
-		    "child tasks inherit counters"),
+	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
+		    "child tasks do not inherit counters"),
 	OPT_INTEGER('F', "freq", &user_freq,
 		    "profile at this frequency"),
 	OPT_INTEGER('m', "mmap-pages", &mmap_pages,
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index e619ac8..ff8c413 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -72,7 +72,7 @@ static unsigned int		nr_cpus				=  0;
 static int			run_idx				=  0;
 
 static int			run_count			=  1;
-static bool			inherit				=  true;
+static bool			no_inherit			= false;
 static bool			scale				=  true;
 static pid_t			target_pid			= -1;
 static pid_t			target_tid			= -1;
@@ -167,8 +167,8 @@ static int create_perf_stat_counter(int counter)
 				++ncreated;
 		}
 	} else {
-		attr->inherit	     = inherit;
-		if (target_pid == -1) {
+		attr->inherit = !no_inherit;
+		if (target_pid == -1 && target_tid == -1) {
 			attr->disabled = 1;
 			attr->enable_on_exec = 1;
 		}
@@ -518,8 +518,8 @@ static const struct option options[] = {
 	OPT_CALLBACK('e', "event", NULL, "event",
 		     "event selector. use 'perf list' to list available events",
 		     parse_events),
-	OPT_BOOLEAN('i', "inherit", &inherit,
-		    "child tasks inherit counters"),
+	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
+		    "child tasks do not inherit counters"),
 	OPT_INTEGER('p', "pid", &target_pid,
 		    "stat events on existing process id"),
 	OPT_INTEGER('t', "tid", &target_tid,
-- 
1.6.2.5

