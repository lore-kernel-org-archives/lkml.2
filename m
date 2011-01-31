Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab1AaV3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:29:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44480 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab1AaV3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:29:32 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 4/5] perf tools: Don't fallback to setup_pager unconditionally
Date: Mon, 31 Jan 2011 19:29:21 -0200
Message-Id: <1296509362-28054-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1296509362-28054-1-git-send-email-acme@infradead.org>
References: <1296509362-28054-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Because in tools like 'top' we don't want the pager.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |    2 +-
 tools/perf/builtin-report.c   |    2 +-
 tools/perf/util/cache.h       |    7 ++++---
 tools/perf/util/ui/setup.c    |    5 +++--
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 7006786..cd9dec4 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -452,7 +452,7 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 	else if (use_tui)
 		use_browser = 1;
 
-	setup_browser();
+	setup_browser(true);
 
 	symbol_conf.priv_size = sizeof(struct sym_priv);
 	symbol_conf.try_vmlinux_path = true;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index a6a4e54..080937c 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -499,7 +499,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 		use_browser = 1;
 
 	if (strcmp(input_name, "-") != 0)
-		setup_browser();
+		setup_browser(true);
 	else
 		use_browser = 0;
 	/*
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index a772979..fc5e5a0 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -34,13 +34,14 @@ extern int pager_use_color;
 extern int use_browser;
 
 #ifdef NO_NEWT_SUPPORT
-static inline void setup_browser(void)
+static inline void setup_browser(bool fallback_to_pager)
 {
-	setup_pager();
+	if (fallback_to_pager)
+		setup_pager();
 }
 static inline void exit_browser(bool wait_for_ok __used) {}
 #else
-void setup_browser(void);
+void setup_browser(bool fallback_to_pager);
 void exit_browser(bool wait_for_ok);
 #endif
 
diff --git a/tools/perf/util/ui/setup.c b/tools/perf/util/ui/setup.c
index 6620850..fbf1a14 100644
--- a/tools/perf/util/ui/setup.c
+++ b/tools/perf/util/ui/setup.c
@@ -14,11 +14,12 @@ static void newt_suspend(void *d __used)
 	newtResume();
 }
 
-void setup_browser(void)
+void setup_browser(bool fallback_to_pager)
 {
 	if (!isatty(1) || !use_browser || dump_trace) {
 		use_browser = 0;
-		setup_pager();
+		if (fallback_to_pager)
+			setup_pager();
 		return;
 	}
 
-- 
1.6.2.5

