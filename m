Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761239Ab0GTMH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 08:07:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:54417 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758210Ab0GTMHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 08:07:14 -0400
Message-Id: <20100720120709.851214980@ett.arch.suse.de>
User-Agent: quilt/0.47-15.10
Date: Tue, 20 Jul 2010 14:00:55 +0200
From: trenn@suse.de
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, yehuda@hq.newdream.net
Subject: [patch 1/1] Dynamic Debug: Split out query string parsing/setup from proc_write
References: <20100720120054.875277707@ett.arch.suse.de>
Content-Disposition: inline; filename=patches.drivers/dynamic_debug_split_up_query_exec.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parsing and applying of dynamic debug strings is not only useful for
/sys/../dynamic_debug/control write access, but can also be used for
boot parameter parsing.
The boot parameter is introduced in a follow up patch.

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: jbaron@redhat.com
CC: linux-kernel@vger.kernel.org
CC: yehuda@hq.newdream.net

---
 lib/dynamic_debug.c |   40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

Index: linux-2.6.34-master/lib/dynamic_debug.c
===================================================================
--- linux-2.6.34-master.orig/lib/dynamic_debug.c
+++ linux-2.6.34-master/lib/dynamic_debug.c
@@ -429,6 +429,27 @@ static int ddebug_parse_flags(const char
 	return 0;
 }
 
+static int ddebug_exec_query(char *query_string)
+{
+	unsigned int flags = 0, mask = 0;
+	struct ddebug_query query;
+#define MAXWORDS 9
+	int nwords;
+	char *words[MAXWORDS];
+
+	nwords = ddebug_tokenize(query_string, words, MAXWORDS);
+	if (nwords <= 0)
+		return -EINVAL;
+	if (ddebug_parse_query(words, nwords-1, &query))
+		return -EINVAL;
+	if (ddebug_parse_flags(words[nwords-1], &flags, &mask))
+		return -EINVAL;
+
+	/* actually go and implement the change */
+	ddebug_change(&query, flags, mask);
+	return 0;
+}
+
 /*
  * File_ops->write method for <debugfs>/dynamic_debug/conrol.  Gathers the
  * command text from userspace, parses and executes it.
@@ -436,12 +457,8 @@ static int ddebug_parse_flags(const char
 static ssize_t ddebug_proc_write(struct file *file, const char __user *ubuf,
 				  size_t len, loff_t *offp)
 {
-	unsigned int flags = 0, mask = 0;
-	struct ddebug_query query;
-#define MAXWORDS 9
-	int nwords;
-	char *words[MAXWORDS];
 	char tmpbuf[256];
+	int ret;
 
 	if (len == 0)
 		return 0;
@@ -455,16 +472,9 @@ static ssize_t ddebug_proc_write(struct
 		printk(KERN_INFO "%s: read %d bytes from userspace\n",
 			__func__, (int)len);
 
-	nwords = ddebug_tokenize(tmpbuf, words, MAXWORDS);
-	if (nwords <= 0)
-		return -EINVAL;
-	if (ddebug_parse_query(words, nwords-1, &query))
-		return -EINVAL;
-	if (ddebug_parse_flags(words[nwords-1], &flags, &mask))
-		return -EINVAL;
-
-	/* actually go and implement the change */
-	ddebug_change(&query, flags, mask);
+	ret = ddebug_exec_query(tmpbuf);
+	if (ret)
+		return ret;
 
 	*offp += len;
 	return len;

