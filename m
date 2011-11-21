Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab1KURDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 12:03:00 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48796 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab1KURC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 12:02:59 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH v3] perf script: Add comm filtering option
Date: Mon, 21 Nov 2011 10:02:52 -0700
Message-Id: <1321894972-24246-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows collecting events system wide and then pulling out events
for a specific task name(s). e.g,

    perf script -c gnome-shell,gnome-terminal

Applies on top of:
    https://lkml.org/lkml/2011/11/13/74

v2->v3
- update Documentation

v1->v2
- use comm_list from symbol_conf

Signed-off-by: David Ahern <dsahern@gmail.com>
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
index 01329ca..c170d39 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -440,6 +440,7 @@ static int process_sample_event(union perf_event *event,
 				struct perf_session *session)
 {
 	struct thread *thread = perf_session__findnew(session, event->ip.pid);
+	struct addr_location al;
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
@@ -458,6 +459,15 @@ static int process_sample_event(union perf_event *event,
 		return 0;
 	}
 
+	if (perf_event__preprocess_sample(event, session, &al, sample, 0) < 0) {
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
 
@@ -1084,6 +1094,8 @@ static const struct option options[] = {
 		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso,addr",
 		     parse_output_fields),
 	OPT_STRING('C', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
+	OPT_STRING('c', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
+		   "only display events for these comms"),
 	OPT_BOOLEAN('I', "show-info", &show_full_info,
 		    "display extended information from perf.data file"),
 	OPT_END()
-- 
1.7.7.1

