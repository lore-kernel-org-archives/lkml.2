Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab0GAP4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:56:18 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47066 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049Ab0GAPyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:54:07 -0400
From: Borislav Petkov <bp@amd64.org>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/21] perf: Carve out perf bits for general usage, p3
Date: Thu,  1 Jul 2010 17:55:56 +0200
Message-Id: <1277999763-20357-15-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277999763-20357-1-git-send-email-bp@amd64.org>
References: <1277999763-20357-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Those are pulled in when linking parse-events.c with other tools like
the RAS daemon so export them into tools/lib/perf/ too.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/lib/Makefile                |   10 +
 tools/lib/lk/debug.h              |    2 +-
 tools/lib/perf/build-id.c         |  111 ++++
 tools/lib/perf/build-id.h         |   12 +
 tools/lib/perf/event.c            |  827 ++++++++++++++++++++++++++++
 tools/lib/perf/event.h            |  167 ++++++
 tools/lib/perf/header.h           |    2 +-
 tools/lib/perf/hist.c             | 1082 +++++++++++++++++++++++++++++++++++++
 tools/lib/perf/hist.h             |  129 +++++
 tools/lib/perf/session.c          |    3 +-
 tools/lib/perf/session.h          |    6 +-
 tools/lib/perf/sort.c             |  346 ++++++++++++
 tools/lib/perf/sort.h             |  115 ++++
 tools/lib/perf/symbol.c           |    2 +-
 tools/lib/perf/thread.c           |  164 ++++++
 tools/lib/perf/thread.h           |   44 ++
 tools/perf/Makefile               |   10 -
 tools/perf/builtin-annotate.c     |    8 +-
 tools/perf/builtin-buildid-list.c |    2 +-
 tools/perf/builtin-diff.c         |    6 +-
 tools/perf/builtin-kmem.c         |    2 +-
 tools/perf/builtin-kvm.c          |    2 +-
 tools/perf/builtin-lock.c         |    2 +-
 tools/perf/builtin-record.c       |    4 +-
 tools/perf/builtin-report.c       |    6 +-
 tools/perf/builtin-sched.c        |    2 +-
 tools/perf/builtin-stat.c         |    4 +-
 tools/perf/builtin-test.c         |    2 +-
 tools/perf/builtin-timechart.c    |    2 +-
 tools/perf/builtin-top.c          |    2 +-
 tools/perf/builtin-trace.c        |    2 +-
 tools/perf/perf.c                 |    2 +-
 tools/perf/util/build-id.c        |  111 ----
 tools/perf/util/build-id.h        |   12 -
 tools/perf/util/callchain.c       |    7 -
 tools/perf/util/callchain.h       |    3 +-
 tools/perf/util/event.c           |  820 ----------------------------
 tools/perf/util/event.h           |  166 ------
 tools/perf/util/hist.c            | 1082 -------------------------------------
 tools/perf/util/hist.h            |  129 -----
 tools/perf/util/newt.c            |    4 +-
 tools/perf/util/probe-event.c     |    4 +-
 tools/perf/util/probe-finder.c    |    2 +-
 tools/perf/util/sort.c            |  346 ------------
 tools/perf/util/sort.h            |  116 ----
 tools/perf/util/thread.c          |  164 ------
 tools/perf/util/thread.h          |   44 --
 47 files changed, 3044 insertions(+), 3046 deletions(-)
 create mode 100644 tools/lib/perf/build-id.c
 create mode 100644 tools/lib/perf/build-id.h
 create mode 100644 tools/lib/perf/event.c
 create mode 100644 tools/lib/perf/event.h
 create mode 100644 tools/lib/perf/hist.c
 create mode 100644 tools/lib/perf/hist.h
 create mode 100644 tools/lib/perf/sort.c
 create mode 100644 tools/lib/perf/sort.h
 create mode 100644 tools/lib/perf/thread.c
 create mode 100644 tools/lib/perf/thread.h
 delete mode 100644 tools/perf/util/build-id.c
 delete mode 100644 tools/perf/util/build-id.h
 delete mode 100644 tools/perf/util/event.c
 delete mode 100644 tools/perf/util/event.h
 delete mode 100644 tools/perf/util/hist.c
 delete mode 100644 tools/perf/util/hist.h
 delete mode 100644 tools/perf/util/sort.c
 delete mode 100644 tools/perf/util/sort.h
 delete mode 100644 tools/perf/util/thread.c
 delete mode 100644 tools/perf/util/thread.h

diff --git a/tools/lib/Makefile b/tools/lib/Makefile
index dd87c43..cabef46 100644
--- a/tools/lib/Makefile
+++ b/tools/lib/Makefile
@@ -18,6 +18,11 @@ LIB_H += perf/header.h
 LIB_H += perf/symbol.h
 LIB_H += perf/map.h
 LIB_H += perf/session.h
+LIB_H += perf/build-id.h
+LIB_H += perf/hist.h
+LIB_H += perf/thread.h
+LIB_H += perf/sort.h
+LIB_H += perf/event.h
 
 LIB_OBJS += $(OUTPUT)lk/bitmap.o
 LIB_OBJS += $(OUTPUT)lk/cpumap.o
@@ -39,6 +44,11 @@ LIB_OBJS += $(OUTPUT)perf/header.o
 LIB_OBJS += $(OUTPUT)perf/symbol.o
 LIB_OBJS += $(OUTPUT)perf/map.o
 LIB_OBJS += $(OUTPUT)perf/session.o
+LIB_OBJS += $(OUTPUT)perf/build-id.o
+LIB_OBJS += $(OUTPUT)perf/hist.o
+LIB_OBJS += $(OUTPUT)perf/thread.o
+LIB_OBJS += $(OUTPUT)perf/sort.o
+LIB_OBJS += $(OUTPUT)perf/event.o
 
 LIBFILE = lklib.a
 
diff --git a/tools/lib/lk/debug.h b/tools/lib/lk/debug.h
index 6df0457..44fdfab 100644
--- a/tools/lib/lk/debug.h
+++ b/tools/lib/lk/debug.h
@@ -3,7 +3,7 @@
 #define __LK_DEBUG_H
 
 #include <stdbool.h>
-#include <util/event.h>
+#include <perf/event.h>
 
 extern int verbose;
 extern bool dump_trace;
