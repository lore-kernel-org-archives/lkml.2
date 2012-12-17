Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab2LQGlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 01:41:55 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45648 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab2LQGjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 01:39:13 -0500
X-AuditID: 9c930179-b7becae000000e51-88-50cebe0e1495
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Pekka Enberg <penberg@kernel.org>,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH 10/14] perf gtk/browser: Trim column header string when event group enabled
Date: Mon, 17 Dec 2012 15:39:01 +0900
Message-Id: <1355726345-29553-11-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355726345-29553-1-git-send-email-namhyung@kernel.org>
References: <1355726345-29553-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When event group feature is enabled, each column header is expanded to
match with the whole group column width.  But this is not needed for
GTK+ browser since it usually use variable-width fonts.  So trim it.

As we have ltrim() implementation in builtin-script.c move it to the
more generic location of util/string.c.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Feng Tang <feng.tang@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-script.c | 12 ------------
 tools/perf/ui/gtk/browser.c |  2 +-
 tools/perf/util/string.c    | 18 ++++++++++++++++++
 tools/perf/util/util.h      |  1 +
 4 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index b363e7b292b2..74b9f740794b 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -909,18 +909,6 @@ static const char *ends_with(const char *str, const char *suffix)
 	return NULL;
 }
 
-static char *ltrim(char *str)
-{
-	int len = strlen(str);
-
-	while (len && isspace(*str)) {
-		len--;
-		str++;
-	}
-
-	return str;
-}
-
 static int read_script_info(struct script_desc *desc, const char *filename)
 {
 	char line[BUFSIZ], *p;
diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index a82e903703b4..8de928848f79 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -202,7 +202,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 	perf_hpp__for_each_format(fmt) {
 		fmt->header(fmt, &hpp);
 		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
-							    -1, s,
+							    -1, ltrim(s),
 							    renderer, "markup",
 							    col_idx++, NULL);
 	}
diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index 346707df04b9..29c7b2cb2521 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -332,6 +332,24 @@ char *strxfrchar(char *s, char from, char to)
 }
 
 /**
+ * ltrim - Removes leading whitespace from @s.
+ * @s: The string to be stripped.
+ *
+ * Return pointer to the first non-whitespace character in @s.
+ */
+char *ltrim(char *s)
+{
+	int len = strlen(s);
+
+	while (len && isspace(*s)) {
+		len--;
+		s++;
+	}
+
+	return s;
+}
+
+/**
  * rtrim - Removes trailing whitespace from @s.
  * @s: The string to be stripped.
  *
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index c2330918110c..2a854a133b5b 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -265,6 +265,7 @@ bool is_power_of_2(unsigned long n)
 size_t hex_width(u64 v);
 int hex2u64(const char *ptr, u64 *val);
 
+char *ltrim(char *s);
 char *rtrim(char *s);
 
 void dump_stack(void);
-- 
1.7.11.7

