Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab2LVDQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 22:16:11 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35861 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab2LVDQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 22:16:09 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 4/5] f2fs: fix fsync_inode list addition logic and avoid invalid access to memory
Date: Sat, 22 Dec 2012 12:10:12 +0900
Message-Id: <1356145812-20048-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

In function find_fsync_dnodes() - the fsync inodes gets added to the list, but
in one path suppose f2fs_iget results in error, in such case - error gets added
to the fsync inode list.
In next call to recover_data()->get_fsync_inode()
entry = list_entry(this, struct fsync_inode_entry, list);
                if (entry->inode->i_ino == ino)
This can result in "invalid access to memory" when it encounters 'error' as
entry in the fsync inode list.
So, add the fsync inode entry to the list only in case of no errors.
And, free the object at that point itself in case of issue.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/recovery.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 632e679..e602bfa 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -144,14 +144,15 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 				goto out;
 			}
 
-			INIT_LIST_HEAD(&entry->list);
-			list_add_tail(&entry->list, head);
-
 			entry->inode = f2fs_iget(sbi->sb, ino_of_node(page));
 			if (IS_ERR(entry->inode)) {
 				err = PTR_ERR(entry->inode);
+				kmem_cache_free(fsync_entry_slab, entry);
 				goto out;
 			}
+
+			INIT_LIST_HEAD(&entry->list);
+			list_add_tail(&entry->list, head);
 			entry->blkaddr = blkaddr;
 		}
 		if (IS_INODE(page)) {
-- 
1.7.9.5

