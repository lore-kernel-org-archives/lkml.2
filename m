Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab1E3O4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 10:56:09 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:51103 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab1E3O4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 10:56:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=xucaOpIaKRZNRmaun6J0S4G5M3yGoDhA+G2UlqZ4zp1rtDgCRq4EZimmef0LFZNCV9
         JTe47TCwV+lhZIcn8PU1cGYOF1WxavfB/KNTi4EshCKpWeT7Pw/vwOxceuvJ0ljiyo+Z
         +u1BRnTVZVRmQpnjr4nLr+f0QQmMoqRvqU7rY=
From: David Ahern <dsahern@gmail.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH v3] perf stat: clarify unsupported events from uncounted events
Date: Mon, 30 May 2011 08:55:59 -0600
Message-Id: <1306767359-13221-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf stat continues running even if the event list contains
counters that are not supported. The resulting output then
contains <not counted> for those events which gets confusing
as to which events are supported, but not counted and which
are not supported.

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

Signed-off-by: David Ahern <dsahern@gmail.com>
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
index f79bb2c..40dd4e7 100644
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
1.7.5.2

