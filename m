Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933973Ab2FELAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 07:00:09 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:39566 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671Ab2FELAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 07:00:04 -0400
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jun 2012 07:00:04 EDT
X-AuditID: b753bd60-978eeba000000f6c-e6-4fcde46bbd48
X-AuditID: b753bd60-978eeba000000f6c-e6-4fcde46bbd48
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [RFC PATCH 2/2] ivring: Add a ring-buffer reader tool
To: linux-kernel@vger.kernel.org, Cam Macdonell <cam@cs.ualberta.ca>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Rusty Russell <rusty@rustcorp.com.au>, qemu-devel@nongnu.org,
        systemtap@sourceware.org, yrl.pp-manager.tt@hitachi.com,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, Cam Macdonell <cam@cs.ualberta.ca>,
        qemu-devel@nongnu.org, systemtap@sourceware.org
Date: Tue, 05 Jun 2012 19:50:14 +0900
Message-ID: <20120605105014.15442.67769.stgit@ltc189.sdl.hitachi.co.jp>
In-Reply-To: <20120605104954.15442.62695.stgit@ltc189.sdl.hitachi.co.jp>
References: <20120605104954.15442.62695.stgit@ltc189.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a reader tool for IVRing. This tool is used on a host OS and
reads data written by a guest. This reader reads data from a ring-buffer via
POSIX share memory, so the data will be read without memory copying between
a guest and a host. To read data written by a guest, s option assigning same
shared memory object of IVShmem is needed.

Some options are available as follows:
	-f: output log file
	-h: show usage
	-m: shared memory size in MB
	-s: shared memory object path
	-N: number of log files
	-S: log file size in MB

Example:
	./ivring_reader -m 2 -f /tmp/log.txt -S 10 -N 2 -s /ivshmem
In this case, two log files are output as /tmp/log.txt.0 and /tmp/log.txt.1
whose sizes are 10MB.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: Cam Macdonell <cam@cs.ualberta.ca>
Cc: qemu-devel@nongnu.org
Cc: systemtap@sourceware.org
---

 tools/Makefile                |    1 
 tools/ivshmem/Makefile        |   19 ++
 tools/ivshmem/ivring_reader.c |  516 +++++++++++++++++++++++++++++++++++++++++
 tools/ivshmem/ivring_reader.h |   15 +
 tools/ivshmem/pr_msg.c        |  125 ++++++++++
 tools/ivshmem/pr_msg.h        |   19 ++
 6 files changed, 695 insertions(+), 0 deletions(-)
 create mode 100644 tools/ivshmem/Makefile
 create mode 100644 tools/ivshmem/ivring_reader.c
 create mode 100644 tools/ivshmem/ivring_reader.h
 create mode 100644 tools/ivshmem/pr_msg.c
 create mode 100644 tools/ivshmem/pr_msg.h

diff --git a/tools/Makefile b/tools/Makefile
index 3ae4394..3edf16a 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -5,6 +5,7 @@ help:
 	@echo ''
 	@echo '  cpupower   - a tool for all things x86 CPU power'
 	@echo '  firewire   - the userspace part of nosy, an IEEE-1394 traffic sniffer'
+	@echo '  ivshmem   - the userspace tool for ivshmem device'
 	@echo '  lguest     - a minimal 32-bit x86 hypervisor'
 	@echo '  perf       - Linux performance measurement and analysis tool'
 	@echo '  selftests  - various kernel selftests'
