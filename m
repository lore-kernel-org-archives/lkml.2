Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125Ab2J3MIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:08:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40934 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab2J3MI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:08:29 -0400
Date: Tue, 30 Oct 2012 05:07:49 -0700
From: tip-bot for Feng Tang <feng.tang@intel.com>
Message-ID: <tip-66517826664fa910d4bc5f32a5abff6bcd8657c5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, andi@firstfloor.org, peterz@infradead.org,
        namhyung@kernel.org, tglx@linutronix.de, feng.tang@intel.com,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, andi@firstfloor.org, peterz@infradead.org,
        namhyung@kernel.org, tglx@linutronix.de, feng.tang@intel.com,
        mingo@elte.hu
In-Reply-To: <1351569369-26732-4-git-send-email-feng.tang@intel.com>
References: <1351569369-26732-4-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf scripts browser:
  Add a browser for perf script
Git-Commit-ID: 66517826664fa910d4bc5f32a5abff6bcd8657c5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 30 Oct 2012 05:07:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  66517826664fa910d4bc5f32a5abff6bcd8657c5
Gitweb:     http://git.kernel.org/tip/66517826664fa910d4bc5f32a5abff6bcd8657c5
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Tue, 30 Oct 2012 11:56:04 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 29 Oct 2012 11:52:53 -0200

perf scripts browser: Add a browser for perf script

Create a script browser, so that user can check all the available
scripts for current perf data file and run them inside the main perf
report or annotation browsers, for all perf samples or for samples
belong to one thread/symbol.

Please be noted: current script browser is only for report use, and
doesn't cover the record phase, IOW it must run against one existing
perf data file.

The work flow is, users can use function key to list all the available
scripts for current perf data file in system and chose one, which will
be executed with popen("perf script -s xxx.xx",) and all the output
lines are put into one ui browser, pressing 'q' or left arrow key will
make it return to previous browser.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1351569369-26732-4-git-send-email-feng.tang@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile              |    4 +
 tools/perf/ui/browsers/scripts.c |  189 ++++++++++++++++++++++++++++++++++++++
 tools/perf/util/hist.h           |    7 ++
 3 files changed, 200 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ec63d53..7e25f59 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -593,6 +593,7 @@ ifndef NO_NEWT
 		LIB_OBJS += $(OUTPUT)ui/browsers/annotate.o
 		LIB_OBJS += $(OUTPUT)ui/browsers/hists.o
 		LIB_OBJS += $(OUTPUT)ui/browsers/map.o
+		LIB_OBJS += $(OUTPUT)ui/browsers/scripts.o
 		LIB_OBJS += $(OUTPUT)ui/progress.o
 		LIB_OBJS += $(OUTPUT)ui/util.o
 		LIB_OBJS += $(OUTPUT)ui/tui/setup.o
@@ -909,6 +910,9 @@ $(OUTPUT)ui/browsers/hists.o: ui/browsers/hists.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)ui/browsers/map.o: ui/browsers/map.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
+$(OUTPUT)ui/browsers/scripts.o: ui/browsers/scripts.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
+
 $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Wno-unused-parameter -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
