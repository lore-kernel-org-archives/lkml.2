Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab0K1Ifi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 03:35:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:57127 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab0K1Ifg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 03:35:36 -0500
Date: Sun, 28 Nov 2010 08:34:59 GMT
From: tip-bot for Shawn Bohrer <sbohrer@rgmadvisors.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        sbohrer@rgmadvisors.com, tglx@linutronix.de, schwab@linux-m68k.org,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        sbohrer@rgmadvisors.com, tglx@linutronix.de, schwab@linux-m68k.org,
        mingo@elte.hu
In-Reply-To: <1290355779-3276-1-git-send-email-sbohrer@rgmadvisors.com>
References: <1290355779-3276-1-git-send-email-sbohrer@rgmadvisors.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Handle DT_UNKNOWN on filesystems that don't support d_type
Message-ID: <tip-008f29d3865828bb27e35d6d3fa889d0853b469f@git.kernel.org>
Git-Commit-ID: 008f29d3865828bb27e35d6d3fa889d0853b469f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 28 Nov 2010 08:35:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  008f29d3865828bb27e35d6d3fa889d0853b469f
Gitweb:     http://git.kernel.org/tip/008f29d3865828bb27e35d6d3fa889d0853b469f
Author:     Shawn Bohrer <sbohrer@rgmadvisors.com>
AuthorDate: Sun, 21 Nov 2010 10:09:39 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 27 Nov 2010 01:33:04 -0200

perf trace: Handle DT_UNKNOWN on filesystems that don't support d_type

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