diff --git a/tools/ivshmem/Makefile b/tools/ivshmem/Makefile
new file mode 100644
index 0000000..287508e
--- /dev/null
+++ b/tools/ivshmem/Makefile
@@ -0,0 +1,19 @@
+CC = gcc
+CFLAGS = -O1 -Wall -Werror -g
+LIBS = -lrt
+
+# makefile to build ivshmem tools
+
+all: ivring_reader
+
+.c.o:
+	$(CC) $(CFLAGS) -c $^ -o $@
+
+ivring_reader: ivring_reader.o pr_msg.o
+	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)
+
+install: ivring_reader
+	install ivring_reader /usr/local/bin/
+
+clean:
+	rm -f *.o ivring_reader
diff --git a/tools/ivshmem/ivring_reader.c b/tools/ivshmem/ivring_reader.c
new file mode 100644
index 0000000..d61e9c9
--- /dev/null
+++ b/tools/ivshmem/ivring_reader.c
@@ -0,0 +1,516 @@
+/*
+ * A trace reader for inter-VM shared memory
+ *
+ * (C) 2012 Hitachi, Ltd.
+ * Written by Hitachi Yokohama Research Laboratory.
+ *
+ * Created by Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
+ *            Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
+ *            Yoshihiro Yunomae <yoshihiro.yunomae.ez@hitachi.com>
+ * based on IVShmem Server, http://www.gitorious.org/nahanni/guest-code,
+ *                                   (C) 2009 Cam Macdonell <cam@cs.ualberta.ca>
+ *
+ * Licensed under GPL version 2 only.
+ *
+ */
+
+#include <errno.h>
+#include <string.h>
+#include <sys/types.h>
+#include <unistd.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <sys/eventfd.h>
+#include <sys/mman.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <signal.h>
+#include "../../drivers/ivshmem/ivring.h"
+#include "pr_msg.h"
+#include "ivring_reader.h"
+
+/* default pathes */
+#define DEFAULT_SHM_SIZE (1024*1024)
+#define BUFFER_SIZE 4096
+
+static int global_term;
+static int global_outfd;
+static char *global_log_basename;
+static ssize_t global_log_rotate_size;
+static int global_log_rotate_num;
+#define log_rotate_mode() (global_log_rotate_size && global_log_rotate_num)
+
+/* Handle SIGTERM/SIGINT/SIGQUIT to exit */
+void term_handler(int sig)
+{
+	global_term = sig;
+	pr_info("Receive an interrupt %d\n", sig);
+}
+
+/* Utilities */
+static void *zalloc(size_t size)
+{
+	void *ret = malloc(size);
+	if (ret)
+		memset(ret, 0, size);
+	else
+		pr_perror("malloc");
+	return ret;
+}
+
+static u32 __fls32(u32 word)
+{
+	int num = 31;
+	if (!(word & (~0ul << 16))) {
+		num -= 16;
+		word <<= 16;
+	}
+	if (!(word & (~0ul << (32-8)))) {
+		num -= 8;
+		word <<= 8;
+	}
+	if (!(word & (~0ul << (32-4)))) {
+		num -= 4;
+		word <<= 4;
+	}
+	if (!(word & (~0ul << (32-2)))) {
+		num -= 2;
+		word <<= 2;
+	}
+	if (!(word & (~0ul << (32-1))))
+		num -= 1;
+	return num;
+}
+
+/* IVRing Header functions */
+int ivring_hdr_init(struct ivring_hdr *hdr, u32 shmsize)
+{
+	if (strncmp(hdr->magic, IVRING_MAGIC, 4) == 0) {
+		pr_debug("Ring header is already initialized\n");
+		pr_debug("reader %d, writer %d, pos %llx\n",
+			 (int)hdr->reader, (int)hdr->writer, hdr->pos);
+		if (hdr->version != IVRING_VERSION) {
+			pr_debug("Ring version is different! (%d)\n",
+				(int)hdr->version);
+			return -EINVAL;
+		}
+		return 0;
+	}
+	memset(hdr, 0, IVRING_OFFSET);
+	memcpy(hdr->magic, IVRING_MAGIC, 4);
+	hdr->version = IVRING_VERSION;
+	hdr->reader = -1;
+	hdr->writer = -1;
+	hdr->total_bits = __fls32(shmsize);
+	hdr->total_mask = ~(~0 << hdr->total_bits);
+	hdr->threshold = IVRING_INIT_THRESHOLD;
+	hdr->pos = IVRING_STARTPOS;
+	return 1;
+}
+
+void ivring_hdr_free(struct ivring_hdr *hdr, size_t size)
+{
+	munmap(hdr, size);
+}
+
+struct ivring_hdr *ivring_hdr_new(int shmfd, size_t size)
+{
+	struct ivring_hdr *hdr;
+
+	hdr = mmap(0, size, PROT_READ|PROT_WRITE, MAP_SHARED, shmfd, 0);
+	if (!hdr) {
+		pr_perror("mmap");
+		return NULL;
+	}
+
+	if (ivring_hdr_init(hdr, (u32)size) < 0) {
+		munmap(hdr, size);
+		return NULL;
+	}
+
+	return hdr;
+}
+
+static inline u64 fixup_pos64(u64 pos, u32 total_mask)
+{
+	if (((u32)pos & total_mask) < IVRING_OFFSET)
+		pos += IVRING_OFFSET;
+	return pos;
+}
+
+struct ivring_read_ops {
+	ssize_t (*read)(void *data, void *saddr, ssize_t size);
+	ssize_t (*cancel)(void *data, ssize_t size);
+};
+
+/* Ringbuffer Reader */
+ssize_t __ivring_read(struct ivring_user *ivr, struct ivring_read_ops *ops,
+		      void *data, ssize_t max_size)
+{
+	struct ivring_hdr *hdr = ivr->hdr;
+	void *saddr, *eaddr, *end, *start;
+	u64 rpos;
+	ssize_t read_size;
+
+	if (!hdr)
+		return -EINVAL;
+
+	if (hdr->pos == ivr->rpos) {	/* No data is ready */
+		pr_debug("no data\n");
+		return 0;
+	}
+
+	start = ivring_start_addr(hdr);
+	end = ivring_end_addr(hdr);
+
+	rpos = ivr->rpos;
+	if ((hdr->pos - rpos) >> hdr->total_bits) {
+		/* Writer cought up */
+		rpos = hdr->pos - (1 << hdr->total_bits) + IVRING_READ_MARGIN;
+		rpos = fixup_pos64(rpos, hdr->total_mask);
+		pr_debug("Event drop detected! -- fixup\n");
+		ivr->rpos = rpos;
+	}
+	saddr = ivring_pos64_addr(hdr, rpos);
+
+	rpos = fixup_pos64(rpos + max_size, hdr->total_mask);
+	if (rpos > hdr->pos)
+		rpos = hdr->pos;
+	eaddr = ivring_pos64_addr(hdr, rpos);
+
+	if (saddr < eaddr)
+		read_size = ops->read(data, saddr, eaddr - saddr);
+	else {
+		ssize_t tmp;
+		read_size = ops->read(data, saddr, end - saddr);
+		if (read_size < 0)
+			return read_size;
+		tmp = ops->read(data, start, eaddr - start);
+		if (tmp < 0)
+			return tmp;
+		read_size += tmp;
+	}
+
+	if ((hdr->pos - ivr->rpos) >> hdr->total_bits) {
+		/* Cought up again */
+		pr_debug("Overwritten detected!\n");
+		return ops->cancel(data, read_size);
+	}
+
+	ivr->rpos = rpos;
+	return read_size;
+}
+
+/* Read from ring to memory */
+static ssize_t read_memcpy(void *data, void *saddr, ssize_t size)
+{
+	memcpy(data, saddr, size);
+	return size;
+}
+
+static ssize_t cancel_memcpy(void *data, ssize_t size)
+{
+	return -EAGAIN;
+}
+
+ssize_t ivring_memcpy(struct ivring_user *ivr, void *buf, ssize_t bufsize)
+{
+	ssize_t ret;
+	static struct ivring_read_ops ops = {
+		.read = read_memcpy,
+		.cancel = cancel_memcpy};
+
+	do {
+		ret = __ivring_read(ivr, &ops, buf, bufsize);
+	} while (ret == -EAGAIN);
+	return ret;
+}
+
+/* Read from ring to file */
+static ssize_t read_write_fd(void *data, void *saddr, ssize_t size)
+{
+	int fd = (int)(long)data;
+	return write(fd, saddr, size);
+}
+
+static ssize_t cancel_write_fd(void *data, ssize_t size)
+{
+	int fd = (int)(long)data;
+	lseek(fd, (off_t)-size, SEEK_CUR);
+	return -EAGAIN;
+}
+
+ssize_t ivring_read_fd(struct ivring_user *ivr, int fd, ssize_t blocksize)
+{
+	ssize_t ret;
+	static struct ivring_read_ops ops = {
+		.read = read_write_fd,
+		.cancel = cancel_write_fd};
+
+	do {
+		ret = __ivring_read(ivr, &ops, (void *)(long)fd, blocksize);
+		pr_debug("__ivring_read ret=%d\n", ret);
+	} while (ret == -EAGAIN);
+	return ret;
+}
+
+int ivring_init_rpos(struct ivring_user *ivr)
+{
+	if (ivr->hdr->pos > ivr->shm_size)
+		ivr->rpos = ivr->hdr->pos - ivr->shm_size + IVRING_READ_MARGIN;
+	else
+		ivr->rpos = IVRING_STARTPOS;
+
+	return 0;
+}
+
+int ivring_init_hdr(struct ivring_user *ivr)
+{
+	struct stat st;
+	int ret;
+
+	if (fstat(ivr->shm_fd, &st) < 0) {
+		ret = -errno;
+		pr_perror("fstat");
+		return ret;
+	}
+
+	if (ivr->shm_size != st.st_size) {
+		pr_debug("Given shmem size isn't correct\n");
+		ivr->shm_size = st.st_size;
+	}
+
+	ivr->hdr = ivring_hdr_new(ivr->shm_fd, ivr->shm_size);
+	if (!ivr->hdr)
+		return -EINVAL;
+
+	return ivring_init_rpos(ivr);
+}
+
+void ivring_init(struct ivring_user *ivr)
+{
+	ivr->rpos = IVRING_STARTPOS;
+	ivr->hdr = NULL;
+	ivr->shm_size = 0;
+	ivr->shm_fd = -1;
+	ivr->shm_obj = NULL;
+}
+
+void ivring_cleanup(struct ivring_user *ivr)
+{
+	/* Unmap Buffer */
+	if (ivr->hdr) {
+		ivring_hdr_free(ivr->hdr, ivr->shm_size);
+		ivr->hdr = NULL;
+	}
+
+	if (ivr->shm_fd != -1) {
+		close(ivr->shm_fd);
+		ivr->shm_fd = -1;
+	}
+}
+
+int open_outfd(const char *out_path)
+{
+	int fd;
+
+	fd = open(out_path, O_CREAT | O_TRUNC | O_RDWR,
+			S_IRUSR | S_IWUSR);
+	if (fd < 0)
+		pr_perror("open(out_fd)");
+
+	return fd;
+}
+
+static int rotate_log(void)
+{
+	static int current_log_no;
+	char *new_outpath;
+	int length;
+
+	if (global_outfd > 0)
+		close(global_outfd);
+
+	if (log_rotate_mode()) {
+		/* prepare filename "log_basename.XXXX" */
+		length = strlen(global_log_basename) + 10;
+		new_outpath = (char *)malloc(sizeof(char) * length);
+		if (!new_outpath) {
+			pr_perror("malloc()");
+			exit(EXIT_FAILURE);
+		}
+		snprintf(new_outpath, length, "%s.%d", global_log_basename,
+				current_log_no++ % global_log_rotate_num);
+	} else
+		new_outpath = strdup(global_log_basename);
+
+	global_outfd = open_outfd(new_outpath);
+	if (global_outfd < 0)
+		exit(EXIT_FAILURE);
+
+	free(new_outpath);
+
+	return global_outfd;
+}
+
+static int ivring_read(struct ivring_user *ivr)
+{
+	char buf[BUFFER_SIZE];
+	ssize_t size;
+	static ssize_t total_size;
+
+	pr_debug("Try to read buffer.\n");
+
+	do {
+		if (global_outfd >= 0)
+			size = ivring_read_fd(ivr, global_outfd, BUFFER_SIZE);
+		else
+			size = ivring_memcpy(ivr, buf, BUFFER_SIZE);
+		if (size < 0) {
+			pr_err("Ring buffer read Error %d\n", (int)size);
+			return (int)size;
+		} else
+			total_size += size;
+
+		printf("%s", buf);
+	} while (size > 0);
+
+	if (log_rotate_mode() && total_size > global_log_rotate_size) {
+		global_outfd = rotate_log();
+		total_size = 0;
+	}
+
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	struct ivring_user *ivr;
+
+	set_pr_mode(PR_MODE_STDIO, 1, "ivtrace_reader");
+
+	ivr = zalloc(sizeof(struct ivring_user));
+	if (!ivr)
+		return -ENOMEM;
+	ivring_init(ivr);
+
+	if (parse_args(argc, argv, ivr) < 0)
+		exit(-1);
+
+	ivr->shm_fd = shm_open(ivr->shm_obj, O_RDWR, S_IRWXU|S_IRWXG|S_IRWXO);
+	if (ivr->shm_fd < 0) {
+		pr_err("ivtrace_reader: could not open shared file\n");
+		exit(-1);
+	}
+
+	if (ivr->hdr == NULL && ivr->shm_fd != -1) {
+		if (ivring_init_hdr(ivr) < 0) {
+				pr_debug("hdr init error %d\n");
+				exit(-1);
+		}
+		pr_debug("ivring_init_hdr: %p\n", ivr->hdr);
+	}
+
+	/* Setup signal handlers */
+	signal(SIGTERM, term_handler);
+	signal(SIGINT, term_handler);
+	signal(SIGQUIT, term_handler);
+
+	/* Main Loop */
+	while (!global_term) {
+		int ret;
+
+		sleep(1);
+
+		ret = ivring_read(ivr);
+
+		if (ret < 0) {
+			pr_debug("Exit with an error %d\n", ret);
+			goto out;
+		}
+	}
+out:
+	ivring_cleanup(ivr);
+	free(ivr);
+
+	if (global_outfd >= 0)
+		close(global_outfd);
+	if (global_log_basename)
+		free(global_log_basename);
+
+	return 0;
+}
+
+size_t parse_size(const char *arg)
+{
+	uint64_t value;
+	char *ptr;
+
+	value = strtoul(arg, &ptr, 10);
+	switch (*ptr) {
+	case 0: case 'M': case 'm':
+		value <<= 20;
+		break;
+	case 'G': case 'g':
+		value <<= 30;
+		break;
+	default:
+		pr_err("invalid ram size: %s\n", arg);
+		exit(1);
+	}
+	return (size_t)value;
+}
+
+int parse_args(int argc, char **argv, struct ivring_user *ivr)
+{
+	int c;
+
+	ivr->shm_size = DEFAULT_SHM_SIZE;
+
+	while ((c = getopt(argc, argv, "h:m:f:S:N:s:")) != -1) {
+		switch (c) {
+		/* size of shared memory object */
+		case 'm':
+			ivr->shm_size = parse_size(optarg);
+			break;
+		/* output file */
+		case 'f':
+			if (global_log_basename)
+				free(global_log_basename);
+			global_log_basename = strdup(optarg);
+			break;
+		/* log rotation */
+		case 'S':
+			global_log_rotate_size = atoi(optarg) * 1024 * 1024;
+			break;
+		/* number of log files */
+		case 'N':
+			global_log_rotate_num = atoi(optarg);
+			break;
+		/* name of shared memory object */
+		case 's':
+			ivr->shm_obj = optarg;
+			break;
+		case 'h':
+		default:
+			usage(argv[0]);
+			exit(1);
+		}
+	}
+
+	printf("shared object size: %ld (bytes)\n", (long)ivr->shm_size);
+
+	if (ivr->shm_size == 0 || ivr->shm_obj == NULL)
+		return -1;
+
+	if (global_log_basename)
+		global_outfd = rotate_log();
+
+	return 0;
+}
+
+void usage(char const *prg)
+{
+	fprintf(stderr, "use: %s [-h] [-m <size in MB>] [-f <output>]"\
+		"[-S <log size in MB> [-N <log num>] [-s <shm object>]\n", prg);
+}
diff --git a/tools/ivshmem/ivring_reader.h b/tools/ivshmem/ivring_reader.h
new file mode 100644
index 0000000..10fbf10
--- /dev/null
+++ b/tools/ivshmem/ivring_reader.h
@@ -0,0 +1,15 @@
+#ifndef __IVRING_READER__
+#define __IVRING_READER__
+
+struct ivring_user {
+	size_t	shm_size;	/* shmem size */
+	struct ivring_hdr *hdr;	/* Header */
+	u64	rpos;		/* Read position */
+	int shm_fd;		/* Shared memory fd */
+	char *shm_obj;		/* Shared memory object */
+};
+
+extern void usage(char const *prg);
+extern int parse_args(int argc, char **argv, struct ivring_user *ivr);
+
+#endif
diff --git a/tools/ivshmem/pr_msg.c b/tools/ivshmem/pr_msg.c
new file mode 100644
index 0000000..16347e8
--- /dev/null
+++ b/tools/ivshmem/pr_msg.c
@@ -0,0 +1,125 @@
+#define _GNU_SOURCE
+#include <syslog.h>
+#include <stdio.h>
+#include <string.h>
+#include <stdarg.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include "pr_msg.h"
+
+static void pr_stdout(const char *fmt, ...);
+static void pr_stderr(const char *fmt, ...);
+static void pr_syslog(const char *fmt, ...);
+static void pr_syslog_err(const char *fmt, ...);
+static void pr_file(const char *fmt, ...);
+static void pr_file_err(const char *fmt, ...);
+static void pr_void(const char *fmt, ...);
+
+void (*pr_info)(const char *fmt, ...) = pr_stdout;
+void (*pr_err)(const char *fmt, ...) = pr_stderr;
+void (*pr_debug)(const char *fmt, ...) = pr_void;
+
+static int log_fd;
+char *program;
+
+void set_pr_mode(int mode, int debug, const char *prog)
+{
+	if (program)
+		free(program);
+	program = strdup(prog);
+
+	if (mode == PR_MODE_STDIO) {
+		log_fd = -1;
+		pr_info = pr_stdout;
+		pr_err = pr_stderr;
+	} else if (mode == PR_MODE_SYSLOG) {
+		log_fd = -1;
+		openlog(program, 0, 0);
+		pr_info = pr_syslog;
+		pr_err = pr_syslog_err;
+	} else {
+		log_fd = mode;
+		pr_info = pr_file;
+		pr_err = pr_file_err;
+	}
+	if (debug)
+		pr_debug = pr_info;
+	else
+		pr_debug = pr_void;
+}
+
+#define format_varg(bufp, fmt) \
+	do {va_list ap; va_start(ap, fmt); vasprintf(bufp, fmt, ap); \
+	    va_end(ap); } while (0)
+
+static void pr_stdout(const char *fmt, ...)
+{
+	char *buf;
+
+	format_varg(&buf, fmt);
+
+	fprintf(stdout, "%s", buf);
+
+	free(buf);
+}
+
+static void pr_stderr(const char *fmt, ...)
+{
+	char *buf;
+
+	format_varg(&buf, fmt);
+
+	fprintf(stderr, "Error: %s", buf);
+
+	free(buf);
+}
+
+static void pr_syslog(const char *fmt, ...)
+{
+	char *buf;
+
+	format_varg(&buf, fmt);
+
+	syslog(LOG_INFO, "%s", buf);
+
+	free(buf);
+}
+
+static void pr_syslog_err(const char *fmt, ...)
+{
+	char *buf;
+
+	format_varg(&buf, fmt);
+
+	syslog(LOG_ERR, "Error: %s", buf);
+
+	free(buf);
+}
+
+static void pr_file(const char *fmt, ...)
+{
+	char *buf;
+
+	format_varg(&buf, fmt);
+
+	write(log_fd, buf, strlen(buf));
+
+	free(buf);
+}
+
+static void pr_file_err(const char *fmt, ...)
+{
+	char *buf;
+
+	format_varg(&buf, fmt);
+
+	write(log_fd, "Error: ", 7);
+	write(log_fd, buf, strlen(buf));
+
+	free(buf);
+}
+
+static void pr_void(const char *fmt, ...)
+{
+	/* Do nothing */
+}
diff --git a/tools/ivshmem/pr_msg.h b/tools/ivshmem/pr_msg.h
new file mode 100644
index 0000000..c9a6acf
--- /dev/null
+++ b/tools/ivshmem/pr_msg.h
@@ -0,0 +1,19 @@
+#ifndef __PR_MSG__
+#define __PR_MSG__
+
+#include <errno.h>
+#include <string.h>
+
+#define PR_MODE_STDIO 0
+#define PR_MODE_SYSLOG 1
+#define PR_MODE_FD(fd) (fd)
+
+extern void set_pr_mode(int mode, int debug, const char *prog);
+
+extern void (*pr_info)(const char *fmt, ...);
+extern void (*pr_err)(const char *fmt, ...);
+extern void (*pr_debug)(const char *fmt, ...);
+
+#define pr_perror(msg) pr_err("%s: %s\n", msg, strerror(errno))
+
+#endif

