Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab1LSWNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 17:13:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877Ab1LSWNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 17:13:12 -0500
Date: Mon, 19 Dec 2011 17:13:07 -0500
From: Jason Baron <jbaron@redhat.com>
To: greg@kroah.com
Cc: jim.cromie@gmail.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org
Message-Id: <f81023a9a96efb709e4679d955dcb19360680ec5.1324318997.git.jbaron@redhat.com>
In-Reply-To: <cover.1324318997.git.jbaron@redhat.com>
References: <cover.1324318997.git.jbaron@redhat.com>
Subject: [PATCH 13/16] dynamic_debug: enlarge command/query write buffer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Current query write buffer is 256 bytes, on stack.  In comparison, the
ddebug_query boot-arg is 1024.  Allocate the buffer off heap, and
enlarge it to 4096 bytes, big enough for ~100 queries (at 40 bytes
each), and error out if not.  This makes it play nicely with large
query sets (to be added later).  The buffer should be enough for most
uses, and others should probably be split into subsets.

[jbaron@redhat.com: changed USER_BUF_PAGE from 4095 -> 4096 ]
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 lib/dynamic_debug.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 86a9abb..d8773dc 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -570,24 +570,32 @@ __setup("ddebug_query=", ddebug_setup_query);
  * File_ops->write method for <debugfs>/dynamic_debug/conrol.  Gathers the
  * command text from userspace, parses and executes it.
  */
+#define USER_BUF_PAGE 4096
 static ssize_t ddebug_proc_write(struct file *file, const char __user *ubuf,
 				  size_t len, loff_t *offp)
 {
-	char tmpbuf[256];
+	char *tmpbuf;
 	int ret;
 
 	if (len == 0)
 		return 0;
-	/* we don't check *offp -- multiple writes() are allowed */
-	if (len > sizeof(tmpbuf)-1)
+	if (len > USER_BUF_PAGE - 1) {
+		pr_warn("expected <%d bytes into control\n", USER_BUF_PAGE);
 		return -E2BIG;
-	if (copy_from_user(tmpbuf, ubuf, len))
+	}
+	tmpbuf = kmalloc(len + 1, GFP_KERNEL);
+	if (!tmpbuf)
+		return -ENOMEM;
+	if (copy_from_user(tmpbuf, ubuf, len)) {
+		kfree(tmpbuf);
 		return -EFAULT;
+	}
 	tmpbuf[len] = '\0';
 	if (verbose)
 		pr_info("read %d bytes from userspace\n", (int)len);
 
 	ret = ddebug_exec_query(tmpbuf);
+	kfree(tmpbuf);
 	if (ret)
 		return ret;
 
-- 
1.7.7.3

