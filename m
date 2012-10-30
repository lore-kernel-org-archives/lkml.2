Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090Ab2J3MHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:07:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40916 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758042Ab2J3MHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:07:13 -0400
Date: Tue, 30 Oct 2012 05:06:46 -0700
From: tip-bot for Feng Tang <feng.tang@intel.com>
Message-ID: <tip-49e639e256ea18fb92f609dd6be09883cd9d05aa@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, andi@firstfloor.org, peterz@infradead.org,
        namhyung@kernel.org, tglx@linutronix.de, feng.tang@intel.com,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, andi@firstfloor.org, peterz@infradead.org,
        namhyung@kernel.org, tglx@linutronix.de, feng.tang@intel.com,
        mingo@elte.hu
In-Reply-To: <1351569369-26732-3-git-send-email-feng.tang@intel.com>
References: <1351569369-26732-3-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Add more filter to find_scripts()
Git-Commit-ID: 49e639e256ea18fb92f609dd6be09883cd9d05aa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 30 Oct 2012 05:06:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  49e639e256ea18fb92f609dd6be09883cd9d05aa
Gitweb:     http://git.kernel.org/tip/49e639e256ea18fb92f609dd6be09883cd9d05aa
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Tue, 30 Oct 2012 11:56:03 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 29 Oct 2012 11:46:23 -0200

perf script: Add more filter to find_scripts()

As suggested by Arnaldo, many scripts have their own usages and need
capture specific events or tracepoints, so only those scripts whose
target events match the events in current perf data file should be
listed in the script browser menu.

This patch will add the event match checking, by opening "xxx-record"
script to cherry pick out all events name and comparing them with
those inside the perf data file.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1351569369-26732-3-git-send-email-feng.tang@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c |   82 +++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 79 insertions(+), 3 deletions(-)

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
 
