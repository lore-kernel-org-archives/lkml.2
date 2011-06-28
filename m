Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab1F1HLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 03:11:48 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32877 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756695Ab1F1HKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 03:10:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OAlj47PfPB0PUdrQJEtw9+kqjOHhqko5Hif3SxngGuYeahq6e1mQxmFC91iTHQn5Ot
         eaipUAo16Nintf7J56CJ7HLixkcewR/Ob+T6jlV+ivnu3J5EHPMegm2uvTDXm/2THV5i
         IBGYWlFhX3j2GwEmV4zyN4V6VvhHhnskILKBQ=
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gnb@fmeh.org, jbaron@redhat.com, bvanassche@acm.org, gregkh@suse.de,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 03/11] dynamic_debug: process multiple commands on a line
Date: Tue, 28 Jun 2011 01:09:44 -0600
Message-Id: <1309244992-2305-4-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Process multiple commands per line, separated by ';'.  All commands are
processed, independent of errors, allowing individual commands to fail,
for example when a module is not installed.  Last error code is returned.
With this, extensive command sets can be given on the boot-line.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 Documentation/dynamic-debug-howto.txt |   14 ++++++++++-
 lib/dynamic_debug.c                   |   39 +++++++++++++++++++++++++++++++-
 2 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
index f959909..d0faf98 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -92,8 +92,18 @@ nullarbor:~ # echo -c 'file svcsock.c\nline 1603 +p' >
 nullarbor:~ # echo -n 'file svcsock.c line 1603 +p' >
 				<debugfs>/dynamic_debug/control
 
-Commands are bounded by a write() system call.  If you want to do
-multiple commands you need to do a separate "echo" for each, like:
+Commands are bounded by a write() system call.  Subject to this limit
+(or 1024 for boot-line parameter) you can send multiple commands,
+separated by ';'
+
+foo:~ # echo "module nsc_gpio +p ; module pc8736x_gpio +p ; " \
+ "module scx200_gpio +p " > /dbg/dynamic_debug/control
+
+Multiple commands are processed independently, this allows you to send
+commands which may fail, for example if a module is not present.  The
+last failing command returns its error.
+
+Or you can do an "echo" for each, like:
 
 nullarbor:~ # echo 'file svcsock.c line 1603 +p' > /proc/dprintk ;\
 > echo 'file svcsock.c line 1563 +p' > /proc/dprintk
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index eb08a2f..0e567ad 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -428,6 +428,41 @@ static int ddebug_exec_query(char *query_string)
 	return 0;
 }
 
+/* handle multiple queries, continue on error, return last error */
+static int ddebug_exec_queries(char *query)
+{
+	char *split = query;
+	int i, errs = 0, exitcode = 0, rc;
+
+	if (verbose)
+		/* clean up for logging */
+		for (; (split = strpbrk(split, "\t\n")); split++)
+			*split = ' ';
+
+	for (i = 0; query; query = split, i++) {
+
+		split = strchr(query, ';');
+		if (split)
+			*split++ = '\0';
+
+		if (verbose)
+			printk(KERN_INFO "%s: query %d: \"%s\"",
+				__func__, i, query);
+
+		rc = ddebug_exec_query(query);
+		if (rc) {
+			errs++;
+			exitcode = rc;
+		}
+	}
+	if (verbose)
+		printk(KERN_INFO
+			"%s: processed %d queries, with %d errs",
+			__func__, i, errs);
+
+	return exitcode;
+}
+
 int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
 {
 	va_list args;
@@ -492,7 +527,7 @@ static ssize_t ddebug_proc_write(struct file *file, const char __user *ubuf,
 		printk(KERN_INFO "%s: read %d bytes from userspace\n",
 			__func__, (int)len);
 
-	ret = ddebug_exec_query(tmpbuf);
+	ret = ddebug_exec_queries(tmpbuf);
 	if (ret)
 		return ret;
 
@@ -804,7 +839,7 @@ static int __init dynamic_debug_init(void)
 
 	/* ddebug_query boot param got passed -> set it up */
 	if (ddebug_setup_string[0] != '\0') {
-		ret = ddebug_exec_query(ddebug_setup_string);
+		ret = ddebug_exec_queries(ddebug_setup_string);
 		if (ret)
 			pr_warning("Invalid ddebug boot param %s",
 				   ddebug_setup_string);
-- 
1.7.4.1