diff --git a/tools/lib/perf/build-id.c b/tools/lib/perf/build-id.c
new file mode 100644
index 0000000..5969758
--- /dev/null
+++ b/tools/lib/perf/build-id.c
@@ -0,0 +1,111 @@
+/*
+ * build-id.c
+ *
+ * build-id support
+ *
+ * Copyright (C) 2009, 2010 Red Hat Inc.
+ * Copyright (C) 2009, 2010 Arnaldo Carvalho de Melo <acme@redhat.com>
+ */
+#include <lk/util.h>
+#include <lk/debug.h>
+#include <lk/config.h>
+#include <lk/strbuf.h>
+#include <stdio.h>
+#include "build-id.h"
+#include "event.h"
+#include <perf/symbol.h>
+#include <linux/kernel.h>
+
+static int build_id__mark_dso_hit(event_t *event, struct perf_session *session)
+{
+	struct addr_location al;
+	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+	struct thread *thread = perf_session__findnew(session, event->ip.pid);
+
+	if (thread == NULL) {
+		pr_err("problem processing %d event, skipping it.\n",
+			event->header.type);
+		return -1;
+	}
+
+	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
+			      event->ip.pid, event->ip.ip, &al);
+
+	if (al.map != NULL)
+		al.map->dso->hit = 1;
+
+	return 0;
+}
+
+struct perf_event_ops build_id__mark_dso_hit_ops = {
+	.sample	= build_id__mark_dso_hit,
+	.mmap	= event__process_mmap,
+	.fork	= event__process_task,
+};
+
+char *dso__build_id_filename(struct dso *self, char *bf, size_t size)
+{
+	char build_id_hex[BUILD_ID_SIZE * 2 + 1];
+
+	if (!self->has_build_id)
+		return NULL;
+
+	build_id__sprintf(self->build_id, sizeof(self->build_id), build_id_hex);
+	if (bf == NULL) {
+		if (asprintf(&bf, "%s/.build-id/%.2s/%s", buildid_dir,
+			     build_id_hex, build_id_hex + 2) < 0)
+			return NULL;
+	} else
+		snprintf(bf, size, "%s/.build-id/%.2s/%s", buildid_dir,
+			 build_id_hex, build_id_hex + 2);
+	return bf;
+}
+
+struct buildid_dir_config {
+	char *dir;
+};
+
+static int buildid_dir_command_config(const char *var, const char *value,
+				      void *data)
+{
+	struct buildid_dir_config *c = data;
+	const char *v;
+
+	/* same dir for all commands */
+	if (!prefixcmp(var, "buildid.") && !strcmp(var + 8, "dir")) {
+		v = lk_config_dirname(var, value);
+		if (!v)
+			return -1;
+		strncpy(c->dir, v, MAXPATHLEN-1);
+		c->dir[MAXPATHLEN-1] = '\0';
+	}
+	return 0;
+}
+static void check_buildid_dir_config(void)
+{
+	struct buildid_dir_config c;
+	c.dir = buildid_dir;
+	perf_config(buildid_dir_command_config, &c);
+}
+
+void set_buildid_dir(void)
+{
+	buildid_dir[0] = '\0';
+
+	/* try config file */
+	check_buildid_dir_config();
+
+	/* default to $HOME/.debug */
+	if (buildid_dir[0] == '\0') {
+		char *v = getenv("HOME");
+		if (v) {
+			snprintf(buildid_dir, MAXPATHLEN-1, "%s/%s",
+				 v, DEBUG_CACHE_DIR);
+		} else {
+			strncpy(buildid_dir, DEBUG_CACHE_DIR, MAXPATHLEN-1);
+		}
+		buildid_dir[MAXPATHLEN-1] = '\0';
+	}
+	/* for communicating with external commands */
+	setenv("PERF_BUILDID_DIR", buildid_dir, 1);
+}
diff --git a/tools/lib/perf/build-id.h b/tools/lib/perf/build-id.h
new file mode 100644
index 0000000..1b73726
--- /dev/null
+++ b/tools/lib/perf/build-id.h
@@ -0,0 +1,12 @@
+#ifndef PERF_BUILD_ID_H_
+#define PERF_BUILD_ID_H_ 1
+
+#include "session.h"
+#include <util/config.h>
+
+extern struct perf_event_ops build_id__mark_dso_hit_ops;
+
+char *dso__build_id_filename(struct dso *self, char *bf, size_t size);
+extern void set_buildid_dir(void);
+
+#endif
diff --git a/tools/lib/perf/event.c b/tools/lib/perf/event.c
new file mode 100644
index 0000000..0f16325
--- /dev/null
+++ b/tools/lib/perf/event.c
@@ -0,0 +1,827 @@
+#include <linux/types.h>
+#include "event.h"
+#include <lk/debug.h>
+#include <perf/session.h>
+#include "sort.h"
+#include "string.h"
+#include <lk/strlist.h>
+#include "thread.h"
+
+const char *event__name[] = {
+	[0]			 = "TOTAL",
+	[PERF_RECORD_MMAP]	 = "MMAP",
+	[PERF_RECORD_LOST]	 = "LOST",
+	[PERF_RECORD_COMM]	 = "COMM",
+	[PERF_RECORD_EXIT]	 = "EXIT",
+	[PERF_RECORD_THROTTLE]	 = "THROTTLE",
+	[PERF_RECORD_UNTHROTTLE] = "UNTHROTTLE",
+	[PERF_RECORD_FORK]	 = "FORK",
+	[PERF_RECORD_READ]	 = "READ",
+	[PERF_RECORD_SAMPLE]	 = "SAMPLE",
+	[PERF_RECORD_HEADER_ATTR]	 = "ATTR",
+	[PERF_RECORD_HEADER_EVENT_TYPE]	 = "EVENT_TYPE",
+	[PERF_RECORD_HEADER_TRACING_DATA]	 = "TRACING_DATA",
+	[PERF_RECORD_HEADER_BUILD_ID]	 = "BUILD_ID",
+};
+
+bool ip_callchain__valid(struct ip_callchain *chain, const event_t *event)
+{
+	unsigned int chain_size = event->header.size;
+	chain_size -= (unsigned long)&event->ip.__more_data - (unsigned long)event;
+	return chain->nr * sizeof(u64) <= chain_size;
+}
+
+static pid_t event__synthesize_comm(pid_t pid, int full,
+				    event__handler_t process,
+				    struct perf_session *session)
+{
+	event_t ev;
+	char filename[PATH_MAX];
+	char bf[BUFSIZ];
+	FILE *fp;
+	size_t size = 0;
+	DIR *tasks;
+	struct dirent dirent, *next;
+	pid_t tgid = 0;
+
+	snprintf(filename, sizeof(filename), "/proc/%d/status", pid);
+
+	fp = fopen(filename, "r");
+	if (fp == NULL) {
+out_race:
+		/*
+		 * We raced with a task exiting - just return:
+		 */
+		pr_debug("couldn't open %s\n", filename);
+		return 0;
+	}
+
+	memset(&ev.comm, 0, sizeof(ev.comm));
+	while (!ev.comm.comm[0] || !ev.comm.pid) {
+		if (fgets(bf, sizeof(bf), fp) == NULL)
+			goto out_failure;
+
+		if (memcmp(bf, "Name:", 5) == 0) {
+			char *name = bf + 5;
+			while (*name && isspace(*name))
+				++name;
+			size = strlen(name) - 1;
+			memcpy(ev.comm.comm, name, size++);
+		} else if (memcmp(bf, "Tgid:", 5) == 0) {
+			char *tgids = bf + 5;
+			while (*tgids && isspace(*tgids))
+				++tgids;
+			tgid = ev.comm.pid = atoi(tgids);
+		}
+	}
+
+	ev.comm.header.type = PERF_RECORD_COMM;
+	size = ALIGN(size, sizeof(u64));
+	ev.comm.header.size = sizeof(ev.comm) - (sizeof(ev.comm.comm) - size);
+
+	if (!full) {
+		ev.comm.tid = pid;
+
+		process(&ev, session);
+		goto out_fclose;
+	}
+
+	snprintf(filename, sizeof(filename), "/proc/%d/task", pid);
+
+	tasks = opendir(filename);
+	if (tasks == NULL)
+		goto out_race;
+
+	while (!readdir_r(tasks, &dirent, &next) && next) {
+		char *end;
+		pid = strtol(dirent.d_name, &end, 10);
+		if (*end)
+			continue;
+
+		ev.comm.tid = pid;
+
+		process(&ev, session);
+	}
+	closedir(tasks);
+
+out_fclose:
+	fclose(fp);
+	return tgid;
+
+out_failure:
+	pr_warning("couldn't get COMM and pgid, malformed %s\n", filename);
+	return -1;
+}
+
+static int event__synthesize_mmap_events(pid_t pid, pid_t tgid,
+					 event__handler_t process,
+					 struct perf_session *session)
+{
+	char filename[PATH_MAX];
+	FILE *fp;
+
+	snprintf(filename, sizeof(filename), "/proc/%d/maps", pid);
+
+	fp = fopen(filename, "r");
+	if (fp == NULL) {
+		/*
+		 * We raced with a task exiting - just return:
+		 */
+		pr_debug("couldn't open %s\n", filename);
+		return -1;
+	}
+
+	while (1) {
+		char bf[BUFSIZ], *pbf = bf;
+		event_t ev = {
+			.header = {
+				.type = PERF_RECORD_MMAP,
+				/*
+				 * Just like the kernel, see __perf_event_mmap
+				 * in kernel/perf_event.c
+				 */
+				.misc = PERF_RECORD_MISC_USER,
+			 },
+		};
+		int n;
+		size_t size;
+		if (fgets(bf, sizeof(bf), fp) == NULL)
+			break;
+
+		/* 00400000-0040c000 r-xp 00000000 fd:01 41038  /bin/cat */
+		n = hex2u64(pbf, &ev.mmap.start);
+		if (n < 0)
+			continue;
+		pbf += n + 1;
+		n = hex2u64(pbf, &ev.mmap.len);
+		if (n < 0)
+			continue;
+		pbf += n + 3;
+		if (*pbf == 'x') { /* vm_exec */
+			u64 vm_pgoff;
+			char *execname = strchr(bf, '/');
+
+			/* Catch VDSO */
+			if (execname == NULL)
+				execname = strstr(bf, "[vdso]");
+
+			if (execname == NULL)
+				continue;
+
+			pbf += 3;
+			n = hex2u64(pbf, &vm_pgoff);
+			/* pgoff is in bytes, not pages */
+			if (n >= 0)
+				ev.mmap.pgoff = vm_pgoff << getpagesize();
+			else
+				ev.mmap.pgoff = 0;
+
+			size = strlen(execname);
+			execname[size - 1] = '\0'; /* Remove \n */
+			memcpy(ev.mmap.filename, execname, size);
+			size = ALIGN(size, sizeof(u64));
+			ev.mmap.len -= ev.mmap.start;
+			ev.mmap.header.size = (sizeof(ev.mmap) -
+					       (sizeof(ev.mmap.filename) - size));
+			ev.mmap.pid = tgid;
+			ev.mmap.tid = pid;
+
+			process(&ev, session);
+		}
+	}
+
+	fclose(fp);
+	return 0;
+}
+
+int event__synthesize_modules(event__handler_t process,
+			      struct perf_session *session,
+			      struct machine *machine)
+{
+	struct rb_node *nd;
+	struct map_groups *kmaps = &machine->kmaps;
+	u16 misc;
+
+	/*
+	 * kernel uses 0 for user space maps, see kernel/perf_event.c
+	 * __perf_event_mmap
+	 */
+	if (machine__is_host(machine))
+		misc = PERF_RECORD_MISC_KERNEL;
+	else
+		misc = PERF_RECORD_MISC_GUEST_KERNEL;
+
+	for (nd = rb_first(&kmaps->maps[MAP__FUNCTION]);
+	     nd; nd = rb_next(nd)) {
+		event_t ev;
+		size_t size;
+		struct map *pos = rb_entry(nd, struct map, rb_node);
+
+		if (pos->dso->kernel)
+			continue;
+
+		size = ALIGN(pos->dso->long_name_len + 1, sizeof(u64));
+		memset(&ev, 0, sizeof(ev));
+		ev.mmap.header.misc = misc;
+		ev.mmap.header.type = PERF_RECORD_MMAP;
+		ev.mmap.header.size = (sizeof(ev.mmap) -
+				        (sizeof(ev.mmap.filename) - size));
+		ev.mmap.start = pos->start;
+		ev.mmap.len   = pos->end - pos->start;
+		ev.mmap.pid   = machine->pid;
+
+		memcpy(ev.mmap.filename, pos->dso->long_name,
+		       pos->dso->long_name_len + 1);
+		process(&ev, session);
+	}
+
+	return 0;
+}
+
+int event__synthesize_thread(pid_t pid, event__handler_t process,
+			     struct perf_session *session)
+{
+	pid_t tgid = event__synthesize_comm(pid, 1, process, session);
+	if (tgid == -1)
+		return -1;
+	return event__synthesize_mmap_events(pid, tgid, process, session);
+}
+
+void event__synthesize_threads(event__handler_t process,
+			       struct perf_session *session)
+{
+	DIR *proc;
+	struct dirent dirent, *next;
+
+	proc = opendir("/proc");
+
+	while (!readdir_r(proc, &dirent, &next) && next) {
+		char *end;
+		pid_t pid = strtol(dirent.d_name, &end, 10);
+
+		if (*end) /* only interested in proper numerical dirents */
+			continue;
+
+		event__synthesize_thread(pid, process, session);
+	}
+
+	closedir(proc);
+}
+
+struct process_symbol_args {
+	const char *name;
+	u64	   start;
+};
+
+static int find_symbol_cb(void *arg, const char *name, char type, u64 start)
+{
+	struct process_symbol_args *args = arg;
+
+	/*
+	 * Must be a function or at least an alias, as in PARISC64, where "_text" is
+	 * an 'A' to the same address as "_stext".
+	 */
+	if (!(symbol_type__is_a(type, MAP__FUNCTION) ||
+	      type == 'A') || strcmp(name, args->name))
+		return 0;
+
+	args->start = start;
+	return 1;
+}
+
+int event__synthesize_kernel_mmap(event__handler_t process,
+				  struct perf_session *session,
+				  struct machine *machine,
+				  const char *symbol_name)
+{
+	size_t size;
+	const char *filename, *mmap_name;
+	char path[PATH_MAX];
+	char name_buff[PATH_MAX];
+	struct map *map;
+
+	event_t ev = {
+		.header = {
+			.type = PERF_RECORD_MMAP,
+		},
+	};
+	/*
+	 * We should get this from /sys/kernel/sections/.text, but till that is
+	 * available use this, and after it is use this as a fallback for older
+	 * kernels.
+	 */
+	struct process_symbol_args args = { .name = symbol_name, };
+
+	mmap_name = machine__mmap_name(machine, name_buff, sizeof(name_buff));
+	if (machine__is_host(machine)) {
+		/*
+		 * kernel uses PERF_RECORD_MISC_USER for user space maps,
+		 * see kernel/perf_event.c __perf_event_mmap
+		 */
+		ev.header.misc = PERF_RECORD_MISC_KERNEL;
+		filename = "/proc/kallsyms";
+	} else {
+		ev.header.misc = PERF_RECORD_MISC_GUEST_KERNEL;
+		if (machine__is_default_guest(machine))
+			filename = (char *) symbol_conf.default_guest_kallsyms;
+		else {
+			sprintf(path, "%s/proc/kallsyms", machine->root_dir);
+			filename = path;
+		}
+	}
+
+	if (kallsyms__parse(filename, &args, find_symbol_cb) <= 0)
+		return -ENOENT;
+
+	map = machine->vmlinux_maps[MAP__FUNCTION];
+	size = snprintf(ev.mmap.filename, sizeof(ev.mmap.filename),
+			"%s%s", mmap_name, symbol_name) + 1;
+	size = ALIGN(size, sizeof(u64));
+	ev.mmap.header.size = (sizeof(ev.mmap) -
+			(sizeof(ev.mmap.filename) - size));
+	ev.mmap.pgoff = args.start;
+	ev.mmap.start = map->start;
+	ev.mmap.len   = map->end - ev.mmap.start;
+	ev.mmap.pid   = machine->pid;
+
+	return process(&ev, session);
+}
+
+static void thread__comm_adjust(struct thread *self)
+{
+	char *comm = self->comm;
+
+	if (!symbol_conf.col_width_list_str && !symbol_conf.field_sep &&
+	    (!symbol_conf.comm_list ||
+	     strlist__has_entry(symbol_conf.comm_list, comm))) {
+		unsigned int slen = strlen(comm);
+
+		if (slen > comms__col_width) {
+			comms__col_width = slen;
+			threads__col_width = slen + 6;
+		}
+	}
+}
+
+static int thread__set_comm_adjust(struct thread *self, const char *comm)
+{
+	int ret = thread__set_comm(self, comm);
+
+	if (ret)
+		return ret;
+
+	thread__comm_adjust(self);
+
+	return 0;
+}
+
+int event__process_comm(event_t *self, struct perf_session *session)
+{
+	struct thread *thread = perf_session__findnew(session, self->comm.tid);
+
+	dump_printf(": %s:%d\n", self->comm.comm, self->comm.tid);
+
+	if (thread == NULL || thread__set_comm_adjust(thread, self->comm.comm)) {
+		dump_printf("problem processing PERF_RECORD_COMM, skipping event.\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+int event__process_lost(event_t *self, struct perf_session *session)
+{
+	dump_printf(": id:%Ld: lost:%Ld\n", self->lost.id, self->lost.lost);
+	session->hists.stats.total_lost += self->lost.lost;
+	return 0;
+}
+
+static void event_set_kernel_mmap_len(struct map **maps, event_t *self)
+{
+	maps[MAP__FUNCTION]->start = self->mmap.start;
+	maps[MAP__FUNCTION]->end   = self->mmap.start + self->mmap.len;
+	/*
+	 * Be a bit paranoid here, some perf.data file came with
+	 * a zero sized synthesized MMAP event for the kernel.
+	 */
+	if (maps[MAP__FUNCTION]->end == 0)
+		maps[MAP__FUNCTION]->end = ~0UL;
+}
+
+static int event__process_kernel_mmap(event_t *self,
+			struct perf_session *session)
+{
+	struct map *map;
+	char kmmap_prefix[PATH_MAX];
+	struct machine *machine;
+	enum dso_kernel_type kernel_type;
+	bool is_kernel_mmap;
+
+	machine = perf_session__findnew_machine(session, self->mmap.pid);
+	if (!machine) {
+		pr_err("Can't find id %d's machine\n", self->mmap.pid);
+		goto out_problem;
+	}
+
+	machine__mmap_name(machine, kmmap_prefix, sizeof(kmmap_prefix));
+	if (machine__is_host(machine))
+		kernel_type = DSO_TYPE_KERNEL;
+	else
+		kernel_type = DSO_TYPE_GUEST_KERNEL;
+
+	is_kernel_mmap = memcmp(self->mmap.filename,
+				kmmap_prefix,
+				strlen(kmmap_prefix)) == 0;
+	if (self->mmap.filename[0] == '/' ||
+	    (!is_kernel_mmap && self->mmap.filename[0] == '[')) {
+
+		char short_module_name[1024];
+		char *name, *dot;
+
+		if (self->mmap.filename[0] == '/') {
+			name = strrchr(self->mmap.filename, '/');
+			if (name == NULL)
+				goto out_problem;
+
+			++name; /* skip / */
+			dot = strrchr(name, '.');
+			if (dot == NULL)
+				goto out_problem;
+			snprintf(short_module_name, sizeof(short_module_name),
+					"[%.*s]", (int)(dot - name), name);
+			strxfrchar(short_module_name, '-', '_');
+		} else
+			strcpy(short_module_name, self->mmap.filename);
+
+		map = machine__new_module(machine, self->mmap.start,
+					  self->mmap.filename);
+		if (map == NULL)
+			goto out_problem;
+
+		name = strdup(short_module_name);
+		if (name == NULL)
+			goto out_problem;
+
+		map->dso->short_name = name;
+		map->end = map->start + self->mmap.len;
+	} else if (is_kernel_mmap) {
+		const char *symbol_name = (self->mmap.filename +
+				strlen(kmmap_prefix));
+		/*
+		 * Should be there already, from the build-id table in
+		 * the header.
+		 */
+		struct dso *kernel = __dsos__findnew(&machine->kernel_dsos,
+						     kmmap_prefix);
+		if (kernel == NULL)
+			goto out_problem;
+
+		kernel->kernel = kernel_type;
+		if (__machine__create_kernel_maps(machine, kernel) < 0)
+			goto out_problem;
+
+		event_set_kernel_mmap_len(machine->vmlinux_maps, self);
+		perf_session__set_kallsyms_ref_reloc_sym(machine->vmlinux_maps,
+							 symbol_name,
+							 self->mmap.pgoff);
+		if (machine__is_default_guest(machine)) {
+			/*
+			 * preload dso of guest kernel and modules
+			 */
+			dso__load(kernel, machine->vmlinux_maps[MAP__FUNCTION],
+				  NULL);
+		}
+	}
+	return 0;
+out_problem:
+	return -1;
+}
+
+int event__process_mmap(event_t *self, struct perf_session *session)
+{
+	struct machine *machine;
+	struct thread *thread;
+	struct map *map;
+	u8 cpumode = self->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+	int ret = 0;
+
+	dump_printf(" %d/%d: [%#Lx(%#Lx) @ %#Lx]: %s\n",
+			self->mmap.pid, self->mmap.tid, self->mmap.start,
+			self->mmap.len, self->mmap.pgoff, self->mmap.filename);
+
+	if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL ||
+	    cpumode == PERF_RECORD_MISC_KERNEL) {
+		ret = event__process_kernel_mmap(self, session);
+		if (ret < 0)
+			goto out_problem;
+		return 0;
+	}
+
+	machine = perf_session__find_host_machine(session);
+	if (machine == NULL)
+		goto out_problem;
+	thread = perf_session__findnew(session, self->mmap.pid);
+	map = map__new(&machine->user_dsos, self->mmap.start,
+			self->mmap.len, self->mmap.pgoff,
+			self->mmap.pid, self->mmap.filename,
+			MAP__FUNCTION, session->cwd, session->cwdlen);
+
+	if (thread == NULL || map == NULL)
+		goto out_problem;
+
+	thread__insert_map(thread, map);
+	return 0;
+
+out_problem:
+	dump_printf("problem processing PERF_RECORD_MMAP, skipping event.\n");
+	return 0;
+}
+
+int event__process_task(event_t *self, struct perf_session *session)
+{
+	struct thread *thread = perf_session__findnew(session, self->fork.tid);
+	struct thread *parent = perf_session__findnew(session, self->fork.ptid);
+
+	dump_printf("(%d:%d):(%d:%d)\n", self->fork.pid, self->fork.tid,
+		    self->fork.ppid, self->fork.ptid);
+
+	if (self->header.type == PERF_RECORD_EXIT)
+		return 0;
+
+	if (thread == NULL || parent == NULL ||
+	    thread__fork(thread, parent) < 0) {
+		dump_printf("problem processing PERF_RECORD_FORK, skipping event.\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+void thread__find_addr_map(struct thread *self,
+			   struct perf_session *session, u8 cpumode,
+			   enum map_type type, pid_t pid, u64 addr,
+			   struct addr_location *al)
+{
+	struct map_groups *mg = &self->mg;
+	struct machine *machine = NULL;
+
+	al->thread = self;
+	al->addr = addr;
+	al->cpumode = cpumode;
+	al->filtered = false;
+
+	if (cpumode == PERF_RECORD_MISC_KERNEL && perf_host) {
+		al->level = 'k';
+		machine = perf_session__find_host_machine(session);
+		if (machine == NULL) {
+			al->map = NULL;
+			return;
+		}
+		mg = &machine->kmaps;
+	} else if (cpumode == PERF_RECORD_MISC_USER && perf_host) {
+		al->level = '.';
+		machine = perf_session__find_host_machine(session);
+	} else if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL && perf_guest) {
+		al->level = 'g';
+		machine = perf_session__find_machine(session, pid);
+		if (machine == NULL) {
+			al->map = NULL;
+			return;
+		}
+		mg = &machine->kmaps;
+	} else {
+		/*
+		 * 'u' means guest os user space.
+		 * TODO: We don't support guest user space. Might support late.
+		 */
+		if (cpumode == PERF_RECORD_MISC_GUEST_USER && perf_guest)
+			al->level = 'u';
+		else
+			al->level = 'H';
+		al->map = NULL;
+
+		if ((cpumode == PERF_RECORD_MISC_GUEST_USER ||
+			cpumode == PERF_RECORD_MISC_GUEST_KERNEL) &&
+			!perf_guest)
+			al->filtered = true;
+		if ((cpumode == PERF_RECORD_MISC_USER ||
+			cpumode == PERF_RECORD_MISC_KERNEL) &&
+			!perf_host)
+			al->filtered = true;
+
+		return;
+	}
+try_again:
+	al->map = map_groups__find(mg, type, al->addr);
+	if (al->map == NULL) {
+		/*
+		 * If this is outside of all known maps, and is a negative
+		 * address, try to look it up in the kernel dso, as it might be
+		 * a vsyscall or vdso (which executes in user-mode).
+		 *
+		 * XXX This is nasty, we should have a symbol list in the
+		 * "[vdso]" dso, but for now lets use the old trick of looking
+		 * in the whole kernel symbol list.
+		 */
+		if ((long long)al->addr < 0 &&
+		    cpumode == PERF_RECORD_MISC_KERNEL &&
+		    machine && mg != &machine->kmaps) {
+			mg = &machine->kmaps;
+			goto try_again;
+		}
+	} else
+		al->addr = al->map->map_ip(al->map, al->addr);
+}
+
+void thread__find_addr_location(struct thread *self,
+				struct perf_session *session, u8 cpumode,
+				enum map_type type, pid_t pid, u64 addr,
+				struct addr_location *al,
+				symbol_filter_t filter)
+{
+	thread__find_addr_map(self, session, cpumode, type, pid, addr, al);
+	if (al->map != NULL)
+		al->sym = map__find_symbol(al->map, al->addr, filter);
+	else
+		al->sym = NULL;
+}
+
+static void dso__calc_col_width(struct dso *self)
+{
+	if (!symbol_conf.col_width_list_str && !symbol_conf.field_sep &&
+	    (!symbol_conf.dso_list ||
+	     strlist__has_entry(symbol_conf.dso_list, self->name))) {
+		u16 slen = self->short_name_len;
+		if (verbose)
+			slen = self->long_name_len;
+		if (dsos__col_width < slen)
+			dsos__col_width = slen;
+	}
+
+	self->slen_calculated = 1;
+}
+
+int event__preprocess_sample(const event_t *self, struct perf_session *session,
+			     struct addr_location *al, struct sample_data *data,
+			     symbol_filter_t filter)
+{
+	u8 cpumode = self->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+	struct thread *thread;
+
+	event__parse_sample(self, session->sample_type, data);
+
+	dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld cpu:%d\n",
+		    self->header.misc, data->pid, data->tid, data->ip,
+		    data->period, data->cpu);
+
+	if (session->sample_type & PERF_SAMPLE_CALLCHAIN) {
+		unsigned int i;
+
+		dump_printf("... chain: nr:%Lu\n", data->callchain->nr);
+
+		if (!ip_callchain__valid(data->callchain, self)) {
+			pr_debug("call-chain problem with event, "
+				 "skipping it.\n");
+			goto out_filtered;
+		}
+
+		if (dump_trace) {
+			for (i = 0; i < data->callchain->nr; i++)
+				dump_printf("..... %2d: %016Lx\n",
+					    i, data->callchain->ips[i]);
+		}
+	}
+	thread = perf_session__findnew(session, self->ip.pid);
+	if (thread == NULL)
+		return -1;
+
+	if (symbol_conf.comm_list &&
+	    !strlist__has_entry(symbol_conf.comm_list, thread->comm))
+		goto out_filtered;
+
+	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
+	/*
+	 * Have we already created the kernel maps for the host machine?
+	 *
+	 * This should have happened earlier, when we processed the kernel MMAP
+	 * events, but for older perf.data files there was no such thing, so do
+	 * it now.
+	 */
+	if (cpumode == PERF_RECORD_MISC_KERNEL &&
+	    session->host_machine.vmlinux_maps[MAP__FUNCTION] == NULL)
+		machine__create_kernel_maps(&session->host_machine);
+
+	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
+			      self->ip.pid, self->ip.ip, al);
+	dump_printf(" ...... dso: %s\n",
+		    al->map ? al->map->dso->long_name :
+			al->level == 'H' ? "[hypervisor]" : "<not found>");
+	al->sym = NULL;
+	al->cpu = data->cpu;
+
+	if (al->map) {
+		if (symbol_conf.dso_list &&
+		    (!al->map || !al->map->dso ||
+		     !(strlist__has_entry(symbol_conf.dso_list,
+					  al->map->dso->short_name) ||
+		       (al->map->dso->short_name != al->map->dso->long_name &&
+			strlist__has_entry(symbol_conf.dso_list,
+					   al->map->dso->long_name)))))
+			goto out_filtered;
+		/*
+		 * We have to do this here as we may have a dso with no symbol
+		 * hit that has a name longer than the ones with symbols
+		 * sampled.
+		 */
+		if (!sort_dso.elide && !al->map->dso->slen_calculated)
+			dso__calc_col_width(al->map->dso);
+
+		al->sym = map__find_symbol(al->map, al->addr, filter);
+	} else {
+		const unsigned int unresolved_col_width = BITS_PER_LONG / 4;
+
+		if (dsos__col_width < unresolved_col_width &&
+		    !symbol_conf.col_width_list_str && !symbol_conf.field_sep &&
+		    !symbol_conf.dso_list)
+			dsos__col_width = unresolved_col_width;
+	}
+
+	if (symbol_conf.sym_list && al->sym &&
+	    !strlist__has_entry(symbol_conf.sym_list, al->sym->name))
+		goto out_filtered;
+
+	return 0;
+
+out_filtered:
+	al->filtered = true;
+	return 0;
+}
+
+int event__parse_sample(const event_t *event, u64 type, struct sample_data *data)
+{
+	const u64 *array = event->sample.array;
+
+	if (type & PERF_SAMPLE_IP) {
+		data->ip = event->ip.ip;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_TID) {
+		u32 *p = (u32 *)array;
+		data->pid = p[0];
+		data->tid = p[1];
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_TIME) {
+		data->time = *array;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_ADDR) {
+		data->addr = *array;
+		array++;
+	}
+
+	data->id = -1ULL;
+	if (type & PERF_SAMPLE_ID) {
+		data->id = *array;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_STREAM_ID) {
+		data->stream_id = *array;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_CPU) {
+		u32 *p = (u32 *)array;
+		data->cpu = *p;
+		array++;
+	} else
+		data->cpu = -1;
+
+	if (type & PERF_SAMPLE_PERIOD) {
+		data->period = *array;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_READ) {
+		pr_debug("PERF_SAMPLE_READ is unsuported for now\n");
+		return -1;
+	}
+
+	if (type & PERF_SAMPLE_CALLCHAIN) {
+		data->callchain = (struct ip_callchain *)array;
+		array += 1 + data->callchain->nr;
+	}
+
+	if (type & PERF_SAMPLE_RAW) {
+		u32 *p = (u32 *)array;
+		data->raw_size = *p;
+		p++;
+		data->raw_data = p;
+	}
+
+	return 0;
+}
diff --git a/tools/lib/perf/event.h b/tools/lib/perf/event.h
new file mode 100644
index 0000000..a3260f8
--- /dev/null
+++ b/tools/lib/perf/event.h
@@ -0,0 +1,167 @@
+#ifndef __PERF_RECORD_H
+#define __PERF_RECORD_H
+
+#include <limits.h>
+
+#include <perf.h>
+#include <perf/map.h>
+
+/*
+ * PERF_SAMPLE_IP | PERF_SAMPLE_TID | *
+ */
+struct ip_event {
+	struct perf_event_header header;
+	u64 ip;
+	u32 pid, tid;
+	unsigned char __more_data[];
+};
+
+struct mmap_event {
+	struct perf_event_header header;
+	u32 pid, tid;
+	u64 start;
+	u64 len;
+	u64 pgoff;
+	char filename[PATH_MAX];
+};
+
+struct comm_event {
+	struct perf_event_header header;
+	u32 pid, tid;
+	char comm[16];
+};
+
+struct fork_event {
+	struct perf_event_header header;
+	u32 pid, ppid;
+	u32 tid, ptid;
+	u64 time;
+};
+
+struct lost_event {
+	struct perf_event_header header;
+	u64 id;
+	u64 lost;
+};
+
+/*
+ * PERF_FORMAT_ENABLED | PERF_FORMAT_RUNNING | PERF_FORMAT_ID
+ */
+struct read_event {
+	struct perf_event_header header;
+	u32 pid, tid;
+	u64 value;
+	u64 time_enabled;
+	u64 time_running;
+	u64 id;
+};
+
+struct sample_event {
+	struct perf_event_header        header;
+	u64 array[];
+};
+
+struct sample_data {
+	u64 ip;
+	u32 pid, tid;
+	u64 time;
+	u64 addr;
+	u64 id;
+	u64 stream_id;
+	u64 period;
+	u32 cpu;
+	u32 raw_size;
+	void *raw_data;
+	struct ip_callchain *callchain;
+};
+
+#define BUILD_ID_SIZE 20
+
+struct build_id_event {
+	struct perf_event_header header;
+	pid_t			 pid;
+	u8			 build_id[ALIGN(BUILD_ID_SIZE, sizeof(u64))];
+	char			 filename[];
+};
+
+enum perf_user_event_type { /* above any possible kernel type */
+	PERF_RECORD_HEADER_ATTR			= 64,
+	PERF_RECORD_HEADER_EVENT_TYPE		= 65,
+	PERF_RECORD_HEADER_TRACING_DATA		= 66,
+	PERF_RECORD_HEADER_BUILD_ID		= 67,
+	PERF_RECORD_FINISHED_ROUND		= 68,
+	PERF_RECORD_HEADER_MAX
+};
+
+struct attr_event {
+	struct perf_event_header header;
+	struct perf_event_attr attr;
+	u64 id[];
+};
+
+#define MAX_EVENT_NAME 64
+
+struct perf_trace_event_type {
+	u64	event_id;
+	char	name[MAX_EVENT_NAME];
+};
+
+struct event_type_event {
+	struct perf_event_header header;
+	struct perf_trace_event_type event_type;
+};
+
+struct tracing_data_event {
+	struct perf_event_header header;
+	u32 size;
+};
+
+typedef union event_union {
+	struct perf_event_header	header;
+	struct ip_event			ip;
+	struct mmap_event		mmap;
+	struct comm_event		comm;
+	struct fork_event		fork;
+	struct lost_event		lost;
+	struct read_event		read;
+	struct sample_event		sample;
+	struct attr_event		attr;
+	struct event_type_event		event_type;
+	struct tracing_data_event	tracing_data;
+	struct build_id_event		build_id;
+} event_t;
+
+void event__print_totals(void);
+
+struct perf_session;
+
+typedef int (*event__handler_t)(event_t *event, struct perf_session *session);
+
+int event__synthesize_thread(pid_t pid, event__handler_t process,
+			     struct perf_session *session);
+void event__synthesize_threads(event__handler_t process,
+			       struct perf_session *session);
+int event__synthesize_kernel_mmap(event__handler_t process,
+				struct perf_session *session,
+				struct machine *machine,
+				const char *symbol_name);
+
+int event__synthesize_modules(event__handler_t process,
+			      struct perf_session *session,
+			      struct machine *machine);
+
+int event__process_comm(event_t *self, struct perf_session *session);
+int event__process_lost(event_t *self, struct perf_session *session);
+int event__process_mmap(event_t *self, struct perf_session *session);
+int event__process_task(event_t *self, struct perf_session *session);
+
+struct addr_location;
+int event__preprocess_sample(const event_t *self, struct perf_session *session,
+			     struct addr_location *al, struct sample_data *data,
+			     symbol_filter_t filter);
+int event__parse_sample(const event_t *event, u64 type, struct sample_data *data);
+
+extern const char *event__name[];
+
+bool ip_callchain__valid(struct ip_callchain *chain, const event_t *event);
+#endif /* __PERF_RECORD_H */
diff --git a/tools/lib/perf/header.h b/tools/lib/perf/header.h
index e930814..3845118 100644
--- a/tools/lib/perf/header.h
+++ b/tools/lib/perf/header.h
@@ -5,7 +5,7 @@
 #include <sys/types.h>
 #include <stdbool.h>
 #include <lk/types.h>
-#include <util/event.h>
+#include "event.h"
 #include "session.h"
 
 #include <linux/bitmap.h>
diff --git a/tools/lib/perf/hist.c b/tools/lib/perf/hist.c
new file mode 100644
index 0000000..2dfa141
--- /dev/null
+++ b/tools/lib/perf/hist.c
@@ -0,0 +1,1082 @@
+#include <lk/util.h>
+#include "build-id.h"
+#include "hist.h"
+#include <perf/session.h>
+#include "sort.h"
+#include <math.h>
+
+struct callchain_param	callchain_param = {
+	.mode	= CHAIN_GRAPH_REL,
+	.min_percent = 0.5
+};
+
+static void hist_entry__add_cpumode_period(struct hist_entry *self,
+					   unsigned int cpumode, u64 period)
+{
+	switch (cpumode) {
+	case PERF_RECORD_MISC_KERNEL:
+		self->period_sys += period;
+		break;
+	case PERF_RECORD_MISC_USER:
+		self->period_us += period;
+		break;
+	case PERF_RECORD_MISC_GUEST_KERNEL:
+		self->period_guest_sys += period;
+		break;
+	case PERF_RECORD_MISC_GUEST_USER:
+		self->period_guest_us += period;
+		break;
+	default:
+		break;
+	}
+}
+
+/*
+ * histogram, sorted on item, collects periods
+ */
+
+static struct hist_entry *hist_entry__new(struct hist_entry *template)
+{
+	size_t callchain_size = symbol_conf.use_callchain ? sizeof(struct callchain_node) : 0;
+	struct hist_entry *self = malloc(sizeof(*self) + callchain_size);
+
+	if (self != NULL) {
+		*self = *template;
+		self->nr_events = 1;
+		if (symbol_conf.use_callchain)
+			callchain_init(self->callchain);
+	}
+
+	return self;
+}
+
+static void hists__inc_nr_entries(struct hists *self, struct hist_entry *entry)
+{
+	if (entry->ms.sym && self->max_sym_namelen < entry->ms.sym->namelen)
+		self->max_sym_namelen = entry->ms.sym->namelen;
+	++self->nr_entries;
+}
+
+struct hist_entry *__hists__add_entry(struct hists *self,
+				      struct addr_location *al,
+				      struct symbol *sym_parent, u64 period)
+{
+	struct rb_node **p = &self->entries.rb_node;
+	struct rb_node *parent = NULL;
+	struct hist_entry *he;
+	struct hist_entry entry = {
+		.thread	= al->thread,
+		.ms = {
+			.map	= al->map,
+			.sym	= al->sym,
+		},
+		.cpu	= al->cpu,
+		.ip	= al->addr,
+		.level	= al->level,
+		.period	= period,
+		.parent = sym_parent,
+	};
+	int cmp;
+
+	while (*p != NULL) {
+		parent = *p;
+		he = rb_entry(parent, struct hist_entry, rb_node);
+
+		cmp = hist_entry__cmp(&entry, he);
+
+		if (!cmp) {
+			he->period += period;
+			++he->nr_events;
+			goto out;
+		}
+
+		if (cmp < 0)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	he = hist_entry__new(&entry);
+	if (!he)
+		return NULL;
+	rb_link_node(&he->rb_node, parent, p);
+	rb_insert_color(&he->rb_node, &self->entries);
+	hists__inc_nr_entries(self, he);
+out:
+	hist_entry__add_cpumode_period(he, al->cpumode, period);
+	return he;
+}
+
+int64_t
+hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	struct sort_entry *se;
+	int64_t cmp = 0;
+
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		cmp = se->se_cmp(left, right);
+		if (cmp)
+			break;
+	}
+
+	return cmp;
+}
+
+int64_t
+hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
+{
+	struct sort_entry *se;
+	int64_t cmp = 0;
+
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		int64_t (*f)(struct hist_entry *, struct hist_entry *);
+
+		f = se->se_collapse ?: se->se_cmp;
+
+		cmp = f(left, right);
+		if (cmp)
+			break;
+	}
+
+	return cmp;
+}
+
+void hist_entry__free(struct hist_entry *he)
+{
+	free(he);
+}
+
+/*
+ * collapse the histogram
+ */
+
+static bool collapse__insert_entry(struct rb_root *root, struct hist_entry *he)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct hist_entry *iter;
+	int64_t cmp;
+
+	while (*p != NULL) {
+		parent = *p;
+		iter = rb_entry(parent, struct hist_entry, rb_node);
+
+		cmp = hist_entry__collapse(iter, he);
+
+		if (!cmp) {
+			iter->period += he->period;
+			hist_entry__free(he);
+			return false;
+		}
+
+		if (cmp < 0)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&he->rb_node, parent, p);
+	rb_insert_color(&he->rb_node, root);
+	return true;
+}
+
+void hists__collapse_resort(struct hists *self)
+{
+	struct rb_root tmp;
+	struct rb_node *next;
+	struct hist_entry *n;
+
+	if (!sort__need_collapse)
+		return;
+
+	tmp = RB_ROOT;
+	next = rb_first(&self->entries);
+	self->nr_entries = 0;
+	self->max_sym_namelen = 0;
+
+	while (next) {
+		n = rb_entry(next, struct hist_entry, rb_node);
+		next = rb_next(&n->rb_node);
+
+		rb_erase(&n->rb_node, &self->entries);
+		if (collapse__insert_entry(&tmp, n))
+			hists__inc_nr_entries(self, n);
+	}
+
+	self->entries = tmp;
+}
+
+/*
+ * reverse the map, sort on period.
+ */
+
+static void __hists__insert_output_entry(struct rb_root *entries,
+					 struct hist_entry *he,
+					 u64 min_callchain_hits)
+{
+	struct rb_node **p = &entries->rb_node;
+	struct rb_node *parent = NULL;
+	struct hist_entry *iter;
+
+	if (symbol_conf.use_callchain)
+		callchain_param.sort(&he->sorted_chain, he->callchain,
+				      min_callchain_hits, &callchain_param);
+
+	while (*p != NULL) {
+		parent = *p;
+		iter = rb_entry(parent, struct hist_entry, rb_node);
+
+		if (he->period > iter->period)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&he->rb_node, parent, p);
+	rb_insert_color(&he->rb_node, entries);
+}
+
+void hists__output_resort(struct hists *self)
+{
+	struct rb_root tmp;
+	struct rb_node *next;
+	struct hist_entry *n;
+	u64 min_callchain_hits;
+
+	min_callchain_hits = self->stats.total_period * (callchain_param.min_percent / 100);
+
+	tmp = RB_ROOT;
+	next = rb_first(&self->entries);
+
+	self->nr_entries = 0;
+	self->max_sym_namelen = 0;
+
+	while (next) {
+		n = rb_entry(next, struct hist_entry, rb_node);
+		next = rb_next(&n->rb_node);
+
+		rb_erase(&n->rb_node, &self->entries);
+		__hists__insert_output_entry(&tmp, n, min_callchain_hits);
+		hists__inc_nr_entries(self, n);
+	}
+
+	self->entries = tmp;
+}
+
+static size_t callchain__fprintf_left_margin(FILE *fp, int left_margin)
+{
+	int i;
+	int ret = fprintf(fp, "            ");
+
+	for (i = 0; i < left_margin; i++)
+		ret += fprintf(fp, " ");
+
+	return ret;
+}
+
+static size_t ipchain__fprintf_graph_line(FILE *fp, int depth, int depth_mask,
+					  int left_margin)
+{
+	int i;
+	size_t ret = callchain__fprintf_left_margin(fp, left_margin);
+
+	for (i = 0; i < depth; i++)
+		if (depth_mask & (1 << i))
+			ret += fprintf(fp, "|          ");
+		else
+			ret += fprintf(fp, "           ");
+
+	ret += fprintf(fp, "\n");
+
+	return ret;
+}
+
+static size_t ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain,
+				     int depth, int depth_mask, int period,
+				     u64 total_samples, int hits,
+				     int left_margin)
+{
+	int i;
+	size_t ret = 0;
+
+	ret += callchain__fprintf_left_margin(fp, left_margin);
+	for (i = 0; i < depth; i++) {
+		if (depth_mask & (1 << i))
+			ret += fprintf(fp, "|");
+		else
+			ret += fprintf(fp, " ");
+		if (!period && i == depth - 1) {
+			double percent;
+
+			percent = hits * 100.0 / total_samples;
+			ret += percent_color_fprintf(fp, "--%2.2f%%-- ", percent);
+		} else
+			ret += fprintf(fp, "%s", "          ");
+	}
+	if (chain->ms.sym)
+		ret += fprintf(fp, "%s\n", chain->ms.sym->name);
+	else
+		ret += fprintf(fp, "%p\n", (void *)(long)chain->ip);
+
+	return ret;
+}
+
+static struct symbol *rem_sq_bracket;
+static struct callchain_list rem_hits;
+
+static void init_rem_hits(void)
+{
+	rem_sq_bracket = malloc(sizeof(*rem_sq_bracket) + 6);
+	if (!rem_sq_bracket) {
+		fprintf(stderr, "Not enough memory to display remaining hits\n");
+		return;
+	}
+
+	strcpy(rem_sq_bracket->name, "[...]");
+	rem_hits.ms.sym = rem_sq_bracket;
+}
+
+static size_t __callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
+					 u64 total_samples, int depth,
+					 int depth_mask, int left_margin)
+{
+	struct rb_node *node, *next;
+	struct callchain_node *child;
+	struct callchain_list *chain;
+	int new_depth_mask = depth_mask;
+	u64 new_total;
+	u64 remaining;
+	size_t ret = 0;
+	int i;
+	uint entries_printed = 0;
+
+	if (callchain_param.mode == CHAIN_GRAPH_REL)
+		new_total = self->children_hit;
+	else
+		new_total = total_samples;
+
+	remaining = new_total;
+
+	node = rb_first(&self->rb_root);
+	while (node) {
+		u64 cumul;
+
+		child = rb_entry(node, struct callchain_node, rb_node);
+		cumul = cumul_hits(child);
+		remaining -= cumul;
+
+		/*
+		 * The depth mask manages the output of pipes that show
+		 * the depth. We don't want to keep the pipes of the current
+		 * level for the last child of this depth.
+		 * Except if we have remaining filtered hits. They will
+		 * supersede the last child
+		 */
+		next = rb_next(node);
+		if (!next && (callchain_param.mode != CHAIN_GRAPH_REL || !remaining))
+			new_depth_mask &= ~(1 << (depth - 1));
+
+		/*
+		 * But we keep the older depth mask for the line separator
+		 * to keep the level link until we reach the last child
+		 */
+		ret += ipchain__fprintf_graph_line(fp, depth, depth_mask,
+						   left_margin);
+		i = 0;
+		list_for_each_entry(chain, &child->val, list) {
+			ret += ipchain__fprintf_graph(fp, chain, depth,
+						      new_depth_mask, i++,
+						      new_total,
+						      cumul,
+						      left_margin);
+		}
+		ret += __callchain__fprintf_graph(fp, child, new_total,
+						  depth + 1,
+						  new_depth_mask | (1 << depth),
+						  left_margin);
+		node = next;
+		if (++entries_printed == callchain_param.print_limit)
+			break;
+	}
+
+	if (callchain_param.mode == CHAIN_GRAPH_REL &&
+		remaining && remaining != new_total) {
+
+		if (!rem_sq_bracket)
+			return ret;
+
+		new_depth_mask &= ~(1 << (depth - 1));
+
+		ret += ipchain__fprintf_graph(fp, &rem_hits, depth,
+					      new_depth_mask, 0, new_total,
+					      remaining, left_margin);
+	}
+
+	return ret;
+}
+
+static size_t callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
+				       u64 total_samples, int left_margin)
+{
+	struct callchain_list *chain;
+	bool printed = false;
+	int i = 0;
+	int ret = 0;
+	u32 entries_printed = 0;
+
+	list_for_each_entry(chain, &self->val, list) {
+		if (!i++ && sort__first_dimension == SORT_SYM)
+			continue;
+
+		if (!printed) {
+			ret += callchain__fprintf_left_margin(fp, left_margin);
+			ret += fprintf(fp, "|\n");
+			ret += callchain__fprintf_left_margin(fp, left_margin);
+			ret += fprintf(fp, "---");
+
+			left_margin += 3;
+			printed = true;
+		} else
+			ret += callchain__fprintf_left_margin(fp, left_margin);
+
+		if (chain->ms.sym)
+			ret += fprintf(fp, " %s\n", chain->ms.sym->name);
+		else
+			ret += fprintf(fp, " %p\n", (void *)(long)chain->ip);
+
+		if (++entries_printed == callchain_param.print_limit)
+			break;
+	}
+
+	ret += __callchain__fprintf_graph(fp, self, total_samples, 1, 1, left_margin);
+
+	return ret;
+}
+
+static size_t callchain__fprintf_flat(FILE *fp, struct callchain_node *self,
+				      u64 total_samples)
+{
+	struct callchain_list *chain;
+	size_t ret = 0;
+
+	if (!self)
+		return 0;
+
+	ret += callchain__fprintf_flat(fp, self->parent, total_samples);
+
+
+	list_for_each_entry(chain, &self->val, list) {
+		if (chain->ip >= PERF_CONTEXT_MAX)
+			continue;
+		if (chain->ms.sym)
+			ret += fprintf(fp, "                %s\n", chain->ms.sym->name);
+		else
+			ret += fprintf(fp, "                %p\n",
+					(void *)(long)chain->ip);
+	}
+
+	return ret;
+}
+
+static size_t hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
+					    u64 total_samples, int left_margin)
+{
+	struct rb_node *rb_node;
+	struct callchain_node *chain;
+	size_t ret = 0;
+	u32 entries_printed = 0;
+
+	rb_node = rb_first(&self->sorted_chain);
+	while (rb_node) {
+		double percent;
+
+		chain = rb_entry(rb_node, struct callchain_node, rb_node);
+		percent = chain->hit * 100.0 / total_samples;
+		switch (callchain_param.mode) {
+		case CHAIN_FLAT:
+			ret += percent_color_fprintf(fp, "           %6.2f%%\n",
+						     percent);
+			ret += callchain__fprintf_flat(fp, chain, total_samples);
+			break;
+		case CHAIN_GRAPH_ABS: /* Falldown */
+		case CHAIN_GRAPH_REL:
+			ret += callchain__fprintf_graph(fp, chain, total_samples,
+							left_margin);
+		case CHAIN_NONE:
+		default:
+			break;
+		}
+		ret += fprintf(fp, "\n");
+		if (++entries_printed == callchain_param.print_limit)
+			break;
+		rb_node = rb_next(rb_node);
+	}
+
+	return ret;
+}
+
+int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
+			 struct hists *pair_hists, bool show_displacement,
+			 long displacement, bool color, u64 session_total)
+{
+	struct sort_entry *se;
+	u64 period, total, period_sys, period_us, period_guest_sys, period_guest_us;
+	const char *sep = symbol_conf.field_sep;
+	int ret;
+
+	if (symbol_conf.exclude_other && !self->parent)
+		return 0;
+
+	if (pair_hists) {
+		period = self->pair ? self->pair->period : 0;
+		total = pair_hists->stats.total_period;
+		period_sys = self->pair ? self->pair->period_sys : 0;
+		period_us = self->pair ? self->pair->period_us : 0;
+		period_guest_sys = self->pair ? self->pair->period_guest_sys : 0;
+		period_guest_us = self->pair ? self->pair->period_guest_us : 0;
+	} else {
+		period = self->period;
+		total = session_total;
+		period_sys = self->period_sys;
+		period_us = self->period_us;
+		period_guest_sys = self->period_guest_sys;
+		period_guest_us = self->period_guest_us;
+	}
+
+	if (total) {
+		if (color)
+			ret = percent_color_snprintf(s, size,
+						     sep ? "%.2f" : "   %6.2f%%",
+						     (period * 100.0) / total);
+		else
+			ret = snprintf(s, size, sep ? "%.2f" : "   %6.2f%%",
+				       (period * 100.0) / total);
+		if (symbol_conf.show_cpu_utilization) {
+			ret += percent_color_snprintf(s + ret, size - ret,
+					sep ? "%.2f" : "   %6.2f%%",
+					(period_sys * 100.0) / total);
+			ret += percent_color_snprintf(s + ret, size - ret,
+					sep ? "%.2f" : "   %6.2f%%",
+					(period_us * 100.0) / total);
+			if (perf_guest) {
+				ret += percent_color_snprintf(s + ret,
+						size - ret,
+						sep ? "%.2f" : "   %6.2f%%",
+						(period_guest_sys * 100.0) /
+								total);
+				ret += percent_color_snprintf(s + ret,
+						size - ret,
+						sep ? "%.2f" : "   %6.2f%%",
+						(period_guest_us * 100.0) /
+								total);
+			}
+		}
+	} else
+		ret = snprintf(s, size, sep ? "%lld" : "%12lld ", period);
+
+	if (symbol_conf.show_nr_samples) {
+		if (sep)
+			ret += snprintf(s + ret, size - ret, "%c%lld", *sep, period);
+		else
+			ret += snprintf(s + ret, size - ret, "%11lld", period);
+	}
+
+	if (pair_hists) {
+		char bf[32];
+		double old_percent = 0, new_percent = 0, diff;
+
+		if (total > 0)
+			old_percent = (period * 100.0) / total;
+		if (session_total > 0)
+			new_percent = (self->period * 100.0) / session_total;
+
+		diff = new_percent - old_percent;
+
+		if (fabs(diff) >= 0.01)
+			snprintf(bf, sizeof(bf), "%+4.2F%%", diff);
+		else
+			snprintf(bf, sizeof(bf), " ");
+
+		if (sep)
+			ret += snprintf(s + ret, size - ret, "%c%s", *sep, bf);
+		else
+			ret += snprintf(s + ret, size - ret, "%11.11s", bf);
+
+		if (show_displacement) {
+			if (displacement)
+				snprintf(bf, sizeof(bf), "%+4ld", displacement);
+			else
+				snprintf(bf, sizeof(bf), " ");
+
+			if (sep)
+				ret += snprintf(s + ret, size - ret, "%c%s", *sep, bf);
+			else
+				ret += snprintf(s + ret, size - ret, "%6.6s", bf);
+		}
+	}
+
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		if (se->elide)
+			continue;
+
+		ret += snprintf(s + ret, size - ret, "%s", sep ?: "  ");
+		ret += se->se_snprintf(self, s + ret, size - ret,
+				       se->se_width ? *se->se_width : 0);
+	}
+
+	return ret;
+}
+
+int hist_entry__fprintf(struct hist_entry *self, struct hists *pair_hists,
+			bool show_displacement, long displacement, FILE *fp,
+			u64 session_total)
+{
+	char bf[512];
+	hist_entry__snprintf(self, bf, sizeof(bf), pair_hists,
+			     show_displacement, displacement,
+			     true, session_total);
+	return fprintf(fp, "%s\n", bf);
+}
+
+static size_t hist_entry__fprintf_callchain(struct hist_entry *self, FILE *fp,
+					    u64 session_total)
+{
+	int left_margin = 0;
+
+	if (sort__first_dimension == SORT_COMM) {
+		struct sort_entry *se = list_first_entry(&hist_entry__sort_list,
+							 typeof(*se), list);
+		left_margin = se->se_width ? *se->se_width : 0;
+		left_margin -= thread__comm_len(self->thread);
+	}
+
+	return hist_entry_callchain__fprintf(fp, self, session_total,
+					     left_margin);
+}
+
+size_t hists__fprintf(struct hists *self, struct hists *pair,
+		      bool show_displacement, FILE *fp)
+{
+	struct sort_entry *se;
+	struct rb_node *nd;
+	size_t ret = 0;
+	unsigned long position = 1;
+	long displacement = 0;
+	unsigned int width;
+	const char *sep = symbol_conf.field_sep;
+	const char *col_width = symbol_conf.col_width_list_str;
+
+	init_rem_hits();
+
+	fprintf(fp, "# %s", pair ? "Baseline" : "Overhead");
+
+	if (symbol_conf.show_nr_samples) {
+		if (sep)
+			fprintf(fp, "%cSamples", *sep);
+		else
+			fputs("  Samples  ", fp);
+	}
+
+	if (symbol_conf.show_cpu_utilization) {
+		if (sep) {
+			ret += fprintf(fp, "%csys", *sep);
+			ret += fprintf(fp, "%cus", *sep);
+			if (perf_guest) {
+				ret += fprintf(fp, "%cguest sys", *sep);
+				ret += fprintf(fp, "%cguest us", *sep);
+			}
+		} else {
+			ret += fprintf(fp, "  sys  ");
+			ret += fprintf(fp, "  us  ");
+			if (perf_guest) {
+				ret += fprintf(fp, "  guest sys  ");
+				ret += fprintf(fp, "  guest us  ");
+			}
+		}
+	}
+
+	if (pair) {
+		if (sep)
+			ret += fprintf(fp, "%cDelta", *sep);
+		else
+			ret += fprintf(fp, "  Delta    ");
+
+		if (show_displacement) {
+			if (sep)
+				ret += fprintf(fp, "%cDisplacement", *sep);
+			else
+				ret += fprintf(fp, " Displ");
+		}
+	}
+
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		if (se->elide)
+			continue;
+		if (sep) {
+			fprintf(fp, "%c%s", *sep, se->se_header);
+			continue;
+		}
+		width = strlen(se->se_header);
+		if (se->se_width) {
+			if (symbol_conf.col_width_list_str) {
+				if (col_width) {
+					*se->se_width = atoi(col_width);
+					col_width = strchr(col_width, ',');
+					if (col_width)
+						++col_width;
+				}
+			}
+			width = *se->se_width = max(*se->se_width, width);
+		}
+		fprintf(fp, "  %*s", width, se->se_header);
+	}
+	fprintf(fp, "\n");
+
+	if (sep)
+		goto print_entries;
+
+	fprintf(fp, "# ........");
+	if (symbol_conf.show_nr_samples)
+		fprintf(fp, " ..........");
+	if (pair) {
+		fprintf(fp, " ..........");
+		if (show_displacement)
+			fprintf(fp, " .....");
+	}
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		unsigned int i;
+
+		if (se->elide)
+			continue;
+
+		fprintf(fp, "  ");
+		if (se->se_width)
+			width = *se->se_width;
+		else
+			width = strlen(se->se_header);
+		for (i = 0; i < width; i++)
+			fprintf(fp, ".");
+	}
+
+	fprintf(fp, "\n#\n");
+
+print_entries:
+	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
+		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+
+		if (show_displacement) {
+			if (h->pair != NULL)
+				displacement = ((long)h->pair->position -
+					        (long)position);
+			else
+				displacement = 0;
+			++position;
+		}
+		ret += hist_entry__fprintf(h, pair, show_displacement,
+					   displacement, fp, self->stats.total_period);
+
+		if (symbol_conf.use_callchain)
+			ret += hist_entry__fprintf_callchain(h, fp, self->stats.total_period);
+
+		if (h->ms.map == NULL && verbose > 1) {
+			__map_groups__fprintf_maps(&h->thread->mg,
+						   MAP__FUNCTION, verbose, fp);
+			fprintf(fp, "%.10s end\n", graph_dotted_line);
+		}
+	}
+
+	free(rem_sq_bracket);
+
+	return ret;
+}
+
+enum hist_filter {
+	HIST_FILTER__DSO,
+	HIST_FILTER__THREAD,
+};
+
+void hists__filter_by_dso(struct hists *self, const struct dso *dso)
+{
+	struct rb_node *nd;
+
+	self->nr_entries = self->stats.total_period = 0;
+	self->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
+	self->max_sym_namelen = 0;
+
+	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
+		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+
+		if (symbol_conf.exclude_other && !h->parent)
+			continue;
+
+		if (dso != NULL && (h->ms.map == NULL || h->ms.map->dso != dso)) {
+			h->filtered |= (1 << HIST_FILTER__DSO);
+			continue;
+		}
+
+		h->filtered &= ~(1 << HIST_FILTER__DSO);
+		if (!h->filtered) {
+			++self->nr_entries;
+			self->stats.total_period += h->period;
+			self->stats.nr_events[PERF_RECORD_SAMPLE] += h->nr_events;
+			if (h->ms.sym &&
+			    self->max_sym_namelen < h->ms.sym->namelen)
+				self->max_sym_namelen = h->ms.sym->namelen;
+		}
+	}
+}
+
+void hists__filter_by_thread(struct hists *self, const struct thread *thread)
+{
+	struct rb_node *nd;
+
+	self->nr_entries = self->stats.total_period = 0;
+	self->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
+	self->max_sym_namelen = 0;
+
+	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
+		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+
+		if (thread != NULL && h->thread != thread) {
+			h->filtered |= (1 << HIST_FILTER__THREAD);
+			continue;
+		}
+		h->filtered &= ~(1 << HIST_FILTER__THREAD);
+		if (!h->filtered) {
+			++self->nr_entries;
+			self->stats.total_period += h->period;
+			self->stats.nr_events[PERF_RECORD_SAMPLE] += h->nr_events;
+			if (h->ms.sym &&
+			    self->max_sym_namelen < h->ms.sym->namelen)
+				self->max_sym_namelen = h->ms.sym->namelen;
+		}
+	}
+}
+
+static int symbol__alloc_hist(struct symbol *self)
+{
+	struct sym_priv *priv = symbol__priv(self);
+	const int size = (sizeof(*priv->hist) +
+			  (self->end - self->start) * sizeof(u64));
+
+	priv->hist = zalloc(size);
+	return priv->hist == NULL ? -1 : 0;
+}
+
+int hist_entry__inc_addr_samples(struct hist_entry *self, u64 ip)
+{
+	unsigned int sym_size, offset;
+	struct symbol *sym = self->ms.sym;
+	struct sym_priv *priv;
+	struct sym_hist *h;
+
+	if (!sym || !self->ms.map)
+		return 0;
+
+	priv = symbol__priv(sym);
+	if (priv->hist == NULL && symbol__alloc_hist(sym) < 0)
+		return -ENOMEM;
+
+	sym_size = sym->end - sym->start;
+	offset = ip - sym->start;
+
+	pr_debug3("%s: ip=%#Lx\n", __func__, self->ms.map->unmap_ip(self->ms.map, ip));
+
+	if (offset >= sym_size)
+		return 0;
+
+	h = priv->hist;
+	h->sum++;
+	h->ip[offset]++;
+
+	pr_debug3("%#Lx %s: period++ [ip: %#Lx, %#Lx] => %Ld\n", self->ms.sym->start,
+		  self->ms.sym->name, ip, ip - self->ms.sym->start, h->ip[offset]);
+	return 0;
+}
+
+static struct objdump_line *objdump_line__new(s64 offset, char *line)
+{
+	struct objdump_line *self = malloc(sizeof(*self));
+
+	if (self != NULL) {
+		self->offset = offset;
+		self->line = line;
+	}
+
+	return self;
+}
+
+void objdump_line__free(struct objdump_line *self)
+{
+	free(self->line);
+	free(self);
+}
+
+static void objdump__add_line(struct list_head *head, struct objdump_line *line)
+{
+	list_add_tail(&line->node, head);
+}
+
+struct objdump_line *objdump__get_next_ip_line(struct list_head *head,
+					       struct objdump_line *pos)
+{
+	list_for_each_entry_continue(pos, head, node)
+		if (pos->offset >= 0)
+			return pos;
+
+	return NULL;
+}
+
+static int hist_entry__parse_objdump_line(struct hist_entry *self, FILE *file,
+					  struct list_head *head)
+{
+	struct symbol *sym = self->ms.sym;
+	struct objdump_line *objdump_line;
+	char *line = NULL, *tmp, *tmp2, *c;
+	size_t line_len;
+	s64 line_ip, offset = -1;
+
+	if (getline(&line, &line_len, file) < 0)
+		return -1;
+
+	if (!line)
+		return -1;
+
+	while (line_len != 0 && isspace(line[line_len - 1]))
+		line[--line_len] = '\0';
+
+	c = strchr(line, '\n');
+	if (c)
+		*c = 0;
+
+	line_ip = -1;
+
+	/*
+	 * Strip leading spaces:
+	 */
+	tmp = line;
+	while (*tmp) {
+		if (*tmp != ' ')
+			break;
+		tmp++;
+	}
+
+	if (*tmp) {
+		/*
+		 * Parse hexa addresses followed by ':'
+		 */
+		line_ip = strtoull(tmp, &tmp2, 16);
+		if (*tmp2 != ':' || tmp == tmp2)
+			line_ip = -1;
+	}
+
+	if (line_ip != -1) {
+		u64 start = map__rip_2objdump(self->ms.map, sym->start);
+		offset = line_ip - start;
+	}
+
+	objdump_line = objdump_line__new(offset, line);
+	if (objdump_line == NULL) {
+		free(line);
+		return -1;
+	}
+	objdump__add_line(head, objdump_line);
+
+	return 0;
+}
+
+int hist_entry__annotate(struct hist_entry *self, struct list_head *head)
+{
+	struct symbol *sym = self->ms.sym;
+	struct map *map = self->ms.map;
+	struct dso *dso = map->dso;
+	char *filename = dso__build_id_filename(dso, NULL, 0);
+	bool free_filename = true;
+	char command[PATH_MAX * 2];
+	FILE *file;
+	int err = 0;
+	u64 len;
+
+	if (filename == NULL) {
+		if (dso->has_build_id) {
+			pr_err("Can't annotate %s: not enough memory\n",
+			       sym->name);
+			return -ENOMEM;
+		}
+		goto fallback;
+	} else if (readlink(filename, command, sizeof(command)) < 0 ||
+		   strstr(command, "[kernel.kallsyms]") ||
+		   access(filename, R_OK)) {
+		free(filename);
+fallback:
+		/*
+		 * If we don't have build-ids or the build-id file isn't in the
+		 * cache, or is just a kallsyms file, well, lets hope that this
+		 * DSO is the same as when 'perf record' ran.
+		 */
+		filename = dso->long_name;
+		free_filename = false;
+	}
+
+	if (dso->origin == DSO__ORIG_KERNEL) {
+		if (dso->annotate_warned)
+			goto out_free_filename;
+		err = -ENOENT;
+		dso->annotate_warned = 1;
+		pr_err("Can't annotate %s: No vmlinux file was found in the "
+		       "path\n", sym->name);
+		goto out_free_filename;
+	}
+
+	pr_debug("%s: filename=%s, sym=%s, start=%#Lx, end=%#Lx\n", __func__,
+		 filename, sym->name, map->unmap_ip(map, sym->start),
+		 map->unmap_ip(map, sym->end));
+
+	len = sym->end - sym->start;
+
+	pr_debug("annotating [%p] %30s : [%p] %30s\n",
+		 dso, dso->long_name, sym, sym->name);
+
+	snprintf(command, sizeof(command),
+		 "objdump --start-address=0x%016Lx --stop-address=0x%016Lx -dS -C %s|grep -v %s|expand",
+		 map__rip_2objdump(map, sym->start),
+		 map__rip_2objdump(map, sym->end),
+		 filename, filename);
+
+	pr_debug("Executing: %s\n", command);
+
+	file = popen(command, "r");
+	if (!file)
+		goto out_free_filename;
+
+	while (!feof(file))
+		if (hist_entry__parse_objdump_line(self, file, head) < 0)
+			break;
+
+	pclose(file);
+out_free_filename:
+	if (free_filename)
+		free(filename);
+	return err;
+}
+
+void hists__inc_nr_events(struct hists *self, u32 type)
+{
+	++self->stats.nr_events[0];
+	++self->stats.nr_events[type];
+}
+
+size_t hists__fprintf_nr_events(struct hists *self, FILE *fp)
+{
+	int i;
+	size_t ret = 0;
+
+	for (i = 0; i < PERF_RECORD_HEADER_MAX; ++i) {
+		if (!event__name[i])
+			continue;
+		ret += fprintf(fp, "%10s events: %10d\n",
+			       event__name[i], self->stats.nr_events[i]);
+	}
+
+	return ret;
+}
diff --git a/tools/lib/perf/hist.h b/tools/lib/perf/hist.h
new file mode 100644
index 0000000..5d5cf49
--- /dev/null
+++ b/tools/lib/perf/hist.h
@@ -0,0 +1,129 @@
+#ifndef __PERF_HIST_H
+#define __PERF_HIST_H
+
+#include <linux/types.h>
+#include <util/callchain.h>
+
+extern struct callchain_param callchain_param;
+
+struct hist_entry;
+struct addr_location;
+struct symbol;
+struct rb_root;
+
+struct objdump_line {
+	struct list_head node;
+	s64		 offset;
+	char		 *line;
+};
+
+void objdump_line__free(struct objdump_line *self);
+struct objdump_line *objdump__get_next_ip_line(struct list_head *head,
+					       struct objdump_line *pos);
+
+struct sym_hist {
+	u64		sum;
+	u64		ip[0];
+};
+
+struct sym_ext {
+	struct rb_node	node;
+	double		percent;
+	char		*path;
+};
+
+struct sym_priv {
+	struct sym_hist	*hist;
+	struct sym_ext	*ext;
+};
+
+/*
+ * The kernel collects the number of events it couldn't send in a stretch and
+ * when possible sends this number in a PERF_RECORD_LOST event. The number of
+ * such "chunks" of lost events is stored in .nr_events[PERF_EVENT_LOST] while
+ * total_lost tells exactly how many events the kernel in fact lost, i.e. it is
+ * the sum of all struct lost_event.lost fields reported.
+ *
+ * The total_period is needed because by default auto-freq is used, so
+ * multipling nr_events[PERF_EVENT_SAMPLE] by a frequency isn't possible to get
+ * the total number of low level events, it is necessary to to sum all struct
+ * sample_event.period and stash the result in total_period.
+ */
+struct events_stats {
+	u64 total_period;
+	u64 total_lost;
+	u32 nr_events[PERF_RECORD_HEADER_MAX];
+	u32 nr_unknown_events;
+};
+
+struct hists {
+	struct rb_node		rb_node;
+	struct rb_root		entries;
+	u64			nr_entries;
+	struct events_stats	stats;
+	u64			config;
+	u64			event_stream;
+	u32			type;
+	u32			max_sym_namelen;
+};
+
+struct hist_entry *__hists__add_entry(struct hists *self,
+				      struct addr_location *al,
+				      struct symbol *parent, u64 period);
+extern int64_t hist_entry__cmp(struct hist_entry *, struct hist_entry *);
+extern int64_t hist_entry__collapse(struct hist_entry *, struct hist_entry *);
+int hist_entry__fprintf(struct hist_entry *self, struct hists *pair_hists,
+			bool show_displacement, long displacement, FILE *fp,
+			u64 total);
+int hist_entry__snprintf(struct hist_entry *self, char *bf, size_t size,
+			 struct hists *pair_hists, bool show_displacement,
+			 long displacement, bool color, u64 total);
+void hist_entry__free(struct hist_entry *);
+
+void hists__output_resort(struct hists *self);
+void hists__collapse_resort(struct hists *self);
+
+void hists__inc_nr_events(struct hists *self, u32 type);
+size_t hists__fprintf_nr_events(struct hists *self, FILE *fp);
+
+size_t hists__fprintf(struct hists *self, struct hists *pair,
+		      bool show_displacement, FILE *fp);
+
+int hist_entry__inc_addr_samples(struct hist_entry *self, u64 ip);
+int hist_entry__annotate(struct hist_entry *self, struct list_head *head);
+
+void hists__filter_by_dso(struct hists *self, const struct dso *dso);
+void hists__filter_by_thread(struct hists *self, const struct thread *thread);
+
+#ifdef NO_NEWT_SUPPORT
+static inline int hists__browse(struct hists *self __used,
+				const char *helpline __used,
+				const char *ev_name __used)
+{
+	return 0;
+}
+
+static inline int hists__tui_browse_tree(struct rb_root *self __used,
+					 const char *help __used)
+{
+	return 0;
+}
+
+static inline int hist_entry__tui_annotate(struct hist_entry *self __used)
+{
+	return 0;
+}
+#define KEY_LEFT -1
+#define KEY_RIGHT -2
+#else
+#include <newt.h>
+int hists__browse(struct hists *self, const char *helpline,
+		  const char *ev_name);
+int hist_entry__tui_annotate(struct hist_entry *self);
+
+#define KEY_LEFT NEWT_KEY_LEFT
+#define KEY_RIGHT NEWT_KEY_RIGHT
+
+int hists__tui_browse_tree(struct rb_root *self, const char *help);
+#endif
+#endif	/* __PERF_HIST_H */
diff --git a/tools/lib/perf/session.c b/tools/lib/perf/session.c
index 5e9998c..c1589e9 100644
--- a/tools/lib/perf/session.c
+++ b/tools/lib/perf/session.c
@@ -6,9 +6,8 @@
 #include <unistd.h>
 #include <sys/types.h>
 #include <sys/mman.h>
