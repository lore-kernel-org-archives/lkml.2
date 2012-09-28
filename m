Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab2I1JPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:15:07 -0400
Received: from we870.netcup.net ([46.38.232.112]:46740 "EHLO we870.netcup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757171Ab2I1JPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:15:03 -0400
X-Greylist: delayed 655 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2012 05:15:03 EDT
Date: Fri, 28 Sep 2012 11:04:03 +0200
From: Michael Heide <lkml843@der-he.de>
To: linux-kernel@vger.kernel.org
Subject: Sharing USB Media between multiple Home PCs
Message-ID: <20120928110403.4fc171b1@tbb-phenom>
Organization: der-he.de
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/rrdzDtoTueJvLloGlOA8L/R"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/rrdzDtoTueJvLloGlOA8L/R
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello all.

Sharing USB Media between multiple Home PCs is a pain, at least for me.

It works fine with fat or ntfs, where there is no rights Management in Linux.
fat is old and unreliable compared to modern file systems.
ntfs is a modern b+tree based journalling file system, but who wants to 
use a windows file system implemented via fuse in linux to share files 
between linux PCs?

When sharing Documents via an ext formatted USB Medium between several Users 
on multiple PCs, there seems to be no easy way to use[1] all those files 
another user has created. I'm feeling sorry if I'm just don't seeing some
obvious solution to this problem...

[1] using means reading and writing, like editing some office docs.

Are there any useful hints to do such things?

If not... read on.
I've patched my Kernel, just for fun. I've added a mount option for
ext4 called "noposixrights". If I mount it "-o noposixrights" then the 
drive is world read- and writeable. While the posix rights are still be 
handled in the background, they are simply not enforced.

It's also possible to add it as a default mount option:
tune2fs -E mount_opts=noposixrights /dev/[pathtodevice]
This way every other PC/user with a properly patched Kernel automatically 
uses this option.

There's nothing changed in the ext4 on disk data structure, 
every created file/inode still gets proper uid and mode. 
It's still possible to mount it without this option.

I'm pretty sure no one wants this patch, because it's really world
read/writeable where fat and ntfs is only read/writeable by the 
mounting uid/gid. And there's no status indicator with "state" or "ls".
(i.e. "ls" says: you are not allowed to write. but indeed you can write)
Yes, it's that crude. So I don't expect it to go upstream...

But maybe there's some existing solution for my problem I haven't found yet.
Please tell me. :-)
Or maybe I can urge someone to do it the right way. :-D

Regards
Michael

