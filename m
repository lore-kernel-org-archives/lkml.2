Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960Ab2FVNg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 09:36:58 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43378 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932888Ab2FVNg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 09:36:56 -0400
Date: Fri, 22 Jun 2012 15:36:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20120622133650.GA24136@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: 6921a575c9f26f7ea274aaea3b78967810ce5513 Merge branch 'tip/perf/urgent-2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace into perf/urgent

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (1):
      perf tools: Fix synthesizing tracepoint names from the perf.data headers

David Ahern (1):
      perf tools: Fix endianity swapping for adds_features bitmask

Salman Qazi (1):
      perf: Use css_tryget() to avoid propping up css refcount

Stephane Eranian (1):
      perf stat: Fix default output file

Steven Rostedt (1):
      ftrace: Make all inline tags also include notrace


 include/linux/compiler-gcc.h           |    6 ++--
 kernel/events/core.c                   |   10 +++++--
 tools/perf/builtin-stat.c              |    8 +++++-
 tools/perf/util/header.c               |   48 +++++++++++++++++++++++++++-----
 tools/perf/util/include/linux/bitops.h |    2 ++
 tools/perf/util/session.c              |   10 +++++++
 tools/perf/util/session.h              |    1 +
 7 files changed, 71 insertions(+), 14 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index e5834aa..6a6d7ae 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -47,9 +47,9 @@
  */
 #if !defined(CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING) || \
     !defined(CONFIG_OPTIMIZE_INLINING) || (__GNUC__ < 4)
-# define inline		inline		__attribute__((always_inline))
-# define __inline__	__inline__	__attribute__((always_inline))
-# define __inline	__inline	__attribute__((always_inline))
+# define inline		inline		__attribute__((always_inline)) notrace
+# define __inline__	__inline__	__attribute__((always_inline)) notrace
+# define __inline	__inline	__attribute__((always_inline)) notrace
 #else
 /* A lot of inline functions can cause havoc with function tracing */
 # define inline		inline		notrace
diff --git a/kernel/events/core.c b/kernel/events/core.c
index f85c015..d7d71d6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -253,9 +253,9 @@ perf_cgroup_match(struct perf_event *event)
 	return !event->cgrp || event->cgrp == cpuctx->cgrp;
 }
 
-static inline void perf_get_cgroup(struct perf_event *event)
+static inline bool perf_tryget_cgroup(struct perf_event *event)
 {
-	css_get(&event->cgrp->css);
+	return css_tryget(&event->cgrp->css);
 }
 
 static inline void perf_put_cgroup(struct perf_event *event)
