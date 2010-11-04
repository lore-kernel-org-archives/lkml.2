Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab0KDPkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:40:17 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:43046 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab0KDPkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:40:13 -0400
From: Borislav Petkov <bp@amd64.org>
To: <acme@infradead.org>, <fweisbec@gmail.com>, <mingo@elte.hu>,
        <peterz@infradead.org>, <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 20/20] ras: Add RAS daemon
Date: Thu,  4 Nov 2010 16:36:56 +0100
Message-Id: <1288885016-18295-21-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1288885016-18295-1-git-send-email-bp@amd64.org>
References: <1288885016-18295-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/Makefile     |    4 +
 tools/ras/Makefile |   16 +++
 tools/ras/rasd.c   |  305 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 325 insertions(+), 0 deletions(-)
 create mode 100644 tools/ras/Makefile
 create mode 100644 tools/ras/rasd.c

diff --git a/tools/Makefile b/tools/Makefile
index 691f78b..360454c 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -37,6 +37,9 @@ export PERF_TOP_DIR
 perf: libparsevent lklib lkperflib .FORCE
 	$(QUIET_SUBDIR0)perf/ $(QUIET_SUBDIR1)
 
+ras: libparsevent lklib lkperflib .FORCE
+	$(QUIET_SUBDIR0)ras/ $(QUIET_SUBDIR1)
+
 libparsevent: .FORCE
 	$(QUIET_SUBDIR0)lib/trace/ $(QUIET_SUBDIR1)
 
@@ -51,5 +54,6 @@ clean:
 	$(QUIET_SUBDIR0)lib/lk/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)lib/perf/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)perf/ $(QUIET_SUBDIR1) clean
+	$(QUIET_SUBDIR0)ras/ $(QUIET_SUBDIR1) clean
 
 .PHONY: clean .FORCE
