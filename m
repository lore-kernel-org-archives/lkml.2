Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab1EIFtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 01:49:18 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61744 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab1EIFtQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 01:49:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Ne9J9kp1qp026R2JqXQeLNz5B1yLukrzfnepKoqZ+eLkYJdOPLu2GItF6++EFQ99eX
         aGiPyakD0i2J+BlRnvDYm+8G+c/Ipki75CkZoQFjxmFRch0Cs2O5rx6q4K5X/FF2vos/
         RiFW3pArsEFaSNP6FddPGkgOORZBbaFIMuQ7k=
MIME-Version: 1.0
Date: Sun, 8 May 2011 22:49:15 -0700
Message-ID: <BANLkTikoPEmKVAoEqg35w3P6EMQZ=VfMkA@mail.gmail.com>
Subject: [PATCH] fs/ecryptfs/inode.c warnings
From: Connor H <cmdkhh@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warnings popped up in fs/ecryptfs/inode.c with 2.6.39-rc6

fs/ecryptfs/inode.c: In function 'ecryptfs_do_create':
fs/ecryptfs/inode.c:72: warning: 'dentry_save' may be used
uninitialized in this function
fs/ecryptfs/inode.c:72: note: 'dentry_save' was declared here
fs/ecryptfs/inode.c:73: warning: 'vfsmount_save' may be used
uninitialized in this function
fs/ecryptfs/inode.c:73: note: 'vfsmount_save' was declared here
fs/ecryptfs/inode.c:74: warning: 'flags_save' may be used
uninitialized in this function
fs/ecryptfs/inode.c:74: note: 'flags_save' was declared here

patch sets rc to error and removes the need for two if statements.

-Connor

--- a/fs/ecryptfs/inode.c       2011-05-03 23:28:26.000000000 +0000
+++ b/fs/ecryptfs/inode.c       2011-05-08 22:10:43.000000000 +0000
@@ -69,21 +69,18 @@
 {
       struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
       struct vfsmount *lower_mnt = ecryptfs_dentry_to_lower_mnt(dentry);
-       struct dentry *dentry_save;
-       struct vfsmount *vfsmount_save;
-       unsigned int flags_save;
-       int rc;
+       int rc = -EIO;

       if (nd) {
-               dentry_save = nd->path.dentry;
-               vfsmount_save = nd->path.mnt;
-               flags_save = nd->flags;
+               struct dentry *dentry_save = nd->path.dentry;
+               struct vfsmount *vfsmount_save = nd->path.mnt;
+               unsigned int flags_save = nd->flags;
               nd->path.dentry = lower_dentry;
               nd->path.mnt = lower_mnt;
               nd->flags &= ~LOOKUP_OPEN;
-       }
-       rc = vfs_create(lower_dir_inode, lower_dentry, mode, nd);
-       if (nd) {
+
+               rc = vfs_create(lower_dir_inode, lower_dentry, mode, nd);
+
               nd->path.dentry = dentry_save;
               nd->path.mnt = vfsmount_save;
               nd->flags = flags_save;
