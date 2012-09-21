Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab2IUJba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:31:30 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:33559 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932735Ab2IUJb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:31:26 -0400
From: Guo Chao <yan@linux.vnet.ibm.com>
To: viro@zeniv.linux.org.uk
Cc: dchinner@redhat.com, hch@infradead.org, jack@suse.cz,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] fs/inode.c: do not take i_lock in __(insert|remove)_inode_hash
Date: Fri, 21 Sep 2012 17:31:04 +0800
Message-Id: <1348219866-1799-3-git-send-email-yan@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348219866-1799-1-git-send-email-yan@linux.vnet.ibm.com>
References: <1348219866-1799-1-git-send-email-yan@linux.vnet.ibm.com>
x-cbid: 12092109-2674-0000-0000-00000610023A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the beginning of fs/inode.c, the comment suggests both inode_hash_lock and
i_lock protect i_hash. I wonder why two locks are needed.

Grep the source code shows that i_hash is accessed in limited and
well-defined places:

        1. In inode_unhashed()
        2. In some special cases, as argument to hlist_add_fake()
        3. Traverse inode hash list
        4. Add/remove inode to/from inode hash list.

Case #1, #2 are not in any locking context. Case #3, #4 will hold
inode_hash_lock. i_hash is not accessed by other ways. This suggests that
inode_hash_lock alone protects i_hash well.

In __(insert|remove)_inode_hash(), our only goal is to manipulate i_hash, do
not take i_lock in these functions.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 fs/inode.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index d2d15aa..54e4b29 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -463,9 +463,7 @@ void __insert_inode_hash(struct inode *inode, unsigned long hashval)
 	struct hlist_head *b = inode_hashtable + hash(inode->i_sb, hashval);
 
 	spin_lock(&inode_hash_lock);
-	spin_lock(&inode->i_lock);
 	hlist_add_head(&inode->i_hash, b);
-	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_hash_lock);
 }
 EXPORT_SYMBOL(__insert_inode_hash);
@@ -479,9 +477,7 @@ EXPORT_SYMBOL(__insert_inode_hash);
 void __remove_inode_hash(struct inode *inode)
 {
 	spin_lock(&inode_hash_lock);
-	spin_lock(&inode->i_lock);
 	hlist_del_init(&inode->i_hash);
-	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_hash_lock);
 }
 EXPORT_SYMBOL(__remove_inode_hash);
-- 
1.7.9.5

