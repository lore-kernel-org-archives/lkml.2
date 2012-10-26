Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933675Ab2JZPKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:10:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54927 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab2JZPKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:10:42 -0400
Date: Fri, 26 Oct 2012 08:10:22 -0700
From: tip-bot for Andrew Vagin <avagin@openvz.org>
Message-ID: <tip-26a031e136f4f8dc82c64df48cca0eb3b5d3eb4f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, avagin@openvz.org, fweisbec@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, avagin@openvz.org
In-Reply-To: <1344344165-369636-4-git-send-email-avagin@openvz.org>
References: <1344344165-369636-4-git-send-email-avagin@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf inject:
  Merge sched_stat_* and sched_switch events
Git-Commit-ID: 26a031e136f4f8dc82c64df48cca0eb3b5d3eb4f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 26 Oct 2012 08:10:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26a031e136f4f8dc82c64df48cca0eb3b5d3eb4f
Gitweb:     http://git.kernel.org/tip/26a031e136f4f8dc82c64df48cca0eb3b5d3eb4f
Author:     Andrew Vagin <avagin@openvz.org>
AuthorDate: Tue, 7 Aug 2012 16:56:04 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 26 Oct 2012 11:22:25 -0200

perf inject: Merge sched_stat_* and sched_switch events

You may want to know where and how long a task is sleeping. A callchain
may be found in sched_switch and a time slice in stat_iowait, so I add
handler in perf inject for merging this events.

My code saves sched_switch event for each process and when it meets
stat_iowait, it reports the sched_switch event, because this event
contains a correct callchain. By another words it replaces all
stat_iowait events on proper sched_switch events.

I use the next sequence of commands for testing:

  perf record -e sched:sched_stat_sleep -e sched:sched_switch \
	      -e sched:sched_process_exit -g -o ~/perf.data.raw \
	      ~/test-program
  perf inject -v -s -i ~/perf.data.raw -o ~/perf.data
  perf report --stdio -i ~/perf.data
   100.00%	foo  [kernel.kallsyms]  [k] __schedule
               	|
                --- __schedule
                    schedule
                   |
                   |--79.75%-- schedule_hrtimeout_range_clock
                   |          schedule_hrtimeout_range
                   |          poll_schedule_timeout
                   |          do_select
                   |          core_sys_select
                   |          sys_select
                   |          system_call_fastpath
                   |          __select
                   |          __libc_start_main
                   |
                    --20.25%-- do_nanosleep
                              hrtimer_nanosleep
                              sys_nanosleep
                              system_call_fastpath
                              __GI___libc_nanosleep
                              __libc_start_main

 And here is test-program.c:

 #include<unistd.h>
 #include<time.h>
 #include<sys/select.h>

 int main()
 {
	struct timespec ts1;
	struct timeval tv1;
	int i;
	long s;

	for (i = 0; i <  10; i++) {
		ts1.tv_sec = 0;
		ts1.tv_nsec = 10000000;
		nanosleep(&ts1, NULL);

		tv1.tv_sec = 0;
		tv1.tv_usec = 40000;
		select(0, NULL, NULL, NULL,&tv1);
	}
	return 1;
 }

Signed-off-by: Andrew Vagin <avagin@openvz.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1344344165-369636-4-git-send-email-avagin@openvz.org
[ committer note: Made it use evsel->handler ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-inject.txt |    5 +
 tools/perf/builtin-inject.c              |  142 +++++++++++++++++++++++++++++-
 2 files changed, 144 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-inject.txt b/tools/perf/Documentation/perf-inject.txt
index 673ef97..a00a342 100644
--- a/tools/perf/Documentation/perf-inject.txt
+++ b/tools/perf/Documentation/perf-inject.txt
@@ -35,6 +35,11 @@ OPTIONS
 -o::
 --output=::
 	Output file name. (default: stdout)
+-s::
+--sched-stat::
+	Merge sched_stat and sched_switch for getting events where and how long
+	tasks slept. sched_switch contains a callchain where a task slept and
+	sched_stat contains a timeslice how long a task slept.
 
 SEE ALSO
 --------
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index a706ed5..a4a3072 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -8,19 +8,32 @@
 #include "builtin.h"
 
 #include "perf.h"
+#include "util/color.h"
+#include "util/evlist.h"
+#include "util/evsel.h"
 #include "util/session.h"
 #include "util/tool.h"
 #include "util/debug.h"
 
 #include "util/parse-options.h"
 
+#include <linux/list.h>
+
 struct perf_inject {
 	struct perf_tool tool;
 	bool		 build_ids;
+	bool		 sched_stat;
 	const char	 *input_name;
 	int		 pipe_output,
 			 output;
 	u64		 bytes_written;
+	struct list_head samples;
+};
+
+struct event_entry {
+	struct list_head node;
+	u32		 tid;
+	union perf_event event[0];
 };
 
 static int perf_event__repipe_synth(struct perf_tool *tool,
@@ -86,12 +99,23 @@ static int perf_event__repipe(struct perf_tool *tool,
 	return perf_event__repipe_synth(tool, event, machine);
 }
 
+typedef int (*inject_handler)(struct perf_tool *tool,
+			      union perf_event *event,
+			      struct perf_sample *sample,
+			      struct perf_evsel *evsel,
+			      struct machine *machine);
+
 static int perf_event__repipe_sample(struct perf_tool *tool,
 				     union perf_event *event,
-			      struct perf_sample *sample __maybe_unused,
-			      struct perf_evsel *evsel __maybe_unused,
-			      struct machine *machine)
+				     struct perf_sample *sample,
+				     struct perf_evsel *evsel,
+				     struct machine *machine)
 {
+	if (evsel->handler.func) {
+		inject_handler f = evsel->handler.func;
+		return f(tool, event, sample, evsel, machine);
+	}
+
 	return perf_event__repipe_synth(tool, event, machine);
 }
 
@@ -216,6 +240,79 @@ repipe:
 	return 0;
 }
 
