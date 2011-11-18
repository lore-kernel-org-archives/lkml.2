Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944Ab1KRNrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 08:47:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757205Ab1KRNrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 08:47:08 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 4/5] perf tool: Introducing perf_data object
Date: Fri, 18 Nov 2011 14:46:44 +0100
Message-Id: <1321624005-6889-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1321624005-6889-1-git-send-email-jolsa@redhat.com>
References: <1321624005-6889-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding perf_data object to handle input/output data files.
The objective is to have this functionality centralized
and ready for supporting multiple event data streams.

All the input/output file related functions originally scatered
through the whole code are now placed in perf_mmap object.

To open/close data file:
	perf_data__open
	perf_data__close

Plus several helper functions:
	perf_data__is_pipe
	perf_data__is_ro
	perf_data__is_new
	perf_data__size

The perf_data object handles input/output file open/create processing,
plus check for pipe intput/output.

The perf_session object was modified to contains perf_data. Thus for
perf_session users the change is almost invisible apart from newly
defined open mode enums:

	PERF_DATA_NONE
	PERF_DATA_READ
	PERF_DATA_WRITE_TRUNC
	PERF_DATA_WRITE_APPEND

The PERF_DATA_NONE serves for 'top' session, where no storage
is needed. The rest is selfexplanatory.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Makefile               |    2 +
 tools/perf/builtin-annotate.c     |    3 +-
 tools/perf/builtin-buildid-list.c |    4 +-
 tools/perf/builtin-diff.c         |    6 +-
 tools/perf/builtin-evlist.c       |    3 +-
 tools/perf/builtin-inject.c       |    3 +-
 tools/perf/builtin-kmem.c         |    6 +-
 tools/perf/builtin-lock.c         |    3 +-
 tools/perf/builtin-record.c       |  134 ++++++++-----------------
 tools/perf/builtin-report.c       |    7 +-
 tools/perf/builtin-sched.c        |    6 +-
 tools/perf/builtin-script.c       |    3 +-
 tools/perf/builtin-timechart.c    |    7 +-
 tools/perf/builtin-top.c          |   12 +--
 tools/perf/util/data.c            |  203 +++++++++++++++++++++++++++++++++++++
 tools/perf/util/data.h            |   65 ++++++++++++
 tools/perf/util/header.c          |   35 ++++---
 tools/perf/util/header.h          |    6 +-
 tools/perf/util/session.c         |  115 ++++++++--------------
 tools/perf/util/session.h         |   26 ++++--
 20 files changed, 429 insertions(+), 220 deletions(-)
 create mode 100644 tools/perf/util/data.c
 create mode 100644 tools/perf/util/data.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 0158b66..a11ec3d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -275,6 +275,7 @@ LIB_H += util/header.h
 LIB_H += util/help.h
 LIB_H += util/session.h
 LIB_H += util/mmap.h
+LIB_H += util/data.h
 LIB_H += util/strbuf.h
 LIB_H += util/strlist.h
 LIB_H += util/strfilter.h
@@ -339,6 +340,7 @@ LIB_OBJS += $(OUTPUT)util/map.o
 LIB_OBJS += $(OUTPUT)util/pstack.o
 LIB_OBJS += $(OUTPUT)util/session.o
 LIB_OBJS += $(OUTPUT)util/mmap.o
+LIB_OBJS += $(OUTPUT)util/data.o
 LIB_OBJS += $(OUTPUT)util/thread.o
 LIB_OBJS += $(OUTPUT)util/thread_map.o
 LIB_OBJS += $(OUTPUT)util/trace-event-parse.o
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 46b4c24..cbaa8be 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -183,7 +183,8 @@ static int __cmd_annotate(void)
 	struct perf_evsel *pos;
 	u64 total_nr_samples;
 
