Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab1CJFW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 00:22:59 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:57256 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab1CJFWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 00:22:54 -0500
X-IronPort-AV: E=Sophos;i="4.62,294,1297036800"; 
   d="scan'208";a="318913072"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <daahern@cisco.com>
Subject: [PATCH 2/6] perf: remove print_graph_cpu and print_graph_proc from trace-event-parse
Date: Wed,  9 Mar 2011 22:23:24 -0700
Message-Id: <1299734608-5223-3-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299734608-5223-1-git-send-email-daahern@cisco.com>
References: <1299734608-5223-1-git-send-email-daahern@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Next patch moves printing of 'common' data into perf-script which
removes the need for these functions.

Signed-off-by: David Ahern <daahern@cisco.com>
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
1.7.4

