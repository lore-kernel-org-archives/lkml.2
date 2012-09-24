Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab2IXQWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:22:46 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57614 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab2IXQWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:22:42 -0400
Date: Mon, 24 Sep 2012 18:22:36 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, mingo@elte.hu, dsahern@gmail.com,
        namhyung.kim@lge.com
Subject: [PATCH] perf record: add meta-data support for pipe-mode
Message-ID: <20120924162236.GA10606@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds the meta-data header support for perf record
when used in pipe mode: perf record -o -
    
Up until now, meta-data was only available when perf record
was used in "regular" mode, i.e., generating a perf.data file.
For users depending on pipe mode, neither host or event header
information were gathered. This patch addresses this limitation.
    
The difficulty in pipe mode is that information needs to be written
sequentially to the pipe. Meta data headers are usually generated
(and also expected) at the beginning of the file (or piped output).
To solve this problem, we introduce new synthetic record types,
one for each meta-data type. The approach is similar to what
is *ALREADY* used for BUILD_ID and TRACING_DATA.
    
We have modified util/header.c such that the same routines are used
to generate and read the meta-data information regardless of pipe-mode
vs. regular mode. To make this work, we added a new struct called
feat_fd which encapsulates all the information necessary to read or
write meta-data information to a file/pipe or from a file/pipe.

With this patch, it is possible to get:

$ perf record -o - noploop 5 | perf inject -b | perf report -i -
# ========
# captured on: Mon Sep 24 18:16:08 2012
# ========
#
# hostname : quad
# os release : 3.6.0-rc6
# perf version : 3.6.0-rc7
# arch : x86_64
# nrcpus online : 4
# nrcpus avail : 4
# cpudesc : Intel(R) Core(TM)2 Quad CPU Q6600 @ 2.40GHz
# cpuid : GenuineIntel,6,15,11
# total memory : 8092412 kB
# cmdline : /usr/bin/perf record -o - noploop 5 
# ...
# CPU_TOPOLOGY info available, use -I to display
# pmu mappings: cpu = 4, software = 1, tracepoint = 2, breakpoint = 5
noploop for 5 seconds
[ perf record: Woken up 4 times to write data ]
[ perf record: Captured and wrote 0.773 MB - (~33771 samples) ]
# Samples: 20K of event 'cycles'
# Event count (approx.): 11873977966
#
# Overhead  Command      Shared Object                                      Symbol
# ........  .......  .................  ..........................................
#
    98.89%  noploop  noploop            [.] noploop                               
     0.14%  noploop  [kernel.kallsyms]  [k] lock_acquire                          

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 9ea3854..211a9cb 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -247,6 +247,11 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
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
index 1eaa661..bc814ea 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -222,6 +222,7 @@ struct perf_tool perf_inject = {
 	.event_type	= perf_event__repipe_event_type_synth,
 	.tracing_data	= perf_event__repipe_tracing_data_synth,
 	.build_id	= perf_event__repipe_op2_synth,
+	.feature	= perf_event__repipe_op2_synth,
 };
 
 extern volatile int session_done;
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index c643ed6..c536a4e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -590,6 +590,13 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
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
index 1da243d..56e12ba 100644
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
@@ -359,7 +358,8 @@ static int __cmd_report(struct perf_report *rep)
 	}
 
 	if (use_browser <= 0)
-		perf_session__fprintf_info(session, stdout, rep->show_full_info);
+		perf_session__fprintf_info(session, stdout,
+					   rep->tool.show_full_info);
 
 	if (rep->show_threads)
 		perf_read_values_init(&rep->show_threads_values);
@@ -564,6 +564,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 			.event_type	 = perf_event__process_event_type,
 			.tracing_data	 = perf_event__process_tracing_data,
 			.build_id	 = perf_event__process_build_id,
+			.feature         = perf_event__process_feature,
 			.ordered_samples = true,
 			.ordering_requires_timestamps = true,
 		},
@@ -627,7 +628,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Look for files with symbols relative to this directory"),
 	OPT_STRING('C', "cpu", &report.cpu_list, "cpu",
 		   "list of cpus to profile"),
