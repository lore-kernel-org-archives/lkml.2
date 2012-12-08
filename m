Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab2LHOyr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 09:54:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49531 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab2LHOyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 09:54:46 -0500
Date: Sat, 8 Dec 2012 06:54:30 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-0020ce23864d16f66e5667013b8b43d1df3e142e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung.kim@lge.com, namhyung@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@kernel.org
In-Reply-To: <1352688617-25570-1-git-send-email-namhyung@kernel.org>
References: <1352688617-25570-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add gtk.<command>
  config option for launching GTK browser
Git-Commit-ID: 0020ce23864d16f66e5667013b8b43d1df3e142e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 08 Dec 2012 06:54:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0020ce23864d16f66e5667013b8b43d1df3e142e
Gitweb:     http://git.kernel.org/tip/0020ce23864d16f66e5667013b8b43d1df3e142e
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 12 Nov 2012 11:50:17 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Nov 2012 16:51:30 -0300

perf tools: Add gtk.<command> config option for launching GTK browser

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
 tools/perf/perf.c | 15 ++++++++++-----
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
