Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab2KROaY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 09:30:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36544 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab2KROaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 09:30:14 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 16/32] perf tools: Add gtk.<command> config option for launching GTK browser
Date: Sun, 18 Nov 2012 11:29:41 -0300
Message-Id: <1353248997-30763-17-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1353248997-30763-1-git-send-email-acme@infradead.org>
References: <1353248997-30763-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Add config option for launching GTK browser for the specified command by
default.  Currently only 'report' command is supported.

Adding following line to the perfconfig file will have a same effect of
specifying --gtk option on command line (unless other related options
are not given).

$ cat ~/.perfconfig
[gtk]
report = true

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1352688617-25570-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index a0ae290..0f661fb 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -85,21 +85,26 @@ int check_pager_config(const char *cmd)
 	return c.val;
 }
 
-static int tui_command_config(const char *var, const char *value, void *data)
+static int browser_command_config(const char *var, const char *value, void *data)
 {
 	struct pager_config *c = data;
 	if (!prefixcmp(var, "tui.") && !strcmp(var + 4, c->cmd))
 		c->val = perf_config_bool(var, value);
+	if (!prefixcmp(var, "gtk.") && !strcmp(var + 4, c->cmd))
+		c->val = perf_config_bool(var, value) ? 2 : 0;
 	return 0;
 }
 
-/* returns 0 for "no tui", 1 for "use tui", and -1 for "not specified" */
-static int check_tui_config(const char *cmd)
+/*
+ * returns 0 for "no tui", 1 for "use tui", 2 for "use gtk",
+ * and -1 for "not specified"
+ */
+static int check_browser_config(const char *cmd)
 {
 	struct pager_config c;
 	c.cmd = cmd;
 	c.val = -1;
-	perf_config(tui_command_config, &c);
+	perf_config(browser_command_config, &c);
 	return c.val;
 }
 
@@ -302,7 +307,7 @@ static int run_builtin(struct cmd_struct *p, int argc, const char **argv)
 		prefix = NULL; /* setup_perf_directory(); */
 
 	if (use_browser == -1)
-		use_browser = check_tui_config(p->cmd);
+		use_browser = check_browser_config(p->cmd);
 
 	if (use_pager == -1 && p->option & RUN_SETUP)
 		use_pager = check_pager_config(p->cmd);
-- 
1.7.9.2.358.g22243

