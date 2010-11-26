Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab0KZVrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 16:47:40 -0500
Received: from canuck.infradead.org ([134.117.69.58]:57356 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab0KZVrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 16:47:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Andreas Schwab <schwab@linux-m68k.org>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/5] perf trace: Handle DT_UNKNOWN on filesystems that don't support d_type
Date: Fri, 26 Nov 2010 19:47:21 -0200
Message-Id: <1290808041-16535-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1290808041-16535-1-git-send-email-acme@infradead.org>
References: <1290808041-16535-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shawn Bohrer <sbohrer@rgmadvisors.com>

Some filesystems like xfs and reiserfs will return DT_UNKNOWN for the
d_type.  Handle this case by calling stat() to determine the type.

Cc: Andreas Schwab <schwab@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1290355779-3276-1-git-send-email-sbohrer@rgmadvisors.com>
Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
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
1.6.2.5

