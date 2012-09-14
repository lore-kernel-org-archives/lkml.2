Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab2INGFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:05:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48799 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab2INGFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:05:14 -0400
Date: Thu, 13 Sep 2012 23:04:53 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-rtmgzptvrifzjxqwb9vs6g1b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Introduce perf_evsel__{str,
 int}val methods
Git-Commit-ID: 5555ded44698ed82ffa3d8742ec2994f695127bc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 23:04:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5555ded44698ed82ffa3d8742ec2994f695127bc
Gitweb:     http://git.kernel.org/tip/5555ded44698ed82ffa3d8742ec2994f695127bc
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 11 Sep 2012 19:24:23 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 11 Sep 2012 19:24:23 -0300

perf evsel: Introduce perf_evsel__{str,int}val methods

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
 2 files changed, 42 insertions(+), 0 deletions(-)

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
