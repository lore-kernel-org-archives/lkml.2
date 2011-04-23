Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab1DWQaq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 12:30:46 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:40259 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159Ab1DWQal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 12:30:41 -0400
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 18/18] ras: Add RAS daemon
Date: Sat, 23 Apr 2011 18:28:20 +0200
Message-Id: <1303576100-425-19-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1303576100-425-1-git-send-email-bp@amd64.org>
References: <1303576100-425-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/Makefile     |    4 +
 tools/ras/Makefile |   16 ++
 tools/ras/rasd.c   |  440 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 460 insertions(+), 0 deletions(-)
 create mode 100644 tools/ras/Makefile
 create mode 100644 tools/ras/rasd.c

diff --git a/tools/Makefile b/tools/Makefile
index 60993bf..fb4fdb3 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -27,6 +27,9 @@ liblkperf: .FORCE
 libtrace: .FORCE
 	$(QUIET_SUBDIR0)lib/trace/ $(QUIET_SUBDIR1)
 
+ras: libtrace liblkperf liblk .FORCE
+	$(QUIET_SUBDIR0)ras/ $(QUIET_SUBDIR1)
+
 slabinfo: .FORCE
 	$(QUIET_SUBDIR0)slub/ $(QUIET_SUBDIR1)
 
@@ -48,6 +51,7 @@ clean:
 	$(QUIET_SUBDIR0)lib/lk/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)lib/perf/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)lib/trace/ $(QUIET_SUBDIR1) clean
