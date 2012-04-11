Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab2DKJEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 05:04:24 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61042 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab2DKJDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 05:03:30 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, dsahern@gmail.com,
        namhyung.kim@lge.com
Subject: [PATCH 4/5] perf record: add meta-data support for pipe-mode
Date: Wed, 11 Apr 2012 11:01:28 +0200
Message-Id: <1334134889-20312-5-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1334134889-20312-1-git-send-email-eranian@google.com>
References: <1334134889-20312-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the meta-data header support for perf record
when used in pipe mode: perf record -o -

Up until now, meta-data was only available when perf record
was used in "regular" mode, i.e., generating a perf.data file.
For users depending on pipe mode, no host, event header information
was gathered. This patch addresses this limitation.

The difficulty in pipe mode is that information needs to be written
sequentially to the pipe. Meta data headers are usually generated
(and also expected) at the beginning of the file (or piped output).
To solve this problem, we introduce new synthetic record types,
one for each meta-data type. The approach is similar to what
is already used for BUILD_ID and TRACING_DATA.

We have modified util/header.c such that the same routines are used
to generate and read the meta-data information regardless of pipe-mode
vs. regular mode. To make this work, we added a new struct called
feat_fd which encapsulates all the information necessary to read or
write meta-data information to a file/pipe or from a file/pipe.

It should be noted that there is a limitation with the current
perf in terms of endianess in pipe mode. Perf assumes the records
are generated using the same endianess during collection and
analysis.  That is always the case with the example shown below.
However, one could also do:
$ perf record -o - noploop 2 | perf inject -b >perf.data
$ cat perf.data | perf report -i -

With this patch, it is possible to get:
 $ perf record -o - noploop 2 | perf inject -b | perf report -i -
      # ========
      # captured on: Fri Jan 20 18:13:55 2012
      # ========
      #
      # hostname : quad
      # os release : 3.2.0-rc7-tip
      # perf version : 3.2.0
      # arch : x86_64
      # nrcpus online : 4
      # nrcpus avail : 4
      # cpudesc : Intel(R) Core(TM)2 Quad CPU Q6600 @ 2.40GHz
      # cpuid : GenuineIntel,6,15,11
      # total memory : 8092884 kB
      ...
      # HEADER_CPU_TOPOLOGY info available, use -I to display
      noploop for 2 seconds
      [ perf record: Woken up 1 times to write data ]
      [ perf record: Captured and wrote 0.084 MB - (~3677 samples) ]
        99.80%  noploop  noploop            [.] noploop
         0.19%  noploop  [kernel.kallsyms]  [k] radix_tree_gang_lookup

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-annotate.c |    5 +
 tools/perf/builtin-inject.c   |    1 +
 tools/perf/builtin-record.c   |    7 +
 tools/perf/builtin-report.c   |    7 +-
 tools/perf/util/event.c       |   12 +
 tools/perf/util/event.h       |   18 ++
 tools/perf/util/header.c      |  532 +++++++++++++++++++++++++++++------------
 tools/perf/util/header.h      |    9 +
 tools/perf/util/session.c     |   17 ++-
 tools/perf/util/tool.h        |    4 +-
 10 files changed, 449 insertions(+), 163 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 806e0a2..fe42298 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -247,6 +247,11 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 			.mmap	= perf_event__process_mmap,
 			.comm	= perf_event__process_comm,
 			.fork	= perf_event__process_task,
+			.attr	= perf_event__process_attr,
+			.event_type	 = perf_event__process_event_type,
+			.tracing_data	 = perf_event__process_tracing_data,
+			.build_id	 = perf_event__process_build_id,
+			.feature	 = perf_event__process_feature,
 			.ordered_samples = true,
 			.ordering_requires_timestamps = true,
 		},
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 3beab48..65b0529 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -217,6 +217,7 @@ struct perf_tool perf_inject = {
 	.event_type	= perf_event__repipe_event_type_synth,
 	.tracing_data	= perf_event__repipe_tracing_data_synth,
 	.build_id	= perf_event__repipe_op2_synth,
+	.feature	= perf_event__repipe_op2_synth,
 };
 
 extern volatile int session_done;
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 2a64679..175acdf 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -524,6 +524,13 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	}
 
 	if (opts->pipe_output) {
+		err = perf_event__synthesize_features(tool, session, evsel_list,
+						   process_synthesized_event);
+		if (err < 0) {
+			pr_err("Couldn't synthesize features.\n");
+			return err;
+		}
+
 		err = perf_event__synthesize_attrs(tool, session,
 						   process_synthesized_event);
 		if (err < 0) {
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 2e31743..350b888 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -43,7 +43,6 @@ struct perf_report {
 	bool			force, use_tui, use_gtk, use_stdio;
 	bool			hide_unresolved;
 	bool			dont_use_callchains;
-	bool			show_full_info;
 	bool			show_threads;
 	bool			inverted_callchain;
 	struct perf_read_values	show_threads_values;
@@ -355,7 +354,8 @@ static int __cmd_report(struct perf_report *rep)
 	}
 
 	if (use_browser <= 0)
-		perf_session__fprintf_info(session, stdout, rep->show_full_info);
+		perf_session__fprintf_info(session, stdout,
+					   rep->tool.show_all_features);
 
 	if (rep->show_threads)
 		perf_read_values_init(&rep->show_threads_values);
@@ -552,6 +552,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 			.event_type	 = perf_event__process_event_type,
 			.tracing_data	 = perf_event__process_tracing_data,
 			.build_id	 = perf_event__process_build_id,
+			.feature	 = perf_event__process_feature,
 			.ordered_samples = true,
 			.ordering_requires_timestamps = true,
 		},
@@ -615,7 +616,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 		    "Look for files with symbols relative to this directory"),
 	OPT_STRING('C', "cpu", &report.cpu_list, "cpu",
 		   "list of cpus to profile"),