-
 #include "session.h"
-#include <util/sort.h>
+#include "sort.h"
 #include <lk/util.h>
 
 static int perf_session__open(struct perf_session *self, bool force)
diff --git a/tools/lib/perf/session.h b/tools/lib/perf/session.h
index 1bbece2..bf3b5c4 100644
--- a/tools/lib/perf/session.h
+++ b/tools/lib/perf/session.h
@@ -1,10 +1,10 @@
 #ifndef __PERF_SESSION_H
 #define __PERF_SESSION_H
 
-#include <util/hist.h>
-#include <util/event.h>
+#include "hist.h"
+#include "event.h"
 #include "symbol.h"
-#include <util/thread.h>
+#include "thread.h"
 #include <linux/bitops.h>
 #include <linux/rbtree.h>
 #include "../../../include/linux/perf_event.h"
diff --git a/tools/lib/perf/sort.c b/tools/lib/perf/sort.c
new file mode 100644
index 0000000..c27b4b0
--- /dev/null
+++ b/tools/lib/perf/sort.c
@@ -0,0 +1,346 @@
+#include "sort.h"
+
+regex_t		parent_regex;
+const char	default_parent_pattern[] = "^sys_|^do_page_fault";
+const char	*parent_pattern = default_parent_pattern;
+const char	default_sort_order[] = "comm,dso,symbol";
+const char	*sort_order = default_sort_order;
+int		sort__need_collapse = 0;
+int		sort__has_parent = 0;
+
+enum sort_type	sort__first_dimension;
+
+unsigned int dsos__col_width;
+unsigned int comms__col_width;
+unsigned int threads__col_width;
+unsigned int cpus__col_width;
+static unsigned int parent_symbol__col_width;
+char * field_sep;
+
+LIST_HEAD(hist_entry__sort_list);
+
+static int hist_entry__thread_snprintf(struct hist_entry *self, char *bf,
+				       size_t size, unsigned int width);
+static int hist_entry__comm_snprintf(struct hist_entry *self, char *bf,
+				     size_t size, unsigned int width);
+static int hist_entry__dso_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width);
+static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width);
+static int hist_entry__parent_snprintf(struct hist_entry *self, char *bf,
+				       size_t size, unsigned int width);
+static int hist_entry__cpu_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width);
+
+struct sort_entry sort_thread = {
+	.se_header	= "Command:  Pid",
+	.se_cmp		= sort__thread_cmp,
+	.se_snprintf	= hist_entry__thread_snprintf,
+	.se_width	= &threads__col_width,
+};
+
+struct sort_entry sort_comm = {
+	.se_header	= "Command",
+	.se_cmp		= sort__comm_cmp,
+	.se_collapse	= sort__comm_collapse,
+	.se_snprintf	= hist_entry__comm_snprintf,
+	.se_width	= &comms__col_width,
+};
+
+struct sort_entry sort_dso = {
+	.se_header	= "Shared Object",
+	.se_cmp		= sort__dso_cmp,
+	.se_snprintf	= hist_entry__dso_snprintf,
+	.se_width	= &dsos__col_width,
+};
+
+struct sort_entry sort_sym = {
+	.se_header	= "Symbol",
+	.se_cmp		= sort__sym_cmp,
+	.se_snprintf	= hist_entry__sym_snprintf,
+};
+
+struct sort_entry sort_parent = {
+	.se_header	= "Parent symbol",
+	.se_cmp		= sort__parent_cmp,
+	.se_snprintf	= hist_entry__parent_snprintf,
+	.se_width	= &parent_symbol__col_width,
+};
+ 
+struct sort_entry sort_cpu = {
+	.se_header      = "CPU",
+	.se_cmp	        = sort__cpu_cmp,
+	.se_snprintf    = hist_entry__cpu_snprintf,
+	.se_width	= &cpus__col_width,
+};
+
+struct sort_dimension {
+	const char		*name;
+	struct sort_entry	*entry;
+	int			taken;
+};
+
+static struct sort_dimension sort_dimensions[] = {
+	{ .name = "pid",	.entry = &sort_thread,	},
+	{ .name = "comm",	.entry = &sort_comm,	},
+	{ .name = "dso",	.entry = &sort_dso,	},
+	{ .name = "symbol",	.entry = &sort_sym,	},
+	{ .name = "parent",	.entry = &sort_parent,	},
+	{ .name = "cpu",	.entry = &sort_cpu,	},
+};
+
+int64_t cmp_null(void *l, void *r)
+{
+	if (!l && !r)
+		return 0;
+	else if (!l)
+		return -1;
+	else
+		return 1;
+}
+
+/* --sort pid */
+
+int64_t
+sort__thread_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return right->thread->pid - left->thread->pid;
+}
+
+static int repsep_snprintf(char *bf, size_t size, const char *fmt, ...)
+{
+	int n;
+	va_list ap;
+
+	va_start(ap, fmt);
+	n = vsnprintf(bf, size, fmt, ap);
+	if (field_sep && n > 0) {
+		char *sep = bf;
+
+		while (1) {
+			sep = strchr(sep, *field_sep);
+			if (sep == NULL)
+				break;
+			*sep = '.';
+		}
+	}
+	va_end(ap);
+	return n;
+}
+
+static int hist_entry__thread_snprintf(struct hist_entry *self, char *bf,
+				       size_t size, unsigned int width)
+{
+	return repsep_snprintf(bf, size, "%*s:%5d", width,
+			      self->thread->comm ?: "", self->thread->pid);
+}
+
+static int hist_entry__comm_snprintf(struct hist_entry *self, char *bf,
+				     size_t size, unsigned int width)
+{
+	return repsep_snprintf(bf, size, "%*s", width, self->thread->comm);
+}
+
+/* --sort dso */
+
+int64_t
+sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	struct dso *dso_l = left->ms.map ? left->ms.map->dso : NULL;
+	struct dso *dso_r = right->ms.map ? right->ms.map->dso : NULL;
+	const char *dso_name_l, *dso_name_r;
+
+	if (!dso_l || !dso_r)
+		return cmp_null(dso_l, dso_r);
+
+	if (verbose) {
+		dso_name_l = dso_l->long_name;
+		dso_name_r = dso_r->long_name;
+	} else {
+		dso_name_l = dso_l->short_name;
+		dso_name_r = dso_r->short_name;
+	}
+
+	return strcmp(dso_name_l, dso_name_r);
+}
+
+static int hist_entry__dso_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
+	if (self->ms.map && self->ms.map->dso) {
+		const char *dso_name = !verbose ? self->ms.map->dso->short_name :
+						  self->ms.map->dso->long_name;
+		return repsep_snprintf(bf, size, "%-*s", width, dso_name);
+	}
+
+	return repsep_snprintf(bf, size, "%*Lx", width, self->ip);
+}
+
+/* --sort symbol */
+
+int64_t
+sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	u64 ip_l, ip_r;
+
+	if (left->ms.sym == right->ms.sym)
+		return 0;
+
+	ip_l = left->ms.sym ? left->ms.sym->start : left->ip;
+	ip_r = right->ms.sym ? right->ms.sym->start : right->ip;
+
+	return (int64_t)(ip_r - ip_l);
+}
+
+static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width __used)
+{
+	size_t ret = 0;
+
+	if (verbose) {
+		char o = self->ms.map ? dso__symtab_origin(self->ms.map->dso) : '!';
+		ret += repsep_snprintf(bf, size, "%#018llx %c ", self->ip, o);
+	}
+
+	ret += repsep_snprintf(bf + ret, size - ret, "[%c] ", self->level);
+	if (self->ms.sym)
+		ret += repsep_snprintf(bf + ret, size - ret, "%s",
+				       self->ms.sym->name);
+	else
+		ret += repsep_snprintf(bf + ret, size - ret, "%#016llx", self->ip);
+
+	return ret;
+}
+
+/* --sort comm */
+
+int64_t
+sort__comm_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return right->thread->pid - left->thread->pid;
+}
+
+int64_t
+sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
+{
+	char *comm_l = left->thread->comm;
+	char *comm_r = right->thread->comm;
+
+	if (!comm_l || !comm_r)
+		return cmp_null(comm_l, comm_r);
+
+	return strcmp(comm_l, comm_r);
+}
+
+/* --sort parent */
+
+int64_t
+sort__parent_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	struct symbol *sym_l = left->parent;
+	struct symbol *sym_r = right->parent;
+
+	if (!sym_l || !sym_r)
+		return cmp_null(sym_l, sym_r);
+
+	return strcmp(sym_l->name, sym_r->name);
+}
+
+static int hist_entry__parent_snprintf(struct hist_entry *self, char *bf,
+				       size_t size, unsigned int width)
+{
+	return repsep_snprintf(bf, size, "%-*s", width,
+			      self->parent ? self->parent->name : "[other]");
+}
+
+/* --sort cpu */
+
+int64_t
+sort__cpu_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return right->cpu - left->cpu;
+}
+
+static int hist_entry__cpu_snprintf(struct hist_entry *self, char *bf,
+				       size_t size, unsigned int width)
+{
+	return repsep_snprintf(bf, size, "%-*d", width, self->cpu);
+}
+
+int sort_dimension__add(const char *tok)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(sort_dimensions); i++) {
+		struct sort_dimension *sd = &sort_dimensions[i];
+
+		if (sd->taken)
+			continue;
+
+		if (strncasecmp(tok, sd->name, strlen(tok)))
+			continue;
+
+		if (sd->entry->se_collapse)
+			sort__need_collapse = 1;
+
+		if (sd->entry == &sort_parent) {
+			int ret = regcomp(&parent_regex, parent_pattern, REG_EXTENDED);
+			if (ret) {
+				char err[BUFSIZ];
+
+				regerror(ret, &parent_regex, err, sizeof(err));
+				pr_err("Invalid regex: %s\n%s", parent_pattern, err);
+				return -EINVAL;
+			}
+			sort__has_parent = 1;
+		}
+
+		if (list_empty(&hist_entry__sort_list)) {
+			if (!strcmp(sd->name, "pid"))
+				sort__first_dimension = SORT_PID;
+			else if (!strcmp(sd->name, "comm"))
+				sort__first_dimension = SORT_COMM;
+			else if (!strcmp(sd->name, "dso"))
+				sort__first_dimension = SORT_DSO;
+			else if (!strcmp(sd->name, "symbol"))
+				sort__first_dimension = SORT_SYM;
+			else if (!strcmp(sd->name, "parent"))
+				sort__first_dimension = SORT_PARENT;
+			else if (!strcmp(sd->name, "cpu"))
+				sort__first_dimension = SORT_CPU;
+		}
+
+		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
+		sd->taken = 1;
+
+		return 0;
+	}
+
+	return -ESRCH;
+}
+
+void setup_sorting(const char * const usagestr[], const struct option *opts)
+{
+	char *tmp, *tok, *str = strdup(sort_order);
+
+	for (tok = strtok_r(str, ", ", &tmp);
+			tok; tok = strtok_r(NULL, ", ", &tmp)) {
+		if (sort_dimension__add(tok) < 0) {
+			error("Unknown --sort key: `%s'", tok);
+			usage_with_options(usagestr, opts);
+		}
+	}
+
+	free(str);
+}
+
+void sort_entry__setup_elide(struct sort_entry *self, struct strlist *list,
+			     const char *list_name, FILE *fp)
+{
+	if (list && strlist__nr_entries(list) == 1) {
+		if (fp != NULL)
+			fprintf(fp, "# %s: %s\n", list_name,
+				strlist__entry(list, 0)->s);
+		self->elide = true;
+	}
+}
diff --git a/tools/lib/perf/sort.h b/tools/lib/perf/sort.h
new file mode 100644
index 0000000..6c3a5af
--- /dev/null
+++ b/tools/lib/perf/sort.h
@@ -0,0 +1,115 @@
+#ifndef __PERF_SORT_H
+#define __PERF_SORT_H
+#include <builtin.h>
+#include <perf.h>
+
+#include <lk/util.h>
+#include <lk/color.h>
+#include <linux/list.h>
+#include <linux/rbtree.h>
+#include <perf/symbol.h>
+#include "string.h"
+#include <util/callchain.h>
+#include <lk/strlist.h>
+#include "values.h"
+
+#include <lk/debug.h>
+#include <perf/header.h>
+#include <perf/parse-events.h>
+
+#include <util/parse-options.h>
+#include <util/cache.h>
+
+#include "thread.h"
+#include "sort.h"
+
+extern regex_t parent_regex;
+extern const char *sort_order;
+extern const char default_parent_pattern[];
+extern const char *parent_pattern;
+extern const char default_sort_order[];
+extern int sort__need_collapse;
+extern int sort__has_parent;
+extern char *field_sep;
+extern struct sort_entry sort_comm;
+extern struct sort_entry sort_dso;
+extern struct sort_entry sort_sym;
+extern struct sort_entry sort_parent;
+extern unsigned int dsos__col_width;
+extern unsigned int comms__col_width;
+extern unsigned int threads__col_width;
+extern unsigned int cpus__col_width;
+extern enum sort_type sort__first_dimension;
+
+struct hist_entry {
+	struct rb_node		rb_node;
+	u64			period;
+	u64			period_sys;
+	u64			period_us;
+	u64			period_guest_sys;
+	u64			period_guest_us;
+	struct map_symbol	ms;
+	struct thread		*thread;
+	u64			ip;
+	s32			cpu;
+	u32			nr_events;
+	char			level;
+	u8			filtered;
+	struct symbol		*parent;
+	union {
+		unsigned long	  position;
+		struct hist_entry *pair;
+		struct rb_root	  sorted_chain;
+	};
+	struct callchain_node	callchain[0];
+};
+
+enum sort_type {
+	SORT_PID,
+	SORT_COMM,
+	SORT_DSO,
+	SORT_SYM,
+	SORT_PARENT,
+	SORT_CPU,
+};
+
+/*
+ * configurable sorting bits
+ */
+
+struct sort_entry {
+	struct list_head list;
+
+	const char *se_header;
+
+	int64_t (*se_cmp)(struct hist_entry *, struct hist_entry *);
+	int64_t (*se_collapse)(struct hist_entry *, struct hist_entry *);
+	int	(*se_snprintf)(struct hist_entry *self, char *bf, size_t size,
+			       unsigned int width);
+	unsigned int *se_width;
+	bool	elide;
+};
+
+extern struct sort_entry sort_thread;
+extern struct list_head hist_entry__sort_list;
+
+void setup_sorting(const char * const usagestr[], const struct option *opts);
+
+extern size_t sort__thread_print(FILE *, struct hist_entry *, unsigned int);
+extern size_t sort__comm_print(FILE *, struct hist_entry *, unsigned int);
+extern size_t sort__dso_print(FILE *, struct hist_entry *, unsigned int);
+extern size_t sort__sym_print(FILE *, struct hist_entry *, unsigned int __used);
+extern int64_t cmp_null(void *, void *);
+extern int64_t sort__thread_cmp(struct hist_entry *, struct hist_entry *);
+extern int64_t sort__comm_cmp(struct hist_entry *, struct hist_entry *);
+extern int64_t sort__comm_collapse(struct hist_entry *, struct hist_entry *);
+extern int64_t sort__dso_cmp(struct hist_entry *, struct hist_entry *);
+extern int64_t sort__sym_cmp(struct hist_entry *, struct hist_entry *);
+extern int64_t sort__parent_cmp(struct hist_entry *, struct hist_entry *);
+int64_t sort__cpu_cmp(struct hist_entry *left, struct hist_entry *right);
+extern size_t sort__parent_print(FILE *, struct hist_entry *, unsigned int);
+extern int sort_dimension__add(const char *);
+void sort_entry__setup_elide(struct sort_entry *self, struct strlist *list,
+			     const char *list_name, FILE *fp);
+
+#endif	/* __PERF_SORT_H */
diff --git a/tools/lib/perf/symbol.c b/tools/lib/perf/symbol.c
index 04593d2..dddbeab 100644
--- a/tools/lib/perf/symbol.c
+++ b/tools/lib/perf/symbol.c
@@ -11,7 +11,7 @@
 #include <sys/param.h>
 #include <fcntl.h>
 #include <unistd.h>