diff --git a/tools/ras/Makefile b/tools/ras/Makefile
new file mode 100644
index 0000000..370ae35
--- /dev/null
+++ b/tools/ras/Makefile
@@ -0,0 +1,16 @@
+include ../scripts/Makefile.lib
+
+CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 -DNO_NEWT_SUPPORT $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
+ALL_CFLAGS = $(CFLAGS) $(BASIC_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
+ALL_LDFLAGS = $(LDFLAGS)
+
+RASLIBS=$(LIB_OUTPUT)libparsevent.a $(LIB_OUTPUT)lklib.a $(LIB_OUTPUT)lkperflib.a
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
index 0000000..2b02742
--- /dev/null
+++ b/tools/ras/rasd.c
@@ -0,0 +1,305 @@
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
+#include <lk/cpumap.h>
+#include <lk/kernel.h>
+#include <lk/debugfs.h>
+#include <lk/compiler.h>
+#include <perf/mmap.h>
+#include <perf/util.h>
+#include <trace/trace-event.h>
+#include <trace/parse-events.h>
+
+#include "../../arch/x86/include/asm/mce.h"
+
+#define DBG(fmt, args...)	fprintf(stderr, "DBG %s: " fmt "\n", __func__, ##args)
+
+#define MMAP_PAGES	128
+
+#define PFX "rasd: "
+
+static int fds[MAX_NR_CPUS];
+static struct mmap_data mmaps[MAX_NR_CPUS];
+static struct event_format *mce_event;
+static struct mce m;
+
+static int nr_cpus;
+static unsigned int page_size;
+static volatile int done = 0;
+
+static void sig_handler(int sig __used)
+{
+	done = 1;
+}
+
+static void write_output(void *buf, size_t size)
+{
+	while (size) {
+		int ret = write(STDOUT_FILENO, buf, size);
+
+		if (ret < 0)
+			die("failed to write");
+
+		size -= ret;
+		buf += ret;
+	}
+}
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
+static void parse_mce_event(const char *event_name)
+{
+	struct stat st;
+	char *format_path, *format_buf, *path;
+	int fsize, err = 0;
+
+	path = get_tracing_file("events");
+
+	DBG("Got %s", path);
+
+	format_path = malloc_or_die(MAXPATHLEN + sizeof(event_name) + 10);
+	sprintf(format_path, "%s/%s/format", path, event_name);
+
+	err = stat(format_path, &st);
+	if (err < 0)
+		die("accessing %s", format_path);
+
+	DBG("Format access %s ok", format_path);
+
+	fsize = get_filesize(format_path);
+	DBG("Format file size: %d", fsize);
+
+	format_buf = malloc_or_die(fsize);
+	if (!format_buf)
+		die("allocating format buffer");
+
+	if (!read_file(format_path, format_buf))
+		die("reading in format file");
+
+	DBG("Format file contents:\n%s", format_buf);
+
+	init_input_buf(format_buf, fsize);
+
+	mce_event = alloc_event();
+	if (!mce_event)
+		die("Cannot alloc mce_event");
+
+	mce_event->name = event_read_name();
+	if (!mce_event->name)
+		error("no event name");
+
+	mce_event->id = event_read_id();
+	if (mce_event->id < 0)
+		error(PFX "failed to read event id");
+
+	if (event_read_format(mce_event))
+		die("parsing event");
+
+
+	free(format_buf);
+	free(format_path);
+	free(path);
+}
+
+static void fill_mce_data(void *vbuf, size_t buflen)
+{
+	struct format_field *field;
+	char *buf = vbuf;
+	u32 tp_len;
+	unsigned i;
+
+	if (!buflen)
+		return;
+
+	DBG("buflen %lu", buflen);
+
+	for (i = 0; i < buflen; i++) {
+
+		if (!(i & 0xf) && i)
+			printf("\n");
+
+		printf("0x%2.2x ", *(unsigned char *)(buf + i));
+	}
+
+	/* skip event header for now, u32 size inclusive */
+	buf    += (sizeof(struct perf_event_header) + 4);
+	buflen -= (sizeof(struct perf_event_header) + 4);
+
+	tp_len = *(u32 *)buf;
+
+	if (tp_len != buflen)
+		warning("buffer size mismatch: %lu <-> %u (tp)\n", buflen, tp_len);
+
+	for (field = mce_event->format.fields; field; field = field->next) {
+		if ((size_t)(field->offset + field->size) > buflen)
+			warning("MCE buffer truncated? (off: %d <-> buflen: %lu)",
+				field->offset, buflen);
+
+		DBG("field %s, offset: %d", field->name, field->offset);
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
+			DBG("skipping %s", field->name);
+	}
+}
+
+static int ras_init(void)
+{
+	const char *event_name = "mce/mce_record";
+	int cpu;
+
+
+	fprintf(stderr, PFX "Starting daemon.\n");
+
+	page_size = sysconf(_SC_PAGE_SIZE);
+
+	if (get_debugfs_mntpt()) {
+		error("Cannot mount debugfs, exiting...");
+		return 1;
+	}
+
+	nr_cpus = read_cpu_map(NULL);
+
+	parse_mce_event(event_name);
+	assert(event_name);
+
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
+		char dfs_path[MAXPATHLEN];
+
+		snprintf(dfs_path, MAXPATHLEN, "%s/%s%d",
+			 debugfs_mntpt, event_name, cpu);
+
+		DBG("dfs_path: %s", dfs_path);
+
+		fds[cpu] = open(dfs_path, O_RDONLY, O_NONBLOCK);
+		if (fds[cpu] < 0) {
+			error("open perf event on cpu %d\n", cpu);
+			return 1;
+		} else
+			DBG("cpu %d, fd %d", cpu, fds[cpu]);
+	}
+
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
+		mmaps[cpu].prev = 0;
+		mmaps[cpu].mask = MMAP_PAGES*page_size - 1;
+		mmaps[cpu].base = mmap(NULL, (MMAP_PAGES + 1) * page_size,
+				       PROT_READ, MAP_SHARED, fds[cpu], 0);
+
+		if (mmaps[cpu].base == MAP_FAILED) {
+			error("failed to mmap with %d (%s)\n", errno, strerror(errno));
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+static void ras_exit(void)
+{
+	free(mce_event);
+}
+
+int main(void)
+{
+	pid_t pid, sid;
+
+	pid = fork();
+	if (pid < 0) {
+		perror(PFX "Error forking daemon thread");
+		exit(EXIT_FAILURE);
+	}
+
+	/* parent can disappear now */
+	if (pid > 0)
+		exit(EXIT_SUCCESS);
+
+	umask(0);
+
+	/* TODO: open system logs */
+
+	sid = setsid();
+	if (sid < 0) {
+		perror(PFX "Error creating session");
+		exit(EXIT_FAILURE);
+	}
+
+	if (chdir("/") < 0) {
+		perror(PFX "Error chdir to /");
+		exit(EXIT_FAILURE);
+	}
+
+	close(STDIN_FILENO);
+/* 	close(STDOUT_FILENO); */
+/*	close(STDERR_FILENO); */
+
+	if (ras_init())
+		exit(EXIT_FAILURE);
+
+	signal(SIGCHLD, sig_handler);
+	signal(SIGINT, sig_handler);
+
+	while(1) {
+
+		if (mmap_read_all(mmaps, nr_cpus, fill_mce_data)) {
+			DBG("Read some mmapped data");
+			DBG("MCE status: 0x%016llx", m.status);
+		}
+
+		if (done)
+			goto out;
+
+		sleep(30);
+	}
+
+out:
+	ras_exit();
+	return 0;
+
+}
-- 
1.7.3.1

