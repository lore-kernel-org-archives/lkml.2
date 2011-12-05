Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab1LENAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:00:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57033 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab1LENAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:00:48 -0500
Date: Mon, 5 Dec 2011 04:59:23 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-qgpc4msetqlwr8y2k7537cxe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Rename perf_event_ops to perf_tool
Git-Commit-ID: 45694aa7702bc44d538a3bcb51bb2bb96cf190c0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 04:59:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45694aa7702bc44d538a3bcb51bb2bb96cf190c0
Gitweb:     http://git.kernel.org/tip/45694aa7702bc44d538a3bcb51bb2bb96cf190c0
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 28 Nov 2011 08:30:20 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 Nov 2011 10:39:28 -0200

perf tools: Rename perf_event_ops to perf_tool

To better reflect that it became the base class for all tools, that must
be in each tool struct and where common stuff will be put.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-qgpc4msetqlwr8y2k7537cxe@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile            |    1 +
 tools/perf/builtin-annotate.c  |   13 ++--
 tools/perf/builtin-diff.c      |   11 ++-
 tools/perf/builtin-inject.c    |   55 +++++++-------
 tools/perf/builtin-kmem.c      |    9 +-
 tools/perf/builtin-lock.c      |    5 +-
 tools/perf/builtin-record.c    |   35 +++++----
 tools/perf/builtin-report.c    |   17 ++--
 tools/perf/builtin-sched.c     |    9 +-
 tools/perf/builtin-script.c    |    9 +-
 tools/perf/builtin-timechart.c |   15 ++--
 tools/perf/builtin-top.c       |    6 +-
 tools/perf/util/build-id.c     |    7 +-
 tools/perf/util/build-id.h     |    2 +-
 tools/perf/util/event.c        |   54 +++++++-------
 tools/perf/util/event.h        |   22 +++---
 tools/perf/util/header.c       |   28 ++++----
 tools/perf/util/header.h       |   16 ++--
 tools/perf/util/session.c      |  163 ++++++++++++++++++++--------------------
 tools/perf/util/session.h      |   49 ++----------
 tools/perf/util/tool.h         |   45 +++++++++++
 tools/perf/util/top.h          |    7 +-
 22 files changed, 301 insertions(+), 277 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b98e307..ac86d67 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -278,6 +278,7 @@ LIB_H += util/strbuf.h
 LIB_H += util/strlist.h
 LIB_H += util/strfilter.h
 LIB_H += util/svghelper.h
+LIB_H += util/tool.h
 LIB_H += util/run-command.h
 LIB_H += util/sigchain.h
 LIB_H += util/symbol.h
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index dff081a..c01139f 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -27,11 +27,12 @@
 #include "util/sort.h"
 #include "util/hist.h"
 #include "util/session.h"
+#include "util/tool.h"
 
 #include <linux/bitmap.h>
 
 struct perf_annotate {
-	struct perf_event_ops ops;
+	struct perf_tool tool;
 	char const *input_name;
 	bool	   force, use_tui, use_stdio;
 	bool	   full_paths;
@@ -79,13 +80,13 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 	return ret;
 }
 
-static int process_sample_event(struct perf_event_ops *ops,
+static int process_sample_event(struct perf_tool *tool,
 				union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_evsel *evsel,
 				struct machine *machine)
 {
-	struct perf_annotate *ann = container_of(ops, struct perf_annotate, ops);
+	struct perf_annotate *ann = container_of(tool, struct perf_annotate, tool);
 	struct addr_location al;
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample,
@@ -174,7 +175,7 @@ static int __cmd_annotate(struct perf_annotate *ann)
 	u64 total_nr_samples;
 
 	session = perf_session__new(ann->input_name, O_RDONLY,
-				    ann->force, false, &ann->ops);
+				    ann->force, false, &ann->tool);
 	if (session == NULL)
 		return -ENOMEM;
 
@@ -185,7 +186,7 @@ static int __cmd_annotate(struct perf_annotate *ann)
 			goto out_delete;
 	}
 
-	ret = perf_session__process_events(session, &ann->ops);
+	ret = perf_session__process_events(session, &ann->tool);
 	if (ret)
 		goto out_delete;
 
