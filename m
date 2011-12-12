Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab1LLXRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:17:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42879 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab1LLXNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:13:30 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 14/25] dynamic_debug: enlarge command/query write buffer
Date: Mon, 12 Dec 2011 16:12:40 -0700
Message-Id: <1323731569-20644-14-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323731569-20644-1-git-send-email-jim.cromie@gmail.com>
References: <1323731569-20644-1-git-send-email-jim.cromie@gmail.com>
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

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index d285bb5..6e5b9a3 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -570,24 +570,32 @@ __setup("ddebug_query=", ddebug_setup_query);
  * File_ops->write method for <debugfs>/dynamic_debug/conrol.  Gathers the
  * command text from userspace, parses and executes it.
  */
+#define USER_BUF_PAGE 4095
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

