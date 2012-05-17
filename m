Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964787Ab2EQQZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:25:45 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44579 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760514Ab2EQQZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:25:39 -0400
Message-Id: <20120517162534.840623571@openvz.org>
User-Agent: quilt/0.48-1
Date: Thu, 17 May 2012 20:07:42 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        linux-fsdevel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [rfc 4/4] fs, epoll: Add procfs fdinfo helper
References: <20120517160738.116113099@openvz.org>
Content-Disposition: inline; filename=seq-fdinfo-eventpoll-2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allow us to print out eventpoll target file descriptor,
events and data, so the /proc/pid/fdinfo/fd consists of

 | pos:	0
 | flags:	02
 | tfd:        5 events:       1d data: ffffffffffffffff

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 fs/eventpoll.c |   82 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

Index: linux-2.6.git/fs/eventpoll.c
===================================================================
--- linux-2.6.git.orig/fs/eventpoll.c
+++ linux-2.6.git/fs/eventpoll.c
@@ -37,6 +37,8 @@
 #include <asm/io.h>
 #include <asm/mman.h>
 #include <linux/atomic.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 
 /*
  * LOCKING:
@@ -1815,6 +1817,84 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 
 #endif /* HAVE_SET_RESTORE_SIGMASK */
 
+#ifdef CONFIG_PROC_FS
+
+#define FDINFO_SEQ_UNLOCKED	(void *)(0L)
+#define FDINFO_SEQ_LOCKED	(void *)(1L)
+
+static struct epitem *
+seq_lookup_epi(struct proc_fdinfo_extra *extra, struct eventpoll *ep, loff_t num)
+{
+	struct rb_node *rbp;
+
+	if (extra->private == FDINFO_SEQ_UNLOCKED) {
+		mutex_lock(&ep->mtx);
+		extra->private = FDINFO_SEQ_LOCKED;
+	}
+
+	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
+		if (num-- == 0)
+			return rb_entry(rbp, struct epitem, rbn);
+	}
+
+	return NULL;
+}
+
+static void *seq_start(struct seq_file *m, loff_t *pos)
+{
+	struct proc_fdinfo_extra *extra = m->private;
+	struct eventpoll *ep = extra->fd_file->private_data;
+
+	return *pos ? seq_lookup_epi(extra, ep, *pos - 1) : NULL;
+}
+
+static void seq_stop(struct seq_file *m, void *v)
+{
+	struct proc_fdinfo_extra *extra = m->private;
+	struct eventpoll *ep = extra->fd_file->private_data;
+
+	if (extra->private == FDINFO_SEQ_LOCKED)
+		mutex_unlock(&ep->mtx);
+	extra->private = FDINFO_SEQ_UNLOCKED;
+}
+
+static void *seq_next(struct seq_file *m, void *p, loff_t *pos)
+{
+	struct proc_fdinfo_extra *extra = m->private;
+	struct eventpoll *ep = extra->fd_file->private_data;
+	++*pos;
+	return (void *)seq_lookup_epi(extra, ep, *pos - 1);
+}
+
+static int seq_show(struct seq_file *m, void *v)
+{
+	struct epitem *epi = v;
+	seq_printf(m, "tfd: %8d events: %8x data: %16llx\n",
+		   epi->ffd.fd, epi->event.events, (long long)epi->event.data);
+	return 0;
+}
+
+static const struct seq_operations ep_fdinfo_ops = {
+	.start	= seq_start,
+	.next	= seq_next,
+	.stop	= seq_stop,
+	.show	= seq_show,
+};
+
+static struct proc_fdinfo_helper ep_fdinfo_helper = {
+	.name	= "epoll",
+	.ops	= &ep_fdinfo_ops,
+	.probe	= is_file_epoll,
+};
+
+static int __init ep_register_fdinfo_helper(void)
+{
+	return proc_register_fdinfo_helper(&ep_fdinfo_helper);
+}
+#else
+static void ep_register_fdinfo_helper(void) { }
+#endif /* CONFIG_PROC_FS */
+
 static int __init eventpoll_init(void)
 {
 	struct sysinfo si;
@@ -1847,6 +1927,8 @@ static int __init eventpoll_init(void)
 	pwq_cache = kmem_cache_create("eventpoll_pwq",
 			sizeof(struct eppoll_entry), 0, SLAB_PANIC, NULL);
 
+	ep_register_fdinfo_helper();
+
 	return 0;
 }
 fs_initcall(eventpoll_init);

