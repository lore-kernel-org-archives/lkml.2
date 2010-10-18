Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab0JRQWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 12:22:09 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:40901 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335Ab0JRQWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 12:22:07 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zzbb2cK1432N98dNb3c9mzz1202hzz8275bh8275dh8275chz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0LAHUR8-01-OIC-02
X-M-MSG: 
Date: Mon, 18 Oct 2010 18:21:09 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@googlemail.com>,
        "Mark W. Krentel" <krentel@cs.rice.edu>, Xu Liu <xl10@rice.edu>
CC: <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, <perfmon2-devel@lists.sourceforge.net>,
        John Mellor-Crummey <johnmc@cs.rice.edu>
Subject: [PATCH] libpfm4: perf_event example code for AMD IBS
Message-ID: <20101018162109.GL5969@erda.amd.com>
References: <1271335221-18601-1-git-send-email-robert.richter@amd.com>
 <1271335221-18601-4-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1271335221-18601-4-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.04.10 14:40:21, Robert Richter wrote:
> This patch includes an example to use IBS via perf_event. It is for
> the kernel patches I sent some days ago:
> 
>  http://lkml.org/lkml/2010/4/13/336
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <peterz@infradead.org
> Cc: linux-kernel@vger.kernel.org
> LKML-Reference: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
> Signed-off-by: Robert Richter <robert.richter@amd.com>

For those interested in, see my updated version below for current
libpfm4 and my latest perf-ibs patches:

 git://perfmon2.git.sourceforge.net/gitroot/perfmon2/libpfm4 master
 fc4727f Add CONFIG_PFMLIB_NOPYTHON to disable building python directory

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git perf-ibs
 85a1e6a perf, x86: implement the ibs interrupt handler

-Robert

--

>From 7a423ba97a645e0183eec52ddbec9453341ee88f Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Thu, 15 Apr 2010 13:54:02 +0200
Subject: [PATCH] libpfm4: perf_event example code for AMD IBS

This patch includes an example to use IBS via perf_event. It is for
the kernel patches I sent some days ago:

 http://lkml.org/lkml/2010/4/13/336

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
LKML-Reference: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 include/perfmon/perf_event.h |    5 +-
 perf_examples/x86/Makefile   |    2 +-
 perf_examples/x86/ibs_smpl.c |  675 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 680 insertions(+), 2 deletions(-)
 create mode 100644 perf_examples/x86/ibs_smpl.c

diff --git a/include/perfmon/perf_event.h b/include/perfmon/perf_event.h
index bb1b343..8e1d14b 100644
--- a/include/perfmon/perf_event.h
+++ b/include/perfmon/perf_event.h
@@ -222,7 +222,10 @@ struct perf_event_attr {
 		uint32_t	wakeup_watermark;	/* bytes before wakeup */
 	} SWIG_NAME(wakeup);
 
-	uint32_t        bp_type;
+	union {
+		uint32_t        bp_type;
+		uint32_t        raw_type;
+	};
 	uint64_t        bp_addr;
 	uint64_t        bp_len;
 };
diff --git a/perf_examples/x86/Makefile b/perf_examples/x86/Makefile
index 7a0e805..e2ebecb 100644
--- a/perf_examples/x86/Makefile
+++ b/perf_examples/x86/Makefile
@@ -36,7 +36,7 @@ TARGETS=
 
 ifeq ($(SYS),Linux)
 LPC_UTILS=../perf_util.o
-TARGETS += bts_smpl
+TARGETS += bts_smpl ibs_smpl
 endif
 
 EXAMPLESDIR=$(DOCDIR)/perf_examples/x86
