Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934208Ab1FWSNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:13:47 -0400
Received: from mail.windriver.com ([147.11.1.11]:34494 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933334Ab1FWRg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:29 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 114/247] eCryptfs: Copy up lower inode attrs in getattr
Date: Thu, 23 Jun 2011 13:33:02 -0400
Message-Id: <1308850515-15242-55-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ecryptfs/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 31c8b2f..b39e46f 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -1034,6 +1034,8 @@ int ecryptfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	rc = vfs_getattr(ecryptfs_dentry_to_lower_mnt(dentry),
 			 ecryptfs_dentry_to_lower(dentry), &lower_stat);
 	if (!rc) {
+		fsstack_copy_attr_all(dentry->d_inode,
+				      ecryptfs_inode_to_lower(dentry->d_inode));
 		generic_fillattr(dentry->d_inode, stat);
 		stat->blocks = lower_stat.blocks;
 	}
-- 
1.7.4.4

