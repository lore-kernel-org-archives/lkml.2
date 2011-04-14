Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933935Ab1DNS25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:28:57 -0400
Received: from mail.windriver.com ([147.11.1.11]:38006 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933003Ab1DNRqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 049/209] eCryptfs: Clear LOOKUP_OPEN flag when creating lower file
Date: Thu, 14 Apr 2011 13:41:19 -0400
Message-Id: <1302803039-9400-50-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ecryptfs/inode.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 21801ee..31c8b2f 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -70,15 +70,19 @@ ecryptfs_create_underlying_file(struct inode *lower_dir_inode,
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
 
-- 
1.7.4.4

