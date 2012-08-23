Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030400Ab2HWKsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:48:06 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60319 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933893Ab2HWKrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:47:32 -0400
Message-Id: <20120823104726.160536958@openvz.org>
User-Agent: quilt/0.48-1
Date: Thu, 23 Aug 2012 14:43:31 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 8/9] fs, epoll: Add procfs fdinfo helper v2
References: <20120823104323.040550004@openvz.org>
Content-Disposition: inline; filename=seq-fdinfo-eventpoll-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allow us to print out eventpoll target file descriptor,
events and data, the /proc/pid/fdinfo/fd consists of

 | pos:	0
 | flags:	02
 | tfd:        5 events:       1d data: ffffffffffffffff

This feature is CONFIG_CHECKPOINT_RESTORE only.

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
 fs/eventpoll.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

Index: linux-2.6.git/fs/eventpoll.c
===================================================================
--- linux-2.6.git.orig/fs/eventpoll.c
+++ linux-2.6.git/fs/eventpoll.c
@@ -38,6 +38,8 @@
 #include <asm/io.h>
 #include <asm/mman.h>
 #include <linux/atomic.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 
 /*
  * LOCKING:
@@ -783,8 +785,34 @@ static unsigned int ep_eventpoll_poll(st
 	return pollflags != -1 ? pollflags : 0;
 }
 
+#ifdef CONFIG_PROC_FS
+static int ep_show_fdinfo(struct seq_file *m, struct file *f)
+{
+	struct eventpoll *ep = f->private_data;
+	struct rb_node *rbp;
+	int ret;
+
+	mutex_lock(&ep->mtx);
+	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
+		struct epitem *epi = rb_entry(rbp, struct epitem, rbn);
+
+		ret = seq_printf(m, "tfd: %8d events: %8x data: %16llx\n",
+				 epi->ffd.fd, epi->event.events,
+				 (long long)epi->event.data);
+		if (ret)
+			break;
+	}
+	mutex_unlock(&ep->mtx);
+
+	return ret;
+}
+#endif
+
 /* File callbacks that implement the eventpoll file behaviour */
 static const struct file_operations eventpoll_fops = {
+#ifdef CONFIG_PROC_FS
+	.show_fdinfo	= ep_show_fdinfo,
+#endif
 	.release	= ep_eventpoll_release,
 	.poll		= ep_eventpoll_poll,
 	.llseek		= noop_llseek,

