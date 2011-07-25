Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab1GYVnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:43:37 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:40424 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab1GYVn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:43:26 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: bvanassche@acm.org, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 07/25] dynamic_debug: enlarge command/query write buffer
Date: Mon, 25 Jul 2011 15:42:32 -0600
Message-Id: <1311630170-26057-8-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current write buffer is 256 bytes, on stack.  Allocate it off heap,
to fit the size passed by user.   This makes it play nicely with:

 $> cat debug-queries-file > /dbg/dynamic_debug/control

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 2539517..8ce941a 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -555,20 +555,23 @@ __setup("ddebug_query=", ddebug_setup_query);
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
-		return -E2BIG;
-	if (copy_from_user(tmpbuf, ubuf, len))
+	tmpbuf = kmalloc(len, GFP_KERNEL);
+	if (!tmpbuf)
+		return -ENOMEM;
+	if (copy_from_user(tmpbuf, ubuf, len)) {
+		kfree(tmpbuf);
 		return -EFAULT;
+	}
 	tmpbuf[len] = '\0';
 	pr_debug("read %d bytes from userspace\n", (int)len);
 
 	ret = ddebug_exec_queries(tmpbuf);
+	kfree(tmpbuf);
 	if (ret)
 		return ret;
 
-- 
1.7.4.1

