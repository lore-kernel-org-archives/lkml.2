Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab1K1XPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:15:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:34327 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab1K1XPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:15:00 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 24/25] perf script: Add comm filtering option
Date: Mon, 28 Nov 2011 21:14:25 -0200
Message-Id: <1322522066-21879-25-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1322522066-21879-1-git-send-email-acme@infradead.org>
References: <1322522066-21879-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Allows collecting events system wide and then pulling out events for a
specific task name(s). e.g,

    perf script -c gnome-shell,gnome-terminal

Applies on top of:
    https://lkml.org/lkml/2011/11/13/74

v2->v3
- update Documentation

v1->v2
- use comm_list from symbol_conf

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1321894972-24246-1-git-send-email-dsahern@gmail.com
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-script.txt |    5 +++++
 tools/perf/builtin-script.c              |   12 ++++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index 3613b0a..7f61eaa 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -188,6 +188,11 @@ OPTIONS
 	CPUs are specified with -: 0-2. Default is to report samples on all
 	CPUs.
 
+-c::
+--comms=::
+	Only display events for these comms. CSV that understands
+	file://filename entries.
+
 -I::
 --show-info::
 	Display extended information about the perf.data file. This adds
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 7731a09..619d6dc 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -441,6 +441,7 @@ static int process_sample_event(struct perf_tool *tool __used,
 				struct perf_evsel *evsel,
 				struct machine *machine)
 {
+	struct addr_location al;
 	struct thread *thread = machine__findnew_thread(machine, event->ip.pid);
 
 	if (thread == NULL) {
@@ -460,6 +461,15 @@ static int process_sample_event(struct perf_tool *tool __used,
 		return 0;
 	}
 
+	if (perf_event__preprocess_sample(event, machine, &al, sample, 0) < 0) {
+		pr_err("problem processing %d event, skipping it.\n",
+		       event->header.type);
+		return -1;
+	}
+
+	if (al.filtered)
+		return 0;
+
 	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
 		return 0;
 
@@ -1086,6 +1096,8 @@ static const struct option options[] = {
 		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso,addr",
 		     parse_output_fields),
 	OPT_STRING('C', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
+	OPT_STRING('c', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
+		   "only display events for these comms"),
 	OPT_BOOLEAN('I', "show-info", &show_full_info,
 		    "display extended information from perf.data file"),
 	OPT_END()
-- 
1.7.8.rc0.35.gee6df

