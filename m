Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273Ab1LFKfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:35:51 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:10082
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933154Ab1LFKc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:32:56 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LVS2MS-02-F8K-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 01/10] perf script: Fix mem leaks and NULL pointer checks around strdup()s
Date: Tue, 6 Dec 2011 11:32:31 +0100
Message-ID: <1323167560-2282-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1323167560-2282-1-git-send-email-robert.richter@amd.com>
References: <1323167560-2282-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix mem leaks and missing null pointer checks after strdup().
get_script_path() did not free __script_root in case of continue.

Introducing a helper function get_script_root().

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/builtin-script.c |   48 ++++++++++++++++++++++++++-----------------
 1 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 2f62a29..bcfc00e 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -681,7 +681,8 @@ static int parse_output_fields(const struct option *opt __used,
 			type = PERF_TYPE_RAW;
 		else {
 			fprintf(stderr, "Invalid event type in field string.\n");
-			return -EINVAL;
+			rc = -EINVAL;
+			goto out;
 		}
 
 		if (output[type].user_set)
@@ -923,6 +924,24 @@ static int read_script_info(struct script_desc *desc, const char *filename)
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
@@ -934,7 +953,6 @@ static int list_available_scripts(const struct option *opt __used,
 	struct script_desc *desc;
 	char first_half[BUFSIZ];
 	char *script_root;
-	char *str;
 
 	snprintf(scripts_path, MAXPATHLEN, "%s/scripts", perf_exec_path());
 
@@ -950,16 +968,14 @@ static int list_available_scripts(const struct option *opt __used,
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
 
@@ -981,8 +997,7 @@ static char *get_script_path(const char *script_root, const char *suffix)
 	char script_path[MAXPATHLEN];
 	DIR *scripts_dir, *lang_dir;
 	char lang_path[MAXPATHLEN];
-	char *str, *__script_root;
-	char *path = NULL;
+	char *__script_root;
 
 	snprintf(scripts_path, MAXPATHLEN, "%s/scripts", perf_exec_path());
 
@@ -998,23 +1013,18 @@ static char *get_script_path(const char *script_root, const char *suffix)
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
1.7.7


