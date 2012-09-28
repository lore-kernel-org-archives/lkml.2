Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab2I1IhO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:37:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:37094 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756641Ab2I1IhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:37:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,501,1344236400"; 
   d="scan'208";a="150188620"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, andi@firstfloor.org,
        namhyung@kernel.org, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH v4 3/8] perf ui/browser: Add a browser for perf script
Date: Fri, 28 Sep 2012 16:30:35 +0800
Message-Id: <1348821040-9724-4-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1348821040-9724-1-git-send-email-feng.tang@intel.com>
References: <1348821040-9724-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 tools/perf/Makefile              |    4 +
 tools/perf/ui/browsers/scripts.c |  189 ++++++++++++++++++++++++++++++++++++++
 tools/perf/util/hist.h           |    7 ++
 3 files changed, 200 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/ui/browsers/scripts.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e5e71e7..dbe107c 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -588,6 +588,7 @@ else
 		LIB_OBJS += $(OUTPUT)ui/browsers/annotate.o
 		LIB_OBJS += $(OUTPUT)ui/browsers/hists.o
 		LIB_OBJS += $(OUTPUT)ui/browsers/map.o
+		LIB_OBJS += $(OUTPUT)ui/browsers/scripts.o
 		LIB_OBJS += $(OUTPUT)ui/progress.o
 		LIB_OBJS += $(OUTPUT)ui/util.o
 		LIB_OBJS += $(OUTPUT)ui/tui/setup.o
@@ -905,6 +906,9 @@ $(OUTPUT)ui/browsers/hists.o: ui/browsers/hists.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)ui/browsers/map.o: ui/browsers/map.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
+$(OUTPUT)ui/browsers/scripts.o: ui/browsers/scripts.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
+
 $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
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
index f011ad4..3bd60f3 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -175,6 +175,12 @@ static inline int hist_entry__tui_annotate(struct hist_entry *self
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
 #else
@@ -202,6 +208,7 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist __maybe_unused,
 int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist, const char *help,
 				  void(*timer)(void *arg), void *arg,
 				  int refresh);
+int script_browse(const char *script_opt);
 #endif
 
 unsigned int hists__sort_list_width(struct hists *self);
-- 
1.7.1

