Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab2J2D5e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 23:57:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:3896 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757408Ab2J2D5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 23:57:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,669,1344236400"; 
   d="scan'208";a="210544413"
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>
Subject: [PATCH v5 2/8] perf script: Add more filter to find_scripts()
Date: Tue, 30 Oct 2012 11:56:03 +0800
Message-Id: <1351569369-26732-3-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351569369-26732-1-git-send-email-feng.tang@intel.com>
References: <1351569369-26732-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Arnaldo, many scripts have their own usages and need
capture specific events or tracepoints, so only those scripts whose
target events match the events in current perf data file should be
listed in the script browser menu.

This patch will add the event match checking, by opening "xxx-record"
script to cherry pick out all events name and comparing them with
those inside the perf data file.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 tools/perf/builtin-script.c |   82 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 79 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 7c6e4b2..b363e7b 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1030,6 +1030,68 @@ static int list_available_scripts(const struct option *opt __maybe_unused,
 }
 
 /*
+ * Some scripts specify the required events in their "xxx-record" file,
+ * this function will check if the events in perf.data match those
+ * mentioned in the "xxx-record".
+ *
+ * Fixme: All existing "xxx-record" are all in good formats "-e event ",
+ * which is covered well now. And new parsing code should be added to
+ * cover the future complexing formats like event groups etc.
+ */
+static int check_ev_match(char *dir_name, char *scriptname,
+			struct perf_session *session)
+{
+	char filename[MAXPATHLEN], evname[128];
+	char line[BUFSIZ], *p;
+	struct perf_evsel *pos;
+	int match, len;
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
+		if (*p == '#')
+			continue;
+
+		while (strlen(p)) {
+			p = strstr(p, "-e");
+			if (!p)
+				break;
+
+			p += 2;
+			p = ltrim(p);
+			len = strcspn(p, " \t");
+			if (!len)
+				break;
+
+			snprintf(evname, len + 1, "%s", p);
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
+		}
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
@@ -1039,17 +1101,23 @@ static int list_available_scripts(const struct option *opt __maybe_unused,
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
@@ -1077,10 +1145,18 @@ int find_scripts(char **scripts_array, char **scripts_path_array)
 			snprintf(scripts_array[i],
 				(temp - script_dirent.d_name) + 1,
 				"%s", script_dirent.d_name);
+
+			if (check_ev_match(lang_path,
+					scripts_array[i], session))
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
1.7.9.5

