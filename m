Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab1BAJUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 04:20:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:45474 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868Ab1BAJUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 04:20:32 -0500
Date: Tue, 1 Feb 2011 09:20:01 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Don't fallback to setup_pager unconditionally
Message-ID: <tip-229ade9ba36341f7369ecb4f134bcec9133520bf@git.kernel.org>
Git-Commit-ID: 229ade9ba36341f7369ecb4f134bcec9133520bf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 01 Feb 2011 09:20:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  229ade9ba36341f7369ecb4f134bcec9133520bf
Gitweb:     http://git.kernel.org/tip/229ade9ba36341f7369ecb4f134bcec9133520bf
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 31 Jan 2011 18:08:39 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 31 Jan 2011 18:08:39 -0200

perf tools: Don't fallback to setup_pager unconditionally

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
 
