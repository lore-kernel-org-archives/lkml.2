Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab0LGG6D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 01:58:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:53510 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab0LGG6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 01:58:00 -0500
Date: Tue, 7 Dec 2010 06:57:27 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        eranian@google.com, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, eranian@gmail.com, davem@davemloft.net,
        robert.richter@amd.com, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, eranian@gmail.com, davem@davemloft.net,
        robert.richter@amd.com, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4cf92096.17edd80a.1540.5d60@mx.google.com>
References: <4cf92096.17edd80a.1540.5d60@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Fix compiler warning in builtin_script.c:is_top_script()
Message-ID: <tip-965bb6beaf70862d3846e330ea7a14996d82c499@git.kernel.org>
Git-Commit-ID: 965bb6beaf70862d3846e330ea7a14996d82c499
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Dec 2010 06:57:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  965bb6beaf70862d3846e330ea7a14996d82c499
Gitweb:     http://git.kernel.org/tip/965bb6beaf70862d3846e330ea7a14996d82c499
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Fri, 3 Dec 2010 17:52:01 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 6 Dec 2010 12:44:27 -0200

perf script: Fix compiler warning in builtin_script.c:is_top_script()

Fix annoying compiler warning in the is_top_script() function.

The issue was that a const char * was cast into a char * to call
ends_with(). We fix the users of ends_with() instead. Some are passing a
char *, but it is okay to cast the return value of ends_with() to char *
(because we understand what ends_with() does).

Cc: David S. Miller <davem@davemloft.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@gmail.com>
LKML-Reference: <4cf92096.17edd80a.1540.5d60@mx.google.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 683a305..54f1ea8 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -387,10 +387,10 @@ out_delete_desc:
 	return NULL;
 }
 
-static char *ends_with(char *str, const char *suffix)
+static const char *ends_with(const char *str, const char *suffix)
 {
 	size_t suffix_len = strlen(suffix);
-	char *p = str;
+	const char *p = str;
 
 	if (strlen(str) > suffix_len) {
 		p = str + strlen(str) - suffix_len;
@@ -482,7 +482,7 @@ static int list_available_scripts(const struct option *opt __used,
 
 		for_each_script(lang_path, lang_dir, script_dirent, script_next) {
 			script_root = strdup(script_dirent.d_name);
-			str = ends_with(script_root, REPORT_SUFFIX);
+			str = (char *)ends_with(script_root, REPORT_SUFFIX);
 			if (str) {
 				*str = '\0';
 				desc = script_desc__findnew(script_root);
@@ -530,7 +530,7 @@ static char *get_script_path(const char *script_root, const char *suffix)
 
 		for_each_script(lang_path, lang_dir, script_dirent, script_next) {
 			__script_root = strdup(script_dirent.d_name);
-			str = ends_with(__script_root, suffix);
+			str = (char *)ends_with(__script_root, suffix);
 			if (str) {
 				*str = '\0';
 				if (strcmp(__script_root, script_root))
@@ -550,7 +550,7 @@ static char *get_script_path(const char *script_root, const char *suffix)
 
 static bool is_top_script(const char *script_path)
 {
-	return ends_with((char *)script_path, "top") == NULL ? false : true;
+	return ends_with(script_path, "top") == NULL ? false : true;
 }
 
 static int has_required_arg(char *script_path)