+static int perf_inject__sched_process_exit(struct perf_tool *tool,
+					   union perf_event *event __maybe_unused,
+					   struct perf_sample *sample,
+					   struct perf_evsel *evsel __maybe_unused,
+					   struct machine *machine __maybe_unused)
+{
+	struct perf_inject *inject = container_of(tool, struct perf_inject, tool);
+	struct event_entry *ent;
+
+	list_for_each_entry(ent, &inject->samples, node) {
+		if (sample->tid == ent->tid) {
+			list_del_init(&ent->node);
+			free(ent);
+			break;
+		}
+	}
+
+	return 0;
+}
+
+static int perf_inject__sched_switch(struct perf_tool *tool,
+				     union perf_event *event,
+				     struct perf_sample *sample,
+				     struct perf_evsel *evsel,
+				     struct machine *machine)
+{
+	struct perf_inject *inject = container_of(tool, struct perf_inject, tool);
+	struct event_entry *ent;
+
+	perf_inject__sched_process_exit(tool, event, sample, evsel, machine);
+
+	ent = malloc(event->header.size + sizeof(struct event_entry));
+	if (ent == NULL) {
+		color_fprintf(stderr, PERF_COLOR_RED,
+			     "Not enough memory to process sched switch event!");
+		return -1;
+	}
+
+	ent->tid = sample->tid;
+	memcpy(&ent->event, event, event->header.size);
+	list_add(&ent->node, &inject->samples);
+	return 0;
+}
+
+static int perf_inject__sched_stat(struct perf_tool *tool,
+				   union perf_event *event __maybe_unused,
+				   struct perf_sample *sample,
+				   struct perf_evsel *evsel,
+				   struct machine *machine)
+{
+	struct event_entry *ent;
+	union perf_event *event_sw;
+	struct perf_sample sample_sw;
+	struct perf_inject *inject = container_of(tool, struct perf_inject, tool);
+	u32 pid = perf_evsel__intval(evsel, sample, "pid");
+
+	list_for_each_entry(ent, &inject->samples, node) {
+		if (pid == ent->tid)
+			goto found;
+	}
+
+	return 0;
+found:
+	event_sw = &ent->event[0];
+	perf_evsel__parse_sample(evsel, event_sw, &sample_sw);
+
+	sample_sw.period = sample->period;
+	sample_sw.time	 = sample->time;
+	perf_event__synthesize_sample(event_sw, evsel->attr.sample_type,
+				      &sample_sw, false);
+	return perf_event__repipe(tool, event_sw, &sample_sw, machine);
+}
+
 extern volatile int session_done;
 
 static void sig_handler(int sig __maybe_unused)
@@ -223,6 +320,21 @@ static void sig_handler(int sig __maybe_unused)
 	session_done = 1;
 }
 
+static int perf_evsel__check_stype(struct perf_evsel *evsel,
+				   u64 sample_type, const char *sample_msg)
+{
+	struct perf_event_attr *attr = &evsel->attr;
+	const char *name = perf_evsel__name(evsel);
+
+	if (!(attr->sample_type & sample_type)) {
+		pr_err("Samples for %s event do not have %s attribute set.",
+			name, sample_msg);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int __cmd_inject(struct perf_inject *inject)
 {
 	struct perf_session *session;
@@ -241,6 +353,26 @@ static int __cmd_inject(struct perf_inject *inject)
 	if (session == NULL)
 		return -ENOMEM;
 
+	if (inject->sched_stat) {
+		struct perf_evsel *evsel;
+
+		inject->tool.ordered_samples = true;
+
+		list_for_each_entry(evsel, &session->evlist->entries, node) {
+			const char *name = perf_evsel__name(evsel);
+
+			if (!strcmp(name, "sched:sched_switch")) {
+				if (perf_evsel__check_stype(evsel, PERF_SAMPLE_TID, "TID"))
+					return -EINVAL;
+
+				evsel->handler.func = perf_inject__sched_switch;
+			} else if (!strcmp(name, "sched:sched_process_exit"))
+				evsel->handler.func = perf_inject__sched_process_exit;
+			else if (!strncmp(name, "sched:sched_stat_", 17))
+				evsel->handler.func = perf_inject__sched_stat;
+		}
+	}
+
 	if (!inject->pipe_output)
 		lseek(inject->output, session->header.data_offset, SEEK_SET);
 
@@ -275,6 +407,7 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 			.build_id	= perf_event__repipe_op2_synth,
 		},
 		.input_name  = "-",
+		.samples = LIST_HEAD_INIT(inject.samples),
 	};
 	const char *output_name = "-";
 	const struct option options[] = {
@@ -284,6 +417,9 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 			   "input file name"),
 		OPT_STRING('o', "output", &output_name, "file",
 			   "output file name"),
+		OPT_BOOLEAN('s', "sched-stat", &inject.sched_stat,
+			    "Merge sched-stat and sched-switch for getting events "
+			    "where and how long tasks slept"),
 		OPT_INCR('v', "verbose", &verbose,
 			 "be more verbose (show build ids, etc)"),
 		OPT_END()
