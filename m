Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab0LHBgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:36:16 -0500
Received: from kroah.org ([198.145.64.141]:48974 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757306Ab0LHBBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:18 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:34 2010
Message-Id: <20101208005734.264018026@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [129/289] eCryptfs: Clear LOOKUP_OPEN flag when creating lower file
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 fs/ecryptfs/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
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
 


