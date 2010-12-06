Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab0LFU2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:28:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:58311 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab0LFU2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:28:32 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/5] perf script: Fix compiler warning in builtin_script.c:is_top_script()
Date: Mon,  6 Dec 2010 18:28:17 -0200
Message-Id: <1291667298-7238-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291667298-7238-1-git-send-email-acme@infradead.org>
References: <1291667298-7238-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

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
-- 
1.6.2.5