@@ -241,7 +242,7 @@ static const char * const annotate_usage[] = {
 int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 {
 	struct perf_annotate annotate = {
-		.ops = {
+		.tool = {
 			.sample	= process_sample_event,
 			.mmap	= perf_event__process_mmap,
 			.comm	= perf_event__process_comm,
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 478b0ae..4f19513 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -11,6 +11,7 @@
 #include "util/hist.h"
 #include "util/evsel.h"
 #include "util/session.h"
+#include "util/tool.h"
 #include "util/sort.h"
 #include "util/symbol.h"
 #include "util/util.h"
@@ -31,7 +32,7 @@ static int hists__add_entry(struct hists *self,
 	return -ENOMEM;
 }
 
-static int diff__process_sample_event(struct perf_event_ops *ops __used,
+static int diff__process_sample_event(struct perf_tool *tool __used,
 				      union perf_event *event,
 				      struct perf_sample *sample,
 				      struct perf_evsel *evsel __used,
@@ -57,7 +58,7 @@ static int diff__process_sample_event(struct perf_event_ops *ops __used,
 	return 0;
 }
 
-static struct perf_event_ops event_ops = {
+static struct perf_tool perf_diff = {
 	.sample	= diff__process_sample_event,
 	.mmap	= perf_event__process_mmap,
 	.comm	= perf_event__process_comm,
@@ -147,13 +148,13 @@ static int __cmd_diff(void)
 	int ret, i;
 	struct perf_session *session[2];
 
-	session[0] = perf_session__new(input_old, O_RDONLY, force, false, &event_ops);
-	session[1] = perf_session__new(input_new, O_RDONLY, force, false, &event_ops);
+	session[0] = perf_session__new(input_old, O_RDONLY, force, false, &perf_diff);
+	session[1] = perf_session__new(input_new, O_RDONLY, force, false, &perf_diff);
 	if (session[0] == NULL || session[1] == NULL)
 		return -ENOMEM;
 
 	for (i = 0; i < 2; ++i) {
-		ret = perf_session__process_events(session[i], &event_ops);
+		ret = perf_session__process_events(session[i], &perf_diff);
 		if (ret)
 			goto out_delete;
 	}
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index a5bcf81..09c1061 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -9,6 +9,7 @@
 
 #include "perf.h"
 #include "util/session.h"
+#include "util/tool.h"
 #include "util/debug.h"
 
 #include "util/parse-options.h"
@@ -16,7 +17,7 @@
 static char		const *input_name = "-";
 static bool		inject_build_ids;
 
-static int perf_event__repipe_synth(struct perf_event_ops *ops __used,
+static int perf_event__repipe_synth(struct perf_tool *tool __used,
 				    union perf_event *event,
 				    struct machine *machine __used)
 {
@@ -37,17 +38,17 @@ static int perf_event__repipe_synth(struct perf_event_ops *ops __used,
 	return 0;
 }
 
-static int perf_event__repipe_op2_synth(struct perf_event_ops *ops,
+static int perf_event__repipe_op2_synth(struct perf_tool *tool,
 					union perf_event *event,
 					struct perf_session *session __used)
 {
-	return perf_event__repipe_synth(ops, event, NULL);
+	return perf_event__repipe_synth(tool, event, NULL);
 }
 
-static int perf_event__repipe_event_type_synth(struct perf_event_ops *ops,
+static int perf_event__repipe_event_type_synth(struct perf_tool *tool,
 					       union perf_event *event)
 {
-	return perf_event__repipe_synth(ops, event, NULL);
+	return perf_event__repipe_synth(tool, event, NULL);
 }
 
 static int perf_event__repipe_tracing_data_synth(union perf_event *event,
@@ -62,45 +63,45 @@ static int perf_event__repipe_attr(union perf_event *event,
 	return perf_event__repipe_synth(NULL, event, NULL);
 }
 
-static int perf_event__repipe(struct perf_event_ops *ops,
+static int perf_event__repipe(struct perf_tool *tool,
 			      union perf_event *event,
 			      struct perf_sample *sample __used,
 			      struct machine *machine)
 {
-	return perf_event__repipe_synth(ops, event, machine);
+	return perf_event__repipe_synth(tool, event, machine);
 }
 
-static int perf_event__repipe_sample(struct perf_event_ops *ops,
+static int perf_event__repipe_sample(struct perf_tool *tool,
 				     union perf_event *event,
 			      struct perf_sample *sample __used,
 			      struct perf_evsel *evsel __used,
 			      struct machine *machine)
 {
-	return perf_event__repipe_synth(ops, event, machine);
+	return perf_event__repipe_synth(tool, event, machine);
 }
 
-static int perf_event__repipe_mmap(struct perf_event_ops *ops,
+static int perf_event__repipe_mmap(struct perf_tool *tool,
 				   union perf_event *event,
 				   struct perf_sample *sample,
 				   struct machine *machine)
 {
 	int err;
 
-	err = perf_event__process_mmap(ops, event, sample, machine);
-	perf_event__repipe(ops, event, sample, machine);
+	err = perf_event__process_mmap(tool, event, sample, machine);
+	perf_event__repipe(tool, event, sample, machine);
 
 	return err;
 }
 
-static int perf_event__repipe_task(struct perf_event_ops *ops,
+static int perf_event__repipe_task(struct perf_tool *tool,
 				   union perf_event *event,
 				   struct perf_sample *sample,
 				   struct machine *machine)
 {
 	int err;
 
-	err = perf_event__process_task(ops, event, sample, machine);
-	perf_event__repipe(ops, event, sample, machine);
+	err = perf_event__process_task(tool, event, sample, machine);
+	perf_event__repipe(tool, event, sample, machine);
 
 	return err;
 }
@@ -130,7 +131,7 @@ static int dso__read_build_id(struct dso *self)
 	return -1;
 }
 
-static int dso__inject_build_id(struct dso *self, struct perf_event_ops *ops,
+static int dso__inject_build_id(struct dso *self, struct perf_tool *tool,
 				struct machine *machine)
 {
 	u16 misc = PERF_RECORD_MISC_USER;
@@ -144,7 +145,7 @@ static int dso__inject_build_id(struct dso *self, struct perf_event_ops *ops,
 	if (self->kernel)
 		misc = PERF_RECORD_MISC_KERNEL;
 
-	err = perf_event__synthesize_build_id(ops, self, misc, perf_event__repipe,
+	err = perf_event__synthesize_build_id(tool, self, misc, perf_event__repipe,
 					      machine);
 	if (err) {
 		pr_err("Can't synthesize build_id event for %s\n", self->long_name);
@@ -154,7 +155,7 @@ static int dso__inject_build_id(struct dso *self, struct perf_event_ops *ops,
 	return 0;
 }
 
-static int perf_event__inject_buildid(struct perf_event_ops *ops,
+static int perf_event__inject_buildid(struct perf_tool *tool,
 				      union perf_event *event,
 				      struct perf_sample *sample,
 				      struct perf_evsel *evsel __used,
@@ -180,7 +181,7 @@ static int perf_event__inject_buildid(struct perf_event_ops *ops,
 		if (!al.map->dso->hit) {
 			al.map->dso->hit = 1;
 			if (map__load(al.map, NULL) >= 0) {
-				dso__inject_build_id(al.map->dso, ops, machine);
+				dso__inject_build_id(al.map->dso, tool, machine);
 				/*
 				 * If this fails, too bad, let the other side
 				 * account this as unresolved.
@@ -193,11 +194,11 @@ static int perf_event__inject_buildid(struct perf_event_ops *ops,
 	}
 
 repipe:
-	perf_event__repipe(ops, event, sample, machine);
+	perf_event__repipe(tool, event, sample, machine);
 	return 0;
 }
 
-struct perf_event_ops inject_ops = {
+struct perf_tool perf_inject = {
 	.sample		= perf_event__repipe_sample,
 	.mmap		= perf_event__repipe,
 	.comm		= perf_event__repipe,
@@ -228,17 +229,17 @@ static int __cmd_inject(void)
 	signal(SIGINT, sig_handler);
 
 	if (inject_build_ids) {
-		inject_ops.sample	= perf_event__inject_buildid;
-		inject_ops.mmap		= perf_event__repipe_mmap;
-		inject_ops.fork		= perf_event__repipe_task;
-		inject_ops.tracing_data	= perf_event__repipe_tracing_data;
+		perf_inject.sample	 = perf_event__inject_buildid;
+		perf_inject.mmap	 = perf_event__repipe_mmap;
+		perf_inject.fork	 = perf_event__repipe_task;
+		perf_inject.tracing_data = perf_event__repipe_tracing_data;
 	}
 
-	session = perf_session__new(input_name, O_RDONLY, false, true, &inject_ops);
+	session = perf_session__new(input_name, O_RDONLY, false, true, &perf_inject);
 	if (session == NULL)
 		return -ENOMEM;
 
-	ret = perf_session__process_events(session, &inject_ops);
+	ret = perf_session__process_events(session, &perf_inject);
 
 	perf_session__delete(session);
 
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 27b2a15..886174e 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -7,6 +7,7 @@
 #include "util/thread.h"
 #include "util/header.h"
 #include "util/session.h"
+#include "util/tool.h"
 
 #include "util/parse-options.h"
 #include "util/trace-event.h"
@@ -303,7 +304,7 @@ static void process_raw_event(union perf_event *raw_event __used, void *data,
 	}
 }
 
-static int process_sample_event(struct perf_event_ops *ops __used,
+static int process_sample_event(struct perf_tool *tool __used,
 				union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_evsel *evsel __used,
@@ -325,7 +326,7 @@ static int process_sample_event(struct perf_event_ops *ops __used,
 	return 0;
 }
 
-static struct perf_event_ops event_ops = {
+static struct perf_tool perf_kmem = {
 	.sample			= process_sample_event,
 	.comm			= perf_event__process_comm,
 	.ordered_samples	= true,
@@ -484,7 +485,7 @@ static int __cmd_kmem(void)
 {
 	int err = -EINVAL;
 	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
-							 0, false, &event_ops);
+							 0, false, &perf_kmem);
 	if (session == NULL)
 		return -ENOMEM;
 
@@ -495,7 +496,7 @@ static int __cmd_kmem(void)
 		goto out_delete;
 
 	setup_pager();
-	err = perf_session__process_events(session, &event_ops);
+	err = perf_session__process_events(session, &perf_kmem);
 	if (err != 0)
 		goto out_delete;
 	sort_result();
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 99b032a..4db5e52 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -12,6 +12,7 @@
 
 #include "util/debug.h"
 #include "util/session.h"
+#include "util/tool.h"
 
 #include <sys/types.h>
 #include <sys/prctl.h>
@@ -845,7 +846,7 @@ static void dump_info(void)
 		die("Unknown type of information\n");
 }
 
-static int process_sample_event(struct perf_event_ops *ops __used,
+static int process_sample_event(struct perf_tool *tool __used,
 				union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_evsel *evsel __used,
@@ -864,7 +865,7 @@ static int process_sample_event(struct perf_event_ops *ops __used,
 	return 0;
 }
 
-static struct perf_event_ops eops = {
+static struct perf_tool eops = {
 	.sample			= process_sample_event,
 	.comm			= perf_event__process_comm,
 	.ordered_samples	= true,
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0af598a..7d4fdaa 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -22,6 +22,7 @@
 #include "util/evsel.h"
 #include "util/debug.h"
 #include "util/session.h"
+#include "util/tool.h"
 #include "util/symbol.h"
 #include "util/cpumap.h"
 #include "util/thread_map.h"
@@ -36,7 +37,7 @@ enum write_mode_t {
 };
 
 struct perf_record {
-	struct perf_event_ops	ops;
+	struct perf_tool	tool;
 	struct perf_record_opts	opts;
 	u64			bytes_written;
 	const char		*output_name;
@@ -76,12 +77,12 @@ static void write_output(struct perf_record *rec, void *buf, size_t size)
 	}
 }
 
-static int process_synthesized_event(struct perf_event_ops *ops,
+static int process_synthesized_event(struct perf_tool *tool,
 				     union perf_event *event,
 				     struct perf_sample *sample __used,
 				     struct machine *machine __used)
 {
-	struct perf_record *rec = container_of(ops, struct perf_record, ops);
+	struct perf_record *rec = container_of(tool, struct perf_record, tool);
 	write_output(rec, event, event->header.size);
 	return 0;
 }
@@ -319,7 +320,7 @@ static void perf_record__exit(int status __used, void *arg)
 static void perf_event__synthesize_guest_os(struct machine *machine, void *data)
 {
 	int err;
-	struct perf_event_ops *ops = data;
+	struct perf_tool *tool = data;
 
 	if (machine__is_host(machine))
 		return;
@@ -332,7 +333,7 @@ static void perf_event__synthesize_guest_os(struct machine *machine, void *data)
 	 *method is used to avoid symbol missing when the first addr is
 	 *in module instead of in guest kernel.
 	 */
-	err = perf_event__synthesize_modules(ops, process_synthesized_event,
+	err = perf_event__synthesize_modules(tool, process_synthesized_event,
 					     machine);
 	if (err < 0)
 		pr_err("Couldn't record guest kernel [%d]'s reference"
@@ -342,10 +343,10 @@ static void perf_event__synthesize_guest_os(struct machine *machine, void *data)
 	 * We use _stext for guest kernel because guest kernel's /proc/kallsyms
 	 * have no _text sometimes.
 	 */
-	err = perf_event__synthesize_kernel_mmap(ops, process_synthesized_event,
+	err = perf_event__synthesize_kernel_mmap(tool, process_synthesized_event,
 						 machine, "_text");
 	if (err < 0)
-		err = perf_event__synthesize_kernel_mmap(ops, process_synthesized_event,
+		err = perf_event__synthesize_kernel_mmap(tool, process_synthesized_event,
 							 machine, "_stext");
 	if (err < 0)
 		pr_err("Couldn't record guest kernel [%d]'s reference"
@@ -378,7 +379,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	unsigned long waking = 0;
 	const bool forks = argc > 0;
 	struct machine *machine;
-	struct perf_event_ops *ops = &rec->ops;
+	struct perf_tool *tool = &rec->tool;
 	struct perf_record_opts *opts = &rec->opts;
 	struct perf_evlist *evsel_list = rec->evlist;
 	const char *output_name = rec->output_name;
@@ -501,14 +502,14 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	}
 
 	if (opts->pipe_output) {
-		err = perf_event__synthesize_attrs(ops, session,
+		err = perf_event__synthesize_attrs(tool, session,
 						   process_synthesized_event);
 		if (err < 0) {
 			pr_err("Couldn't synthesize attrs.\n");
 			return err;
 		}
 
-		err = perf_event__synthesize_event_types(ops, process_synthesized_event,
+		err = perf_event__synthesize_event_types(tool, process_synthesized_event,
 							 machine);
 		if (err < 0) {
 			pr_err("Couldn't synthesize event_types.\n");
@@ -524,7 +525,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 			 * return this more properly and also
 			 * propagate errors that now are calling die()
 			 */
-			err = perf_event__synthesize_tracing_data(ops, output, evsel_list,
+			err = perf_event__synthesize_tracing_data(tool, output, evsel_list,
 								  process_synthesized_event);
 			if (err <= 0) {
 				pr_err("Couldn't record tracing data.\n");
@@ -534,17 +535,17 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		}
 	}
 
-	err = perf_event__synthesize_kernel_mmap(ops, process_synthesized_event,
+	err = perf_event__synthesize_kernel_mmap(tool, process_synthesized_event,
 						 machine, "_text");
 	if (err < 0)
-		err = perf_event__synthesize_kernel_mmap(ops, process_synthesized_event,
+		err = perf_event__synthesize_kernel_mmap(tool, process_synthesized_event,
 							 machine, "_stext");
 	if (err < 0)
 		pr_err("Couldn't record kernel reference relocation symbol\n"
 		       "Symbol resolution may be skewed if relocation was used (e.g. kexec).\n"
 		       "Check /proc/kallsyms permission or run as root.\n");
 
-	err = perf_event__synthesize_modules(ops, process_synthesized_event,
+	err = perf_event__synthesize_modules(tool, process_synthesized_event,
 					     machine);
 	if (err < 0)
 		pr_err("Couldn't record kernel module information.\n"
@@ -552,15 +553,15 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		       "Check /proc/modules permission or run as root.\n");
 
 	if (perf_guest)
-		perf_session__process_machines(session, ops,
+		perf_session__process_machines(session, tool,
 					       perf_event__synthesize_guest_os);
 
 	if (!opts->system_wide)
-		perf_event__synthesize_thread_map(ops, evsel_list->threads,
+		perf_event__synthesize_thread_map(tool, evsel_list->threads,
 						  process_synthesized_event,
 						  machine);
 	else
-		perf_event__synthesize_threads(ops, process_synthesized_event,
+		perf_event__synthesize_threads(tool, process_synthesized_event,
 					       machine);
 
 	if (rec->realtime_prio) {
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ea64fbb..eef8e42 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -25,6 +25,7 @@
 #include "util/evsel.h"
 #include "util/header.h"
 #include "util/session.h"
+#include "util/tool.h"
 
 #include "util/parse-options.h"
 #include "util/parse-events.h"
@@ -36,7 +37,7 @@
 #include <linux/bitmap.h>
 
 struct perf_report {
-	struct perf_event_ops	ops;
+	struct perf_tool	tool;
 	struct perf_session	*session;
 	char const		*input_name;
 	bool			force, use_tui, use_stdio;
@@ -103,13 +104,13 @@ out:
 }
 
 
-static int process_sample_event(struct perf_event_ops *ops,
+static int process_sample_event(struct perf_tool *tool,
 				union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_evsel *evsel,
 				struct machine *machine)
 {
-	struct perf_report *rep = container_of(ops, struct perf_report, ops);
+	struct perf_report *rep = container_of(tool, struct perf_report, tool);
 	struct addr_location al;
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample,
@@ -136,13 +137,13 @@ static int process_sample_event(struct perf_event_ops *ops,
 	return 0;
 }
 
-static int process_read_event(struct perf_event_ops *ops,
+static int process_read_event(struct perf_tool *tool,
 			      union perf_event *event,
 			      struct perf_sample *sample __used,
 			      struct perf_evsel *evsel,
 			      struct machine *machine __used)
 {
-	struct perf_report *rep = container_of(ops, struct perf_report, ops);
+	struct perf_report *rep = container_of(tool, struct perf_report, tool);
 
 	if (rep->show_threads) {
 		const char *name = evsel ? event_name(evsel) : "unknown";
@@ -254,7 +255,7 @@ static int __cmd_report(struct perf_report *rep)
 	signal(SIGINT, sig_handler);
 
 	session = perf_session__new(rep->input_name, O_RDONLY,
-				    rep->force, false, &rep->ops);
+				    rep->force, false, &rep->tool);
 	if (session == NULL)
 		return -ENOMEM;
 
@@ -277,7 +278,7 @@ static int __cmd_report(struct perf_report *rep)
 	if (ret)
 		goto out_delete;
 
-	ret = perf_session__process_events(session, &rep->ops);
+	ret = perf_session__process_events(session, &rep->tool);
 	if (ret)
 		goto out_delete;
 
@@ -435,7 +436,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 		NULL
 	};
 	struct perf_report report = {
-		.ops = {
+		.tool = {
 			.sample		 = process_sample_event,
 			.mmap		 = perf_event__process_mmap,
 			.comm		 = perf_event__process_comm,
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 6a771f8..0ee868e 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -8,6 +8,7 @@
 #include "util/thread.h"
 #include "util/header.h"
 #include "util/session.h"
+#include "util/tool.h"
 
 #include "util/parse-options.h"
 #include "util/trace-event.h"
@@ -1602,7 +1603,7 @@ static void process_raw_event(union perf_event *raw_event __used,
 		process_sched_migrate_task_event(data, machine, event, cpu, timestamp, thread);
 }
 
-static int process_sample_event(struct perf_event_ops *ops __used,
+static int process_sample_event(struct perf_tool *tool __used,
 				union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_evsel *evsel,
@@ -1631,7 +1632,7 @@ static int process_sample_event(struct perf_event_ops *ops __used,
 	return 0;
 }
 
-static struct perf_event_ops event_ops = {
+static struct perf_tool perf_sched = {
 	.sample			= process_sample_event,
 	.comm			= perf_event__process_comm,
 	.lost			= perf_event__process_lost,
@@ -1643,12 +1644,12 @@ static void read_events(bool destroy, struct perf_session **psession)
 {
 	int err = -EINVAL;
 	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
-							 0, false, &event_ops);
+							 0, false, &perf_sched);
 	if (session == NULL)
 		die("No Memory");
 
 	if (perf_session__has_traces(session, "record -R")) {
-		err = perf_session__process_events(session, &event_ops);
+		err = perf_session__process_events(session, &perf_sched);
 		if (err)
 			die("Failed to process events, error %d", err);
 
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 31a8d14..5f8afc6 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -7,6 +7,7 @@
 #include "util/header.h"
 #include "util/parse-options.h"
 #include "util/session.h"
+#include "util/tool.h"
 #include "util/symbol.h"
 #include "util/thread.h"
 #include "util/trace-event.h"
@@ -434,7 +435,7 @@ static int cleanup_scripting(void)
 
 static char const		*input_name = "perf.data";
 
-static int process_sample_event(struct perf_event_ops *ops __used,
+static int process_sample_event(struct perf_tool *tool __used,
 				union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_evsel *evsel,
@@ -468,7 +469,7 @@ static int process_sample_event(struct perf_event_ops *ops __used,
 	return 0;
 }
 
-static struct perf_event_ops event_ops = {
+static struct perf_tool perf_script = {
 	.sample		 = process_sample_event,
 	.mmap		 = perf_event__process_mmap,
 	.comm		 = perf_event__process_comm,
@@ -495,7 +496,7 @@ static int __cmd_script(struct perf_session *session)
 
 	signal(SIGINT, sig_handler);
 
-	ret = perf_session__process_events(session, &event_ops);
+	ret = perf_session__process_events(session, &perf_script);
 
 	if (debug_mode)
 		pr_err("Misordered timestamps: %" PRIu64 "\n", nr_unordered);
@@ -1262,7 +1263,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 	if (!script_name)
 		setup_pager();
 
-	session = perf_session__new(input_name, O_RDONLY, 0, false, &event_ops);
+	session = perf_session__new(input_name, O_RDONLY, 0, false, &perf_script);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 8e65396..135376a 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -32,6 +32,7 @@
 #include "util/event.h"
 #include "util/session.h"
 #include "util/svghelper.h"
+#include "util/tool.h"
 
 #define SUPPORT_OLD_POWER_EVENTS 1
 #define PWR_EVENT_EXIT -1
@@ -274,7 +275,7 @@ static int cpus_cstate_state[MAX_CPUS];
 static u64 cpus_pstate_start_times[MAX_CPUS];
 static u64 cpus_pstate_state[MAX_CPUS];
 
-static int process_comm_event(struct perf_event_ops *ops __used,
+static int process_comm_event(struct perf_tool *tool __used,
 			      union perf_event *event,
 			      struct perf_sample *sample __used,
 			      struct machine *machine __used)
@@ -283,7 +284,7 @@ static int process_comm_event(struct perf_event_ops *ops __used,
 	return 0;
 }
 
-static int process_fork_event(struct perf_event_ops *ops __used,
+static int process_fork_event(struct perf_tool *tool __used,
 			      union perf_event *event,
 			      struct perf_sample *sample __used,
 			      struct machine *machine __used)
@@ -292,7 +293,7 @@ static int process_fork_event(struct perf_event_ops *ops __used,
 	return 0;
 }
 
-static int process_exit_event(struct perf_event_ops *ops __used,
+static int process_exit_event(struct perf_tool *tool __used,
 			      union perf_event *event,
 			      struct perf_sample *sample __used,
 			      struct machine *machine __used)
@@ -490,7 +491,7 @@ static void sched_switch(int cpu, u64 timestamp, struct trace_entry *te)
 }
 
 
-static int process_sample_event(struct perf_event_ops *ops __used,
+static int process_sample_event(struct perf_tool *tool __used,
 				union perf_event *event __used,
 				struct perf_sample *sample,
 				struct perf_evsel *evsel,
@@ -979,7 +980,7 @@ static void write_svg_file(const char *filename)
 	svg_close();
 }
 
-static struct perf_event_ops event_ops = {
+static struct perf_tool perf_timechart = {
 	.comm			= process_comm_event,
 	.fork			= process_fork_event,
 	.exit			= process_exit_event,
@@ -990,7 +991,7 @@ static struct perf_event_ops event_ops = {
 static int __cmd_timechart(void)
 {
 	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
-							 0, false, &event_ops);
+							 0, false, &perf_timechart);
 	int ret = -EINVAL;
 
 	if (session == NULL)
@@ -999,7 +1000,7 @@ static int __cmd_timechart(void)
 	if (!perf_session__has_traces(session, "timechart record"))
 		goto out_delete;
 
-	ret = perf_session__process_events(session, &event_ops);
+	ret = perf_session__process_events(session, &perf_timechart);
 	if (ret)
 		goto out_delete;
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 31d4973..42a7d96 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -826,7 +826,7 @@ static void perf_session__mmap_read_idx(struct perf_session *self, int idx)
 			perf_event__process_sample(event, evsel, &sample, machine);
 		else if (event->header.type < PERF_RECORD_MAX) {
 			hists__inc_nr_events(&evsel->hists, event->header.type);
-			perf_event__process(&top.ops, event, &sample, machine);
+			perf_event__process(&top.tool, event, &sample, machine);
 		} else
 			++self->hists.stats.nr_unknown_events;
 	}
@@ -968,11 +968,11 @@ static int __cmd_top(void)
 		goto out_delete;
 
 	if (top.target_tid != -1)
-		perf_event__synthesize_thread_map(&top.ops, top.evlist->threads,
+		perf_event__synthesize_thread_map(&top.tool, top.evlist->threads,
 						  perf_event__process,
 						  &top.session->host_machine);
 	else
-		perf_event__synthesize_threads(&top.ops, perf_event__process,
+		perf_event__synthesize_threads(&top.tool, perf_event__process,
 					       &top.session->host_machine);
 	start_counters(top.evlist);
 	top.session->evlist = top.evlist;
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 2f84c48..dff9c7a 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -14,8 +14,9 @@
 #include <linux/kernel.h>
 #include "debug.h"
 #include "session.h"
+#include "tool.h"
 
-static int build_id__mark_dso_hit(struct perf_event_ops *ops __used,
+static int build_id__mark_dso_hit(struct perf_tool *tool __used,
 				  union perf_event *event,
 				  struct perf_sample *sample __used,
 				  struct perf_evsel *evsel __used,
@@ -40,7 +41,7 @@ static int build_id__mark_dso_hit(struct perf_event_ops *ops __used,
 	return 0;
 }
 
-static int perf_event__exit_del_thread(struct perf_event_ops *ops __used,
+static int perf_event__exit_del_thread(struct perf_tool *tool __used,
 				       union perf_event *event,
 				       struct perf_sample *sample __used,
 				       struct machine *machine)
@@ -59,7 +60,7 @@ static int perf_event__exit_del_thread(struct perf_event_ops *ops __used,
 	return 0;
 }
 
-struct perf_event_ops build_id__mark_dso_hit_ops = {
+struct perf_tool build_id__mark_dso_hit_ops = {
 	.sample	= build_id__mark_dso_hit,
 	.mmap	= perf_event__process_mmap,
 	.fork	= perf_event__process_task,
diff --git a/tools/perf/util/build-id.h b/tools/perf/util/build-id.h
index 5dafb00..a993ba8 100644
--- a/tools/perf/util/build-id.h
+++ b/tools/perf/util/build-id.h
@@ -3,7 +3,7 @@
 
 #include "session.h"
 
-extern struct perf_event_ops build_id__mark_dso_hit_ops;
+extern struct perf_tool build_id__mark_dso_hit_ops;
 
 char *dso__build_id_filename(struct dso *self, char *bf, size_t size);
 
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 0cdc811..0ebbe76 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -43,7 +43,7 @@ static struct perf_sample synth_sample = {
 	.period	   = 1,
 };
 
-static pid_t perf_event__synthesize_comm(struct perf_event_ops *ops,
+static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
 					 union perf_event *event, pid_t pid,
 					 int full, perf_event__handler_t process,
 					 struct machine *machine)
@@ -99,7 +99,7 @@ out_race:
 	if (!full) {
 		event->comm.tid = pid;
 
-		process(ops, event, &synth_sample, machine);
+		process(tool, event, &synth_sample, machine);
 		goto out;
 	}
 
@@ -117,7 +117,7 @@ out_race:
 
 		event->comm.tid = pid;
 
-		process(ops, event, &synth_sample, machine);
+		process(tool, event, &synth_sample, machine);
 	}
 
 	closedir(tasks);
@@ -127,7 +127,7 @@ out:
 	return tgid;
 }
 
-static int perf_event__synthesize_mmap_events(struct perf_event_ops *ops,
+static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 					      union perf_event *event,
 					      pid_t pid, pid_t tgid,
 					      perf_event__handler_t process,
@@ -199,7 +199,7 @@ static int perf_event__synthesize_mmap_events(struct perf_event_ops *ops,
 			event->mmap.pid = tgid;
 			event->mmap.tid = pid;
 
-			process(ops, event, &synth_sample, machine);
+			process(tool, event, &synth_sample, machine);
 		}
 	}
 
@@ -207,7 +207,7 @@ static int perf_event__synthesize_mmap_events(struct perf_event_ops *ops,
 	return 0;
 }
 
-int perf_event__synthesize_modules(struct perf_event_ops *ops,
+int perf_event__synthesize_modules(struct perf_tool *tool,
 				   perf_event__handler_t process,
 				   struct machine *machine)
 {
@@ -252,7 +252,7 @@ int perf_event__synthesize_modules(struct perf_event_ops *ops,
 
 		memcpy(event->mmap.filename, pos->dso->long_name,
 		       pos->dso->long_name_len + 1);
-		process(ops, event, &synth_sample, machine);
+		process(tool, event, &synth_sample, machine);
 	}
 
 	free(event);
@@ -262,18 +262,18 @@ int perf_event__synthesize_modules(struct perf_event_ops *ops,
 static int __event__synthesize_thread(union perf_event *comm_event,
 				      union perf_event *mmap_event,
 				      pid_t pid, perf_event__handler_t process,
-				      struct perf_event_ops *ops,
+				      struct perf_tool *tool,
 				      struct machine *machine)
 {
-	pid_t tgid = perf_event__synthesize_comm(ops, comm_event, pid, 1,
+	pid_t tgid = perf_event__synthesize_comm(tool, comm_event, pid, 1,
 						 process, machine);
 	if (tgid == -1)
 		return -1;
-	return perf_event__synthesize_mmap_events(ops, mmap_event, pid, tgid,
+	return perf_event__synthesize_mmap_events(tool, mmap_event, pid, tgid,
 						  process, machine);
 }
 
-int perf_event__synthesize_thread_map(struct perf_event_ops *ops,
+int perf_event__synthesize_thread_map(struct perf_tool *tool,
 				      struct thread_map *threads,
 				      perf_event__handler_t process,
 				      struct machine *machine)
@@ -293,7 +293,7 @@ int perf_event__synthesize_thread_map(struct perf_event_ops *ops,
 	for (thread = 0; thread < threads->nr; ++thread) {
 		if (__event__synthesize_thread(comm_event, mmap_event,
 					       threads->map[thread],
-					       process, ops, machine)) {
+					       process, tool, machine)) {
 			err = -1;
 			break;
 		}
@@ -305,7 +305,7 @@ out:
 	return err;
 }
 
-int perf_event__synthesize_threads(struct perf_event_ops *ops,
+int perf_event__synthesize_threads(struct perf_tool *tool,
 				   perf_event__handler_t process,
 				   struct machine *machine)
 {
@@ -334,7 +334,7 @@ int perf_event__synthesize_threads(struct perf_event_ops *ops,
 			continue;
 
 		__event__synthesize_thread(comm_event, mmap_event, pid,
-					   process, ops, machine);
+					   process, tool, machine);
 	}
 
 	closedir(proc);
@@ -369,7 +369,7 @@ static int find_symbol_cb(void *arg, const char *name, char type,
 	return 1;
 }
 
-int perf_event__synthesize_kernel_mmap(struct perf_event_ops *ops,
+int perf_event__synthesize_kernel_mmap(struct perf_tool *tool,
 				       perf_event__handler_t process,
 				       struct machine *machine,
 				       const char *symbol_name)
@@ -427,13 +427,13 @@ int perf_event__synthesize_kernel_mmap(struct perf_event_ops *ops,
 	event->mmap.len   = map->end - event->mmap.start;
 	event->mmap.pid   = machine->pid;
 
-	err = process(ops, event, &synth_sample, machine);
+	err = process(tool, event, &synth_sample, machine);
 	free(event);
 
 	return err;
 }
 
-int perf_event__process_comm(struct perf_event_ops *ops __used,
+int perf_event__process_comm(struct perf_tool *tool __used,
 			     union perf_event *event,
 			     struct perf_sample *sample __used,
 			     struct machine *machine)
@@ -450,7 +450,7 @@ int perf_event__process_comm(struct perf_event_ops *ops __used,
 	return 0;
 }
 
-int perf_event__process_lost(struct perf_event_ops *ops __used,
+int perf_event__process_lost(struct perf_tool *tool __used,
 			     union perf_event *event,
 			     struct perf_sample *sample __used,
 			     struct machine *machine __used)
@@ -473,7 +473,7 @@ static void perf_event__set_kernel_mmap_len(union perf_event *event,
 		maps[MAP__FUNCTION]->end = ~0ULL;
 }
 
-static int perf_event__process_kernel_mmap(struct perf_event_ops *ops __used,
+static int perf_event__process_kernel_mmap(struct perf_tool *tool __used,
 					   union perf_event *event,
 					   struct machine *machine)
 {
@@ -566,7 +566,7 @@ out_problem:
 	return -1;
 }
 
-int perf_event__process_mmap(struct perf_event_ops *ops,
+int perf_event__process_mmap(struct perf_tool *tool,
 			     union perf_event *event,
 			     struct perf_sample *sample __used,
 			     struct machine *machine)
@@ -582,7 +582,7 @@ int perf_event__process_mmap(struct perf_event_ops *ops,
 
 	if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL ||
 	    cpumode == PERF_RECORD_MISC_KERNEL) {
-		ret = perf_event__process_kernel_mmap(ops, event, machine);
+		ret = perf_event__process_kernel_mmap(tool, event, machine);
 		if (ret < 0)
 			goto out_problem;
 		return 0;
@@ -606,7 +606,7 @@ out_problem:
 	return 0;
 }
 
-int perf_event__process_task(struct perf_event_ops *ops __used,
+int perf_event__process_task(struct perf_tool *tool __used,
 			     union perf_event *event,
 			     struct perf_sample *sample __used,
 			      struct machine *machine)
@@ -631,22 +631,22 @@ int perf_event__process_task(struct perf_event_ops *ops __used,
 	return 0;
 }
 
-int perf_event__process(struct perf_event_ops *ops, union perf_event *event,
+int perf_event__process(struct perf_tool *tool, union perf_event *event,
 			struct perf_sample *sample, struct machine *machine)
 {
 	switch (event->header.type) {
 	case PERF_RECORD_COMM:
-		perf_event__process_comm(ops, event, sample, machine);
+		perf_event__process_comm(tool, event, sample, machine);
 		break;
 	case PERF_RECORD_MMAP:
-		perf_event__process_mmap(ops, event, sample, machine);
+		perf_event__process_mmap(tool, event, sample, machine);
 		break;
 	case PERF_RECORD_FORK:
 	case PERF_RECORD_EXIT:
-		perf_event__process_task(ops, event, sample, machine);
+		perf_event__process_task(tool, event, sample, machine);
 		break;
 	case PERF_RECORD_LOST:
-		perf_event__process_lost(ops, event, sample, machine);
+		perf_event__process_lost(tool, event, sample, machine);
 	default:
 		break;
 	}
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 1564877..d8499e7 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -141,47 +141,47 @@ union perf_event {
 
 void perf_event__print_totals(void);
 
-struct perf_event_ops;
+struct perf_tool;
 struct thread_map;
 
-typedef int (*perf_event__handler_t)(struct perf_event_ops *ops,
+typedef int (*perf_event__handler_t)(struct perf_tool *tool,
 				     union perf_event *event,
 				     struct perf_sample *sample,
 				     struct machine *machine);
 
-int perf_event__synthesize_thread_map(struct perf_event_ops *ops,
+int perf_event__synthesize_thread_map(struct perf_tool *tool,
 				      struct thread_map *threads,
 				      perf_event__handler_t process,
 				      struct machine *machine);
-int perf_event__synthesize_threads(struct perf_event_ops *ops,
+int perf_event__synthesize_threads(struct perf_tool *tool,
 				   perf_event__handler_t process,
 				   struct machine *machine);
-int perf_event__synthesize_kernel_mmap(struct perf_event_ops *ops,
+int perf_event__synthesize_kernel_mmap(struct perf_tool *tool,
 				       perf_event__handler_t process,
 				       struct machine *machine,
 				       const char *symbol_name);
 
-int perf_event__synthesize_modules(struct perf_event_ops *ops,
+int perf_event__synthesize_modules(struct perf_tool *tool,
 				   perf_event__handler_t process,
 				   struct machine *machine);
 
-int perf_event__process_comm(struct perf_event_ops *ops,
+int perf_event__process_comm(struct perf_tool *tool,
 			     union perf_event *event,
 			     struct perf_sample *sample,
 			     struct machine *machine);
-int perf_event__process_lost(struct perf_event_ops *ops,
+int perf_event__process_lost(struct perf_tool *tool,
 			     union perf_event *event,
 			     struct perf_sample *sample,
 			     struct machine *machine);
-int perf_event__process_mmap(struct perf_event_ops *ops,
+int perf_event__process_mmap(struct perf_tool *tool,
 			     union perf_event *event,
 			     struct perf_sample *sample,
 			     struct machine *machine);
-int perf_event__process_task(struct perf_event_ops *ops,
+int perf_event__process_task(struct perf_tool *tool,
 			     union perf_event *event,
 			     struct perf_sample *sample,
 			     struct machine *machine);
-int perf_event__process(struct perf_event_ops *ops,
+int perf_event__process(struct perf_tool *tool,
 			union perf_event *event,
 			struct perf_sample *sample,
 			struct machine *machine);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index db280d6..9272f3a 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2070,7 +2070,7 @@ out_delete_evlist:
 	return -ENOMEM;
 }
 
-int perf_event__synthesize_attr(struct perf_event_ops *ops,
+int perf_event__synthesize_attr(struct perf_tool *tool,
 				struct perf_event_attr *attr, u16 ids, u64 *id,
 				perf_event__handler_t process)
 {
@@ -2094,14 +2094,14 @@ int perf_event__synthesize_attr(struct perf_event_ops *ops,
 	ev->attr.header.type = PERF_RECORD_HEADER_ATTR;
 	ev->attr.header.size = size;
 
-	err = process(ops, ev, NULL, NULL);
+	err = process(tool, ev, NULL, NULL);
 
 	free(ev);
 
 	return err;
 }
 
-int perf_event__synthesize_attrs(struct perf_event_ops *ops,
+int perf_event__synthesize_attrs(struct perf_tool *tool,
 				   struct perf_session *session,
 				   perf_event__handler_t process)
 {
@@ -2109,7 +2109,7 @@ int perf_event__synthesize_attrs(struct perf_event_ops *ops,
 	int err = 0;
 
 	list_for_each_entry(attr, &session->evlist->entries, node) {
-		err = perf_event__synthesize_attr(ops, &attr->attr, attr->ids,
+		err = perf_event__synthesize_attr(tool, &attr->attr, attr->ids,
 						  attr->id, process);
 		if (err) {
 			pr_debug("failed to create perf header attribute\n");
@@ -2157,7 +2157,7 @@ int perf_event__process_attr(union perf_event *event,
 	return 0;
 }
 
-int perf_event__synthesize_event_type(struct perf_event_ops *ops,
+int perf_event__synthesize_event_type(struct perf_tool *tool,
 				      u64 event_id, char *name,
 				      perf_event__handler_t process,
 				      struct machine *machine)
@@ -2178,12 +2178,12 @@ int perf_event__synthesize_event_type(struct perf_event_ops *ops,
 	ev.event_type.header.size = sizeof(ev.event_type) -
 		(sizeof(ev.event_type.event_type.name) - size);
 
-	err = process(ops, &ev, NULL, machine);
+	err = process(tool, &ev, NULL, machine);
 
 	return err;
 }
 
-int perf_event__synthesize_event_types(struct perf_event_ops *ops,
+int perf_event__synthesize_event_types(struct perf_tool *tool,
 				       perf_event__handler_t process,
 				       struct machine *machine)
 {
@@ -2193,7 +2193,7 @@ int perf_event__synthesize_event_types(struct perf_event_ops *ops,
 	for (i = 0; i < event_count; i++) {
 		type = &events[i];
 
-		err = perf_event__synthesize_event_type(ops, type->event_id,
+		err = perf_event__synthesize_event_type(tool, type->event_id,
 							type->name, process,
 							machine);
 		if (err) {
@@ -2205,7 +2205,7 @@ int perf_event__synthesize_event_types(struct perf_event_ops *ops,
 	return err;
 }
 
-int perf_event__process_event_type(struct perf_event_ops *ops __unused,
+int perf_event__process_event_type(struct perf_tool *tool __unused,
 				   union perf_event *event)
 {
 	if (perf_header__push_event(event->event_type.event_type.event_id,
@@ -2215,7 +2215,7 @@ int perf_event__process_event_type(struct perf_event_ops *ops __unused,
 	return 0;
 }
 
-int perf_event__synthesize_tracing_data(struct perf_event_ops *ops, int fd,
+int perf_event__synthesize_tracing_data(struct perf_tool *tool, int fd,
 					struct perf_evlist *evlist,
 					perf_event__handler_t process)
 {
@@ -2248,7 +2248,7 @@ int perf_event__synthesize_tracing_data(struct perf_event_ops *ops, int fd,
 	ev.tracing_data.header.size = sizeof(ev.tracing_data);
 	ev.tracing_data.size = aligned_size;
 
-	process(ops, &ev, NULL, NULL);
+	process(tool, &ev, NULL, NULL);
 
 	/*
 	 * The put function will copy all the tracing data
@@ -2290,7 +2290,7 @@ int perf_event__process_tracing_data(union perf_event *event,
 	return size_read + padding;
 }
 
-int perf_event__synthesize_build_id(struct perf_event_ops *ops,
+int perf_event__synthesize_build_id(struct perf_tool *tool,
 				    struct dso *pos, u16 misc,
 				    perf_event__handler_t process,
 				    struct machine *machine)
@@ -2313,12 +2313,12 @@ int perf_event__synthesize_build_id(struct perf_event_ops *ops,
 	ev.build_id.header.size = sizeof(ev.build_id) + len;
 	memcpy(&ev.build_id.filename, pos->long_name, pos->long_name_len);
 
-	err = process(ops, &ev, NULL, machine);
+	err = process(tool, &ev, NULL, machine);
 
 	return err;
 }
 
-int perf_event__process_build_id(struct perf_event_ops *ops __used,
+int perf_event__process_build_id(struct perf_tool *tool __used,
 				 union perf_event *event,
 				 struct perf_session *session)
 {
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index a604962..09365b3 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -97,35 +97,35 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 			  const char *name, bool is_kallsyms);
 int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir);
 
-int perf_event__synthesize_attr(struct perf_event_ops *ops,
+int perf_event__synthesize_attr(struct perf_tool *tool,
 				struct perf_event_attr *attr, u16 ids, u64 *id,
 				perf_event__handler_t process);
-int perf_event__synthesize_attrs(struct perf_event_ops *ops,
+int perf_event__synthesize_attrs(struct perf_tool *tool,
 				 struct perf_session *session,
 				 perf_event__handler_t process);
 int perf_event__process_attr(union perf_event *event, struct perf_evlist **pevlist);
 
-int perf_event__synthesize_event_type(struct perf_event_ops *ops,
+int perf_event__synthesize_event_type(struct perf_tool *tool,
 				      u64 event_id, char *name,
 				      perf_event__handler_t process,
 				      struct machine *machine);
-int perf_event__synthesize_event_types(struct perf_event_ops *ops,
+int perf_event__synthesize_event_types(struct perf_tool *tool,
 				       perf_event__handler_t process,
 				       struct machine *machine);
-int perf_event__process_event_type(struct perf_event_ops *ops,
+int perf_event__process_event_type(struct perf_tool *tool,
 				   union perf_event *event);
 
-int perf_event__synthesize_tracing_data(struct perf_event_ops *ops,
+int perf_event__synthesize_tracing_data(struct perf_tool *tool,
 					int fd, struct perf_evlist *evlist,
 					perf_event__handler_t process);
 int perf_event__process_tracing_data(union perf_event *event,
 				     struct perf_session *session);
 
-int perf_event__synthesize_build_id(struct perf_event_ops *ops,
+int perf_event__synthesize_build_id(struct perf_tool *tool,
 				    struct dso *pos, u16 misc,
 				    perf_event__handler_t process,
 				    struct machine *machine);
-int perf_event__process_build_id(struct perf_event_ops *ops,
+int perf_event__process_build_id(struct perf_tool *tool,
 				 union perf_event *event,
 				 struct perf_session *session);
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index be33606..7d15908 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -10,6 +10,7 @@
 #include "evlist.h"
 #include "evsel.h"
 #include "session.h"
+#include "tool.h"
 #include "sort.h"
 #include "util.h"
 #include "cpumap.h"
@@ -104,7 +105,7 @@ static void perf_session__destroy_kernel_maps(struct perf_session *self)
 
 struct perf_session *perf_session__new(const char *filename, int mode,
 				       bool force, bool repipe,
-				       struct perf_event_ops *ops)
+				       struct perf_tool *tool)
 {
 	size_t len = filename ? strlen(filename) + 1 : 0;
 	struct perf_session *self = zalloc(sizeof(*self) + len);
@@ -142,10 +143,10 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 			goto out_delete;
 	}
 
-	if (ops && ops->ordering_requires_timestamps &&
-	    ops->ordered_samples && !self->sample_id_all) {
+	if (tool && tool->ordering_requires_timestamps &&
+	    tool->ordered_samples && !self->sample_id_all) {
 		dump_printf("WARNING: No sample_id_all support, falling back to unordered processing\n");
-		ops->ordered_samples = false;
+		tool->ordered_samples = false;
 	}
 
 out:
@@ -285,7 +286,7 @@ static int process_event_synth_attr_stub(union perf_event *event __used,
 	return 0;
 }
 
-static int process_event_sample_stub(struct perf_event_ops *ops __used,
+static int process_event_sample_stub(struct perf_tool *tool __used,
 				     union perf_event *event __used,
 				     struct perf_sample *sample __used,
 				     struct perf_evsel *evsel __used,
@@ -295,7 +296,7 @@ static int process_event_sample_stub(struct perf_event_ops *ops __used,
 	return 0;
 }
 
-static int process_event_stub(struct perf_event_ops *ops __used,
+static int process_event_stub(struct perf_tool *tool __used,
 			      union perf_event *event __used,
 			      struct perf_sample *sample __used,
 			      struct machine *machine __used)
@@ -304,7 +305,7 @@ static int process_event_stub(struct perf_event_ops *ops __used,
 	return 0;
 }
 
-static int process_finished_round_stub(struct perf_event_ops *ops __used,
+static int process_finished_round_stub(struct perf_tool *tool __used,
 				       union perf_event *event __used,
 				       struct perf_session *perf_session __used)
 {
@@ -312,50 +313,50 @@ static int process_finished_round_stub(struct perf_event_ops *ops __used,
 	return 0;
 }
 
-static int process_event_type_stub(struct perf_event_ops *ops __used,
+static int process_event_type_stub(struct perf_tool *tool __used,
 				   union perf_event *event __used)
 {
 	dump_printf(": unhandled!\n");
 	return 0;
 }
 
-static int process_finished_round(struct perf_event_ops *ops,
+static int process_finished_round(struct perf_tool *tool,
 				  union perf_event *event,
 				  struct perf_session *session);
 
-static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
+static void perf_tool__fill_defaults(struct perf_tool *tool)
 {
-	if (handler->sample == NULL)
-		handler->sample = process_event_sample_stub;
-	if (handler->mmap == NULL)
-		handler->mmap = process_event_stub;
-	if (handler->comm == NULL)
-		handler->comm = process_event_stub;
-	if (handler->fork == NULL)
-		handler->fork = process_event_stub;
-	if (handler->exit == NULL)
-		handler->exit = process_event_stub;
-	if (handler->lost == NULL)
-		handler->lost = perf_event__process_lost;
-	if (handler->read == NULL)
-		handler->read = process_event_sample_stub;
-	if (handler->throttle == NULL)
-		handler->throttle = process_event_stub;
-	if (handler->unthrottle == NULL)
-		handler->unthrottle = process_event_stub;
-	if (handler->attr == NULL)
-		handler->attr = process_event_synth_attr_stub;
-	if (handler->event_type == NULL)
-		handler->event_type = process_event_type_stub;
-	if (handler->tracing_data == NULL)
-		handler->tracing_data = process_event_synth_tracing_data_stub;
-	if (handler->build_id == NULL)
-		handler->build_id = process_finished_round_stub;
-	if (handler->finished_round == NULL) {
-		if (handler->ordered_samples)
-			handler->finished_round = process_finished_round;
+	if (tool->sample == NULL)
+		tool->sample = process_event_sample_stub;
+	if (tool->mmap == NULL)
+		tool->mmap = process_event_stub;
+	if (tool->comm == NULL)
+		tool->comm = process_event_stub;
+	if (tool->fork == NULL)
+		tool->fork = process_event_stub;
+	if (tool->exit == NULL)
+		tool->exit = process_event_stub;
+	if (tool->lost == NULL)
+		tool->lost = perf_event__process_lost;
+	if (tool->read == NULL)
+		tool->read = process_event_sample_stub;
+	if (tool->throttle == NULL)
+		tool->throttle = process_event_stub;
+	if (tool->unthrottle == NULL)
+		tool->unthrottle = process_event_stub;
+	if (tool->attr == NULL)
+		tool->attr = process_event_synth_attr_stub;
+	if (tool->event_type == NULL)
+		tool->event_type = process_event_type_stub;
+	if (tool->tracing_data == NULL)
+		tool->tracing_data = process_event_synth_tracing_data_stub;
+	if (tool->build_id == NULL)
+		tool->build_id = process_finished_round_stub;
+	if (tool->finished_round == NULL) {
+		if (tool->ordered_samples)
+			tool->finished_round = process_finished_round;
 		else
-			handler->finished_round = process_finished_round_stub;
+			tool->finished_round = process_finished_round_stub;
 	}
 }
 
@@ -487,11 +488,11 @@ static void perf_session_free_sample_buffers(struct perf_session *session)
 static int perf_session_deliver_event(struct perf_session *session,
 				      union perf_event *event,
 				      struct perf_sample *sample,
-				      struct perf_event_ops *ops,
+				      struct perf_tool *tool,
 				      u64 file_offset);
 
 static void flush_sample_queue(struct perf_session *s,
-			       struct perf_event_ops *ops)
+			       struct perf_tool *tool)
 {
 	struct ordered_samples *os = &s->ordered_samples;
 	struct list_head *head = &os->samples;
@@ -502,7 +503,7 @@ static void flush_sample_queue(struct perf_session *s,
 	unsigned idx = 0, progress_next = os->nr_samples / 16;
 	int ret;
 
-	if (!ops->ordered_samples || !limit)
+	if (!tool->ordered_samples || !limit)
 		return;
 
 	list_for_each_entry_safe(iter, tmp, head, list) {
@@ -513,7 +514,7 @@ static void flush_sample_queue(struct perf_session *s,
 		if (ret)
 			pr_err("Can't parse sample, err = %d\n", ret);
 		else
-			perf_session_deliver_event(s, iter->event, &sample, ops,
+			perf_session_deliver_event(s, iter->event, &sample, tool,
 						   iter->file_offset);
 
 		os->last_flush = iter->timestamp;
@@ -575,11 +576,11 @@ static void flush_sample_queue(struct perf_session *s,
  *      Flush every events below timestamp 7
  *      etc...
  */
-static int process_finished_round(struct perf_event_ops *ops,
+static int process_finished_round(struct perf_tool *tool,
 				  union perf_event *event __used,
 				  struct perf_session *session)
 {
-	flush_sample_queue(session, ops);
+	flush_sample_queue(session, tool);
 	session->ordered_samples.next_flush = session->ordered_samples.max_timestamp;
 
 	return 0;
@@ -749,7 +750,7 @@ static struct machine *
 static int perf_session_deliver_event(struct perf_session *session,
 				      union perf_event *event,
 				      struct perf_sample *sample,
-				      struct perf_event_ops *ops,
+				      struct perf_tool *tool,
 				      u64 file_offset)
 {
 	struct perf_evsel *evsel;
@@ -784,25 +785,25 @@ static int perf_session_deliver_event(struct perf_session *session,
 			++session->hists.stats.nr_unknown_id;
 			return -1;
 		}
-		return ops->sample(ops, event, sample, evsel, machine);
+		return tool->sample(tool, event, sample, evsel, machine);
 	case PERF_RECORD_MMAP:
-		return ops->mmap(ops, event, sample, machine);
+		return tool->mmap(tool, event, sample, machine);
 	case PERF_RECORD_COMM:
-		return ops->comm(ops, event, sample, machine);
+		return tool->comm(tool, event, sample, machine);
 	case PERF_RECORD_FORK:
-		return ops->fork(ops, event, sample, machine);
+		return tool->fork(tool, event, sample, machine);
 	case PERF_RECORD_EXIT:
-		return ops->exit(ops, event, sample, machine);
+		return tool->exit(tool, event, sample, machine);
 	case PERF_RECORD_LOST:
-		if (ops->lost == perf_event__process_lost)
+		if (tool->lost == perf_event__process_lost)
 			session->hists.stats.total_lost += event->lost.lost;
-		return ops->lost(ops, event, sample, machine);
+		return tool->lost(tool, event, sample, machine);
 	case PERF_RECORD_READ:
-		return ops->read(ops, event, sample, evsel, machine);
+		return tool->read(tool, event, sample, evsel, machine);
 	case PERF_RECORD_THROTTLE:
-		return ops->throttle(ops, event, sample, machine);
+		return tool->throttle(tool, event, sample, machine);
 	case PERF_RECORD_UNTHROTTLE:
-		return ops->unthrottle(ops, event, sample, machine);
+		return tool->unthrottle(tool, event, sample, machine);
 	default:
 		++session->hists.stats.nr_unknown_events;
 		return -1;
@@ -826,7 +827,7 @@ static int perf_session__preprocess_sample(struct perf_session *session,
 }
 
 static int perf_session__process_user_event(struct perf_session *session, union perf_event *event,
-					    struct perf_event_ops *ops, u64 file_offset)
+					    struct perf_tool *tool, u64 file_offset)
 {
 	int err;
 
@@ -835,20 +836,20 @@ static int perf_session__process_user_event(struct perf_session *session, union
 	/* These events are processed right away */
 	switch (event->header.type) {
 	case PERF_RECORD_HEADER_ATTR:
-		err = ops->attr(event, &session->evlist);
+		err = tool->attr(event, &session->evlist);
 		if (err == 0)
 			perf_session__update_sample_type(session);
 		return err;
 	case PERF_RECORD_HEADER_EVENT_TYPE:
-		return ops->event_type(ops, event);
+		return tool->event_type(tool, event);
 	case PERF_RECORD_HEADER_TRACING_DATA:
 		/* setup for reading amidst mmap */
 		lseek(session->fd, file_offset, SEEK_SET);
-		return ops->tracing_data(event, session);
+		return tool->tracing_data(event, session);
 	case PERF_RECORD_HEADER_BUILD_ID:
-		return ops->build_id(ops, event, session);
+		return tool->build_id(tool, event, session);
 	case PERF_RECORD_FINISHED_ROUND:
-		return ops->finished_round(ops, event, session);
+		return tool->finished_round(tool, event, session);
 	default:
 		return -EINVAL;
 	}
@@ -856,7 +857,7 @@ static int perf_session__process_user_event(struct perf_session *session, union
 
 static int perf_session__process_event(struct perf_session *session,
 				       union perf_event *event,
-				       struct perf_event_ops *ops,
+				       struct perf_tool *tool,
 				       u64 file_offset)
 {
 	struct perf_sample sample;
@@ -872,7 +873,7 @@ static int perf_session__process_event(struct perf_session *session,
 	hists__inc_nr_events(&session->hists, event->header.type);
 
 	if (event->header.type >= PERF_RECORD_USER_TYPE_START)
-		return perf_session__process_user_event(session, event, ops, file_offset);
+		return perf_session__process_user_event(session, event, tool, file_offset);
 
 	/*
 	 * For all kernel events we get the sample data
@@ -885,14 +886,14 @@ static int perf_session__process_event(struct perf_session *session,
 	if (perf_session__preprocess_sample(session, event, &sample))
 		return 0;
 
-	if (ops->ordered_samples) {
+	if (tool->ordered_samples) {
 		ret = perf_session_queue_event(session, event, &sample,
 					       file_offset);
 		if (ret != -ETIME)
 			return ret;
 	}
 
-	return perf_session_deliver_event(session, event, &sample, ops,
+	return perf_session_deliver_event(session, event, &sample, tool,
 					  file_offset);
 }
 
@@ -921,9 +922,9 @@ static struct thread *perf_session__register_idle_thread(struct perf_session *se
 }
 
 static void perf_session__warn_about_errors(const struct perf_session *session,
-					    const struct perf_event_ops *ops)
+					    const struct perf_tool *tool)
 {
-	if (ops->lost == perf_event__process_lost &&
+	if (tool->lost == perf_event__process_lost &&
 	    session->hists.stats.nr_events[PERF_RECORD_LOST] != 0) {
 		ui__warning("Processed %d events and lost %d chunks!\n\n"
 			    "Check IO/CPU overload!\n\n",
@@ -958,7 +959,7 @@ static void perf_session__warn_about_errors(const struct perf_session *session,
 volatile int session_done;
 
 static int __perf_session__process_pipe_events(struct perf_session *self,
-					       struct perf_event_ops *ops)
+					       struct perf_tool *tool)
 {
 	union perf_event event;
 	uint32_t size;
@@ -967,7 +968,7 @@ static int __perf_session__process_pipe_events(struct perf_session *self,
 	int err;
 	void *p;
 
-	perf_event_ops__fill_defaults(ops);
+	perf_tool__fill_defaults(tool);
 
 	head = 0;
 more:
@@ -1004,7 +1005,7 @@ more:
 	}
 
 	if (size == 0 ||
-	    (skip = perf_session__process_event(self, &event, ops, head)) < 0) {
+	    (skip = perf_session__process_event(self, &event, tool, head)) < 0) {
 		dump_printf("%#" PRIx64 " [%#x]: skipping unknown header type: %d\n",
 			    head, event.header.size, event.header.type);
 		/*
@@ -1027,7 +1028,7 @@ more:
 done:
 	err = 0;
 out_err:
-	perf_session__warn_about_errors(self, ops);
+	perf_session__warn_about_errors(self, tool);
 	perf_session_free_sample_buffers(self);
 	return err;
 }
@@ -1058,7 +1059,7 @@ fetch_mmaped_event(struct perf_session *session,
 
 int __perf_session__process_events(struct perf_session *session,
 				   u64 data_offset, u64 data_size,
-				   u64 file_size, struct perf_event_ops *ops)
+				   u64 file_size, struct perf_tool *tool)
 {
 	u64 head, page_offset, file_offset, file_pos, progress_next;
 	int err, mmap_prot, mmap_flags, map_idx = 0;
@@ -1067,7 +1068,7 @@ int __perf_session__process_events(struct perf_session *session,
 	union perf_event *event;
 	uint32_t size;
 
-	perf_event_ops__fill_defaults(ops);
+	perf_tool__fill_defaults(tool);
 
 	page_size = sysconf(_SC_PAGESIZE);
 
@@ -1122,7 +1123,7 @@ more:
 	size = event->header.size;
 
 	if (size == 0 ||
-	    perf_session__process_event(session, event, ops, file_pos) < 0) {
+	    perf_session__process_event(session, event, tool, file_pos) < 0) {
 		dump_printf("%#" PRIx64 " [%#x]: skipping unknown header type: %d\n",
 			    file_offset + head, event->header.size,
 			    event->header.type);
@@ -1151,15 +1152,15 @@ more:
 	err = 0;
 	/* do the final flush for ordered samples */
 	session->ordered_samples.next_flush = ULLONG_MAX;
-	flush_sample_queue(session, ops);
+	flush_sample_queue(session, tool);
 out_err:
-	perf_session__warn_about_errors(session, ops);
+	perf_session__warn_about_errors(session, tool);
 	perf_session_free_sample_buffers(session);
 	return err;
 }
 
 int perf_session__process_events(struct perf_session *self,
-				 struct perf_event_ops *ops)
+				 struct perf_tool *tool)
 {
 	int err;
 
@@ -1170,9 +1171,9 @@ int perf_session__process_events(struct perf_session *self,
 		err = __perf_session__process_events(self,
 						     self->header.data_offset,
 						     self->header.data_size,
-						     self->size, ops);
+						     self->size, tool);
 	else
-		err = __perf_session__process_pipe_events(self, ops);
+		err = __perf_session__process_pipe_events(self, tool);
 
 	return err;
 }
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 1c5823c..30e9c6b6 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -53,55 +53,20 @@ struct perf_session {
 	char			filename[0];
 };
 
-struct perf_evsel;
-struct perf_event_ops;
-
-typedef int (*event_sample)(struct perf_event_ops *ops,
-			    union perf_event *event, struct perf_sample *sample,
-			    struct perf_evsel *evsel, struct machine *machine);
-typedef int (*event_op)(struct perf_event_ops *ops, union perf_event *event,
-			struct perf_sample *sample,
-			struct machine *machine);
-typedef int (*event_synth_op)(union perf_event *self,
-			      struct perf_session *session);
-typedef int (*event_attr_op)(union perf_event *event,
-			     struct perf_evlist **pevlist);
-typedef int (*event_simple_op)(struct perf_event_ops *ops,
-			       union perf_event *event);
-typedef int (*event_op2)(struct perf_event_ops *ops, union perf_event *event,
-			 struct perf_session *session);
-
-struct perf_event_ops {
-	event_sample	sample,
-			read;
-	event_op	mmap,
-			comm,
-			fork,
-			exit,
-			lost,
-			throttle,
-			unthrottle;
-	event_attr_op	attr;
-	event_synth_op	tracing_data;
-	event_simple_op	event_type;
-	event_op2	finished_round,
-			build_id;
-	bool		ordered_samples;
-	bool		ordering_requires_timestamps;
-};
+struct perf_tool;
 
 struct perf_session *perf_session__new(const char *filename, int mode,
 				       bool force, bool repipe,
-				       struct perf_event_ops *ops);
+				       struct perf_tool *tool);
 void perf_session__delete(struct perf_session *self);
 
 void perf_event_header__bswap(struct perf_event_header *self);
 
 int __perf_session__process_events(struct perf_session *self,
 				   u64 data_offset, u64 data_size, u64 size,
-				   struct perf_event_ops *ops);
+				   struct perf_tool *tool);
 int perf_session__process_events(struct perf_session *self,
-				 struct perf_event_ops *event_ops);
+				 struct perf_tool *tool);
 
 int perf_session__resolve_callchain(struct perf_session *self, struct perf_evsel *evsel,
 				    struct thread *thread,
@@ -142,11 +107,11 @@ struct machine *perf_session__findnew_machine(struct perf_session *self, pid_t p
 
 static inline
 void perf_session__process_machines(struct perf_session *self,
-				    struct perf_event_ops *ops,
+				    struct perf_tool *tool,
 				    machine__process_t process)
 {
-	process(&self->host_machine, ops);
-	return machines__process(&self->machines, process, ops);
+	process(&self->host_machine, tool);
+	return machines__process(&self->machines, process, tool);
 }
 
 struct thread *perf_session__findnew(struct perf_session *self, pid_t pid);
diff --git a/tools/perf/util/tool.h b/tools/perf/util/tool.h
new file mode 100644
index 0000000..89ff1b5
--- /dev/null
+++ b/tools/perf/util/tool.h
@@ -0,0 +1,45 @@
+#ifndef __PERF_TOOL_H
+#define __PERF_TOOL_H
+
+struct perf_session;
+struct perf_evsel;
+struct perf_tool;
+struct machine;
+
+typedef int (*event_sample)(struct perf_tool *tool, union perf_event *event,
+			    struct perf_sample *sample,
+			    struct perf_evsel *evsel, struct machine *machine);
+
+typedef int (*event_op)(struct perf_tool *tool, union perf_event *event,
+			struct perf_sample *sample, struct machine *machine);
+
+typedef int (*event_attr_op)(union perf_event *event,
+			     struct perf_evlist **pevlist);
+typedef int (*event_simple_op)(struct perf_tool *tool, union perf_event *event);
+
+typedef int (*event_synth_op)(union perf_event *event,
+			      struct perf_session *session);
+
+typedef int (*event_op2)(struct perf_tool *tool, union perf_event *event,
+			 struct perf_session *session);
+
+struct perf_tool {
+	event_sample	sample,
+			read;
+	event_op	mmap,
+			comm,
+			fork,
+			exit,
+			lost,
+			throttle,
+			unthrottle;
+	event_attr_op	attr;
+	event_synth_op	tracing_data;
+	event_simple_op	event_type;
+	event_op2	finished_round,
+			build_id;
+	bool		ordered_samples;
+	bool		ordering_requires_timestamps;
+};
+
+#endif /* __PERF_TOOL_H */
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index 44eda6f..40430ec 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -1,16 +1,17 @@
 #ifndef __PERF_TOP_H
 #define __PERF_TOP_H 1
 
+#include "tool.h"
 #include "types.h"
-#include "session.h"
-#include "../perf.h"
 #include <stddef.h>
+#include <stdbool.h>
 
 struct perf_evlist;
 struct perf_evsel;
+struct perf_session;
 
 struct perf_top {
-	struct perf_event_ops ops;
+	struct perf_tool   tool;
 	struct perf_evlist *evlist;
 	/*
 	 * Symbols will be added here in perf_event__process_sample and will
