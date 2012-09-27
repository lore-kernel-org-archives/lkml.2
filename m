Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab2I0FrG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:47:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54306 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab2I0FrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:47:03 -0400
Date: Wed, 26 Sep 2012 22:46:44 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-g3rm9b3wtim4djx3z8dkftrj@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test:
  Add test for the sched tracepoint format fields
Git-Commit-ID: 6a6cd11d4e5793ce1a2fb88dc7a09dbf43f9c618
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 22:46:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6a6cd11d4e5793ce1a2fb88dc7a09dbf43f9c618
Gitweb:     http://git.kernel.org/tip/6a6cd11d4e5793ce1a2fb88dc7a09dbf43f9c618
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 18 Sep 2012 11:56:28 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Sep 2012 12:29:19 -0300

perf test: Add test for the sched tracepoint format fields

So that we make sure the routines that do event format parsing are
working on at least two well know scheduler tracepoints.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-g3rm9b3wtim4djx3z8dkftrj@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c |   86 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 86 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 4aed155..32caf13 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -14,6 +14,7 @@
 #include "util/symbol.h"
 #include "util/thread_map.h"
 #include "util/pmu.h"
+#include "event-parse.h"
 #include "../../include/linux/hw_breakpoint.h"
 
 #include <sys/mman.h>
@@ -1207,6 +1208,87 @@ static int perf_evsel__roundtrip_name_test(void)
 	return ret;
 }
 
+static int perf_evsel__test_field(struct perf_evsel *evsel, const char *name,
+				  int size, bool should_be_signed)
+{
+	struct format_field *field = perf_evsel__field(evsel, name);
+	int is_signed;
+	int ret = 0;
+
+	if (field == NULL) {
+		pr_debug("%s: \"%s\" field not found!\n", evsel->name, name);
+		return -1;
+	}
+
+	is_signed = !!(field->flags | FIELD_IS_SIGNED);
+	if (should_be_signed && !is_signed) {
+		pr_debug("%s: \"%s\" signedness(%d) is wrong, should be %d\n",
+			 evsel->name, name, is_signed, should_be_signed);
+		ret = -1;
+	}
+
+	if (field->size != size) {
+		pr_debug("%s: \"%s\" size (%d) should be %d!\n",
+			 evsel->name, name, field->size, size);
+		ret = -1;
+	}
+
+	return 0;
+}
+
+static int perf_evsel__tp_sched_test(void)
+{
+	struct perf_evsel *evsel = perf_evsel__newtp("sched", "sched_switch", 0);
+	int ret = 0;
+
+	if (evsel == NULL) {
+		pr_debug("perf_evsel__new\n");
+		return -1;
+	}
+
+	if (perf_evsel__test_field(evsel, "prev_comm", 16, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "prev_pid", 4, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "prev_prio", 4, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "prev_state", 8, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "next_comm", 16, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "next_pid", 4, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "next_prio", 4, true))
+		ret = -1;
+
+	perf_evsel__delete(evsel);
+
+	evsel = perf_evsel__newtp("sched", "sched_wakeup", 0);
+
+	if (perf_evsel__test_field(evsel, "comm", 16, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "pid", 4, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "prio", 4, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "success", 4, true))
+		ret = -1;
+
+	if (perf_evsel__test_field(evsel, "target_cpu", 4, true))
+		ret = -1;
+
+	return 0;
+}
+
 static struct test {
 	const char *desc;
 	int (*func)(void);
@@ -1254,6 +1336,10 @@ static struct test {
 		.func = perf_evsel__roundtrip_name_test,
 	},
 	{
+		.desc = "Check parsing of sched tracepoints fields",
+		.func = perf_evsel__tp_sched_test,
+	},
+	{
 		.func = NULL,
 	},
 };
