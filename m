Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760Ab2KVVWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:22:45 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:57268 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757730Ab2KVVWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:22:40 -0500
Message-Id: <20121122212235.606689990@openvz.org>
User-Agent: quilt/0.48-1
Date: Fri, 23 Nov 2012 01:15:25 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, oleg@redhat.com,
        rientjes@google.com, tvrtko.ursulin@onelan.co.uk,
        linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrey Vagin <avagin@openvz.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch -mm 3/4] fs, notify: Dont forget to provide fhandle for inode fanotify
References: <20121122211522.075455799@openvz.org>
Content-Disposition: inline; filename=seq-fsnotify-update
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For inode based fanotify I missed to add fhandle output. This patch
brings it in.

 | pos:	0
 | flags:	02
 | fanotify ino:2 sdev:800013 mask:1 ignored_mask:40000000 fhandle-bytes:8 fhandle-type:1 f_handle:0200000000000000

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
 fs/notify/fdinfo.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6.git/fs/notify/fdinfo.c
===================================================================
--- linux-2.6.git.orig/fs/notify/fdinfo.c
+++ linux-2.6.git/fs/notify/fdinfo.c
@@ -36,8 +36,6 @@ static int show_fdinfo(struct seq_file *
 	return ret;
 }
 
-#ifdef CONFIG_INOTIFY_USER
-
 #if defined(CONFIG_EXPORTFS)
 static int show_mark_fhandle(struct seq_file *m, struct inode *inode)
 {
@@ -74,6 +72,8 @@ static int show_mark_fhandle(struct seq_
 }
 #endif
 
+#ifdef CONFIG_INOTIFY_USER
+
 static int inotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
 {
 	struct inotify_inode_mark *inode_mark;
@@ -121,9 +121,11 @@ static int fanotify_fdinfo(struct seq_fi
 		if (!inode)
 			goto out;
 		ret = seq_printf(m, "fanotify ino:%lx sdev:%x "
-				 "mask:%x ignored_mask:%x\n",
+				 "mask:%x ignored_mask:%x ",
 				 inode->i_ino, inode->i_sb->s_dev,
 				 mark->mask, mark->ignored_mask);
+		ret |= show_mark_fhandle(m, inode);
+		ret |= seq_putc(m, '\n');
 		iput(inode);
 	} else if (mark->flags & FSNOTIFY_MARK_FLAG_VFSMOUNT) {
 		struct mount *mnt = real_mount(mark->m.mnt);

