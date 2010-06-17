Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760706Ab0FQUlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:41:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49314 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933242Ab0FQUkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:40:12 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
       "David S. Miller" <davem@davemloft.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/7] perf record: Add option to avoid updating buildid cache
Date: Thu, 17 Jun 2010 17:40:00 -0300
Message-Id: <1276807204-22512-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1276807204-22512-1-git-send-email-acme@infradead.org>
References: <1276807204-22512-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

There are situations where there is enough information in the perf.data
to process the samples. Updating the buildid cache may add unecessary
overhead in terms of disk space and time (copying large elf images).

A persistent option to do this already exists via the perfconfig file,
simply do:

[buildid]
dir = /dev/null

This patch provides a way to suppress builid cache updates on a per-run
basis.  It addds a new option, -N, to perf record. Buildids are still
generated in the perf.data file.

Cc: David S. Miller <davem@davemloft.net>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <4c19ef89.93ecd80a.40dc.fffff8e9@mx.google.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-record.txt |    6 ++++++
 tools/perf/builtin-record.c              |    5 +++++
 tools/perf/util/header.c                 |   10 +++++++++-
 tools/perf/util/util.h                   |    1 +
 4 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 25576b4..3ee27dc 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -110,6 +110,12 @@ comma-sperated list with no space: 0,1. Ranges of CPUs are specified with -: 0-2
 In per-thread mode with inheritance mode on (default), samples are captured only when
 the thread executes on the designated CPUs. Default is to monitor all CPUs.
 
+-N::
+--no-buildid-cache::
+Do not update the builid cache. This saves some overhead in situations
+where the information in the perf.data file (which includes buildids)
+is sufficient.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 5efc3fc..86b1c3b 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -60,6 +60,7 @@ static bool			call_graph			=  false;
 static bool			inherit_stat			=  false;
 static bool			no_samples			=  false;
 static bool			sample_address			=  false;
+static bool			no_buildid			=  false;
 
 static long			samples				=      0;
 static u64			bytes_written			=      0;
@@ -825,6 +826,8 @@ static const struct option options[] = {
 		    "Sample addresses"),
 	OPT_BOOLEAN('n', "no-samples", &no_samples,
 		    "don't sample"),
+	OPT_BOOLEAN('N', "no-buildid-cache", &no_buildid,
+		    "do not update the buildid cache"),
 	OPT_END()
 };
 
@@ -849,6 +852,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	}
 
 	symbol__init();
+	if (no_buildid)
+		disable_buildid_cache();
 
 	if (!nr_counters) {
 		nr_counters	= 1;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 4a6a4b3..d7e67b1 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -16,6 +16,8 @@
 #include "symbol.h"
 #include "debug.h"
 
+static bool no_buildid_cache = false;
+
 /*
  * Create new perf.data header attribute:
  */
@@ -470,7 +472,8 @@ static int perf_header__adds_write(struct perf_header *self, int fd)
 		}
 		buildid_sec->size = lseek(fd, 0, SEEK_CUR) -
 					  buildid_sec->offset;
-		perf_session__cache_build_ids(session);
+		if (!no_buildid_cache)
+			perf_session__cache_build_ids(session);
 	}
 
 	lseek(fd, sec_start, SEEK_SET);
@@ -1189,3 +1192,8 @@ int event__process_build_id(event_t *self,
 				 session);
 	return 0;
 }
+
+void disable_buildid_cache(void)
+{
+	no_buildid_cache = true;
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index de61441..f380fed 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -154,6 +154,7 @@ extern void set_die_routine(void (*routine)(const char *err, va_list params) NOR
 
 extern int prefixcmp(const char *str, const char *prefix);
 extern void set_buildid_dir(void);
+extern void disable_buildid_cache(void);
 
 static inline const char *skip_prefix(const char *str, const char *prefix)
 {
-- 
1.6.2.5

