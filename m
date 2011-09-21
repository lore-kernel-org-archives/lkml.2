Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab1IUV4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:56:15 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:36106 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab1IUV4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:56:08 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: joe@perches.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 09/26] dynamic_debug: process multiple commands on a line
Date: Wed, 21 Sep 2011 15:54:58 -0600
Message-Id: <1316642115-20029-10-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Process multiple commands per line, separated by ';' or '\n'.
All commands are processed, independent of errors, allowing individual
commands to fail, for example when a module is not installed.  Errors
are counted, and last error code is returned.

With this, extensive command sets can be given on the boot-line.

Splitting on '\n' allows "cat cmd-file > /dbg/dynamic_debug/control"
where cmd-file contains multiple queries, one per line.  Empty commands
are skipped, allowing ";\n\n" to not count as errors.

Splitting on '\n' prevents its use in a format-spec, but thats not very
useful anyway, searching for meaningful and selective substrings is typical.

Also allow comment lines, starting with '#', with optional leading whitespace.
Trailing comments are allowed, if preceded by ';' which terminates
the command on the line.  For example:

root@voyage:~# cat debugfs-file

  # blank lines ok, comments too
  module foo +p
  # multiple cmds on line, with ; to separate them
  module bar +p ; module buz +p ; # trailing comments need cmd terminator too

root@voyage:~# cat debugfs-file > /dbg/dynamic_debug/control

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   35 +++++++++++++++++++++++++++++++++--
 1 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index b88f918..4bf27f3 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -444,6 +444,35 @@ static int ddebug_exec_query(char *query_string)
 	return 0;
 }
 
+/* handle multiple queries, continue on error, return last error */
+static int ddebug_exec_queries(char *query)
+{
+	char *split;
+	int i, errs = 0, exitcode = 0, rc;
+
+	for (i = 0; query; query = split) {
+		split = strpbrk(query, ";\n");
+		if (split)
+			*split++ = '\0';
+
+		query = skip_spaces(query);
+		if (!*query || *query == '#')
+			continue;
+		if (verbose)
+			pr_info("query %d: \"%s\"\n", i, query);
+
+		rc = ddebug_exec_query(query);
+		if (rc) {
+			errs++;
+			exitcode = rc;
+		}
+		i++;
+	}
+	pr_info("processed %d queries, with %d errs\n", i, errs);
+
+	return exitcode;
+}
+
 #define PREFIX_SIZE 64
 #define LEFT(wrote) ((PREFIX_SIZE - wrote) > 0) ? (PREFIX_SIZE - wrote) : 0
 
@@ -578,7 +607,7 @@ static ssize_t ddebug_proc_write(struct file *file, const char __user *ubuf,
 	if (verbose)
 		pr_info("read %d bytes from userspace\n", (int)len);
 
-	ret = ddebug_exec_query(tmpbuf);
+	ret = ddebug_exec_queries(tmpbuf);
 	if (ret)
 		return ret;
 
@@ -883,7 +912,9 @@ static int __init dynamic_debug_init(void)
 
 	/* ddebug_query boot param got passed -> set it up */
 	if (ddebug_setup_string[0] != '\0') {
-		ret = ddebug_exec_query(ddebug_setup_string);
+		pr_info("ddebug initializing with string \"%s\"",
+			ddebug_setup_string);
+		ret = ddebug_exec_queries(ddebug_setup_string);
 		if (ret)
 			pr_warn("Invalid ddebug boot param %s",
 				ddebug_setup_string);
-- 
1.7.4.4

