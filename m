Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161175Ab2KNPWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 10:22:53 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:36185 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883Ab2KNPWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 10:22:46 -0500
Message-Id: <20121114152239.413767763@openvz.org>
User-Agent: quilt/0.48-1
Date: Wed, 14 Nov 2012 19:19:38 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, oleg@redhat.com,
        rientjes@google.com, tvrtko.ursulin@onelan.co.uk,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrey Vagin <avagin@openvz.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 1/7] procfs: Add ability to plug in auxiliary fdinfo providers
References: <20121114151937.344922058@openvz.org>
Content-Disposition: inline; filename=seq-fdinfo-seq-ops-helpers-12
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
CC: Oleg Nesterov <oleg@redhat.com>
CC: Andrey Vagin <avagin@openvz.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: James Bottomley <jbottomley@parallels.com>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Matthew Helsley <matt.helsley@gmail.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
---
 fs/proc/fd.c       |    2 ++
 include/linux/fs.h |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.git/fs/proc/fd.c
===================================================================
--- linux-2.6.git.orig/fs/proc/fd.c
+++ linux-2.6.git/fs/proc/fd.c
@@ -50,6 +50,8 @@ static int seq_show(struct seq_file *m,
 	if (!ret) {
                 seq_printf(m, "pos:\t%lli\nflags:\t0%o\n",
 			   (long long)file->f_pos, f_flags);
+		if (file->f_op->show_fdinfo)
+			ret = file->f_op->show_fdinfo(m, file);
 		fput(file);
 	}
 
Index: linux-2.6.git/include/linux/fs.h
===================================================================
--- linux-2.6.git.orig/include/linux/fs.h
+++ linux-2.6.git/include/linux/fs.h
@@ -44,6 +44,7 @@ struct vm_area_struct;
 struct vfsmount;
 struct cred;
 struct swap_info_struct;
+struct seq_file;
 
 extern void __init inode_init(void);
 extern void __init inode_init_early(void);
@@ -1545,6 +1546,7 @@ struct file_operations {
 	int (*setlease)(struct file *, long, struct file_lock **);
 	long (*fallocate)(struct file *file, int mode, loff_t offset,
 			  loff_t len);
+	int (*show_fdinfo)(struct seq_file *m, struct file *f);
 };
 
 struct inode_operations {
@@ -1580,8 +1582,6 @@ struct inode_operations {
 			   umode_t create_mode, int *opened);
 } ____cacheline_aligned;
 
-struct seq_file;
-
 ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
 			      unsigned long nr_segs, unsigned long fast_segs,
 			      struct iovec *fast_pointer,

