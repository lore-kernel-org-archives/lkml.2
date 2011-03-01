Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab1CAIvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 03:51:47 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:49431 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975Ab1CAIvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 03:51:44 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 3/6] fs/9p: Writeback dirty data before setattr
Date: Tue,  1 Mar 2011 14:21:21 +0530
Message-Id: <1298969484-16199-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1298969484-16199-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1298969484-16199-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change file attribute can result in making the file readonly.
So flush the dirty pages before that.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode.c      |    4 ++++
 fs/9p/vfs_inode_dotl.c |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 7c60011..e49c592 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1002,6 +1002,10 @@ static int v9fs_vfs_setattr(struct dentry *dentry, struct iattr *iattr)
 		if (retval)
 			return retval;
 	}
+	/* Write all dirty data */
+	if (S_ISREG(dentry->d_inode->i_mode))
+		filemap_write_and_wait(dentry->d_inode->i_mapping);
+
 	retval = p9_client_wstat(fid, &wstat);
 	if (retval < 0)
 		return retval;
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index b14d740..327c578 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -462,6 +462,10 @@ int v9fs_vfs_setattr_dotl(struct dentry *dentry, struct iattr *iattr)
 		if (retval)
 			return retval;
 	}
+	/* Write all dirty data */
+	if (S_ISREG(dentry->d_inode->i_mode))
+		filemap_write_and_wait(dentry->d_inode->i_mapping);
+
 	retval = p9_client_setattr(fid, &p9attr);
 	if (retval < 0)
 		return retval;
-- 
1.7.1

