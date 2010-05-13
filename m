Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab0EMGE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 02:04:57 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:53920 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab0EMGEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 02:04:51 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ian Munsie <imunsie@au1.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 7/7] perf trace test: Test cases for kernel->host format string conversion
Date: Thu, 13 May 2010 16:03:52 +1000
Message-Id: <1273730632-21008-8-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273730632-21008-1-git-send-email-imunsie@au1.ibm.com>
References: <1273730632-21008-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patch adds some test cases to be run with perf test to verify the
correct operation of the convert_kernel_host_format function.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 tools/perf/builtin-test.c           |   36 ++++++++++++++++++++++++++++++
 tools/perf/util/test-cases.h        |    8 ++++++
 tools/perf/util/trace-event-parse.c |   41 +++++++++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/util/test-cases.h

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 0339612..d1c6179 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -11,6 +11,19 @@
 #include "util/session.h"
 #include "util/symbol.h"
 #include "util/thread.h"
+#include "util/test-cases.h"
+
+#define INIT_TEST_CASES \
+	int test_case_err = 0; \
+	int test_case_num = 0;
+
+#define TEST_CASE(fn) \
+	pr_debug("--- test case #%d start ---\n", ++test_case_num); \
+	test_case_err += fn; \
+	pr_debug("--- test case #%d end ---\n", test_case_num); \
+
+#define TEST_CASES_ERR test_case_err
+
 
 static long page_size;
 
@@ -219,6 +232,25 @@ out:
 	return err;
 }
 
+static int test__convert_kernel_host_format(void)
+{
+	INIT_TEST_CASES
+
+	TEST_CASE(test_case__convert_kernel_host_format(4, "0x44444444", 1, "%p", 0x44444444UL))
+	TEST_CASE(test_case__convert_kernel_host_format(8, "0x88888888", 1, "%p", 0x88888888UL))
+	TEST_CASE(test_case__convert_kernel_host_format(8, "0x12345678abcdef00", 1, "%p", 0x12345678abcdef00ULL))
+
+	TEST_CASE(test_case__convert_kernel_host_format(4, "9223372036854775807", 2, "%lld", 9223372036854775807LL))
+	TEST_CASE(test_case__convert_kernel_host_format(8, "9223372036854775807", 2, "%lld", 9223372036854775807LL))
+
+	TEST_CASE(test_case__convert_kernel_host_format(4, "2147483647", 1, "%ld", 2147483647))
+	TEST_CASE(test_case__convert_kernel_host_format(8, "2147483647", 1, "%ld", 2147483647))
+	TEST_CASE(test_case__convert_kernel_host_format(8, "9223372036854775807", 1, "%ld", 9223372036854775807LL))
+
+	return TEST_CASES_ERR;
+}
+
+
 static struct test {
 	const char *desc;
 	int (*func)(void);
@@ -228,6 +260,10 @@ static struct test {
 		.func = test__vmlinux_matches_kallsyms,
 	},
 	{
+		.desc = "trace handles printing values from kernels with differing long size",
+		.func = test__convert_kernel_host_format,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/util/test-cases.h b/tools/perf/util/test-cases.h
new file mode 100644
index 0000000..be1da92
--- /dev/null
+++ b/tools/perf/util/test-cases.h
@@ -0,0 +1,8 @@
+#ifndef PERF_TEST_CASES_H_
+#define PERF_TEST_CASES_H_
+
+int test_case__convert_kernel_host_format(const int kern_long_size,
+		const char *expected_out, const int ls,
+		const char *kern_format, const unsigned long long val);
+
+#endif
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index f74abdb..ac3d0b7 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -33,6 +33,7 @@
 #include "../perf.h"
 #include "util.h"
 #include "trace-event.h"
+#include "test-cases.h"
 
 int header_page_ts_offset;
 int header_page_ts_size;
@@ -2536,6 +2537,46 @@ static void convert_kernel_host_format(char *kernel_format, int *ls)
 	memcpy(kernel_format, user_format, uptr - user_format);
 }
 
+int test_case__convert_kernel_host_format(const int kern_long_size,
+		const char *expected_out, const int ls,
+		const char *kern_format, const unsigned long long val)
+{
+	char test_fmt[32];
+	char test_out[32];
+	int test_ls = ls;
+	int err = 0;
+
+	assert(strlen(expected_out) < 32);
+	assert(strlen(kern_format) < 32);
+
+	long_size = kern_long_size;
+	memcpy(test_fmt, kern_format, 32);
+
+	convert_kernel_host_format(test_fmt, &test_ls);
+	switch (test_ls) {
+	case 0:
+		snprintf(test_out, 32, test_fmt, (int)val);
+		break;
+	case 1:
+		snprintf(test_out, 32, test_fmt, (long)val);
+		break;
+	case 2:
+		snprintf(test_out, 32, test_fmt, (long long)val);
+		break;
+	default:
+		err = -1;
+		pr_info("Invalid ls (%d)\n", test_ls);
+	}
+
+	if (strncmp(test_out, expected_out, 32)) {
+		err = -1;
+		pr_info("FAIL: Expected string: %s\n"
+			"      Returned string: %s\n",
+			expected_out, test_out);
+	}
+	return err;
+}
+
 static void pretty_print(void *data, int size, struct event *event)
 {
 	struct print_fmt *print_fmt = &event->print_fmt;
-- 
1.7.1

