Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab1LENIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:08:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57207 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374Ab1LENIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:08:51 -0500
Date: Mon, 5 Dec 2011 05:08:27 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-nqec2145qfxdgimux28aw7v8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test: Allow running just a subset of the available tests
Git-Commit-ID: e60770a01bd889707faaaeb794f1e278e7160458
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 05:08:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e60770a01bd889707faaaeb794f1e278e7160458
Gitweb:     http://git.kernel.org/tip/e60770a01bd889707faaaeb794f1e278e7160458
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 29 Nov 2011 12:52:07 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 29 Nov 2011 14:04:35 -0200

perf test: Allow running just a subset of the available tests

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
