Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329Ab0EAGlc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 02:41:32 -0400
Received: from mail-iw0-f182.google.com ([209.85.223.182]:63512 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab0EAGl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 02:41:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OHr9BUkfH/HMYfoNsALkDDcuLLl+D9aHZvCO8qJIwNxhtvUtA1lCzrT+v1p5pOW2TC
         qiDIUBc2fJUEfQLIBkYukoRapvRc6TBGRbkTbhCwKzv6n6U4sUq7ldu7y8ECNcoar6dJ
         /XYKwI2y00SGc9A4ccifhEeql6kv6gt9ICNas=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       acme@ghostprotocols.net
Subject: [RFC][PATCH 2/2] perf: add perf-inject builtin
Date: Sat,  1 May 2010 01:41:20 -0500
Message-Id: <1272696080-16435-3-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1272696080-16435-1-git-send-email-tzanussi@gmail.com>
References: <1272696080-16435-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, perf 'live mode' writes build-ids at the end of the
session, which isn't actually useful for processing live mode events.

What would be better would be to have the build-ids sent before any of
the samples that reference them, which can be done by processing the
event stream and retrieving the build-ids on the first hit.  Doing
that in perf-record itself, however, is off-limits.

This patch introduces perf-inject, which does the same job while
leaving perf-record untouched.  Normal mode perf still records the
build-ids at the end of the session as it should, but for live mode,
perf-inject can be injected in between the record and report steps
e.g.:

perf record -o - ./hackbench 10 | perf inject -v -b | perf report -v -i -

perf-inject reads a perf-record event stream and repipes it to stdout.
At any point the processing code can inject other events into the
event stream - in this case build-ids (-b option) are read and
injected as needed into the event stream.

Build-ids are just the first user of perf-inject - potentially
anything that needs userspace processing to augment the trace stream
with additional information could make use of this facility.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/Makefile                |    1 +
 tools/perf/builtin-annotate.c      |    2 +-
 tools/perf/builtin-buildid-list.c  |    2 +-
 tools/perf/builtin-diff.c          |    4 +-
 tools/perf/builtin-inject.c        |  228 ++++++++++++++++++++++++++++++++++++
 tools/perf/builtin-kmem.c          |    2 +-
 tools/perf/builtin-lock.c          |    2 +-
 tools/perf/builtin-record.c        |    2 +-
 tools/perf/builtin-report.c        |    2 +-
 tools/perf/builtin-sched.c         |    2 +-
 tools/perf/builtin-timechart.c     |    2 +-
 tools/perf/builtin-top.c           |    2 +-
 tools/perf/builtin-trace.c         |    2 +-
 tools/perf/builtin.h               |    1 +
 tools/perf/perf.c                  |    1 +
 tools/perf/util/header.c           |   35 +++++--
 tools/perf/util/session.c          |    3 +-
 tools/perf/util/session.h          |    3 +-
 tools/perf/util/trace-event-read.c |   19 +++-
 tools/perf/util/trace-event.h      |    2 +-
 20 files changed, 293 insertions(+), 24 deletions(-)
 create mode 100644 tools/perf/builtin-inject.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 739c441..73a9666 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -491,6 +491,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-kmem.o
 BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
 BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
 BUILTIN_OBJS += $(OUTPUT)builtin-test.o
+BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
 
 PERFLIBS = $(LIB_FILE)
 
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index b57dbcf..ee154b5 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -554,7 +554,7 @@ static int __cmd_annotate(void)
 	int ret;
 	struct perf_session *session;
 
-	session = perf_session__new(input_name, O_RDONLY, force);
+	session = perf_session__new(input_name, O_RDONLY, force, false);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 7dc3b2e..44a47e1 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -39,7 +39,7 @@ static int __cmd_buildid_list(void)
 	int err = -1;
 	struct perf_session *session;
 
-	session = perf_session__new(input_name, O_RDONLY, force);
+	session = perf_session__new(input_name, O_RDONLY, force, false);
 	if (session == NULL)
 		return -1;
 
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 207e860..4cce68f 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -156,8 +156,8 @@ static int __cmd_diff(void)
 	int ret, i;
 	struct perf_session *session[2];
 
-	session[0] = perf_session__new(input_old, O_RDONLY, force);
-	session[1] = perf_session__new(input_new, O_RDONLY, force);
+	session[0] = perf_session__new(input_old, O_RDONLY, force, false);
+	session[1] = perf_session__new(input_new, O_RDONLY, force, false);
 	if (session[0] == NULL || session[1] == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
new file mode 100644
index 0000000..a5902a3
--- /dev/null
+++ b/tools/perf/builtin-inject.c
@@ -0,0 +1,228 @@
+/*
+ * builtin-inject.c
+ *
+ * Builtin inject command: Examine the live mode (stdin) event stream
+ * and repipe it to stdout while optionally injecting additional
+ * events into it.
+ */
+#include "builtin.h"
+
+#include "perf.h"
+#include "util/session.h"
+#include "util/debug.h"
+
+#include "util/parse-options.h"
+
+static char		const *input_name = "-";
+static bool		inject_build_ids;
+
+static int event__repipe(event_t *event __used,
+			 struct perf_session *session __used)
+{
+	uint32_t size;
+	void *buf = event;
+
+	size = event->header.size;
+
+	while (size) {
+		int ret = write(STDOUT_FILENO, buf, size);
+		if (ret < 0)
+			return -errno;
+
+		size -= ret;
+		buf += ret;
+	}
+
+	return 0;
+}
+
+static int event__repipe_mmap(event_t *self, struct perf_session *session)
+{
+	int err;
+
+	err = event__process_mmap(self, session);
+	event__repipe(self, session);
+
+	return err;
+}
+
+static int event__repipe_task(event_t *self, struct perf_session *session)
+{
+	int err;
+
+	err = event__process_task(self, session);
+	event__repipe(self, session);
+
+	return err;
+}
+
+static int event__repipe_tracing_data(event_t *self,
+				      struct perf_session *session)
+{
+	int err;
+
+	event__repipe(self, session);
+	err = event__process_tracing_data(self, session);
+
+	return err;
+}
+
+static int read_buildid(struct map *self, struct perf_session *session)
+{
+	const char *name = self->dso->long_name;
+	int err;
+
+	if (filename__read_build_id(self->dso->long_name, self->dso->build_id,
+				    sizeof(self->dso->build_id)) > 0) {
+		char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+
+		self->dso->has_build_id = true;
+
+		build_id__sprintf(self->dso->build_id,
+				  sizeof(self->dso->build_id),
+				  sbuild_id);
+		pr_debug("build id found for %s: %s\n", self->dso->long_name,
+			 sbuild_id);
+	}
+
+	if (self->dso->has_build_id) {
+		u16 misc = PERF_RECORD_MISC_USER;
+		struct machine *machine;
+
+		misc = self->dso->kernel ? PERF_RECORD_MISC_KERNEL : misc;
+
+		machine = perf_session__find_host_machine(session);
+		if (!machine) {
+			pr_err("Can't find machine for session\n");
+			return -1;
+		}
+
+		err = event__synthesize_build_id(self->dso, misc,
+						 event__repipe, machine,
+						 session);
+		if (err) {
+			pr_err("Can't synthesize build_id event for %s\n",
+			       name);
+			return -1;
+		}
+	} else {
+		pr_debug("no build_id found for %s\n", name);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int event__inject_buildid(event_t *event, struct perf_session *session)
+{
+	struct addr_location al;
+	struct thread *thread;
+	u8 cpumode;
+	int err = 0;
+
+	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+
+	thread = perf_session__findnew(session, event->ip.pid);
+	if (thread == NULL) {
+		pr_err("problem processing %d event, skipping it.\n",
+		       event->header.type);
+		err = -1;
+		goto repipe;
+	}
+
+	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
+			      event->ip.pid, event->ip.ip, &al);
+
+	if (al.map != NULL) {
+		if (!al.map->dso->hit) {
+			al.map->dso->hit = 1;
+			if (map__load(al.map, NULL) >= 0)
+				read_buildid(al.map, session);
+			else
+				pr_warning("no symbols found in %s, maybe "
+					   "install a debug package?\n",
+					   al.map->dso->long_name);
+		}
+	}
+
+repipe:
+	event__repipe(event, session);
+	return err;
+}
+
+struct perf_event_ops inject_ops = {
+	.sample		= event__repipe,
+	.mmap		= event__repipe,
+	.comm		= event__repipe,
+	.fork		= event__repipe,
+	.exit		= event__repipe,
+	.lost		= event__repipe,
+	.read		= event__repipe,
+	.throttle	= event__repipe,
+	.unthrottle	= event__repipe,
+	.attr		= event__repipe,
+	.event_type 	= event__repipe,
+	.tracing_data 	= event__repipe,
+	.build_id 	= event__repipe,
+};
+
+extern volatile int session_done;
+
+static void sig_handler(int sig __attribute__((__unused__)))
+{
+	session_done = 1;
+}
+
+static int __cmd_inject(void)
+{
+	struct perf_session *session;
+	int ret = -EINVAL;
+
+	signal(SIGINT, sig_handler);
+
+	if (inject_build_ids) {
+		inject_ops.sample	= event__inject_buildid;
+		inject_ops.mmap		= event__repipe_mmap;
+		inject_ops.fork		= event__repipe_task;
+		inject_ops.tracing_data	= event__repipe_tracing_data;
+	}
+
+	session = perf_session__new(input_name, O_RDONLY, false, true);
+	if (session == NULL)
+		return -ENOMEM;
+
+	ret = perf_session__process_events(session, &inject_ops);
+
+	perf_session__delete(session);
+
+	return ret;
+}
+
+static const char * const report_usage[] = {
+	"perf inject [<options>]",
+	NULL
+};
+
+static const struct option options[] = {
+	OPT_BOOLEAN('b', "inject build-ids", &inject_build_ids,
+		    "Inject build-ids into the output stream"),
+	OPT_INCR('v', "verbose", &verbose,
+		 "be more verbose (show build ids, etc)"),
+	OPT_END()
+};
+
+int cmd_inject(int argc, const char **argv, const char *prefix __used)
+{
+	argc = parse_options(argc, argv, options, report_usage, 0);
+
+	/*
+	 * Any (unrecognized) arguments left?
+	 */
+	if (argc)
+		usage_with_options(report_usage, options);
+
+	if (symbol__init() < 0)
+		return -1;
+
+	return __cmd_inject();
+}
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index ee05dba..31f60a2 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -492,7 +492,7 @@ static void sort_result(void)
 static int __cmd_kmem(void)
 {
 	int err = -EINVAL;
-	struct perf_session *session = perf_session__new(input_name, O_RDONLY, 0);
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY, 0, false);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index ce27675..6605000 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -818,7 +818,7 @@ static struct perf_event_ops eops = {
 
 static int read_events(void)
 {
-	session = perf_session__new(input_name, O_RDONLY, 0);
+	session = perf_session__new(input_name, O_RDONLY, 0, false);
 	if (!session)
 		die("Initializing perf session failed\n");
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 5d21a3a..8364e00 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -548,7 +548,7 @@ static int __cmd_record(int argc, const char **argv)
 	}
 
 	session = perf_session__new(output_name, O_WRONLY,
-				    write_mode == WRITE_FORCE);
+				    write_mode == WRITE_FORCE, false);
 	if (session == NULL) {
 		pr_err("Not enough memory for reading perf file header\n");
 		return -1;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f1b46eb..0152b54 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -289,7 +289,7 @@ static int __cmd_report(void)
 
 	signal(SIGINT, sig_handler);
 
-	session = perf_session__new(input_name, O_RDONLY, force);
+	session = perf_session__new(input_name, O_RDONLY, force, false);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 94453f1..aef6ed0 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1660,7 +1660,7 @@ static struct perf_event_ops event_ops = {
 static int read_events(void)
 {
 	int err = -EINVAL;
-	struct perf_session *session = perf_session__new(input_name, O_RDONLY, 0);
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY, 0, false);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index c35aa44..5a52ed9 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -936,7 +936,7 @@ static struct perf_event_ops event_ops = {
 
 static int __cmd_timechart(void)
 {
-	struct perf_session *session = perf_session__new(input_name, O_RDONLY, 0);
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY, 0, false);
 	int ret = -EINVAL;
 
 	if (session == NULL)
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index d95281f..3de3977 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1287,7 +1287,7 @@ static int __cmd_top(void)
 	 * FIXME: perf_session__new should allow passing a O_MMAP, so that all this
 	 * mmap reading, etc is encapsulated in it. Use O_WRONLY for now.
 	 */
-	struct perf_session *session = perf_session__new(NULL, O_WRONLY, false);
+	struct perf_session *session = perf_session__new(NULL, O_WRONLY, false, false);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 77f556f..9c483e9 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -661,7 +661,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 	if (!script_name)
 		setup_pager();
 
-	session = perf_session__new(input_name, O_RDONLY, 0);
+	session = perf_session__new(input_name, O_RDONLY, 0, false);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index 34a8a9a..921245b 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -34,5 +34,6 @@ extern int cmd_kmem(int argc, const char **argv, const char *prefix);
 extern int cmd_lock(int argc, const char **argv, const char *prefix);
 extern int cmd_kvm(int argc, const char **argv, const char *prefix);
 extern int cmd_test(int argc, const char **argv, const char *prefix);
+extern int cmd_inject(int argc, const char **argv, const char *prefix);
 
 #endif
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 5ff9b5b..08e0e5d 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -309,6 +309,7 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "lock",	cmd_lock,	0 },
 		{ "kvm",	cmd_kvm,	0 },
 		{ "test",	cmd_test,	0 },
+		{ "inject",	cmd_inject,	0 },
 	};
 	unsigned int i;
 	static const char ext[] = STRIP_EXTENSION;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 83b79e2..2b9f898 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -712,10 +712,18 @@ static int __event_process_build_id(struct build_id_event *bev,
 
 	dso = __dsos__findnew(head, filename);
 	if (dso != NULL) {
+		char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+
 		dso__set_build_id(dso, &bev->build_id);
-			if (filename[0] == '[')
-				dso->kernel = dso_type;
-		}
+
+		if (filename[0] == '[')
+			dso->kernel = dso_type;
+
+		build_id__sprintf(dso->build_id, sizeof(dso->build_id),
+				  sbuild_id);
+		pr_debug("build id event received for %s: %s\n",
+			 dso->long_name, sbuild_id);
+	}
 
 	err = 0;
 out:
@@ -766,7 +774,7 @@ static int perf_file_section__process(struct perf_file_section *self,
 
 	switch (feat) {
 	case HEADER_TRACE_INFO:
-		trace_report(fd);
+		trace_report(fd, false);
 		break;
 
 	case HEADER_BUILD_ID:
@@ -781,12 +789,16 @@ static int perf_file_section__process(struct perf_file_section *self,
 }
 
 static int perf_file_header__read_pipe(struct perf_pipe_file_header *self,
-				       struct perf_header *ph, int fd)
+				       struct perf_header *ph, int fd,
+				       bool repipe)
 {
 	if (do_read(fd, self, sizeof(*self)) <= 0 ||
 	    memcmp(&self->magic, __perf_magic, sizeof(self->magic)))
 		return -1;
 
+	if (repipe && do_write(STDOUT_FILENO, self, sizeof(*self)) < 0)
+		return -1;
+
 	if (self->size != sizeof(*self)) {
 		u64 size = bswap_64(self->size);
 
@@ -804,7 +816,8 @@ static int perf_header__read_pipe(struct perf_session *session, int fd)
 	struct perf_header *self = &session->header;
 	struct perf_pipe_file_header f_header;
 
-	if (perf_file_header__read_pipe(&f_header, self, fd) < 0) {
+	if (perf_file_header__read_pipe(&f_header, self, fd,
+					session->repipe) < 0) {
 		pr_debug("incompatible file format\n");
 		return -EINVAL;
 	}
@@ -1095,12 +1108,17 @@ int event__process_tracing_data(event_t *self,
 	lseek(session->fd, offset + sizeof(struct tracing_data_event),
 	      SEEK_SET);
 
-	size_read = trace_report(session->fd);
+	size_read = trace_report(session->fd, session->repipe);
 
 	padding = ALIGN(size_read, sizeof(u64)) - size_read;
 
 	if (read(session->fd, buf, padding) < 0)
 		die("reading input file");
+	if (session->repipe) {
+		int retw = write(STDOUT_FILENO, buf, padding);
+		if (retw <= 0 || retw != padding)
+			die("repiping tracing data padding");
+	}
 
 	if (size_read + padding != size)
 		die("tracing data size mismatch");
@@ -1109,7 +1127,8 @@ int event__process_tracing_data(event_t *self,
 }
 
 int event__synthesize_build_id(struct dso *pos, u16 misc,
-			       event__handler_t process, struct machine *machine,
+			       event__handler_t process,
+			       struct machine *machine,
 			       struct perf_session *session)
 {
 	event_t ev;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index a8dd73e..5d353e7 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -77,7 +77,7 @@ int perf_session__create_kernel_maps(struct perf_session *self)
 	return ret;
 }
 
-struct perf_session *perf_session__new(const char *filename, int mode, bool force)
+struct perf_session *perf_session__new(const char *filename, int mode, bool force, bool repipe)
 {
 	size_t len = filename ? strlen(filename) + 1 : 0;
 	struct perf_session *self = zalloc(sizeof(*self) + len);
@@ -97,6 +97,7 @@ struct perf_session *perf_session__new(const char *filename, int mode, bool forc
 	self->cwdlen = 0;
 	self->unknown_events = 0;
 	self->machines = RB_ROOT;
+	self->repipe = repipe;
 	self->ordered_samples.flush_limit = ULLONG_MAX;
 	INIT_LIST_HEAD(&self->ordered_samples.samples_head);
 
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 61ca92e..f2b2c6a 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -34,6 +34,7 @@ struct perf_session {
 	u64			sample_type;
 	int			fd;
 	bool			fd_pipe;
+	bool			repipe;
 	int			cwdlen;
 	char			*cwd;
 	struct ordered_samples	ordered_samples;
@@ -59,7 +60,7 @@ struct perf_event_ops {
 	bool	ordered_samples;
 };
 
-struct perf_session *perf_session__new(const char *filename, int mode, bool force);
+struct perf_session *perf_session__new(const char *filename, int mode, bool force, bool repipe);
 void perf_session__delete(struct perf_session *self);
 
 void perf_event_header__bswap(struct perf_event_header *self);
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 44889c9..43f19c1 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -51,6 +51,7 @@ static int long_size;
 static unsigned long	page_size;
 
 static ssize_t calc_data_size;
+static bool repipe;
 
 static int do_read(int fd, void *buf, int size)
 {
@@ -62,6 +63,13 @@ static int do_read(int fd, void *buf, int size)
 		if (ret <= 0)
 			return -1;
 
+		if (repipe) {
+			int retw = write(STDOUT_FILENO, buf, ret);
+
+			if (retw <= 0 || retw != ret)
+				die("repiping input file");
+		}
+
 		size -= ret;
 		buf += ret;
 	}
@@ -116,6 +124,13 @@ static char *read_string(void)
 		if (!r)
 			die("no data");
 
+		if (repipe) {
+			int retw = write(STDOUT_FILENO, &c, 1);
+
+			if (retw <= 0 || retw != r)
+				die("repiping input file string");
+		}
+
 		buf[size++] = c;
 
 		if (!c)
@@ -454,7 +469,7 @@ struct record *trace_read_data(int cpu)
 	return data;
 }
 
-ssize_t trace_report(int fd)
+ssize_t trace_report(int fd, bool __repipe)
 {
 	char buf[BUFSIZ];
 	char test[] = { 23, 8, 68 };
@@ -465,6 +480,7 @@ ssize_t trace_report(int fd)
 	ssize_t size;
 
 	calc_data_size = 1;
+	repipe = __repipe;
 
 	input_fd = fd;
 
@@ -499,6 +515,7 @@ ssize_t trace_report(int fd)
 
 	size = calc_data_size - 1;
 	calc_data_size = 0;
+	repipe = false;
 
 	if (show_funcs) {
 		print_funcs();
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 1f45d46..ebfee80 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -163,7 +163,7 @@ struct record *trace_read_data(int cpu);
 
 void parse_set_info(int nr_cpus, int long_sz);
 
-ssize_t trace_report(int fd);
+ssize_t trace_report(int fd, bool repipe);
 
 void *malloc_or_die(unsigned int size);
 
-- 
1.6.4.GIT