-	OPT_BOOLEAN('I', "show-info", &report.show_full_info,
+	OPT_BOOLEAN('I', "show-info", &report.tool.show_all_features,
 		    "Display extended information about perf.data file"),
 	OPT_BOOLEAN(0, "source", &symbol_conf.annotate_src,
 		    "Interleave source code with assembly code (default)"),
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 2a6f33c..da3551f 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -23,6 +23,18 @@ static const char *perf_event__names[] = {
 	[PERF_RECORD_HEADER_TRACING_DATA]	= "TRACING_DATA",
 	[PERF_RECORD_HEADER_BUILD_ID]		= "BUILD_ID",
 	[PERF_RECORD_FINISHED_ROUND]		= "FINISHED_ROUND",
+	[PERF_RECORD_HEADER_HOSTNAME]		= "HOSTNAME",
+	[PERF_RECORD_HEADER_OSRELEASE]		= "OSRELEASE",
+	[PERF_RECORD_HEADER_VERSION]		= "VERSION",
+	[PERF_RECORD_HEADER_ARCH]		= "ARCH",
+	[PERF_RECORD_HEADER_NRCPUS]		= "NRCPUS",
+	[PERF_RECORD_HEADER_CPUDESC]		= "CPUDESC",
+	[PERF_RECORD_HEADER_CPUID]		= "CPUID",
+	[PERF_RECORD_HEADER_TOTAL_MEM]		= "TOTAL_MEM",
+	[PERF_RECORD_HEADER_CMDLINE]		= "CMDLINE",
+	[PERF_RECORD_HEADER_EVENT_DESC]		= "EVENT_DESC",
+	[PERF_RECORD_HEADER_CPU_TOPOLOGY]	= "CPU_TOPOLOGY",
+	[PERF_RECORD_HEADER_NUMA_TOPOLOGY]	= "NUMA_TOPOLOGY",
 };
 
 const char *perf_event__name(unsigned int id)
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 1b19728..e44aaec 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -100,6 +100,18 @@ enum perf_user_event_type { /* above any possible kernel type */
 	PERF_RECORD_HEADER_TRACING_DATA		= 66,
 	PERF_RECORD_HEADER_BUILD_ID		= 67,
 	PERF_RECORD_FINISHED_ROUND		= 68,
+	PERF_RECORD_HEADER_HOSTNAME		= 69,
+	PERF_RECORD_HEADER_OSRELEASE		= 70,
+	PERF_RECORD_HEADER_VERSION		= 71,
+	PERF_RECORD_HEADER_ARCH			= 72,
+	PERF_RECORD_HEADER_NRCPUS		= 73,
+	PERF_RECORD_HEADER_CPUDESC		= 74,
+	PERF_RECORD_HEADER_CPUID		= 75,
+	PERF_RECORD_HEADER_TOTAL_MEM		= 76,
+	PERF_RECORD_HEADER_CMDLINE		= 77,
+	PERF_RECORD_HEADER_EVENT_DESC		= 78,
+	PERF_RECORD_HEADER_CPU_TOPOLOGY		= 79,
+	PERF_RECORD_HEADER_NUMA_TOPOLOGY	= 80,
 	PERF_RECORD_HEADER_MAX
 };
 
@@ -126,6 +138,11 @@ struct tracing_data_event {
 	u32 size;
 };
 
+struct feature_event {
+	struct perf_event_header header;
+	char data[]; /* size bytes of raw data specific to the feature */
+};
+
 union perf_event {
 	struct perf_event_header	header;
 	struct ip_event			ip;
@@ -139,6 +156,7 @@ union perf_event {
 	struct event_type_event		event_type;
 	struct tracing_data_event	tracing_data;
 	struct build_id_event		build_id;
+	struct feature_event		feat;
 };
 
 void perf_event__print_totals(void);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 99af448..6072fba 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -20,6 +20,16 @@
 #include "symbol.h"
 #include "debug.h"
 #include "cpumap.h"
+#include "tool.h"
+
+struct feat_fd {
+	int fd;
+	int needs_swap;
+	void *buf;
+	struct perf_header *hdr;
+	size_t size;
+	size_t pos;
+};
 
 static bool no_buildid_cache = false;
 
@@ -98,14 +108,46 @@ bool perf_header__has_feat(const struct perf_header *header, int feat)
 	return test_bit(feat, header->adds_features);
 }
 
-static int do_write(int fd, const void *buf, size_t size)
+static ssize_t do_read(struct feat_fd *fd, void *addr, size_t size)
+{
+	if (!fd->buf)
+		return read(fd->fd, addr, size);
+
+	size = min(size, (fd->size - fd->pos));
+
+	memcpy(addr, fd->buf+fd->pos, size);
+
+	fd->pos += size;
+
+	return size;
+}
+
+static int do_write(struct feat_fd *fd, const void *buf, size_t size)
 {
+	void *addr;
+	int ret;
+
 	while (size) {
-		int ret = write(fd, buf, size);
 
-		if (ret < 0)
-			return -errno;
+		if (fd->buf == NULL) {
+			ret = write(fd->fd, buf, size);
+			if (ret < 0)
+				return -errno;
+		} else {
+retry:
+			if (size > (fd->size - fd->pos)) {
+				addr = realloc(fd->buf, fd->size << 1);
+				if (!addr)
+					return -ENOSPC;
+				fd->buf = addr;
+				fd->size <<= 1;
+				goto retry;
+			}
 
+			memcpy(fd->buf+fd->pos, buf, size);
+			fd->pos += size;
+			ret = size;
+		}
 		size -= ret;
 		buf += ret;
 	}
@@ -115,7 +157,7 @@ static int do_write(int fd, const void *buf, size_t size)
 
 #define NAME_ALIGN 64
 
-static int write_padded(int fd, const void *bf, size_t count,
+static int write_padded(struct feat_fd *fd, const void *bf, size_t count,
 			size_t count_aligned)
 {
 	static const char zero_buf[NAME_ALIGN];
@@ -127,7 +169,7 @@ static int write_padded(int fd, const void *bf, size_t count,
 	return err;
 }
 
-static int do_write_string(int fd, const char *str)
+static int do_write_string(struct feat_fd *fd, const char *str)
 {
 	u32 len, olen;
 	int ret;
@@ -143,24 +185,35 @@ static int do_write_string(int fd, const char *str)
 	return write_padded(fd, str, olen, len);
 }
 
-static char *do_read_string(int fd, struct perf_header *ph)
+static char *do_read_string(struct feat_fd *fd)
 {
 	ssize_t sz, ret;
 	u32 len;
 	char *buf;
 
-	sz = read(fd, &len, sizeof(len));
-	if (sz < (ssize_t)sizeof(len))
-		return NULL;
+	if (fd->buf) {
+		len = *(int *)(fd->buf + fd->pos);
+		fd->pos += sizeof(u32);
+	} else {
+		sz = read(fd->fd, &len, sizeof(len));
+		if (sz < (ssize_t)sizeof(len))
+			return NULL;
+	}
 
-	if (ph->needs_swap)
+	if (fd->needs_swap)
 		len = bswap_32(len);
 
 	buf = malloc(len);
 	if (!buf)
 		return NULL;
 
-	ret = read(fd, buf, len);
+	if (fd->buf) {
+		memcpy(buf, fd->buf+fd->pos, len);
+		fd->pos += len;
+		return buf;
+	}
+
+	ret = read(fd->fd, buf, len);
 	if (ret == (ssize_t)len) {
 		/*
 		 * strings are padded by zeroes
@@ -169,7 +222,6 @@ static char *do_read_string(int fd, struct perf_header *ph)
 		 */
 		return buf;
 	}
-
 	free(buf);
 	return NULL;
 }
@@ -203,7 +255,7 @@ perf_header__set_cmdline(int argc, const char **argv)
 		else
 
 static int __dsos__write_buildid_table(struct list_head *head, pid_t pid,
-				u16 misc, int fd)
+				u16 misc, struct feat_fd *fd)
 {
 	struct dso *pos;
 
@@ -233,7 +285,8 @@ static int __dsos__write_buildid_table(struct list_head *head, pid_t pid,
 	return 0;
 }
 
-static int machine__write_buildid_table(struct machine *machine, int fd)
+static int machine__write_buildid_table(struct machine *machine,
+					struct feat_fd *fd)
 {
 	int err;
 	u16 kmisc = PERF_RECORD_MISC_KERNEL,
@@ -252,7 +305,8 @@ static int machine__write_buildid_table(struct machine *machine, int fd)
 	return err;
 }
 
-static int dsos__write_buildid_table(struct perf_header *header, int fd)
+static int dsos__write_buildid_table(struct perf_header *header,
+				     struct feat_fd *fd)
 {
 	struct perf_session *session = container_of(header,
 			struct perf_session, header);
@@ -442,25 +496,24 @@ static bool perf_session__read_build_ids(struct perf_session *session, bool with
 	return ret;
 }
 
-static int write_tracing_data(int fd, struct perf_header *h __used,
-			    struct perf_evlist *evlist)
+static int write_tracing_data(struct feat_fd *fd, struct perf_evlist *evlist)
 {
-	return read_tracing_data(fd, &evlist->entries);
+	return read_tracing_data(fd->fd, &evlist->entries);
 }
 
 
-static int write_build_id(int fd, struct perf_header *h,
+static int write_build_id(struct feat_fd *fd,
 			  struct perf_evlist *evlist __used)
 {
 	struct perf_session *session;
 	int err;
 
-	session = container_of(h, struct perf_session, header);
+	session = container_of(fd->hdr, struct perf_session, header);
 
 	if (!perf_session__read_build_ids(session, true))
 		return -1;
 
-	err = dsos__write_buildid_table(h, fd);
+	err = dsos__write_buildid_table(fd->hdr, fd);
 	if (err < 0) {
 		pr_debug("failed to write buildid table\n");
 		return err;
@@ -471,8 +524,7 @@ static int write_build_id(int fd, struct perf_header *h,
 	return 0;
 }
 
-static int write_hostname(int fd, struct perf_header *h __used,
-			  struct perf_evlist *evlist __used)
+static int write_hostname(struct feat_fd *fd, struct perf_evlist *evlist __used)
 {
 	struct utsname uts;
 	int ret;
@@ -484,7 +536,7 @@ static int write_hostname(int fd, struct perf_header *h __used,
 	return do_write_string(fd, uts.nodename);
 }
 
-static int write_osrelease(int fd, struct perf_header *h __used,
+static int write_osrelease(struct feat_fd *fd,
 			   struct perf_evlist *evlist __used)
 {
 	struct utsname uts;
@@ -497,8 +549,7 @@ static int write_osrelease(int fd, struct perf_header *h __used,
 	return do_write_string(fd, uts.release);
 }
 
-static int write_arch(int fd, struct perf_header *h __used,
-		      struct perf_evlist *evlist __used)
+static int write_arch(struct feat_fd *fd, struct perf_evlist *evlist __used)
 {
 	struct utsname uts;
 	int ret;
@@ -510,14 +561,12 @@ static int write_arch(int fd, struct perf_header *h __used,
 	return do_write_string(fd, uts.machine);
 }
 
-static int write_version(int fd, struct perf_header *h __used,
-			 struct perf_evlist *evlist __used)
+static int write_version(struct feat_fd *fd, struct perf_evlist *evlist __used)
 {
 	return do_write_string(fd, perf_version_string);
 }
 
-static int write_cpudesc(int fd, struct perf_header *h __used,
-		       struct perf_evlist *evlist __used)
+static int write_cpudesc(struct feat_fd *fd, struct perf_evlist *evlist __used)
 {
 #ifndef CPUINFO_PROC
 #define CPUINFO_PROC NULL
@@ -575,8 +624,7 @@ static int write_cpudesc(int fd, struct perf_header *h __used,
 	return ret;
 }
 
-static int write_nrcpus(int fd, struct perf_header *h __used,
-			struct perf_evlist *evlist __used)
+static int write_nrcpus(struct feat_fd *fd, struct perf_evlist *evlist __used)
 {
 	long nr;
 	u32 nrc, nra;
@@ -601,8 +649,7 @@ static int write_nrcpus(int fd, struct perf_header *h __used,
 	return do_write(fd, &nra, sizeof(nra));
 }
 
-static int write_event_desc(int fd, struct perf_header *h __used,
-			    struct perf_evlist *evlist)
+static int write_event_desc(struct feat_fd *fd, struct perf_evlist *evlist)
 {
 	struct perf_evsel *attr;
 	u32 nre = 0, nri, sz;
@@ -659,8 +706,7 @@ static int write_event_desc(int fd, struct perf_header *h __used,
 	return 0;
 }
 
-static int write_cmdline(int fd, struct perf_header *h __used,
-			 struct perf_evlist *evlist __used)
+static int write_cmdline(struct feat_fd *fd, struct perf_evlist *evlist __used)
 {
 	char buf[MAXPATHLEN];
 	char proc[32];
@@ -828,8 +874,8 @@ static struct cpu_topo *build_cpu_topology(void)
 	return tp;
 }
 
-static int write_cpu_topology(int fd, struct perf_header *h __used,
-			  struct perf_evlist *evlist __used)
+static int write_cpu_topology(struct feat_fd *fd,
+			      struct perf_evlist *evlist __used)
 {
 	struct cpu_topo *tp;
 	u32 i;
@@ -862,10 +908,8 @@ static int write_cpu_topology(int fd, struct perf_header *h __used,
 	return ret;
 }
 
-
-
-static int write_total_mem(int fd, struct perf_header *h __used,
-			  struct perf_evlist *evlist __used)
+static int write_total_mem(struct feat_fd *fd,
+			   struct perf_evlist *evlist __used)
 {
 	char *buf = NULL;
 	FILE *fp;
@@ -892,7 +936,7 @@ static int write_total_mem(int fd, struct perf_header *h __used,
 	return ret;
 }
 
-static int write_topo_node(int fd, int node)
+static int write_topo_node(struct feat_fd *fd, int node)
 {
 	char str[MAXPATHLEN];
 	char field[32];
@@ -950,8 +994,8 @@ static int write_topo_node(int fd, int node)
 	return ret;
 }
 
-static int write_numa_topology(int fd, struct perf_header *h __used,
-			  struct perf_evlist *evlist __used)
+static int write_numa_topology(struct feat_fd *fd,
+			       struct perf_evlist *evlist __used)
 {
 	char *buf = NULL;
 	size_t len = 0;
@@ -1008,8 +1052,7 @@ int __attribute__((weak)) get_cpuid(char *buffer __used, size_t sz __used)
 	return -1;
 }
 
-static int write_cpuid(int fd, struct perf_header *h __used,
-		       struct perf_evlist *evlist __used)
+static int write_cpuid(struct feat_fd *fd, struct perf_evlist *evlist __used)
 {
 	char buffer[64];
 	int ret;
@@ -1023,128 +1066,128 @@ static int write_cpuid(int fd, struct perf_header *h __used,
 	return do_write_string(fd, buffer);
 }
 
-static int write_branch_stack(int fd __used, struct perf_header *h __used,
-		       struct perf_evlist *evlist __used)
+static int write_branch_stack(struct feat_fd *fd __used,
+			      struct perf_evlist *evlist __used)
 {
 	return 0;
 }
 
-static void print_hostname(struct perf_header *ph, int fd, FILE *fp)
+static void print_hostname(struct feat_fd *fd, FILE *fp)
 {
-	char *str = do_read_string(fd, ph);
+	char *str = do_read_string(fd);
 	fprintf(fp, "# hostname : %s\n", str);
 	free(str);
 }
 
-static void print_osrelease(struct perf_header *ph, int fd, FILE *fp)
+static void print_osrelease(struct feat_fd *fd, FILE *fp)
 {
-	char *str = do_read_string(fd, ph);
+	char *str = do_read_string(fd);
 	fprintf(fp, "# os release : %s\n", str);
 	free(str);
 }
 
-static void print_arch(struct perf_header *ph, int fd, FILE *fp)
+static void print_arch(struct feat_fd *fd, FILE *fp)
 {
-	char *str = do_read_string(fd, ph);
+	char *str = do_read_string(fd);
 	fprintf(fp, "# arch : %s\n", str);
 	free(str);
 }
 
-static void print_cpudesc(struct perf_header *ph, int fd, FILE *fp)
+static void print_cpudesc(struct feat_fd *fd, FILE *fp)
 {
-	char *str = do_read_string(fd, ph);
+	char *str = do_read_string(fd);
 	fprintf(fp, "# cpudesc : %s\n", str);
 	free(str);
 }
 
-static void print_nrcpus(struct perf_header *ph, int fd, FILE *fp)
+static void print_nrcpus(struct feat_fd *fd, FILE *fp)
 {
 	ssize_t ret;
 	u32 nr;
 
-	ret = read(fd, &nr, sizeof(nr));
+	ret = do_read(fd, &nr, sizeof(nr));
 	if (ret != (ssize_t)sizeof(nr))
 		nr = -1; /* interpreted as error */
 
-	if (ph->needs_swap)
+	if (fd->needs_swap)
 		nr = bswap_32(nr);
 
 	fprintf(fp, "# nrcpus online : %u\n", nr);
 
-	ret = read(fd, &nr, sizeof(nr));
+	ret = do_read(fd, &nr, sizeof(nr));
 	if (ret != (ssize_t)sizeof(nr))
 		nr = -1; /* interpreted as error */
 
-	if (ph->needs_swap)
+	if (fd->needs_swap)
 		nr = bswap_32(nr);
 
 	fprintf(fp, "# nrcpus avail : %u\n", nr);
 }
 
-static void print_version(struct perf_header *ph, int fd, FILE *fp)
+static void print_version(struct feat_fd *fd, FILE *fp)
 {
-	char *str = do_read_string(fd, ph);
+	char *str = do_read_string(fd);
 	fprintf(fp, "# perf version : %s\n", str);
 	free(str);
 }
 
-static void print_cmdline(struct perf_header *ph, int fd, FILE *fp)
+static void print_cmdline(struct feat_fd *fd, FILE *fp)
 {
 	ssize_t ret;
 	char *str;
 	u32 nr, i;
 
-	ret = read(fd, &nr, sizeof(nr));
+	ret = do_read(fd, &nr, sizeof(nr));
 	if (ret != (ssize_t)sizeof(nr))
 		return;
 
-	if (ph->needs_swap)
+	if (fd->needs_swap)
 		nr = bswap_32(nr);
 
 	fprintf(fp, "# cmdline : ");
 
 	for (i = 0; i < nr; i++) {
-		str = do_read_string(fd, ph);
+		str = do_read_string(fd);
 		fprintf(fp, "%s ", str);
 		free(str);
 	}
 	fputc('\n', fp);
 }
 
-static void print_cpu_topology(struct perf_header *ph, int fd, FILE *fp)
+static void print_cpu_topology(struct feat_fd *fd, FILE *fp)
 {
 	ssize_t ret;
 	u32 nr, i;
 	char *str;
 
-	ret = read(fd, &nr, sizeof(nr));
+	ret = do_read(fd, &nr, sizeof(nr));
 	if (ret != (ssize_t)sizeof(nr))
 		return;
 
-	if (ph->needs_swap)
+	if (fd->needs_swap)
 		nr = bswap_32(nr);
 
 	for (i = 0; i < nr; i++) {
-		str = do_read_string(fd, ph);
+		str = do_read_string(fd);
 		fprintf(fp, "# sibling cores   : %s\n", str);
 		free(str);
 	}
 
-	ret = read(fd, &nr, sizeof(nr));
+	ret = do_read(fd, &nr, sizeof(nr));
 	if (ret != (ssize_t)sizeof(nr))
 		return;
 
-	if (ph->needs_swap)
+	if (fd->needs_swap)
 		nr = bswap_32(nr);
 
 	for (i = 0; i < nr; i++) {
-		str = do_read_string(fd, ph);
+		str = do_read_string(fd);
 		fprintf(fp, "# sibling threads : %s\n", str);
 		free(str);
 	}
 }
 
-static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
+static void print_event_desc(struct feat_fd *fd, FILE *fp)
 {
 	struct perf_event_attr attr;
 	uint64_t id;
@@ -1155,18 +1198,18 @@ static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
 	size_t msz;
 
 	/* number of events */
-	ret = read(fd, &nre, sizeof(nre));
+	ret = do_read(fd, &nre, sizeof(nre));
 	if (ret != (ssize_t)sizeof(nre))
 		goto error;
 
-	if (ph->needs_swap)
+	if (fd->needs_swap)
 		nre = bswap_32(nre);
 
-	ret = read(fd, &sz, sizeof(sz));
+	ret = do_read(fd, &sz, sizeof(sz));
 	if (ret != (ssize_t)sizeof(sz))
 		goto error;
 
-	if (ph->needs_swap)
+	if (fd->needs_swap)
 		sz = bswap_32(sz);
 
 	memset(&attr, 0, sizeof(attr));
@@ -1181,28 +1224,27 @@ static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
 		msz = sz;
 
 	for (i = 0 ; i < nre; i++) {
-
 		/*
 		 * must read entire on-file attr struct to
 		 * sync up with layout.
 		 */
-		ret = read(fd, buf, sz);
+		ret = do_read(fd, buf, sz);
 		if (ret != (ssize_t)sz)
 			goto error;
 
-		if (ph->needs_swap)
+		if (fd->needs_swap)
 			perf_event__attr_swap(buf);
 
 		memcpy(&attr, buf, msz);
 
-		ret = read(fd, &nr, sizeof(nr));
+		ret = do_read(fd, &nr, sizeof(nr));
 		if (ret != (ssize_t)sizeof(nr))
 			goto error;
 
-		if (ph->needs_swap)
+		if (fd->needs_swap)
 			nr = bswap_32(nr);
 
-		str = do_read_string(fd, ph);
+		str = do_read_string(fd);
 		fprintf(fp, "# event : name = %s, ", str);
 		free(str);
 
@@ -1221,11 +1263,11 @@ static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
 			fprintf(fp, ", id = {");
 
 		for (j = 0 ; j < nr; j++) {
-			ret = read(fd, &id, sizeof(id));
+			ret = do_read(fd, &id, sizeof(id));
 			if (ret != (ssize_t)sizeof(id))
 				goto error;
 
-			if (ph->needs_swap)
+			if (fd->needs_swap)
 				id = bswap_64(id);
 
 			if (j)
@@ -1243,16 +1285,16 @@ static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
 	fprintf(fp, "# event desc: not available or unable to read\n");
 }
 
-static void print_total_mem(struct perf_header *h __used, int fd, FILE *fp)
+static void print_total_mem(struct feat_fd *fd, FILE *fp)
 {
 	uint64_t mem;
 	ssize_t ret;
 
-	ret = read(fd, &mem, sizeof(mem));
+	ret = do_read(fd, &mem, sizeof(mem));
 	if (ret != sizeof(mem))
 		goto error;
 
-	if (h->needs_swap)
+	if (fd->needs_swap)
 		mem = bswap_64(mem);
 
 	fprintf(fp, "# total memory : %"PRIu64" kB\n", mem);
@@ -1261,7 +1303,7 @@ static void print_total_mem(struct perf_header *h __used, int fd, FILE *fp)
 	fprintf(fp, "# total memory : unknown\n");
 }
 
-static void print_numa_topology(struct perf_header *h __used, int fd, FILE *fp)
+static void print_numa_topology(struct feat_fd *fd, FILE *fp)
 {
 	ssize_t ret;
 	u32 nr, c, i;
@@ -1269,32 +1311,32 @@ static void print_numa_topology(struct perf_header *h __used, int fd, FILE *fp)
 	uint64_t mem_total, mem_free;
 
 	/* nr nodes */
-	ret = read(fd, &nr, sizeof(nr));
+	ret = do_read(fd, &nr, sizeof(nr));
 	if (ret != (ssize_t)sizeof(nr))
 		goto error;
 
-	if (h->needs_swap)
+	if (fd->needs_swap)
 		nr = bswap_32(nr);
 
 	for (i = 0; i < nr; i++) {
 
 		/* node number */
-		ret = read(fd, &c, sizeof(c));
+		ret = do_read(fd, &c, sizeof(c));
 		if (ret != (ssize_t)sizeof(c))
 			goto error;
 
-		if (h->needs_swap)
+		if (fd->needs_swap)
 			c = bswap_32(c);
 
-		ret = read(fd, &mem_total, sizeof(u64));
+		ret = do_read(fd, &mem_total, sizeof(u64));
 		if (ret != sizeof(u64))
 			goto error;
 
-		ret = read(fd, &mem_free, sizeof(u64));
+		ret = do_read(fd, &mem_free, sizeof(u64));
 		if (ret != sizeof(u64))
 			goto error;
 
-		if (h->needs_swap) {
+		if (fd->needs_swap) {
 			mem_total = bswap_64(mem_total);
 			mem_free = bswap_64(mem_free);
 		}
@@ -1305,7 +1347,7 @@ static void print_numa_topology(struct perf_header *h __used, int fd, FILE *fp)
 			mem_total,
 			mem_free);
 
-		str = do_read_string(fd, h);
+		str = do_read_string(fd);
 		fprintf(fp, "# node%u cpu list : %s\n", c, str);
 		free(str);
 	}
@@ -1314,15 +1356,14 @@ static void print_numa_topology(struct perf_header *h __used, int fd, FILE *fp)
 	fprintf(fp, "# numa topology : not available\n");
 }
 
-static void print_cpuid(struct perf_header *ph, int fd, FILE *fp)
+static void print_cpuid(struct feat_fd *fd, FILE *fp)
 {
-	char *str = do_read_string(fd, ph);
+	char *str = do_read_string(fd);
 	fprintf(fp, "# cpuid : %s\n", str);
 	free(str);
 }
 
-static void print_branch_stack(struct perf_header *ph __used, int fd __used,
-			       FILE *fp)
+static void print_branch_stack(struct feat_fd *fd __used, FILE *fp)
 {
 	fprintf(fp, "# contains samples with branch stack\n");
 }
@@ -1495,43 +1536,88 @@ static int process_build_id(struct perf_file_section *section,
 }
 
 struct feature_ops {
-	int (*write)(int fd, struct perf_header *h, struct perf_evlist *evlist);
-	void (*print)(struct perf_header *h, int fd, FILE *fp);
+	int (*write)(struct feat_fd *fd, struct perf_evlist *evlist);
+	void (*print)(struct feat_fd *fd, FILE *fp);
 	int (*process)(struct perf_file_section *section,
 		       struct perf_header *h, int feat, int fd);
 	const char *name;
 	bool full_only;
+	int record_type;
 };
 
-#define FEAT_OPA(n, func) \
-	[n] = { .name = #n, .write = write_##func, .print = print_##func }
-#define FEAT_OPP(n, func) \
-	[n] = { .name = #n, .write = write_##func, .print = print_##func, \
-		.process = process_##func }
-#define FEAT_OPF(n, func) \
-	[n] = { .name = #n, .write = write_##func, .print = print_##func, \
-		.full_only = true }
+#define FEAT_OPA(n, func)				\
+	[HEADER_##n] = { .name = #n,			\
+		.write = write_##func,			\
+		.print = print_##func,			\
+		.full_only = false,			\
+		.record_type = PERF_RECORD_HEADER_##n	\
+	}
+
+#define FEAT_OPB(n, func)                               \
+	[HEADER_##n] = { .name = #n,			\
+		.write = write_##func,			\
+		.print = print_##func,			\
+		.full_only = false,			\
+	}
+
+#define FEAT_OPP(n, func)				\
+	[HEADER_##n] = { .name = #n,			\
+		.write = write_##func,			\
+		.print = print_##func,			\
+		.process = process_##func,		\
+		.record_type = PERF_RECORD_HEADER_##n	\
+	}
+
+#define FEAT_OPF(n, func)				\
+	[HEADER_##n] = { .name = #n,			\
+		.write = write_##func,			\
+		.print = print_##func,			\
+		.full_only = true,			\
+		.record_type = PERF_RECORD_HEADER_##n	\
+	}
 
 /* feature_ops not implemented: */
 #define print_tracing_data	NULL
 #define print_build_id		NULL
 
 static const struct feature_ops feat_ops[HEADER_LAST_FEATURE] = {
-	FEAT_OPP(HEADER_TRACING_DATA,	tracing_data),
-	FEAT_OPP(HEADER_BUILD_ID,	build_id),
-	FEAT_OPA(HEADER_HOSTNAME,	hostname),
-	FEAT_OPA(HEADER_OSRELEASE,	osrelease),
-	FEAT_OPA(HEADER_VERSION,	version),
-	FEAT_OPA(HEADER_ARCH,		arch),
-	FEAT_OPA(HEADER_NRCPUS,		nrcpus),
-	FEAT_OPA(HEADER_CPUDESC,	cpudesc),
-	FEAT_OPA(HEADER_CPUID,		cpuid),
-	FEAT_OPA(HEADER_TOTAL_MEM,	total_mem),
-	FEAT_OPA(HEADER_EVENT_DESC,	event_desc),
-	FEAT_OPA(HEADER_CMDLINE,	cmdline),
-	FEAT_OPF(HEADER_CPU_TOPOLOGY,	cpu_topology),
-	FEAT_OPF(HEADER_NUMA_TOPOLOGY,	numa_topology),
-	FEAT_OPA(HEADER_BRANCH_STACK,	branch_stack),
+	FEAT_OPP(TRACING_DATA,	tracing_data),
+	FEAT_OPP(BUILD_ID,	build_id),
+	FEAT_OPA(HOSTNAME,	hostname),
+	FEAT_OPA(OSRELEASE,	osrelease),
+	FEAT_OPA(VERSION,	version),
+	FEAT_OPA(ARCH,		arch),
+	FEAT_OPA(NRCPUS,	nrcpus),
+	FEAT_OPA(CPUDESC,	cpudesc),
+	FEAT_OPA(CPUID,		cpuid),
+	FEAT_OPA(TOTAL_MEM,	total_mem),
+	FEAT_OPA(EVENT_DESC,	event_desc),
+	FEAT_OPA(CMDLINE,	cmdline),
+	FEAT_OPF(CPU_TOPOLOGY,	cpu_topology),
+	FEAT_OPF(NUMA_TOPOLOGY,	numa_topology),
+	FEAT_OPB(BRANCH_STACK,	branch_stack),
+};
+
+/*
+ * we use a mapping table to go from record type to feature header
+ * because we have no guarantee that new record types may not be added
+ * after the feature header.
+ */
+#define REC2FEAT(a)	[PERF_RECORD_HEADER_##a] = HEADER_##a
+
+static const int rec2feat[PERF_RECORD_HEADER_MAX] = {
+	REC2FEAT(HOSTNAME),
+	REC2FEAT(OSRELEASE),
+	REC2FEAT(VERSION),
+	REC2FEAT(ARCH),
+	REC2FEAT(NRCPUS),
+	REC2FEAT(CPUDESC),
+	REC2FEAT(CPUID),
+	REC2FEAT(TOTAL_MEM),
+	REC2FEAT(EVENT_DESC),
+	REC2FEAT(CMDLINE),
+	REC2FEAT(CPU_TOPOLOGY),
+	REC2FEAT(NUMA_TOPOLOGY),
 };
 
 struct header_print_data {
@@ -1544,6 +1630,7 @@ static int perf_file_section__fprintf_info(struct perf_file_section *section,
 					   int feat, int fd, void *data)
 {
 	struct header_print_data *hd = data;
+	struct feat_fd fdd;
 
 	if (lseek(fd, section->offset, SEEK_SET) == (off_t)-1) {
 		pr_debug("Failed to lseek to %" PRIu64 " offset for feature "
@@ -1557,8 +1644,19 @@ static int perf_file_section__fprintf_info(struct perf_file_section *section,
 	if (!feat_ops[feat].print)
 		return 0;
 
+	memset(&fdd, 0, sizeof(fdd));
+	fdd.fd = fd;
+	fdd.hdr = ph;
+	fdd.needs_swap = ph->needs_swap;
+
+	/*
+	 * propagate endianess setting to fdd
+	 * in pipe-mode there is no perf_header
+	 */
+	fdd.needs_swap = ph->needs_swap;
+
 	if (!feat_ops[feat].full_only || hd->full)
-		feat_ops[feat].print(ph, fd, hd->fp);
+		feat_ops[feat].print(&fdd, hd->fp);
 	else
 		fprintf(hd->fp, "# %s info available, use -I to display\n",
 			feat_ops[feat].name);
@@ -1579,44 +1677,51 @@ int perf_header__fprintf_info(struct perf_session *session, FILE *fp, bool full)
 	return 0;
 }
 
-static int do_write_feat(int fd, struct perf_header *h, int type,
+static int do_write_feat(struct feat_fd *fdd, int type,
 			 struct perf_file_section **p,
 			 struct perf_evlist *evlist)
 {
 	int err;
-	int ret = 0;
 
-	if (perf_header__has_feat(h, type)) {
+	if (perf_header__has_feat(fdd->hdr, type)) {
 		if (!feat_ops[type].write)
 			return -1;
 
-		(*p)->offset = lseek(fd, 0, SEEK_CUR);
+		(*p)->offset = lseek(fdd->fd, 0, SEEK_CUR);
 
-		err = feat_ops[type].write(fd, h, evlist);
+		err = feat_ops[type].write(fdd, evlist);
 		if (err < 0) {
 			pr_debug("failed to write feature %d\n", type);
-
-			/* undo anything written */
-			lseek(fd, (*p)->offset, SEEK_SET);
-
+			lseek(fdd->fd, (*p)->offset, SEEK_SET);
 			return -1;
+
 		}
-		(*p)->size = lseek(fd, 0, SEEK_CUR) - (*p)->offset;
+		(*p)->size = lseek(fdd->fd, 0, SEEK_CUR) - (*p)->offset;
 		(*p)++;
 	}
-	return ret;
+	return 0;
 }
 
 static int perf_header__adds_write(struct perf_header *header,
 				   struct perf_evlist *evlist, int fd)
 {
 	int nr_sections;
+	struct feat_fd fdd;
 	struct perf_file_section *feat_sec, *p;
 	int sec_size;
 	u64 sec_start;
 	int feat;
 	int err;
 
+	/*
+	 * may write more than needed due to dropped feature, but
+	 * this is okay, reader will skip the mising entries
+	 */
+	memset(&fdd, 0, sizeof(fdd));
+	fdd.fd  = fd;
+	fdd.hdr = header;
+	fdd.needs_swap = header->needs_swap;
+
 	nr_sections = bitmap_weight(header->adds_features, HEADER_FEAT_BITS);
 	if (!nr_sections)
 		return 0;
@@ -1631,38 +1736,40 @@ static int perf_header__adds_write(struct perf_header *header,
 	lseek(fd, sec_start + sec_size, SEEK_SET);
 
 	for_each_set_bit(feat, header->adds_features, HEADER_FEAT_BITS) {
-		if (do_write_feat(fd, header, feat, &p, evlist))
+		if (do_write_feat(&fdd, feat, &p, evlist))
 			perf_header__clear_feat(header, feat);
 	}
 
 	lseek(fd, sec_start, SEEK_SET);
-	/*
-	 * may write more than needed due to dropped feature, but
-	 * this is okay, reader will skip the mising entries
-	 */
-	err = do_write(fd, feat_sec, sec_size);
+
+	err = do_write(&fdd, feat_sec, sec_size);
 	if (err < 0)
 		pr_debug("failed to write feature section\n");
+
 	free(feat_sec);
+
 	return err;
 }
 
 int perf_header__write_pipe(int fd)
 {
 	struct perf_pipe_file_header f_header;
+	struct feat_fd fdd;
 	int err;
 
+	memset(&fdd, 0, sizeof(fdd));
+	fdd.fd = fd;
+
 	f_header = (struct perf_pipe_file_header){
 		.magic	   = PERF_MAGIC,
 		.size	   = sizeof(f_header),
 	};
 
-	err = do_write(fd, &f_header, sizeof(f_header));
+	err = do_write(&fdd, &f_header, sizeof(f_header));
 	if (err < 0) {
 		pr_debug("failed to write perf pipe header\n");
 		return err;
 	}
-
 	return 0;
 }
 
@@ -1670,12 +1777,16 @@ int perf_session__write_header(struct perf_session *session,
 			       struct perf_evlist *evlist,
 			       int fd, bool at_exit)
 {
+	struct feat_fd fdd;
 	struct perf_file_header f_header;
 	struct perf_file_attr   f_attr;
 	struct perf_header *header = &session->header;
 	struct perf_evsel *attr, *pair = NULL;
 	int err;
 
+	memset(&fdd, 0, sizeof(fdd));
+	fdd.fd = fd;
+
 	lseek(fd, sizeof(f_header), SEEK_SET);
 
 	if (session->evlist != evlist)
@@ -1683,14 +1794,14 @@ int perf_session__write_header(struct perf_session *session,
 
 	list_for_each_entry(attr, &evlist->entries, node) {
 		attr->id_offset = lseek(fd, 0, SEEK_CUR);
-		err = do_write(fd, attr->id, attr->ids * sizeof(u64));
+		err = do_write(&fdd, attr->id, attr->ids * sizeof(u64));
 		if (err < 0) {
 out_err_write:
 			pr_debug("failed to write perf header\n");
 			return err;
 		}
 		if (session->evlist != evlist) {
-			err = do_write(fd, pair->id, pair->ids * sizeof(u64));
+			err = do_write(&fdd, pair->id, pair->ids * sizeof(u64));
 			if (err < 0)
 				goto out_err_write;
 			attr->ids += pair->ids;
@@ -1708,7 +1819,7 @@ int perf_session__write_header(struct perf_session *session,
 				.size   = attr->ids * sizeof(u64),
 			}
 		};
-		err = do_write(fd, &f_attr, sizeof(f_attr));
+		err = do_write(&fdd, &f_attr, sizeof(f_attr));
 		if (err < 0) {
 			pr_debug("failed to write perf header attribute\n");
 			return err;
@@ -1718,7 +1829,7 @@ int perf_session__write_header(struct perf_session *session,
 	header->event_offset = lseek(fd, 0, SEEK_CUR);
 	header->event_size = event_count * sizeof(struct perf_trace_event_type);
 	if (events) {
-		err = do_write(fd, events, header->event_size);
+		err = do_write(&fdd, events, header->event_size);
 		if (err < 0) {
 			pr_debug("failed to write perf header events\n");
 			return err;
@@ -1754,7 +1865,7 @@ int perf_session__write_header(struct perf_session *session,
 	memcpy(&f_header.adds_features, &header->adds_features, sizeof(header->adds_features));
 
 	lseek(fd, 0, SEEK_SET);
-	err = do_write(fd, &f_header, sizeof(f_header));
+	err = do_write(&fdd, &f_header, sizeof(f_header));
 	if (err < 0) {
 		pr_debug("failed to write perf header\n");
 		return err;
@@ -2014,8 +2125,13 @@ static int perf_file_header__read_pipe(struct perf_pipe_file_header *header,
 				       struct perf_header *ph, int fd,
 				       bool repipe)
 {
+	struct feat_fd fdd;
 	int ret;
 
+	memset(&fdd, 0, sizeof(fdd));
+	fdd.fd  = STDOUT_FILENO;
+	fdd.hdr = ph;
+
 	ret = readn(fd, header, sizeof(*header));
 	if (ret <= 0)
 		return -1;
@@ -2028,7 +2144,7 @@ static int perf_file_header__read_pipe(struct perf_pipe_file_header *header,
 	if (ph->needs_swap)
 		header->size = bswap_64(header->size);
 
-	if (repipe && do_write(STDOUT_FILENO, header, sizeof(*header)) < 0)
+	if (repipe && do_write(&fdd, header, sizeof(*header)) < 0)
 		return -1;
 
 	return 0;
@@ -2323,6 +2439,58 @@ int perf_event__synthesize_event_types(struct perf_tool *tool,
 	return err;
 }
 
+int perf_event__synthesize_features(struct perf_tool *tool,
+				    struct perf_session *session,
+				    struct perf_evlist *evlist,
+				    perf_event__handler_t process)
+{
+	struct perf_header *header = &session->header;
+	struct feat_fd fdd;
+	struct feature_event *fe;
+	size_t sz, sz_hdr;
+	int feat, ret;
+
+	sz_hdr = sizeof(fe->header);
+	sz = sizeof(union perf_event);
+	/* get a nice alignment */
+	sz = ALIGN(sz, getpagesize());
+
+	memset(&fdd, 0, sizeof(fdd));
+
+	fdd.buf = malloc(sz);
+	if (!fdd.buf)
+		return -1;
+
+	fdd.size = sz - sz_hdr;
+
+	for_each_set_bit(feat, header->adds_features, HEADER_FEAT_BITS) {
+		/*
+		 * those are already written as:
+		 * - PERF_RECORD_HEADER_TRACING_DATA
+		 * - PERF_RECORD_HEADER_BUILD_ID
+		 */
+		if (feat == HEADER_TRACING_DATA || feat == HEADER_BUILD_ID)
+			continue;
+
+		fdd.pos = sizeof(*fe);
+
+		ret = feat_ops[feat].write(&fdd, evlist);
+		if (ret || fdd.pos == sizeof(*fe))
+			continue;
+
+		/* fdd.buf may change due to realloc in do_write() */
+		fe = fdd.buf;
+		memset(fe, 0, sizeof(*fe));
+
+		fe->header.type = feat_ops[feat].record_type;
+		fe->header.size = fdd.pos;
+
+		process(tool, fdd.buf, NULL, NULL);
+	}
+	free(fdd.buf);
+	return 0;
+}
+
 int perf_event__process_event_type(struct perf_tool *tool __unused,
 				   union perf_event *event)
 {
@@ -2338,6 +2506,7 @@ int perf_event__synthesize_tracing_data(struct perf_tool *tool, int fd,
 					perf_event__handler_t process)
 {
 	union perf_event ev;
+	struct feat_fd fdd;
 	struct tracing_data *tdata;
 	ssize_t size = 0, aligned_size = 0, padding;
 	int err __used = 0;
@@ -2374,7 +2543,10 @@ int perf_event__synthesize_tracing_data(struct perf_tool *tool, int fd,
 	 */
 	tracing_data_put(tdata);
 
-	write_padded(fd, NULL, 0, padding);
+	memset(&fdd, 0, sizeof(fdd));
+	fdd.fd = fd;
+
+	write_padded(&fdd, NULL, 0, padding);
 
 	return aligned_size;
 }
@@ -2446,6 +2618,52 @@ int perf_event__process_build_id(struct perf_tool *tool __used,
 	return 0;
 }
 
+int perf_event__process_feature(struct perf_tool *tool,
+				union perf_event *event,
+				 struct perf_session *session __used)
+{
+	struct feat_fd fdd;
+	int type = event->header.type;
+	int feat;
+
+	if (type < 0 || type >= PERF_RECORD_HEADER_MAX) {
+		pr_warning("invalid record type %d\n", type);
+		return 0;
+	}
+	/*
+	 * unhandled feature
+	 */
+	feat = rec2feat[type];
+	if (feat == 0)
+		return 0;
+
+	/*
+	 * no priunt routine
+	 */
+	if (!feat_ops[feat].print)
+		return 0;
+
+	memset(&fdd, 0, sizeof(fdd));
+	fdd.buf  = (void *)event;
+	fdd.buf += sizeof(event->header);
+	fdd.size = event->header.size - sizeof(event->header);
+	/*
+	 * have to assume endianess match for now
+	 * as we do not have the info coming from the header.
+	 *
+	 * Once header is updated, we'll use the info here
+	 */
+	fdd.needs_swap = 0;
+
+	if (!feat_ops[feat].full_only || tool->show_all_features)
+		feat_ops[feat].print(&fdd, stdout);
+	else
+		fprintf(stdout, "# %s info available, use -I to display\n",
+			feat_ops[feat].name);
+
+	return 0;
+}
+
 void disable_buildid_cache(void)
 {
 	no_buildid_cache = true;
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 2d42b3e..af4db9e 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -98,6 +98,15 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 			  const char *name, bool is_kallsyms);
 int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir);
 
+int perf_event__synthesize_features(struct perf_tool *tool,
+				    struct perf_session *session,
+				    struct perf_evlist *evlist,
+				    perf_event__handler_t process);
+
+int perf_event__process_feature(struct perf_tool *tool,
+				union perf_event *event,
+				 struct perf_session *session);
+
 int perf_event__synthesize_attr(struct perf_tool *tool,
 				struct perf_event_attr *attr, u16 ids, u64 *id,
 				perf_event__handler_t process);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index d13e915..84012fa 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -390,6 +390,14 @@ static int process_event_type_stub(struct perf_tool *tool __used,
 	return 0;
 }
 
+static int process_feature_stub(struct perf_tool *tool __used,
+				union perf_event *event __used,
+				struct perf_session *session __used)
+{
+	dump_printf(": unhandled!\n");
+	return 0;
+}
+
 static int process_finished_round(struct perf_tool *tool,
 				  union perf_event *event,
 				  struct perf_session *session);
@@ -428,6 +436,8 @@ static void perf_tool__fill_defaults(struct perf_tool *tool)
 		else
 			tool->finished_round = process_finished_round_stub;
 	}
+	if (tool->feature == NULL)
+		tool->feature = process_feature_stub;
 }
 
 void mem_bswap_64(void *src, int byte_size)
@@ -530,8 +540,8 @@ static perf_event__swap_op perf_event__swap_ops[] = {
 	[PERF_RECORD_SAMPLE]		  = perf_event__all64_swap,
 	[PERF_RECORD_HEADER_ATTR]	  = perf_event__hdr_attr_swap,
 	[PERF_RECORD_HEADER_EVENT_TYPE]	  = perf_event__event_type_swap,
-	[PERF_RECORD_HEADER_TRACING_DATA] = perf_event__tracing_data_swap,
 	[PERF_RECORD_HEADER_BUILD_ID]	  = NULL,
+	[PERF_RECORD_HEADER_TRACING_DATA] = perf_event__tracing_data_swap,
 	[PERF_RECORD_HEADER_MAX]	  = NULL,
 };
 
@@ -939,6 +949,8 @@ static int perf_session__process_user_event(struct perf_session *session, union
 		return tool->build_id(tool, event, session);
 	case PERF_RECORD_FINISHED_ROUND:
 		return tool->finished_round(tool, event, session);
+	case PERF_RECORD_HEADER_HOSTNAME ... PERF_RECORD_HEADER_NUMA_TOPOLOGY:
+		return tool->feature(tool, event, session);
 	default:
 		return -EINVAL;
 	}
@@ -1514,6 +1526,7 @@ void perf_session__fprintf_info(struct perf_session *session, FILE *fp,
 
 	fprintf(fp, "# ========\n");
 	fprintf(fp, "# captured on: %s", ctime(&st.st_ctime));
-	perf_header__fprintf_info(session, fp, full);
 	fprintf(fp, "# ========\n#\n");
+	if (!session->fd_pipe)
+		perf_header__fprintf_info(session, fp, full);
 }
diff --git a/tools/perf/util/tool.h b/tools/perf/util/tool.h
index b0e1aad..af16af1f 100644
--- a/tools/perf/util/tool.h
+++ b/tools/perf/util/tool.h
@@ -42,9 +42,11 @@ struct perf_tool {
 	event_synth_op	tracing_data;
 	event_simple_op	event_type;
 	event_op2	finished_round,
-			build_id;
+			build_id,
+			feature;
 	bool		ordered_samples;
 	bool		ordering_requires_timestamps;
+	bool		show_all_features;
 };
 
 #endif /* __PERF_TOOL_H */
-- 
1.7.4.1

