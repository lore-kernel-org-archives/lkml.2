Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab2KMU1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 15:27:48 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55466 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab2KMU1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 15:27:45 -0500
Message-Id: <20121113202738.875148296@openvz.org>
User-Agent: quilt/0.48-1
Date: Wed, 14 Nov 2012 00:20:25 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, oleg@redhat.com,
        rientjes@google.com, Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 2/7] fs, eventfd: Add procfs fdinfo helper
References: <20121113202023.748833257@openvz.org>
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
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Matthew Helsley <matt.helsley@gmail.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
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

