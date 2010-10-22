Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab0JVScj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:32:39 -0400
Received: from kroah.org ([198.145.64.141]:37750 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758889Ab0JVSZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:18 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Renninger <trenn@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/31] Dynamic Debug: Split out query string parsing/setup from proc_write
Date: Fri, 22 Oct 2010 11:24:46 -0700
Message-Id: <1287771916-15016-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Renninger <trenn@suse.de>

The parsing and applying of dynamic debug strings is not only useful for
/sys/../dynamic_debug/control write access, but can also be used for
boot parameter parsing.
The boot parameter is introduced in a follow up patch.

Signed-off-by: Thomas Renninger <trenn@suse.de>
Acked-by: jbaron@redhat.com
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/dynamic_debug.c |   40 +++++++++++++++++++++++++---------------
 1 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 02afc25..84d103c4 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -429,6 +429,27 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
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
@@ -436,12 +457,8 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
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
@@ -455,16 +472,9 @@ static ssize_t ddebug_proc_write(struct file *file, const char __user *ubuf,
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
-- 
1.7.2

