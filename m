Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab2LSPII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 10:08:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755431Ab2LSPHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 10:07:53 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/3] perf tests: Add precise event attribute test
Date: Wed, 19 Dec 2012 16:07:22 +0100
Message-Id: <1355929642-28392-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1355929642-28392-1-git-send-email-jolsa@redhat.com>
References: <1355929642-28392-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "jolsa@redhat.com" <jolsa@redhat.com>

The test detects the precise attribute availability and try
to open perf event with each allowed precise attribute value.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile             |  1 +
 tools/perf/tests/builtin-test.c |  4 +++
 tools/perf/tests/precise.c      | 79 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h        |  1 +
 4 files changed, 85 insertions(+)
 create mode 100644 tools/perf/tests/precise.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index dbf1c35..03aae70 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -489,6 +489,7 @@ LIB_OBJS += $(OUTPUT)tests/evsel-tp-sched.o
 LIB_OBJS += $(OUTPUT)tests/pmu.o
 LIB_OBJS += $(OUTPUT)tests/hists_link.o
 LIB_OBJS += $(OUTPUT)tests/python-use.o
+LIB_OBJS += $(OUTPUT)tests/precise.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 6a5dee2..9903af2 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -77,6 +77,10 @@ static struct test {
 		.func = test__python_use,
 	},
 	{
+		.desc = "Test precise event attribute",
+		.func = test__precise,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/precise.c b/tools/perf/tests/precise.c
new file mode 100644
index 0000000..e3eedab
--- /dev/null
+++ b/tools/perf/tests/precise.c
@@ -0,0 +1,79 @@
+#include <linux/kernel.h>
+#include <linux/perf_event.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include "perf.h"
+#include "tests.h"
+#include "util.h"
+#include "sysfs.h"
+
+static int get_precise(void)
+{
+	struct stat st;
+	char path[PATH_MAX];
+	int precise = 0;
+
+	scnprintf(path, PATH_MAX, "%s/devices/cpu/precise",
+		  sysfs_find_mountpoint());
+
+	if (!lstat(path, &st)) {
+		FILE *file;
+
+		file = fopen(path, "r");
+		if (!file)
+			return -1;
+
+		if (1 != fscanf(file, "%d", &precise)) {
+			pr_debug("failed to read precise info\n");
+			precise = -1;
+		}
+
+		fclose(file);
+	}
+
+	return precise;
+}
+
+static int event_open_precise(int precise)
+{
+	struct perf_event_attr attr = {
+		.type		= PERF_TYPE_HARDWARE,
+		.config		= PERF_COUNT_HW_CPU_CYCLES,
+		.precise_ip	= precise,
+	};
+	int fd;
+
+	pr_debug("open cycles event with precise %d\n", precise);
+
+	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
+	if (fd < 0) {
+		pr_debug("failed to open event, syscall returned "
+			 "with %d (%s)\n", fd, strerror(errno));
+		return -1;
+	}
+
+	close(fd);
+	return 0;
+
+}
+
+int test__precise(void)
+{
+	int precise = get_precise();
+	int i;
+
+	if (!precise) {
+		pr_debug("no precise info or support\n");
+		return TEST_SKIP;
+	}
+
+	if (precise < 0)
+		return TEST_FAIL;
+
+	for (i = 1; i <= precise; i++)
+		if (event_open_precise(i))
+			return TEST_FAIL;
+
+	return TEST_OK;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 5de0be1..ff6db12 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -23,5 +23,6 @@ int test__dso_data(void);
 int test__parse_events(void);
 int test__hists_link(void);
 int test__python_use(void);
+int test__precise(void);
 
 #endif /* TESTS_H */
-- 
1.7.11.7

