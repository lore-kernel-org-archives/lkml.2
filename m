Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab2HPQjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:39:00 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37256 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030220Ab2HPQhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:37:39 -0400
Message-Id: <20120816163734.415731995@openvz.org>
User-Agent: quilt/0.48-1
Date: Thu, 16 Aug 2012 20:34:11 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 3/7] procfs: Add ability to plug in auxiliary fdinfo providers
References: <20120816163408.625246843@openvz.org>
Content-Disposition: inline; filename=seq-fdinfo-seq-ops-helpers-11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch brings ability to print out auxiliary data associated
with file in procfs interface /proc/pid/fdinfo/fd.

In particular further patches make eventfd, evenpoll, signalfd
and fsnotify to print additional information complete enough
to restore these objects after checkpoint.

To simplify the code we add show_fdinfo callback inside
struct file_operations (as Al and Pavel are proposing).

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: James Bottomley <jbottomley@parallels.com>
---
 fs/proc/fd.c       |    5 +++++
 include/linux/fs.h |    3 +++
 2 files changed, 8 insertions(+)

Index: linux-2.6.git/fs/proc/fd.c
===================================================================
--- linux-2.6.git.orig/fs/proc/fd.c
+++ linux-2.6.git/fs/proc/fd.c
@@ -23,8 +23,13 @@ struct proc_fdinfo {
 static int seq_show(struct seq_file *m, void *v)
 {
 	struct proc_fdinfo *fdinfo = container_of(m, struct proc_fdinfo, m);
+
 	seq_printf(m, "pos:\t%lli\nflags:\t0%o\n",
 		   (long long)fdinfo->fd_file->f_pos, fdinfo->f_flags);
+
+	if (fdinfo->fd_file->f_op->show_fdinfo)
+		return fdinfo->fd_file->f_op->show_fdinfo(m, fdinfo->fd_file);
+
 	return 0;
 }
 
Index: linux-2.6.git/include/linux/fs.h
===================================================================
--- linux-2.6.git.orig/include/linux/fs.h
+++ linux-2.6.git/include/linux/fs.h
@@ -1775,6 +1775,8 @@ struct block_device_operations;
 #define HAVE_COMPAT_IOCTL 1
 #define HAVE_UNLOCKED_IOCTL 1
 
+struct seq_file;
+
 struct file_operations {
 	struct module *owner;
 	loff_t (*llseek) (struct file *, loff_t, int);
@@ -1803,6 +1805,7 @@ struct file_operations {
 	int (*setlease)(struct file *, long, struct file_lock **);
 	long (*fallocate)(struct file *file, int mode, loff_t offset,
 			  loff_t len);
+	int (*show_fdinfo)(struct seq_file *m, struct file *f);
 };
 
 struct inode_operations {