-#include <util/build-id.h>
+#include "build-id.h"
 #include "symbol.h"
 #include <lk/strlist.h>
 #include <libelf.h>
diff --git a/tools/lib/perf/thread.c b/tools/lib/perf/thread.c
new file mode 100644
index 0000000..1f9793d
--- /dev/null
+++ b/tools/lib/perf/thread.c
@@ -0,0 +1,164 @@
+#include <perf.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <perf/session.h>
+#include "thread.h"
+#include <lk/util.h>
+#include <lk/debug.h>
+
+int find_all_tid(int pid, pid_t ** all_tid)
+{
+	char name[256];
+	int items;
+	struct dirent **namelist = NULL;
+	int ret = 0;
+	int i;
+
+	sprintf(name, "/proc/%d/task", pid);
+	items = scandir(name, &namelist, NULL, NULL);
+	if (items <= 0)
+                return -ENOENT;
+	*all_tid = malloc(sizeof(pid_t) * items);
+	if (!*all_tid) {
+		ret = -ENOMEM;
+		goto failure;
+	}
+
+	for (i = 0; i < items; i++)
+		(*all_tid)[i] = atoi(namelist[i]->d_name);
+
+	ret = items;
+
+failure:
+	for (i=0; i<items; i++)
+		free(namelist[i]);
+	free(namelist);
+
+	return ret;
+}
+
+static struct thread *thread__new(pid_t pid)
+{
+	struct thread *self = zalloc(sizeof(*self));
+
+	if (self != NULL) {
+		map_groups__init(&self->mg);
+		self->pid = pid;
+		self->comm = malloc(32);
+		if (self->comm)
+			snprintf(self->comm, 32, ":%d", self->pid);
+	}
+
+	return self;
+}
+
+int thread__set_comm(struct thread *self, const char *comm)
+{
+	int err;
+
+	if (self->comm)
+		free(self->comm);
+	self->comm = strdup(comm);
+	err = self->comm == NULL ? -ENOMEM : 0;
+	if (!err) {
+		self->comm_set = true;
+		map_groups__flush(&self->mg);
+	}
+	return err;
+}
+
+int thread__comm_len(struct thread *self)
+{
+	if (!self->comm_len) {
+		if (!self->comm)
+			return 0;
+		self->comm_len = strlen(self->comm);
+	}
+
+	return self->comm_len;
+}
+
+static size_t thread__fprintf(struct thread *self, FILE *fp)
+{
+	return fprintf(fp, "Thread %d %s\n", self->pid, self->comm) +
+	       map_groups__fprintf(&self->mg, verbose, fp);
+}
+
+struct thread *perf_session__findnew(struct perf_session *self, pid_t pid)
+{
+	struct rb_node **p = &self->threads.rb_node;
+	struct rb_node *parent = NULL;
+	struct thread *th;
+
+	/*
+	 * Font-end cache - PID lookups come in blocks,
+	 * so most of the time we dont have to look up
+	 * the full rbtree:
+	 */
+	if (self->last_match && self->last_match->pid == pid)
+		return self->last_match;
+
+	while (*p != NULL) {
+		parent = *p;
+		th = rb_entry(parent, struct thread, rb_node);
+
+		if (th->pid == pid) {
+			self->last_match = th;
+			return th;
+		}
+
+		if (pid < th->pid)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	th = thread__new(pid);
+	if (th != NULL) {
+		rb_link_node(&th->rb_node, parent, p);
+		rb_insert_color(&th->rb_node, &self->threads);
+		self->last_match = th;
+	}
+
+	return th;
+}
+
+void thread__insert_map(struct thread *self, struct map *map)
+{
+	map_groups__fixup_overlappings(&self->mg, map, verbose, stderr);
+	map_groups__insert(&self->mg, map);
+}
+
+int thread__fork(struct thread *self, struct thread *parent)
+{
+	int i;
+
+	if (parent->comm_set) {
+		if (self->comm)
+			free(self->comm);
+		self->comm = strdup(parent->comm);
+		if (!self->comm)
+			return -ENOMEM;
+		self->comm_set = true;
+	}
+
+	for (i = 0; i < MAP__NR_TYPES; ++i)
+		if (map_groups__clone(&self->mg, &parent->mg, i) < 0)
+			return -ENOMEM;
+	return 0;
+}
+
+size_t perf_session__fprintf(struct perf_session *self, FILE *fp)
+{
+	size_t ret = 0;
+	struct rb_node *nd;
+
+	for (nd = rb_first(&self->threads); nd; nd = rb_next(nd)) {
+		struct thread *pos = rb_entry(nd, struct thread, rb_node);
+
+		ret += thread__fprintf(pos, fp);
+	}
+
+	return ret;
+}
diff --git a/tools/lib/perf/thread.h b/tools/lib/perf/thread.h
new file mode 100644
index 0000000..93baaea
--- /dev/null
+++ b/tools/lib/perf/thread.h
@@ -0,0 +1,44 @@
+#ifndef __PERF_THREAD_H
+#define __PERF_THREAD_H
+
+#include <linux/rbtree.h>
+#include <unistd.h>
+#include <perf/symbol.h>
+
+struct thread {
+	struct rb_node		rb_node;
+	struct map_groups	mg;
+	pid_t			pid;
+	char			shortname[3];
+	bool			comm_set;
+	char			*comm;
+	int			comm_len;
+};
+
+struct perf_session;
+
+int find_all_tid(int pid, pid_t ** all_tid);
+int thread__set_comm(struct thread *self, const char *comm);
+int thread__comm_len(struct thread *self);
+struct thread *perf_session__findnew(struct perf_session *self, pid_t pid);
+void thread__insert_map(struct thread *self, struct map *map);
+int thread__fork(struct thread *self, struct thread *parent);
+size_t perf_session__fprintf(struct perf_session *self, FILE *fp);
+
+static inline struct map *thread__find_map(struct thread *self,
+					   enum map_type type, u64 addr)
+{
+	return self ? map_groups__find(&self->mg, type, addr) : NULL;
+}
+
+void thread__find_addr_map(struct thread *self,
+			   struct perf_session *session, u8 cpumode,
+			   enum map_type type, pid_t pid, u64 addr,
+			   struct addr_location *al);
+
+void thread__find_addr_location(struct thread *self,
+				struct perf_session *session, u8 cpumode,
+				enum map_type type, pid_t pid, u64 addr,
+				struct addr_location *al,
+				symbol_filter_t filter);
+#endif	/* __PERF_THREAD_H */
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 653802b..001831e 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -354,8 +354,6 @@ LIB_H += util/include/dwarf-regs.h
 LIB_H += perf.h
 LIB_H += util/cache.h
 LIB_H += util/callchain.h
-LIB_H += util/build-id.h
-LIB_H += util/event.h
 LIB_H += util/exec_cmd.h
 LIB_H += util/levenshtein.h
 LIB_H += util/parse-options.h
@@ -365,9 +363,6 @@ LIB_H += util/svghelper.h
 LIB_H += util/run-command.h
 LIB_H += util/sigchain.h
 LIB_H += util/values.h
-LIB_H += util/sort.h
-LIB_H += util/hist.h
-LIB_H += util/thread.h
 LIB_H += util/trace-event.h
 LIB_H += util/probe-finder.h
 LIB_H += util/probe-event.h
@@ -375,9 +370,7 @@ LIB_H += util/config.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
-LIB_OBJS += $(OUTPUT)util/build-id.o
 LIB_OBJS += $(OUTPUT)util/environment.o
-LIB_OBJS += $(OUTPUT)util/event.o
 LIB_OBJS += $(OUTPUT)util/exec_cmd.o
 LIB_OBJS += $(OUTPUT)util/help.o
 LIB_OBJS += $(OUTPUT)util/levenshtein.o
@@ -390,14 +383,11 @@ LIB_OBJS += $(OUTPUT)util/sigchain.o
 LIB_OBJS += $(OUTPUT)util/pager.o
 LIB_OBJS += $(OUTPUT)util/callchain.o
 LIB_OBJS += $(OUTPUT)util/values.o
-LIB_OBJS += $(OUTPUT)util/thread.o
 LIB_OBJS += $(OUTPUT)util/trace-event-parse.o
 LIB_OBJS += $(OUTPUT)util/trace-event-read.o
 LIB_OBJS += $(OUTPUT)util/trace-event-info.o
 LIB_OBJS += $(OUTPUT)util/trace-event-scripting.o
 LIB_OBJS += $(OUTPUT)util/svghelper.o
-LIB_OBJS += $(OUTPUT)util/sort.o
-LIB_OBJS += $(OUTPUT)util/hist.o
 LIB_OBJS += $(OUTPUT)util/probe-event.o
 LIB_OBJS += $(OUTPUT)util/config.o
 
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 1c78b75..29753d1 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -18,12 +18,12 @@
 #include "perf.h"
 #include <lk/debug.h>
 
-#include "util/event.h"
+#include <perf/event.h>
 #include "util/parse-options.h"
 #include <perf/parse-events.h>
-#include "util/thread.h"
-#include "util/sort.h"
-#include "util/hist.h"
+#include <perf/thread.h>
+#include <perf/sort.h>
+#include <perf/hist.h>
 #include <perf/session.h>
 
 static char		const *input_name = "perf.data";
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 8cfc4d3..5e3253a 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -8,7 +8,7 @@
  */
 #include "builtin.h"
 #include "perf.h"
-#include "util/build-id.h"
+#include <perf/build-id.h>
 #include "util/cache.h"
 #include <lk/debug.h>
 #include "util/parse-options.h"
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 2d406dd..9615c36 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -7,10 +7,10 @@
 #include "builtin.h"
 
 #include <lk/debug.h>
-#include "util/event.h"
-#include "util/hist.h"
+#include <perf/event.h>
+#include <perf/hist.h>
 #include <perf/session.h>
-#include "util/sort.h"
+#include <perf/sort.h>
 #include <perf/symbol.h>
 #include <lk/util.h>
 
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 3129210..32476b9 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -4,7 +4,7 @@
 #include <lk/util.h>
 #include "util/cache.h"
 #include <perf/symbol.h>
-#include "util/thread.h"
+#include <perf/thread.h>
 #include <perf/header.h>
 #include <perf/session.h>
 
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 509d11f..10a8c4d 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -4,7 +4,7 @@
 #include <lk/util.h>
 #include "util/cache.h"
 #include <perf/symbol.h>
-#include "util/thread.h"
+#include <perf/thread.h>
 #include <perf/header.h>
 #include <perf/session.h>
 
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 17abce4..8ded0a7 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -4,7 +4,7 @@
 #include <lk/util.h>
 #include "util/cache.h"
 #include <perf/symbol.h>
-#include "util/thread.h"
+#include <perf/thread.h>
 #include <perf/header.h>
 
 #include "util/parse-options.h"
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index e78efad..6072b83 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -11,13 +11,13 @@
 
 #include "perf.h"
 
-#include "util/build-id.h"
+#include <perf/build-id.h>
 #include <lk/util.h>
 #include "util/parse-options.h"
 #include <perf/parse-events.h>
 
 #include <perf/header.h>
-#include "util/event.h"
+#include <perf/event.h>
 #include <lk/debug.h>
 #include <perf/session.h>
 #include <perf/symbol.h>
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 98284d1..0803898 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -26,9 +26,9 @@
 #include "util/parse-options.h"
 #include <perf/parse-events.h>
 
-#include "util/thread.h"
-#include "util/sort.h"
-#include "util/hist.h"
+#include <perf/thread.h>
+#include <perf/sort.h>
+#include <perf/hist.h>
 
 static char		const *input_name = "perf.data";
 
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 24dabdc..6df3cb3 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -4,7 +4,7 @@
 #include <lk/util.h>
 #include "util/cache.h"
 #include <perf/symbol.h>
-#include "util/thread.h"
+#include <perf/thread.h>
 #include <perf/header.h>
 #include <perf/session.h>
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 56c47bc..e1186c0 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -42,11 +42,11 @@
 #include <lk/util.h>
 #include "util/parse-options.h"
 #include <perf/parse-events.h>
-#include "util/event.h"
+#include <perf/event.h>
 #include <lk/debug.h>
 #include <perf/header.h>
 #include <lk/cpumap.h>
-#include "util/thread.h"
+#include <perf/thread.h>
 
 #include <sys/prctl.h>
 #include <math.h>
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index f5d6686..0028015 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -10,7 +10,7 @@
 #include "util/parse-options.h"
 #include <perf/session.h>
 #include <perf/symbol.h>
-#include "util/thread.h"
+#include <perf/thread.h>
 
 static long page_size;
 
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index eddeeae..71dd659 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -28,7 +28,7 @@
 #include <perf/header.h>
 #include "util/parse-options.h"
 #include <perf/parse-events.h>
-#include "util/event.h"
+#include <perf/event.h>
 #include <perf/session.h>
 #include "util/svghelper.h"
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 8edc974..866ba3d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -23,7 +23,7 @@
 #include <lk/color.h>
 #include <perf/session.h>
 #include <perf/symbol.h>
-#include "util/thread.h"
+#include <perf/thread.h>
 #include <lk/util.h>
 #include <linux/rbtree.h>
 #include "util/parse-options.h"
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 1edffa4..585af2e 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -4,7 +4,7 @@
 #include <lk/debug.h>
 #include "util/cache.h"
 #include <perf/symbol.h>
-#include "util/thread.h"
+#include <perf/thread.h>
 #include <perf/header.h>
 #include "util/exec_cmd.h"
 #include "util/trace-event.h"
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 4d57b28..4268ed4 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -12,7 +12,7 @@
 #include "util/cache.h"
 #include "util/config.h"
 #include "util/quote.h"
-#include "util/build-id.h"
+#include <perf/build-id.h>
 #include "util/run-command.h"
 #include <perf/parse-events.h>
 #include <lk/debugfs.h>
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
deleted file mode 100644
index 5969758..0000000
--- a/tools/perf/util/build-id.c
+++ /dev/null
@@ -1,111 +0,0 @@
-/*
- * build-id.c
- *
- * build-id support
- *
- * Copyright (C) 2009, 2010 Red Hat Inc.
- * Copyright (C) 2009, 2010 Arnaldo Carvalho de Melo <acme@redhat.com>
- */
-#include <lk/util.h>
-#include <lk/debug.h>
-#include <lk/config.h>
-#include <lk/strbuf.h>
-#include <stdio.h>
-#include "build-id.h"
-#include "event.h"
-#include <perf/symbol.h>
-#include <linux/kernel.h>
-
-static int build_id__mark_dso_hit(event_t *event, struct perf_session *session)
-{
-	struct addr_location al;
-	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	struct thread *thread = perf_session__findnew(session, event->ip.pid);
-
-	if (thread == NULL) {
-		pr_err("problem processing %d event, skipping it.\n",
-			event->header.type);
-		return -1;
-	}
-
-	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
-			      event->ip.pid, event->ip.ip, &al);
-
-	if (al.map != NULL)
-		al.map->dso->hit = 1;
-
-	return 0;
-}
-
-struct perf_event_ops build_id__mark_dso_hit_ops = {
-	.sample	= build_id__mark_dso_hit,
-	.mmap	= event__process_mmap,
-	.fork	= event__process_task,
-};
-
-char *dso__build_id_filename(struct dso *self, char *bf, size_t size)
-{
-	char build_id_hex[BUILD_ID_SIZE * 2 + 1];
-
-	if (!self->has_build_id)
-		return NULL;
-
-	build_id__sprintf(self->build_id, sizeof(self->build_id), build_id_hex);
-	if (bf == NULL) {
-		if (asprintf(&bf, "%s/.build-id/%.2s/%s", buildid_dir,
-			     build_id_hex, build_id_hex + 2) < 0)
-			return NULL;
-	} else
-		snprintf(bf, size, "%s/.build-id/%.2s/%s", buildid_dir,
-			 build_id_hex, build_id_hex + 2);
-	return bf;
-}
-
-struct buildid_dir_config {
-	char *dir;
-};
-
-static int buildid_dir_command_config(const char *var, const char *value,
-				      void *data)
-{
-	struct buildid_dir_config *c = data;
-	const char *v;
-
-	/* same dir for all commands */
-	if (!prefixcmp(var, "buildid.") && !strcmp(var + 8, "dir")) {
-		v = lk_config_dirname(var, value);
-		if (!v)
-			return -1;
-		strncpy(c->dir, v, MAXPATHLEN-1);
-		c->dir[MAXPATHLEN-1] = '\0';
-	}
-	return 0;
-}
-static void check_buildid_dir_config(void)
-{
-	struct buildid_dir_config c;
-	c.dir = buildid_dir;
-	perf_config(buildid_dir_command_config, &c);
-}
-
-void set_buildid_dir(void)
-{
-	buildid_dir[0] = '\0';
-
-	/* try config file */
-	check_buildid_dir_config();
-
-	/* default to $HOME/.debug */
-	if (buildid_dir[0] == '\0') {
-		char *v = getenv("HOME");
-		if (v) {
-			snprintf(buildid_dir, MAXPATHLEN-1, "%s/%s",
-				 v, DEBUG_CACHE_DIR);
-		} else {
-			strncpy(buildid_dir, DEBUG_CACHE_DIR, MAXPATHLEN-1);
-		}
-		buildid_dir[MAXPATHLEN-1] = '\0';
-	}
-	/* for communicating with external commands */
-	setenv("PERF_BUILDID_DIR", buildid_dir, 1);
-}
diff --git a/tools/perf/util/build-id.h b/tools/perf/util/build-id.h
deleted file mode 100644
index a8a6bd9..0000000
--- a/tools/perf/util/build-id.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef PERF_BUILD_ID_H_
-#define PERF_BUILD_ID_H_ 1
-
-#include <perf/session.h>
-#include "config.h"
-
-extern struct perf_event_ops build_id__mark_dso_hit_ops;
-
-char *dso__build_id_filename(struct dso *self, char *bf, size_t size);
-extern void set_buildid_dir(void);
-
-#endif
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index dcc0254..6de3448 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -19,13 +19,6 @@
 #include <lk/debug.h>
 #include "callchain.h"
 
