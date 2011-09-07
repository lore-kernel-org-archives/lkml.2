Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab1IGQk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:40:29 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:10014
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751795Ab1IGQkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:40:24 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LR5VN4-02-27N-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 7/7] perf, x86: Example code for AMD IBS
Date: Wed, 7 Sep 2011 18:36:16 +0200
Message-ID: <1315413376-769-8-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1315413376-769-1-git-send-email-robert.richter@amd.com>
References: <1315413376-769-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes an example to use IBS via perf_event.

usage: ibs [-h]
       ibs ibs_fetch | ibs_op [-s] [-C CPU] [-m BUFFERPAGES] <command>

        <command>
                Command to execute.

        -e CONFIG
                64 bit configuration value, refers to msrs
                IbsFetchCtl (0xC0011030) or IbsOpCtl (0xC0011033).
                The default sample period is set to 100000.

        -c COUNT
                Event period to sample (default: 100000).

        -h
                Print help.

        -s
                system wide profiling (set per default)

        -C CPU
                profile on CPU (not yet implemented)

        -m BUFFERPAGES
                Per-cpu buffer pages to allocate.

V2:
* Updated include header files to fix build errors on some distros.
* Caps field added to sampling format.
* Note: I kept example code for reference, the patch must not be
  applied. I will come up with a sulution that integrates IBS into
  perf-report.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/Documentation/examples/Makefile |   44 +++
 tools/perf/Documentation/examples/ibs.c    |  445 ++++++++++++++++++++++++++++
 2 files changed, 489 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/Documentation/examples/Makefile
 create mode 100644 tools/perf/Documentation/examples/ibs.c