@@ -484,7 +484,11 @@ static inline int perf_cgroup_connect(int fd, struct perf_event *event,
 	event->cgrp = cgrp;
 
 	/* must be done before we fput() the file */
-	perf_get_cgroup(event);
+	if (!perf_tryget_cgroup(event)) {
+		event->cgrp = NULL;
+		ret = -ENOENT;
+		goto out;
+	}
 
 	/*
 	 * all events in a group must monitor
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 2625899..07b5c77 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1179,6 +1179,12 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 		fprintf(stderr, "cannot use both --output and --log-fd\n");
 		usage_with_options(stat_usage, options);
 	}
+
+	if (output_fd < 0) {
+		fprintf(stderr, "argument to --log-fd must be a > 0\n");
+		usage_with_options(stat_usage, options);
+	}
+
 	if (!output) {
 		struct timespec tm;
 		mode = append_file ? "a" : "w";
@@ -1190,7 +1196,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 		}
 		clock_gettime(CLOCK_REALTIME, &tm);
 		fprintf(output, "# started on %s\n", ctime(&tm.tv_sec));
-	} else if (output_fd != 2) {
+	} else if (output_fd > 0) {
 		mode = append_file ? "a" : "w";
 		output = fdopen(output_fd, mode);
 		if (!output) {
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 2dd5edf..e909d43 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1942,7 +1942,6 @@ int perf_file_header__read(struct perf_file_header *header,
 		else
 			return -1;
 	} else if (ph->needs_swap) {
-		unsigned int i;
 		/*
 		 * feature bitmap is declared as an array of unsigned longs --
 		 * not good since its size can differ between the host that
@@ -1958,14 +1957,17 @@ int perf_file_header__read(struct perf_file_header *header,
 		 * file), punt and fallback to the original behavior --
 		 * clearing all feature bits and setting buildid.
 		 */
-		for (i = 0; i < BITS_TO_LONGS(HEADER_FEAT_BITS); ++i)
-			header->adds_features[i] = bswap_64(header->adds_features[i]);
+		mem_bswap_64(&header->adds_features,
+			    BITS_TO_U64(HEADER_FEAT_BITS));
 
 		if (!test_bit(HEADER_HOSTNAME, header->adds_features)) {
-			for (i = 0; i < BITS_TO_LONGS(HEADER_FEAT_BITS); ++i) {
-				header->adds_features[i] = bswap_64(header->adds_features[i]);
-				header->adds_features[i] = bswap_32(header->adds_features[i]);
-			}
+			/* unswap as u64 */
+			mem_bswap_64(&header->adds_features,
+				    BITS_TO_U64(HEADER_FEAT_BITS));
+
+			/* unswap as u32 */
+			mem_bswap_32(&header->adds_features,
+				    BITS_TO_U32(HEADER_FEAT_BITS));
 		}
 
 		if (!test_bit(HEADER_HOSTNAME, header->adds_features)) {
@@ -2091,6 +2093,35 @@ static int read_attr(int fd, struct perf_header *ph,
 	return ret <= 0 ? -1 : 0;
 }
 
+static int perf_evsel__set_tracepoint_name(struct perf_evsel *evsel)
+{
+	struct event_format *event = trace_find_event(evsel->attr.config);
+	char bf[128];
+
+	if (event == NULL)
+		return -1;
+
+	snprintf(bf, sizeof(bf), "%s:%s", event->system, event->name);
+	evsel->name = strdup(bf);
+	if (event->name == NULL)
+		return -1;
+
+	return 0;
+}
+
+static int perf_evlist__set_tracepoint_names(struct perf_evlist *evlist)
+{
+	struct perf_evsel *pos;
+
+	list_for_each_entry(pos, &evlist->entries, node) {
+		if (pos->attr.type == PERF_TYPE_TRACEPOINT &&
+		    perf_evsel__set_tracepoint_name(pos))
+			return -1;
+	}
+
+	return 0;
+}
+
 int perf_session__read_header(struct perf_session *session, int fd)
 {
 	struct perf_header *header = &session->header;
@@ -2172,6 +2203,9 @@ int perf_session__read_header(struct perf_session *session, int fd)
 
 	lseek(fd, header->data_offset, SEEK_SET);
 
+	if (perf_evlist__set_tracepoint_names(session->evlist))
+		goto out_delete_evlist;
+
 	header->frozen = 1;
 	return 0;
 out_errno:
diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index f1584833..587a230 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -8,6 +8,8 @@
 #define BITS_PER_LONG __WORDSIZE
 #define BITS_PER_BYTE           8
 #define BITS_TO_LONGS(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
+#define BITS_TO_U64(nr)         DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u64))
+#define BITS_TO_U32(nr)         DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u32))
 
 #define for_each_set_bit(bit, addr, size) \
 	for ((bit) = find_first_bit((addr), (size));		\
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 2600916..c3e399b 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -442,6 +442,16 @@ static void perf_tool__fill_defaults(struct perf_tool *tool)
 			tool->finished_round = process_finished_round_stub;
 	}
 }
+ 
+void mem_bswap_32(void *src, int byte_size)
+{
+	u32 *m = src;
+	while (byte_size > 0) {
+		*m = bswap_32(*m);
+		byte_size -= sizeof(u32);
+		++m;
+	}
+}
 
 void mem_bswap_64(void *src, int byte_size)
 {
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 7a5434c..0c702e3 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -80,6 +80,7 @@ struct branch_info *machine__resolve_bstack(struct machine *self,
 bool perf_session__has_traces(struct perf_session *self, const char *msg);
 
 void mem_bswap_64(void *src, int byte_size);
+void mem_bswap_32(void *src, int byte_size);
 void perf_event__attr_swap(struct perf_event_attr *attr);
 
 int perf_session__create_kernel_maps(struct perf_session *self);
