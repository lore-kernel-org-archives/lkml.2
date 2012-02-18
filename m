Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab2BRU0o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 15:26:44 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:34837 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab2BRU0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 15:26:40 -0500
Date: Sat, 18 Feb 2012 12:29:16 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net
Cc: anton@samba.org, sukadev@us.ibm.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] perf: Ignore tui when built with NO_NEWT
Message-ID: <20120218202916.GA17239@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021820-1976-0000-0000-00000AB22166
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Fri, 17 Feb 2012 17:20:05 -0800
Subject: [PATCH 1/1] perf: Ignore tui when built with NO_NEWT

If perf tools were built without tui support (eg if newt-devel package was
not installed), they __silently__ exit if tui was selected on command line
or in .perfconfig.

If the binary has no tui support, report error when --tui is specified. If
selected from .perfconfig, warn and fall back to stdio.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 tools/perf/builtin-annotate.c |   22 ++++++++++++++++++++++
 tools/perf/builtin-report.c   |   15 +++++++++++++++
 tools/perf/builtin-top.c      |   22 ++++++++++++++++++++++
 tools/perf/util/hist.h        |   10 ++++++++++
 4 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 806e0a2..5ee699b 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -287,6 +287,28 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 
 	argc = parse_options(argc, argv, options, annotate_usage, 0);
 
+	/*
+	 * If binary was built without the newt library, fall back to stdio.
+	 * But if --tui was explicitly requested, report error and exit.
+	 */
+	if (!tui_enabled()) {
+		if (annotate.use_tui) {
+			fprintf(stderr, "TUI not supported, use --stdio.\n");
+			return -1;
+		} else if (!annotate.use_stdio && use_browser > 0) {
+			/*
+			 * sleep(1) is hackish, but before we clear the screen,
+			 * they need know that we can't provide what their
+			 * .perfconfig asked for.
+			 */
+			fprintf(stderr, "TUI not supported, using stdio.\n");
+			sleep(1);
+		}
+
+		annotate.use_tui = 0;
+		annotate.use_stdio = 1;
+	}
+
 	if (annotate.use_stdio)
 		use_browser = 0;
 	else if (annotate.use_tui)
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 25d34d4..70175d6 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -522,6 +522,21 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 
 	argc = parse_options(argc, argv, options, report_usage, 0);
 
+	/*
+	 * If binary was built without the newt library, fall back to stdio.
+	 * But if --tui was explicitly requested, report error and exit.
+	 */
+	if (!tui_enabled()) {
+		if (report.use_tui) {
+			fprintf(stderr, "TUI not supported, use --stdio.\n");
+			return -1;
+		} else if (!report.use_stdio && use_browser > 0)
+			fprintf(stderr, "TUI not supported, using stdio.\n");
+
+		report.use_tui = 0;
+		report.use_stdio = 1;
+	}
+
 	if (report.use_stdio)
 		use_browser = 0;
 	else if (report.use_tui)
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index dd162aa..2aa2bdf 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1187,6 +1187,28 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 
 	setup_sorting(top_usage, options);
 
+	/*
+	 * If binary was built without the newt library, fall back to stdio.
+	 * But if --tui was explicitly requested, report error and exit.
+	 */
+	if (!tui_enabled()) {
+		if (top.use_tui) {
+			fprintf(stderr, "TUI not supported, use --stdio.\n");
+			return -1;
+		} else if (!top.use_stdio && use_browser > 0) {
+			/*
+			 * sleep(1) is hackish, but before we clear the screen,
+			 * they need know that we can't provide what their
+			 * .perfconfig asked for.
+			 */
+			fprintf(stderr, "TUI not supported, using stdio.\n");
+			sleep(1);
+		}
+
+		top.use_tui = 0;
+		top.use_stdio = 1;
+	}
+
 	if (top.use_stdio)
 		use_browser = 0;
 	else if (top.use_tui)
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index f55f0a8..2a3a3db 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -103,6 +103,11 @@ struct perf_evlist;
 
 #ifdef NO_NEWT_SUPPORT
 static inline
+int tui_enabled(void)
+{
+	return 0;
+}
+static inline
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist __used,
 				  const char *help __used,
 				  void(*timer)(void *arg) __used,
@@ -130,6 +135,11 @@ int hist_entry__tui_annotate(struct hist_entry *he, int evidx,
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
 				  void(*timer)(void *arg), void *arg,
 				  int refresh);
+static inline
+int tui_enabled(void)
+{
+	return 1;
+}
 #endif
 
 unsigned int hists__sort_list_width(struct hists *self);
-- 
1.7.0.4