-bool ip_callchain__valid(struct ip_callchain *chain, const event_t *event)
-{
-	unsigned int chain_size = event->header.size;
-	chain_size -= (unsigned long)&event->ip.__more_data - (unsigned long)event;
-	return chain->nr * sizeof(u64) <= chain_size;
-}
-
 #define chain_for_each_child(child, parent)	\
 	list_for_each_entry(child, &parent->children, brothers)
 
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index ca8a73d..13176e6 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -4,7 +4,7 @@
 #include "../perf.h"
 #include <linux/list.h>
 #include <linux/rbtree.h>
-#include "event.h"
+#include <perf/event.h>
 #include <perf/symbol.h>
 
 enum chain_mode {
@@ -60,5 +60,4 @@ int register_callchain_param(struct callchain_param *param);
 int append_chain(struct callchain_node *root, struct ip_callchain *chain,
 		 struct map_symbol *syms);
 
-bool ip_callchain__valid(struct ip_callchain *chain, const event_t *event);
 #endif	/* __PERF_CALLCHAIN_H */
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
deleted file mode 100644
index 1669fcc..0000000
--- a/tools/perf/util/event.c
+++ /dev/null
@@ -1,820 +0,0 @@
-#include <linux/types.h>
-#include "event.h"
-#include <lk/debug.h>
-#include <perf/session.h>
-#include "sort.h"
-#include "string.h"
-#include <lk/strlist.h>
-#include "thread.h"
-
-const char *event__name[] = {
-	[0]			 = "TOTAL",
-	[PERF_RECORD_MMAP]	 = "MMAP",
-	[PERF_RECORD_LOST]	 = "LOST",
-	[PERF_RECORD_COMM]	 = "COMM",
-	[PERF_RECORD_EXIT]	 = "EXIT",
-	[PERF_RECORD_THROTTLE]	 = "THROTTLE",
-	[PERF_RECORD_UNTHROTTLE] = "UNTHROTTLE",
-	[PERF_RECORD_FORK]	 = "FORK",
-	[PERF_RECORD_READ]	 = "READ",
-	[PERF_RECORD_SAMPLE]	 = "SAMPLE",
-	[PERF_RECORD_HEADER_ATTR]	 = "ATTR",
-	[PERF_RECORD_HEADER_EVENT_TYPE]	 = "EVENT_TYPE",
-	[PERF_RECORD_HEADER_TRACING_DATA]	 = "TRACING_DATA",
-	[PERF_RECORD_HEADER_BUILD_ID]	 = "BUILD_ID",
-};
-
-static pid_t event__synthesize_comm(pid_t pid, int full,
-				    event__handler_t process,
-				    struct perf_session *session)
-{
-	event_t ev;
-	char filename[PATH_MAX];
-	char bf[BUFSIZ];
-	FILE *fp;
-	size_t size = 0;
-	DIR *tasks;
-	struct dirent dirent, *next;
-	pid_t tgid = 0;
-
-	snprintf(filename, sizeof(filename), "/proc/%d/status", pid);
-
-	fp = fopen(filename, "r");
-	if (fp == NULL) {
-out_race:
-		/*
-		 * We raced with a task exiting - just return:
-		 */
-		pr_debug("couldn't open %s\n", filename);
-		return 0;
-	}
-
-	memset(&ev.comm, 0, sizeof(ev.comm));
-	while (!ev.comm.comm[0] || !ev.comm.pid) {
-		if (fgets(bf, sizeof(bf), fp) == NULL)
-			goto out_failure;
-
-		if (memcmp(bf, "Name:", 5) == 0) {
-			char *name = bf + 5;
-			while (*name && isspace(*name))
-				++name;
-			size = strlen(name) - 1;
-			memcpy(ev.comm.comm, name, size++);
-		} else if (memcmp(bf, "Tgid:", 5) == 0) {
-			char *tgids = bf + 5;
-			while (*tgids && isspace(*tgids))
-				++tgids;
-			tgid = ev.comm.pid = atoi(tgids);
-		}
-	}
-
-	ev.comm.header.type = PERF_RECORD_COMM;
-	size = ALIGN(size, sizeof(u64));
-	ev.comm.header.size = sizeof(ev.comm) - (sizeof(ev.comm.comm) - size);
-
-	if (!full) {
-		ev.comm.tid = pid;
-
-		process(&ev, session);
-		goto out_fclose;
-	}
-
-	snprintf(filename, sizeof(filename), "/proc/%d/task", pid);
-
-	tasks = opendir(filename);
-	if (tasks == NULL)
-		goto out_race;
-
-	while (!readdir_r(tasks, &dirent, &next) && next) {
-		char *end;
-		pid = strtol(dirent.d_name, &end, 10);
-		if (*end)
-			continue;
-
-		ev.comm.tid = pid;
-
-		process(&ev, session);
-	}
-	closedir(tasks);
-
-out_fclose:
-	fclose(fp);
-	return tgid;
-
-out_failure:
-	pr_warning("couldn't get COMM and pgid, malformed %s\n", filename);
-	return -1;
-}
-
-static int event__synthesize_mmap_events(pid_t pid, pid_t tgid,
-					 event__handler_t process,
-					 struct perf_session *session)
-{
-	char filename[PATH_MAX];
-	FILE *fp;
-
-	snprintf(filename, sizeof(filename), "/proc/%d/maps", pid);
-
-	fp = fopen(filename, "r");
-	if (fp == NULL) {
-		/*
-		 * We raced with a task exiting - just return:
-		 */
-		pr_debug("couldn't open %s\n", filename);
-		return -1;
-	}
-
-	while (1) {
-		char bf[BUFSIZ], *pbf = bf;
-		event_t ev = {
-			.header = {
-				.type = PERF_RECORD_MMAP,
-				/*
-				 * Just like the kernel, see __perf_event_mmap
-				 * in kernel/perf_event.c
-				 */
-				.misc = PERF_RECORD_MISC_USER,
-			 },
-		};
-		int n;
-		size_t size;
-		if (fgets(bf, sizeof(bf), fp) == NULL)
-			break;
-
-		/* 00400000-0040c000 r-xp 00000000 fd:01 41038  /bin/cat */
-		n = hex2u64(pbf, &ev.mmap.start);
-		if (n < 0)
-			continue;
-		pbf += n + 1;
-		n = hex2u64(pbf, &ev.mmap.len);
-		if (n < 0)
-			continue;
-		pbf += n + 3;
-		if (*pbf == 'x') { /* vm_exec */
-			u64 vm_pgoff;
-			char *execname = strchr(bf, '/');
-
-			/* Catch VDSO */
-			if (execname == NULL)
-				execname = strstr(bf, "[vdso]");
-
-			if (execname == NULL)
-				continue;
-
-			pbf += 3;
-			n = hex2u64(pbf, &vm_pgoff);
-			/* pgoff is in bytes, not pages */
-			if (n >= 0)
-				ev.mmap.pgoff = vm_pgoff << getpagesize();
-			else
-				ev.mmap.pgoff = 0;
-
-			size = strlen(execname);
-			execname[size - 1] = '\0'; /* Remove \n */
-			memcpy(ev.mmap.filename, execname, size);
-			size = ALIGN(size, sizeof(u64));
-			ev.mmap.len -= ev.mmap.start;
-			ev.mmap.header.size = (sizeof(ev.mmap) -
-					       (sizeof(ev.mmap.filename) - size));
-			ev.mmap.pid = tgid;
-			ev.mmap.tid = pid;
-
-			process(&ev, session);
-		}
-	}
-
-	fclose(fp);
-	return 0;
-}
-
-int event__synthesize_modules(event__handler_t process,
-			      struct perf_session *session,
-			      struct machine *machine)
-{
-	struct rb_node *nd;
-	struct map_groups *kmaps = &machine->kmaps;
-	u16 misc;
-
-	/*
-	 * kernel uses 0 for user space maps, see kernel/perf_event.c
-	 * __perf_event_mmap
-	 */
-	if (machine__is_host(machine))
-		misc = PERF_RECORD_MISC_KERNEL;
-	else
-		misc = PERF_RECORD_MISC_GUEST_KERNEL;
-
-	for (nd = rb_first(&kmaps->maps[MAP__FUNCTION]);
-	     nd; nd = rb_next(nd)) {
-		event_t ev;
-		size_t size;
-		struct map *pos = rb_entry(nd, struct map, rb_node);
-
-		if (pos->dso->kernel)
-			continue;
-
-		size = ALIGN(pos->dso->long_name_len + 1, sizeof(u64));
-		memset(&ev, 0, sizeof(ev));
-		ev.mmap.header.misc = misc;
-		ev.mmap.header.type = PERF_RECORD_MMAP;
-		ev.mmap.header.size = (sizeof(ev.mmap) -
-				        (sizeof(ev.mmap.filename) - size));
-		ev.mmap.start = pos->start;
-		ev.mmap.len   = pos->end - pos->start;
-		ev.mmap.pid   = machine->pid;
-
-		memcpy(ev.mmap.filename, pos->dso->long_name,
-		       pos->dso->long_name_len + 1);
-		process(&ev, session);
-	}
-
-	return 0;
-}
-
-int event__synthesize_thread(pid_t pid, event__handler_t process,
-			     struct perf_session *session)
-{
-	pid_t tgid = event__synthesize_comm(pid, 1, process, session);
-	if (tgid == -1)
-		return -1;
-	return event__synthesize_mmap_events(pid, tgid, process, session);
-}
-
-void event__synthesize_threads(event__handler_t process,
-			       struct perf_session *session)
-{
-	DIR *proc;
-	struct dirent dirent, *next;
-
-	proc = opendir("/proc");
-
-	while (!readdir_r(proc, &dirent, &next) && next) {
-		char *end;
-		pid_t pid = strtol(dirent.d_name, &end, 10);
-
-		if (*end) /* only interested in proper numerical dirents */
-			continue;
-
-		event__synthesize_thread(pid, process, session);
-	}
-
-	closedir(proc);
-}
-
-struct process_symbol_args {
-	const char *name;
-	u64	   start;
-};
-
-static int find_symbol_cb(void *arg, const char *name, char type, u64 start)
-{
-	struct process_symbol_args *args = arg;
-
-	/*
-	 * Must be a function or at least an alias, as in PARISC64, where "_text" is
-	 * an 'A' to the same address as "_stext".
-	 */
-	if (!(symbol_type__is_a(type, MAP__FUNCTION) ||
-	      type == 'A') || strcmp(name, args->name))
-		return 0;
-
-	args->start = start;
-	return 1;
-}
-
-int event__synthesize_kernel_mmap(event__handler_t process,
-				  struct perf_session *session,
-				  struct machine *machine,
-				  const char *symbol_name)
-{
-	size_t size;
-	const char *filename, *mmap_name;
-	char path[PATH_MAX];
-	char name_buff[PATH_MAX];
-	struct map *map;
-
-	event_t ev = {
-		.header = {
-			.type = PERF_RECORD_MMAP,
-		},
-	};
-	/*
-	 * We should get this from /sys/kernel/sections/.text, but till that is
-	 * available use this, and after it is use this as a fallback for older
-	 * kernels.
-	 */
-	struct process_symbol_args args = { .name = symbol_name, };
-
-	mmap_name = machine__mmap_name(machine, name_buff, sizeof(name_buff));
-	if (machine__is_host(machine)) {
-		/*
-		 * kernel uses PERF_RECORD_MISC_USER for user space maps,
-		 * see kernel/perf_event.c __perf_event_mmap
-		 */
-		ev.header.misc = PERF_RECORD_MISC_KERNEL;
-		filename = "/proc/kallsyms";
-	} else {
-		ev.header.misc = PERF_RECORD_MISC_GUEST_KERNEL;
-		if (machine__is_default_guest(machine))
-			filename = (char *) symbol_conf.default_guest_kallsyms;
-		else {
-			sprintf(path, "%s/proc/kallsyms", machine->root_dir);
-			filename = path;
-		}
-	}
-
-	if (kallsyms__parse(filename, &args, find_symbol_cb) <= 0)
-		return -ENOENT;
-
-	map = machine->vmlinux_maps[MAP__FUNCTION];
-	size = snprintf(ev.mmap.filename, sizeof(ev.mmap.filename),
-			"%s%s", mmap_name, symbol_name) + 1;
-	size = ALIGN(size, sizeof(u64));
-	ev.mmap.header.size = (sizeof(ev.mmap) -
-			(sizeof(ev.mmap.filename) - size));
-	ev.mmap.pgoff = args.start;
-	ev.mmap.start = map->start;
-	ev.mmap.len   = map->end - ev.mmap.start;
-	ev.mmap.pid   = machine->pid;
-
-	return process(&ev, session);
-}
-
-static void thread__comm_adjust(struct thread *self)
-{
-	char *comm = self->comm;
-
-	if (!symbol_conf.col_width_list_str && !symbol_conf.field_sep &&
-	    (!symbol_conf.comm_list ||
-	     strlist__has_entry(symbol_conf.comm_list, comm))) {
-		unsigned int slen = strlen(comm);
-
-		if (slen > comms__col_width) {
-			comms__col_width = slen;
-			threads__col_width = slen + 6;
-		}
-	}
-}
-
-static int thread__set_comm_adjust(struct thread *self, const char *comm)
-{
-	int ret = thread__set_comm(self, comm);
-
-	if (ret)
-		return ret;
-
-	thread__comm_adjust(self);
-
-	return 0;
-}
-
-int event__process_comm(event_t *self, struct perf_session *session)
-{
-	struct thread *thread = perf_session__findnew(session, self->comm.tid);
-
-	dump_printf(": %s:%d\n", self->comm.comm, self->comm.tid);
-
-	if (thread == NULL || thread__set_comm_adjust(thread, self->comm.comm)) {
-		dump_printf("problem processing PERF_RECORD_COMM, skipping event.\n");
-		return -1;
-	}
-
-	return 0;
-}
-
-int event__process_lost(event_t *self, struct perf_session *session)
-{
-	dump_printf(": id:%Ld: lost:%Ld\n", self->lost.id, self->lost.lost);
-	session->hists.stats.total_lost += self->lost.lost;
-	return 0;
-}
-
-static void event_set_kernel_mmap_len(struct map **maps, event_t *self)
-{
-	maps[MAP__FUNCTION]->start = self->mmap.start;
-	maps[MAP__FUNCTION]->end   = self->mmap.start + self->mmap.len;
-	/*
-	 * Be a bit paranoid here, some perf.data file came with
-	 * a zero sized synthesized MMAP event for the kernel.
-	 */
-	if (maps[MAP__FUNCTION]->end == 0)
-		maps[MAP__FUNCTION]->end = ~0UL;
-}
-
-static int event__process_kernel_mmap(event_t *self,
-			struct perf_session *session)
-{
-	struct map *map;
-	char kmmap_prefix[PATH_MAX];
-	struct machine *machine;
-	enum dso_kernel_type kernel_type;
-	bool is_kernel_mmap;
-
-	machine = perf_session__findnew_machine(session, self->mmap.pid);
-	if (!machine) {
-		pr_err("Can't find id %d's machine\n", self->mmap.pid);
-		goto out_problem;
-	}
-
-	machine__mmap_name(machine, kmmap_prefix, sizeof(kmmap_prefix));
-	if (machine__is_host(machine))
-		kernel_type = DSO_TYPE_KERNEL;
-	else
-		kernel_type = DSO_TYPE_GUEST_KERNEL;
-
-	is_kernel_mmap = memcmp(self->mmap.filename,
-				kmmap_prefix,
-				strlen(kmmap_prefix)) == 0;
-	if (self->mmap.filename[0] == '/' ||
-	    (!is_kernel_mmap && self->mmap.filename[0] == '[')) {
-
-		char short_module_name[1024];
-		char *name, *dot;
-
-		if (self->mmap.filename[0] == '/') {
-			name = strrchr(self->mmap.filename, '/');
-			if (name == NULL)
-				goto out_problem;
-
-			++name; /* skip / */
-			dot = strrchr(name, '.');
-			if (dot == NULL)
-				goto out_problem;
-			snprintf(short_module_name, sizeof(short_module_name),
-					"[%.*s]", (int)(dot - name), name);
-			strxfrchar(short_module_name, '-', '_');
-		} else
-			strcpy(short_module_name, self->mmap.filename);
-
-		map = machine__new_module(machine, self->mmap.start,
-					  self->mmap.filename);
-		if (map == NULL)
-			goto out_problem;
-
-		name = strdup(short_module_name);
-		if (name == NULL)
-			goto out_problem;
-
-		map->dso->short_name = name;
-		map->end = map->start + self->mmap.len;
-	} else if (is_kernel_mmap) {
-		const char *symbol_name = (self->mmap.filename +
-				strlen(kmmap_prefix));
-		/*
-		 * Should be there already, from the build-id table in
-		 * the header.
-		 */
-		struct dso *kernel = __dsos__findnew(&machine->kernel_dsos,
-						     kmmap_prefix);
-		if (kernel == NULL)
-			goto out_problem;
-
-		kernel->kernel = kernel_type;
-		if (__machine__create_kernel_maps(machine, kernel) < 0)
-			goto out_problem;
-
-		event_set_kernel_mmap_len(machine->vmlinux_maps, self);
-		perf_session__set_kallsyms_ref_reloc_sym(machine->vmlinux_maps,
-							 symbol_name,
-							 self->mmap.pgoff);
-		if (machine__is_default_guest(machine)) {
-			/*
-			 * preload dso of guest kernel and modules
-			 */
-			dso__load(kernel, machine->vmlinux_maps[MAP__FUNCTION],
-				  NULL);
-		}
-	}
-	return 0;
-out_problem:
-	return -1;
-}
-
-int event__process_mmap(event_t *self, struct perf_session *session)
-{
-	struct machine *machine;
-	struct thread *thread;
-	struct map *map;
-	u8 cpumode = self->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	int ret = 0;
-
-	dump_printf(" %d/%d: [%#Lx(%#Lx) @ %#Lx]: %s\n",
-			self->mmap.pid, self->mmap.tid, self->mmap.start,
-			self->mmap.len, self->mmap.pgoff, self->mmap.filename);
-
-	if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL ||
-	    cpumode == PERF_RECORD_MISC_KERNEL) {
-		ret = event__process_kernel_mmap(self, session);
-		if (ret < 0)
-			goto out_problem;
-		return 0;
-	}
-
-	machine = perf_session__find_host_machine(session);
-	if (machine == NULL)
-		goto out_problem;
-	thread = perf_session__findnew(session, self->mmap.pid);
-	map = map__new(&machine->user_dsos, self->mmap.start,
-			self->mmap.len, self->mmap.pgoff,
-			self->mmap.pid, self->mmap.filename,
-			MAP__FUNCTION, session->cwd, session->cwdlen);
-
-	if (thread == NULL || map == NULL)
-		goto out_problem;
-
-	thread__insert_map(thread, map);
-	return 0;
-
-out_problem:
-	dump_printf("problem processing PERF_RECORD_MMAP, skipping event.\n");
-	return 0;
-}
-
-int event__process_task(event_t *self, struct perf_session *session)
-{
-	struct thread *thread = perf_session__findnew(session, self->fork.tid);
-	struct thread *parent = perf_session__findnew(session, self->fork.ptid);
-
-	dump_printf("(%d:%d):(%d:%d)\n", self->fork.pid, self->fork.tid,
-		    self->fork.ppid, self->fork.ptid);
-
-	if (self->header.type == PERF_RECORD_EXIT)
-		return 0;
-
-	if (thread == NULL || parent == NULL ||
-	    thread__fork(thread, parent) < 0) {
-		dump_printf("problem processing PERF_RECORD_FORK, skipping event.\n");
-		return -1;
-	}
-
-	return 0;
-}
-
-void thread__find_addr_map(struct thread *self,
-			   struct perf_session *session, u8 cpumode,
-			   enum map_type type, pid_t pid, u64 addr,
-			   struct addr_location *al)
-{
-	struct map_groups *mg = &self->mg;
-	struct machine *machine = NULL;
-
-	al->thread = self;
-	al->addr = addr;
-	al->cpumode = cpumode;
-	al->filtered = false;
-
-	if (cpumode == PERF_RECORD_MISC_KERNEL && perf_host) {
-		al->level = 'k';
-		machine = perf_session__find_host_machine(session);
-		if (machine == NULL) {
-			al->map = NULL;
-			return;
-		}
-		mg = &machine->kmaps;
-	} else if (cpumode == PERF_RECORD_MISC_USER && perf_host) {
-		al->level = '.';
-		machine = perf_session__find_host_machine(session);
-	} else if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL && perf_guest) {
-		al->level = 'g';
-		machine = perf_session__find_machine(session, pid);
-		if (machine == NULL) {
-			al->map = NULL;
-			return;
-		}
-		mg = &machine->kmaps;
-	} else {
-		/*
-		 * 'u' means guest os user space.
-		 * TODO: We don't support guest user space. Might support late.
-		 */
-		if (cpumode == PERF_RECORD_MISC_GUEST_USER && perf_guest)
-			al->level = 'u';
-		else
-			al->level = 'H';
-		al->map = NULL;
-
-		if ((cpumode == PERF_RECORD_MISC_GUEST_USER ||
-			cpumode == PERF_RECORD_MISC_GUEST_KERNEL) &&
-			!perf_guest)
-			al->filtered = true;
-		if ((cpumode == PERF_RECORD_MISC_USER ||
-			cpumode == PERF_RECORD_MISC_KERNEL) &&
-			!perf_host)
-			al->filtered = true;
-
-		return;
-	}
-try_again:
-	al->map = map_groups__find(mg, type, al->addr);
-	if (al->map == NULL) {
-		/*
-		 * If this is outside of all known maps, and is a negative
-		 * address, try to look it up in the kernel dso, as it might be
-		 * a vsyscall or vdso (which executes in user-mode).
-		 *
-		 * XXX This is nasty, we should have a symbol list in the
-		 * "[vdso]" dso, but for now lets use the old trick of looking
-		 * in the whole kernel symbol list.
-		 */
-		if ((long long)al->addr < 0 &&
-		    cpumode == PERF_RECORD_MISC_KERNEL &&
-		    machine && mg != &machine->kmaps) {
-			mg = &machine->kmaps;
-			goto try_again;
-		}
-	} else
-		al->addr = al->map->map_ip(al->map, al->addr);
-}
-
-void thread__find_addr_location(struct thread *self,
-				struct perf_session *session, u8 cpumode,
-				enum map_type type, pid_t pid, u64 addr,
-				struct addr_location *al,
-				symbol_filter_t filter)
-{
-	thread__find_addr_map(self, session, cpumode, type, pid, addr, al);
-	if (al->map != NULL)
-		al->sym = map__find_symbol(al->map, al->addr, filter);
-	else
-		al->sym = NULL;
-}
-
-static void dso__calc_col_width(struct dso *self)
-{
-	if (!symbol_conf.col_width_list_str && !symbol_conf.field_sep &&
-	    (!symbol_conf.dso_list ||
-	     strlist__has_entry(symbol_conf.dso_list, self->name))) {
-		u16 slen = self->short_name_len;
-		if (verbose)
-			slen = self->long_name_len;
-		if (dsos__col_width < slen)
-			dsos__col_width = slen;
-	}
-
-	self->slen_calculated = 1;
-}
-
-int event__preprocess_sample(const event_t *self, struct perf_session *session,
-			     struct addr_location *al, struct sample_data *data,
-			     symbol_filter_t filter)
-{
-	u8 cpumode = self->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	struct thread *thread;
-
-	event__parse_sample(self, session->sample_type, data);
-
-	dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld cpu:%d\n",
-		    self->header.misc, data->pid, data->tid, data->ip,
-		    data->period, data->cpu);
-
-	if (session->sample_type & PERF_SAMPLE_CALLCHAIN) {
-		unsigned int i;
-
-		dump_printf("... chain: nr:%Lu\n", data->callchain->nr);
-
-		if (!ip_callchain__valid(data->callchain, self)) {
-			pr_debug("call-chain problem with event, "
-				 "skipping it.\n");
-			goto out_filtered;
-		}
-
-		if (dump_trace) {
-			for (i = 0; i < data->callchain->nr; i++)
-				dump_printf("..... %2d: %016Lx\n",
-					    i, data->callchain->ips[i]);
-		}
-	}
-	thread = perf_session__findnew(session, self->ip.pid);
-	if (thread == NULL)
-		return -1;
-
-	if (symbol_conf.comm_list &&
-	    !strlist__has_entry(symbol_conf.comm_list, thread->comm))
-		goto out_filtered;
-
-	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
-	/*
-	 * Have we already created the kernel maps for the host machine?
-	 *
-	 * This should have happened earlier, when we processed the kernel MMAP
-	 * events, but for older perf.data files there was no such thing, so do
-	 * it now.
-	 */
-	if (cpumode == PERF_RECORD_MISC_KERNEL &&
-	    session->host_machine.vmlinux_maps[MAP__FUNCTION] == NULL)
-		machine__create_kernel_maps(&session->host_machine);
-
-	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
-			      self->ip.pid, self->ip.ip, al);
-	dump_printf(" ...... dso: %s\n",
-		    al->map ? al->map->dso->long_name :
-			al->level == 'H' ? "[hypervisor]" : "<not found>");
-	al->sym = NULL;
-	al->cpu = data->cpu;
-
-	if (al->map) {
-		if (symbol_conf.dso_list &&
-		    (!al->map || !al->map->dso ||
-		     !(strlist__has_entry(symbol_conf.dso_list,
-					  al->map->dso->short_name) ||
-		       (al->map->dso->short_name != al->map->dso->long_name &&
-			strlist__has_entry(symbol_conf.dso_list,
-					   al->map->dso->long_name)))))
-			goto out_filtered;
-		/*
-		 * We have to do this here as we may have a dso with no symbol
-		 * hit that has a name longer than the ones with symbols
-		 * sampled.
-		 */
-		if (!sort_dso.elide && !al->map->dso->slen_calculated)
-			dso__calc_col_width(al->map->dso);
-
-		al->sym = map__find_symbol(al->map, al->addr, filter);
-	} else {
-		const unsigned int unresolved_col_width = BITS_PER_LONG / 4;
-
-		if (dsos__col_width < unresolved_col_width &&
-		    !symbol_conf.col_width_list_str && !symbol_conf.field_sep &&
-		    !symbol_conf.dso_list)
-			dsos__col_width = unresolved_col_width;
-	}
-
-	if (symbol_conf.sym_list && al->sym &&
-	    !strlist__has_entry(symbol_conf.sym_list, al->sym->name))
-		goto out_filtered;
-
-	return 0;
-
-out_filtered:
-	al->filtered = true;
-	return 0;
-}
-
-int event__parse_sample(const event_t *event, u64 type, struct sample_data *data)
-{
-	const u64 *array = event->sample.array;
-
-	if (type & PERF_SAMPLE_IP) {
-		data->ip = event->ip.ip;
-		array++;
-	}
-
-	if (type & PERF_SAMPLE_TID) {
-		u32 *p = (u32 *)array;
-		data->pid = p[0];
-		data->tid = p[1];
-		array++;
-	}
-
-	if (type & PERF_SAMPLE_TIME) {
-		data->time = *array;
-		array++;
-	}
-
-	if (type & PERF_SAMPLE_ADDR) {
-		data->addr = *array;
-		array++;
-	}
-
-	data->id = -1ULL;
-	if (type & PERF_SAMPLE_ID) {
-		data->id = *array;
-		array++;
-	}
-
-	if (type & PERF_SAMPLE_STREAM_ID) {
-		data->stream_id = *array;
-		array++;
-	}
-
-	if (type & PERF_SAMPLE_CPU) {
-		u32 *p = (u32 *)array;
-		data->cpu = *p;
-		array++;
-	} else
-		data->cpu = -1;
-
-	if (type & PERF_SAMPLE_PERIOD) {
-		data->period = *array;
-		array++;
-	}
-
-	if (type & PERF_SAMPLE_READ) {
-		pr_debug("PERF_SAMPLE_READ is unsuported for now\n");
-		return -1;
-	}
-
-	if (type & PERF_SAMPLE_CALLCHAIN) {
-		data->callchain = (struct ip_callchain *)array;
-		array += 1 + data->callchain->nr;
-	}
-
-	if (type & PERF_SAMPLE_RAW) {
-		u32 *p = (u32 *)array;
-		data->raw_size = *p;
-		p++;
-		data->raw_data = p;
-	}
-
-	return 0;
-}
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
deleted file mode 100644
index fef5236..0000000
--- a/tools/perf/util/event.h
+++ /dev/null
@@ -1,166 +0,0 @@
-#ifndef __PERF_RECORD_H
-#define __PERF_RECORD_H
-
-#include <limits.h>
-
-#include "../perf.h"
-#include <perf/map.h>
-
-/*
- * PERF_SAMPLE_IP | PERF_SAMPLE_TID | *
- */
-struct ip_event {
-	struct perf_event_header header;
-	u64 ip;
-	u32 pid, tid;
-	unsigned char __more_data[];
-};
-
-struct mmap_event {
-	struct perf_event_header header;
-	u32 pid, tid;
-	u64 start;
-	u64 len;
-	u64 pgoff;
-	char filename[PATH_MAX];
-};
-
-struct comm_event {
-	struct perf_event_header header;
-	u32 pid, tid;
-	char comm[16];
-};
-
-struct fork_event {
-	struct perf_event_header header;
-	u32 pid, ppid;
-	u32 tid, ptid;
-	u64 time;
-};
-
-struct lost_event {
-	struct perf_event_header header;
-	u64 id;
-	u64 lost;
-};
-
-/*
- * PERF_FORMAT_ENABLED | PERF_FORMAT_RUNNING | PERF_FORMAT_ID
- */
-struct read_event {
-	struct perf_event_header header;
-	u32 pid, tid;
-	u64 value;
-	u64 time_enabled;
-	u64 time_running;
-	u64 id;
-};
-
-struct sample_event {
-	struct perf_event_header        header;
-	u64 array[];
-};
-
-struct sample_data {
-	u64 ip;
-	u32 pid, tid;
-	u64 time;
-	u64 addr;
-	u64 id;
-	u64 stream_id;
-	u64 period;
-	u32 cpu;
-	u32 raw_size;
-	void *raw_data;
-	struct ip_callchain *callchain;
-};
-
-#define BUILD_ID_SIZE 20
-
-struct build_id_event {
-	struct perf_event_header header;
-	pid_t			 pid;
-	u8			 build_id[ALIGN(BUILD_ID_SIZE, sizeof(u64))];
-	char			 filename[];
-};
-
-enum perf_user_event_type { /* above any possible kernel type */
-	PERF_RECORD_HEADER_ATTR			= 64,
-	PERF_RECORD_HEADER_EVENT_TYPE		= 65,
-	PERF_RECORD_HEADER_TRACING_DATA		= 66,
-	PERF_RECORD_HEADER_BUILD_ID		= 67,
-	PERF_RECORD_FINISHED_ROUND		= 68,
-	PERF_RECORD_HEADER_MAX
-};
-
-struct attr_event {
-	struct perf_event_header header;
-	struct perf_event_attr attr;
-	u64 id[];
-};
-
-#define MAX_EVENT_NAME 64
-
-struct perf_trace_event_type {
-	u64	event_id;
-	char	name[MAX_EVENT_NAME];
-};
-
-struct event_type_event {
-	struct perf_event_header header;
-	struct perf_trace_event_type event_type;
-};
-
-struct tracing_data_event {
-	struct perf_event_header header;
-	u32 size;
-};
-
-typedef union event_union {
-	struct perf_event_header	header;
-	struct ip_event			ip;
-	struct mmap_event		mmap;
-	struct comm_event		comm;
-	struct fork_event		fork;
-	struct lost_event		lost;
-	struct read_event		read;
-	struct sample_event		sample;
-	struct attr_event		attr;
-	struct event_type_event		event_type;
-	struct tracing_data_event	tracing_data;
-	struct build_id_event		build_id;
-} event_t;
-
-void event__print_totals(void);
-
-struct perf_session;
-
-typedef int (*event__handler_t)(event_t *event, struct perf_session *session);
-
-int event__synthesize_thread(pid_t pid, event__handler_t process,
-			     struct perf_session *session);
-void event__synthesize_threads(event__handler_t process,
-			       struct perf_session *session);
-int event__synthesize_kernel_mmap(event__handler_t process,
-				struct perf_session *session,
-				struct machine *machine,
-				const char *symbol_name);
-
-int event__synthesize_modules(event__handler_t process,
-			      struct perf_session *session,
-			      struct machine *machine);
-
-int event__process_comm(event_t *self, struct perf_session *session);
-int event__process_lost(event_t *self, struct perf_session *session);
-int event__process_mmap(event_t *self, struct perf_session *session);
-int event__process_task(event_t *self, struct perf_session *session);
-
-struct addr_location;
-int event__preprocess_sample(const event_t *self, struct perf_session *session,
-			     struct addr_location *al, struct sample_data *data,
-			     symbol_filter_t filter);
-int event__parse_sample(const event_t *event, u64 type, struct sample_data *data);
-
-extern const char *event__name[];
-
-#endif /* __PERF_RECORD_H */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
deleted file mode 100644
index 2dfa141..0000000
--- a/tools/perf/util/hist.c
+++ /dev/null
@@ -1,1082 +0,0 @@
-#include <lk/util.h>
-#include "build-id.h"
-#include "hist.h"
-#include <perf/session.h>
-#include "sort.h"
-#include <math.h>
-
-struct callchain_param	callchain_param = {
-	.mode	= CHAIN_GRAPH_REL,
-	.min_percent = 0.5
-};
-
-static void hist_entry__add_cpumode_period(struct hist_entry *self,
-					   unsigned int cpumode, u64 period)
-{
-	switch (cpumode) {
-	case PERF_RECORD_MISC_KERNEL:
-		self->period_sys += period;
-		break;
-	case PERF_RECORD_MISC_USER:
-		self->period_us += period;
-		break;
-	case PERF_RECORD_MISC_GUEST_KERNEL:
-		self->period_guest_sys += period;
-		break;
-	case PERF_RECORD_MISC_GUEST_USER:
-		self->period_guest_us += period;
-		break;
-	default:
-		break;
-	}
-}
-
-/*
- * histogram, sorted on item, collects periods
- */
-
-static struct hist_entry *hist_entry__new(struct hist_entry *template)
-{
-	size_t callchain_size = symbol_conf.use_callchain ? sizeof(struct callchain_node) : 0;
-	struct hist_entry *self = malloc(sizeof(*self) + callchain_size);
-
-	if (self != NULL) {
-		*self = *template;
-		self->nr_events = 1;
-		if (symbol_conf.use_callchain)
-			callchain_init(self->callchain);
-	}
-
-	return self;
-}
-
-static void hists__inc_nr_entries(struct hists *self, struct hist_entry *entry)
-{
-	if (entry->ms.sym && self->max_sym_namelen < entry->ms.sym->namelen)
-		self->max_sym_namelen = entry->ms.sym->namelen;
-	++self->nr_entries;
-}
-
-struct hist_entry *__hists__add_entry(struct hists *self,
-				      struct addr_location *al,
-				      struct symbol *sym_parent, u64 period)
-{
-	struct rb_node **p = &self->entries.rb_node;
-	struct rb_node *parent = NULL;
-	struct hist_entry *he;
-	struct hist_entry entry = {
-		.thread	= al->thread,
-		.ms = {
-			.map	= al->map,
-			.sym	= al->sym,
-		},
-		.cpu	= al->cpu,
-		.ip	= al->addr,
-		.level	= al->level,
-		.period	= period,
-		.parent = sym_parent,
-	};
-	int cmp;
-
-	while (*p != NULL) {
-		parent = *p;
-		he = rb_entry(parent, struct hist_entry, rb_node);
-
-		cmp = hist_entry__cmp(&entry, he);
-
-		if (!cmp) {
-			he->period += period;
-			++he->nr_events;
-			goto out;
-		}
-
-		if (cmp < 0)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-
-	he = hist_entry__new(&entry);
-	if (!he)
-		return NULL;
-	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, &self->entries);
-	hists__inc_nr_entries(self, he);
-out:
-	hist_entry__add_cpumode_period(he, al->cpumode, period);
-	return he;
-}
-
-int64_t
-hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
-{
-	struct sort_entry *se;
-	int64_t cmp = 0;
-
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		cmp = se->se_cmp(left, right);
-		if (cmp)
-			break;
-	}
-
-	return cmp;
-}
-
-int64_t
-hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
-{
-	struct sort_entry *se;
-	int64_t cmp = 0;
-
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		int64_t (*f)(struct hist_entry *, struct hist_entry *);
-
-		f = se->se_collapse ?: se->se_cmp;
-
-		cmp = f(left, right);
-		if (cmp)
-			break;
-	}
-
-	return cmp;
-}
-
-void hist_entry__free(struct hist_entry *he)
-{
-	free(he);
-}
-
-/*
- * collapse the histogram
- */
-
-static bool collapse__insert_entry(struct rb_root *root, struct hist_entry *he)
-{
-	struct rb_node **p = &root->rb_node;
-	struct rb_node *parent = NULL;
-	struct hist_entry *iter;
-	int64_t cmp;
-
-	while (*p != NULL) {
-		parent = *p;
-		iter = rb_entry(parent, struct hist_entry, rb_node);
-
-		cmp = hist_entry__collapse(iter, he);
-
-		if (!cmp) {
-			iter->period += he->period;
-			hist_entry__free(he);
-			return false;
-		}
-
-		if (cmp < 0)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-
-	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, root);
-	return true;
-}
-
-void hists__collapse_resort(struct hists *self)
-{
-	struct rb_root tmp;
-	struct rb_node *next;
-	struct hist_entry *n;
-
-	if (!sort__need_collapse)
-		return;
-
-	tmp = RB_ROOT;
-	next = rb_first(&self->entries);
-	self->nr_entries = 0;
-	self->max_sym_namelen = 0;
-
-	while (next) {
-		n = rb_entry(next, struct hist_entry, rb_node);
-		next = rb_next(&n->rb_node);
-
-		rb_erase(&n->rb_node, &self->entries);
-		if (collapse__insert_entry(&tmp, n))
-			hists__inc_nr_entries(self, n);
-	}
-
-	self->entries = tmp;
-}
-
-/*
- * reverse the map, sort on period.
- */
-
-static void __hists__insert_output_entry(struct rb_root *entries,
-					 struct hist_entry *he,
-					 u64 min_callchain_hits)
-{
-	struct rb_node **p = &entries->rb_node;
-	struct rb_node *parent = NULL;
-	struct hist_entry *iter;
-
-	if (symbol_conf.use_callchain)
-		callchain_param.sort(&he->sorted_chain, he->callchain,
-				      min_callchain_hits, &callchain_param);
-
-	while (*p != NULL) {
-		parent = *p;
-		iter = rb_entry(parent, struct hist_entry, rb_node);
-
-		if (he->period > iter->period)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-
-	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, entries);
-}
-
-void hists__output_resort(struct hists *self)
-{
-	struct rb_root tmp;
-	struct rb_node *next;
-	struct hist_entry *n;
-	u64 min_callchain_hits;
-
-	min_callchain_hits = self->stats.total_period * (callchain_param.min_percent / 100);
-
-	tmp = RB_ROOT;
-	next = rb_first(&self->entries);
-
-	self->nr_entries = 0;
-	self->max_sym_namelen = 0;
-
-	while (next) {
-		n = rb_entry(next, struct hist_entry, rb_node);
-		next = rb_next(&n->rb_node);
-
-		rb_erase(&n->rb_node, &self->entries);
-		__hists__insert_output_entry(&tmp, n, min_callchain_hits);
-		hists__inc_nr_entries(self, n);
-	}
-
-	self->entries = tmp;
-}
-
-static size_t callchain__fprintf_left_margin(FILE *fp, int left_margin)
-{
-	int i;
-	int ret = fprintf(fp, "            ");
-
-	for (i = 0; i < left_margin; i++)
-		ret += fprintf(fp, " ");
-
-	return ret;
-}
-
-static size_t ipchain__fprintf_graph_line(FILE *fp, int depth, int depth_mask,
-					  int left_margin)
-{
-	int i;
-	size_t ret = callchain__fprintf_left_margin(fp, left_margin);
-
-	for (i = 0; i < depth; i++)
-		if (depth_mask & (1 << i))
-			ret += fprintf(fp, "|          ");
-		else
-			ret += fprintf(fp, "           ");
-
-	ret += fprintf(fp, "\n");
-
-	return ret;
-}
-
-static size_t ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain,
-				     int depth, int depth_mask, int period,
-				     u64 total_samples, int hits,
-				     int left_margin)
-{
-	int i;
-	size_t ret = 0;
-
-	ret += callchain__fprintf_left_margin(fp, left_margin);
-	for (i = 0; i < depth; i++) {
-		if (depth_mask & (1 << i))
-			ret += fprintf(fp, "|");
-		else
-			ret += fprintf(fp, " ");
-		if (!period && i == depth - 1) {
-			double percent;
-
-			percent = hits * 100.0 / total_samples;
-			ret += percent_color_fprintf(fp, "--%2.2f%%-- ", percent);
-		} else
-			ret += fprintf(fp, "%s", "          ");
-	}
-	if (chain->ms.sym)
-		ret += fprintf(fp, "%s\n", chain->ms.sym->name);
-	else
-		ret += fprintf(fp, "%p\n", (void *)(long)chain->ip);
-
-	return ret;
-}
-
-static struct symbol *rem_sq_bracket;
-static struct callchain_list rem_hits;
-
-static void init_rem_hits(void)
-{
-	rem_sq_bracket = malloc(sizeof(*rem_sq_bracket) + 6);
-	if (!rem_sq_bracket) {
-		fprintf(stderr, "Not enough memory to display remaining hits\n");
-		return;
-	}
-
-	strcpy(rem_sq_bracket->name, "[...]");
-	rem_hits.ms.sym = rem_sq_bracket;
-}
-
-static size_t __callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
-					 u64 total_samples, int depth,
-					 int depth_mask, int left_margin)
-{
-	struct rb_node *node, *next;
-	struct callchain_node *child;
-	struct callchain_list *chain;
-	int new_depth_mask = depth_mask;
-	u64 new_total;
-	u64 remaining;
-	size_t ret = 0;
-	int i;
-	uint entries_printed = 0;
-
-	if (callchain_param.mode == CHAIN_GRAPH_REL)
-		new_total = self->children_hit;
-	else
-		new_total = total_samples;
-
-	remaining = new_total;
-
-	node = rb_first(&self->rb_root);
-	while (node) {
-		u64 cumul;
-
-		child = rb_entry(node, struct callchain_node, rb_node);
-		cumul = cumul_hits(child);
-		remaining -= cumul;
-
-		/*
-		 * The depth mask manages the output of pipes that show
-		 * the depth. We don't want to keep the pipes of the current
-		 * level for the last child of this depth.
-		 * Except if we have remaining filtered hits. They will
-		 * supersede the last child
-		 */
-		next = rb_next(node);
-		if (!next && (callchain_param.mode != CHAIN_GRAPH_REL || !remaining))
-			new_depth_mask &= ~(1 << (depth - 1));
-
-		/*
-		 * But we keep the older depth mask for the line separator
-		 * to keep the level link until we reach the last child
-		 */
-		ret += ipchain__fprintf_graph_line(fp, depth, depth_mask,
-						   left_margin);
-		i = 0;
-		list_for_each_entry(chain, &child->val, list) {
-			ret += ipchain__fprintf_graph(fp, chain, depth,
-						      new_depth_mask, i++,
-						      new_total,
-						      cumul,
-						      left_margin);
-		}
-		ret += __callchain__fprintf_graph(fp, child, new_total,
-						  depth + 1,
-						  new_depth_mask | (1 << depth),
-						  left_margin);
-		node = next;
-		if (++entries_printed == callchain_param.print_limit)
-			break;
-	}
-
-	if (callchain_param.mode == CHAIN_GRAPH_REL &&
-		remaining && remaining != new_total) {
-
-		if (!rem_sq_bracket)
-			return ret;
-
-		new_depth_mask &= ~(1 << (depth - 1));
-
-		ret += ipchain__fprintf_graph(fp, &rem_hits, depth,
-					      new_depth_mask, 0, new_total,
-					      remaining, left_margin);
-	}
-
-	return ret;
-}
-
-static size_t callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
-				       u64 total_samples, int left_margin)
-{
-	struct callchain_list *chain;
-	bool printed = false;
-	int i = 0;
-	int ret = 0;
-	u32 entries_printed = 0;
-
-	list_for_each_entry(chain, &self->val, list) {
-		if (!i++ && sort__first_dimension == SORT_SYM)
-			continue;
-
-		if (!printed) {
-			ret += callchain__fprintf_left_margin(fp, left_margin);
-			ret += fprintf(fp, "|\n");
-			ret += callchain__fprintf_left_margin(fp, left_margin);
-			ret += fprintf(fp, "---");
-
-			left_margin += 3;
-			printed = true;
-		} else
-			ret += callchain__fprintf_left_margin(fp, left_margin);
-
-		if (chain->ms.sym)
-			ret += fprintf(fp, " %s\n", chain->ms.sym->name);
-		else
-			ret += fprintf(fp, " %p\n", (void *)(long)chain->ip);
-
-		if (++entries_printed == callchain_param.print_limit)
-			break;
-	}
-
-	ret += __callchain__fprintf_graph(fp, self, total_samples, 1, 1, left_margin);
-
-	return ret;
-}
-
-static size_t callchain__fprintf_flat(FILE *fp, struct callchain_node *self,
-				      u64 total_samples)
-{
-	struct callchain_list *chain;
-	size_t ret = 0;
-
-	if (!self)
-		return 0;
-
-	ret += callchain__fprintf_flat(fp, self->parent, total_samples);
-
-
-	list_for_each_entry(chain, &self->val, list) {
-		if (chain->ip >= PERF_CONTEXT_MAX)
-			continue;
-		if (chain->ms.sym)
-			ret += fprintf(fp, "                %s\n", chain->ms.sym->name);
-		else
-			ret += fprintf(fp, "                %p\n",
-					(void *)(long)chain->ip);
-	}
-
-	return ret;
-}
-
-static size_t hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
-					    u64 total_samples, int left_margin)
-{
-	struct rb_node *rb_node;
-	struct callchain_node *chain;
-	size_t ret = 0;
-	u32 entries_printed = 0;
-
-	rb_node = rb_first(&self->sorted_chain);
-	while (rb_node) {
-		double percent;
-
-		chain = rb_entry(rb_node, struct callchain_node, rb_node);
-		percent = chain->hit * 100.0 / total_samples;
-		switch (callchain_param.mode) {
-		case CHAIN_FLAT:
-			ret += percent_color_fprintf(fp, "           %6.2f%%\n",
-						     percent);
-			ret += callchain__fprintf_flat(fp, chain, total_samples);
-			break;
-		case CHAIN_GRAPH_ABS: /* Falldown */
-		case CHAIN_GRAPH_REL:
-			ret += callchain__fprintf_graph(fp, chain, total_samples,
-							left_margin);
-		case CHAIN_NONE:
-		default:
-			break;
-		}
-		ret += fprintf(fp, "\n");
-		if (++entries_printed == callchain_param.print_limit)
-			break;
-		rb_node = rb_next(rb_node);
-	}
-
-	return ret;
-}
-
-int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
-			 struct hists *pair_hists, bool show_displacement,
-			 long displacement, bool color, u64 session_total)
-{
-	struct sort_entry *se;
-	u64 period, total, period_sys, period_us, period_guest_sys, period_guest_us;
-	const char *sep = symbol_conf.field_sep;
-	int ret;
-
-	if (symbol_conf.exclude_other && !self->parent)
-		return 0;
-
-	if (pair_hists) {
-		period = self->pair ? self->pair->period : 0;
-		total = pair_hists->stats.total_period;
-		period_sys = self->pair ? self->pair->period_sys : 0;
-		period_us = self->pair ? self->pair->period_us : 0;
-		period_guest_sys = self->pair ? self->pair->period_guest_sys : 0;
-		period_guest_us = self->pair ? self->pair->period_guest_us : 0;
-	} else {
-		period = self->period;
-		total = session_total;
-		period_sys = self->period_sys;
-		period_us = self->period_us;
-		period_guest_sys = self->period_guest_sys;
-		period_guest_us = self->period_guest_us;
-	}
-
-	if (total) {
-		if (color)
-			ret = percent_color_snprintf(s, size,
-						     sep ? "%.2f" : "   %6.2f%%",
-						     (period * 100.0) / total);
-		else
-			ret = snprintf(s, size, sep ? "%.2f" : "   %6.2f%%",
-				       (period * 100.0) / total);
-		if (symbol_conf.show_cpu_utilization) {
-			ret += percent_color_snprintf(s + ret, size - ret,
-					sep ? "%.2f" : "   %6.2f%%",
-					(period_sys * 100.0) / total);
-			ret += percent_color_snprintf(s + ret, size - ret,
-					sep ? "%.2f" : "   %6.2f%%",
-					(period_us * 100.0) / total);
-			if (perf_guest) {
-				ret += percent_color_snprintf(s + ret,
-						size - ret,
-						sep ? "%.2f" : "   %6.2f%%",
-						(period_guest_sys * 100.0) /
-								total);
-				ret += percent_color_snprintf(s + ret,
-						size - ret,
-						sep ? "%.2f" : "   %6.2f%%",
-						(period_guest_us * 100.0) /
-								total);
-			}
-		}
-	} else
-		ret = snprintf(s, size, sep ? "%lld" : "%12lld ", period);
-
-	if (symbol_conf.show_nr_samples) {
-		if (sep)
-			ret += snprintf(s + ret, size - ret, "%c%lld", *sep, period);
-		else
-			ret += snprintf(s + ret, size - ret, "%11lld", period);
-	}
-
-	if (pair_hists) {
-		char bf[32];
-		double old_percent = 0, new_percent = 0, diff;
-
-		if (total > 0)
-			old_percent = (period * 100.0) / total;
-		if (session_total > 0)
-			new_percent = (self->period * 100.0) / session_total;
-
-		diff = new_percent - old_percent;
-
-		if (fabs(diff) >= 0.01)
-			snprintf(bf, sizeof(bf), "%+4.2F%%", diff);
-		else
-			snprintf(bf, sizeof(bf), " ");
-
-		if (sep)
-			ret += snprintf(s + ret, size - ret, "%c%s", *sep, bf);
-		else
-			ret += snprintf(s + ret, size - ret, "%11.11s", bf);
-
-		if (show_displacement) {
-			if (displacement)
-				snprintf(bf, sizeof(bf), "%+4ld", displacement);
-			else
-				snprintf(bf, sizeof(bf), " ");
-
-			if (sep)
-				ret += snprintf(s + ret, size - ret, "%c%s", *sep, bf);
-			else
-				ret += snprintf(s + ret, size - ret, "%6.6s", bf);
-		}
-	}
-
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		if (se->elide)
-			continue;
-
-		ret += snprintf(s + ret, size - ret, "%s", sep ?: "  ");
-		ret += se->se_snprintf(self, s + ret, size - ret,
-				       se->se_width ? *se->se_width : 0);
-	}
-
-	return ret;
-}
-
-int hist_entry__fprintf(struct hist_entry *self, struct hists *pair_hists,
-			bool show_displacement, long displacement, FILE *fp,
-			u64 session_total)
-{
-	char bf[512];
-	hist_entry__snprintf(self, bf, sizeof(bf), pair_hists,
-			     show_displacement, displacement,
-			     true, session_total);
-	return fprintf(fp, "%s\n", bf);
-}
-
-static size_t hist_entry__fprintf_callchain(struct hist_entry *self, FILE *fp,
-					    u64 session_total)
-{
-	int left_margin = 0;
-
-	if (sort__first_dimension == SORT_COMM) {
-		struct sort_entry *se = list_first_entry(&hist_entry__sort_list,
-							 typeof(*se), list);
-		left_margin = se->se_width ? *se->se_width : 0;
-		left_margin -= thread__comm_len(self->thread);
-	}
-
-	return hist_entry_callchain__fprintf(fp, self, session_total,
-					     left_margin);
-}
-
-size_t hists__fprintf(struct hists *self, struct hists *pair,
-		      bool show_displacement, FILE *fp)
-{
-	struct sort_entry *se;
-	struct rb_node *nd;
-	size_t ret = 0;
-	unsigned long position = 1;
-	long displacement = 0;
-	unsigned int width;
-	const char *sep = symbol_conf.field_sep;
-	const char *col_width = symbol_conf.col_width_list_str;
-
-	init_rem_hits();
-
-	fprintf(fp, "# %s", pair ? "Baseline" : "Overhead");
-
-	if (symbol_conf.show_nr_samples) {
-		if (sep)
-			fprintf(fp, "%cSamples", *sep);
-		else
-			fputs("  Samples  ", fp);
-	}
-
-	if (symbol_conf.show_cpu_utilization) {
-		if (sep) {
-			ret += fprintf(fp, "%csys", *sep);
-			ret += fprintf(fp, "%cus", *sep);
-			if (perf_guest) {
-				ret += fprintf(fp, "%cguest sys", *sep);
-				ret += fprintf(fp, "%cguest us", *sep);
-			}
-		} else {
-			ret += fprintf(fp, "  sys  ");
-			ret += fprintf(fp, "  us  ");
-			if (perf_guest) {
-				ret += fprintf(fp, "  guest sys  ");
-				ret += fprintf(fp, "  guest us  ");
-			}
-		}
-	}
-
-	if (pair) {
-		if (sep)
-			ret += fprintf(fp, "%cDelta", *sep);
-		else
-			ret += fprintf(fp, "  Delta    ");
-
-		if (show_displacement) {
-			if (sep)
-				ret += fprintf(fp, "%cDisplacement", *sep);
-			else
-				ret += fprintf(fp, " Displ");
-		}
-	}
-
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		if (se->elide)
-			continue;
-		if (sep) {
-			fprintf(fp, "%c%s", *sep, se->se_header);
-			continue;
-		}
-		width = strlen(se->se_header);
-		if (se->se_width) {
-			if (symbol_conf.col_width_list_str) {
-				if (col_width) {
-					*se->se_width = atoi(col_width);
-					col_width = strchr(col_width, ',');
-					if (col_width)
-						++col_width;
-				}
-			}
-			width = *se->se_width = max(*se->se_width, width);
-		}
-		fprintf(fp, "  %*s", width, se->se_header);
-	}
-	fprintf(fp, "\n");
-
-	if (sep)
-		goto print_entries;
-
-	fprintf(fp, "# ........");
-	if (symbol_conf.show_nr_samples)
-		fprintf(fp, " ..........");
-	if (pair) {
-		fprintf(fp, " ..........");
-		if (show_displacement)
-			fprintf(fp, " .....");
-	}
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		unsigned int i;
-
-		if (se->elide)
-			continue;
-
-		fprintf(fp, "  ");
-		if (se->se_width)
-			width = *se->se_width;
-		else
-			width = strlen(se->se_header);
-		for (i = 0; i < width; i++)
-			fprintf(fp, ".");
-	}
-
-	fprintf(fp, "\n#\n");
-
-print_entries:
-	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
-		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-
-		if (show_displacement) {
-			if (h->pair != NULL)
-				displacement = ((long)h->pair->position -
-					        (long)position);
-			else
-				displacement = 0;
-			++position;
-		}
-		ret += hist_entry__fprintf(h, pair, show_displacement,
-					   displacement, fp, self->stats.total_period);
-
-		if (symbol_conf.use_callchain)
-			ret += hist_entry__fprintf_callchain(h, fp, self->stats.total_period);
-
-		if (h->ms.map == NULL && verbose > 1) {
-			__map_groups__fprintf_maps(&h->thread->mg,
-						   MAP__FUNCTION, verbose, fp);
-			fprintf(fp, "%.10s end\n", graph_dotted_line);
-		}
-	}
-
-	free(rem_sq_bracket);
-
-	return ret;
-}
-
-enum hist_filter {
-	HIST_FILTER__DSO,
-	HIST_FILTER__THREAD,
-};
-
-void hists__filter_by_dso(struct hists *self, const struct dso *dso)
-{
-	struct rb_node *nd;
-
-	self->nr_entries = self->stats.total_period = 0;
-	self->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
-	self->max_sym_namelen = 0;
-
-	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
-		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-
-		if (symbol_conf.exclude_other && !h->parent)
-			continue;
-
-		if (dso != NULL && (h->ms.map == NULL || h->ms.map->dso != dso)) {
-			h->filtered |= (1 << HIST_FILTER__DSO);
-			continue;
-		}
-
-		h->filtered &= ~(1 << HIST_FILTER__DSO);
-		if (!h->filtered) {
-			++self->nr_entries;
-			self->stats.total_period += h->period;
-			self->stats.nr_events[PERF_RECORD_SAMPLE] += h->nr_events;
-			if (h->ms.sym &&
-			    self->max_sym_namelen < h->ms.sym->namelen)
-				self->max_sym_namelen = h->ms.sym->namelen;
-		}
-	}
-}
-
-void hists__filter_by_thread(struct hists *self, const struct thread *thread)
-{
-	struct rb_node *nd;
-
-	self->nr_entries = self->stats.total_period = 0;
-	self->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
-	self->max_sym_namelen = 0;
-
-	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
-		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-
-		if (thread != NULL && h->thread != thread) {
-			h->filtered |= (1 << HIST_FILTER__THREAD);
-			continue;
-		}
-		h->filtered &= ~(1 << HIST_FILTER__THREAD);
-		if (!h->filtered) {
-			++self->nr_entries;
-			self->stats.total_period += h->period;
-			self->stats.nr_events[PERF_RECORD_SAMPLE] += h->nr_events;
-			if (h->ms.sym &&
-			    self->max_sym_namelen < h->ms.sym->namelen)
-				self->max_sym_namelen = h->ms.sym->namelen;
-		}
-	}
-}
-
-static int symbol__alloc_hist(struct symbol *self)
-{
-	struct sym_priv *priv = symbol__priv(self);
-	const int size = (sizeof(*priv->hist) +
-			  (self->end - self->start) * sizeof(u64));
-
-	priv->hist = zalloc(size);
-	return priv->hist == NULL ? -1 : 0;
-}
-
-int hist_entry__inc_addr_samples(struct hist_entry *self, u64 ip)
-{
-	unsigned int sym_size, offset;
-	struct symbol *sym = self->ms.sym;
-	struct sym_priv *priv;
-	struct sym_hist *h;
-
-	if (!sym || !self->ms.map)
-		return 0;
-
-	priv = symbol__priv(sym);
-	if (priv->hist == NULL && symbol__alloc_hist(sym) < 0)
-		return -ENOMEM;
-
-	sym_size = sym->end - sym->start;
-	offset = ip - sym->start;
-
-	pr_debug3("%s: ip=%#Lx\n", __func__, self->ms.map->unmap_ip(self->ms.map, ip));
-
-	if (offset >= sym_size)
-		return 0;
-
-	h = priv->hist;
-	h->sum++;
-	h->ip[offset]++;
-
-	pr_debug3("%#Lx %s: period++ [ip: %#Lx, %#Lx] => %Ld\n", self->ms.sym->start,
-		  self->ms.sym->name, ip, ip - self->ms.sym->start, h->ip[offset]);
-	return 0;
-}
-
-static struct objdump_line *objdump_line__new(s64 offset, char *line)
-{
-	struct objdump_line *self = malloc(sizeof(*self));
-
-	if (self != NULL) {
-		self->offset = offset;
-		self->line = line;
-	}
-
-	return self;
-}
-
-void objdump_line__free(struct objdump_line *self)
-{
-	free(self->line);
-	free(self);
-}
-
-static void objdump__add_line(struct list_head *head, struct objdump_line *line)
-{
-	list_add_tail(&line->node, head);
-}
-
-struct objdump_line *objdump__get_next_ip_line(struct list_head *head,
-					       struct objdump_line *pos)
-{
-	list_for_each_entry_continue(pos, head, node)
-		if (pos->offset >= 0)
-			return pos;
-
-	return NULL;
-}
-
-static int hist_entry__parse_objdump_line(struct hist_entry *self, FILE *file,
-					  struct list_head *head)
-{
-	struct symbol *sym = self->ms.sym;
-	struct objdump_line *objdump_line;
-	char *line = NULL, *tmp, *tmp2, *c;
-	size_t line_len;
-	s64 line_ip, offset = -1;
-
-	if (getline(&line, &line_len, file) < 0)
-		return -1;
-
-	if (!line)
-		return -1;
-
-	while (line_len != 0 && isspace(line[line_len - 1]))
-		line[--line_len] = '\0';
-
-	c = strchr(line, '\n');
-	if (c)
-		*c = 0;
-
-	line_ip = -1;
-
-	/*
-	 * Strip leading spaces:
-	 */
-	tmp = line;
-	while (*tmp) {
-		if (*tmp != ' ')
-			break;
-		tmp++;
-	}
-
-	if (*tmp) {
-		/*
-		 * Parse hexa addresses followed by ':'
-		 */
-		line_ip = strtoull(tmp, &tmp2, 16);
-		if (*tmp2 != ':' || tmp == tmp2)
-			line_ip = -1;
-	}
-
-	if (line_ip != -1) {
-		u64 start = map__rip_2objdump(self->ms.map, sym->start);
-		offset = line_ip - start;
-	}
-
-	objdump_line = objdump_line__new(offset, line);
-	if (objdump_line == NULL) {
-		free(line);
-		return -1;
-	}
-	objdump__add_line(head, objdump_line);
-
-	return 0;
-}
-
-int hist_entry__annotate(struct hist_entry *self, struct list_head *head)
-{
-	struct symbol *sym = self->ms.sym;
-	struct map *map = self->ms.map;
-	struct dso *dso = map->dso;
-	char *filename = dso__build_id_filename(dso, NULL, 0);
-	bool free_filename = true;
-	char command[PATH_MAX * 2];
-	FILE *file;
-	int err = 0;
-	u64 len;
-
-	if (filename == NULL) {
-		if (dso->has_build_id) {
-			pr_err("Can't annotate %s: not enough memory\n",
-			       sym->name);
-			return -ENOMEM;
-		}
-		goto fallback;
-	} else if (readlink(filename, command, sizeof(command)) < 0 ||
-		   strstr(command, "[kernel.kallsyms]") ||
-		   access(filename, R_OK)) {
-		free(filename);
-fallback:
-		/*
-		 * If we don't have build-ids or the build-id file isn't in the
-		 * cache, or is just a kallsyms file, well, lets hope that this
-		 * DSO is the same as when 'perf record' ran.
-		 */
-		filename = dso->long_name;
-		free_filename = false;
-	}
-
-	if (dso->origin == DSO__ORIG_KERNEL) {
-		if (dso->annotate_warned)
-			goto out_free_filename;
-		err = -ENOENT;
-		dso->annotate_warned = 1;
-		pr_err("Can't annotate %s: No vmlinux file was found in the "
-		       "path\n", sym->name);
-		goto out_free_filename;
-	}
-
-	pr_debug("%s: filename=%s, sym=%s, start=%#Lx, end=%#Lx\n", __func__,
-		 filename, sym->name, map->unmap_ip(map, sym->start),
-		 map->unmap_ip(map, sym->end));
-
-	len = sym->end - sym->start;
-
-	pr_debug("annotating [%p] %30s : [%p] %30s\n",
-		 dso, dso->long_name, sym, sym->name);
-
-	snprintf(command, sizeof(command),
-		 "objdump --start-address=0x%016Lx --stop-address=0x%016Lx -dS -C %s|grep -v %s|expand",
-		 map__rip_2objdump(map, sym->start),
-		 map__rip_2objdump(map, sym->end),
-		 filename, filename);
-
-	pr_debug("Executing: %s\n", command);
-
-	file = popen(command, "r");
-	if (!file)
-		goto out_free_filename;
-
-	while (!feof(file))
-		if (hist_entry__parse_objdump_line(self, file, head) < 0)
-			break;
-
-	pclose(file);
-out_free_filename:
-	if (free_filename)
-		free(filename);
-	return err;
-}
-
-void hists__inc_nr_events(struct hists *self, u32 type)
-{
-	++self->stats.nr_events[0];
-	++self->stats.nr_events[type];
-}
-
-size_t hists__fprintf_nr_events(struct hists *self, FILE *fp)
-{
-	int i;
-	size_t ret = 0;
-
-	for (i = 0; i < PERF_RECORD_HEADER_MAX; ++i) {
-		if (!event__name[i])
-			continue;
-		ret += fprintf(fp, "%10s events: %10d\n",
-			       event__name[i], self->stats.nr_events[i]);
-	}
-
-	return ret;
-}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
deleted file mode 100644
index 83fa33a..0000000
--- a/tools/perf/util/hist.h
+++ /dev/null
@@ -1,129 +0,0 @@
-#ifndef __PERF_HIST_H
-#define __PERF_HIST_H
-
-#include <linux/types.h>
-#include "callchain.h"
-
-extern struct callchain_param callchain_param;
-
-struct hist_entry;
-struct addr_location;
-struct symbol;
-struct rb_root;
-
-struct objdump_line {
-	struct list_head node;
-	s64		 offset;
-	char		 *line;
-};
-
-void objdump_line__free(struct objdump_line *self);
-struct objdump_line *objdump__get_next_ip_line(struct list_head *head,
-					       struct objdump_line *pos);
-
-struct sym_hist {
-	u64		sum;
-	u64		ip[0];
-};
-
-struct sym_ext {
-	struct rb_node	node;
-	double		percent;
-	char		*path;
-};
-
-struct sym_priv {
-	struct sym_hist	*hist;
-	struct sym_ext	*ext;
-};
-
-/*
- * The kernel collects the number of events it couldn't send in a stretch and
- * when possible sends this number in a PERF_RECORD_LOST event. The number of
- * such "chunks" of lost events is stored in .nr_events[PERF_EVENT_LOST] while
- * total_lost tells exactly how many events the kernel in fact lost, i.e. it is
- * the sum of all struct lost_event.lost fields reported.
- *
- * The total_period is needed because by default auto-freq is used, so
- * multipling nr_events[PERF_EVENT_SAMPLE] by a frequency isn't possible to get
- * the total number of low level events, it is necessary to to sum all struct
- * sample_event.period and stash the result in total_period.
- */
-struct events_stats {
-	u64 total_period;
-	u64 total_lost;
-	u32 nr_events[PERF_RECORD_HEADER_MAX];
-	u32 nr_unknown_events;
-};
-
-struct hists {
-	struct rb_node		rb_node;
-	struct rb_root		entries;
-	u64			nr_entries;
-	struct events_stats	stats;
-	u64			config;
-	u64			event_stream;
-	u32			type;
-	u32			max_sym_namelen;
-};
-
-struct hist_entry *__hists__add_entry(struct hists *self,
-				      struct addr_location *al,
-				      struct symbol *parent, u64 period);
-extern int64_t hist_entry__cmp(struct hist_entry *, struct hist_entry *);
-extern int64_t hist_entry__collapse(struct hist_entry *, struct hist_entry *);
-int hist_entry__fprintf(struct hist_entry *self, struct hists *pair_hists,
-			bool show_displacement, long displacement, FILE *fp,
-			u64 total);
-int hist_entry__snprintf(struct hist_entry *self, char *bf, size_t size,
-			 struct hists *pair_hists, bool show_displacement,
-			 long displacement, bool color, u64 total);
-void hist_entry__free(struct hist_entry *);
-
-void hists__output_resort(struct hists *self);
-void hists__collapse_resort(struct hists *self);
-
-void hists__inc_nr_events(struct hists *self, u32 type);
-size_t hists__fprintf_nr_events(struct hists *self, FILE *fp);
-
-size_t hists__fprintf(struct hists *self, struct hists *pair,
-		      bool show_displacement, FILE *fp);
-
-int hist_entry__inc_addr_samples(struct hist_entry *self, u64 ip);
-int hist_entry__annotate(struct hist_entry *self, struct list_head *head);
-
-void hists__filter_by_dso(struct hists *self, const struct dso *dso);
-void hists__filter_by_thread(struct hists *self, const struct thread *thread);
-
-#ifdef NO_NEWT_SUPPORT
-static inline int hists__browse(struct hists *self __used,
-				const char *helpline __used,
-				const char *ev_name __used)
-{
-	return 0;
-}
-
-static inline int hists__tui_browse_tree(struct rb_root *self __used,
-					 const char *help __used)
-{
-	return 0;
-}
-
-static inline int hist_entry__tui_annotate(struct hist_entry *self __used)
-{
-	return 0;
-}
-#define KEY_LEFT -1
-#define KEY_RIGHT -2
-#else
-#include <newt.h>
-int hists__browse(struct hists *self, const char *helpline,
-		  const char *ev_name);
-int hist_entry__tui_annotate(struct hist_entry *self);
-
-#define KEY_LEFT NEWT_KEY_LEFT
-#define KEY_RIGHT NEWT_KEY_RIGHT
-
-int hists__tui_browse_tree(struct rb_root *self, const char *help);
-#endif
-#endif	/* __PERF_HIST_H */
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 63f89e0..dffe075 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -16,10 +16,10 @@
 #include <sys/ttydefaults.h>
 
 #include "cache.h"
