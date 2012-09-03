Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab2ICIUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 04:20:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:51049 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756161Ab2ICIU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 04:20:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,359,1344236400"; 
   d="scan'208";a="140902983"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, andi@firstfloor.org,
        namhyung@kernel.org, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH 4/7] perf scripts: Export a find_scripts() function
Date: Mon,  3 Sep 2012 16:14:30 +0800
Message-Id: <1346660073-20279-5-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1346660073-20279-1-git-send-email-feng.tang@intel.com>
References: <1346660073-20279-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that other perf commands/browser has a way to dig out the available
scripts info in system, this is a preparation for the script browser.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 tools/perf/builtin-script.c |   46 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/builtin.h        |    1 +
 2 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 7ab86bb..d46056c 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1031,6 +1031,52 @@ static int list_available_scripts(const struct option *opt __used,
 	exit(0);
 }
 
+/*
+ * Return 0 if none is found, otherwise the actual scripts number.
+ *
+ * Currently we just return all the raw scripts name, and their full path.
+ *
+ */
+int find_scripts(char **scripts_array, char **scripts_path_array)
+{
+	struct dirent *script_next, *lang_next, script_dirent, lang_dirent;
+	char scripts_path[MAXPATHLEN];
+	DIR *scripts_dir, *lang_dir;
+	char lang_path[MAXPATHLEN];
+	struct script_desc *desc;
+	char first_half[BUFSIZ];
+	char *temp;
+	int i = 0;
+
+	first_half[0] = 0;
+	desc = NULL;
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
+		lang_dir = opendir(lang_path);
+		if (!lang_dir)
+			continue;
+
+		for_each_script(lang_path, lang_dir, script_dirent, script_next) {
+			sprintf(scripts_path_array[i], "%s/%s", lang_path,
+				script_dirent.d_name);
+			temp = strchr(script_dirent.d_name, '.');
+			snprintf(scripts_array[i], (temp - script_dirent.d_name) + 1,
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

