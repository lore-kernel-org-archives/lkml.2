Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab1AUPIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:08:24 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58547 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab1AUPIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:08:19 -0500
From: Borislav Petkov <bp@amd64.org>
To: <peterz@infradead.org>, <mingo@elte.hu>
Cc: <tony.luck@intel.com>, <acme@infradead.org>, <rostedt@goodmis.org>,
        <fweisbec@gmail.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH] ras: Add RAS daemon
Date: Fri, 21 Jan 2011 16:09:35 +0100
Message-Id: <1295622575-18607-13-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1295622575-18607-1-git-send-email-bp@amd64.org>
References: <1295622575-18607-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/Makefile     |    4 +
 tools/ras/Makefile |   16 +++
 tools/ras/rasd.c   |  311 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 331 insertions(+), 0 deletions(-)
 create mode 100644 tools/ras/Makefile
 create mode 100644 tools/ras/rasd.c

diff --git a/tools/Makefile b/tools/Makefile
index 71dce04..a012fa3 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -22,11 +22,15 @@ liblk: .FORCE
 liblkperf:
 	$(QUIET_SUBDIR0)lib/perf/ $(QUIET_SUBDIR1)
 
+ras: libtrace liblk liblkperf .FORCE
+	$(QUIET_SUBDIR0)ras/ $(QUIET_SUBDIR1)
+
 clean:
 	$(QUIET_SUBDIR0)lib/trace/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)lib/lk/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)lib/perf/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)perf/ $(QUIET_SUBDIR1) clean
+	$(QUIET_SUBDIR0)ras/ $(QUIET_SUBDIR1) clean
 
 
 .PHONY: clean .FORCE
diff --git a/tools/ras/Makefile b/tools/ras/Makefile
new file mode 100644
index 0000000..0b2f458
--- /dev/null
+++ b/tools/ras/Makefile
@@ -0,0 +1,16 @@
+include ../scripts/Makefile.lib
+
+CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 -DNO_NEWT_SUPPORT $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
+ALL_CFLAGS = $(CFLAGS) $(BASIC_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
+ALL_LDFLAGS = $(LDFLAGS)
+
+RASLIBS=$(LIB_OUTPUT)libtrace.a $(LIB_OUTPUT)liblk.a $(LIB_OUTPUT)liblkperf.a
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
index 0000000..a8b14b7
--- /dev/null
+++ b/tools/ras/rasd.c
@@ -0,0 +1,311 @@
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
+#include <perf/mmap.h>
+#include <perf/util.h>
+#include <trace/trace-event.h>
+
+#include "../../arch/x86/include/asm/mce.h"
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
+
+static int fds[MAX_NR_CPUS];
+static struct mmap_data mmaps[MAX_NR_CPUS];
+static struct event *mce_event;
+static struct mce m;
+static const char *dfs_root;
+
+static int nr_cpus;
+static unsigned int page_size;
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
+static void parse_mce_event(void)
+{
+	struct stat st;
+	char *format_path, *format_buf, *path;
+	int fsize, err = 0;
+
+	path = get_tracing_file("events");
+
+	dbg("Got %s", path);
+
+	format_path = malloc_or_die(MAXPATHLEN + sizeof(MCE_TP) + 10);
+	sprintf(format_path, "%s/%s/format", path, MCE_TP);
+
+	err = stat(format_path, &st);
+	if (err < 0)
+		die("accessing %s", format_path);
+
+	dbg("Format access %s ok", format_path);
+
+	fsize = get_filesize(format_path);
+	dbg("Format file size: %d", fsize);
+
+	format_buf = malloc_or_die(fsize);
+	if (!format_buf)
+		die("allocating format buffer");
+
+	if (!read_file(format_path, format_buf))
+		die("reading in format file");
+
+	dbg("Format file contents:\n%s", format_buf);
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
+		if (!(i & 0xf) && i)
+			printf("\n");
+
+		printf("0x%2.2x ", *(unsigned char *)(buf + i));
+	}
+#endif
+
+	/* skip event header for now, u32 size inclusive */
+	buf    += sizeof(struct perf_event_header);
+	buflen -= sizeof(struct perf_event_header) + 4;
+
+	tp_len = *(u32 *)buf;
+
+	if (tp_len != buflen)
+		warning("bufsize mismatch: %lu <-> %u (tp)\n", buflen, tp_len);
+
+	/* skip size */
+	buf += 4;
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
+static int ras_init(void)
+{
+	int cpu;
+
+	fprintf(stderr, PFX "Starting daemon.\n");
+
+	page_size = sysconf(_SC_PAGE_SIZE);
+
+	dfs_root = debugfs_mount(NULL);
+	if (!dfs_root) {
+		error("Cannot mount debugfs, exiting... ");
+		return 1;
+	}
+
+	nr_cpus = sysconf(_SC_NPROCESSORS_CONF);
+	if (nr_cpus < 0) {
+		error("Cannot get # CPUs, exiting... ");
+		return 1;
+	}
+
+	parse_mce_event();
+	assert(mce_event);
+
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
+		char dfs_path[MAXPATHLEN];
+
+		snprintf(dfs_path, MAXPATHLEN, "%s/%s%d",
+			 dfs_root, MCE_TP, cpu);
+
+		dbg("dfs_path: %s", dfs_path);
+
+		fds[cpu] = open(dfs_path, O_RDWR, O_NONBLOCK);
+		if (fds[cpu] < 0) {
+			error("open perf event on cpu %d\n", cpu);
+			return 1;
+		} else
+			dbg("cpu %d, fd %d", cpu, fds[cpu]);
+	}
+
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
+		mmaps[cpu].prev = 0;
+		mmaps[cpu].mask = MMAP_PAGES*page_size - 1;
+		mmaps[cpu].base = mmap(NULL, (MMAP_PAGES + 1) * page_size,
+				       PROT_READ | PROT_WRITE, MAP_SHARED,
+				       fds[cpu], 0);
+
+		if (mmaps[cpu].base == MAP_FAILED) {
+			error("cannot mmap: %s (%d).", strerror(errno), errno);
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
+	FILE *logfile = NULL;
+	int err = 0;
+
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
+
+	logfile = fopen(logf_path, "a");
+	if (!logfile) {
+		error(PFX "Error opening logs: %s\n", strerror(errno));
+		err = errno;
+		goto exit;
+	}
+
+	close(STDIN_FILENO);
+	close(STDOUT_FILENO);
+	close(STDERR_FILENO);
+
+	if (ras_init()) {
+		err = -EINVAL;
+		goto cleanup;
+	}
+
+	while (1) {
+
+		if (mmap_read_all(mmaps, nr_cpus, fill_mce_data)) {
+			fprintf(logfile,
+				"Got MCE, cpu: %d, status: 0x%016llx, addr: 0x%016llx\n",
+				m.cpu, m.status, m.addr);
+			fflush(logfile);
+		}
+
+		sleep(30);
+	}
+
+	ras_exit();
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

