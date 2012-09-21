Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab2IUJbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:31:24 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:50154 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932735Ab2IUJbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:31:21 -0400
From: Guo Chao <yan@linux.vnet.ibm.com>
To: viro@zeniv.linux.org.uk
Cc: dchinner@redhat.com, hch@infradead.org, jack@suse.cz,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] fs/inode.c: do not take i_lock on newly allocated inode
Date: Fri, 21 Sep 2012 17:31:03 +0800
Message-Id: <1348219866-1799-2-git-send-email-yan@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348219866-1799-1-git-send-email-yan@linux.vnet.ibm.com>
References: <1348219866-1799-1-git-send-email-yan@linux.vnet.ibm.com>
x-cbid: 12092109-5564-0000-0000-0000048F3D64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does current thread have the exclusive access to newly allocated inode?
The chanllege comes from individual filesystem's ->alloc_inode method.
It may exposure the inode to private lists, thus give other threads a chance
to access the inode.

That should not happen, however, because the inode is not even gone through a
basic initialization. The locks may not be initialized yet, the inode is not
ready for parallel access.

Thus, from getting an inode from alloc_inode(), till we put it on a list and
that list becomes accessible, we can safely manipulate the inode without
taking i_lock.

This patch fixes three places that take the unnecessary i_lock.

Note in iget5_locked(), I have no strong proof set() should not put the inode
into private lists. Any suggestion?

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 fs/inode.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index ac8d904..d2d15aa 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -895,9 +895,7 @@ struct inode *new_inode_pseudo(struct super_block *sb)
 	struct inode *inode = alloc_inode(sb);
 
 	if (inode) {
-		spin_lock(&inode->i_lock);
 		inode->i_state = 0;
-		spin_unlock(&inode->i_lock);
 		INIT_LIST_HEAD(&inode->i_sb_list);
 	}
 	return inode;
@@ -1015,10 +1013,8 @@ struct inode *iget5_locked(struct super_block *sb, unsigned long hashval,
 			if (set(inode, data))
 				goto set_failed;
 
-			spin_lock(&inode->i_lock);
 			inode->i_state = I_NEW;
 			hlist_add_head(&inode->i_hash, head);
-			spin_unlock(&inode->i_lock);
 			inode_sb_list_add(inode);
 			spin_unlock(&inode_hash_lock);
 
@@ -1082,10 +1078,8 @@ struct inode *iget_locked(struct super_block *sb, unsigned long ino)
 		old = find_inode_fast(sb, head, ino);
 		if (!old) {
 			inode->i_ino = ino;
-			spin_lock(&inode->i_lock);
 			inode->i_state = I_NEW;
 			hlist_add_head(&inode->i_hash, head);
-			spin_unlock(&inode->i_lock);
 			inode_sb_list_add(inode);
 			spin_unlock(&inode_hash_lock);
 
-- 
1.7.9.5

