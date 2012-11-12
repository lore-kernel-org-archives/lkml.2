Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab2KLCvH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 21:51:07 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:65426 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab2KLCvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 21:51:04 -0500
X-AuditID: 9c930197-b7b45ae000000e9e-c0-50a06415b980
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH] perf tools: Add gtk.<command> config option for launching GTK browser
Date: Mon, 12 Nov 2012 11:50:17 +0900
Message-Id: <1352688617-25570-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Add config option for launching GTK browser for the specified command
by default.  Currently only 'report' command is supported.

Adding following line to the perfconfig file will have a same effect
of specifying --gtk option on command line (unless other related
options are not given).

$ cat ~/.perfconfig
[gtk]
report = true

Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/perf.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index a0ae2902f9c9..0f661fbce6a8 100644
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
1.7.11.7

