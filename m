Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab1GYVnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:43:33 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:46811 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab1GYVnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:43:24 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: bvanassche@acm.org, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 06/25] dynamic_debug: process multiple commands on a line
Date: Mon, 25 Jul 2011 15:42:31 -0600
Message-Id: <1311630170-26057-7-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

  # blank lines ok
  module dynamic_debug +p		; # turn on self-debugging
  # these are quite noisy when grepping
  # $DEBUGFS/dynamic_debug/{control,pending}
    # silence them (also, leading spaces allowed in comments)
  func ddebug_proc_show -p
  func ddebug_proc_next -p	; # trailing comments need cmd terminator
  func pending_proc_show -p	; # TB added later.  gives error, harmless.
  func pending_proc_next -p

root@voyage:~# cat debugfs-file > /dbg/dynamic_debug/control
split into words: "module" "dynamic_debug" "+p"
changed $srcpath/lib/dynamic_debug.c:223 [dynamic_debug]ddebug_change =p
changed $srcpath/lib/dynamic_debug.c:576 [dynamic_debug]ddebug_save_pending =p
...
nfound 23 on func="" file="" module="dynamic_debug" format="" lineno=0-0
query 1: "func ddebug_proc_show -p	"
split into words: "func" "ddebug_proc_show" "-p"
parsed func="ddebug_proc_show" file="" module="" format="" lineno=0-0
filter=0x0 op='-' flags=0x1 *flagsp=0x0 *maskp=0xfffffffe
changed $srcpath/lib/dynamic_debug.c:881 [dynamic_debug]ddebug_proc_show =_
nfound 1 on func="ddebug_proc_show" file="" module="" format="" lineno=0-0
query 2: "func ddebug_proc_next -p"
...

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   32 ++++++++++++++++++++++++++++++--
 1 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 76f80dc..2539517 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -418,6 +418,34 @@ static int ddebug_exec_query(char *query_string)
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
+		pr_debug("query %d: \"%s\"\n", i, query);
+
+		rc = ddebug_exec_query(query);
+		if (rc) {
+			errs++;
+			exitcode = rc;
+		}
+		i++;
+	}
+	pr_debug("processed %d queries, with %d errs\n", i, errs);
+
+	return exitcode;
+}
+
 #define PREFIX_SIZE 64
 #define LEFT(wrote) ((PREFIX_SIZE - wrote) > 0) ? (PREFIX_SIZE - wrote) : 0
 
@@ -540,7 +568,7 @@ static ssize_t ddebug_proc_write(struct file *file, const char __user *ubuf,
 	tmpbuf[len] = '\0';
 	pr_debug("read %d bytes from userspace\n", (int)len);
 
-	ret = ddebug_exec_query(tmpbuf);
+	ret = ddebug_exec_queries(tmpbuf);
 	if (ret)
 		return ret;
 
@@ -845,7 +873,7 @@ static int __init dynamic_debug_init(void)
 	if (ddebug_setup_string[0] != '\0') {
 		pr_info("ddebug initializing with string \"%s\"",
 			ddebug_setup_string);
-		ret = ddebug_exec_query(ddebug_setup_string);
+		ret = ddebug_exec_queries(ddebug_setup_string);
 		if (ret)
 			pr_warn("invalid ddebug_query\n");
 	}
-- 
1.7.4.1