-	OPT_BOOLEAN('I', "show-info", &report.show_full_info,
+	OPT_BOOLEAN('I', "show-info", &report.tool.show_full_info,
 		    "Display extended information about perf.data file"),
 	OPT_BOOLEAN(0, "source", &symbol_conf.annotate_src,
 		    "Interleave source code with assembly code (default)"),
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 6715b19..4c357f8 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -23,6 +23,19 @@ static const char *perf_event__names[] = {
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
+	[PERF_RECORD_HEADER_PMU_MAPPINGS]	= "PMU_MAPPINGS",
 };
 
 const char *perf_event__name(unsigned int id)
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 21b99e7..125858e 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -112,6 +112,19 @@ enum perf_user_event_type { /* above any possible kernel type */
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
+	PERF_RECORD_HEADER_PMU_MAPPINGS		= 81,
 	PERF_RECORD_HEADER_MAX
 };
 
@@ -138,6 +151,11 @@ struct tracing_data_event {
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
@@ -151,6 +169,7 @@ union perf_event {
 	struct event_type_event		event_type;
 	struct tracing_data_event	tracing_data;
 	struct build_id_event		build_id;
+	struct feature_event		feat;
 };
 
 void perf_event__print_totals(void);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index acbf633..971447d 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -22,6 +22,16 @@
 #include "cpumap.h"
 #include "pmu.h"
 #include "vdso.h"
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
 
@@ -95,14 +105,46 @@ bool perf_header__has_feat(const struct perf_header *header, int feat)
 	return test_bit(feat, header->adds_features);
 }
 
-static int do_write(int fd, const void *buf, size_t size)
+static ssize_t do_read(struct feat_fd *fd, void *addr, size_t size)
 {
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
+{
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
@@ -112,7 +154,7 @@ static int do_write(int fd, const void *buf, size_t size)
 
 #define NAME_ALIGN 64
 
-static int write_padded(int fd, const void *bf, size_t count,
+static int write_padded(struct feat_fd *fd, const void *bf, size_t count,
 			size_t count_aligned)
 {
 	static const char zero_buf[NAME_ALIGN];
@@ -124,7 +166,7 @@ static int write_padded(int fd, const void *bf, size_t count,
 	return err;
 }
 
-static int do_write_string(int fd, const char *str)
+static int do_write_string(struct feat_fd *fd, const char *str)
 {
 	u32 len, olen;
 	int ret;
@@ -140,24 +182,35 @@ static int do_write_string(int fd, const char *str)
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
@@ -166,7 +219,6 @@ static char *do_read_string(int fd, struct perf_header *ph)
 		 */
 		return buf;
 	}
-
 	free(buf);
 	return NULL;
 }
@@ -209,7 +261,7 @@ perf_header__set_cmdline(int argc, const char **argv)
 		else
 
 static int write_buildid(char *name, size_t name_len, u8 *build_id,
-			 pid_t pid, u16 misc, int fd)
+			 pid_t pid, u16 misc, struct feat_fd *fdd)
 {
 	int err;
 	struct build_id_event b;
@@ -224,15 +276,15 @@ static int write_buildid(char *name, size_t name_len, u8 *build_id,
 	b.header.misc = misc;
 	b.header.size = sizeof(b) + len;
 
-	err = do_write(fd, &b, sizeof(b));
+	err = do_write(fdd, &b, sizeof(b));
 	if (err < 0)
 		return err;
 
-	return write_padded(fd, name, name_len + 1, len);
+	return write_padded(fdd, name, name_len + 1, len);
 }
 
 static int __dsos__write_buildid_table(struct list_head *head, pid_t pid,
-				u16 misc, int fd)
+				u16 misc, struct feat_fd *fd)
 {
 	struct dso *pos;
 
@@ -261,7 +313,8 @@ static int __dsos__write_buildid_table(struct list_head *head, pid_t pid,
 	return 0;
 }
 
-static int machine__write_buildid_table(struct machine *machine, int fd)
+static int machine__write_buildid_table(struct machine *machine,
+					struct feat_fd *fd)
 {
 	int err;
 	u16 kmisc = PERF_RECORD_MISC_KERNEL,
@@ -280,7 +333,8 @@ static int machine__write_buildid_table(struct machine *machine, int fd)
 	return err;
 }
 
-static int dsos__write_buildid_table(struct perf_header *header, int fd)
+static int dsos__write_buildid_table(struct perf_header *header,
+				     struct feat_fd *fd)
 {
 	struct perf_session *session = container_of(header,
 			struct perf_session, header);
@@ -475,25 +529,24 @@ static bool perf_session__read_build_ids(struct perf_session *session, bool with
 	return ret;
 }
 
-static int write_tracing_data(int fd, struct perf_header *h __maybe_unused,
-			    struct perf_evlist *evlist)
+static int write_tracing_data(struct feat_fd *fd, struct perf_evlist *evlist)
 {
-	return read_tracing_data(fd, &evlist->entries);
+	return read_tracing_data(fd->fd, &evlist->entries);
 }
 
 
-static int write_build_id(int fd, struct perf_header *h,
+static int write_build_id(struct feat_fd *fd,
 			  struct perf_evlist *evlist __maybe_unused)
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
@@ -504,7 +557,7 @@ static int write_build_id(int fd, struct perf_header *h,
 	return 0;
 }
 
-static int write_hostname(int fd, struct perf_header *h __maybe_unused,
+static int write_hostname(struct feat_fd *fd,
 			  struct perf_evlist *evlist __maybe_unused)
 {
 	struct utsname uts;
@@ -517,7 +570,7 @@ static int write_hostname(int fd, struct perf_header *h __maybe_unused,
 	return do_write_string(fd, uts.nodename);
 }
 
-static int write_osrelease(int fd, struct perf_header *h __maybe_unused,
+static int write_osrelease(struct feat_fd *fd,
 			   struct perf_evlist *evlist __maybe_unused)
 {
 	struct utsname uts;
@@ -530,7 +583,7 @@ static int write_osrelease(int fd, struct perf_header *h __maybe_unused,
 	return do_write_string(fd, uts.release);
 }
 
-static int write_arch(int fd, struct perf_header *h __maybe_unused,
+static int write_arch(struct feat_fd *fd,
 		      struct perf_evlist *evlist __maybe_unused)
 {
 	struct utsname uts;
@@ -543,14 +596,14 @@ static int write_arch(int fd, struct perf_header *h __maybe_unused,
 	return do_write_string(fd, uts.machine);
 }
 
-static int write_version(int fd, struct perf_header *h __maybe_unused,
+static int write_version(struct feat_fd *fd,
 			 struct perf_evlist *evlist __maybe_unused)
 {
 	return do_write_string(fd, perf_version_string);
 }
 
-static int write_cpudesc(int fd, struct perf_header *h __maybe_unused,
-		       struct perf_evlist *evlist __maybe_unused)
+static int write_cpudesc(struct feat_fd *fd,
+			 struct perf_evlist *evlist __maybe_unused)
 {
 #ifndef CPUINFO_PROC
 #define CPUINFO_PROC NULL
@@ -608,7 +661,7 @@ static int write_cpudesc(int fd, struct perf_header *h __maybe_unused,
 	return ret;
 }
 
-static int write_nrcpus(int fd, struct perf_header *h __maybe_unused,
+static int write_nrcpus(struct feat_fd *fd,
 			struct perf_evlist *evlist __maybe_unused)
 {
 	long nr;
@@ -634,8 +687,7 @@ static int write_nrcpus(int fd, struct perf_header *h __maybe_unused,
 	return do_write(fd, &nra, sizeof(nra));
 }
 
-static int write_event_desc(int fd, struct perf_header *h __maybe_unused,
-			    struct perf_evlist *evlist)
+static int write_event_desc(struct feat_fd *fd, struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel;
 	u32 nre, nri, sz;
@@ -691,7 +743,7 @@ static int write_event_desc(int fd, struct perf_header *h __maybe_unused,
 	return 0;
 }
 
-static int write_cmdline(int fd, struct perf_header *h __maybe_unused,
+static int write_cmdline(struct feat_fd *fd,
 			 struct perf_evlist *evlist __maybe_unused)
 {
 	char buf[MAXPATHLEN];
@@ -860,8 +912,8 @@ static struct cpu_topo *build_cpu_topology(void)
 	return tp;
 }
 
-static int write_cpu_topology(int fd, struct perf_header *h __maybe_unused,
-			  struct perf_evlist *evlist __maybe_unused)
+static int write_cpu_topology(struct feat_fd *fd,
+			      struct perf_evlist *evlist __maybe_unused)
 {
 	struct cpu_topo *tp;
 	u32 i;
@@ -894,10 +946,8 @@ static int write_cpu_topology(int fd, struct perf_header *h __maybe_unused,
 	return ret;
 }
 
-
-
-static int write_total_mem(int fd, struct perf_header *h __maybe_unused,
-			  struct perf_evlist *evlist __maybe_unused)
+static int write_total_mem(struct feat_fd *fd,
+			   struct perf_evlist *evlist __maybe_unused)
 {
 	char *buf = NULL;
 	FILE *fp;
@@ -924,7 +974,7 @@ static int write_total_mem(int fd, struct perf_header *h __maybe_unused,
 	return ret;
 }
 
-static int write_topo_node(int fd, int node)
+static int write_topo_node(struct feat_fd *fd, int node)
 {
 	char str[MAXPATHLEN];
 	char field[32];
@@ -982,8 +1032,8 @@ static int write_topo_node(int fd, int node)
 	return ret;
 }
 
-static int write_numa_topology(int fd, struct perf_header *h __maybe_unused,
-			  struct perf_evlist *evlist __maybe_unused)
+static int write_numa_topology(struct feat_fd *fd,
+			       struct perf_evlist *evlist __maybe_unused)
 {
 	char *buf = NULL;
 	size_t len = 0;
@@ -1043,30 +1093,31 @@ static int write_numa_topology(int fd, struct perf_header *h __maybe_unused,
  * };
  */
 
-static int write_pmu_mappings(int fd, struct perf_header *h __maybe_unused,
+static int write_pmu_mappings(struct feat_fd *fd,
 			      struct perf_evlist *evlist __maybe_unused)
 {
 	struct perf_pmu *pmu = NULL;
-	off_t offset = lseek(fd, 0, SEEK_CUR);
-	__u32 pmu_num = 0;
+	u32 pmu_num = 0;
+
+	/*
+	 * first pass to count number of pmu
+	 * avoid lseek so this works in pipe mode as well
+	 */
+	while ((pmu = perf_pmu__scan(pmu))) {
+		if (!pmu->name)
+			continue;
+		pmu_num++;
+	}
 
-	/* write real pmu_num later */
 	do_write(fd, &pmu_num, sizeof(pmu_num));
 
 	while ((pmu = perf_pmu__scan(pmu))) {
 		if (!pmu->name)
 			continue;
-		pmu_num++;
 		do_write(fd, &pmu->type, sizeof(pmu->type));
 		do_write_string(fd, pmu->name);
 	}
 
-	if (pwrite(fd, &pmu_num, sizeof(pmu_num), offset) != sizeof(pmu_num)) {
-		/* discard all */
-		lseek(fd, offset, SEEK_SET);
-		return -1;
-	}
-
 	return 0;
 }
 
@@ -1080,7 +1131,7 @@ int __attribute__ ((weak)) get_cpuid(char *buffer __maybe_unused,
 	return -1;
 }
 
-static int write_cpuid(int fd, struct perf_header *h __maybe_unused,
+static int write_cpuid(struct feat_fd *fd,
 		       struct perf_evlist *evlist __maybe_unused)
 {
 	char buffer[64];
@@ -1095,123 +1146,122 @@ static int write_cpuid(int fd, struct perf_header *h __maybe_unused,
 	return do_write_string(fd, buffer);
 }
 
-static int write_branch_stack(int fd __maybe_unused,
-			      struct perf_header *h __maybe_unused,
-		       struct perf_evlist *evlist __maybe_unused)
+static int write_branch_stack(struct feat_fd *fd __maybe_unused,
+			      struct perf_evlist *evlist __maybe_unused)
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
@@ -1235,7 +1285,7 @@ static void free_event_desc(struct perf_evsel *events)
 }
 
 static struct perf_evsel *
-read_event_desc(struct perf_header *ph, int fd)
+read_event_desc(struct feat_fd *fd)
 {
 	struct perf_evsel *evsel, *events = NULL;
 	u64 *id;
@@ -1245,18 +1295,18 @@ read_event_desc(struct perf_header *ph, int fd)
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
 
 	/* buffer to hold on file attr struct */
@@ -1280,23 +1330,23 @@ read_event_desc(struct perf_header *ph, int fd)
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
 
 		memcpy(&evsel->attr, buf, msz);
 
-		ret = read(fd, &nr, sizeof(nr));
+		ret = do_read(fd, &nr, sizeof(nr));
 		if (ret != (ssize_t)sizeof(nr))
 			goto error;
 
-		if (ph->needs_swap)
+		if (fd->needs_swap)
 			nr = bswap_32(nr);
 
-		evsel->name = do_read_string(fd, ph);
+		evsel->name = do_read_string(fd);
 
 		if (!nr)
 			continue;
@@ -1308,10 +1358,10 @@ read_event_desc(struct perf_header *ph, int fd)
 		evsel->id = id;
 
 		for (j = 0 ; j < nr; j++) {
-			ret = read(fd, id, sizeof(*id));
+			ret = do_read(fd, id, sizeof(*id));
 			if (ret != (ssize_t)sizeof(*id))
 				goto error;
-			if (ph->needs_swap)
+			if (fd->needs_swap)
 				*id = bswap_64(*id);
 			id++;
 		}
@@ -1327,9 +1377,9 @@ read_event_desc(struct perf_header *ph, int fd)
 	goto out;
 }
 
-static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
+static void print_event_desc(struct feat_fd *fd, FILE *fp)
 {
-	struct perf_evsel *evsel, *events = read_event_desc(ph, fd);
+	struct perf_evsel *evsel, *events = read_event_desc(fd);
 	u32 j;
 	u64 *id;
 
@@ -1374,17 +1424,16 @@ static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
 	free_event_desc(events);
 }
 
-static void print_total_mem(struct perf_header *h __maybe_unused, int fd,
-			    FILE *fp)
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
@@ -1393,8 +1442,7 @@ static void print_total_mem(struct perf_header *h __maybe_unused, int fd,
 	fprintf(fp, "# total memory : unknown\n");
 }
 
-static void print_numa_topology(struct perf_header *h __maybe_unused, int fd,
-				FILE *fp)
+static void print_numa_topology(struct feat_fd *fd, FILE *fp)
 {
 	ssize_t ret;
 	u32 nr, c, i;
@@ -1402,32 +1450,32 @@ static void print_numa_topology(struct perf_header *h __maybe_unused, int fd,
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
@@ -1438,7 +1486,7 @@ static void print_numa_topology(struct perf_header *h __maybe_unused, int fd,
 			mem_total,
 			mem_free);
 
-		str = do_read_string(fd, h);
+		str = do_read_string(fd);
 		fprintf(fp, "# node%u cpu list : %s\n", c, str);
 		free(str);
 	}
@@ -1447,21 +1495,19 @@ static void print_numa_topology(struct perf_header *h __maybe_unused, int fd,
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
 
-static void print_branch_stack(struct perf_header *ph __maybe_unused,
-			       int fd __maybe_unused,
-			       FILE *fp)
+static void print_branch_stack(struct feat_fd *fd __maybe_unused, FILE *fp)
 {
 	fprintf(fp, "# contains samples with branch stack\n");
 }
 
-static void print_pmu_mappings(struct perf_header *ph, int fd, FILE *fp)
+static void print_pmu_mappings(struct feat_fd *fd, FILE *fp)
 {
 	const char *delimiter = "# pmu mappings: ";
 	char *name;
@@ -1469,11 +1515,11 @@ static void print_pmu_mappings(struct perf_header *ph, int fd, FILE *fp)
 	u32 pmu_num;
 	u32 type;
 
-	ret = read(fd, &pmu_num, sizeof(pmu_num));
+	ret = do_read(fd, &pmu_num, sizeof(pmu_num));
 	if (ret != sizeof(pmu_num))
 		goto error;
 
-	if (ph->needs_swap)
+	if (fd->needs_swap)
 		pmu_num = bswap_32(pmu_num);
 
 	if (!pmu_num) {
@@ -1482,12 +1528,12 @@ static void print_pmu_mappings(struct perf_header *ph, int fd, FILE *fp)
 	}
 
 	while (pmu_num) {
-		if (read(fd, &type, sizeof(type)) != sizeof(type))
+		if (do_read(fd, &type, sizeof(type)) != sizeof(type))
 			break;
-		if (ph->needs_swap)
+		if (fd->needs_swap)
 			type = bswap_32(type);
 
-		name = do_read_string(fd, ph);
+		name = do_read_string(fd);
 		if (!name)
 			break;
 		pmu_num--;
@@ -1709,9 +1755,15 @@ process_event_desc(struct perf_file_section *section __maybe_unused,
 		   struct perf_header *header, int feat __maybe_unused, int fd,
 		   void *data __maybe_unused)
 {
+	struct feat_fd fdd;
 	struct perf_session *session = container_of(header, struct perf_session, header);
-	struct perf_evsel *evsel, *events = read_event_desc(header, fd);
+	struct perf_evsel *evsel, *events;
+
+	memset(&fdd, 0, sizeof(fdd));
+	fdd.fd = fd;
+	fdd.needs_swap = header->needs_swap;
 
+	events = read_event_desc(&fdd);
 	if (!events)
 		return 0;
 
@@ -1724,44 +1776,90 @@ process_event_desc(struct perf_file_section *section __maybe_unused,
 }
 
 struct feature_ops {
-	int (*write)(int fd, struct perf_header *h, struct perf_evlist *evlist);
-	void (*print)(struct perf_header *h, int fd, FILE *fp);
+	int (*write)(struct feat_fd *fd, struct perf_evlist *evlist);
+	void (*print)(struct feat_fd *h, FILE *fp);
 	int (*process)(struct perf_file_section *section,
 		       struct perf_header *h, int feat, int fd, void *data);
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
-	FEAT_OPP(HEADER_EVENT_DESC,	event_desc),
-	FEAT_OPA(HEADER_CMDLINE,	cmdline),
-	FEAT_OPF(HEADER_CPU_TOPOLOGY,	cpu_topology),
-	FEAT_OPF(HEADER_NUMA_TOPOLOGY,	numa_topology),
-	FEAT_OPA(HEADER_BRANCH_STACK,	branch_stack),
-	FEAT_OPA(HEADER_PMU_MAPPINGS,	pmu_mappings),
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
+	FEAT_OPP(EVENT_DESC,	event_desc),
+	FEAT_OPA(CMDLINE,	cmdline),
+	FEAT_OPF(CPU_TOPOLOGY,	cpu_topology),
+	FEAT_OPF(NUMA_TOPOLOGY,	numa_topology),
+	FEAT_OPB(BRANCH_STACK,	branch_stack),
+	FEAT_OPA(PMU_MAPPINGS,	pmu_mappings),
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
+	REC2FEAT(PMU_MAPPINGS),
 };
 
 struct header_print_data {
@@ -1774,6 +1872,7 @@ static int perf_file_section__fprintf_info(struct perf_file_section *section,
 					   int feat, int fd, void *data)
 {
 	struct header_print_data *hd = data;
+	struct feat_fd fdd;
 
 	if (lseek(fd, section->offset, SEEK_SET) == (off_t)-1) {
 		pr_debug("Failed to lseek to %" PRIu64 " offset for feature "
@@ -1787,8 +1886,13 @@ static int perf_file_section__fprintf_info(struct perf_file_section *section,
 	if (!feat_ops[feat].print)
 		return 0;
 
+	memset(&fdd, 0, sizeof(fdd));
+	fdd.fd = fd;
+	fdd.hdr = ph;
+	fdd.needs_swap = ph->needs_swap;
+
 	if (!feat_ops[feat].full_only || hd->full)
-		feat_ops[feat].print(ph, fd, hd->fp);
+		feat_ops[feat].print(&fdd, hd->fp);
 	else
 		fprintf(hd->fp, "# %s info available, use -I to display\n",
 			feat_ops[feat].name);
@@ -1809,44 +1913,51 @@ int perf_header__fprintf_info(struct perf_session *session, FILE *fp, bool full)
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
@@ -1861,38 +1972,40 @@ static int perf_header__adds_write(struct perf_header *header,
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
 
@@ -1900,12 +2013,16 @@ int perf_session__write_header(struct perf_session *session,
 			       struct perf_evlist *evlist,
 			       int fd, bool at_exit)
 {
+	struct feat_fd fdd;
 	struct perf_file_header f_header;
 	struct perf_file_attr   f_attr;
 	struct perf_header *header = &session->header;
 	struct perf_evsel *evsel, *pair = NULL;
 	int err;
 
+	memset(&fdd, 0, sizeof(fdd));
+	fdd.fd = fd;
+
 	lseek(fd, sizeof(f_header), SEEK_SET);
 
 	if (session->evlist != evlist)
@@ -1913,14 +2030,14 @@ int perf_session__write_header(struct perf_session *session,
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		evsel->id_offset = lseek(fd, 0, SEEK_CUR);
-		err = do_write(fd, evsel->id, evsel->ids * sizeof(u64));
+		err = do_write(&fdd, evsel->id, evsel->ids * sizeof(u64));
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
 			evsel->ids += pair->ids;
@@ -1938,7 +2055,7 @@ int perf_session__write_header(struct perf_session *session,
 				.size   = evsel->ids * sizeof(u64),
 			}
 		};
-		err = do_write(fd, &f_attr, sizeof(f_attr));
+		err = do_write(&fdd, &f_attr, sizeof(f_attr));
 		if (err < 0) {
 			pr_debug("failed to write perf header attribute\n");
 			return err;
@@ -1948,7 +2065,7 @@ int perf_session__write_header(struct perf_session *session,
 	header->event_offset = lseek(fd, 0, SEEK_CUR);
 	header->event_size = trace_event_count * sizeof(struct perf_trace_event_type);
 	if (trace_events) {
-		err = do_write(fd, trace_events, header->event_size);
+		err = do_write(&fdd, trace_events, header->event_size);
 		if (err < 0) {
 			pr_debug("failed to write perf header events\n");
 			return err;
@@ -1984,7 +2101,7 @@ int perf_session__write_header(struct perf_session *session,
 	memcpy(&f_header.adds_features, &header->adds_features, sizeof(header->adds_features));
 
 	lseek(fd, 0, SEEK_SET);
-	err = do_write(fd, &f_header, sizeof(f_header));
+	err = do_write(&fdd, &f_header, sizeof(f_header));
 	if (err < 0) {
 		pr_debug("failed to write perf header\n");
 		return err;
@@ -2248,8 +2365,13 @@ static int perf_file_header__read_pipe(struct perf_pipe_file_header *header,
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
@@ -2262,7 +2384,7 @@ static int perf_file_header__read_pipe(struct perf_pipe_file_header *header,
 	if (ph->needs_swap)
 		header->size = bswap_64(header->size);
 
-	if (repipe && do_write(STDOUT_FILENO, header, sizeof(*header)) < 0)
+	if (repipe && do_write(&fdd, header, sizeof(*header)) < 0)
 		return -1;
 
 	return 0;
@@ -2603,6 +2725,58 @@ int perf_event__synthesize_event_types(struct perf_tool *tool,
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
+	sz = PERF_ALIGN(sz, getpagesize());
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
 int perf_event__process_event_type(struct perf_tool *tool __maybe_unused,
 				   union perf_event *event)
 {
@@ -2618,6 +2792,7 @@ int perf_event__synthesize_tracing_data(struct perf_tool *tool, int fd,
 					perf_event__handler_t process)
 {
 	union perf_event ev;
+	struct feat_fd fdd;
 	struct tracing_data *tdata;
 	ssize_t size = 0, aligned_size = 0, padding;
 	int err __maybe_unused = 0;
@@ -2654,7 +2829,10 @@ int perf_event__synthesize_tracing_data(struct perf_tool *tool, int fd,
 	 */
 	tracing_data_put(tdata);
 
-	write_padded(fd, NULL, 0, padding);
+	memset(&fdd, 0, sizeof(fdd));
+	fdd.fd = fd;
+
+	write_padded(&fdd, NULL, 0, padding);
 
 	return aligned_size;
 }
@@ -2729,6 +2907,52 @@ int perf_event__process_build_id(struct perf_tool *tool __maybe_unused,
 	return 0;
 }
 
+int perf_event__process_feature(struct perf_tool *tool,
+				union perf_event *event,
+				struct perf_session *session __maybe_unused)
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
+	if (!feat_ops[feat].full_only || tool->show_full_info)
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
index 209dad4..e277728 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -99,6 +99,15 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 			  const char *name, bool is_kallsyms, bool is_vdso);
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
 				struct perf_event_attr *attr, u32 ids, u64 *id,
 				perf_event__handler_t process);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 3049b0a..99538bf 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -453,6 +453,14 @@ static int process_event_type_stub(struct perf_tool *tool __maybe_unused,
 	return 0;
 }
 
+static int process_feature_stub(struct perf_tool *tool __maybe_unused,
+				union perf_event *event __maybe_unused,
+				struct perf_session *session __maybe_unused)
+{
+	dump_printf(": unhandled!\n");
+	return 0;
+}
+
 static int process_finished_round(struct perf_tool *tool,
 				  union perf_event *event,
 				  struct perf_session *session);
@@ -491,6 +499,8 @@ static void perf_tool__fill_defaults(struct perf_tool *tool)
 		else
 			tool->finished_round = process_finished_round_stub;
 	}
+	if (tool->feature == NULL)
+		tool->feature = process_feature_stub;
 }
  
 void mem_bswap_32(void *src, int byte_size)
@@ -672,8 +682,8 @@ static perf_event__swap_op perf_event__swap_ops[] = {
 	[PERF_RECORD_SAMPLE]		  = perf_event__all64_swap,
 	[PERF_RECORD_HEADER_ATTR]	  = perf_event__hdr_attr_swap,
 	[PERF_RECORD_HEADER_EVENT_TYPE]	  = perf_event__event_type_swap,
-	[PERF_RECORD_HEADER_TRACING_DATA] = perf_event__tracing_data_swap,
 	[PERF_RECORD_HEADER_BUILD_ID]	  = NULL,
+	[PERF_RECORD_HEADER_TRACING_DATA] = perf_event__tracing_data_swap,
 	[PERF_RECORD_HEADER_MAX]	  = NULL,
 };
 
@@ -1138,6 +1148,8 @@ static int perf_session__process_user_event(struct perf_session *session, union
 		return tool->build_id(tool, event, session);
 	case PERF_RECORD_FINISHED_ROUND:
 		return tool->finished_round(tool, event, session);
+	case PERF_RECORD_HEADER_HOSTNAME ... PERF_RECORD_HEADER_PMU_MAPPINGS:
+		return tool->feature(tool, event, session);
 	default:
 		return -EINVAL;
 	}
@@ -1709,8 +1721,9 @@ void perf_session__fprintf_info(struct perf_session *session, FILE *fp,
 
 	fprintf(fp, "# ========\n");
 	fprintf(fp, "# captured on: %s", ctime(&st.st_ctime));
-	perf_header__fprintf_info(session, fp, full);
 	fprintf(fp, "# ========\n#\n");
+	if (!session->fd_pipe)
+		perf_header__fprintf_info(session, fp, full);
 }
 
 
diff --git a/tools/perf/util/tool.h b/tools/perf/util/tool.h
index b0e1aad..f6307a8 100644
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
+	bool		show_full_info;
 };
 
 #endif /* __PERF_TOOL_H */
