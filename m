Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759903Ab2IEXJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 19:09:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:34306 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759803Ab2IEXJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 19:09:07 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/17] perf help: Remove use of die and handle errors
Date: Wed,  5 Sep 2012 20:08:46 -0300
Message-Id: <1346886537-11621-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1346886537-11621-1-git-send-email-acme@infradead.org>
References: <1346886537-11621-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Allows perf to clean up properly on exit.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1346005487-62961-6-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-help.c |   48 +++++++++++++++++++++++++++++++-------------
 1 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 6d5a8a7..f9daae5 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -24,13 +24,14 @@ static struct man_viewer_info_list {
 } *man_viewer_info_list;
 
 enum help_format {
+	HELP_FORMAT_NONE,
 	HELP_FORMAT_MAN,
 	HELP_FORMAT_INFO,
 	HELP_FORMAT_WEB,
 };
 
 static bool show_all = false;
-static enum help_format help_format = HELP_FORMAT_MAN;
+static enum help_format help_format = HELP_FORMAT_NONE;
 static struct option builtin_help_options[] = {
 	OPT_BOOLEAN('a', "all", &show_all, "print all available commands"),
 	OPT_SET_UINT('m', "man", &help_format, "show man page", HELP_FORMAT_MAN),
@@ -54,7 +55,9 @@ static enum help_format parse_help_format(const char *format)
 		return HELP_FORMAT_INFO;
 	if (!strcmp(format, "web") || !strcmp(format, "html"))
 		return HELP_FORMAT_WEB;
-	die("unrecognized help format '%s'", format);
+
+	pr_err("unrecognized help format '%s'", format);
+	return HELP_FORMAT_NONE;
 }
 
 static const char *get_man_viewer_info(const char *name)
@@ -259,6 +262,8 @@ static int perf_help_config(const char *var, const char *value, void *cb)
 		if (!value)
 			return config_error_nonbool(var);
 		help_format = parse_help_format(value);
+		if (help_format == HELP_FORMAT_NONE)
+			return -1;
 		return 0;
 	}
 	if (!strcmp(var, "man.viewer")) {
@@ -352,7 +357,7 @@ static void exec_viewer(const char *name, const char *page)
 		warning("'%s': unknown man viewer.", name);
 }
 
-static void show_man_page(const char *perf_cmd)
+static int show_man_page(const char *perf_cmd)
 {
 	struct man_viewer_list *viewer;
 	const char *page = cmd_to_page(perf_cmd);
@@ -365,28 +370,35 @@ static void show_man_page(const char *perf_cmd)
 	if (fallback)
 		exec_viewer(fallback, page);
 	exec_viewer("man", page);
-	die("no man viewer handled the request");
+
+	pr_err("no man viewer handled the request");
+	return -1;
 }
 
-static void show_info_page(const char *perf_cmd)
+static int show_info_page(const char *perf_cmd)
 {
 	const char *page = cmd_to_page(perf_cmd);
 	setenv("INFOPATH", system_path(PERF_INFO_PATH), 1);
 	execlp("info", "info", "perfman", page, NULL);
+	return -1;
 }
 
-static void get_html_page_path(struct strbuf *page_path, const char *page)
+static int get_html_page_path(struct strbuf *page_path, const char *page)
 {
 	struct stat st;
 	const char *html_path = system_path(PERF_HTML_PATH);
 
 	/* Check that we have a perf documentation directory. */
 	if (stat(mkpath("%s/perf.html", html_path), &st)
-	    || !S_ISREG(st.st_mode))
-		die("'%s': not a documentation directory.", html_path);
+	    || !S_ISREG(st.st_mode)) {
+		pr_err("'%s': not a documentation directory.", html_path);
+		return -1;
+	}
 
 	strbuf_init(page_path, 0);
 	strbuf_addf(page_path, "%s/%s.html", html_path, page);
+
+	return 0;
 }
 
 /*
@@ -401,19 +413,23 @@ static void open_html(const char *path)
 }
 #endif
 
-static void show_html_page(const char *perf_cmd)
+static int show_html_page(const char *perf_cmd)
 {
 	const char *page = cmd_to_page(perf_cmd);
 	struct strbuf page_path; /* it leaks but we exec bellow */
 
-	get_html_page_path(&page_path, page);
+	if (get_html_page_path(&page_path, page) != 0)
+		return -1;
 
 	open_html(page_path.buf);
+
+	return 0;
 }
 
 int cmd_help(int argc, const char **argv, const char *prefix __used)
 {
 	const char *alias;
+	int rc = 0;
 
 	load_command_list("perf-", &main_cmds, &other_cmds);
 
@@ -444,16 +460,20 @@ int cmd_help(int argc, const char **argv, const char *prefix __used)
 
 	switch (help_format) {
 	case HELP_FORMAT_MAN:
-		show_man_page(argv[0]);
+		rc = show_man_page(argv[0]);
 		break;
 	case HELP_FORMAT_INFO:
-		show_info_page(argv[0]);
+		rc = show_info_page(argv[0]);
 		break;
 	case HELP_FORMAT_WEB:
-		show_html_page(argv[0]);
+		rc = show_html_page(argv[0]);
+		break;
+	case HELP_FORMAT_NONE:
+		/* fall-through */
 	default:
+		rc = -1;
 		break;
 	}
 
-	return 0;
+	return rc;
 }
-- 
1.7.1

