Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab0EYMWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 08:22:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755480Ab0EYMWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 08:22:48 -0400
Subject: Re: udev loops eating 100 % CPU [mmotm 2010-05-21-16-05]
From: Eric Paris <eparis@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Kay Sievers <kay.sievers@suse.de>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4BFBBEB7.4070107@gmail.com>
References: <4BFBBEB7.4070107@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 May 2010 08:22:12 -0400
Message-ID: <1274790132.2810.65.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 14:12 +0200, Jiri Slaby wrote:

thanks for the report, it's a known problem:

http://lkml.org/lkml/2010/5/22/150

Not sure yet how we are going to fix it.  You can either just revert or
you could run this patch which I am using on my box.  Not sure which Al
is going to want to do......

commit 6e066d6c0c70e2032b5fd2b5c6375e66a0f547f9
Author: Eric Paris <eparis@redhat.com>
Date:   Tue May 25 07:55:46 2010 -0400

    anon_inode/ioctl: push FIONREAD for anon_inode to the file handler
    
    FIONREAD for all S_IFREG files is handled by file_ioctl but the
    anon_inode_inode is a magic special beast since the inode is shared between
    lots of users.  Thus ioctl calls on anon_inode_inode needs to go through
    vfs_inode() instead of trying to shortcut some calls through file_ioctl().
    
    Signed-off-by: Eric Paris <eparis@redhat.com>

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 9bd4b38..4ae8c6b 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -23,7 +23,7 @@
 #include <asm/uaccess.h>
 
 static struct vfsmount *anon_inode_mnt __read_mostly;
-static struct inode *anon_inode_inode;
+struct inode *anon_inode_inode;
 static const struct file_operations anon_inode_fops;
 
 static int anon_inodefs_get_sb(struct file_system_type *fs_type, int flags,
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 2d140a7..7041855 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/uaccess.h>
 #include <linux/writeback.h>
+#include <linux/anon_inodes.h>
 #include <linux/buffer_head.h>
 #include <linux/falloc.h>
 
@@ -601,7 +602,8 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 	}
 
 	default:
-		if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
+		if (S_ISREG(filp->f_path.dentry->d_inode->i_mode) &&
+		    (filp->f_path.dentry->d_inode != anon_inode_inode))
 			error = file_ioctl(filp, cmd, arg);
 		else
 			error = vfs_ioctl(filp, cmd, arg);
diff --git a/include/linux/anon_inodes.h b/include/linux/anon_inodes.h
index 69a21e0..ebfece0 100644
--- a/include/linux/anon_inodes.h
+++ b/include/linux/anon_inodes.h
@@ -8,6 +8,8 @@
 #ifndef _LINUX_ANON_INODES_H
 #define _LINUX_ANON_INODES_H
 
+extern struct inode *anon_inode_inode;
+
 struct file *anon_inode_getfile(const char *name,
 				const struct file_operations *fops,
 				void *priv, int flags);


