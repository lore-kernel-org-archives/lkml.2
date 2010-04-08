Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813Ab0DHOjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 10:39:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36250 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758780Ab0DHOjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 10:39:01 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/6] perf tools: Reorganize some structs to save space
Date: Thu,  8 Apr 2010 11:38:46 -0300
Message-Id: <1270737529-24258-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1270737529-24258-1-git-send-email-acme@infradead.org>
References: <1270737529-24258-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Using 'pahole --packable' I found some structs that could be reorganized
to eliminate alignment holes, in some cases getting them to be cacheline
multiples.

[acme@doppio linux-2.6-tip]$ codiff perf.old ~/bin/perf
builtin-annotate.c:
  struct perf_session    |   -8
  struct perf_header     |   -8
 2 structs changed

builtin-diff.c:
  struct sample_data         |   -8
 1 struct changed
  diff__process_sample_event |   -8
 1 function changed, 8 bytes removed, diff: -8

builtin-sched.c:
  struct sched_atom      |   -8
 1 struct changed

builtin-timechart.c:
  struct per_pid         |   -8
 1 struct changed
  cmd_timechart          |  -16
 1 function changed, 16 bytes removed, diff: -16

builtin-probe.c:
  struct perf_probe_point |   -8
  struct perf_probe_event |   -8
 2 structs changed
  opt_add_probe_event     |   -3
 1 function changed, 3 bytes removed, diff: -3

util/probe-finder.c:
  struct probe_finder      |   -8
 1 struct changed
  find_kprobe_trace_events |  -16
 1 function changed, 16 bytes removed, diff: -16

/home/acme/bin/perf:
 4 functions changed, 43 bytes removed, diff: -43
[acme@doppio linux-2.6-tip]$

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c     |    2 +-
 tools/perf/builtin-timechart.c |    2 --
 tools/perf/util/event.h        |    4 ++--
 tools/perf/util/header.h       |    2 +-
 tools/perf/util/probe-event.h  |    2 +-
 tools/perf/util/probe-finder.h |    4 ++--
 6 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 4f5a03e..5e59c0c 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -68,10 +68,10 @@ enum sched_event_type {
 
 struct sched_atom {
 	enum sched_event_type	type;
+	int			specific_wait;
 	u64			timestamp;
 	u64			duration;
 	unsigned long		nr;
-	int			specific_wait;
 	sem_t			*wait_sem;
 	struct task_desc	*wakee;
 };
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 266e7aa..369c1b4 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -77,8 +77,6 @@ struct per_pid {
 
 	struct per_pidcomm *all;
 	struct per_pidcomm *current;
-
-	int painted;
 };
 
 
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index a33b949..7f7cf85 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -68,11 +68,11 @@ struct sample_data {
 	u64 addr;
 	u64 id;
 	u64 stream_id;
-	u32 cpu;
 	u64 period;
-	struct ip_callchain *callchain;
+	u32 cpu;
 	u32 raw_size;
 	void *raw_data;
+	struct ip_callchain *callchain;
 };
 
 #define BUILD_ID_SIZE 20
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 82a6af7..c059f08 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -47,13 +47,13 @@ int perf_file_header__read(struct perf_file_header *self,
 struct perf_header {
 	int			frozen;
 	int			attrs, size;
+	bool			needs_swap;
 	struct perf_header_attr **attr;
 	s64			attr_offset;
 	u64			data_offset;
 	u64			data_size;
 	u64			event_offset;
 	u64			event_size;
-	bool			needs_swap;
 	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
 };
 
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index cd308b0..9d99fc2 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -40,9 +40,9 @@ struct perf_probe_point {
 	char		*file;		/* File path */
 	char		*function;	/* Function name */
 	int		line;		/* Line number */
+	bool		retprobe;	/* Return probe flag */
 	char		*lazy_line;	/* Lazy matching pattern */
 	unsigned long	offset;		/* Offset from function entry */
-	bool		retprobe;	/* Return probe flag */
 };
 
 /* Perf probe probing argument field chain */
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 3564f22..2a27132 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -31,13 +31,13 @@ extern int find_line_range(int fd, struct line_range *lr);
 
 struct probe_finder {
 	struct perf_probe_event	*pev;		/* Target probe event */
-	int			ntevs;		/* number of trace events */
 	struct kprobe_trace_event *tevs;	/* Result trace events */
+	int			ntevs;		/* number of trace events */
 
 	/* For function searching */
+	int			lno;		/* Line number */
 	Dwarf_Addr		addr;		/* Address */
 	const char		*fname;		/* Real file name */
-	int			lno;		/* Line number */
 	Dwarf_Die		cu_die;		/* Current CU */
 	struct list_head	lcache;		/* Line cache for lazy match */
 
-- 
1.6.2.5

