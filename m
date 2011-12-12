Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab1LLRek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:34:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40433 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab1LLRei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:34:38 -0500
Date: Mon, 12 Dec 2011 09:34:07 -0800
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-38efb539c13f8f173e381435cdd40463ab5d38de@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, robert.richter@amd.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1322217520-3287-1-git-send-email-robert.richter@amd.com>
References: <1322217520-3287-1-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Fix mem leaks and NULL pointer checks around strdup()s
Git-Commit-ID: 38efb539c13f8f173e381435cdd40463ab5d38de
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 12 Dec 2011 09:34:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  38efb539c13f8f173e381435cdd40463ab5d38de
Gitweb:     http://git.kernel.org/tip/38efb539c13f8f173e381435cdd40463ab5d38de
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Fri, 25 Nov 2011 11:38:40 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 12 Dec 2011 08:44:00 -0200

perf script: Fix mem leaks and NULL pointer checks around strdup()s

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