-	session = perf_session__new(input_name, O_RDONLY, force, false, &event_ops);
+	session = perf_session__new(input_name, PERF_DATA_READ, force,
+				    false, &event_ops);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index cb690a6..0f26866 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -43,8 +43,8 @@ static int perf_session__list_build_ids(void)
 {
 	struct perf_session *session;
 
-	session = perf_session__new(input_name, O_RDONLY, force, false,
-				    &build_id__mark_dso_hit_ops);
+	session = perf_session__new(input_name, PERF_DATA_READ, force,
+				    false, &build_id__mark_dso_hit_ops);
 	if (session == NULL)
 		return -1;
 
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index b39f3a1..093d5bf 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -145,8 +145,10 @@ static int __cmd_diff(void)
 	int ret, i;
 	struct perf_session *session[2];
 
-	session[0] = perf_session__new(input_old, O_RDONLY, force, false, &event_ops);
-	session[1] = perf_session__new(input_new, O_RDONLY, force, false, &event_ops);
+	session[0] = perf_session__new(input_old, PERF_DATA_READ, force,
+				       false, &event_ops);
+	session[1] = perf_session__new(input_new, PERF_DATA_READ, force,
+				       false, &event_ops);
 	if (session[0] == NULL || session[1] == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
index 4c5e9e0..87a6662 100644
--- a/tools/perf/builtin-evlist.c
+++ b/tools/perf/builtin-evlist.c
@@ -22,7 +22,8 @@ static int __cmd_evlist(void)
 	struct perf_session *session;
 	struct perf_evsel *pos;
 
-	session = perf_session__new(input_name, O_RDONLY, 0, false, NULL);
+	session = perf_session__new(input_name, PERF_DATA_READ,
+				    false, false, NULL);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 3c5eb3a..38a88ca 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -205,7 +205,8 @@ static int __cmd_inject(void)
 		inject_ops.tracing_data	= perf_event__repipe_tracing_data;
 	}
 
-	session = perf_session__new(input_name, O_RDONLY, false, true, &inject_ops);
+	session = perf_session__new(input_name, PERF_DATA_READ, false,
+				    true, &inject_ops);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 2ca8206..1a80840 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -480,8 +480,10 @@ static void sort_result(void)
 static int __cmd_kmem(void)
 {
 	int err = -EINVAL;
-	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
-							 0, false, &event_ops);
+	struct perf_session *session;
+
+	session = perf_session__new(input_name, PERF_DATA_READ, false,
+				    false, &event_ops);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 899080a..af2c923 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -871,7 +871,8 @@ static struct perf_event_ops eops = {
 
 static int read_events(void)
 {
-	session = perf_session__new(input_name, O_RDONLY, 0, false, &eops);
+	session = perf_session__new(input_name, PERF_DATA_READ, false,
+				    false, &eops);
 	if (!session)
 		die("Initializing perf session failed\n");
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 89b3dc2..4b0cf7c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -31,11 +31,6 @@
 #include <sched.h>
 #include <sys/mman.h>
 
-enum write_mode_t {
-	WRITE_FORCE,
-	WRITE_APPEND
-};
-
 static u64			user_interval			= ULLONG_MAX;
 static u64			default_interval		=      0;
 
@@ -43,8 +38,6 @@ static unsigned int		page_size;
 static unsigned int		mmap_pages			= UINT_MAX;
 static unsigned int		user_freq 			= UINT_MAX;
 static int			freq				=   1000;
-static int			output;
-static int			pipe_output			=      0;
 static const char		*output_name			= NULL;
 static bool			group				=  false;
 static int			realtime_prio			=      0;
@@ -56,7 +49,7 @@ static pid_t			target_pid			=     -1;
 static pid_t			target_tid			=     -1;
 static pid_t			child_pid			=     -1;
 static bool			no_inherit			=  false;
-static enum write_mode_t	write_mode			= WRITE_FORCE;
+static enum perf_data_mode	write_mode			=  PERF_DATA_WRITE_TRUNC;
 static bool			call_graph			=  false;
 static bool			inherit_stat			=  false;
 static bool			no_samples			=  false;
@@ -68,7 +61,6 @@ static struct perf_evlist	*evsel_list;
 
 static u64			bytes_written			=      0;
 
-static int			file_new			=      1;
 static off_t			post_processing_offset;
 
 static struct perf_session	*session;
@@ -80,10 +72,10 @@ static void advance_output(size_t size)
 	bytes_written += size;
 }
 
-static void write_output(void *buf, size_t size)
+static void write_output(int fd, void *buf, size_t size)
 {
 	while (size) {
-		int ret = write(output, buf, size);
+		int ret = write(fd, buf, size);
 
 		if (ret < 0)
 			die("failed to write");
@@ -97,9 +89,10 @@ static void write_output(void *buf, size_t size)
 
 static int process_synthesized_event(union perf_event *event,
 				     struct perf_sample *sample __used,
-				     struct perf_session *self __used)
+				     struct perf_session *self)
 {
-	write_output(event, event->header.size);
+	int fd = perf_session__fd(self);
+	write_output(fd, event, event->header.size);
 	return 0;
 }
 
@@ -328,7 +321,7 @@ try_again:
 	if (perf_evlist__mmap(evlist, mmap_pages, false) < 0)
 		die("failed to mmap with %d (%s)\n", errno, strerror(errno));
 
-	if (file_new)
+	if (perf_session__is_new(session))
 		session->evlist = evlist;
 	else {
 		if (!perf_evlist__equal(session->evlist, evlist)) {
@@ -342,12 +335,11 @@ try_again:
 
 static int process_buildids(void)
 {
-	u64 size = lseek(output, 0, SEEK_CUR);
+	u64 size = lseek(perf_session__fd(session), 0, SEEK_CUR);
 
 	if (size == 0)
 		return 0;
 
-	session->fd = output;
 	return __perf_session__process_events(session, post_processing_offset,
 					      size - post_processing_offset,
 					      size, &build_id__mark_dso_hit_ops);
@@ -355,22 +347,23 @@ static int process_buildids(void)
 
 static void atexit_header(void)
 {
-	if (!pipe_output) {
+	if (!perf_session__is_pipe(session)) {
 		session->header.data_size += bytes_written;
 
 		if (!no_buildid)
 			process_buildids();
-		perf_session__write_header(session, evsel_list, output, true);
+		perf_session__write_header(session, evsel_list, true);
 		perf_session__delete(session);
 		perf_evlist__delete(evsel_list);
 		symbol__exit();
 	}
 }
 
-static void perf_event__synthesize_guest_os(struct machine *machine, void *data)
+static void perf_event__synthesize_guest_os(struct machine *machine,
+					    void *__data)
 {
 	int err;
-	struct perf_session *psession = data;
+	struct perf_session *psession = __data;
 
 	if (machine__is_host(machine))
 		return;
@@ -411,7 +404,8 @@ static struct perf_event_header finished_round_event = {
 
 static void mmap_read(struct perf_mmap *m __used, void *buf, unsigned long size)
 {
-	write_output(buf, size);
+	int fd = perf_session__fd(session);
+	write_output(fd, buf, size);
 }
 
 static int mmap_read_all(void)
@@ -420,26 +414,25 @@ static int mmap_read_all(void)
 
 	for (i = 0; i < evsel_list->nr_mmaps; i++) {
 		struct perf_mmap *m = &evsel_list->mmap[i];
-		if (m->base)
-			ret += perf_mmap__process(m, mmap_read);
+		ret += perf_mmap__process(m, mmap_read);
 	}
 
-	if (perf_header__has_feat(&session->header, HEADER_TRACE_INFO))
-		write_output(&finished_round_event, sizeof(finished_round_event));
+	if (perf_header__has_feat(&session->header, HEADER_TRACE_INFO)) {
+		int fd = perf_session__fd(session);
+		write_output(fd, &finished_round_event,
+			     sizeof(finished_round_event));
+	}
 
 	return ret;
 }
 
 static int __cmd_record(int argc, const char **argv)
 {
-	struct stat st;
-	int flags;
-	int err;
+	struct machine *machine;
 	unsigned long waking = 0;
-	int child_ready_pipe[2], go_pipe[2];
+	int child_ready_pipe[2], go_pipe[2], err;
 	const bool forks = argc > 0;
 	char buf;
-	struct machine *machine;
 
 	progname = argv[0];
 
@@ -455,45 +448,8 @@ static int __cmd_record(int argc, const char **argv)
 		exit(-1);
 	}
 
-	if (!output_name) {
-		if (!fstat(STDOUT_FILENO, &st) && S_ISFIFO(st.st_mode))
-			pipe_output = 1;
-		else
-			output_name = "perf.data";
-	}
-	if (output_name) {
-		if (!strcmp(output_name, "-"))
-			pipe_output = 1;
-		else if (!stat(output_name, &st) && st.st_size) {
-			if (write_mode == WRITE_FORCE) {
-				char oldname[PATH_MAX];
-				snprintf(oldname, sizeof(oldname), "%s.old",
-					 output_name);
-				unlink(oldname);
-				rename(output_name, oldname);
-			}
-		} else if (write_mode == WRITE_APPEND) {
-			write_mode = WRITE_FORCE;
-		}
-	}
-
-	flags = O_CREAT|O_RDWR;
-	if (write_mode == WRITE_APPEND)
-		file_new = 0;
-	else
-		flags |= O_TRUNC;
-
-	if (pipe_output)
-		output = STDOUT_FILENO;
-	else
-		output = open(output_name, flags, S_IRUSR | S_IWUSR);
-	if (output < 0) {
-		perror("failed to create output file");
-		exit(-1);
-	}
-
-	session = perf_session__new(output_name, O_WRONLY,
-				    write_mode == WRITE_FORCE, false, NULL);
+	session = perf_session__new(output_name, write_mode,
+				    false, false, NULL);
 	if (session == NULL) {
 		pr_err("Not enough memory for reading perf file header\n");
 		return -1;
@@ -502,8 +458,8 @@ static int __cmd_record(int argc, const char **argv)
 	if (!no_buildid)
 		perf_header__set_feat(&session->header, HEADER_BUILD_ID);
 
-	if (!file_new) {
-		err = perf_session__read_header(session, output);
+	if (!perf_session__is_new(session)) {
+		err = perf_session__read_header(session);
 		if (err < 0)
 			goto out_delete_session;
 	}
@@ -536,7 +492,7 @@ static int __cmd_record(int argc, const char **argv)
 		}
 
 		if (!child_pid) {
-			if (pipe_output)
+			if (perf_session__is_pipe(session))
 				dup2(2, 1);
 			close(child_ready_pipe[0]);
 			close(go_pipe[1]);
@@ -589,32 +545,31 @@ static int __cmd_record(int argc, const char **argv)
 	 */
 	atexit(atexit_header);
 
-	if (pipe_output) {
-		err = perf_header__write_pipe(output);
+	if (perf_session__is_pipe(session)) {
+		err = perf_header__write_pipe(perf_session__fd(session));
 		if (err < 0)
-			return err;
-	} else if (file_new) {
-		err = perf_session__write_header(session, evsel_list,
-						 output, false);
+			goto out_delete_session;
+	} else if (perf_session__is_new(session)) {
+		err = perf_session__write_header(session, evsel_list, false);
 		if (err < 0)
-			return err;
+			goto out_delete_session;
 	}
 
-	post_processing_offset = lseek(output, 0, SEEK_CUR);
+	post_processing_offset = lseek(perf_session__fd(session), 0, SEEK_CUR);
 
-	if (pipe_output) {
+	if (perf_session__is_pipe(session)) {
 		err = perf_session__synthesize_attrs(session,
 						     process_synthesized_event);
 		if (err < 0) {
 			pr_err("Couldn't synthesize attrs.\n");
-			return err;
+			goto out_delete_session;
 		}
 
 		err = perf_event__synthesize_event_types(process_synthesized_event,
 							 session);
 		if (err < 0) {
 			pr_err("Couldn't synthesize event_types.\n");
-			return err;
+			goto out_delete_session;
 		}
 
 		if (have_tracepoints(&evsel_list->entries)) {
@@ -626,12 +581,12 @@ static int __cmd_record(int argc, const char **argv)
 			 * return this more properly and also
 			 * propagate errors that now are calling die()
 			 */
-			err = perf_event__synthesize_tracing_data(output, evsel_list,
+			err = perf_event__synthesize_tracing_data(evsel_list,
 								  process_synthesized_event,
 								  session);
 			if (err <= 0) {
 				pr_err("Couldn't record tracing data.\n");
-				return err;
+				goto out_delete_session;
 			}
 			advance_output(err);
 		}
@@ -699,7 +654,7 @@ static int __cmd_record(int argc, const char **argv)
 	}
 
 	if (quiet || signr == SIGUSR1)
-		return 0;
+		goto out_delete_session;
 
 	fprintf(stderr, "[ perf record: Woken up %ld times to write data ]\n", waking);
 
@@ -804,9 +759,9 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 				" You need to choose between -f and -A");
 		usage_with_options(record_usage, record_options);
 	} else if (append_file) {
-		write_mode = WRITE_APPEND;
+		write_mode = PERF_DATA_WRITE_APPEND;
 	} else {
-		write_mode = WRITE_FORCE;
+		write_mode = PERF_DATA_WRITE_TRUNC;
 	}
 
 	if (nr_cgroups && !system_wide) {
@@ -851,9 +806,6 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 			goto out_free_fd;
 	}
 
-	if (perf_evlist__alloc_pollfd(evsel_list) < 0)
-		goto out_free_fd;
-
 	if (user_interval != ULLONG_MAX)
 		default_interval = user_interval;
 	if (user_freq != UINT_MAX)
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 4d7c834..5a98b8e 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -35,7 +35,7 @@
 
 #include <linux/bitmap.h>
 
-static char		const *input_name = "perf.data";
+static char		const *input_name;
 
 static bool		force, use_tui, use_stdio;
 static bool		hide_unresolved;
@@ -264,7 +264,8 @@ static int __cmd_report(void)
 
 	signal(SIGINT, sig_handler);
 
-	session = perf_session__new(input_name, O_RDONLY, force, false, &event_ops);
+	session = perf_session__new(input_name, PERF_DATA_READ, force,
+				    false, &event_ops);
 	if (session == NULL)
 		return -ENOMEM;
 
@@ -514,7 +515,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	if (inverted_callchain)
 		callchain_param.order = ORDER_CALLER;
 
-	if (strcmp(input_name, "-") != 0)
+	if (input_name && strcmp(input_name, "-") != 0)
 		setup_browser(true);
 	else
 		use_browser = 0;
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 5177964..266333c 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1640,8 +1640,10 @@ static struct perf_event_ops event_ops = {
 static void read_events(bool destroy, struct perf_session **psession)
 {
 	int err = -EINVAL;
-	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
-							 0, false, &event_ops);
+	struct perf_session *session;
+
+	session = perf_session__new(input_name, PERF_DATA_READ, false,
+				    false, &event_ops);
 	if (session == NULL)
 		die("No Memory");
 
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 2f62a29..89ae663 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1261,7 +1261,8 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 	if (!script_name)
 		setup_pager();
 
-	session = perf_session__new(input_name, O_RDONLY, 0, false, &event_ops);
+	session = perf_session__new(input_name, PERF_DATA_READ, false,
+				    false, &event_ops);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index aa26f4d..e3f4951 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -984,10 +984,11 @@ static struct perf_event_ops event_ops = {
 
 static int __cmd_timechart(void)
 {
-	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
-							 0, false, &event_ops);
-	int ret = -EINVAL;
+	struct perf_session *session;
+	int ret = EINVAL;
 
+	session = perf_session__new(input_name, PERF_DATA_READ, false,
+				    false, &event_ops);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 032f70d..e86d728 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -959,11 +959,9 @@ static int __cmd_top(void)
 {
 	pthread_t thread;
 	int ret;
-	/*
-	 * FIXME: perf_session__new should allow passing a O_MMAP, so that all this
-	 * mmap reading, etc is encapsulated in it. Use O_WRONLY for now.
-	 */
-	top.session = perf_session__new(NULL, O_WRONLY, false, false, NULL);
+
+	top.session = perf_session__new(NULL, PERF_DATA_NONE, false,
+					false, NULL);
 	if (top.session == NULL)
 		return -ENOMEM;
 
@@ -1248,10 +1246,6 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		pos->attr.sample_period = default_interval;
 	}
 
-	if (perf_evlist__alloc_pollfd(top.evlist) < 0 ||
-	    perf_evlist__alloc_mmap(top.evlist) < 0)
-		goto out_free_fd;
-
 	top.sym_evsel = list_entry(top.evlist->entries.next, struct perf_evsel, node);
 
 	symbol_conf.priv_size = sizeof(struct annotation);
diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
new file mode 100644
index 0000000..c025d0f
--- /dev/null
+++ b/tools/perf/util/data.c
@@ -0,0 +1,203 @@
+
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <linux/kernel.h>
+#include <linux/compiler.h>
+#include <errno.h>
+
+#include "data.h"
+#include "util.h"
+#include "cpumap.h"
+#include "thread_map.h"
+#include "evsel.h"
+
+static bool pipe_is_fd(int fd)
+{
+	struct stat st;
+	return !fstat(fd, &st) && S_ISFIFO(st.st_mode);
+}
+
+static int pipe_get_fd(int mode)
+{
+	if (mode == PERF_DATA_READ)
+		return STDIN_FILENO;
+	return STDOUT_FILENO;
+}
+
+static bool pipe_chk(const char *name, int mode)
+{
+	int fd = pipe_get_fd(mode);
+
+	if (!name && pipe_is_fd(fd))
+		return true;
+
+	if (name && !strcmp(name, "-"))
+		return true;
+
+	return false;
+}
+
+static int pipe_data(struct perf_data *data)
+{
+	struct perf_data_file *file = &data->header;
+
+	memset(file, 0, sizeof(*file));
+	file->fd = pipe_get_fd(data->mode);
+	return 0;
+}
+
+static int file_chk_read(struct perf_data *data,
+			 struct stat *st, char *name)
+{
+	if (!data->force &&
+	    st->st_uid && (st->st_uid != geteuid())) {
+		pr_err("file %s not owned by current user or root\n",
+		       name);
+		return -1;
+	}
+
+	if (!st->st_size) {
+		pr_info("zero-sized file (%s), nothing to do!\n",
+			name);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int file_open(struct perf_data *data, char *name)
+{
+	int flags = 0, fd;
+	int mode = data->mode;
+
+	switch (mode) {
+	case PERF_DATA_READ:
+		flags = O_RDONLY;
+		break;
+	case PERF_DATA_WRITE_TRUNC:
+		flags = O_TRUNC;
+	/* falling through intentionally */
+	case PERF_DATA_WRITE_APPEND:
+		flags |= O_CREAT|O_RDWR;
+		break;
+	default:
+		return -1;
+	};
+
+	fd = open(name, flags, S_IRUSR | S_IWUSR);
+	if (fd < 0)
+		perror("failed to create output file");
+
+	return fd;
+}
+
+static int file_backup(char *name)
+{
+	char oldname[PATH_MAX];
+	int ret;
+
+	snprintf(oldname, sizeof(oldname), "%s.old",
+		 name);
+
+	ret = unlink(oldname);
+	if (ret)
+		return ret;
+
+	ret = rename(name, oldname);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int data_file__open(struct perf_data *data,
+			   struct perf_data_file *file,
+			   char *name)
+{
+	struct stat st;
+	int fd, mode = data->mode;
+	bool exists;
+
+	exists = (!stat(name, &st) && st.st_size);
+
+	/* make the file backup if needed */
+	if (exists && (mode == PERF_DATA_WRITE_TRUNC)) {
+		int ret = file_backup(name);
+		if (ret)
+			return ret;
+	}
+
+	/* nothing to append to, change mode */
+	if (!exists &&
+	    (mode == PERF_DATA_WRITE_APPEND))
+		mode = PERF_DATA_WRITE_TRUNC;
+
+	data->mode = mode;
+	memset(file, 0, sizeof(*file));
+
+	/* read sanity checks */
+	if (mode == PERF_DATA_READ) {
+		if (!exists) {
+			pr_err("failed to open %s: does not exist\n", name);
+			return -EINVAL;
+		}
+		if (file_chk_read(data, &st, name))
+			return -1;
+		file->size = st.st_size;
+	}
+
+	fd = file_open(data, name);
+	if (fd < 0)
+		return errno;
+
+	file->name = name;
+	file->fd = fd;
+
+	list_add_tail(&file->list, &data->files);
+	return 0;
+}
+
+static void data_file__close(struct perf_data *data __used,
+			     struct perf_data_file *file)
+{
+	close(file->fd);
+}
+
+int perf_data__open(struct perf_data *data, const char *name,
+		    int mode, bool force)
+{
+	bool is_pipe;
+
+	memset(data, 0, sizeof(*data));
+	data->mode = mode;
+	INIT_LIST_HEAD(&data->files);
+
+	if (mode == PERF_DATA_NONE)
+		return 0;
+
+	is_pipe = pipe_chk(name, mode);
+	if (!is_pipe && !name)
+		name = "perf.data";
+
+	data->force   = force;
+	data->is_pipe = is_pipe;
+
+	if (is_pipe)
+		return pipe_data(data);
+
+	return data_file__open(data, &data->header, (char *) name);
+}
+
+void perf_data__close(struct perf_data *data)
+{
+	struct perf_data_file *file;
+
+	if (!data->is_pipe)
+		return;
+
+	list_for_each_entry(file, &data->files, list)
+		data_file__close(data, file);
+}
diff --git a/tools/perf/util/data.h b/tools/perf/util/data.h
new file mode 100644
index 0000000..3103f7a
--- /dev/null
+++ b/tools/perf/util/data.h
@@ -0,0 +1,65 @@
+#ifndef __PERF_DATA_H
+#define __PERF_DATA_H
+
+#include <stdbool.h>
+#include <linux/list.h>
+#include "mmap.h"
+#include "evlist.h"
+
+enum perf_data_mode {
+	PERF_DATA_NONE,
+	PERF_DATA_READ,
+	PERF_DATA_WRITE_TRUNC,
+	PERF_DATA_WRITE_APPEND,
+};
+
+struct perf_data_file {
+	int fd;
+	off_t size;
+	char *name;
+
+	struct list_head list;
+};
+
+struct perf_data {
+	struct perf_data_file header;
+
+	bool is_pipe;
+	int  mode;
+	bool force;
+
+	struct list_head files;
+};
+
+int perf_data__open(struct perf_data *data, const char *name,
+		    int mode, bool force);
+void perf_data__close(struct perf_data *data);
+
+#define PERF_DATA__NONE(__data) \
+	perf_data__open(&__data, NULL, PERF_DATA_NONE, false);
+
+static inline int perf_data__is_pipe(struct perf_data *data)
+{
+	return data->is_pipe;
+}
+
+static inline int perf_data__is_ro(struct perf_data *data)
+{
+	return data->mode == PERF_DATA_READ;
+}
+
+static inline int perf_data__is_new(struct perf_data *data)
+{
+	return data->mode == PERF_DATA_WRITE_TRUNC;
+}
+
+static inline off_t perf_data__size(struct perf_data *data)
+{
+	return data->header.size;
+}
+
+static inline int perf_data__fd(struct perf_data *data)
+{
+	return data->header.fd;
+}
+#endif /* __PERF_DATA_H */
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index bcd05d0..f1580c8 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1123,7 +1123,7 @@ int perf_header__fprintf_info(struct perf_session *session, FILE *fp, bool full)
 {
 	struct header_print_data hd;
 	struct perf_header *header = &session->header;
-	int fd = session->fd;
+	int fd = perf_session__fd(session);
 	hd.fp = fp;
 	hd.full = full;
 
@@ -1525,13 +1525,13 @@ int perf_header__write_pipe(int fd)
 
 int perf_session__write_header(struct perf_session *session,
 			       struct perf_evlist *evlist,
-			       int fd, bool at_exit)
+			       bool at_exit)
 {
 	struct perf_file_header f_header;
 	struct perf_file_attr   f_attr;
 	struct perf_header *header = &session->header;
 	struct perf_evsel *attr, *pair = NULL;
-	int err;
+	int err, fd = perf_session__fd(session);
 
 	lseek(fd, sizeof(f_header), SEEK_SET);
 
@@ -1960,10 +1960,11 @@ static int perf_file_header__read_pipe(struct perf_pipe_file_header *header,
 	return 0;
 }
 
-static int perf_header__read_pipe(struct perf_session *session, int fd)
+static int perf_header__read_pipe(struct perf_session *session)
 {
 	struct perf_header *header = &session->header;
 	struct perf_pipe_file_header f_header;
+	int fd = perf_session__fd(session);
 
 	if (perf_file_header__read_pipe(&f_header, header, fd,
 					session->repipe) < 0) {
@@ -1971,25 +1972,24 @@ static int perf_header__read_pipe(struct perf_session *session, int fd)
 		return -EINVAL;
 	}
 
-	session->fd = fd;
-
 	return 0;
 }
 
-int perf_session__read_header(struct perf_session *session, int fd)
+int perf_session__read_header(struct perf_session *session)
 {
 	struct perf_header *header = &session->header;
 	struct perf_file_header	f_header;
 	struct perf_file_attr	f_attr;
 	u64			f_id;
 	int nr_attrs, nr_ids, i, j;
+	int fd = perf_session__fd(session);
 
 	session->evlist = perf_evlist__new(NULL, NULL);
 	if (session->evlist == NULL)
 		return -ENOMEM;
 
-	if (session->fd_pipe)
-		return perf_header__read_pipe(session, fd);
+	if (perf_session__is_pipe(session))
+		return perf_header__read_pipe(session);
 
 	if (perf_file_header__read(&f_header, header, fd) < 0) {
 		pr_debug("incompatible file format\n");
@@ -2213,14 +2213,14 @@ int perf_event__process_event_type(union perf_event *event,
 	return 0;
 }
 
-int perf_event__synthesize_tracing_data(int fd, struct perf_evlist *evlist,
-					 perf_event__handler_t process,
-				   struct perf_session *session __unused)
+int perf_event__synthesize_tracing_data(struct perf_evlist *evlist,
+					perf_event__handler_t process,
+					struct perf_session *session)
 {
 	union perf_event ev;
 	struct tracing_data *tdata;
 	ssize_t size = 0, aligned_size = 0, padding;
-	int err __used = 0;
+	int fd = perf_session__fd(session);
 
 	/*
 	 * We are going to store the size of the data followed
@@ -2263,18 +2263,19 @@ int perf_event__process_tracing_data(union perf_event *event,
 				     struct perf_session *session)
 {
 	ssize_t size_read, padding, size = event->tracing_data.size;
-	off_t offset = lseek(session->fd, 0, SEEK_CUR);
+	int fd = perf_session__fd(session);
+	off_t offset = lseek(fd, 0, SEEK_CUR);
 	char buf[BUFSIZ];
 
 	/* setup for reading amidst mmap */
-	lseek(session->fd, offset + sizeof(struct tracing_data_event),
+	lseek(fd, offset + sizeof(struct tracing_data_event),
 	      SEEK_SET);
 
-	size_read = trace_report(session->fd, session->repipe);
+	size_read = trace_report(fd, session->repipe);
 
 	padding = ALIGN(size_read, sizeof(u64)) - size_read;
 
-	if (read(session->fd, buf, padding) < 0)
+	if (read(fd, buf, padding) < 0)
 		die("reading input file");
 	if (session->repipe) {
 		int retw = write(STDOUT_FILENO, buf, padding);
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 3d5a742..63b56ba 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -69,10 +69,10 @@ struct perf_header {
 
 struct perf_evlist;
 
-int perf_session__read_header(struct perf_session *session, int fd);
+int perf_session__read_header(struct perf_session *session);
 int perf_session__write_header(struct perf_session *session,
 			       struct perf_evlist *evlist,
-			       int fd, bool at_exit);
+			       bool at_exit);
 int perf_header__write_pipe(int fd);
 
 int perf_header__push_event(u64 id, const char *name);
@@ -111,7 +111,7 @@ int perf_event__synthesize_event_types(perf_event__handler_t process,
 int perf_event__process_event_type(union perf_event *event,
 				   struct perf_session *session);
 
-int perf_event__synthesize_tracing_data(int fd, struct perf_evlist *evlist,
+int perf_event__synthesize_tracing_data(struct perf_evlist *evlist,
 					perf_event__handler_t process,
 					struct perf_session *session);
 int perf_event__process_tracing_data(union perf_event *event,
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 85c1e6b7..219ce32 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -13,69 +13,26 @@
 #include "sort.h"
 #include "util.h"
 #include "cpumap.h"
+#include "data.h"
 
-static int perf_session__open(struct perf_session *self, bool force)
+static int perf_session__open(struct perf_session *self)
 {
-	struct stat input_stat;
-
-	if (!strcmp(self->filename, "-")) {
-		self->fd_pipe = true;
-		self->fd = STDIN_FILENO;
-
-		if (perf_session__read_header(self, self->fd) < 0)
-			pr_err("incompatible file format");
-
-		return 0;
-	}
-
-	self->fd = open(self->filename, O_RDONLY);
-	if (self->fd < 0) {
-		int err = errno;
-
-		pr_err("failed to open %s: %s", self->filename, strerror(err));
-		if (err == ENOENT && !strcmp(self->filename, "perf.data"))
-			pr_err("  (try 'perf record' first)");
-		pr_err("\n");
-		return -errno;
-	}
-
-	if (fstat(self->fd, &input_stat) < 0)
-		goto out_close;
-
-	if (!force && input_stat.st_uid && (input_stat.st_uid != geteuid())) {
-		pr_err("file %s not owned by current user or root\n",
-		       self->filename);
-		goto out_close;
-	}
-
-	if (!input_stat.st_size) {
-		pr_info("zero-sized file (%s), nothing to do!\n",
-			self->filename);
-		goto out_close;
-	}
-
-	if (perf_session__read_header(self, self->fd) < 0) {
+	if (perf_session__read_header(self) < 0) {
 		pr_err("incompatible file format");
-		goto out_close;
+		return -1;
 	}
 
 	if (!perf_evlist__valid_sample_type(self->evlist)) {
 		pr_err("non matching sample_type");
-		goto out_close;
+		return -1;
 	}
 
 	if (!perf_evlist__valid_sample_id_all(self->evlist)) {
 		pr_err("non matching sample_id_all");
-		goto out_close;
+		return -1;
 	}
 
-	self->size = input_stat.st_size;
 	return 0;
-
-out_close:
-	close(self->fd);
-	self->fd = -1;
-	return -1;
 }
 
 static void perf_session__id_header_size(struct perf_session *session)
@@ -128,17 +85,15 @@ static void perf_session__destroy_kernel_maps(struct perf_session *self)
 	machines__destroy_guest_kernel_maps(&self->machines);
 }
 
-struct perf_session *perf_session__new(const char *filename, int mode,
-				       bool force, bool repipe,
-				       struct perf_event_ops *ops)
+struct perf_session *perf_session__new(const char *name, int mode, bool force,
+				       bool repipe, struct perf_event_ops *ops)
 {
-	size_t len = filename ? strlen(filename) + 1 : 0;
-	struct perf_session *self = zalloc(sizeof(*self) + len);
+	struct perf_session *self;
 
-	if (self == NULL)
-		goto out;
+	self = zalloc(sizeof(*self));
+	if (!self)
+		return NULL;
 
-	memcpy(self->filename, filename, len);
 	self->threads = RB_ROOT;
 	INIT_LIST_HEAD(&self->dead_threads);
 	self->last_match = NULL;
@@ -158,17 +113,20 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 	INIT_LIST_HEAD(&self->ordered_samples.to_free);
 	machine__init(&self->host_machine, "", HOST_KERNEL_ID);
 
-	if (mode == O_RDONLY) {
-		if (perf_session__open(self, force) < 0)
-			goto out_delete;
+	if (perf_data__open(&self->data, name, mode, force))
+		goto out_delete_session;
+
+	if (perf_data__is_ro(&self->data)) {
+		if (perf_session__open(self) < 0)
+			goto out_close_data;
 		perf_session__update_sample_type(self);
-	} else if (mode == O_WRONLY) {
+	} else {
 		/*
 		 * In O_RDONLY mode this will be performed when reading the
 		 * kernel MMAP event, in perf_event__process_mmap().
 		 */
 		if (perf_session__create_kernel_maps(self) < 0)
-			goto out_delete;
+			goto out_close_data;
 	}
 
 	if (ops && ops->ordering_requires_timestamps &&
@@ -177,9 +135,12 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 		ops->ordered_samples = false;
 	}
 
-out:
 	return self;
-out_delete:
+
+out_close_data:
+	perf_data__close(&self->data);
+
+out_delete_session:
 	perf_session__delete(self);
 	return NULL;
 }
@@ -213,7 +174,7 @@ void perf_session__delete(struct perf_session *self)
 	perf_session__delete_dead_threads(self);
 	perf_session__delete_threads(self);
 	machine__exit(&self->host_machine);
-	close(self->fd);
+	perf_data__close(&self->data);
 	free(self);
 }
 
@@ -814,6 +775,8 @@ static int perf_session__preprocess_sample(struct perf_session *session,
 static int perf_session__process_user_event(struct perf_session *session, union perf_event *event,
 					    struct perf_event_ops *ops, u64 file_offset)
 {
+	int fd = perf_session__fd(session);
+
 	dump_event(session, event, file_offset, NULL);
 
 	/* These events are processed right away */
@@ -824,7 +787,7 @@ static int perf_session__process_user_event(struct perf_session *session, union
 		return ops->event_type(event, session);
 	case PERF_RECORD_HEADER_TRACING_DATA:
 		/* setup for reading amidst mmap */
-		lseek(session->fd, file_offset, SEEK_SET);
+		lseek(fd, file_offset, SEEK_SET);
 		return ops->tracing_data(event, session);
 	case PERF_RECORD_HEADER_BUILD_ID:
 		return ops->build_id(event, session);
@@ -942,12 +905,13 @@ static int __perf_session__process_pipe_events(struct perf_session *self,
 	u64 head;
 	int err;
 	void *p;
+	int fd = perf_session__fd(self);
 
 	perf_event_ops__fill_defaults(ops);
 
 	head = 0;
 more:
-	err = readn(self->fd, &event, sizeof(struct perf_event_header));
+	err = readn(fd, &event, sizeof(struct perf_event_header));
 	if (err <= 0) {
 		if (err == 0)
 			goto done;
@@ -967,7 +931,7 @@ more:
 	p += sizeof(struct perf_event_header);
 
 	if (size - sizeof(struct perf_event_header)) {
-		err = readn(self->fd, p, size - sizeof(struct perf_event_header));
+		err = readn(fd, p, size - sizeof(struct perf_event_header));
 		if (err <= 0) {
 			if (err == 0) {
 				pr_err("unexpected end of event stream\n");
@@ -1042,6 +1006,7 @@ int __perf_session__process_events(struct perf_session *session,
 	char *buf, *mmaps[8];
 	union perf_event *event;
 	uint32_t size;
+	int fd = perf_session__fd(session);
 
 	perf_event_ops__fill_defaults(ops);
 
@@ -1070,7 +1035,7 @@ int __perf_session__process_events(struct perf_session *session,
 		mmap_flags = MAP_PRIVATE;
 	}
 remap:
-	buf = mmap(NULL, mmap_size, mmap_prot, mmap_flags, session->fd,
+	buf = mmap(NULL, mmap_size, mmap_prot, mmap_flags, fd,
 		   file_offset);
 	if (buf == MAP_FAILED) {
 		pr_err("failed to mmap file\n");
@@ -1142,11 +1107,12 @@ int perf_session__process_events(struct perf_session *self,
 	if (perf_session__register_idle_thread(self) == NULL)
 		return -ENOMEM;
 
-	if (!self->fd_pipe)
+	if (!perf_session__is_pipe(self))
 		err = __perf_session__process_events(self,
-						     self->header.data_offset,
-						     self->header.data_size,
-						     self->size, ops);
+					     self->header.data_offset,
+					     self->header.data_size,
+					     perf_data__size(&self->data),
+					     ops);
 	else
 		err = __perf_session__process_pipe_events(self, ops);
 
@@ -1354,11 +1320,12 @@ void perf_session__fprintf_info(struct perf_session *session, FILE *fp,
 {
 	struct stat st;
 	int ret;
+	int fd = perf_session__fd(session);
 
 	if (session == NULL || fp == NULL)
 		return;
 
-	ret = fstat(session->fd, &st);
+	ret = fstat(fd, &st);
 	if (ret == -1)
 		return;
 
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index a81d666..cbc37f3 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -6,6 +6,7 @@
 #include "header.h"
 #include "symbol.h"
 #include "thread.h"
+#include "data.h"
 #include <linux/rbtree.h>
 #include "../../../include/linux/perf_event.h"
 
@@ -28,7 +29,7 @@ struct ordered_samples {
 
 struct perf_session {
 	struct perf_header	header;
-	unsigned long		size;
+	struct perf_data	data;
 	unsigned long		mmap_window;
 	struct rb_root		threads;
 	struct list_head	dead_threads;
@@ -45,8 +46,6 @@ struct perf_session {
 	struct hists		hists;
 	u64			sample_type;
 	int			sample_size;
-	int			fd;
-	bool			fd_pipe;
 	bool			repipe;
 	bool			sample_id_all;
 	u16			id_hdr_size;
@@ -54,7 +53,6 @@ struct perf_session {
 	char			*cwd;
 	struct ordered_samples	ordered_samples;
 	struct callchain_cursor	callchain_cursor;
-	char			filename[0];
 };
 
 struct perf_evsel;
@@ -88,9 +86,8 @@ struct perf_event_ops {
 	bool		ordering_requires_timestamps;
 };
 
-struct perf_session *perf_session__new(const char *filename, int mode,
-				       bool force, bool repipe,
-				       struct perf_event_ops *ops);
+struct perf_session *perf_session__new(const char *name, int mode, bool force,
+				       bool repipe, struct perf_event_ops *ops);
 void perf_session__delete(struct perf_session *self);
 
 void perf_event_header__bswap(struct perf_event_header *self);
@@ -179,4 +176,19 @@ int perf_session__cpu_bitmap(struct perf_session *session,
 			     const char *cpu_list, unsigned long *cpu_bitmap);
 
 void perf_session__fprintf_info(struct perf_session *s, FILE *fp, bool full);
+
+static inline bool perf_session__is_new(struct perf_session *self)
+{
+	return perf_data__is_new(&self->data);
+}
+
+static inline int perf_session__fd(struct perf_session *self)
+{
+	return perf_data__fd(&self->data);
+}
+
+static inline int perf_session__is_pipe(struct perf_session *self)
+{
+	return perf_data__is_pipe(&self->data);
+}
 #endif /* __PERF_SESSION_H */
-- 
1.7.4