diff --git a/tools/perf/Documentation/examples/Makefile b/tools/perf/Documentation/examples/Makefile
new file mode 100644
index 0000000..cfc9647
--- /dev/null
+++ b/tools/perf/Documentation/examples/Makefile
@@ -0,0 +1,44 @@
+all:	ibs
+
+CFLAGS += -I../..
+CFLAGS += -I../../util/include
+CFLAGS += -DNO_NEWT_SUPPORT
+
+LIB_FILE=../../libperf.a
+
+INSTALL = install
+
+ifeq ("$(origin O)", "command line")
+	OUTPUT := $(O)/
+endif
+
+ifneq ($(OUTPUT),)
+# check that the output directory actually exists
+OUTDIR := $(shell cd $(OUTPUT) && /bin/pwd)
+$(if $(OUTDIR),, $(error output directory "$(OUTPUT)" does not exist))
+endif
+
+ifndef DESTDIR
+prefix = $(HOME)
+endif
+bindir_relative = bin
+bindir = $(prefix)/$(bindir_relative)
+
+DESTDIR_SQ = $(subst ','\'',$(DESTDIR))
+bindir_SQ = $(subst ','\'',$(bindir))
+
+../../libperf.a:
+	$(MAKE) CFLAGS="-DNO_NEWT_SUPPORT" -C ../.. libperf.a
+
+$(OUTPUT)ibs: ibs.c $(LIB_FILE)
+	$(CC) $(CFLAGS) $^ -o $@
+
+clean:
+	$(MAKE) -C ../.. clean
+	$(RM) ibs
+
+install: all
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
+	$(INSTALL) $(OUTPUT)ibs '$(DESTDIR_SQ)$(bindir_SQ)'
+
+.PHONY:	all clean install
diff --git a/tools/perf/Documentation/examples/ibs.c b/tools/perf/Documentation/examples/ibs.c
new file mode 100644
index 0000000..e4ad012
--- /dev/null
+++ b/tools/perf/Documentation/examples/ibs.c
@@ -0,0 +1,445 @@
+/*
+ * IBS sampling example
+ *
+ *  Copyright (C) 2011 Advanced Micro Devices, Inc., Robert Richter
+ *
+ * Sample code that attaches an event to a specified PMU.
+ *
+ * Compiling:
+ *
+ *  $ cd linux         # Linux kernel source dir
+ *  $ make -C tools/perf/Documentation/examples ibs
+ *
+ * Running:
+ *
+ *  $ ./ibs ibs_fetch -s -m 256 <command>
+ *
+ */
+
+#include <errno.h>
+#include <fcntl.h>
+#include <string.h>
+#include <stdio.h>
+#include <poll.h>
+#include <stdlib.h>
+#include <sys/ptrace.h>
+#include <signal.h>
+#include <setjmp.h>
+#include <inttypes.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+
+#include "util/evsel.h"
+#include "util/evlist.h"
+#include "util/cpumap.h"
+#include "util/thread_map.h"
+
+struct perf_config {
+	uint64_t	config;
+	uint64_t	sample_period;
+	char		*sysfs;
+	int		pid;
+	int		cpu;
+	int		mmap_pages;
+	char		**argv;
+};
+
+static uint64_t collected_samples, lost_samples, sum_period;
+
+static void usage(void)
+{
+	printf(
+"usage: ibs [-h]\n"
+"       ibs ibs_fetch | ibs_op [-s] [-C CPU] [-m BUFFERPAGES] <command>\n"
+"\n"
+"        <command>\n"
+"                Command to execute.\n"
+"\n"
+"        -e CONFIG\n"
+"                64 bit configuration value, refers to msrs\n"
+"                IbsFetchCtl (0xC0011030) or IbsOpCtl (0xC0011033).\n"
+"                The default sample period is set to 100000.\n"
+"\n"
+"        -c COUNT\n"
+"                Event period to sample (default: 100000).\n"
+"\n"
+"        -h\n"
+"                Print help.\n"
+"\n"
+"        -s\n"
+"                system wide profiling (set per default)\n"
+"\n"
+"        -C CPU\n"
+"                profile on CPU (not yet implemented)\n"
+"\n"
+"        -m BUFFERPAGES\n"
+"                Per-cpu buffer pages to allocate.\n"
+);
+	exit(0);
+}
+
+#define IBS_FETCH_DEFAULT	((1ULL<<57)|(100000ULL>>4))
+#define IBS_OP_DEFAULT		((0ULL<<19)|(100000ULL>>4))
+
+#define IBS_MAX_CNT		0x0000FFFFULL
+
+#define IBS_FETCH_SYSFS "/sys/bus/event_source/devices/ibs_fetch/type"
+#define IBS_OP_SYSFS    "/sys/bus/event_source/devices/ibs_op/type"
+
+static int ibs_config(struct perf_config *config, int argc, char **argv)
+{
+	int c;
+
+	memset(config, 0, sizeof(*config));
+	config->pid = -1;	/* support for system wide profiling only */
+	config->cpu = -1;
+	config->mmap_pages = 1; /* need buffer for ibs */
+
+	c = getopt(argc, argv,"+h");
+	if (c != -1 || !argv[optind]) {
+		usage();
+		exit(0);
+	}
+
+	if (!strcmp(argv[optind], "ibs_fetch")) {
+		config->sysfs  = IBS_FETCH_SYSFS;
+		config->config = IBS_FETCH_DEFAULT;
+	} else if (!strcmp(argv[optind], "ibs_op")) {
+		config->sysfs  = IBS_OP_SYSFS;
+		config->config = IBS_OP_DEFAULT;
+	} else {
+		errx(1, "specify ibs_fetch or ibs_op\n");
+	}
+
+	optind++;
+
+	while (1) {
+		c = getopt(argc, argv,"+he:c:sC:m:v");
+		if (c == -1)
+			break;
+		switch (c) {
+		case 'h':
+			usage();
+			exit(0);
+		case 'e':
+			/* event configuration */
+			config->config = atoll(optarg);
+			break;
+		case 'c':
+			/* sample period */
+			config->sample_period = atoll(optarg);
+			config->config &= ~IBS_MAX_CNT;
+			if (!config->sample_period)
+				errx(1, "invalid sample period");
+			break;
+		case 's':
+			/* system wide profiling */
+			if (config->pid)
+				break;
+			config->pid = -1;
+			config->cpu = -1;
+			break;
+		case 'C':
+			/* profile cpu */
+			config->pid = -1;
+			config->cpu = atoi(optarg);
+			break;
+		case 'm':
+			config->mmap_pages = atoi(optarg);
+			break;
+		default:
+			errx(1, "unknown option");
+		}
+	}
+
+	if (!argv[optind])
+		errx(1, "you must specify a command to execute\n");
+
+	config->argv = argv + optind;
+
+	if (config->mmap_pages > 1 && ((config->mmap_pages) & 0x1))
+		errx(1, "number of pages must be power of 2\n");
+
+	return 0;
+}
+
+#define BUFSIZ_ATOI	32
+
+static int get_pmu_type(char *sysfs)
+{	int pmu, ret = 0;
+	char buf[BUFSIZ_ATOI];
+	size_t size;
+
+	pmu = open(sysfs, O_RDONLY);
+	if (pmu == -1)
+		return -errno;
+	size = read(pmu, buf, BUFSIZ - 1);
+	if (size < 0)
+		ret = -errno;
+	close(pmu);
+
+	if (ret)
+		return ret;
+
+	buf[size] = '0';
+
+	return atoi(buf);
+}
+
+static volatile int done = 0;
+
+static void cld_handler(int n)
+{
+	done = 1;
+}
+
+static int child(char **arg)
+{
+	ptrace(PTRACE_TRACEME, 0, NULL, NULL);
+	execvp(arg[0], arg);
+	return -1;
+}
+
+struct ibs_data {
+	uint32_t caps;
+	uint64_t regs[0];
+} __attribute__ ((packed));
+
+static void print_ibs_fetch(int cpu, struct ibs_data *__ibs)
+{
+	uint64_t *ibs = __ibs->regs;
+	printf("IBS_fetch sample on cpu%d\tIBS0: 0x%016"PRIx64" IBS1: 0x%016"PRIx64" IBS2:0x%016"PRIx64"\n",
+	       cpu, ibs[0], ibs[1], ibs[2]);
+}
+
+static void print_ibs_op(int cpu, struct ibs_data *__ibs)
+{
+	uint64_t *ibs = __ibs->regs;
+	printf("IBS_OP sample on cpu%d\t"
+	       "\t IBS0: 0x%016"PRIx64" IBS1: 0x%016"PRIx64" IBS2: 0x%016"PRIx64"\n"
+	        "\tIBS3: 0x%016"PRIx64" IBS4: 0x%016"PRIx64" IBS5: 0x%016"PRIx64" IBS6: 0x%016"PRIx64"\n",
+	       cpu, ibs[0], ibs[1], ibs[2], ibs[3], ibs[4], ibs[5], ibs[6]);
+}
+
+#define MSR_AMD64_IBSFETCH_SIZE		3
+#define MSR_AMD64_IBSOP_SIZE		7
+
+static int print_ibs(struct perf_sample *sample)
+{
+	switch (sample->raw_size >> 3) {
+	case MSR_AMD64_IBSFETCH_SIZE:
+		print_ibs_fetch(sample->cpu, sample->raw_data);
+		return 0;
+	case MSR_AMD64_IBSOP_SIZE:
+		print_ibs_op(sample->cpu, sample->raw_data);
+		return 0;
+	default:
+		printf("invalid: raw_size = %d, p = %p\n",
+		       sample->raw_size, (u64*)sample->raw_data);
+		return -EINVAL;
+	}
+}
+
+static void print_event(union perf_event *event)
+{
+	int idx, size = event->sample.header.size;
+	u64 *val = event->sample.array;
+
+	printf("unrecognized event, type = %d, size = %d, header = 0x%016"PRIx64":\n",
+	       event->sample.header.type, size, *(u64*)&event->sample.header);
+
+	for (idx = 1; size > 0; idx++, size -= 8) {
+		printf(" 0x%016"PRIx64, *val++);
+		if (!(idx % 8))
+			printf("\n");
+	}
+	printf("\n");
+}
+
+static int ibs_run(struct perf_config *config)
+{
+	struct perf_event_attr attr;
+	struct perf_sample sample;
+	struct perf_evsel *evsel = NULL;
+	struct perf_evlist *evlist = NULL;
+	struct cpu_map *cpus = NULL;
+	struct thread_map *threads = NULL;
+	struct perf_evsel *pos, *n;
+	union perf_event *event;
+	pid_t pid = config->pid;
+	char cpu_list[8];
+	int type, idx, status, ready = 0;
+	int ret = -ENOMEM;
+	static uint64_t ovfl_count; /* static to avoid setjmp issue */
+
+	type = get_pmu_type(config->sysfs);
+	if (type < 0) {
+		fprintf(stderr, "Failed to get pmu type: %d\n", type);
+		return type;
+	}
+
+	memset(&attr, 0, sizeof(attr));
+	attr.type = type;
+	attr.sample_type   = PERF_SAMPLE_CPU | PERF_SAMPLE_RAW;
+	attr.sample_period = config->sample_period;
+	attr.config        = config->config;
+
+	evsel = perf_evsel__new(&attr, 0);
+
+	if (config->cpu == -1) {
+		cpus = cpu_map__new(NULL);
+	} else {
+		snprintf(cpu_list, sizeof(cpu_list), "%d", config->cpu);
+		cpus = cpu_map__new(cpu_list);
+	}
+
+	threads = thread_map__new(pid, pid);
+
+	evlist = perf_evlist__new(cpus, threads);
+
+	if (!evsel || !evlist || !cpus || !threads)
+		goto out;
+
+	ret = perf_evsel__alloc_counts(evsel, cpus->nr);
+	if (ret < 0)
+		goto out;
+
+	perf_evlist__add(evlist, evsel);
+
+	list_for_each_entry(pos, &evlist->entries, node) {
+		if (perf_evsel__open(pos, evlist->cpus, evlist->threads, 0) < 0) {
+			ret = -errno;
+			fprintf(stderr, "cannot open events, %d\n", ret);
+			goto out;
+		}
+	}
+
+	if (perf_evlist__mmap(evlist, config->mmap_pages, false) < 0) {
+		ret = -errno;
+		fprintf(stderr, "failed to mmap with %d (%s)\n",
+			ret, strerror(ret));
+		goto out;
+	}
+
+	/*
+	 * Create the child task
+	 */
+	if ((pid=fork()) == -1) {
+		ret = -errno;
+		fprintf(stderr, "cannot fork process\n");
+		goto out;
+	}
+
+	if (pid == 0)
+		exit(child(config->argv));
+
+	/*
+	 * wait for the child to exec
+	 */
+	ret = waitpid(pid, &status, WUNTRACED);
+	if (ret == -1)
+		err(1, "waitpid failed");
+
+	if (WIFEXITED(status))
+		errx(1, "task %s [%d] exited already status %d\n",
+		     config->argv[0], pid, WEXITSTATUS(status));
+
+	/*
+	 * effectively activate monitoring
+	 */
+	ptrace(PTRACE_DETACH, pid, NULL, 0);
+
+	signal(SIGCHLD, cld_handler);
+
+	/*
+	 * core loop
+	 */
+	for (ret = 0; !ret; ) {
+		if (done && ready)
+			break;
+		ready = done;
+
+		ret = poll(evlist->pollfd, evlist->nr_fds, done ? 0 : -1);
+
+		if (ret > 0) {
+			ovfl_count += ret;
+		} else if (ret < 0) {
+			ret = -errno;
+			if (ret != -EINTR)
+				break;
+			ret = 0;
+		}
+
+		list_for_each_entry(pos, &evlist->entries, node) {
+			if (ret < 0)
+				break;
+			ret = __perf_evsel__read(pos, evlist->cpus->nr,
+						 evlist->threads->nr, false);
+		}
+
+		for (idx = 0; !ret, idx < evlist->nr_fds; idx++) {
+			if (done)
+				ioctl(evlist->pollfd[idx].fd,
+				      PERF_EVENT_IOC_DISABLE);
+			while (event = perf_evlist__mmap_read(evlist, idx)) {
+				ready = 0;
+				ret = perf_event__parse_sample(event,
+							       evsel->attr.sample_type,
+							       perf_evsel__sample_size(evsel),
+							       false, &sample);
+				if (ret)
+					break;
+				collected_samples++;
+				if (print_ibs(&sample))
+					print_event(event);
+			}
+		}
+	}
+
+	/*
+	 * cleanup child
+	 */
+	waitpid(pid, &status, 0);
+
+	printf("%"PRIu64" samples collected in %"PRIu64" poll events, %"PRIu64" lost samples\n",
+		collected_samples, ovfl_count, lost_samples);
+	if (collected_samples)
+		printf("avg period=%"PRIu64"\n", sum_period / collected_samples);
+out:
+	if (evlist) {
+		perf_evlist__munmap(evlist);
+		list_for_each_entry_safe(pos, n, &evlist->entries, node) {
+			perf_evsel__close_fd(pos, evlist->cpus->nr,
+					     evlist->threads->nr);
+			list_del(&pos->node);
+		}
+		free(evsel->counts);
+		evsel->counts = NULL;
+		perf_evlist__delete_maps(evlist);
+		cpus = NULL;
+		threads = NULL;
+	}
+	free(evsel);
+	free(evlist);
+	free(cpus);
+	free(threads);
+
+	return ret;
+}
+
+int main(int argc, char **argv)
+{
+	struct perf_config config;
+	int ret;
+
+	ret = ibs_config(&config, argc, argv);
+	if (ret)
+		goto fail;
+	ret = ibs_run(&config);
+	if (ret)
+		goto fail;
+	return 0;
+fail:
+	printf("An error occurred: %d (%s)\n", -ret, strerror(-ret));
+	return -1;
+}
-- 
1.7.6.1


