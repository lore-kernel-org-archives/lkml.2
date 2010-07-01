Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab0GAPy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:54:59 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47059 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757126Ab0GAPyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:54:10 -0400
From: Borislav Petkov <bp@amd64.org>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 21/21] tools, ras: Add a RAS daemon
Date: Thu,  1 Jul 2010 17:56:03 +0200
Message-Id: <1277999763-20357-22-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277999763-20357-1-git-send-email-bp@amd64.org>
References: <1277999763-20357-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/Makefile     |    4 +
 tools/lib/Makefile |    2 +-
 tools/ras/Makefile |   18 ++++++
 tools/ras/rasd.c   |  155 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 178 insertions(+), 1 deletions(-)
 create mode 100644 tools/ras/Makefile
 create mode 100644 tools/ras/rasd.c

diff --git a/tools/Makefile b/tools/Makefile
index 54dea0e..270c027 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -100,11 +100,15 @@ export BASIC_CFLAGS EXTLIBS
 perf: lib .FORCE
 	$(QUIET_SUBDIR0)perf/ $(QUIET_SUBDIR1)
 
+ras: lib .FORCE
+	$(QUIET_SUBDIR0)ras/ $(QUIET_SUBDIR1)
+
 lib: .FORCE
 	$(QUIET_SUBDIR0)lib/ $(QUIET_SUBDIR1)
 
 clean:
 	$(QUIET_SUBDIR0)lib/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)perf/ $(QUIET_SUBDIR1) clean
+	$(QUIET_SUBDIR0)ras/ $(QUIET_SUBDIR1) clean
 
 .PHONY: clean .FORCE
diff --git a/tools/lib/Makefile b/tools/lib/Makefile
index 6f7102b..0786588 100644
--- a/tools/lib/Makefile
+++ b/tools/lib/Makefile
@@ -83,6 +83,6 @@ $(OUTPUT)%.o: %.S
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
 
 clean:
-	$(RM) $(LIB_OBJS)
+	$(RM) $(LIB_OBJS) $(LIBFILE)
 
 .PHONY: clean
diff --git a/tools/ras/Makefile b/tools/ras/Makefile
new file mode 100644
index 0000000..26525e7
--- /dev/null
+++ b/tools/ras/Makefile
@@ -0,0 +1,18 @@
+include ../Makefile.lib
+
+CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
+EXTLIBS += -lpthread -lrt -lelf -lm
+ALL_CFLAGS = $(CFLAGS) $(BASIC_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
+ALL_LDFLAGS = $(LDFLAGS)
+LIBFILE = ../lib/lklib.a
+
+rasd: rasd.o $(LIBFILE)
+	$(QUIET_CC)$(CC) $(ALL_CFLAGS) -o $@ $^ $(EXTLIBS)
+
+%.o: %.c
+	$(QUIET_CC)$(CC) $(ALL_CFLAGS) -c $<
+
+clean:
+	rm -rf *.o rasd
+
+.PHONY: clean
diff --git a/tools/ras/rasd.c b/tools/ras/rasd.c
new file mode 100644
index 0000000..af44e42
--- /dev/null
+++ b/tools/ras/rasd.c
@@ -0,0 +1,155 @@
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
+#include <perf/parse-events.h>
+#include <linux/compiler.h>
+
+#define MMAP_PAGES 128
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
+	set_debugfs_path();
+
+	if (parse_events(NULL, "mce:mce_record", 0)) {
+		error(PFX "Error parsing MCE tracepoint\n");
+		return 1;
+	}
+
+	nr_cpus = read_cpu_map(NULL);
+
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
+		fds[cpu] = sys_perf_event_open(&attrs[0], -1, cpu, -1,
+					       PERF_FLAG_EVENT_PERSISTENT);
+
+		if (fds[cpu] < 0) {
+			error("Error opening perf event on cpu %d\n", cpu);
+			return 1;
+		}
+
+		fcntl(fds[cpu], F_SETFL, O_NONBLOCK);
+	}
+
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
+		mmaps[cpu].prev = 0;
+		mmaps[cpu].mask = MMAP_PAGES*page_size - 1;
+		mmaps[cpu].base = mmap(NULL, (MMAP_PAGES + 1) * page_size,
+				       PROT_READ|PROT_WRITE, MAP_SHARED,
+				       fds[cpu], 0);
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
+	int i;
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
+		if (done)
+			for (i = 0; i < nr_cpus; i++)
+				ioctl(fds[i], PERF_EVENT_IOC_DISABLE);
+
+		sleep(30);
+	}
+
+}
-- 
1.7.1

