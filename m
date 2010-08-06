Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761473Ab0HFO0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 10:26:43 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:40165 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab0HFO0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 10:26:23 -0400
From: Borislav Petkov <bp@amd64.org>
To: <acme@infradead.org>, <fweisbec@gmail.com>, <mingo@elte.hu>,
        <peterz@infradead.org>, <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [RFC PATCH 9/9] tools, ras: Add a RAS daemon
Date: Fri,  6 Aug 2010 16:25:13 +0200
Message-Id: <1281104713-23141-10-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1281104713-23141-1-git-send-email-bp@amd64.org>
References: <1281104713-23141-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/Makefile     |    4 ++
 tools/ras/Makefile |   16 ++++++
 tools/ras/rasd.c   |  144 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 164 insertions(+), 0 deletions(-)
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
index 0000000..3aebe5a
--- /dev/null
+++ b/tools/ras/Makefile
@@ -0,0 +1,16 @@
+include ../scripts/Makefile.lib
+
+CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
+ALL_CFLAGS = $(CFLAGS) $(BASIC_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
+ALL_LDFLAGS = $(LDFLAGS)
+
+RASLIBS=$(LIB_OUTPUT)libparsevent.a $(LIB_OUTPUT)lklib.a $(LIB_OUTPUT)lkperflib.a
+
+rasd: rasd.o $(RASLIBS)
+	$(QUIET_CC)$(CC) $(ALL_CFLAGS) -o $@ $^ $(RASLIBS)
+
+%.o: %.c
+	$(QUIET_CC)$(CC) $(ALL_CFLAGS) -c $<
+
+clean:
+	rm -rf *.o rasd
diff --git a/tools/ras/rasd.c b/tools/ras/rasd.c
new file mode 100644
index 0000000..5bf76cb
--- /dev/null
+++ b/tools/ras/rasd.c
@@ -0,0 +1,144 @@
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
+#include <lk/debugfs.h>
+#include <perf/mmap.h>
+#include <linux/compiler.h>
+
+#define MMAP_PAGES	128
+#define MAX_NR_CPUS	256
+
+#define PFX "rasd: "
+
+static int fds[MAX_NR_CPUS];
+static struct mmap_data mmaps[MAX_NR_CPUS];
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
+static int ras_init(void)
+{
+	int cpu;
+
+	fprintf(stderr, PFX "Starting daemon.");
+
+	page_size = sysconf(_SC_PAGE_SIZE);
+
+	if (get_debugfs_mntpt()) {
+		error(PFX "Cannot mount debugfs, exiting...\n");
+		return 1;
+	}
+
+	nr_cpus = read_cpu_map(NULL);
+
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
+		char path[MAXPATHLEN];
+
+		snprintf(path, MAXPATHLEN, "%s/mce/mce_record%d", debugfs_mntpt, cpu);
+		fds[cpu] = open(path, O_RDONLY, O_NONBLOCK);
+		if (fds[cpu] < 0) {
+			error("Error opening perf event on cpu %d\n", cpu);
+			return 1;
+		}
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
+		if (mmap_read_all(mmaps, nr_cpus, write_output))
+			fprintf(stderr, "Read some mmapped data");
+
+//		if (done)
+//			return 0;
+
+		sleep(30);
+	}
+
+}
-- 
1.7.1