+	$(QUIET_SUBDIR0)ras/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)slub/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)power/x86/turbostat/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)usb/ $(QUIET_SUBDIR1) clean
diff --git a/tools/ras/Makefile b/tools/ras/Makefile
new file mode 100644
index 0000000..b9b1c23
--- /dev/null
+++ b/tools/ras/Makefile
@@ -0,0 +1,16 @@
+include ../scripts/Makefile.lib
+
+CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 -DNO_NEWT_SUPPORT $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
+ALL_CFLAGS = $(CFLAGS) $(BASIC_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
+ALL_LDFLAGS = $(LDFLAGS)
+
+RASLIBS=$(LIB_OUTPUT)liblkperf.a $(LIB_OUTPUT)libtrace.a $(LIB_OUTPUT)liblk.a
+
+rasd: rasd.o
+	$(QUIET_CC)$(CC) $(ALL_CFLAGS) -o $@ $^ $(RASLIBS)
+
+%.o: %.c
+	$(QUIET_CC)$(CC) $(ALL_CFLAGS) -c $<
+
+clean:
+	rm -rf *.o rasd
diff --git a/tools/ras/rasd.c b/tools/ras/rasd.c
new file mode 100644
index 0000000..1bdf66b
--- /dev/null
+++ b/tools/ras/rasd.c
@@ -0,0 +1,440 @@
+/*
+ * Linux RAS daemon.
+ *
+ * Initial code reused from Linux Daemon Writing HOWTO
+ */
+
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+#include <sys/types.h>
+
+#include <lk/util.h>
+#include <lk/debugfs.h>
+#include <lk/thread_map.h>
+#include <lk/cpumap.h>
+#include <perf/evsel.h>
+#include <perf/evlist.h>
+#include <trace/trace-event.h>
+
+#include "../../include/linux/perf_event.h"
+#include "../../arch/x86/include/asm/mce.h"
+
+#undef DEBUG
+
+#ifdef DEBUG
+#define dbg(fmt, args...) \
+	fprintf(stderr, "DBG %s: " fmt "\n", __func__, ##args)
+#else
+#define dbg(fmt, args...) do { } while (0)
+#endif
+
+#define MMAP_PAGES		128
+#define MCE_TP			"mce/mce_record"
+
+#define PFX "rasd: "
+#define ras_err(fmt, args...)	error(PFX fmt, ##args)
+#define ras_die(fmt, args...)	die(PFX fmt, ##args)
+
+static struct event *mce_event;
+static struct thread_map *thread;
+static struct cpu_map *cpus;
+static struct perf_evlist *evlist;
+static struct perf_evsel *evsel;
+static struct mce m;
+static const char *dfs_root;
+
+const char *logf_path = "/var/log/ras.log";
+
+static unsigned long long read_file(const char *file, void *buf)
+{
+	unsigned long long size = 0;
+	int fd, r;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0)
+		die("Can't read '%s'", file);
+
+	do {
+		r = read(fd, buf, BUFSIZ);
+		if (r > 0)
+			size += r;
+	} while (r > 0);
+
+	close(fd);
+
+	return size;
+}
+
+static int parse_mce_event(void)
+{
+	struct stat st;
+	char *fmt_path, *fmt_buf, *tracing_dir;
+	int fsize, err = -EINVAL;
+
+	tracing_dir = get_tracing_file("events");
+	if (!tracing_dir) {
+		ras_err("Cannot get trace events dir!");
+		goto err_out;
+	}
+
+	dbg("Got %s", tracing_dir);
+
+	err = -ENOMEM;
+	fmt_path = malloc(MAXPATHLEN + sizeof(MCE_TP) + 10);
+	if (!fmt_path) {
+		ras_err("allocating %s string", MCE_TP);
+		goto err_event_format;
+	}
+
+	sprintf(fmt_path, "%s/%s/format", tracing_dir, MCE_TP);
+
+	err = stat(fmt_path, &st);
+	if (err < 0) {
+		ras_err("accessing %s", fmt_path);
+		goto err_free_fmt_path;
+	}
+
+	dbg("Format access %s ok", fmt_path);
+
+	fsize = get_filesize(fmt_path);
+
+	dbg("Format file size: %d", fsize);
+
+	err = -ENOMEM;
+	fmt_buf = malloc(fsize);
+	if (!fmt_buf) {
+		ras_err("allocating format buffer");
+		goto err_free_fmt_path;
+	}
+
+	if (!read_file(fmt_path, fmt_buf)) {
+		ras_err("reading in format file");
+		goto err_free_fmt_buf;
+	}
+
+	dbg("event format:\n%s", fmt_buf);
+
+	init_input_buf(fmt_buf, fsize);
+
+	err = -ENOMEM;
+	mce_event = alloc_event();
+	if (!mce_event) {
+		ras_err("allocating mce_event");
+		goto err_free_fmt_buf;
+	}
+
+	err = -EINVAL;
+	mce_event->name = event_read_name();
+	if (!mce_event->name) {
+		ras_err("reading event name");
+		goto err_free_event;
+	}
+
+	mce_event->id = event_read_id();
+	if (mce_event->id < 0) {
+		ras_err("reading event id");
+		goto err_free_event;
+	}
+
+	if (event_read_format(mce_event)) {
+		ras_err("reading event format");
+		goto err_free_event;
+	}
+
+	/*
+	 * we're done parsing the event, free temporarily used resources
+	 * and leave only mce_event.
+	 */
+	err = 0;
+	goto err_free_fmt_buf;
+
+err_free_event:
+	free(mce_event);
+
+err_free_fmt_buf:
+	free(fmt_buf);
+
+err_free_fmt_path:
+	free(fmt_path);
+
+err_event_format:
+	put_tracing_file(tracing_dir);
+
+err_out:
+	return err;
+}
+
+static void fill_mce_data(void *vbuf, size_t buflen)
+{
+	struct format_field *field;
+	char *buf = vbuf;
+#ifdef DEBUG
+	unsigned i;
+#endif
+
+	if (!buflen)
+		return;
+
+#ifdef DEBUG
+	dbg("buflen %lu", buflen);
+
+	for (i = 0; i < buflen; i++) {
+
+		if (!(i % 8) && i)
+			printf("\n");
+
+		printf("0x%2.2x ", *(unsigned char *)(buf + i));
+	}
+#endif
+
+	for (field = mce_event->format.fields; field; field = field->next) {
+		if ((size_t)(field->offset + field->size) > buflen)
+			warning("MCE buf truncated? (off: %d <-> buflen: %lu)",
+				field->offset, buflen);
+
+		dbg("field %s, offset: %d", field->name, field->offset);
+
+		if (!strncmp(field->name, "bank", 4))
+			m.bank = *(u8 *)(buf + field->offset);
+		else if (!strncmp(field->name, "status", 6))
+			m.status = *(u64 *)(buf + field->offset);
+		else if (!strncmp(field->name, "addr", 4))
+			m.addr = *(u64 *)(buf + field->offset);
+		else if (!strncmp(field->name, "misc", 4))
+			m.misc = *(u64 *)(buf + field->offset);
+		else if (!strncmp(field->name, "ip", 2))
+			m.ip = *(u64 *)(buf + field->offset);
+		else if (!strncmp(field->name, "cs", 2))
+			m.cs = *(u8 *)(buf + field->offset);
+		else if (!strncmp(field->name, "tsc", 3))
+			m.tsc = *(u64 *)(buf + field->offset);
+		else if (!strncmp(field->name, "cpu", 3))
+			m.cpu = *(u8 *)(buf + field->offset);
+		else
+			warning("skipping %s", field->name);
+	}
+}
+
+static struct perf_event_attr attr = {
+	.type	     = PERF_TYPE_TRACEPOINT,
+	.sample_type = PERF_SAMPLE_RAW,
+};
+
+static struct perf_evlist *mmap_tp(void)
+{
+	struct perf_evlist *evl;
+	int cpu;
+	char dfs_path[MAXPATHLEN];
+
+	attr.wakeup_events = 1;
+	attr.sample_period = 1;
+
+	thread = thread_map__new(-1, getpid());
+	if (!thread) {
+		ras_err("thread_map__new\n");
+		goto err_out;
+	}
+
+	cpus = cpu_map__new(NULL);
+	if (!cpus) {
+		ras_err("cpu_map__new\n");
+		goto err_free_thread;
+	}
+
+	evl = perf_evlist__new(cpus, thread);
+	if (!evl) {
+		ras_err("perf_evlist__new\n");
+		goto err_free_cpus;
+	}
+
+	evsel = perf_evsel__new(&attr, 0);
+	if (!evsel) {
+		ras_err("perf_evsel__new\n");
+		goto err_free_evlist;
+	}
+
+	perf_evlist__add(evl, evsel);
+
+	if (evsel->fd == NULL &&
+	    perf_evsel__alloc_fd(evsel, cpus->nr, thread->nr) < 0) {
+		ras_err("perf_evsel__alloc_fd\n");
+		goto err_free_evlist;
+	}
+
+	/*
+	 * debugfs_mount has to precede that since we rely
+	 * on dfs_root being properly set
+	 */
+	for (cpu = 0; cpu < cpus->nr; cpu++) {
+
+		memset(dfs_path, 0, MAXPATHLEN);
+
+		snprintf(dfs_path, MAXPATHLEN, "%s/%s%d", dfs_root, MCE_TP, cpu);
+
+		dbg("dfs_path: %s", dfs_path);
+
+		FD(evsel, cpu, 0) = open(dfs_path, O_RDWR, O_NONBLOCK);
+		if (FD(evsel, cpu, 0) < 0) {
+			ras_err("open perf event on cpu %d\n", cpu);
+			goto err_open_fds;
+		} else
+			dbg("cpu %d, fd %d", cpu, FD(evsel, cpu, 0));
+	}
+
+	if (perf_evlist__mmap(evl, 4, true) < 0) {
+		ras_err("perf_evlist__mmap\n");
+		goto err_open_fds;
+	}
+
+	return evl;
+
+err_open_fds:
+	for (; cpu >= 0; cpu--) {
+		close(FD(evsel, cpu, 0));
+		FD(evsel, cpu, 0) = -1;
+	}
+	perf_evsel__free_fd(evsel);
+
+err_free_evlist:
+	perf_evlist__delete(evl);
+
+err_free_cpus:
+	cpu_map__delete(cpus);
+
+err_free_thread:
+	thread_map__delete(thread);
+
+err_out:
+	return NULL;
+
+}
+
+static int ras_init(void)
+{
+	int err = 0;
+
+	fprintf(stderr, PFX "Starting daemon.\n");
+
+	dfs_root = debugfs_mount(NULL);
+	if (!dfs_root) {
+		error("Cannot mount debugfs, exiting... ");
+		return 1;
+	}
+
+	err = parse_mce_event();
+	if (err)
+		return err;
+
+	evlist = mmap_tp();
+	if (!evlist) {
+		ras_err("mmap_tp\n");
+		return 1;
+	}
+
+	return 0;
+}
+
+static void unmap_tp(void)
+{
+	perf_evlist__munmap(evlist);
+	perf_evsel__close_fd(evsel, evlist->cpus->nr, thread->nr);
+	perf_evlist__delete(evlist);
+	cpu_map__delete(cpus);
+	thread_map__delete(thread);
+}
+
+int main(void)
+{
+	union perf_event *event;
+#ifndef DEBUG
+	pid_t pid, sid;
+#endif
+	FILE *logfile = NULL;
+	int err = 0;
+
+#ifndef DEBUG
+	pid = fork();
+	if (pid < 0) {
+		error(PFX "Error forking daemon thread.");
+		exit(EXIT_FAILURE);
+	}
+
+	/* parent can disappear now */
+	if (pid > 0)
+		exit(EXIT_SUCCESS);
+
+	umask(0);
+
+	sid = setsid();
+	if (sid < 0) {
+		error(PFX "Error creating session.");
+		exit(EXIT_FAILURE);
+	}
+
+	if (chdir("/") < 0) {
+		error(PFX "Error chdir to /");
+		exit(EXIT_FAILURE);
+	}
+#endif
+	logfile = fopen(logf_path, "a");
+	if (!logfile) {
+		error(PFX "Error opening logs: %s\n", strerror(errno));
+		err = errno;
+		goto exit;
+	}
+
+#ifndef DEBUG
+	close(STDIN_FILENO);
+	close(STDOUT_FILENO);
+	close(STDERR_FILENO);
+#endif
+
+	err = ras_init();
+	if (err)
+		goto out;
+
+	for (;;) {
+		int cpu;
+
+		for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
+			while ((event = perf_evlist__read_on_cpu(evlist, cpu))) {
+				struct perf_sample s;
+
+				perf_event__parse_sample(event, attr.sample_type,
+							 false, &s);
+
+				fill_mce_data(s.raw_data, s.raw_size);
+
+				dbg("Got MCE, cpu: %d, status: 0x%016llx, addr: 0x%016llx\n",
+				    m.cpu, m.status, m.addr);
+
+				fprintf(logfile,
+					"MCE on cpu %d, status: 0x%016llx, addr: 0x%016llx\n",
+					m.cpu, m.status, m.addr);
+				fflush(logfile);
+			}
+		}
+
+		dbg("polling fds");
+		poll(evlist->pollfd, evlist->nr_fds, -1);
+	}
+
+	goto cleanup;
+
+out:
+	free(mce_event);
+	unmap_tp();
+
+cleanup:
+	fclose(logfile);
+
+exit:
+	return err;
+
+}
-- 
1.7.4.rc2

