Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab2GYJ5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 05:57:10 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62054 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab2GYJzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 05:55:41 -0400
Message-Id: <20120725095025.013094662@openvz.org>
User-Agent: quilt/0.48-1
Date: Wed, 25 Jul 2012 13:47:23 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 5/7] fs, epoll: Add procfs fdinfo helper v2
References: <20120725094718.089879534@openvz.org>
Content-Disposition: inline; filename=seq-fdinfo-eventpoll-5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allow us to print out eventpoll target file descriptor,
events and data, the /proc/pid/fdinfo/fd consists of

 | pos:	0
 | flags:	02
 | tfd:        5 events:       1d data: ffffffffffffffff

This feature is CONFIG_CHECKPOINT_RESTORE only.

v2:
 - don't walk over all rb nodes on seq-next,
   try to continue from pervious position

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: James Bottomley <jbottomley@parallels.com>
CC: Matthew Helsley <matt.helsley@gmail.com>
---
 fs/eventpoll.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

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
@@ -1897,6 +1899,69 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 	return error;
 }
 
+#if defined(CONFIG_PROC_FS) && defined(CONFIG_CHECKPOINT_RESTORE)
+
+static void *seq_start(struct seq_file *m, loff_t *pos)
+{
+	struct proc_fdinfo_extra *extra = m->private;
+	struct eventpoll *ep = extra->f_file->private_data;
+	struct rb_node *rbp;
+	loff_t num = *pos;
+
+	mutex_lock(&ep->mtx);
+	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
+		if (num-- == 0)
+			return rbp;
+	}
+
+	return NULL;
+}
+
+static void seq_stop(struct seq_file *m, void *v)
+{
+	struct proc_fdinfo_extra *extra = m->private;
+	struct eventpoll *ep = extra->f_file->private_data;
+	mutex_unlock(&ep->mtx);
+}
+
+static void *seq_next(struct seq_file *m, void *p, loff_t *pos)
+{
+	struct rb_node *rbp = p;
+	++*pos;
+	return (void *)rb_next(rbp);
+}
+
+static int seq_show(struct seq_file *m, void *v)
+{
+	struct rb_node *rbp = v;
+	struct epitem *epi = rb_entry(rbp, struct epitem, rbn);
+
+	return seq_printf(m, "tfd: %8d events: %8x data: %16llx\n",
+			  epi->ffd.fd, epi->event.events,
+			  (long long)epi->event.data);
+}
+
+static const struct seq_operations ep_fdinfo_ops = {
+	.start		= seq_start,
+	.next		= seq_next,
+	.stop		= seq_stop,
+	.show		= seq_show,
+};
+
+static struct proc_fdinfo_driver ep_fdinfo = {
+	.name		= "eventpoll",
+	.ops		= &ep_fdinfo_ops,
+	.probe		= is_file_epoll,
+};
+
+static int __init ep_register_fdinfo_driver(void)
+{
+	return proc_register_fdinfo_driver(&ep_fdinfo);
+}
+#else
+static void ep_register_fdinfo_driver(void) { }
+#endif /* CONFIG_PROC_FS && CONFIG_CHECKPOINT_RESTORE */
+
 static int __init eventpoll_init(void)
 {
 	struct sysinfo si;
@@ -1929,6 +1994,8 @@ static int __init eventpoll_init(void)
 	pwq_cache = kmem_cache_create("eventpoll_pwq",
 			sizeof(struct eppoll_entry), 0, SLAB_PANIC, NULL);
 
+	ep_register_fdinfo_driver();
+
 	return 0;
 }
 fs_initcall(eventpoll_init);

