Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497Ab1COUGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:06:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53872 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758053Ab1COUF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 16:05:28 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Ahern <daahern@cisco.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/12] perf tracing: Remove print_graph_cpu and print_graph_proc from trace-event-parse
Date: Tue, 15 Mar 2011 17:04:56 -0300
Message-Id: <1300219501-15085-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1300219501-15085-1-git-send-email-acme@infradead.org>
References: <1300219501-15085-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <daahern@cisco.com>

Next patch moves printing of 'common' data into perf-script which
removes the need for these functions.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <1299734608-5223-3-git-send-email-daahern@cisco.com>
Signed-off-by: David Ahern <daahern@cisco.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-parse.c |   65 +---------------------------------
 1 files changed, 2 insertions(+), 63 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index d8e622d..dd5f058 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -2648,63 +2648,8 @@ static void print_lat_fmt(void *data, int size __unused)
 		printf("%d", lock_depth);
 }
 
-/* taken from Linux, written by Frederic Weisbecker */
-static void print_graph_cpu(int cpu)
-{
-	int i;
-	int log10_this = log10_cpu(cpu);
-	int log10_all = log10_cpu(cpus);
-
-
-	/*
-	 * Start with a space character - to make it stand out
-	 * to the right a bit when trace output is pasted into
-	 * email:
-	 */
-	printf(" ");
-
-	/*
-	 * Tricky - we space the CPU field according to the max
-	 * number of online CPUs. On a 2-cpu system it would take
-	 * a maximum of 1 digit - on a 128 cpu system it would
-	 * take up to 3 digits:
-	 */
-	for (i = 0; i < log10_all - log10_this; i++)
-		printf(" ");
-
-	printf("%d) ", cpu);
-}
-
-#define TRACE_GRAPH_PROCINFO_LENGTH	14
 #define TRACE_GRAPH_INDENT	2
 
-static void print_graph_proc(int pid, const char *comm)
-{
-	/* sign + log10(MAX_INT) + '\0' */
-	char pid_str[11];
-	int spaces = 0;
-	int len;
-	int i;
-
-	sprintf(pid_str, "%d", pid);
-
-	/* 1 stands for the "-" character */
-	len = strlen(comm) + strlen(pid_str) + 1;
-
-	if (len < TRACE_GRAPH_PROCINFO_LENGTH)
-		spaces = TRACE_GRAPH_PROCINFO_LENGTH - len;
-
-	/* First spaces to align center */
-	for (i = 0; i < spaces / 2; i++)
-		printf(" ");
-
-	printf("%s-%s", comm, pid_str);
-
-	/* Last spaces to align center */
-	for (i = 0; i < spaces - (spaces / 2); i++)
-		printf(" ");
-}
-
 static struct record *
 get_return_for_leaf(int cpu, int cur_pid, unsigned long long cur_func,
 		    struct record *next)
@@ -2876,7 +2821,7 @@ static void print_graph_nested(struct event *event, void *data)
 
 static void
 pretty_print_func_ent(void *data, int size, struct event *event,
-		      int cpu, int pid, const char *comm,
+		      int cpu, int pid, const char *comm __unused,
 		      unsigned long secs, unsigned long usecs)
 {
 	struct format_field *field;
@@ -2886,9 +2831,6 @@ pretty_print_func_ent(void *data, int size, struct event *event,
 
 	printf("%5lu.%06lu |  ", secs, usecs);
 
-	print_graph_cpu(cpu);
-	print_graph_proc(pid, comm);
-
 	printf(" | ");
 
 	if (latency_format) {
@@ -2924,7 +2866,7 @@ out_free:
 
 static void
 pretty_print_func_ret(void *data, int size __unused, struct event *event,
-		      int cpu, int pid, const char *comm,
+		      int cpu __unused, int pid __unused, const char *comm __unused,
 		      unsigned long secs, unsigned long usecs)
 {
 	unsigned long long rettime, calltime;
@@ -2934,9 +2876,6 @@ pretty_print_func_ret(void *data, int size __unused, struct event *event,
 
 	printf("%5lu.%06lu |  ", secs, usecs);
 
-	print_graph_cpu(cpu);
-	print_graph_proc(pid, comm);
-
 	printf(" | ");
 
 	if (latency_format) {
-- 
1.6.2.5

