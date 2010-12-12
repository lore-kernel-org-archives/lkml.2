Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab0LMAO5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:14:57 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36034 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab0LLXq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:29 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: tyhicks@linux.vnet.ibm.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [88/223] eCryptfs: Clear LOOKUP_OPEN flag when creating lower file
Message-Id: <20101212234627.CC56EB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:27 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

commit 2e21b3f124eceb6ab5a07c8a061adce14ac94e14 upstream.

eCryptfs was passing the LOOKUP_OPEN flag through to the lower file
system, even though ecryptfs_create() doesn't support the flag. A valid
filp for the lower filesystem could be returned in the nameidata if the
lower file system's create() function supported LOOKUP_OPEN, possibly
resulting in unencrypted writes to the lower file.

However, this is only a potential problem in filesystems (FUSE, NFS,
CIFS, CEPH, 9p) that eCryptfs isn't known to support today.

https://bugs.launchpad.net/ecryptfs/+bug/641703

Reported-by: Kevin Buhr
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/ecryptfs/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/fs/ecryptfs/inode.c
===================================================================
--- linux.orig/fs/ecryptfs/inode.c
+++ linux/fs/ecryptfs/inode.c
@@ -70,15 +70,19 @@ ecryptfs_create_underlying_file(struct i
 	struct vfsmount *lower_mnt = ecryptfs_dentry_to_lower_mnt(dentry);
 	struct dentry *dentry_save;
 	struct vfsmount *vfsmount_save;
+	unsigned int flags_save;
 	int rc;
 
 	dentry_save = nd->path.dentry;
 	vfsmount_save = nd->path.mnt;
+	flags_save = nd->flags;
 	nd->path.dentry = lower_dentry;
 	nd->path.mnt = lower_mnt;
+	nd->flags &= ~LOOKUP_OPEN;
 	rc = vfs_create(lower_dir_inode, lower_dentry, mode, nd);
 	nd->path.dentry = dentry_save;
 	nd->path.mnt = vfsmount_save;
+	nd->flags = flags_save;
 	return rc;
 }
 
