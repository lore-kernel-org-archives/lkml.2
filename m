Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab2IKX5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 19:57:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:42273 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab2IKXxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 19:53:23 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 16/18] perf evsel: Introduce perf_evsel__{str,int}val methods
Date: Tue, 11 Sep 2012 20:53:08 -0300
Message-Id: <1347407590-30960-17-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347407590-30960-1-git-send-email-acme@infradead.org>
References: <1347407590-30960-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Wrappers to the libtraceevent routines, so that we can further reduce
the surface contact perf builtins have with it.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-rtmgzptvrifzjxqwb9vs6g1b@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c |   35 +++++++++++++++++++++++++++++++++++
 tools/perf/util/evsel.h |    7 +++++++
 2 files changed, 42 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 06f7644..1506ba0 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -10,6 +10,7 @@
 #include <byteswap.h>
 #include <linux/bitops.h>
 #include "asm/bug.h"
+#include "event-parse.h"
 #include "evsel.h"
 #include "evlist.h"
 #include "util.h"
@@ -1000,3 +1001,37 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 
 	return 0;
 }
+
+char *perf_evsel__strval(struct perf_evsel *evsel, struct perf_sample *sample,
+			 const char *name)
+{
+	struct format_field *field = pevent_find_field(evsel->tp_format, name);
+	int offset;
+
+        if (!field)
+                return NULL;
+
+	offset = field->offset;
+
+	if (field->flags & FIELD_IS_DYNAMIC) {
+		offset = *(int *)(sample->raw_data + field->offset);
+		offset &= 0xffff;
+	}
+
+	return sample->raw_data + offset;
+}
+
+u64 perf_evsel__intval(struct perf_evsel *evsel, struct perf_sample *sample,
+		       const char *name)
+{
+	struct format_field *field = pevent_find_field(evsel->tp_format, name);
+	u64 val;
+
+        if (!field)
+                return 0;
+
+	val = pevent_read_number(evsel->tp_format->pevent,
+				 sample->raw_data + field->offset, field->size);
+	return val;
+
+}
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 390690e..dc40fe3 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -120,6 +120,13 @@ int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 		     struct thread_map *threads);
 void perf_evsel__close(struct perf_evsel *evsel, int ncpus, int nthreads);
 
+struct perf_sample;
+
+char *perf_evsel__strval(struct perf_evsel *evsel, struct perf_sample *sample,
+			 const char *name);
+u64 perf_evsel__intval(struct perf_evsel *evsel, struct perf_sample *sample,
+		       const char *name);
+
 #define perf_evsel__match(evsel, t, c)		\
 	(evsel->attr.type == PERF_TYPE_##t &&	\
 	 evsel->attr.config == PERF_COUNT_##c)
-- 
1.7.9.2.358.g22243

