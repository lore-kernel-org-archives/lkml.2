Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345Ab2LHOqZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 09:46:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49386 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051Ab2LHOqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 09:46:24 -0500
Date: Sat, 8 Dec 2012 06:46:00 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-5e24a0904ed4029f6778a214b6fe41b9265fd620@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1352508412-16914-9-git-send-email-jolsa@redhat.com>
References: <1352508412-16914-9-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests:
  Move perf_evsel__tp_sched_test into separate object
Git-Commit-ID: 5e24a0904ed4029f6778a214b6fe41b9265fd620
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 08 Dec 2012 06:46:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5e24a0904ed4029f6778a214b6fe41b9265fd620
Gitweb:     http://git.kernel.org/tip/5e24a0904ed4029f6778a214b6fe41b9265fd620
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sat, 10 Nov 2012 01:46:48 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Nov 2012 16:50:02 -0300

perf tests: Move perf_evsel__tp_sched_test into separate object

Separating perf_evsel__tp_sched_test test from the builtin-test into
evsel-tp-sched object.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1352508412-16914-9-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile               |  1 +
 tools/perf/tests/builtin-test.c   | 83 +-------------------------------------
 tools/perf/tests/evsel-tp-sched.c | 84 +++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h          |  1 +
 4 files changed, 87 insertions(+), 82 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ad6fcb5..e510b53 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -438,6 +438,7 @@ LIB_OBJS += $(OUTPUT)tests/mmap-basic.o
 LIB_OBJS += $(OUTPUT)tests/perf-record.o
 LIB_OBJS += $(OUTPUT)tests/rdpmc.o
 LIB_OBJS += $(OUTPUT)tests/evsel-roundtrip-name.o
+LIB_OBJS += $(OUTPUT)tests/evsel-tp-sched.o
 LIB_OBJS += $(OUTPUT)tests/util.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 93f5e91..c66caa7 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -35,87 +35,6 @@ static int test__perf_pmu(void)
 	return perf_pmu__test();
 }
 
-static int perf_evsel__test_field(struct perf_evsel *evsel, const char *name,
-				  int size, bool should_be_signed)
-{
-	struct format_field *field = perf_evsel__field(evsel, name);
-	int is_signed;
-	int ret = 0;
-
-	if (field == NULL) {
-		pr_debug("%s: \"%s\" field not found!\n", evsel->name, name);
-		return -1;
-	}
-
-	is_signed = !!(field->flags | FIELD_IS_SIGNED);
-	if (should_be_signed && !is_signed) {
-		pr_debug("%s: \"%s\" signedness(%d) is wrong, should be %d\n",
-			 evsel->name, name, is_signed, should_be_signed);
-		ret = -1;
-	}
-
-	if (field->size != size) {
-		pr_debug("%s: \"%s\" size (%d) should be %d!\n",
-			 evsel->name, name, field->size, size);
-		ret = -1;
-	}
-
-	return ret;
-}
-
-static int perf_evsel__tp_sched_test(void)
-{
-	struct perf_evsel *evsel = perf_evsel__newtp("sched", "sched_switch", 0);
-	int ret = 0;
-
-	if (evsel == NULL) {
-		pr_debug("perf_evsel__new\n");
-		return -1;
-	}
-
-	if (perf_evsel__test_field(evsel, "prev_comm", 16, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "prev_pid", 4, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "prev_prio", 4, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "prev_state", 8, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "next_comm", 16, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "next_pid", 4, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "next_prio", 4, true))
-		ret = -1;
-
-	perf_evsel__delete(evsel);
-
-	evsel = perf_evsel__newtp("sched", "sched_wakeup", 0);
-
-	if (perf_evsel__test_field(evsel, "comm", 16, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "pid", 4, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "prio", 4, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "success", 4, true))
-		ret = -1;
-
-	if (perf_evsel__test_field(evsel, "target_cpu", 4, true))
-		ret = -1;
-
-	return ret;
-}
-
 static int test__syscall_open_tp_fields(void)
 {
 	struct perf_record_opts opts = {
@@ -276,7 +195,7 @@ static struct test {
 	},
 	{
 		.desc = "Check parsing of sched tracepoints fields",
-		.func = perf_evsel__tp_sched_test,
+		.func = test__perf_evsel__tp_sched_test,
 	},
 	{
 		.desc = "Generate and check syscalls:sys_enter_open event fields",
diff --git a/tools/perf/tests/evsel-tp-sched.c b/tools/perf/tests/evsel-tp-sched.c
new file mode 100644
index 0000000..a5d2fcc
--- /dev/null
+++ b/tools/perf/tests/evsel-tp-sched.c
@@ -0,0 +1,84 @@
+#include "evsel.h"
+#include "tests.h"
+#include "event-parse.h"
+
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
+	return ret;
+}
+
+int test__perf_evsel__tp_sched_test(void)
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
+	return ret;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 5897dd1..1ef265d 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -9,6 +9,7 @@ int test__basic_mmap(void);
 int test__PERF_RECORD(void);
 int test__rdpmc(void);
 int test__perf_evsel__roundtrip_name_test(void);
+int test__perf_evsel__tp_sched_test(void);
 
 /* Util */
 int trace_event__id(const char *evname);
