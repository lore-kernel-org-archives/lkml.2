Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424452Ab2LGU4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 15:56:48 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36763 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424419Ab2LGU4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 15:56:45 -0500
Message-Id: <20121207205640.729815069@openvz.org>
User-Agent: quilt/0.60-1
Date: Sat, 08 Dec 2012 00:53:00 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrey Vagin <avagin@openvz.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <jbottomley@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Subject: [patch 1/2] [PATCH -mm] fs, fanotify: Add @mflags field to fanotify output
References: <20121207205259.394558474@openvz.org>
Content-Disposition: inline; filename=fdinfo-fanotify-extend-2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel keeps FAN_MARK_IGNORED_SURV_MODIFY bit separately from
fsnotify_mark::mask|ignored_mask thus put it in @mflags (mark flags)
field so the user-space reader will be able to detect if such bit
were used on mark creation procedure.

 | pos:	0
 | flags:	04002
 | fanotify flags:10 event-flags:0
 | fanotify mnt_id:12 mflags:40 mask:38 ignored_mask:40000003
 | fanotify ino:4f969 sdev:800013 mflags:0 mask:3b ignored_mask:40000000 fhandle-bytes:8 fhandle-type:1 f_handle:69f90400c275b5b4

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Andrey Vagin <avagin@openvz.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: James Bottomley <jbottomley@parallels.com>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: Matthew Helsley <matt.helsley@gmail.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>
CC: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
---
 fs/notify/fdinfo.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

Index: linux-2.6.git/fs/notify/fdinfo.c
===================================================================
--- linux-2.6.git.orig/fs/notify/fdinfo.c
+++ linux-2.6.git/fs/notify/fdinfo.c
@@ -111,29 +111,33 @@ int inotify_show_fdinfo(struct seq_file
 
 static int fanotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
 {
+	unsigned int mflags = 0;
 	struct inode *inode;
 	int ret = 0;
 
 	if (!(mark->flags & FSNOTIFY_MARK_FLAG_ALIVE))
 		return 0;
 
+	if (mark->flags & FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY)
+		mflags |= FAN_MARK_IGNORED_SURV_MODIFY;
+
 	if (mark->flags & FSNOTIFY_MARK_FLAG_INODE) {
 		inode = igrab(mark->i.inode);
 		if (!inode)
 			goto out;
 		ret = seq_printf(m, "fanotify ino:%lx sdev:%x "
-				 "mask:%x ignored_mask:%x ",
+				 "mflags:%x mask:%x ignored_mask:%x ",
 				 inode->i_ino, inode->i_sb->s_dev,
-				 mark->mask, mark->ignored_mask);
+				 mflags, mark->mask, mark->ignored_mask);
 		ret |= show_mark_fhandle(m, inode);
 		ret |= seq_putc(m, '\n');
 		iput(inode);
 	} else if (mark->flags & FSNOTIFY_MARK_FLAG_VFSMOUNT) {
 		struct mount *mnt = real_mount(mark->m.mnt);
 
-		ret = seq_printf(m, "fanotify mnt_id:%x mask:%x "
-				 "ignored_mask:%x\n",
-				 mnt->mnt_id, mark->mask, mark->ignored_mask);
+		ret = seq_printf(m, "fanotify mnt_id:%x mflags:%x mask:%x "
+				 "ignored_mask:%x\n", mnt->mnt_id, mflags,
+				 mark->mask, mark->ignored_mask);
 	}
 out:
 	return ret;

