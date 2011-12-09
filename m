Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab1LIRbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:31:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971Ab1LIRbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:31:01 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 4/4] perf, tool: Introducing perf_data object
Date: Fri,  9 Dec 2011 18:30:38 +0100
Message-Id: <1323451838-23081-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1323451838-23081-1-git-send-email-jolsa@redhat.com>
References: <1323451838-23081-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding perf_data object to handle input/output data files.
The objective is to have this functionality centralized
and ready for supporting multiple event data streams.

All the intput/output file related functions originally scatered
through the whole code are now place in perf_mmap object.

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
 tools/perf/builtin-annotate.c     |    2 +-
 tools/perf/builtin-buildid-list.c |    4 +-
 tools/perf/builtin-diff.c         |    6 +-
 tools/perf/builtin-evlist.c       |    3 +-
 tools/perf/builtin-inject.c       |    3 +-
 tools/perf/builtin-kmem.c         |    3 +-
 tools/perf/builtin-lock.c         |    3 +-
 tools/perf/builtin-record.c       |  102 ++++++-------------
 tools/perf/builtin-report.c       |    2 +-
 tools/perf/builtin-sched.c        |    6 +-
 tools/perf/builtin-script.c       |    3 +-
 tools/perf/builtin-timechart.c    |    5 +-
 tools/perf/builtin-top.c          |    8 +-
 tools/perf/util/data.c            |  201 +++++++++++++++++++++++++++++++++++++
 tools/perf/util/data.h            |   64 ++++++++++++
 tools/perf/util/header.c          |   28 +++---
 tools/perf/util/header.h          |    4 +-
 tools/perf/util/session.c         |  111 +++++++-------------
 tools/perf/util/session.h         |   21 +++-
 20 files changed, 396 insertions(+), 185 deletions(-)
 create mode 100644 tools/perf/util/data.c
 create mode 100644 tools/perf/util/data.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1e63246..ea0a2fd 100644
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
@@ -340,6 +341,7 @@ LIB_OBJS += $(OUTPUT)util/map.o
 LIB_OBJS += $(OUTPUT)util/pstack.o
 LIB_OBJS += $(OUTPUT)util/session.o
 LIB_OBJS += $(OUTPUT)util/mmap.o
+LIB_OBJS += $(OUTPUT)util/data.o
 LIB_OBJS += $(OUTPUT)util/thread.o
 LIB_OBJS += $(OUTPUT)util/thread_map.o
 LIB_OBJS += $(OUTPUT)util/trace-event-parse.o
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index d449645..a16d43a 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -174,7 +174,7 @@ static int __cmd_annotate(struct perf_annotate *ann)
 	struct perf_evsel *pos;
 	u64 total_nr_samples;
 
-	session = perf_session__new(ann->input_name, O_RDONLY,
+	session = perf_session__new(ann->input_name, PERF_DATA_READ,
 				    ann->force, false, &ann->tool);
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
index 4f19513..0bdb18b 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -148,8 +148,10 @@ static int __cmd_diff(void)
 	int ret, i;
 	struct perf_session *session[2];
 
-	session[0] = perf_session__new(input_old, O_RDONLY, force, false, &perf_diff);
-	session[1] = perf_session__new(input_new, O_RDONLY, force, false, &perf_diff);
+	session[0] = perf_session__new(input_old, PERF_DATA_READ, force,
+				       false, &perf_diff);
+	session[1] = perf_session__new(input_new, PERF_DATA_READ, force,
+				       false, &perf_diff);
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
index 09c1061..79487d2 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -235,7 +235,8 @@ static int __cmd_inject(void)
 		perf_inject.tracing_data = perf_event__repipe_tracing_data;
 	}
 
