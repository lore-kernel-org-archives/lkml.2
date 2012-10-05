Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab2JEImn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:42:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60841 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2JEIml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:42:41 -0400
Date: Fri, 5 Oct 2012 01:42:17 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-plurd9htha6ea2mo9e9sd1p5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf help: Don't use globals where not needed to
Git-Commit-ID: 2bae1d1b1aa3b763b99431101a04dfe24ec5ba7f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 01:42:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2bae1d1b1aa3b763b99431101a04dfe24ec5ba7f
Gitweb:     http://git.kernel.org/tip/2bae1d1b1aa3b763b99431101a04dfe24ec5ba7f
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 1 Oct 2012 15:20:58 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 2 Oct 2012 18:36:31 -0300

perf help: Don't use globals where not needed to

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
Link: http://lkml.kernel.org/n/tip-plurd9htha6ea2mo9e9sd1p5@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-help.c |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 25c8b94..411ee56 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -30,23 +30,6 @@ enum help_format {
 	HELP_FORMAT_WEB,
 };
 
-static bool show_all = false;
-static enum help_format help_format = HELP_FORMAT_NONE;
-static struct option builtin_help_options[] = {
-	OPT_BOOLEAN('a', "all", &show_all, "print all available commands"),
-	OPT_SET_UINT('m', "man", &help_format, "show man page", HELP_FORMAT_MAN),
-	OPT_SET_UINT('w', "web", &help_format, "show manual in web browser",
-			HELP_FORMAT_WEB),
-	OPT_SET_UINT('i', "info", &help_format, "show info page",
-			HELP_FORMAT_INFO),
-	OPT_END(),
-};
-
-static const char * const builtin_help_usage[] = {
-	"perf help [--all] [--man|--web|--info] [command]",
-	NULL
-};
-
 static enum help_format parse_help_format(const char *format)
 {
 	if (!strcmp(format, "man"))
@@ -258,11 +241,13 @@ static int add_man_viewer_info(const char *var, const char *value)
 
 static int perf_help_config(const char *var, const char *value, void *cb)
 {
+	enum help_format *help_formatp = cb;
+
 	if (!strcmp(var, "help.format")) {
 		if (!value)
 			return config_error_nonbool(var);
-		help_format = parse_help_format(value);
-		if (help_format == HELP_FORMAT_NONE)
+		*help_formatp = parse_help_format(value);
+		if (*help_formatp == HELP_FORMAT_NONE)
 			return -1;
 		return 0;
 	}
@@ -428,12 +413,27 @@ static int show_html_page(const char *perf_cmd)
 
 int cmd_help(int argc, const char **argv, const char *prefix __maybe_unused)
 {
+	bool show_all = false;
+	enum help_format help_format = HELP_FORMAT_NONE;
+	struct option builtin_help_options[] = {
+	OPT_BOOLEAN('a', "all", &show_all, "print all available commands"),
+	OPT_SET_UINT('m', "man", &help_format, "show man page", HELP_FORMAT_MAN),
+	OPT_SET_UINT('w', "web", &help_format, "show manual in web browser",
+			HELP_FORMAT_WEB),
+	OPT_SET_UINT('i', "info", &help_format, "show info page",
+			HELP_FORMAT_INFO),
+	OPT_END(),
+	};
+	const char * const builtin_help_usage[] = {
+		"perf help [--all] [--man|--web|--info] [command]",
+		NULL
+	};
 	const char *alias;
 	int rc = 0;
 
 	load_command_list("perf-", &main_cmds, &other_cmds);
 
-	perf_config(perf_help_config, NULL);
+	perf_config(perf_help_config, &help_format);
 
 	argc = parse_options(argc, argv, builtin_help_options,
 			builtin_help_usage, 0);
