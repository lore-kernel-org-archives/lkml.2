Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab0EUBJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 21:09:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:50777 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab0EUBJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 21:09:07 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH v2 2/2] perf tui: Allow disabling the TUI on a per command basis in ~/.perfconfig
Date: Thu, 20 May 2010 22:08:41 -0300
Message-Id: <1274404121-6115-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274404121-6115-1-git-send-email-acme@infradead.org>
References: <1274404121-6115-1-git-send-email-acme@infradead.org>
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
 tools/perf/builtin-report.c |    8 ++++----
 tools/perf/perf.c           |   25 +++++++++++++++++++++++--
 tools/perf/util/cache.h     |    2 +-
 tools/perf/util/newt.c      |    9 ++++++---
 4 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 1d3c100..a7b8760 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -116,7 +116,7 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 	 * so we don't allocated the extra space needed because the stdio
 	 * code will not use it.
 	 */
-	if (use_browser)
+	if (use_browser > 0)
 		err = hist_entry__inc_addr_samples(he, al->addr);
 out_free_syms:
 	free(syms);
@@ -330,7 +330,7 @@ static int __cmd_report(void)
 		hists = rb_entry(next, struct hists, rb_node);
 		hists__collapse_resort(hists);
 		hists__output_resort(hists);
-		if (use_browser)
+		if (use_browser > 0)
 			hists__browse(hists, help, input_name);
 		else {
 			const char *evname = NULL;
@@ -347,7 +347,7 @@ static int __cmd_report(void)
 		next = rb_next(&hists->rb_node);
 	}
 
-	if (!use_browser && sort_order == default_sort_order &&
+	if (use_browser <= 0 && sort_order == default_sort_order &&
 	    parent_pattern == default_parent_pattern) {
 		fprintf(stdout, "#\n# (%s)\n#\n", help);
 
@@ -491,7 +491,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	 * so don't allocate extra space that won't be used in the stdio
 	 * implementation.
 	 */
-	if (use_browser)
+	if (use_browser > 0)
 		symbol_conf.priv_size = sizeof(struct sym_priv);
 
 	if (symbol__init() < 0)
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
index 9338d06..9d203c9 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -1066,10 +1066,13 @@ static struct newtPercentTreeColors {
 void setup_browser(void)
 {
 	struct newtPercentTreeColors *c = &defaultPercentTreeColors;
-	if (!isatty(1))
+
+	if (!isatty(1) || !use_browser) {
+		setup_pager();
 		return;
+	}
 
-	use_browser = true;
+	use_browser = 1;
 	newtInit();
 	newtCls();
 	ui_helpline__puts(" ");
@@ -1082,7 +1085,7 @@ void setup_browser(void)
 
 void exit_browser(bool wait_for_ok)
 {
-	if (use_browser) {
+	if (use_browser > 0) {
 		if (wait_for_ok) {
 			char title[] = "Fatal Error", ok[] = "Ok";
 			newtWinMessage(title, ok, browser__last_msg);
-- 
1.6.2.5

