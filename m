Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab1LLN0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 08:26:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:46300 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab1LLN0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 08:26:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/3] perf script: Fix mem leaks and NULL pointer checks around strdup()s
Date: Mon, 12 Dec 2011 11:26:07 -0200
Message-Id: <1323696369-14688-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1323696369-14688-1-git-send-email-acme@infradead.org>
References: <1323696369-14688-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

Fix mem leaks and missing NULL pointer checks after strdup().

And get_script_path() did not free __script_root in case of continue.

Introduce a helper function get_script_root().

Cc: Ingo Molnar <mingo@elte.hu>
Link: http://lkml.kernel.org/r/1322217520-3287-1-git-send-email-robert.richter@amd.com
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c |   48 ++++++++++++++++++++++++++-----------------
 1 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 619d6dc..ccbfd56 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -693,7 +693,8 @@ static int parse_output_fields(const struct option *opt __used,
 			type = PERF_TYPE_RAW;
 		else {
 			fprintf(stderr, "Invalid event type in field string.\n");
-			return -EINVAL;
+			rc = -EINVAL;
+			goto out;
 		}
 
 		if (output[type].user_set)
@@ -935,6 +936,24 @@ static int read_script_info(struct script_desc *desc, const char *filename)
 	return 0;
 }
 
+static char *get_script_root(struct dirent *script_dirent, const char *suffix)
+{
+	char *script_root, *str;
+
+	script_root = strdup(script_dirent->d_name);
+	if (!script_root)
+		return NULL;
+
+	str = (char *)ends_with(script_root, suffix);
+	if (!str) {
+		free(script_root);
+		return NULL;
+	}
+
+	*str = '\0';
+	return script_root;
+}
+
 static int list_available_scripts(const struct option *opt __used,
 				  const char *s __used, int unset __used)
 {
@@ -946,7 +965,6 @@ static int list_available_scripts(const struct option *opt __used,
 	struct script_desc *desc;
 	char first_half[BUFSIZ];
 	char *script_root;
-	char *str;
 
 	snprintf(scripts_path, MAXPATHLEN, "%s/scripts", perf_exec_path());
 
@@ -962,16 +980,14 @@ static int list_available_scripts(const struct option *opt __used,
 			continue;
 
 		for_each_script(lang_path, lang_dir, script_dirent, script_next) {
-			script_root = strdup(script_dirent.d_name);
-			str = (char *)ends_with(script_root, REPORT_SUFFIX);
-			if (str) {
-				*str = '\0';
+			script_root = get_script_root(&script_dirent, REPORT_SUFFIX);
+			if (script_root) {
 				desc = script_desc__findnew(script_root);
 				snprintf(script_path, MAXPATHLEN, "%s/%s",
 					 lang_path, script_dirent.d_name);
 				read_script_info(desc, script_path);
+				free(script_root);
 			}
-			free(script_root);
 		}
 	}
 
@@ -993,8 +1009,7 @@ static char *get_script_path(const char *script_root, const char *suffix)
 	char script_path[MAXPATHLEN];
 	DIR *scripts_dir, *lang_dir;
 	char lang_path[MAXPATHLEN];
-	char *str, *__script_root;
-	char *path = NULL;
+	char *__script_root;
 
 	snprintf(scripts_path, MAXPATHLEN, "%s/scripts", perf_exec_path());
 
@@ -1010,23 +1025,18 @@ static char *get_script_path(const char *script_root, const char *suffix)
 			continue;
 
 		for_each_script(lang_path, lang_dir, script_dirent, script_next) {
-			__script_root = strdup(script_dirent.d_name);
-			str = (char *)ends_with(__script_root, suffix);
-			if (str) {
-				*str = '\0';
-				if (strcmp(__script_root, script_root))
-					continue;
+			__script_root = get_script_root(&script_dirent, suffix);
+			if (__script_root && !strcmp(script_root, __script_root)) {
+				free(__script_root);
 				snprintf(script_path, MAXPATHLEN, "%s/%s",
 					 lang_path, script_dirent.d_name);
-				path = strdup(script_path);
-				free(__script_root);
-				break;
+				return strdup(script_path);
 			}
 			free(__script_root);
 		}
 	}
 
-	return path;
+	return NULL;
 }
 
 static bool is_top_script(const char *script_path)
-- 
1.7.8.rc0.35.gee6df

