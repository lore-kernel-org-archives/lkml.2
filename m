Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000Ab2IGIse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 04:48:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:28377 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932856Ab2IGIs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 04:48:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,384,1344236400"; 
   d="scan'208";a="219252890"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, andi@firstfloor.org,
        namhyung@kernel.org, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH v2 4/7] perf scripts: Export a find_scripts() function
Date: Fri,  7 Sep 2012 16:42:26 +0800
Message-Id: <1347007349-3102-5-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1347007349-3102-1-git-send-email-feng.tang@intel.com>
References: <1347007349-3102-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that other perf commands/browser has a way to dig out the available
scripts info in system, this is a preparation for the script browser.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 tools/perf/builtin-script.c |   55 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/builtin.h        |    1 +
 2 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 7ab86bb..79f21d5 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1031,6 +1031,61 @@ static int list_available_scripts(const struct option *opt __used,
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

