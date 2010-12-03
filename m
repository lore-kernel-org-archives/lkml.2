Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab0LCQyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 11:54:11 -0500
Received: from smtp-out.google.com ([216.239.44.51]:45011 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab0LCQyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 11:54:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=e8UN9KwfhbQ1CeX0GMfaZmavj0r6qJS9VHciyX1pITaYvAa513kW7cFAdJQ8LpQiFk
         8ru8ylM0xVS1ZkL5w+5A==
Message-ID: <4cf92096.17edd80a.1540.5d60@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Fri, 3 Dec 2010 17:52:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, acme@redhat.com
Subject: [PATCH] perf: fix compiler warning in builtin_script.c:is_top_script()
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix annoying compiler warning in the is_top_script() function.
The issue was that a const char * was cast into a char * to call
ends_with(). We fix the users of ends_with() instead. Some are
passing a char *, but it is okay to cast the return value of
ends_with() to char * (because we understand what ends_with() does).

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 4539551..77983e8 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -397,10 +397,10 @@ out_delete_desc:
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
@@ -492,7 +492,7 @@ static int list_available_scripts(const struct option *opt __used,
 
 		for_each_script(lang_path, lang_dir, script_dirent, script_next) {
 			script_root = strdup(script_dirent.d_name);
-			str = ends_with(script_root, REPORT_SUFFIX);
+			str = (char *)ends_with(script_root, REPORT_SUFFIX);
 			if (str) {
 				*str = '\0';
 				desc = script_desc__findnew(script_root);
@@ -540,7 +540,7 @@ static char *get_script_path(const char *script_root, const char *suffix)
 
 		for_each_script(lang_path, lang_dir, script_dirent, script_next) {
 			__script_root = strdup(script_dirent.d_name);
-			str = ends_with(__script_root, suffix);
+			str = (char *)ends_with(__script_root, suffix);
 			if (str) {
 				*str = '\0';
 				if (strcmp(__script_root, script_root))
@@ -560,7 +560,7 @@ static char *get_script_path(const char *script_root, const char *suffix)
 
 static bool is_top_script(const char *script_path)
 {
-	return ends_with((char *)script_path, "top") == NULL ? false : true;
+	return ends_with(script_path, "top") == NULL ? false : true;
 }
 
 static int has_required_arg(char *script_path)
