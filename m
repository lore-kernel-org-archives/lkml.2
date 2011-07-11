Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab1GKHrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 03:47:21 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33546 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214Ab1GKHrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 03:47:19 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, bvanassche@acm.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 03/21] dynamic_debug: process multiple commands on a line
Date: Mon, 11 Jul 2011 01:46:38 -0600
Message-Id: <1310370416-6322-4-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Process multiple commands per line, separated by ';'.  All commands are
processed, independent of errors, allowing individual commands to fail,
for example when a module is not installed.  Last error code is returned.
With this, extensive command sets can be given on the boot-line.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   30 ++++++++++++++++++++++++++++--
 1 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 1597d5a..ae72402 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -423,6 +423,32 @@ static int ddebug_exec_query(char *query_string)
 	return 0;
 }
 
+/* handle multiple queries, continue on error, return last error */
+static int ddebug_exec_queries(char *query)
+{
+	char *split;
+	int i, errs = 0, exitcode = 0, rc;
+
+	for (i = 0; query; query = split, i++) {
+		split = strchr(query, ';');
+		if (split)
+			*split++ = '\0';
+
+		if (verbose)
+			pr_info("query %d: \"%s\"\n", i, query);
+
+		rc = ddebug_exec_query(query);
+		if (rc) {
+			errs++;
+			exitcode = rc;
+		}
+	}
+	if (verbose)
+		pr_info("processed %d queries, with %d errs\n", i, errs);
+
+	return exitcode;
+}
+
 static int dynamic_emit_prefix(const struct _ddebug *descriptor)
 {
 	char tid[sizeof(int) + sizeof(int)/2 + 4];
@@ -557,7 +583,7 @@ static ssize_t ddebug_proc_write(struct file *file, const char __user *ubuf,
 	if (verbose)
 		pr_info("read %d bytes from userspace\n", (int)len);
 
-	ret = ddebug_exec_query(tmpbuf);
+	ret = ddebug_exec_queries(tmpbuf);
 	if (ret)
 		return ret;
 
@@ -862,7 +888,7 @@ static int __init dynamic_debug_init(void)
 
 	/* ddebug_query boot param got passed -> set it up */
 	if (ddebug_setup_string[0] != '\0') {
-		ret = ddebug_exec_query(ddebug_setup_string);
+		ret = ddebug_exec_queries(ddebug_setup_string);
 		if (ret)
 			pr_warn("Invalid ddebug boot param %s",
 				ddebug_setup_string);
-- 
1.7.4.1

