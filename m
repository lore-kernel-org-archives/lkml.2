Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab2EQIUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 04:20:16 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41313 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab2EQIUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 04:20:04 -0400
Date: Thu, 17 May 2012 10:19:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20120517081958.GA19031@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: 9b63776fa3ca96c4ecda76f6fa947b7b0add66ac tracing: Do not enable function event with enable

 Thanks,

	Ingo

------------------>
David Ahern (1):
      perf stat: handle ENXIO error for perf_event_open

Greg Kroah-Hartman (1):
      perf: Turn off compiler warnings for flex and bison generated files

Namhyung Kim (1):
      perf build-id: Fix filename size calculation

Stephane Eranian (1):
      perf stat: Fix case where guest/host monitoring is not supported by kernel

Steven Rostedt (1):
      tracing: Do not enable function event with enable


 include/linux/ftrace_event.h |    2 ++
 kernel/trace/trace_events.c  |    5 ++++-
 kernel/trace/trace_export.c  |    1 +
 tools/perf/Makefile          |    4 ++--
 tools/perf/builtin-stat.c    |   40 +++++++++++++++++++++++++++++++++++-----
 tools/perf/util/header.c     |    2 +-
 6 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 5f3f3be..176a939 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -179,6 +179,7 @@ enum {
 	TRACE_EVENT_FL_RECORDED_CMD_BIT,
 	TRACE_EVENT_FL_CAP_ANY_BIT,
 	TRACE_EVENT_FL_NO_SET_FILTER_BIT,
+	TRACE_EVENT_FL_IGNORE_ENABLE_BIT,
 };
 
 enum {
@@ -187,6 +188,7 @@ enum {
 	TRACE_EVENT_FL_RECORDED_CMD	= (1 << TRACE_EVENT_FL_RECORDED_CMD_BIT),
 	TRACE_EVENT_FL_CAP_ANY		= (1 << TRACE_EVENT_FL_CAP_ANY_BIT),
 	TRACE_EVENT_FL_NO_SET_FILTER	= (1 << TRACE_EVENT_FL_NO_SET_FILTER_BIT),
+	TRACE_EVENT_FL_IGNORE_ENABLE	= (1 << TRACE_EVENT_FL_IGNORE_ENABLE_BIT),
 };
 
 struct ftrace_event_call {
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 079a93a..29111da 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -294,6 +294,9 @@ static int __ftrace_set_clr_event(const char *match, const char *sub,
 		if (!call->name || !call->class || !call->class->reg)
 			continue;
 
+		if (call->flags & TRACE_EVENT_FL_IGNORE_ENABLE)
+			continue;
+
 		if (match &&
 		    strcmp(match, call->name) != 0 &&
 		    strcmp(match, call->class->system) != 0)
@@ -1164,7 +1167,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		return -1;
 	}
 
-	if (call->class->reg)
+	if (call->class->reg && !(call->flags & TRACE_EVENT_FL_IGNORE_ENABLE))
 		trace_create_file("enable", 0644, call->dir, call,
 				  enable);
 
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 3dd15e8..e039906 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -180,6 +180,7 @@ struct ftrace_event_call __used event_##call = {			\
 	.event.type		= etype,				\
 	.class			= &event_class_ftrace_##call,		\
 	.print_fmt		= print,				\
+	.flags			= TRACE_EVENT_FL_IGNORE_ENABLE,		\
 };									\
 struct ftrace_event_call __used						\
 __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call;
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 9bf3fc7..92271d3 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -774,10 +774,10 @@ $(OUTPUT)perf.o perf.spec \
 # over the general rule for .o
 
 $(OUTPUT)util/%-flex.o: $(OUTPUT)util/%-flex.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Iutil/ -Wno-redundant-decls -Wno-switch-default -Wno-unused-function $<
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Iutil/ -w $<
 
 $(OUTPUT)util/%-bison.o: $(OUTPUT)util/%-bison.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -Iutil/ -Wno-redundant-decls -Wno-switch-default -Wno-unused-function $<
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -Iutil/ -w $<
 
 $(OUTPUT)%.o: %.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c941bb6..1e5e9b2 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -283,6 +283,8 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
 {
 	struct perf_event_attr *attr = &evsel->attr;
 	struct xyarray *group_fd = NULL;
+	bool exclude_guest_missing = false;
+	int ret;
 
 	if (group && evsel != first)
 		group_fd = first->fd;
@@ -293,16 +295,39 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
 
 	attr->inherit = !no_inherit;
 
-	if (system_wide)
-		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus,
+retry:
+	if (exclude_guest_missing)
+		evsel->attr.exclude_guest = evsel->attr.exclude_host = 0;
+
+	if (system_wide) {
+		ret = perf_evsel__open_per_cpu(evsel, evsel_list->cpus,
 						group, group_fd);
+		if (ret)
+			goto check_ret;
+		return 0;
+	}
+
 	if (!target_pid && !target_tid && (!group || evsel == first)) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
 
-	return perf_evsel__open_per_thread(evsel, evsel_list->threads,
-					   group, group_fd);
+	ret = perf_evsel__open_per_thread(evsel, evsel_list->threads,
+					  group, group_fd);
+	if (!ret)
+		return 0;
+	/* fall through */
+check_ret:
+	if (ret && errno == EINVAL) {
+		if (!exclude_guest_missing &&
+		    (evsel->attr.exclude_guest || evsel->attr.exclude_host)) {
+			pr_debug("Old kernel, cannot exclude "
+				 "guest or host samples.\n");
+			exclude_guest_missing = true;
+			goto retry;
+		}
+	}
+	return ret;
 }
 
 /*
@@ -463,8 +488,13 @@ static int run_perf_stat(int argc __used, const char **argv)
 
 	list_for_each_entry(counter, &evsel_list->entries, node) {
 		if (create_perf_stat_counter(counter, first) < 0) {
+			/*
+			 * PPC returns ENXIO for HW counters until 2.6.37
+			 * (behavior changed with commit b0a873e).
+			 */
 			if (errno == EINVAL || errno == ENOSYS ||
-			    errno == ENOENT || errno == EOPNOTSUPP) {
+			    errno == ENOENT || errno == EOPNOTSUPP ||
+			    errno == ENXIO) {
 				if (verbose)
 					ui__warning("%s event is not supported by the kernel.\n",
 						    event_name(counter));
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 4c7c2d7..c0b70c6 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -296,7 +296,7 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 	if (mkdir_p(filename, 0755))
 		goto out_free;
 
-	snprintf(filename + len, sizeof(filename) - len, "/%s", sbuild_id);
+	snprintf(filename + len, size - len, "/%s", sbuild_id);
 
 	if (access(filename, F_OK)) {
 		if (is_kallsyms) {
