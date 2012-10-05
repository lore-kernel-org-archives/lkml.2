Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab2JEIrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:47:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60935 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab2JEIrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:47:19 -0400
Date: Fri, 5 Oct 2012 01:47:00 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-ixb32cbcka9w1fk07xrksusf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf buildid-list: Don'
 t use globals where not needed to
Git-Commit-ID: 6ee4149736e39deb7ed6d11c5de3101b5b8c2669
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 01:47:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6ee4149736e39deb7ed6d11c5de3101b5b8c2669
Gitweb:     http://git.kernel.org/tip/6ee4149736e39deb7ed6d11c5de3101b5b8c2669
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 1 Oct 2012 15:20:58 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 2 Oct 2012 18:36:36 -0300

perf buildid-list: Don't use globals where not needed to

Some variables were global but used in just one function, so move it to
where it belongs.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ixb32cbcka9w1fk07xrksusf@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-buildid-list.c |   55 ++++++++++++++++---------------------
 1 files changed, 24 insertions(+), 31 deletions(-)

diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 1159fee..a0e94ff 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -16,27 +16,6 @@
 #include "util/session.h"
 #include "util/symbol.h"
 
-static const char *input_name;
-static bool force;
-static bool show_kernel;
-static bool with_hits;
-
-static const char * const buildid_list_usage[] = {
-	"perf buildid-list [<options>]",
-	NULL
-};
-
-static const struct option options[] = {
-	OPT_BOOLEAN('H', "with-hits", &with_hits, "Show only DSOs with hits"),
-	OPT_STRING('i', "input", &input_name, "file",
-		    "input file name"),
-	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
-	OPT_BOOLEAN('k', "kernel", &show_kernel, "Show current kernel build id"),
-	OPT_INCR('v', "verbose", &verbose,
-		    "be more verbose"),
-	OPT_END()
-};
-
 static int sysfs__fprintf_build_id(FILE *fp)
 {
 	u8 kallsyms_build_id[BUILD_ID_SIZE];
@@ -65,7 +44,8 @@ static int filename__fprintf_build_id(const char *name, FILE *fp)
 	return fprintf(fp, "%s\n", sbuild_id);
 }
 
-static int perf_session__list_build_ids(void)
+static int perf_session__list_build_ids(const char *input_name,
+					bool force, bool with_hits)
 {
 	struct perf_session *session;
 
@@ -95,18 +75,31 @@ out:
 	return 0;
 }
 
-static int __cmd_buildid_list(void)
-{
-	if (show_kernel)
-		return sysfs__fprintf_build_id(stdout);
-
-	return perf_session__list_build_ids();
-}
-
 int cmd_buildid_list(int argc, const char **argv,
 		     const char *prefix __maybe_unused)
 {
+	bool show_kernel = false;
+	bool with_hits = false;
+	bool force = false;
+	const char *input_name = NULL;
+	const struct option options[] = {
+	OPT_BOOLEAN('H', "with-hits", &with_hits, "Show only DSOs with hits"),
+	OPT_STRING('i', "input", &input_name, "file", "input file name"),
+	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
+	OPT_BOOLEAN('k', "kernel", &show_kernel, "Show current kernel build id"),
+	OPT_INCR('v', "verbose", &verbose, "be more verbose"),
+	OPT_END()
+	};
+	const char * const buildid_list_usage[] = {
+		"perf buildid-list [<options>]",
+		NULL
+	};
+
 	argc = parse_options(argc, argv, options, buildid_list_usage, 0);
 	setup_pager();
-	return __cmd_buildid_list();
+
+	if (show_kernel)
+		return sysfs__fprintf_build_id(stdout);
+
+	return perf_session__list_build_ids(input_name, force, with_hits);
 }
