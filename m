Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030369Ab2HPQiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:38:16 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52781 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030226Ab2HPQhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:37:40 -0400
Message-Id: <20120816163734.576898891@openvz.org>
User-Agent: quilt/0.48-1
Date: Thu, 16 Aug 2012 20:34:13 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 5/7] fs, eventfd: Add procfs fdinfo helper
References: <20120816163408.625246843@openvz.org>
Content-Disposition: inline; filename=seq-fdinfo-eventfd-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allow us to print out raw counter value.
The /proc/pid/fdinfo/fd output is

 | pos:	0
 | flags:	04002
 | eventfd-count:               5a

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: James Bottomley <jbottomley@parallels.com>
---
 fs/eventfd.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

Index: linux-2.6.git/fs/eventfd.c
===================================================================
--- linux-2.6.git.orig/fs/eventfd.c
+++ linux-2.6.git/fs/eventfd.c
@@ -19,6 +19,8 @@
 #include <linux/export.h>
 #include <linux/kref.h>
 #include <linux/eventfd.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 
 struct eventfd_ctx {
 	struct kref kref;
@@ -284,7 +286,25 @@ static ssize_t eventfd_write(struct file
 	return res;
 }
 
+#ifdef CONFIG_PROC_FS
+static int eventfd_show_fdinfo(struct seq_file *m, struct file *f)
+{
+	struct eventfd_ctx *ctx = f->private_data;
+	int ret;
+
+	spin_lock_irq(&ctx->wqh.lock);
+	ret = seq_printf(m, "eventfd-count: %16llx\n",
+			 (unsigned long long)ctx->count);
+	spin_unlock_irq(&ctx->wqh.lock);
+
+	return ret;
+}
+#endif
+
 static const struct file_operations eventfd_fops = {
+#ifdef CONFIG_PROC_FS
+	.show_fdinfo	= eventfd_show_fdinfo,
+#endif
 	.release	= eventfd_release,
 	.poll		= eventfd_poll,
 	.read		= eventfd_read,

