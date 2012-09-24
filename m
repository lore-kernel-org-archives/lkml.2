Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab2IXPcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:32:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:15850 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab2IXPae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:30:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,476,1344236400"; 
   d="scan'208";a="196413178"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, andi@firstfloor.org,
        namhyung@kernel.org, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH v3 3/9] perf script: Add more filter to find_scripts()
Date: Mon, 24 Sep 2012 23:24:05 +0800
Message-Id: <1348500251-9937-4-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
References: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Arnaldo, many scripts have their own usages and need
capture specific events or tracepoints, so only those scripts whose
targe events match the events in current perf data file should be
listed in the script browser menu.

This patch will add the event match checking.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 tools/perf/builtin-script.c |   76 +++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 73 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 4e2f10f..37a0df8 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1031,6 +1031,63 @@ static int list_available_scripts(const struct option *opt __maybe_unused,
 }
 
 /*
+ * Some scripts specify the required events in their "xxx-record" file,
+ * this function will check if the events in perf.data match those
+ * mentioned in the "xxx-record".
+ */
+static int check_ev_match(char *dir_name, char *scriptname,
+			struct perf_session *session)
+{
+	char filename[MAXPATHLEN], evname[128];
+	char line[BUFSIZ], *p, *temp;
+	struct perf_evsel *pos;
+	int match;
+	FILE *fp;
+
+	sprintf(filename, "%s/bin/%s-record", dir_name, scriptname);
+
+	fp = fopen(filename, "r");
+	if (!fp)
+		return -1;
+
+	while (fgets(line, sizeof(line), fp)) {
+		p = ltrim(line);
+		if (strlen(p) == 0 ||*p == '#')
+			continue;
+
+		while (strlen(p)) {
+			temp = strstr(p, "-e");
+			if (!temp)
+				break;
+
+			p = temp + 3;
+			temp = strchr(p, ' ');
+			snprintf(evname, (temp - p) + 1, "%s", p);
+
+			match = 0;
+			list_for_each_entry(pos,
+					&session->evlist->entries, node) {
+				if (!strcmp(perf_evsel__name(pos), evname)) {
+					match = 1;
+					break;
+				}
+			}
+
+			if (!match) {
+				fclose(fp);
+				return -1;
+			}
+
+			p = temp + 1;
+		}
+
+	}
+
+	fclose(fp);
+	return 0;
+}
+
+/*
  * Return -1 if none is found, otherwise the actual scripts number.
  *
  * Currently the only user of this function is the script browser, which
@@ -1040,17 +1097,23 @@ static int list_available_scripts(const struct option *opt __maybe_unused,
 int find_scripts(char **scripts_array, char **scripts_path_array)
 {
 	struct dirent *script_next, *lang_next, script_dirent, lang_dirent;
-	char scripts_path[MAXPATHLEN];
+	char scripts_path[MAXPATHLEN], lang_path[MAXPATHLEN];
 	DIR *scripts_dir, *lang_dir;
-	char lang_path[MAXPATHLEN];
+	struct perf_session *session;
 	char *temp;
 	int i = 0;
 
+	session = perf_session__new(input_name, O_RDONLY, 0, false, NULL);
+	if (!session)
+		return -1;
+
 	snprintf(scripts_path, MAXPATHLEN, "%s/scripts", perf_exec_path());
 
 	scripts_dir = opendir(scripts_path);
-	if (!scripts_dir)
+	if (!scripts_dir) {
+		perf_session__delete(session);
 		return -1;
+	}
 
 	for_each_lang(scripts_path, scripts_dir, lang_dirent, lang_next) {
 		snprintf(lang_path, MAXPATHLEN, "%s/%s", scripts_path,
@@ -1078,10 +1141,17 @@ int find_scripts(char **scripts_array, char **scripts_path_array)
 			snprintf(scripts_array[i],
 				(temp - script_dirent.d_name) + 1,
 				"%s", script_dirent.d_name);
+
+			if (check_ev_match(lang_path, scripts_array[i], session))
+				continue;
+
 			i++;
 		}
+		closedir(lang_dir);
 	}
 
+	closedir(scripts_dir);
+	perf_session__delete(session);
 	return i;
 }
 
-- 
1.7.1

