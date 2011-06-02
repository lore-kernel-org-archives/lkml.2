Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab1FBU4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 16:56:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:36236 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab1FBU4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 16:56:48 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6/9] perf stat: clarify unsupported events from uncounted events
Date: Thu,  2 Jun 2011 17:56:33 -0300
Message-Id: <1307048196-16387-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1307048196-16387-1-git-send-email-acme@infradead.org>
References: <1307048196-16387-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

perf stat continues running even if the event list contains counters
that are not supported. The resulting output then contains <not counted>
for those events which gets confusing as to which events are supported,
but not counted and which are not supported.

Before:

perf stat -ddd -- sleep 1

      Performance counter stats for 'sleep 1':

          0.571283 task-clock                #    0.001 CPUs utilized
                 1 context-switches          #    0.002 M/sec
                 0 CPU-migrations            #    0.000 M/sec
               157 page-faults               #    0.275 M/sec
         1,037,707 cycles                    #    1.816 GHz
     <not counted> stalled-cycles-frontend
     <not counted> stalled-cycles-backend
           654,499 instructions              #    0.63  insns per cycle
           136,129 branches                  #  238.286 M/sec
     <not counted> branch-misses
     <not counted> L1-dcache-loads
     <not counted> L1-dcache-load-misses
     <not counted> LLC-loads
     <not counted> LLC-load-misses
     <not counted> L1-icache-loads
     <not counted> L1-icache-load-misses
     <not counted> dTLB-loads
     <not counted> dTLB-load-misses
     <not counted> iTLB-loads
     <not counted> iTLB-load-misses
     <not counted> L1-dcache-prefetches
     <not counted> L1-dcache-prefetch-misses

       1.001004836 seconds time elapsed

After:

perf stat -ddd -- sleep 1

 Performance counter stats for 'sleep 1':

          1.350326 task-clock                #    0.001 CPUs utilized
                 2 context-switches          #    0.001 M/sec
                 0 CPU-migrations            #    0.000 M/sec
               157 page-faults               #    0.116 M/sec
            11,986 cycles                    #    0.009 GHz
   <not supported> stalled-cycles-frontend
   <not supported> stalled-cycles-backend
           496,986 instructions              #   41.46  insns per cycle
           138,065 branches                  #  102.246 M/sec
             7,245 branch-misses             #    5.25% of all branches
     <not counted> L1-dcache-loads
     <not counted> L1-dcache-load-misses
     <not counted> LLC-loads
     <not counted> LLC-load-misses
     <not counted> L1-icache-loads
     <not counted> L1-icache-load-misses
     <not counted> dTLB-loads
     <not counted> dTLB-load-misses
     <not counted> iTLB-loads
     <not counted> iTLB-load-misses
     <not counted> L1-dcache-prefetches
   <not supported> L1-dcache-prefetch-misses

       1.002397333 seconds time elapsed

v1->v2:
changed supported type from int to bool

v2->v3
fixed vertical alignment of new struct element

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1306767359-13221-1-git-send-email-dsahern@gmail.com
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |    9 +++++++--
 tools/perf/util/evsel.h   |    1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index a9f0671..784ed6d 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -61,6 +61,8 @@
 #include <locale.h>
 
 #define DEFAULT_SEPARATOR	" "
+#define CNTR_NOT_SUPPORTED	"<not supported>"
+#define CNTR_NOT_COUNTED	"<not counted>"
 
 static struct perf_event_attr default_attrs[] = {
 
@@ -448,6 +450,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 				if (verbose)
 					ui__warning("%s event is not supported by the kernel.\n",
 						    event_name(counter));
+				counter->supported = false;
 				continue;
 			}
 
@@ -466,6 +469,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 			die("Not all events could be opened.\n");
 			return -1;
 		}
+		counter->supported = true;
 	}
 
 	if (perf_evlist__set_filters(evsel_list)) {
@@ -861,7 +865,7 @@ static void print_counter_aggr(struct perf_evsel *counter)
 	if (scaled == -1) {
 		fprintf(stderr, "%*s%s%*s",
 			csv_output ? 0 : 18,
-			"<not counted>",
+			counter->supported ? CNTR_NOT_COUNTED : CNTR_NOT_SUPPORTED,
 			csv_sep,
 			csv_output ? 0 : -24,
 			event_name(counter));
@@ -914,7 +918,8 @@ static void print_counter(struct perf_evsel *counter)
 				csv_output ? 0 : -4,
 				evsel_list->cpus->map[cpu], csv_sep,
 				csv_output ? 0 : 18,
-				"<not counted>", csv_sep,
+				counter->supported ? CNTR_NOT_COUNTED : CNTR_NOT_SUPPORTED,
+				csv_sep,
 				csv_output ? 0 : -24,
 				event_name(counter));
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 7e9366e..e9a3155 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -61,6 +61,7 @@ struct perf_evsel {
 		off_t		id_offset;
 	};
 	struct cgroup_sel	*cgrp;
+	bool 			supported;
 };
 
 struct cpu_map;
-- 
1.6.2.5

