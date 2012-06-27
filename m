Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab2F0LFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 07:05:55 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65019 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453Ab2F0LFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 07:05:20 -0400
Message-Id: <20120627110512.734751587@openvz.org>
User-Agent: quilt/0.48-1
Date: Wed, 27 Jun 2012 15:01:21 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>
Subject: [rfc 5/7] fs, epoll: Add procfs fdinfo helper
References: <20120627110116.201735815@openvz.org>
Content-Disposition: inline; filename=seq-fdinfo-eventpoll-4
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
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: James Bottomley <jbottomley@parallels.com>
---
 fs/eventpoll.c |   81 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

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
@@ -1897,6 +1899,83 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 	return error;
 }
 
+#if defined(CONFIG_PROC_FS) && defined(CONFIG_CHECKPOINT_RESTORE)
+
+struct epitem_fdinfo {
+	struct epoll_event	ev;
+	int			fd;
+};
+
+static struct epitem_fdinfo *
+seq_lookup_fdinfo(struct proc_fdinfo_extra *extra, struct eventpoll *ep, loff_t num)
+{
+	struct epitem_fdinfo *fdinfo = extra->priv;
+	struct epitem *epi = NULL;
+	struct rb_node *rbp;
+
+	mutex_lock(&ep->mtx);
+	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
+		if (num-- == 0) {
+			epi = rb_entry(rbp, struct epitem, rbn);
+			fdinfo->fd = epi->ffd.fd;
+			fdinfo->ev = epi->event;
+			break;
+		}
+	}
+	mutex_unlock(&ep->mtx);
+
+	return epi ? fdinfo : NULL;
+}
+
+static void *seq_start(struct seq_file *m, loff_t *pos)
+{
+	struct proc_fdinfo_extra *extra = m->private;
+	struct eventpoll *ep = extra->f_file->private_data;
+
+	return seq_lookup_fdinfo(extra, ep, *pos);
+}
+
+static void seq_stop(struct seq_file *m, void *v) { }
+
+static void *seq_next(struct seq_file *m, void *p, loff_t *pos)
+{
+	struct proc_fdinfo_extra *extra = m->private;
+	struct eventpoll *ep = extra->f_file->private_data;
+	++*pos;
+	return (void *)seq_lookup_fdinfo(extra, ep, *pos);
+}
+
+static int seq_show(struct seq_file *m, void *v)
+{
+	struct epitem_fdinfo *fdinfo = v;
+	seq_printf(m, "tfd: %8d events: %8x data: %16llx\n",
+		   fdinfo->fd, fdinfo->ev.events,
+		   (long long)fdinfo->ev.data);
+	return 0;
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
+	.priv_size	= sizeof(struct epitem_fdinfo),
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
@@ -1929,6 +2008,8 @@ static int __init eventpoll_init(void)
 	pwq_cache = kmem_cache_create("eventpoll_pwq",
 			sizeof(struct eppoll_entry), 0, SLAB_PANIC, NULL);
 
+	ep_register_fdinfo_driver();
+
 	return 0;
 }
 fs_initcall(eventpoll_init);