(I tried to send this to the kernelnewbies list. I'm pretty sure it's 
better suited there. But my mails got filtered out there, 
even I'm a list subscriber. So now I try it here...)

--MP_/rrdzDtoTueJvLloGlOA8L/R
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=linux-3.2.0-noposixrights.patch

diff -rupN linux-3.2.0-original/fs/ext4/ext4.h linux-3.2.0/fs/ext4/ext4.h
--- linux-3.2.0-original/fs/ext4/ext4.h	2012-09-20 16:04:42.000000000 +0200
+++ linux-3.2.0/fs/ext4/ext4.h	2012-09-20 16:09:27.196325162 +0200
@@ -944,6 +944,7 @@ struct ext4_inode_info {
 
 #define EXT4_MOUNT2_EXPLICIT_DELALLOC	0x00000001 /* User explicitly
 						      specified delalloc */
+#define EXT4_MOUNT2_NOPOSIXRIGHTS			0x00000002 /* full world writeable */
 
 #define clear_opt(sb, opt)		EXT4_SB(sb)->s_mount_opt &= \
 						~EXT4_MOUNT_##opt
diff -rupN linux-3.2.0-original/fs/ext4/super.c linux-3.2.0/fs/ext4/super.c
--- linux-3.2.0-original/fs/ext4/super.c	2012-09-20 16:04:42.000000000 +0200
+++ linux-3.2.0/fs/ext4/super.c	2012-09-20 16:13:54.687998226 +0200
@@ -1335,6 +1335,7 @@ enum {
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
 	Opt_dioread_nolock, Opt_dioread_lock,
 	Opt_discard, Opt_nodiscard, Opt_init_itable, Opt_noinit_itable,
+	Opt_posixrights, Opt_noposixrights,
 };
 
 static const match_table_t tokens = {
@@ -1394,6 +1395,8 @@ static const match_table_t tokens = {
 	{Opt_resize, "resize"},
 	{Opt_delalloc, "delalloc"},
 	{Opt_nodelalloc, "nodelalloc"},
+	{Opt_posixrights, "posixrights"},
+	{Opt_noposixrights, "noposixrights"},
 	{Opt_mblk_io_submit, "mblk_io_submit"},
 	{Opt_nomblk_io_submit, "nomblk_io_submit"},
 	{Opt_block_validity, "block_validity"},
@@ -1822,6 +1825,10 @@ set_qf_format:
 			clear_opt(sb, DELALLOC);
 			clear_opt2(sb, EXPLICIT_DELALLOC);
 			break;
+		case Opt_noposixrights:
+			set_opt2(sb, NOPOSIXRIGHTS);
+			sb->s_flags |= MS_NOPOSIXRIGHTS;
+			break;
 		case Opt_mblk_io_submit:
 			set_opt(sb, MBLK_IO_SUBMIT);
 			break;
@@ -1839,6 +1846,10 @@ set_qf_format:
 			set_opt(sb, DELALLOC);
 			set_opt2(sb, EXPLICIT_DELALLOC);
 			break;
+		case Opt_posixrights:
+			clear_opt2(sb, NOPOSIXRIGHTS);
+			sb->s_flags &= ~MS_NOPOSIXRIGHTS;
+			break;
 		case Opt_block_validity:
 			set_opt(sb, BLOCK_VALIDITY);
 			break;
@@ -3328,6 +3339,14 @@ static int ext4_fill_super(struct super_
 	    ((def_mount_opts & EXT4_DEFM_NODELALLOC) == 0))
 		set_opt(sb, DELALLOC);
 
+	/* 
+	 * use normal Posix rights by default
+	 * use -o noposixrights to turn it off
+	 * then all files will be RWX by everyone
+	 * usefull for shared media, like USB or SD Media
+	 */
+	clear_opt2(sb, NOPOSIXRIGHTS);
+
 	/*
 	 * set default s_li_wait_mult for lazyinit, for the case there is
 	 * no mount option specified.
diff -rupN linux-3.2.0-original/fs/namei.c linux-3.2.0/fs/namei.c
--- linux-3.2.0-original/fs/namei.c	2012-09-20 16:04:42.000000000 +0200
+++ linux-3.2.0/fs/namei.c	2012-09-20 16:14:45.858405590 +0200
@@ -272,6 +272,10 @@ int generic_permission(struct inode *ino
 {
 	int ret;
 
+	/*  printk(KERN_INFO "posixrights override"); */
+	if (inode->i_sb->s_flags & MS_NOPOSIXRIGHTS)
+		return 0;
+
 	/*
 	 * Do the basic permission checks.
 	 */
diff -rupN linux-3.2.0-original/include/linux/fs.h linux-3.2.0/include/linux/fs.h
--- linux-3.2.0-original/include/linux/fs.h	2012-09-20 16:04:42.000000000 +0200
+++ linux-3.2.0/include/linux/fs.h	2012-09-20 16:56:04.461396079 +0200
@@ -210,6 +210,9 @@ struct inodes_stat_t {
 #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
 #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
 #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
+#define MS_NOPOSIXRIGHTS (1<<25) /* Don't force rights, 
+                                    everyone is allowed to do everything,
+                                    everyone is root here */
 #define MS_NOSEC	(1<<28)
 #define MS_BORN		(1<<29)
 #define MS_ACTIVE	(1<<30)

--MP_/rrdzDtoTueJvLloGlOA8L/R--
