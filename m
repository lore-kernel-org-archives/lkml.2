Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408Ab2IQRSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:18:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57939 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062Ab2IQRSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:18:34 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/18] perf scripts: Export a find_scripts() function
Date: Mon, 17 Sep 2012 14:18:09 -0300
Message-Id: <1347902292-14536-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347902292-14536-1-git-send-email-acme@infradead.org>
References: <1347902292-14536-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

So that other perf commands/browser has a way to dig out the available
scripts info in system, this is a preparation for the script browser.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1347007349-3102-5-git-send-email-feng.tang@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c |   55 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/builtin.h        |    1 +
 2 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 76577e6..1be843a 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1032,6 +1032,61 @@ static int list_available_scripts(const struct option *opt __maybe_unused,
 	exit(0);
 }
 
+/*
+ * Return -1 if none is found, otherwise the actual scripts number.
+ *
+ * Currently the only user of this function is the script browser, which
+ * will list all statically runnable scripts, select one, execute it and
+ * show the output in a perf browser.
+ */
+int find_scripts(char **scripts_array, char **scripts_path_array)
+{
+	struct dirent *script_next, *lang_next, script_dirent, lang_dirent;
+	char scripts_path[MAXPATHLEN];
+	DIR *scripts_dir, *lang_dir;
+	char lang_path[MAXPATHLEN];
+	char *temp;
+	int i = 0;
+
+	snprintf(scripts_path, MAXPATHLEN, "%s/scripts", perf_exec_path());
+
+	scripts_dir = opendir(scripts_path);
+	if (!scripts_dir)
+		return -1;
+
+	for_each_lang(scripts_path, scripts_dir, lang_dirent, lang_next) {
+		snprintf(lang_path, MAXPATHLEN, "%s/%s", scripts_path,
+			 lang_dirent.d_name);
+#ifdef NO_LIBPERL
+		if (strstr(lang_path, "perl"))
+			continue;
+#endif
+#ifdef NO_LIBPYTHON
+		if (strstr(lang_path, "python"))
+			continue;
+#endif
+
+		lang_dir = opendir(lang_path);
+		if (!lang_dir)
+			continue;
+
+		for_each_script(lang_path, lang_dir, script_dirent, script_next) {
+			/* Skip those real time scripts: xxxtop.p[yl] */
+			if (strstr(script_dirent.d_name, "top."))
+				continue;
+			sprintf(scripts_path_array[i], "%s/%s", lang_path,
+				script_dirent.d_name);
+			temp = strchr(script_dirent.d_name, '.');
+			snprintf(scripts_array[i],
+				(temp - script_dirent.d_name) + 1,
+				"%s", script_dirent.d_name);
+			i++;
+		}
+	}
+
+	return i;
+}
+
 static char *get_script_path(const char *script_root, const char *suffix)
 {
 	struct dirent *script_next, *lang_next, script_dirent, lang_dirent;
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index b382bd5..3ea74ed 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -36,4 +36,5 @@ extern int cmd_kvm(int argc, const char **argv, const char *prefix);
 extern int cmd_test(int argc, const char **argv, const char *prefix);
 extern int cmd_inject(int argc, const char **argv, const char *prefix);
 
+extern int find_scripts(char **scripts_array, char **scripts_path_array);
 #endif
-- 
1.7.1

