Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab0KUQKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 11:10:21 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:59039 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753416Ab0KUQKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 11:10:20 -0500
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Andreas Schwab <schwab@linux-m68k.org>,
        Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: [PATCH v2] perf: Handle DT_UNKNOWN on filesystems that don't support d_type
Date: Sun, 21 Nov 2010 10:09:39 -0600
Message-Id: <1290355779-3276-1-git-send-email-sbohrer@rgmadvisors.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20101121155433.GB2527@BohrerMBP>
References: <20101121155433.GB2527@BohrerMBP>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some filesystems like xfs and reiserfs will return DT_UNKNOWN for the
d_type.  Handle this case by calling stat() to determine the type.

Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
---

Cleaned up the boolean logic from Andreas Schwab's review.

 tools/perf/builtin-trace.c |   33 +++++++++++++++++++++++++--------
 1 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 86cfe38..4783ed8 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -301,17 +301,34 @@ static int parse_scriptname(const struct option *opt __used,
 	return 0;
 }
 
-#define for_each_lang(scripts_dir, lang_dirent, lang_next)		\
+/* Helper function for filesystems that return a dent->d_type DT_UNKNOWN */
+static int is_directory(const char *base_path, const struct dirent *dent)
+{
+	char path[PATH_MAX];
+	struct stat st;
+
+	sprintf(path, "%s/%s", base_path, dent->d_name);
+	if (stat(path, &st))
+		return 0;
+
+	return S_ISDIR(st.st_mode);
+}
+
+#define for_each_lang(scripts_path, scripts_dir, lang_dirent, lang_next)\
 	while (!readdir_r(scripts_dir, &lang_dirent, &lang_next) &&	\
 	       lang_next)						\
-		if (lang_dirent.d_type == DT_DIR &&			\
+		if ((lang_dirent.d_type == DT_DIR ||			\
+		     (lang_dirent.d_type == DT_UNKNOWN &&		\
+		      is_directory(scripts_path, &lang_dirent))) &&	\
 		    (strcmp(lang_dirent.d_name, ".")) &&		\
 		    (strcmp(lang_dirent.d_name, "..")))
 
-#define for_each_script(lang_dir, script_dirent, script_next)		\
+#define for_each_script(lang_path, lang_dir, script_dirent, script_next)\
 	while (!readdir_r(lang_dir, &script_dirent, &script_next) &&	\
 	       script_next)						\
-		if (script_dirent.d_type != DT_DIR)
+		if (script_dirent.d_type != DT_DIR &&			\
+		    (script_dirent.d_type != DT_UNKNOWN ||		\
+		     !is_directory(lang_path, &script_dirent)))
 
 
 #define RECORD_SUFFIX			"-record"
@@ -466,14 +483,14 @@ static int list_available_scripts(const struct option *opt __used,
 	if (!scripts_dir)
 		return -1;
 
-	for_each_lang(scripts_dir, lang_dirent, lang_next) {
+	for_each_lang(scripts_path, scripts_dir, lang_dirent, lang_next) {
 		snprintf(lang_path, MAXPATHLEN, "%s/%s/bin", scripts_path,
 			 lang_dirent.d_name);
 		lang_dir = opendir(lang_path);
 		if (!lang_dir)
 			continue;
 
-		for_each_script(lang_dir, script_dirent, script_next) {
+		for_each_script(lang_path, lang_dir, script_dirent, script_next) {
 			script_root = strdup(script_dirent.d_name);
 			str = ends_with(script_root, REPORT_SUFFIX);
 			if (str) {
@@ -514,14 +531,14 @@ static char *get_script_path(const char *script_root, const char *suffix)
 	if (!scripts_dir)
 		return NULL;
 
-	for_each_lang(scripts_dir, lang_dirent, lang_next) {
+	for_each_lang(scripts_path, scripts_dir, lang_dirent, lang_next) {
 		snprintf(lang_path, MAXPATHLEN, "%s/%s/bin", scripts_path,
 			 lang_dirent.d_name);
 		lang_dir = opendir(lang_path);
 		if (!lang_dir)
 			continue;
 
-		for_each_script(lang_dir, script_dirent, script_next) {
+		for_each_script(lang_path, lang_dir, script_dirent, script_next) {
 			__script_root = strdup(script_dirent.d_name);
 			str = ends_with(__script_root, suffix);
 			if (str) {
-- 
1.7.2.3

