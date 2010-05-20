Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab0ETWe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 18:34:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:50387 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab0ETWe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 18:34:26 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/1] perf tui: Allow disabling the TUI on a per command basis in ~/.perfconfig
Date: Thu, 20 May 2010 19:34:04 -0300
Message-Id: <1274394844-994-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274394844-994-1-git-send-email-acme@infradead.org>
References: <1274394844-994-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Using the same scheme as for git's/perf's pager setup, i.e. if one
doesn't want to, on a newt enabled perf binary, to disable the TUI for
'perf report', its just a matter of doing:

[root@doppio linux-2.6-tip]# printf "[tui]\n\nreport = off\n" >
/root/.perfconfig
[root@doppio linux-2.6-tip]# cat /root/.perfconfig
[tui]

report = off
[root@doppio linux-2.6-tip]#

System wide settings are also possible, by editing /etc/perfconfig, etc,
i.e. the git machinery for config files applies to perf as well, so when
in doubt where to put your settings, consult the git documentation, if
it fails, please let us know.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Discussed-with: Stephane Eranian <eranian@google.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf.c       |   25 +++++++++++++++++++++++--
 tools/perf/util/cache.h |    2 +-
 tools/perf/util/newt.c  |    7 +++++--
 3 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 08e0e5d..6e48711 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -15,15 +15,15 @@
 #include "util/parse-events.h"
 #include "util/debugfs.h"
 
-bool use_browser;
-
 const char perf_usage_string[] =
 	"perf [--version] [--help] COMMAND [ARGS]";
 
 const char perf_more_info_string[] =
 	"See 'perf help COMMAND' for more information on a specific command.";
 
+int use_browser = -1;
 static int use_pager = -1;
+
 struct pager_config {
 	const char *cmd;
 	int val;
@@ -49,6 +49,24 @@ int check_pager_config(const char *cmd)
 	return c.val;
 }
 
+static int tui_command_config(const char *var, const char *value, void *data)
+{
+	struct pager_config *c = data;
+	if (!prefixcmp(var, "tui.") && !strcmp(var + 4, c->cmd))
+		c->val = perf_config_bool(var, value);
+	return 0;
+}
+
+/* returns 0 for "no tui", 1 for "use tui", and -1 for "not specified" */
+static int check_tui_config(const char *cmd)
+{
+	struct pager_config c;
+	c.cmd = cmd;
+	c.val = -1;
+	perf_config(tui_command_config, &c);
+	return c.val;
+}
+
 static void commit_pager_choice(void)
 {
 	switch (use_pager) {
@@ -255,6 +273,9 @@ static int run_builtin(struct cmd_struct *p, int argc, const char **argv)
 	if (p->option & RUN_SETUP)
 		prefix = NULL; /* setup_perf_directory(); */
 
+	if (use_browser == -1)
+		use_browser = check_tui_config(p->cmd);
+
 	if (use_pager == -1 && p->option & RUN_SETUP)
 		use_pager = check_pager_config(p->cmd);
 	if (use_pager == -1 && p->option & USE_PAGER)
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 5eca525..65fe664 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -30,7 +30,7 @@ extern const char *pager_program;
 extern int pager_in_use(void);
 extern int pager_use_color;
 
-extern bool use_browser;
+extern int use_browser;
 
 #ifdef NO_NEWT_SUPPORT
 static inline void setup_browser(void)
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 051022e..f65e859 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -1068,10 +1068,13 @@ static struct newtPercentTreeColors {
 void setup_browser(void)
 {
 	struct newtPercentTreeColors *c = &defaultPercentTreeColors;
-	if (!isatty(1))
+
+	if (!isatty(1) || use_browser != -1) {
+		setup_pager();
 		return;
+	}
 
-	use_browser = true;
+	use_browser = 1;
 	newtInit();
 	newtCls();
 	ui_helpline__puts(" ");
-- 
1.6.2.5