diff --git a/tools/perf/ui/browsers/scripts.c b/tools/perf/ui/browsers/scripts.c
new file mode 100644
index 0000000..cbbd44b
--- /dev/null
+++ b/tools/perf/ui/browsers/scripts.c
@@ -0,0 +1,189 @@
+#include <elf.h>
+#include <newt.h>
+#include <inttypes.h>
+#include <sys/ttydefaults.h>
+#include <string.h>
+#include "../../util/sort.h"
+#include "../../util/util.h"
+#include "../../util/hist.h"
+#include "../../util/debug.h"
+#include "../../util/symbol.h"
+#include "../browser.h"
+#include "../helpline.h"
+#include "../libslang.h"
+
+/* 2048 lines should be enough for a script output */
+#define MAX_LINES		2048
+
+/* 160 bytes for one output line */
+#define AVERAGE_LINE_LEN	160
+
+struct script_line {
+	struct list_head node;
+	char line[AVERAGE_LINE_LEN];
+};
+
+struct perf_script_browser {
+	struct ui_browser b;
+	struct list_head entries;
+	const char *script_name;
+	int nr_lines;
+};
+
+#define SCRIPT_NAMELEN	128
+#define SCRIPT_MAX_NO	64
+/*
+ * Usually the full path for a script is:
+ *	/home/username/libexec/perf-core/scripts/python/xxx.py
+ *	/home/username/libexec/perf-core/scripts/perl/xxx.pl
+ * So 256 should be long enough to contain the full path.
+ */
+#define SCRIPT_FULLPATH_LEN	256
+
+/*
+ * When success, will copy the full path of the selected script
+ * into  the buffer pointed by script_name, and return 0.
+ * Return -1 on failure.
+ */
+static int list_scripts(char *script_name)
+{
+	char *buf, *names[SCRIPT_MAX_NO], *paths[SCRIPT_MAX_NO];
+	int i, num, choice, ret = -1;
+
+	/* Preset the script name to SCRIPT_NAMELEN */
+	buf = malloc(SCRIPT_MAX_NO * (SCRIPT_NAMELEN + SCRIPT_FULLPATH_LEN));
+	if (!buf)
+		return ret;
+
+	for (i = 0; i < SCRIPT_MAX_NO; i++) {
+		names[i] = buf + i * (SCRIPT_NAMELEN + SCRIPT_FULLPATH_LEN);
+		paths[i] = names[i] + SCRIPT_NAMELEN;
+	}
+
+	num = find_scripts(names, paths);
+	if (num > 0) {
+		choice = ui__popup_menu(num, names);
+		if (choice < num && choice >= 0) {
+			strcpy(script_name, paths[choice]);
+			ret = 0;
+		}
+	}
+
+	free(buf);
+	return ret;
+}
+
+static void script_browser__write(struct ui_browser *browser,
+				   void *entry, int row)
+{
+	struct script_line *sline = list_entry(entry, struct script_line, node);
+	bool current_entry = ui_browser__is_current_entry(browser, row);
+
+	ui_browser__set_color(browser, current_entry ? HE_COLORSET_SELECTED :
+						       HE_COLORSET_NORMAL);
+
+	slsmg_write_nstring(sline->line, browser->width);
+}
+
+static int script_browser__run(struct perf_script_browser *self)
+{
+	int key;
+
+	if (ui_browser__show(&self->b, self->script_name,
+			     "Press <- or ESC to exit") < 0)
+		return -1;
+
+	while (1) {
+		key = ui_browser__run(&self->b, 0);
+
+		/* We can add some special key handling here if needed */
+		break;
+	}
+
+	ui_browser__hide(&self->b);
+	return key;
+}
+
+
+int script_browse(const char *script_opt)
+{
+	char cmd[SCRIPT_FULLPATH_LEN*2], script_name[SCRIPT_FULLPATH_LEN];
+	char *line = NULL;
+	size_t len = 0;
+	ssize_t retlen;
+	int ret = -1, nr_entries = 0;
+	FILE *fp;
+	void *buf;
+	struct script_line *sline;
+
+	struct perf_script_browser script = {
+		.b = {
+			.refresh    = ui_browser__list_head_refresh,
+			.seek	    = ui_browser__list_head_seek,
+			.write	    = script_browser__write,
+		},
+		.script_name = script_name,
+	};
+
+	INIT_LIST_HEAD(&script.entries);
+
+	/* Save each line of the output in one struct script_line object. */
+	buf = zalloc((sizeof(*sline)) * MAX_LINES);
+	if (!buf)
+		return -1;
+	sline = buf;
+
+	memset(script_name, 0, SCRIPT_FULLPATH_LEN);
+	if (list_scripts(script_name))
+		goto exit;
+
+	sprintf(cmd, "perf script -s %s ", script_name);
+
+	if (script_opt)
+		strcat(cmd, script_opt);
+
+	if (input_name) {
+		strcat(cmd, " -i ");
+		strcat(cmd, input_name);
+	}
+
+	strcat(cmd, " 2>&1");
+
+	fp = popen(cmd, "r");
+	if (!fp)
+		goto exit;
+
+	while ((retlen = getline(&line, &len, fp)) != -1) {
+		strncpy(sline->line, line, AVERAGE_LINE_LEN);
+
+		/* If one output line is very large, just cut it short */
+		if (retlen >= AVERAGE_LINE_LEN) {
+			sline->line[AVERAGE_LINE_LEN - 1] = '\0';
+			sline->line[AVERAGE_LINE_LEN - 2] = '\n';
+		}
+		list_add_tail(&sline->node, &script.entries);
+
+		if (script.b.width < retlen)
+			script.b.width = retlen;
+
+		if (nr_entries++ >= MAX_LINES - 1)
+			break;
+		sline++;
+	}
+
+	if (script.b.width > AVERAGE_LINE_LEN)
+		script.b.width = AVERAGE_LINE_LEN;
+
+	if (line)
+		free(line);
+	pclose(fp);
+
+	script.nr_lines = nr_entries;
+	script.b.nr_entries = nr_entries;
+	script.b.entries = &script.entries;
+
+	ret = script_browser__run(&script);
+exit:
+	free(buf);
+	return ret;
+}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index c751624..b874609 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -165,6 +165,7 @@ int hist_entry__tui_annotate(struct hist_entry *he, int evidx,
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
 				  void(*timer)(void *arg), void *arg,
 				  int refresh);
+int script_browse(const char *script_opt);
 #else
 static inline
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist __maybe_unused,
@@ -186,6 +187,12 @@ static inline int hist_entry__tui_annotate(struct hist_entry *self
 {
 	return 0;
 }
+
+static inline int script_browse(const char *script_opt)
+{
+	return 0;
+}
+
 #define K_LEFT -1
 #define K_RIGHT -2
 #endif