-#include "hist.h"
+#include <perf/hist.h>
 #include "pstack.h"
 #include <perf/session.h>
-#include "sort.h"
+#include <perf/sort.h>
 #include <perf/symbol.h>
 
 #if SLANG_VERSION < 20104
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index d3e911b..08b591f 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -34,14 +34,14 @@
 
 #undef _GNU_SOURCE
 #include <lk/util.h>
-#include "event.h"
+#include <perf/event.h>
 #include "string.h"
 #include <lk/strlist.h>
 #include <lk/debug.h>
 #include "cache.h"
 #include <lk/color.h>
 #include <perf/symbol.h>
-#include "thread.h"
+#include <perf/thread.h>
 #include <lk/debugfs.h>
 #include "trace-event.h"	/* For __unused */
 #include "probe-event.h"
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 789c583..de2c598 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -34,7 +34,7 @@
 #include <dwarf-regs.h>
 
 #include "string.h"
-#include "event.h"
+#include <perf/event.h>
 #include <lk/debug.h>
 #include <lk/util.h>
 #include <perf/symbol.h>
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
deleted file mode 100644
index c27b4b0..0000000
--- a/tools/perf/util/sort.c
+++ /dev/null
@@ -1,346 +0,0 @@
-#include "sort.h"
-
-regex_t		parent_regex;
-const char	default_parent_pattern[] = "^sys_|^do_page_fault";
-const char	*parent_pattern = default_parent_pattern;
-const char	default_sort_order[] = "comm,dso,symbol";
-const char	*sort_order = default_sort_order;
-int		sort__need_collapse = 0;
-int		sort__has_parent = 0;
-
-enum sort_type	sort__first_dimension;
-
-unsigned int dsos__col_width;
-unsigned int comms__col_width;
-unsigned int threads__col_width;
-unsigned int cpus__col_width;
-static unsigned int parent_symbol__col_width;
-char * field_sep;
-
-LIST_HEAD(hist_entry__sort_list);
-
-static int hist_entry__thread_snprintf(struct hist_entry *self, char *bf,
-				       size_t size, unsigned int width);
-static int hist_entry__comm_snprintf(struct hist_entry *self, char *bf,
-				     size_t size, unsigned int width);
-static int hist_entry__dso_snprintf(struct hist_entry *self, char *bf,
-				    size_t size, unsigned int width);
-static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
-				    size_t size, unsigned int width);
-static int hist_entry__parent_snprintf(struct hist_entry *self, char *bf,
-				       size_t size, unsigned int width);
-static int hist_entry__cpu_snprintf(struct hist_entry *self, char *bf,
-				    size_t size, unsigned int width);
-
-struct sort_entry sort_thread = {
-	.se_header	= "Command:  Pid",
-	.se_cmp		= sort__thread_cmp,
-	.se_snprintf	= hist_entry__thread_snprintf,
-	.se_width	= &threads__col_width,
-};
-
-struct sort_entry sort_comm = {
-	.se_header	= "Command",
-	.se_cmp		= sort__comm_cmp,
-	.se_collapse	= sort__comm_collapse,
-	.se_snprintf	= hist_entry__comm_snprintf,
-	.se_width	= &comms__col_width,
-};
-
-struct sort_entry sort_dso = {
-	.se_header	= "Shared Object",
-	.se_cmp		= sort__dso_cmp,
-	.se_snprintf	= hist_entry__dso_snprintf,
-	.se_width	= &dsos__col_width,
-};
-
-struct sort_entry sort_sym = {
-	.se_header	= "Symbol",
-	.se_cmp		= sort__sym_cmp,
-	.se_snprintf	= hist_entry__sym_snprintf,
-};
-
-struct sort_entry sort_parent = {
-	.se_header	= "Parent symbol",
-	.se_cmp		= sort__parent_cmp,
-	.se_snprintf	= hist_entry__parent_snprintf,
-	.se_width	= &parent_symbol__col_width,
-};
- 
-struct sort_entry sort_cpu = {
-	.se_header      = "CPU",
-	.se_cmp	        = sort__cpu_cmp,
-	.se_snprintf    = hist_entry__cpu_snprintf,
-	.se_width	= &cpus__col_width,
-};
-
-struct sort_dimension {
-	const char		*name;
-	struct sort_entry	*entry;
-	int			taken;
-};
-
-static struct sort_dimension sort_dimensions[] = {
-	{ .name = "pid",	.entry = &sort_thread,	},
-	{ .name = "comm",	.entry = &sort_comm,	},
-	{ .name = "dso",	.entry = &sort_dso,	},
-	{ .name = "symbol",	.entry = &sort_sym,	},
-	{ .name = "parent",	.entry = &sort_parent,	},
-	{ .name = "cpu",	.entry = &sort_cpu,	},
-};
-
-int64_t cmp_null(void *l, void *r)
-{
-	if (!l && !r)
-		return 0;
-	else if (!l)
-		return -1;
-	else
-		return 1;
-}
-
-/* --sort pid */
-
-int64_t
-sort__thread_cmp(struct hist_entry *left, struct hist_entry *right)
-{
-	return right->thread->pid - left->thread->pid;
-}
-
-static int repsep_snprintf(char *bf, size_t size, const char *fmt, ...)
-{
-	int n;
-	va_list ap;
-
-	va_start(ap, fmt);
-	n = vsnprintf(bf, size, fmt, ap);
-	if (field_sep && n > 0) {
-		char *sep = bf;
-
-		while (1) {
-			sep = strchr(sep, *field_sep);
-			if (sep == NULL)
-				break;
-			*sep = '.';
-		}
-	}
-	va_end(ap);
-	return n;
-}
-
-static int hist_entry__thread_snprintf(struct hist_entry *self, char *bf,
-				       size_t size, unsigned int width)
-{
-	return repsep_snprintf(bf, size, "%*s:%5d", width,
-			      self->thread->comm ?: "", self->thread->pid);
-}
-
-static int hist_entry__comm_snprintf(struct hist_entry *self, char *bf,
-				     size_t size, unsigned int width)
-{
-	return repsep_snprintf(bf, size, "%*s", width, self->thread->comm);
-}
-
-/* --sort dso */
-
-int64_t
-sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
-{
-	struct dso *dso_l = left->ms.map ? left->ms.map->dso : NULL;
-	struct dso *dso_r = right->ms.map ? right->ms.map->dso : NULL;
-	const char *dso_name_l, *dso_name_r;
-
-	if (!dso_l || !dso_r)
-		return cmp_null(dso_l, dso_r);
-
-	if (verbose) {
-		dso_name_l = dso_l->long_name;
-		dso_name_r = dso_r->long_name;
-	} else {
-		dso_name_l = dso_l->short_name;
-		dso_name_r = dso_r->short_name;
-	}
-
-	return strcmp(dso_name_l, dso_name_r);
-}
-
-static int hist_entry__dso_snprintf(struct hist_entry *self, char *bf,
-				    size_t size, unsigned int width)
-{
-	if (self->ms.map && self->ms.map->dso) {
-		const char *dso_name = !verbose ? self->ms.map->dso->short_name :
-						  self->ms.map->dso->long_name;
-		return repsep_snprintf(bf, size, "%-*s", width, dso_name);
-	}
-
-	return repsep_snprintf(bf, size, "%*Lx", width, self->ip);
-}
-
-/* --sort symbol */
-
-int64_t
-sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
-{
-	u64 ip_l, ip_r;
-
-	if (left->ms.sym == right->ms.sym)
-		return 0;
-
-	ip_l = left->ms.sym ? left->ms.sym->start : left->ip;
-	ip_r = right->ms.sym ? right->ms.sym->start : right->ip;
-
-	return (int64_t)(ip_r - ip_l);
-}
-
-static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
-				    size_t size, unsigned int width __used)
-{
-	size_t ret = 0;
-
-	if (verbose) {
-		char o = self->ms.map ? dso__symtab_origin(self->ms.map->dso) : '!';
-		ret += repsep_snprintf(bf, size, "%#018llx %c ", self->ip, o);
-	}
-
-	ret += repsep_snprintf(bf + ret, size - ret, "[%c] ", self->level);
-	if (self->ms.sym)
-		ret += repsep_snprintf(bf + ret, size - ret, "%s",
-				       self->ms.sym->name);
-	else
-		ret += repsep_snprintf(bf + ret, size - ret, "%#016llx", self->ip);
-
-	return ret;
-}
-
-/* --sort comm */
-
-int64_t
-sort__comm_cmp(struct hist_entry *left, struct hist_entry *right)
-{
-	return right->thread->pid - left->thread->pid;
-}
-
-int64_t
-sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
-{
-	char *comm_l = left->thread->comm;
-	char *comm_r = right->thread->comm;
-
-	if (!comm_l || !comm_r)
-		return cmp_null(comm_l, comm_r);
-
-	return strcmp(comm_l, comm_r);
-}
-
-/* --sort parent */
-
-int64_t
-sort__parent_cmp(struct hist_entry *left, struct hist_entry *right)
-{
-	struct symbol *sym_l = left->parent;
-	struct symbol *sym_r = right->parent;
-
-	if (!sym_l || !sym_r)
-		return cmp_null(sym_l, sym_r);
-
-	return strcmp(sym_l->name, sym_r->name);
-}
-
-static int hist_entry__parent_snprintf(struct hist_entry *self, char *bf,
-				       size_t size, unsigned int width)
-{
-	return repsep_snprintf(bf, size, "%-*s", width,
-			      self->parent ? self->parent->name : "[other]");
-}
-
-/* --sort cpu */
-
-int64_t
-sort__cpu_cmp(struct hist_entry *left, struct hist_entry *right)
-{
-	return right->cpu - left->cpu;
-}
-
-static int hist_entry__cpu_snprintf(struct hist_entry *self, char *bf,
-				       size_t size, unsigned int width)
-{
-	return repsep_snprintf(bf, size, "%-*d", width, self->cpu);
-}
-
-int sort_dimension__add(const char *tok)
-{
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(sort_dimensions); i++) {
-		struct sort_dimension *sd = &sort_dimensions[i];
-
-		if (sd->taken)
-			continue;
-
-		if (strncasecmp(tok, sd->name, strlen(tok)))
-			continue;
-
-		if (sd->entry->se_collapse)
-			sort__need_collapse = 1;
-
-		if (sd->entry == &sort_parent) {
-			int ret = regcomp(&parent_regex, parent_pattern, REG_EXTENDED);
-			if (ret) {
-				char err[BUFSIZ];
-
-				regerror(ret, &parent_regex, err, sizeof(err));
-				pr_err("Invalid regex: %s\n%s", parent_pattern, err);
-				return -EINVAL;
-			}
-			sort__has_parent = 1;
-		}
-
-		if (list_empty(&hist_entry__sort_list)) {
-			if (!strcmp(sd->name, "pid"))
-				sort__first_dimension = SORT_PID;
-			else if (!strcmp(sd->name, "comm"))
-				sort__first_dimension = SORT_COMM;
-			else if (!strcmp(sd->name, "dso"))
-				sort__first_dimension = SORT_DSO;
-			else if (!strcmp(sd->name, "symbol"))
-				sort__first_dimension = SORT_SYM;
-			else if (!strcmp(sd->name, "parent"))
-				sort__first_dimension = SORT_PARENT;
-			else if (!strcmp(sd->name, "cpu"))
-				sort__first_dimension = SORT_CPU;
-		}
-
-		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
-		sd->taken = 1;
-
-		return 0;
-	}
-
-	return -ESRCH;
-}
-
-void setup_sorting(const char * const usagestr[], const struct option *opts)
-{
-	char *tmp, *tok, *str = strdup(sort_order);
-
-	for (tok = strtok_r(str, ", ", &tmp);
-			tok; tok = strtok_r(NULL, ", ", &tmp)) {
-		if (sort_dimension__add(tok) < 0) {
-			error("Unknown --sort key: `%s'", tok);
-			usage_with_options(usagestr, opts);
-		}
-	}
-
-	free(str);
-}
-
-void sort_entry__setup_elide(struct sort_entry *self, struct strlist *list,
-			     const char *list_name, FILE *fp)
-{
-	if (list && strlist__nr_entries(list) == 1) {
-		if (fp != NULL)
-			fprintf(fp, "# %s: %s\n", list_name,
-				strlist__entry(list, 0)->s);
-		self->elide = true;
-	}
-}
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
deleted file mode 100644
index ccc3045..0000000
--- a/tools/perf/util/sort.h
+++ /dev/null
@@ -1,116 +0,0 @@
-#ifndef __PERF_SORT_H
-#define __PERF_SORT_H
-#include "../builtin.h"
-
-#include <lk/util.h>
-
-#include <lk/color.h>
-#include <linux/list.h>
-#include "cache.h"
-#include <linux/rbtree.h>
-#include <perf/symbol.h>
-#include "string.h"
-#include "callchain.h"
-#include <lk/strlist.h>
-#include "values.h"
-
-#include "../perf.h"
-#include <lk/debug.h>
-#include <perf/header.h>
-
-#include "parse-options.h"
-#include <perf/parse-events.h>
-
-#include "thread.h"
-#include "sort.h"
-
-extern regex_t parent_regex;
-extern const char *sort_order;
-extern const char default_parent_pattern[];
-extern const char *parent_pattern;
-extern const char default_sort_order[];
-extern int sort__need_collapse;
-extern int sort__has_parent;
-extern char *field_sep;
-extern struct sort_entry sort_comm;
-extern struct sort_entry sort_dso;
-extern struct sort_entry sort_sym;
-extern struct sort_entry sort_parent;
-extern unsigned int dsos__col_width;
-extern unsigned int comms__col_width;
-extern unsigned int threads__col_width;
-extern unsigned int cpus__col_width;
-extern enum sort_type sort__first_dimension;
-
-struct hist_entry {
-	struct rb_node		rb_node;
-	u64			period;
-	u64			period_sys;
-	u64			period_us;
-	u64			period_guest_sys;
-	u64			period_guest_us;
-	struct map_symbol	ms;
-	struct thread		*thread;
-	u64			ip;
-	s32			cpu;
-	u32			nr_events;
-	char			level;
-	u8			filtered;
-	struct symbol		*parent;
-	union {
-		unsigned long	  position;
-		struct hist_entry *pair;
-		struct rb_root	  sorted_chain;
-	};
-	struct callchain_node	callchain[0];
-};
-
-enum sort_type {
-	SORT_PID,
-	SORT_COMM,
-	SORT_DSO,
-	SORT_SYM,
-	SORT_PARENT,
-	SORT_CPU,
-};
-
-/*
- * configurable sorting bits
- */
-
-struct sort_entry {
-	struct list_head list;
-
-	const char *se_header;
-
-	int64_t (*se_cmp)(struct hist_entry *, struct hist_entry *);
-	int64_t (*se_collapse)(struct hist_entry *, struct hist_entry *);
-	int	(*se_snprintf)(struct hist_entry *self, char *bf, size_t size,
-			       unsigned int width);
-	unsigned int *se_width;
-	bool	elide;
-};
-
-extern struct sort_entry sort_thread;
-extern struct list_head hist_entry__sort_list;
-
-void setup_sorting(const char * const usagestr[], const struct option *opts);
-
-extern size_t sort__thread_print(FILE *, struct hist_entry *, unsigned int);
-extern size_t sort__comm_print(FILE *, struct hist_entry *, unsigned int);
-extern size_t sort__dso_print(FILE *, struct hist_entry *, unsigned int);
-extern size_t sort__sym_print(FILE *, struct hist_entry *, unsigned int __used);
-extern int64_t cmp_null(void *, void *);
-extern int64_t sort__thread_cmp(struct hist_entry *, struct hist_entry *);
-extern int64_t sort__comm_cmp(struct hist_entry *, struct hist_entry *);
-extern int64_t sort__comm_collapse(struct hist_entry *, struct hist_entry *);
-extern int64_t sort__dso_cmp(struct hist_entry *, struct hist_entry *);
-extern int64_t sort__sym_cmp(struct hist_entry *, struct hist_entry *);
-extern int64_t sort__parent_cmp(struct hist_entry *, struct hist_entry *);
-int64_t sort__cpu_cmp(struct hist_entry *left, struct hist_entry *right);
-extern size_t sort__parent_print(FILE *, struct hist_entry *, unsigned int);
-extern int sort_dimension__add(const char *);
-void sort_entry__setup_elide(struct sort_entry *self, struct strlist *list,
-			     const char *list_name, FILE *fp);
-
-#endif	/* __PERF_SORT_H */
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
deleted file mode 100644
index c5e5207..0000000
--- a/tools/perf/util/thread.c
+++ /dev/null
@@ -1,164 +0,0 @@
-#include "../perf.h"
-#include <stdlib.h>
-#include <stdio.h>
-#include <string.h>
-#include <perf/session.h>
-#include "thread.h"
-#include <lk/util.h>
-#include <lk/debug.h>
-
-int find_all_tid(int pid, pid_t ** all_tid)
-{
-	char name[256];
-	int items;
-	struct dirent **namelist = NULL;
-	int ret = 0;
-	int i;
-
-	sprintf(name, "/proc/%d/task", pid);
-	items = scandir(name, &namelist, NULL, NULL);
-	if (items <= 0)
-                return -ENOENT;
-	*all_tid = malloc(sizeof(pid_t) * items);
-	if (!*all_tid) {
-		ret = -ENOMEM;
-		goto failure;
-	}
-
-	for (i = 0; i < items; i++)
-		(*all_tid)[i] = atoi(namelist[i]->d_name);
-
-	ret = items;
-
-failure:
-	for (i=0; i<items; i++)
-		free(namelist[i]);
-	free(namelist);
-
-	return ret;
-}
-
-static struct thread *thread__new(pid_t pid)
-{
-	struct thread *self = zalloc(sizeof(*self));
-
-	if (self != NULL) {
-		map_groups__init(&self->mg);
-		self->pid = pid;
-		self->comm = malloc(32);
-		if (self->comm)
-			snprintf(self->comm, 32, ":%d", self->pid);
-	}
-
-	return self;
-}
-
-int thread__set_comm(struct thread *self, const char *comm)
-{
-	int err;
-
-	if (self->comm)
-		free(self->comm);
-	self->comm = strdup(comm);
-	err = self->comm == NULL ? -ENOMEM : 0;
-	if (!err) {
-		self->comm_set = true;
-		map_groups__flush(&self->mg);
-	}
-	return err;
-}
-
-int thread__comm_len(struct thread *self)
-{
-	if (!self->comm_len) {
-		if (!self->comm)
-			return 0;
-		self->comm_len = strlen(self->comm);
-	}
-
-	return self->comm_len;
-}
-
-static size_t thread__fprintf(struct thread *self, FILE *fp)
-{
-	return fprintf(fp, "Thread %d %s\n", self->pid, self->comm) +
-	       map_groups__fprintf(&self->mg, verbose, fp);
-}
-
-struct thread *perf_session__findnew(struct perf_session *self, pid_t pid)
-{
-	struct rb_node **p = &self->threads.rb_node;
-	struct rb_node *parent = NULL;
-	struct thread *th;
-
-	/*
-	 * Font-end cache - PID lookups come in blocks,
-	 * so most of the time we dont have to look up
-	 * the full rbtree:
-	 */
-	if (self->last_match && self->last_match->pid == pid)
-		return self->last_match;
-
-	while (*p != NULL) {
-		parent = *p;
-		th = rb_entry(parent, struct thread, rb_node);
-
-		if (th->pid == pid) {
-			self->last_match = th;
-			return th;
-		}
-
-		if (pid < th->pid)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-
-	th = thread__new(pid);
-	if (th != NULL) {
-		rb_link_node(&th->rb_node, parent, p);
-		rb_insert_color(&th->rb_node, &self->threads);
-		self->last_match = th;
-	}
-
-	return th;
-}
-
-void thread__insert_map(struct thread *self, struct map *map)
-{
-	map_groups__fixup_overlappings(&self->mg, map, verbose, stderr);
-	map_groups__insert(&self->mg, map);
-}
-
-int thread__fork(struct thread *self, struct thread *parent)
-{
-	int i;
-
-	if (parent->comm_set) {
-		if (self->comm)
-			free(self->comm);
-		self->comm = strdup(parent->comm);
-		if (!self->comm)
-			return -ENOMEM;
-		self->comm_set = true;
-	}
-
-	for (i = 0; i < MAP__NR_TYPES; ++i)
-		if (map_groups__clone(&self->mg, &parent->mg, i) < 0)
-			return -ENOMEM;
-	return 0;
-}
-
-size_t perf_session__fprintf(struct perf_session *self, FILE *fp)
-{
-	size_t ret = 0;
-	struct rb_node *nd;
-
-	for (nd = rb_first(&self->threads); nd; nd = rb_next(nd)) {
-		struct thread *pos = rb_entry(nd, struct thread, rb_node);
-
-		ret += thread__fprintf(pos, fp);
-	}
-
-	return ret;
-}
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
deleted file mode 100644
index 93baaea..0000000
--- a/tools/perf/util/thread.h
+++ /dev/null
@@ -1,44 +0,0 @@
-#ifndef __PERF_THREAD_H
-#define __PERF_THREAD_H
-
-#include <linux/rbtree.h>
-#include <unistd.h>
-#include <perf/symbol.h>
-
-struct thread {
-	struct rb_node		rb_node;
-	struct map_groups	mg;
-	pid_t			pid;
-	char			shortname[3];
-	bool			comm_set;
-	char			*comm;
-	int			comm_len;
-};
-
-struct perf_session;
-
-int find_all_tid(int pid, pid_t ** all_tid);
-int thread__set_comm(struct thread *self, const char *comm);
-int thread__comm_len(struct thread *self);
-struct thread *perf_session__findnew(struct perf_session *self, pid_t pid);
-void thread__insert_map(struct thread *self, struct map *map);
-int thread__fork(struct thread *self, struct thread *parent);
-size_t perf_session__fprintf(struct perf_session *self, FILE *fp);
-
-static inline struct map *thread__find_map(struct thread *self,
-					   enum map_type type, u64 addr)
-{
-	return self ? map_groups__find(&self->mg, type, addr) : NULL;
-}
-
-void thread__find_addr_map(struct thread *self,
-			   struct perf_session *session, u8 cpumode,
-			   enum map_type type, pid_t pid, u64 addr,
-			   struct addr_location *al);
-
-void thread__find_addr_location(struct thread *self,
-				struct perf_session *session, u8 cpumode,
-				enum map_type type, pid_t pid, u64 addr,
-				struct addr_location *al,
-				symbol_filter_t filter);
-#endif	/* __PERF_THREAD_H */
-- 
1.7.1

