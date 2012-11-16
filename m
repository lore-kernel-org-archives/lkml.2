Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab2KPX4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 18:56:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47045 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab2KPX4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 18:56:05 -0500
Date: Fri, 16 Nov 2012 15:56:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, oleg@redhat.com,
        rientjes@google.com, tvrtko.ursulin@onelan.co.uk,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: [patch 7/7] fs, notify: Add procfs fdinfo helper v6
Message-Id: <20121116155603.2118394c.akpm@linux-foundation.org>
In-Reply-To: <20121114152239.936025193@openvz.org>
References: <20121114151937.344922058@openvz.org>
	<20121114152239.936025193@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012 19:19:44 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> This allow us to print out fsnotify details such as
> watchee inode, device, mask and optionally a file handle.
> 
> For inotify objects if kernel compiled with exportfs support
> the output will be
> 
>  | pos:	0
>  | flags:	02000000
>  | inotify wd:        3 ino:             9e7e sdev:   800013 mask:  800afce ignored_mask:        0 fhandle-bytes:        8 fhandle-type:        1 f_handle: 7e9e0000640d1b6d
>  | inotify wd:        2 ino:             a111 sdev:   800013 mask:  800afce ignored_mask:        0 fhandle-bytes:        8 fhandle-type:        1 f_handle: 11a1000020542153
>  | inotify wd:        1 ino:            6b149 sdev:   800013 mask:  800afce ignored_mask:        0 fhandle-bytes:        8 fhandle-type:        1 f_handle: 49b1060023552153

This is a lousy output format.  It's sort-of like a sensible set of
name-value tuples: "name:value name:value name:value" but

a) it has lots of random pointless whitespace after the colons and

b) several of the labels have spaces in them, just to make life
   harder for parsing code and

c) inotify-wd is secretly printed in decimal while everything else
   is in hex.


What happens if we do something like the below (which will require a
changelog update)?

--- a/fs/notify/fdinfo.c~fs-notify-add-procfs-fdinfo-helper-v6-fix
+++ a/fs/notify/fdinfo.c
@@ -50,7 +50,7 @@ static int show_mark_fhandle(struct seq_
 	f.handle.handle_bytes = sizeof(f.pad);
 	size = f.handle.handle_bytes >> 2;
 
-	ret = exportfs_encode_inode_fh(inode, (struct fid *)f.handle.f_handle, &size,  0);
+	ret = exportfs_encode_inode_fh(inode, (struct fid *)f.handle.f_handle, &size, 0);
 	if ((ret == 255) || (ret == -ENOSPC)) {
 		WARN_ONCE(1, "Can't encode file handler for inotify: %d\n", ret);
 		return 0;
@@ -59,7 +59,7 @@ static int show_mark_fhandle(struct seq_
 	f.handle.handle_type = ret;
 	f.handle.handle_bytes = size * sizeof(u32);
 
-	ret = seq_printf(m, "fhandle-bytes: %8x fhandle-type: %8x f_handle: ",
+	ret = seq_printf(m, "fhandle-bytes:%x fhandle-type:%x f_handle:",
 			 f.handle.handle_bytes, f.handle.handle_type);
 
 	for (i = 0; i < f.handle.handle_bytes; i++)
@@ -86,8 +86,8 @@ static int inotify_fdinfo(struct seq_fil
 	inode_mark = container_of(mark, struct inotify_inode_mark, fsn_mark);
 	inode = igrab(mark->i.inode);
 	if (inode) {
-		ret = seq_printf(m, "inotify wd: %8d ino: %16lx sdev: %8x "
-				 "mask: %8x ignored_mask: %8x ",
+		ret = seq_printf(m, "inotify-wd:%x ino:%lx sdev:%x "
+				 "mask:%x ignored_mask:%x ",
 				 inode_mark->wd, inode->i_ino,
 				 inode->i_sb->s_dev,
 				 mark->mask, mark->ignored_mask);
@@ -120,15 +120,16 @@ static int fanotify_fdinfo(struct seq_fi
 		inode = igrab(mark->i.inode);
 		if (!inode)
 			goto out;
-		ret = seq_printf(m, "fanotify ino: %16lx sdev: %8x "
-				 "mask: %8x ignored_mask: %8x\n",
+		ret = seq_printf(m, "fanotify-ino:%x sdev:%x "
+				 "mask:%x ignored_mask:%x\n",
 				 inode->i_ino, inode->i_sb->s_dev,
 				 mark->mask, mark->ignored_mask);
 		iput(inode);
 	} else if (mark->flags & FSNOTIFY_MARK_FLAG_VFSMOUNT) {
 		struct mount *mnt = real_mount(mark->m.mnt);
 
-		ret = seq_printf(m, "fanotify mnt_id: %8x mask: %8x ignored_mask: %8x\n",
+		ret = seq_printf(m, "fanotify-mnt_id:%x mask:%x "
+				 "ignored_mask:%x\n",
 				 mnt->mnt_id, mark->mask, mark->ignored_mask);
 	}
 out:
_