diff --git a/perf_examples/x86/ibs_smpl.c b/perf_examples/x86/ibs_smpl.c
new file mode 100644
index 0000000..4059dbb
--- /dev/null
+++ b/perf_examples/x86/ibs_smpl.c
@@ -0,0 +1,675 @@
+/*
+ * ibs_smpl.c - IBS samping example
+ *
+ * Copyright (c) 2010 Google, Inc
+ * Contributed by Stephane Eranian <eranian@gmail.com>
+ * Copyright (C) 2010 Advanced Micro Devices, Inc., Robert Richter
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to deal
+ * in the Software without restriction, including without limitation the rights
+ * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
+ * of the Software, and to permit persons to whom the Software is furnished to do so,
+ * subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in all
+ * copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
+ * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
+ * PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
+ * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
+ * CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
+ * OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
+ */
+#include <sys/types.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdarg.h>
+#include <unistd.h>
+#include <errno.h>
+#include <string.h>
+#include <signal.h>
+#include <getopt.h>
+#include <setjmp.h>
+#include <sys/ptrace.h>
+#include <sys/wait.h>
+#include <sys/poll.h>
+#include <sys/mman.h>
+#include <err.h>
+
+#include "perf_util.h"
+#include "../lib/pfmlib_priv.h"
+
+#define MAX_CPU		64
+
+struct perf_event_config {
+	int			pid;
+	int			cpu;
+	int			mmap_pages;
+	char			**argv;
+};
+
+struct perf_event_context {
+	pid_t			pid;
+	int			cpu;
+	int			group_fd;
+	unsigned long		flags;
+	perf_event_desc_t	desc;
+};
+
+struct perf_event_handle {
+	struct perf_event_config	config;
+	int				num_cpus, cpu_min, cpu_max;
+	size_t				map_size;
+	struct perf_event_context	ctx[MAX_CPU];
+	struct pollfd			fds[MAX_CPU];
+};
+
+static struct perf_event_handle ibs_handle;
+
+static jmp_buf jbuf;
+static uint64_t collected_samples, lost_samples;
+static uint64_t sum_period;
+
+static struct option the_options[]={
+	{ "help", 0, 0,  1},
+	{ 0, 0, 0, 0}
+};
+
+static void
+cld_handler(int n)
+{
+	longjmp(jbuf, 1);
+}
+
+int
+child(char **arg)
+{
+	/*
+	 * force the task to stop before executing the first
+	 * user level instruction
+	 */
+	ptrace(PTRACE_TRACEME, 0, NULL, NULL);
+
+	execvp(arg[0], arg);
+	/* not reached */
+	return -1;
+}
+
+#define MSR_AMD64_IBSFETCH_SIZE		3
+#define MSR_AMD64_IBSOP_SIZE		7
+#define MSR_AMD64_IBS_SIZE_MAX		MSR_AMD64_IBSOP_SIZE
+
+static void display_ibs_fetch(uint64_t *ibs)
+{
+	printf("\tIBS0: 0x%016"PRIx64" IBS1: 0x%016"PRIx64" IBS2:0x%016"PRIx64,
+	       ibs[0], ibs[1], ibs[2]);
+}
+
+static void display_ibs_op(uint64_t *ibs)
+{
+	printf("\tIBS0: 0x%016"PRIx64" IBS1: 0x%016"PRIx64" IBS2:0x%016"PRIx64"\n"
+	       "\tIBS3: 0x%016"PRIx64" IBS4: 0x%016"PRIx64" IBS5:0x%016"PRIx64"\n"
+	       "\tIBS6: 0x%016"PRIx64,
+	       ibs[0], ibs[1], ibs[2], ibs[3], ibs[4], ibs[5], ibs[6]);
+}
+
+static void display_ibs(uint64_t *ibs, size_t sz)
+{
+	if (sz == MSR_AMD64_IBSFETCH_SIZE)
+		display_ibs_fetch(ibs);
+	else
+		display_ibs_op(ibs);
+}
+
+static size_t handle_raw_ibs(perf_event_desc_t *hw)
+{
+	uint64_t ibs_sample[MSR_AMD64_IBS_SIZE_MAX];
+	size_t sz = 0;
+	uint32_t raw_sz, dummy;
+	int ret;
+
+	ret = perf_read_buffer_32(hw->buf, hw->pgmsk, &raw_sz);
+	sz += sizeof(raw_sz);
+	if (ret)
+		errx(1, "cannot read raw size");
+
+	raw_sz -= sizeof(raw_sz); /* substract padding data at the end */
+	if (raw_sz >= MSR_AMD64_IBS_SIZE_MAX * sizeof(uint64_t))
+		errx(1, "unexpected sample size");;
+
+	ret = perf_read_buffer(hw->buf, hw->pgmsk, ibs_sample, raw_sz);
+	if (ret)
+		errx(1, "cannot read raw data");
+
+	ret = perf_read_buffer_32(hw->buf, hw->pgmsk, &dummy);
+	sz += sizeof(raw_sz);
+	if (ret)
+		errx(1, "cannot read dummy");
+
+	display_ibs(ibs_sample, raw_sz / sizeof(uint64_t));
+
+	return sz + raw_sz;
+}
+
+/*
+ * sz = sample payload size
+ */
+static void
+display_sample(perf_event_desc_t *hw, struct perf_event_header *ehdr)
+{
+	struct { uint32_t pid, tid; } pid;
+	struct { uint64_t value, id; } grp;
+	uint64_t time_enabled, time_running;
+	size_t sz;
+	uint64_t type;
+	uint64_t val64;
+	char *str;
+	int ret;
+
+	sz = ehdr->size - sizeof(*ehdr);
+
+	type = hw->hw.sample_type;
+
+	collected_samples++;
+	printf("%4"PRIu64" ", collected_samples);
+	/*
+	 * the sample_type information is laid down
+	 * based on the PERF_RECORD_SAMPLE format specified
+	 * in the perf_event.h header file.
+	 * That order is different from the enum perf_event_sample_format
+	 */
+	if (type & PERF_SAMPLE_IP) {
+		ret = perf_read_buffer_64(hw->buf, hw->pgmsk, &val64);
+		if (ret)
+			errx(1, "cannot read IP");
+
+		sz -= sizeof(val64);
+	}
+
+	if (type & PERF_SAMPLE_TID) {
+		ret = perf_read_buffer(hw->buf, hw->pgmsk, &pid, sizeof(pid));
+		if (ret)
+			errx(1, "cannot read PID");
+
+		printf("PID:%d TID:%d ", pid.pid, pid.tid);
+		sz -= sizeof(pid);
+	}
+
+	if (type & PERF_SAMPLE_TIME) {
+		ret = perf_read_buffer_64(hw->buf, hw->pgmsk, &val64);
+		if (ret)
+			errx(1, "cannot read time");
+
+		printf("TIME:%"PRIu64" ", val64);
+		sz -= sizeof(val64);
+	}
+
+	if (type & PERF_SAMPLE_ADDR) {
+		ret = perf_read_buffer_64(hw->buf, hw->pgmsk, &val64);
+		if (ret)
+			errx(1, "cannot read addr");
+
+		printf("ADDR:%"PRIu64" ", val64);
+		sz -= sizeof(val64);
+	}
+
+	if (type & PERF_SAMPLE_ID) {
+		ret = perf_read_buffer_64(hw->buf, hw->pgmsk, &val64);
+		if (ret)
+			errx(1, "cannot read id");
+
+		printf("ID:%"PRIu64" ", val64);
+		sz -= sizeof(val64);
+	}
+
+	if (type & PERF_SAMPLE_STREAM_ID) {
+		ret = perf_read_buffer_64(hw->buf, hw->pgmsk, &val64);
+		if (ret)
+			errx(1, "cannot read stream_id");
+
+		printf("STREAM_ID:%"PRIu64" ", val64);
+		sz -= sizeof(val64);
+	}
+
+	if (type & PERF_SAMPLE_CPU) {
+		struct { uint32_t cpu, res; } cpu;
+		ret = perf_read_buffer(hw->buf, hw->pgmsk, &cpu, sizeof(cpu));
+		if (ret)
+			errx(1, "cannot read cpu");
+
+		printf("CPU:%u CPU_RES:%u ", cpu.cpu, cpu.res);
+		sz -= sizeof(cpu);
+	}
+
+	if (type & PERF_SAMPLE_PERIOD) {
+		ret = perf_read_buffer_64(hw->buf, hw->pgmsk, &val64);
+		if (ret)
+			errx(1, "cannot read period");
+
+		printf("PERIOD:%"PRIu64" ", val64);
+		sz -= sizeof(val64);
+		sum_period += val64;
+	}
+
+	/*
+	 *      { u64           nr;
+	 *        { u64         time_enabled; } && PERF_FORMAT_ENABLED
+	 *        { u64         time_running; } && PERF_FORMAT_RUNNING
+	 *        { u64         value;
+	 *          { u64       id;           } && PERF_FORMAT_ID
+	 *        }             cntr[nr];
+	 */
+	if (type & PERF_SAMPLE_READ) {
+		uint64_t nr;
+
+		ret = perf_read_buffer_64(hw->buf, hw->pgmsk, &nr);
+		if (ret)
+			errx(1, "cannot read nr");
+
+		sz -= sizeof(nr);
+
+		time_enabled = time_running = 1;
+
+		ret = perf_read_buffer_64(hw->buf, hw->pgmsk, &time_enabled);
+		if (ret)
+			errx(1, "cannot read timing info");
+
+		sz -= sizeof(time_enabled);
+
+		ret = perf_read_buffer_64(hw->buf, hw->pgmsk, &time_running);
+		if (ret)
+			errx(1, "cannot read timing info");
+
+		sz -= sizeof(time_running);
+
+		printf("ENA=%"PRIu64" RUN=%"PRIu64" NR=%"PRIu64"\n", time_enabled, time_running, nr);
+
+		while(nr--) {
+			ret = perf_read_buffer(hw->buf, hw->pgmsk, &grp, sizeof(grp));
+			if (ret)
+				errx(1, "cannot read grp");
+
+			sz -= sizeof(grp);
+
+			str = "unknown sample event";
+
+			if (time_running)
+				grp.value = grp.value * time_enabled / time_running;
+
+			printf("\t%"PRIu64" %s (%"PRIu64"%s)\n",
+				grp.value, str,
+				grp.id,
+				time_running != time_enabled ? ", scaled":"");
+
+		}
+	}
+
+	if (type & PERF_SAMPLE_CALLCHAIN) {
+		uint64_t nr, ip;
+
+		ret = perf_read_buffer_64(hw->buf, hw->pgmsk, &nr);
+		if (ret)
+			errx(1, "cannot read callchain nr");
+
+		sz -= sizeof(nr);
+
+		while(nr--) {
+			ret = perf_read_buffer_64(hw->buf, hw->pgmsk, &ip);
+			if (ret)
+				errx(1, "cannot read ip");
+
+			sz -= sizeof(ip);
+
+			printf("\t0x%"PRIx64"\n", ip);
+		}
+	}
+
+	if (type & PERF_SAMPLE_RAW) {
+		ret = handle_raw_ibs(hw);
+		sz -= ret;
+	}
+	/*
+	 * if we have some data left, it is because there is more
+	 * than what we know about. In fact, it is more complicated
+	 * because we may have the right size but wrong layout. But
+	 * that's the best we can do.
+	 */
+	if (sz) {
+		warnx("did not correctly parse sample leftover=%zu", sz);
+		perf_skip_buffer(hw->buf, sz);
+	}
+
+	putchar('\n');
+}
+
+static void
+display_lost(perf_event_desc_t *hw)
+{
+	struct { uint64_t id, lost; } lost;
+	char *str;
+	int ret;
+
+	ret = perf_read_buffer(hw->buf, hw->pgmsk, &lost, sizeof(lost));
+	if (ret)
+		errx(1, "cannot read lost info");
+
+	str = "unknown lost event";
+
+	printf("<<<LOST %"PRIu64" SAMPLES FOR EVENT %s>>>\n", lost.lost, str);
+	lost_samples += lost.lost;
+}
+
+static void
+display_exit(perf_event_desc_t *hw)
+{
+	struct { pid_t pid, ppid, tid, ptid; } grp;
+	int ret;
+
+	ret = perf_read_buffer(hw->buf, hw->pgmsk, &grp, sizeof(grp));
+	if (ret)
+		errx(1, "cannot read exit info");
+
+	printf("[%d] exited\n", grp.pid);
+}
+
+static void
+display_freq(int mode, perf_event_desc_t *hw)
+{
+	struct { uint64_t time, id, stream_id; } thr;
+	int ret;
+
+	ret = perf_read_buffer(hw->buf, hw->pgmsk, &thr, sizeof(thr));
+	if (ret)
+		errx(1, "cannot read throttling info");
+
+	printf("%s value=%"PRIu64" event ID=%"PRIu64"\n", mode ? "Throttled" : "Unthrottled", thr.id, thr.stream_id);
+}
+
+static void
+process_smpl_buf(perf_event_desc_t *hw)
+{
+	struct perf_event_header ehdr;
+	int ret;
+
+	for(;;) {
+		ret = perf_read_buffer(hw->buf, hw->pgmsk, &ehdr, sizeof(ehdr));
+		if (ret)
+			return; /* nothing to read */
+
+		switch(ehdr.type) {
+			case PERF_RECORD_SAMPLE:
+				display_sample(hw, &ehdr);
+				break;
+			case PERF_RECORD_EXIT:
+				display_exit(hw);
+				break;
+			case PERF_RECORD_LOST:
+				display_lost(hw);
+				break;
+			case PERF_RECORD_THROTTLE:
+				display_freq(1, hw);
+				break;
+			case PERF_RECORD_UNTHROTTLE:
+				display_freq(0, hw);
+				break;
+			default:
+				printf("unknown sample type %d\n", ehdr.type);
+				perf_skip_buffer(hw->buf, ehdr.size);
+		}
+	}
+}
+
+static int
+perf_event_handle_setup(struct perf_event_handle *handle, struct perf_event_attr *hw)
+{
+	int cpu, fd, i;
+	size_t pgsz, pgmsk;
+	struct perf_event_context *ctx;
+	struct perf_event_config *config = &handle->config;
+
+	hw->size = sizeof(struct perf_event_attr);
+	if (config->mmap_pages) {
+		pgsz     = sysconf(_SC_PAGESIZE);
+		handle->map_size = (config->mmap_pages + 1) * pgsz;
+		/* does not include header page */
+		pgmsk    = config->mmap_pages * pgsz - 1;
+
+		hw->wakeup_watermark = (config->mmap_pages * pgsz) / 2;
+		hw->watermark        = 1;
+	}
+
+	__pfm_vbprintf("PERF[type=%x val=0x%"PRIx64" e_u=%d e_k=%d e_hv=%d]\n",
+		       hw->type,
+		       hw->config,
+		       hw->exclude_user,
+		       hw->exclude_kernel,
+		       hw->exclude_hv
+		);
+
+	if (config->pid != -1)
+		return PFM_ERR_NOTSUPP;
+
+	if (config->cpu == -1) {
+		handle->num_cpus = sysconf(_SC_NPROCESSORS_ONLN);
+		handle->cpu_min = 0;
+		handle->cpu_max = handle->num_cpus - 1;
+	} else {
+		handle->num_cpus = 1;
+		handle->cpu_min = handle->cpu_max = config->cpu;
+	}
+
+	for (cpu = handle->cpu_min, i = 0; cpu <= handle->cpu_max; cpu++) {
+		printf("setting up counter on cpu #%d\n", cpu);
+		ctx = &handle->ctx[cpu];
+		ctx->desc.hw   = *hw;
+		ctx->cpu       = cpu;
+		ctx->pid       = config->pid;
+		ctx->group_fd  = -1;
+		ctx->flags     = 0;
+		fd = perf_event_open(&ctx->desc.hw, ctx->pid, ctx->cpu,
+				     ctx->group_fd, ctx->flags);
+		if (fd == -1)
+			err(1, "cannot attach event");
+
+		if (handle->map_size) {
+			ctx->desc.buf = mmap(NULL, handle->map_size,
+					     PROT_READ | PROT_WRITE,
+					     MAP_SHARED, fd, 0);
+			if (ctx->desc.buf == MAP_FAILED)
+				err(1, "cannot mmap buffer");
+			ctx->desc.pgmsk = pgmsk;
+		}
+
+		ctx->desc.fd          = fd;
+		handle->fds[i].fd     = fd;
+		handle->fds[i].events = POLLIN;
+		i++;
+	}
+
+	return 0;
+}
+
+static void
+perf_event_handle_release(struct perf_event_handle *handle)
+{
+	int cpu;
+	struct perf_event_context *ctx;
+
+	for (cpu = handle->cpu_min; cpu <= handle->cpu_max; cpu++) {
+		ctx = &handle->ctx[cpu];
+		close(ctx->desc.fd);
+		process_smpl_buf(&ctx->desc);
+		munmap(ctx->desc.buf, handle->map_size);
+	}
+}
+
+#define RAW_TYPE_IBS_FETCH	1
+#define RAW_TYPE_IBS_OP		2
+
+#define IBS_FETCH_CONFIG_DEFAULT	((1ULL<<57)|(100000ULL>>4))
+#define IBS_OP_CONFIG_DEFAULT		((1ULL<<19)|(100000ULL>>4))
+
+int perf_event_handle_run(struct perf_event_handle *handle)
+{
+	struct perf_event_attr attr;
+	static uint64_t ovfl_count; /* static to avoid setjmp issue */
+	pid_t pid;
+	int status, ret;
+	int i;
+
+	if (pfm_initialize() != PFM_SUCCESS)
+		errx(1, "libpfm initialization failed\n");
+
+	memset(&attr, 0, sizeof(attr));
+	attr.type        = PERF_TYPE_RAW;
+	attr.raw_type    = RAW_TYPE_IBS_FETCH;
+	attr.sample_type = PERF_SAMPLE_CPU | PERF_SAMPLE_RAW;
+	attr.config      = IBS_FETCH_CONFIG_DEFAULT;
+
+	ret = perf_event_handle_setup(handle, &attr);
+	if (ret)
+		errx(1, "perf_event_handle_setup() failed: %d\n", ret);
+
+	/*
+	 * Create the child task
+	 */
+	if ((pid=fork()) == -1)
+		err(1, "cannot fork process\n");
+
+	if (pid == 0)
+		exit(child(handle->config.argv));
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
+		     handle->config.argv[0], pid, WEXITSTATUS(status));
+
+	/*
+	 * effectively activate monitoring
+	 */
+	ptrace(PTRACE_DETACH, pid, NULL, 0);
+
+	signal(SIGCHLD, cld_handler);
+
+	if (setjmp(jbuf) == 1)
+		goto terminate_session;
+
+	/*
+	 * core loop
+	 */
+	for(;;) {
+		ret = poll(handle->fds, handle->num_cpus, -1);
+		if (ret < 0 && errno == EINTR)
+			break;
+		ovfl_count++;
+		for (i = 0; i < handle->num_cpus; i++) {
+			if (!handle->fds[i].revents)
+				continue;
+			process_smpl_buf(
+				&handle->ctx[i + handle->cpu_min].desc);
+			ret--;
+			if (!ret)
+				break;
+		}
+	}
+terminate_session:
+	/*
+	 * cleanup child
+	 */
+	wait4(pid, &status, 0, NULL);
+
+	perf_event_handle_release(handle);
+
+	printf("%"PRIu64" samples collected in %"PRIu64" poll events, %"PRIu64" lost samples\n",
+		collected_samples,
+		ovfl_count, lost_samples);
+	if (collected_samples)
+		printf("avg period=%"PRIu64"\n", sum_period / collected_samples);
+	return 0;
+}
+
+static void usage(void)
+{
+	printf("usage: ibs_smpl [-h] [--help] [-s] [-c cpu] cmd\n");
+}
+
+static int perf_event_handle_init(struct perf_event_handle *handle)
+{
+	memset(handle, 0, sizeof(struct perf_event_handle));
+	return 0;
+}
+
+int perf_event_handle_config(struct perf_event_handle *handle,
+			     int argc, char **argv)
+{
+	struct perf_event_config *config = &handle->config;
+	int c;
+
+	config->mmap_pages = 1; /* need buffer for ibs */
+	config->pid = -1;	/* support for system wide profiling only */
+	config->cpu = -1;
+
+	while ((c=getopt_long(argc, argv,"hc:", the_options, 0)) != -1) {
+		switch(c) {
+		case 0: continue;
+		case 'h':
+			usage();
+			exit(0);
+		case 's':
+			/* system wide profiling */
+			if (config->pid)
+				break;
+			config->pid = -1;
+			config->cpu = -1;
+			break;
+		case 'c':
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
+	if (argv[optind] == NULL)
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
+int main(int argc, char **argv)
+{
+	struct perf_event_handle *handle = &ibs_handle;
+	int ret;
+
+	ret = perf_event_handle_init(handle);
+	if (ret)
+		goto fail;
+	ret = perf_event_handle_config(handle, argc, argv);
+	if (ret)
+		goto fail;
+	ret = perf_event_handle_run(handle);
+	if (ret)
+		goto fail;
+	exit(0);
+fail:
+	printf("An error occurred: %d (%s)\n", -ret, strerror(-ret));
+	exit(-1);
+}
-- 
1.7.3.1


-- 
Advanced Micro Devices, Inc.
Operating System Research Center

