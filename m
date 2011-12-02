Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074Ab1LBQTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 11:19:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40209 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757038Ab1LBQTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 11:19:48 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/4] perf test: Allow running just a subset of the available tests
Date: Fri,  2 Dec 2011 14:19:27 -0200
Message-Id: <1322842769-7232-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1322842769-7232-1-git-send-email-acme@infradead.org>
References: <1322842769-7232-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To obtain a list of available tests:

[root@emilia linux]# perf test list
 1: vmlinux symtab matches kallsyms
 2: detect open syscall event
 3: detect open syscall event on all cpus
 4: read samples using the mmap interface
 5: parse events tests
[root@emilia linux]#

To list just a subset:

[root@emilia linux]# perf test list syscall
 2: detect open syscall event
 3: detect open syscall event on all cpus
[root@emilia linux]#

To run a subset:

[root@emilia linux]# perf test detect
 2: detect open syscall event: Ok
 3: detect open syscall event on all cpus: Ok
[root@emilia linux]#

Specific tests can be chosen by number:

[root@emilia linux]# perf test 1 3 parse
 1: vmlinux symtab matches kallsyms: Ok
 3: detect open syscall event on all cpus: Ok
 5: parse events tests: Ok
[root@emilia linux]#

Now to write more tests!

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-nqec2145qfxdgimux28aw7v8@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-test.txt |    8 +++-
 tools/perf/builtin-test.c              |   81 +++++++++++++++++++++++--------
 2 files changed, 67 insertions(+), 22 deletions(-)

diff --git a/tools/perf/Documentation/perf-test.txt b/tools/perf/Documentation/perf-test.txt
index 2c3b462..b24ac40 100644
--- a/tools/perf/Documentation/perf-test.txt
+++ b/tools/perf/Documentation/perf-test.txt
@@ -8,13 +8,19 @@ perf-test - Runs sanity tests.
 SYNOPSIS
 --------
 [verse]
-'perf test <options>'
+'perf test [<options>] [{list <test-name-fragment>|[<test-name-fragments>|<test-numbers>]}]'
 
 DESCRIPTION
 -----------
 This command does assorted sanity tests, initially through linked routines but
 also will look for a directory with more tests in the form of scripts.
 
+To get a list of available tests use 'perf test list', specifying a test name
+fragment will show all tests that have it.
+
+To run just specific tests, inform test name fragments or the numbers obtained
+from 'perf test list'.
+
 OPTIONS
 -------
 -v::
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 77d68bf..3ab2722 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -15,8 +15,6 @@
 #include "util/thread_map.h"
 #include "../../include/linux/hw_breakpoint.h"
 
-static long page_size;
-
 static int vmlinux_matches_kallsyms_filter(struct map *map __used, struct symbol *sym)
 {
 	bool *visited = symbol__priv(sym);
@@ -32,6 +30,7 @@ static int test__vmlinux_matches_kallsyms(void)
 	struct map *kallsyms_map, *vmlinux_map;
 	struct machine kallsyms, vmlinux;
 	enum map_type type = MAP__FUNCTION;
+	long page_size = sysconf(_SC_PAGE_SIZE);
 	struct ref_reloc_sym ref_reloc_sym = { .name = "_stext", };
 
 	/*
@@ -871,41 +870,81 @@ static struct test {
 	},
 };
 
-static int __cmd_test(void)
+static bool perf_test__matches(int curr, int argc, const char *argv[])
 {
-	int i = 0;
+	int i;
+
+	if (argc == 0)
+		return true;
+
+	for (i = 0; i < argc; ++i) {
+		char *end;
+		long nr = strtoul(argv[i], &end, 10);
+
+		if (*end == '\0') {
+			if (nr == curr + 1)
+				return true;
+			continue;
+		}
 
-	page_size = sysconf(_SC_PAGE_SIZE);
+		if (strstr(tests[curr].desc, argv[i]))
+			return true;
+	}
+
+	return false;
+}
+
+static int __cmd_test(int argc, const char *argv[])
+{
+	int i = 0;
 
 	while (tests[i].func) {
-		int err;
-		pr_info("%2d: %s:", i + 1, tests[i].desc);
+		int curr = i++, err;
+
+		if (!perf_test__matches(curr, argc, argv))
+			continue;
+
+		pr_info("%2d: %s:", i, tests[curr].desc);
 		pr_debug("\n--- start ---\n");
-		err = tests[i].func();
-		pr_debug("---- end ----\n%s:", tests[i].desc);
+		err = tests[curr].func();
+		pr_debug("---- end ----\n%s:", tests[curr].desc);
 		pr_info(" %s\n", err ? "FAILED!\n" : "Ok");
-		++i;
 	}
 
 	return 0;
 }
 
-static const char * const test_usage[] = {
-	"perf test [<options>]",
-	NULL,
-};
+static int perf_test__list(int argc, const char **argv)
+{
+	int i = 0;
+
+	while (tests[i].func) {
+		int curr = i++;
+
+		if (argc > 1 && !strstr(tests[curr].desc, argv[1]))
+			continue;
+
+		pr_info("%2d: %s\n", i, tests[curr].desc);
+	}
+
+	return 0;
+}
 
-static const struct option test_options[] = {
+int cmd_test(int argc, const char **argv, const char *prefix __used)
+{
+	const char * const test_usage[] = {
+	"perf test [<options>] [{list <test-name-fragment>|[<test-name-fragments>|<test-numbers>]}]",
+	NULL,
+	};
+	const struct option test_options[] = {
 	OPT_INTEGER('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
 	OPT_END()
-};
+	};
 
-int cmd_test(int argc, const char **argv, const char *prefix __used)
-{
 	argc = parse_options(argc, argv, test_options, test_usage, 0);
-	if (argc)
-		usage_with_options(test_usage, test_options);
+	if (argc >= 1 && !strcmp(argv[0], "list"))
+		return perf_test__list(argc, argv);
 
 	symbol_conf.priv_size = sizeof(int);
 	symbol_conf.sort_by_name = true;
@@ -916,5 +955,5 @@ int cmd_test(int argc, const char **argv, const char *prefix __used)
 
 	setup_pager();
 
-	return __cmd_test();
+	return __cmd_test(argc, argv);
 }
-- 
1.7.8.rc0.35.gee6df

