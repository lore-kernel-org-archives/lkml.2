Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab2ICIUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 04:20:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:51049 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756085Ab2ICIU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 04:20:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,359,1344236400"; 
   d="scan'208";a="140902992"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, andi@firstfloor.org,
        namhyung@kernel.org, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH 5/7] perf ui/browser: Add a browser for perf script
Date: Mon,  3 Sep 2012 16:14:31 +0800
Message-Id: <1346660073-20279-6-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1346660073-20279-1-git-send-email-feng.tang@intel.com>
References: <1346660073-20279-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a script browser, so that user can check all the available
scripts and run them inside the main perf report or annotation
browsers, for all the perf samples or samples belong to one
thread/symbol.

The work flow is, users can use function key to list all the available
scripts in system and chose one, which will be executed with
popen("perf script -s xxx.xx",) and all the output lines are put into
one ui browser, pressing 'q' or left arrow key will make it return
to previous browser.

Please be noted, most of the in-tree scripts with name xxxtop are
dynamically run and not supported by this static browser. You can run
the event_analyzing_sample.py for example.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 tools/perf/Makefile              |    5 +
 tools/perf/ui/browsers/scripts.c |  159 ++++++++++++++++++++++++++++++++++++++
 tools/perf/ui/browsers/scripts.h |    5 +
 3 files changed, 169 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/ui/browsers/scripts.c
 create mode 100644 tools/perf/ui/browsers/scripts.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 722ddee..1fe23b9 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -569,6 +569,7 @@ else
 		LIB_OBJS += $(OUTPUT)ui/browsers/annotate.o
 		LIB_OBJS += $(OUTPUT)ui/browsers/hists.o
 		LIB_OBJS += $(OUTPUT)ui/browsers/map.o
+		LIB_OBJS += $(OUTPUT)ui/browsers/scripts.o
 		LIB_OBJS += $(OUTPUT)ui/progress.o
 		LIB_OBJS += $(OUTPUT)ui/util.o
 		LIB_OBJS += $(OUTPUT)ui/tui/setup.o
@@ -576,6 +577,7 @@ else
 		LIB_OBJS += $(OUTPUT)ui/tui/helpline.o
 		LIB_H += ui/browser.h
 		LIB_H += ui/browsers/map.h
+		LIB_H += ui/browsers/scripts.h
 		LIB_H += ui/keysyms.h
 		LIB_H += ui/libslang.h
 		LIB_H += ui/progress.h
@@ -878,6 +880,9 @@ $(OUTPUT)ui/browsers/hists.o: ui/browsers/hists.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)ui/browsers/map.o: ui/browsers/map.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<

+$(OUTPUT)ui/browsers/scripts.o: ui/browsers/scripts.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
+
 $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<

diff --git a/tools/perf/ui/browsers/scripts.c b/tools/perf/ui/browsers/scripts.c
new file mode 100644
index 0000000..7183795
--- /dev/null
+++ b/tools/perf/ui/browsers/scripts.c
@@ -0,0 +1,159 @@
+#include <elf.h>
+#include <newt.h>
+#include <inttypes.h>
+#include <sys/ttydefaults.h>
+#include <string.h>
+#include <linux/bitops.h>
+#include "../../util/sort.h"
+#include "../../util/util.h"
+#include "../../util/debug.h"
+#include "../../util/symbol.h"
+#include "../browser.h"
+#include "../helpline.h"
+#include "../libslang.h"
+#include "scripts.h"
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
+#define SCRIPT_NAMELEN	40
+#define SCRIPT_MAX_NO	32
+#define SCRIPT_FULLPATH_LEN 128
+
+/* Return 0 on success */
+static int list_scripts(char *script_name)
+{
+	char *buffer, *scripts[SCRIPT_MAX_NO], *scripts_path[SCRIPT_MAX_NO];
+	int i, num, choice, ret = -1;
+
+	/* Preset the script name to SCRIPT_NAMELEN */
+	buffer = zalloc(SCRIPT_MAX_NO * (SCRIPT_NAMELEN + SCRIPT_FULLPATH_LEN));
+	if (!buffer)
+		return ret;
+
+	for (i = 0; i < SCRIPT_MAX_NO; i++) {
+		scripts[i] = buffer + i * (SCRIPT_NAMELEN + SCRIPT_FULLPATH_LEN);
+		scripts_path[i] = scripts[i] + SCRIPT_NAMELEN;
+	}
+
+	num = find_scripts(scripts, scripts_path);
+	if (num) {
+		choice = ui__popup_menu(num, scripts);
+		if (choice < num && choice >= 0) {
+			strcpy(script_name, scripts_path[choice]);
+			ret = 0;
+		}
+	}
+
+	free(buffer);
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
+	char cmd[160], script_name[128];
+	char *line = NULL;
+	size_t len = 0;
+	ssize_t retlen;
+	int ret = -1, nr_entries = 0;
+	FILE *fp;
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
+	sline = malloc((sizeof(*sline)) * MAX_LINES);
+	if (!sline)
+		return -1;
+
+	memset(script_name, 0, 128);
+	if (list_scripts(script_name))
+		goto exit;
+
+	if (script_opt)
+		sprintf(cmd, "perf script %s -s %s 2>&1", script_opt, script_name);
+	else
+		sprintf(cmd, "perf script -s %s 2>&1", script_name);
+
+	fp = popen(cmd, "r");
+	if (!fp)
+		goto exit;
+
+	while ((retlen = getline(&line, &len, fp)) != -1) {
+		strcpy(sline[nr_entries].line, line);
+		list_add_tail(&sline[nr_entries].node, &script.entries);
+
+		if (script.b.width < retlen)
+			script.b.width = retlen;
+		nr_entries++;
+	}
+
+	script.nr_lines = nr_entries;
+	script.b.nr_entries = nr_entries;
+	script.b.entries = &script.entries;
+
+	ret = script_browser__run(&script);
+
+	if (line)
+		free(line);
+
+exit:
+	free(sline);
+	return ret;
+}
diff --git a/tools/perf/ui/browsers/scripts.h b/tools/perf/ui/browsers/scripts.h
new file mode 100644
index 0000000..011baa8
--- /dev/null
+++ b/tools/perf/ui/browsers/scripts.h
@@ -0,0 +1,5 @@
+#ifndef _PERF_UI_BROWSER_BROWSER_H_
+#define _PERF_UI_BROWSER_BROWSER_H_ 1
+
+int script_browse(const char *script_opt);
+#endif /* _PERF_UI_BROWSER_BROWSER_H_ */
--
1.7.1

