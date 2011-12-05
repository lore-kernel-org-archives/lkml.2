Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab1LENCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:02:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57079 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276Ab1LENCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:02:36 -0500
Date: Mon, 5 Dec 2011 05:01:41 -0800
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-e7984b7bee2fca8f582f5bc2bf1e6c93420a5dd5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1321894972-24246-1-git-send-email-dsahern@gmail.com>
References: <1321894972-24246-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Add comm filtering option
Git-Commit-ID: e7984b7bee2fca8f582f5bc2bf1e6c93420a5dd5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 05:01:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e7984b7bee2fca8f582f5bc2bf1e6c93420a5dd5
Gitweb:     http://git.kernel.org/tip/e7984b7bee2fca8f582f5bc2bf1e6c93420a5dd5
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Mon, 21 Nov 2011 10:02:52 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 Nov 2011 11:48:23 -0200

perf script: Add comm filtering option

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
