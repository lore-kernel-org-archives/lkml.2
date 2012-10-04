Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab2JDSJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:09:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:39690 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab2JDSJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:09:00 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 15/42] perf help: Don't use globals where not needed to
Date: Thu,  4 Oct 2012 15:08:15 -0300
Message-Id: <1349374122-27806-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349374122-27806-1-git-send-email-acme@infradead.org>
References: <1349374122-27806-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
-- 
1.7.1