-	session = perf_session__new(input_name, O_RDONLY, false, true, &perf_inject);
+	session = perf_session__new(input_name, PERF_DATA_READ, false,
+				    true, &perf_inject);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 886174e..0c524c0 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -484,7 +484,8 @@ static void sort_result(void)
 static int __cmd_kmem(void)
 {
 	int err = -EINVAL;
-	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
+	struct perf_session *session = perf_session__new(input_name,
+							 PERF_DATA_READ,
 							 0, false, &perf_kmem);
 	if (session == NULL)
 		return -ENOMEM;
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 4db5e52..dbb2909 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -873,7 +873,8 @@ static struct perf_tool eops = {
 
 static int read_events(void)
 {
-	session = perf_session__new(input_name, O_RDONLY, 0, false, &eops);
+	session = perf_session__new(input_name, PERF_DATA_READ, false,
+				    false, &eops);
 	if (!session)
 		die("Initializing perf session failed\n");
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index b58f94d..3fa3263 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -32,11 +32,6 @@
 #include <sched.h>
 #include <sys/mman.h>
 
-enum write_mode_t {
-	WRITE_FORCE,
-	WRITE_APPEND
-};
-
 struct perf_record {
 	struct perf_tool	tool;
 	struct perf_record_opts	opts;
@@ -45,13 +40,11 @@ struct perf_record {
 	struct perf_evlist	*evlist;
 	struct perf_session	*session;
 	const char		*progname;
-	int			output;
 	int			realtime_prio;
-	enum write_mode_t	write_mode;
+	enum perf_data_mode	write_mode;
 	bool			no_buildid;
 	bool			no_buildid_cache;
 	bool			force;
-	bool			file_new;
 	bool			append_file;
 	off_t			post_processing_offset;
 };
@@ -63,8 +56,10 @@ static void advance_output(struct perf_record *rec, size_t size)
 
 static void write_output(struct perf_record *rec, void *buf, size_t size)
 {
+	int fd = perf_session__fd(rec->session);
+
 	while (size) {
-		int ret = write(rec->output, buf, size);
+		int ret = write(fd, buf, size);
 
 		if (ret < 0)
 			die("failed to write");
@@ -240,7 +235,7 @@ try_again:
 	if (perf_evlist__mmap(evlist, opts->mmap_pages, false) < 0)
 		die("failed to mmap with %d (%s)\n", errno, strerror(errno));
 
-	if (rec->file_new)
+	if (perf_session__is_new(session))
 		session->evlist = evlist;
 	else {
 		if (!perf_evlist__equal(session->evlist, evlist)) {
@@ -254,12 +249,11 @@ try_again:
 
 static int process_buildids(struct perf_record *rec)
 {
-	u64 size = lseek(rec->output, 0, SEEK_CUR);
+	u64 size = lseek(perf_session__fd(rec->session), 0, SEEK_CUR);
 
 	if (size == 0)
 		return 0;
 
-	rec->session->fd = rec->output;
 	return __perf_session__process_events(rec->session, rec->post_processing_offset,
 					      size - rec->post_processing_offset,
 					      size, &build_id__mark_dso_hit_ops);
@@ -269,13 +263,13 @@ static void perf_record__exit(int status __used, void *arg)
 {
 	struct perf_record *rec = arg;
 
-	if (!rec->opts.pipe_output) {
+	if (!perf_session__is_pipe(rec->session)) {
 		rec->session->header.data_size += rec->bytes_written;
 
 		if (!rec->no_buildid)
 			process_buildids(rec);
 		perf_session__write_header(rec->session, rec->evlist,
-					   rec->output, true);
+					   true);
 		perf_session__delete(rec->session);
 		perf_evlist__delete(rec->evlist);
 		symbol__exit();
@@ -346,9 +340,7 @@ static int perf_record__mmap_read_all(struct perf_record *rec)
 
 static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 {
-	struct stat st;
-	int flags;
-	int err, output;
+	int err;
 	unsigned long waking = 0;
 	const bool forks = argc > 0;
 	struct machine *machine;
@@ -365,59 +357,22 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	signal(SIGINT, sig_handler);
 	signal(SIGUSR1, sig_handler);
 
-	if (!output_name) {
-		if (!fstat(STDOUT_FILENO, &st) && S_ISFIFO(st.st_mode))
-			opts->pipe_output = true;
-		else
-			rec->output_name = output_name = "perf.data";
-	}
-	if (output_name) {
-		if (!strcmp(output_name, "-"))
-			opts->pipe_output = true;
-		else if (!stat(output_name, &st) && st.st_size) {
-			if (rec->write_mode == WRITE_FORCE) {
-				char oldname[PATH_MAX];
-				snprintf(oldname, sizeof(oldname), "%s.old",
-					 output_name);
-				unlink(oldname);
-				rename(output_name, oldname);
-			}
-		} else if (rec->write_mode == WRITE_APPEND) {
-			rec->write_mode = WRITE_FORCE;
-		}
-	}
-
-	flags = O_CREAT|O_RDWR;
-	if (rec->write_mode == WRITE_APPEND)
-		rec->file_new = 0;
-	else
-		flags |= O_TRUNC;
-
-	if (opts->pipe_output)
-		output = STDOUT_FILENO;
-	else
-		output = open(output_name, flags, S_IRUSR | S_IWUSR);
-	if (output < 0) {
-		perror("failed to create output file");
-		exit(-1);
-	}
-
-	rec->output = output;
-
-	session = perf_session__new(output_name, O_WRONLY,
-				    rec->write_mode == WRITE_FORCE, false, NULL);
+	session = perf_session__new(output_name, rec->write_mode,
+				    rec->write_mode == PERF_DATA_WRITE_TRUNC,
+				    false, NULL);
 	if (session == NULL) {
 		pr_err("Not enough memory for reading perf file header\n");
 		return -1;
 	}
 
 	rec->session = session;
+	opts->pipe_output = perf_session__is_pipe(session);
 
 	if (!rec->no_buildid)
 		perf_header__set_feat(&session->header, HEADER_BUILD_ID);
 
-	if (!rec->file_new) {
-		err = perf_session__read_header(session, output);
+	if (!perf_session__is_new(session)) {
+		err = perf_session__read_header(session);
 		if (err < 0)
 			goto out_delete_session;
 	}
@@ -453,18 +408,18 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	 */
 	on_exit(perf_record__exit, rec);
 
-	if (opts->pipe_output) {
-		err = perf_header__write_pipe(output);
+	if (perf_session__is_pipe(session)) {
+		err = perf_header__write_pipe(perf_session__fd(session));
 		if (err < 0)
 			return err;
-	} else if (rec->file_new) {
-		err = perf_session__write_header(session, evsel_list,
-						 output, false);
+	} else if (perf_session__is_new(session)) {
+		err = perf_session__write_header(session, evsel_list, false);
 		if (err < 0)
 			return err;
 	}
 
-	rec->post_processing_offset = lseek(output, 0, SEEK_CUR);
+	rec->post_processing_offset = lseek(perf_session__fd(session),
+					    0, SEEK_CUR);
 
 	machine = perf_session__find_host_machine(session);
 	if (!machine) {
@@ -472,7 +427,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		return -1;
 	}
 
-	if (opts->pipe_output) {
+	if (perf_session__is_pipe(session)) {
 		err = perf_event__synthesize_attrs(tool, session,
 						   process_synthesized_event);
 		if (err < 0) {
@@ -496,8 +451,10 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 			 * return this more properly and also
 			 * propagate errors that now are calling die()
 			 */
-			err = perf_event__synthesize_tracing_data(tool, output, evsel_list,
-								  process_synthesized_event);
+			err = perf_event__synthesize_tracing_data(tool,
+						perf_session__fd(session),
+						evsel_list,
+						process_synthesized_event);
 			if (err <= 0) {
 				pr_err("Couldn't record tracing data.\n");
 				return err;
@@ -612,8 +569,7 @@ static struct perf_record record = {
 		.freq		     = 1000,
 		.sample_id_all_avail = true,
 	},
-	.write_mode = WRITE_FORCE,
-	.file_new   = true,
+	.write_mode = PERF_DATA_WRITE_TRUNC,
 };
 
 /*
@@ -705,9 +661,9 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 				" You need to choose between -f and -A");
 		usage_with_options(record_usage, record_options);
 	} else if (rec->append_file) {
-		rec->write_mode = WRITE_APPEND;
+		rec->write_mode = PERF_DATA_WRITE_APPEND;
 	} else {
-		rec->write_mode = WRITE_FORCE;
+		rec->write_mode = PERF_DATA_WRITE_TRUNC;
 	}
 
 	if (nr_cgroups && !rec->opts.system_wide) {
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ece7c5d..52510f6 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -254,7 +254,7 @@ static int __cmd_report(struct perf_report *rep)
 
 	signal(SIGINT, sig_handler);
 
-	session = perf_session__new(rep->input_name, O_RDONLY,
+	session = perf_session__new(rep->input_name, PERF_DATA_READ,
 				    rep->force, false, &rep->tool);
 	if (session == NULL)
 		return -ENOMEM;
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 6284ed2..78b332f 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1639,8 +1639,10 @@ static void read_events(bool destroy, struct perf_session **psession)
 		{ "sched:sched_process_exit", process_sched_exit_event, },
 		{ "sched:sched_migrate_task", process_sched_migrate_task_event, },
 	};
-	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
-							 0, false, &perf_sched);
+	struct perf_session *session;
+
+	session = perf_session__new(input_name, PERF_DATA_READ,
+				    false, false, &perf_sched);
 	if (session == NULL)
 		die("No Memory");
 
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 619d6dc..55b6b22 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1275,7 +1275,8 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 	if (!script_name)
 		setup_pager();
 
-	session = perf_session__new(input_name, O_RDONLY, 0, false, &perf_script);
+	session = perf_session__new(input_name, PERF_DATA_READ, false,
+				    false, &perf_script);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 135376a..0369081 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -990,10 +990,11 @@ static struct perf_tool perf_timechart = {
 
 static int __cmd_timechart(void)
 {
-	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
-							 0, false, &perf_timechart);
+	struct perf_session *session;
 	int ret = -EINVAL;
 
+	session = perf_session__new(input_name, PERF_DATA_READ,
+				    false, false, &perf_timechart);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c3836b9..b439d6d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -935,11 +935,9 @@ static int __cmd_top(struct perf_top *top)
 {
 	pthread_t thread;
 	int ret;
-	/*
-	 * FIXME: perf_session__new should allow passing a O_MMAP, so that all this
-	 * mmap reading, etc is encapsulated in it. Use O_WRONLY for now.
-	 */
-	top->session = perf_session__new(NULL, O_WRONLY, false, false, NULL);
+
+	top->session = perf_session__new(NULL, PERF_DATA_NONE,
+					 false, false, NULL);
 	if (top->session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
new file mode 100644
index 0000000..c2f5ffd
--- /dev/null
+++ b/tools/perf/util/data.c
@@ -0,0 +1,201 @@
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
+	unlink(oldname);
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
index 0000000..3f73dd3
--- /dev/null
+++ b/tools/perf/util/data.h
@@ -0,0 +1,64 @@
+#ifndef __PERF_DATA_H
+#define __PERF_DATA_H
+
+#include <stdbool.h>
+#include <linux/list.h>
+#include "mmap.h"
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
index 5b01449..a0f3944 100644
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
@@ -2222,7 +2222,6 @@ int perf_event__synthesize_tracing_data(struct perf_tool *tool, int fd,
 	union perf_event ev;
 	struct tracing_data *tdata;
 	ssize_t size = 0, aligned_size = 0, padding;
-	int err __used = 0;
 
 	/*
 	 * We are going to store the size of the data followed
@@ -2265,18 +2264,19 @@ int perf_event__process_tracing_data(union perf_event *event,
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
index 09365b3..22de206 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -70,10 +70,10 @@ struct perf_header {
 struct perf_evlist;
 struct perf_session;
 
-int perf_session__read_header(struct perf_session *session, int fd);
+int perf_session__read_header(struct perf_session *session);
 int perf_session__write_header(struct perf_session *session,
 			       struct perf_evlist *evlist,
-			       int fd, bool at_exit);
+			       bool at_exit);
 int perf_header__write_pipe(int fd);
 
 int perf_header__push_event(u64 id, const char *name);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index d9318d8..003e5ba 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -14,69 +14,26 @@
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
 
 void perf_session__update_sample_type(struct perf_session *self)
@@ -107,13 +64,12 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 				       bool force, bool repipe,
 				       struct perf_tool *tool)
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
 	/*
 	 * On 64bit we can mmap the data file in one go. No need for tiny mmap
 	 * slices. On 32bit we use 32MB.
@@ -130,17 +86,20 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 	INIT_LIST_HEAD(&self->ordered_samples.to_free);
 	machine__init(&self->host_machine, "", HOST_KERNEL_ID);
 
-	if (mode == O_RDONLY) {
-		if (perf_session__open(self, force) < 0)
-			goto out_delete;
+	if (perf_data__open(&self->data, filename, mode, force))
+		goto out_delete_session;
+
+	if (perf_data__is_ro(&self->data)) {
+		if (perf_session__open(self) < 0)
+			goto out_close_data;
 		perf_session__update_sample_type(self);
-	} else if (mode == O_WRONLY) {
+	} else {
 		/*
-		 * In O_RDONLY mode this will be performed when reading the
+		 * In read only mode this will be performed when reading the
 		 * kernel MMAP event, in perf_event__process_mmap().
 		 */
 		if (perf_session__create_kernel_maps(self) < 0)
-			goto out_delete;
+			goto out_close_data;
 	}
 
 	if (tool && tool->ordering_requires_timestamps &&
@@ -149,9 +108,12 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 		tool->ordered_samples = false;
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
@@ -195,7 +157,7 @@ void perf_session__delete(struct perf_session *self)
 	perf_session__delete_dead_threads(self);
 	perf_session__delete_threads(self);
 	machine__exit(&self->host_machine);
-	close(self->fd);
+	perf_data__close(&self->data);
 	free(self);
 }
 
@@ -830,6 +792,7 @@ static int perf_session__process_user_event(struct perf_session *session, union
 					    struct perf_tool *tool, u64 file_offset)
 {
 	int err;
+	int fd = perf_session__fd(session);
 
 	dump_event(session, event, file_offset, NULL);
 
@@ -844,7 +807,7 @@ static int perf_session__process_user_event(struct perf_session *session, union
 		return tool->event_type(tool, event);
 	case PERF_RECORD_HEADER_TRACING_DATA:
 		/* setup for reading amidst mmap */
-		lseek(session->fd, file_offset, SEEK_SET);
+		lseek(fd, file_offset, SEEK_SET);
 		return tool->tracing_data(event, session);
 	case PERF_RECORD_HEADER_BUILD_ID:
 		return tool->build_id(tool, event, session);
@@ -967,12 +930,13 @@ static int __perf_session__process_pipe_events(struct perf_session *self,
 	u64 head;
 	int err;
 	void *p;
+	int fd = perf_session__fd(self);
 
 	perf_tool__fill_defaults(tool);
 
 	head = 0;
 more:
-	err = readn(self->fd, &event, sizeof(struct perf_event_header));
+	err = readn(fd, &event, sizeof(struct perf_event_header));
 	if (err <= 0) {
 		if (err == 0)
 			goto done;
@@ -992,7 +956,7 @@ more:
 	p += sizeof(struct perf_event_header);
 
 	if (size - sizeof(struct perf_event_header)) {
-		err = readn(self->fd, p, size - sizeof(struct perf_event_header));
+		err = readn(fd, p, size - sizeof(struct perf_event_header));
 		if (err <= 0) {
 			if (err == 0) {
 				pr_err("unexpected end of event stream\n");
@@ -1067,6 +1031,7 @@ int __perf_session__process_events(struct perf_session *session,
 	char *buf, *mmaps[8];
 	union perf_event *event;
 	uint32_t size;
+	int fd = perf_session__fd(session);
 
 	perf_tool__fill_defaults(tool);
 
@@ -1095,7 +1060,7 @@ int __perf_session__process_events(struct perf_session *session,
 		mmap_flags = MAP_PRIVATE;
 	}
 remap:
-	buf = mmap(NULL, mmap_size, mmap_prot, mmap_flags, session->fd,
+	buf = mmap(NULL, mmap_size, mmap_prot, mmap_flags, fd,
 		   file_offset);
 	if (buf == MAP_FAILED) {
 		pr_err("failed to mmap file\n");
@@ -1167,11 +1132,12 @@ int perf_session__process_events(struct perf_session *self,
 	if (perf_session__register_idle_thread(self) == NULL)
 		return -ENOMEM;
 
-	if (!self->fd_pipe)
+	if (!perf_session__is_pipe(self))
 		err = __perf_session__process_events(self,
-						     self->header.data_offset,
-						     self->header.data_size,
-						     self->size, tool);
+				self->header.data_offset,
+				self->header.data_size,
+				perf_data__size(&self->data),
+				tool);
 	else
 		err = __perf_session__process_pipe_events(self, tool);
 
@@ -1402,11 +1368,12 @@ void perf_session__fprintf_info(struct perf_session *session, FILE *fp,
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
index 30e9c6b6..ad1bddf 100644
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
 	struct machine		host_machine;
 	struct rb_root		machines;
@@ -42,15 +43,12 @@ struct perf_session {
 	struct hists		hists;
 	u64			sample_type;
 	int			sample_size;
-	int			fd;
-	bool			fd_pipe;
 	bool			repipe;
 	bool			sample_id_all;
 	u16			id_hdr_size;
 	int			cwdlen;
 	char			*cwd;
 	struct ordered_samples	ordered_samples;
-	char			filename[0];
 };
 
 struct perf_tool;
@@ -145,4 +143,19 @@ int perf_session__cpu_bitmap(struct perf_session *session,
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

