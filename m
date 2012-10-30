Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934893Ab2J3WDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 18:03:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934865Ab2J3WD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 18:03:29 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 24/25] perf tests: Add attr tests under builtin test command
Date: Tue, 30 Oct 2012 23:02:05 +0100
Message-Id: <1351634526-1516-25-git-send-email-jolsa@redhat.com>
In-Reply-To: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The test attr suite is run only if it's run under perf source
directory, or tests are found in installed path.

Otherwise tests are omitted (notification is displayed)
and finished as successful.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/Makefile             |  9 +++++++++
 tools/perf/perf.h               |  1 +
 tools/perf/tests/attr.c         | 35 +++++++++++++++++++++++++++++++++++
 tools/perf/tests/builtin-test.c |  4 ++++
 4 files changed, 49 insertions(+)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1da87a3..ba380b9 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -898,6 +898,11 @@ $(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
 		'-DPREFIX="$(prefix_SQ)"' \
 		$<
 
+$(OUTPUT)tests/attr.o: $(OUTPUT)tests/attr.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
+		'-DBINDIR="$(bindir_SQ)"' \
+		$<
+
 $(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
@@ -1062,6 +1067,10 @@ install: all try-install-man
 	$(INSTALL) scripts/python/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d'
 	$(INSTALL) bash_completion '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d/perf'
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests'
+	$(INSTALL) tests/attr.py '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests'
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'
+	$(INSTALL) tests/attr/* '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'
 
 install-python_ext:
 	$(PYTHON_WORD) util/setup.py --quiet install --root='/$(DESTDIR_SQ)'
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 0047264..054182e 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -178,6 +178,7 @@ extern bool test_attr__enabled;
 void test_attr__init(void);
 void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
 		     int fd, int group_fd, unsigned long flags);
+int  test_attr__run(void);
 
 static inline int
 sys_perf_event_open(struct perf_event_attr *attr,
diff --git a/tools/perf/tests/attr.c b/tools/perf/tests/attr.c
index 2fe8cae..ef2505e 100644
--- a/tools/perf/tests/attr.c
+++ b/tools/perf/tests/attr.c
@@ -26,9 +26,12 @@
 #include <linux/kernel.h>
 #include "../perf.h"
 #include "util.h"
+#include "exec_cmd.h"
 
 #define ENV "PERF_TEST_ATTR"
 
+extern int verbose;
+
 bool test_attr__enabled;
 
 static char *dir;
@@ -134,3 +137,35 @@ void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
 	if (store_event(attr, pid, cpu, fd, group_fd, flags))
 		die("test attr FAILED");
 }
+
+static int run_dir(const char *d, const char *perf)
+{
+	char cmd[3*PATH_MAX];
+
+	snprintf(cmd, 3*PATH_MAX, "python %s/attr.py -d %s/attr/ -p %s %s",
+		 d, d, perf, verbose ? "-v" : "");
+
+	return system(cmd);
+}
+
+int test_attr__run(void)
+{
+	struct stat st;
+	char path_perf[PATH_MAX];
+	char path_dir[PATH_MAX];
+
+	/* First try developement tree tests. */
+	if (!lstat("./tests", &st))
+		return run_dir("./tests", "./perf");
+
+	/* Then installed path. */
+	snprintf(path_dir,  PATH_MAX, "%s/tests", perf_exec_path());
+	snprintf(path_perf, PATH_MAX, "%s/perf", BINDIR);
+
+	if (!lstat(path_dir, &st) &&
+	    !lstat(path_perf, &st))
+		return run_dir(path_dir, path_perf);
+
+	fprintf(stderr, " (ommitted)");
+	return 0;
+}
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index a04276e..8e2e7d6 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -1455,6 +1455,10 @@ static struct test {
 		.func = test__syscall_open_tp_fields,
 	},
 	{
+		.desc = "struct perf_event_attr setup",
+		.func = test_attr__run,
+	},
+	{
 		.func = NULL,
 	},
 };
-- 
1.7.11.7

