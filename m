Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab1BVWZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:25:19 -0500
Received: from kroah.org ([198.145.64.141]:32995 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755106Ab1BVWWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:22:32 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:43 2011
Message-Id: <20110222221843.109824673@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [61/70] eCryptfs: Copy up lower inode attrs in getattr
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

commit 55f9cf6bbaa682958a7dd2755f883b768270c3ce upstream.

The lower filesystem may do some type of inode revalidation during a
getattr call. eCryptfs should take advantage of that by copying the
lower inode attributes to the eCryptfs inode after a call to
vfs_getattr() on the lower inode.

I originally wrote this fix while working on eCryptfs on nfsv3 support,
but discovered it also fixed an eCryptfs on ext4 nanosecond timestamp
bug that was reported.

https://bugs.launchpad.net/bugs/613873

Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -1095,6 +1095,8 @@ int ecryptfs_getattr(struct vfsmount *mn
 	rc = vfs_getattr(ecryptfs_dentry_to_lower_mnt(dentry),
 			 ecryptfs_dentry_to_lower(dentry), &lower_stat);
 	if (!rc) {
+		fsstack_copy_attr_all(dentry->d_inode,
+				      ecryptfs_inode_to_lower(dentry->d_inode));
 		generic_fillattr(dentry->d_inode, stat);
 		stat->blocks = lower_stat.blocks;
 	}


