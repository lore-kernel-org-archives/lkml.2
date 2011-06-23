Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933583Ab1FWRhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:37:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:34885 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933538Ab1FWRhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:21 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Josh Hunt <johunt@akamai.com>,
        Jan Kara <jack@suse.cz>, Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 142/247] ext2: Fix link count corruption under heavy link+rename load
Date: Thu, 23 Jun 2011 13:33:30 -0400
Message-Id: <1308850515-15242-83-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Hunt <johunt@akamai.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit e8a80c6f769dd4622d8b211b398452158ee60c0b upstream.

vfs_rename_other() does not lock renamed inode with i_mutex. Thus changing
i_nlink in a non-atomic manner (which happens in ext2_rename()) can corrupt
it as reported and analyzed by Josh.

In fact, there is no good reason to mess with i_nlink of the moved file.
We did it presumably to simulate linking into the new directory and unlinking
from an old one. But the practical effect of this is disputable because fsck
can possibly treat file as being properly linked into both directories without
writing any error which is confusing. So we just stop increment-decrement
games with i_nlink which also fixes the corruption.

CC: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Josh Hunt <johunt@akamai.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext2/namei.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 71efb0e..b5d9028 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -344,7 +344,6 @@ static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 		new_de = ext2_find_entry (new_dir, &new_dentry->d_name, &new_page);
 		if (!new_de)
 			goto out_dir;
-		inode_inc_link_count(old_inode);
 		ext2_set_link(new_dir, new_de, new_page, old_inode, 1);
 		new_inode->i_ctime = CURRENT_TIME_SEC;
 		if (dir_de)
@@ -356,12 +355,9 @@ static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 			if (new_dir->i_nlink >= EXT2_LINK_MAX)
 				goto out_dir;
 		}
-		inode_inc_link_count(old_inode);
 		err = ext2_add_link(new_dentry, old_inode);
-		if (err) {
-			inode_dec_link_count(old_inode);
+		if (err)
 			goto out_dir;
-		}
 		if (dir_de)
 			inode_inc_link_count(new_dir);
 	}
@@ -369,12 +365,11 @@ static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 	/*
 	 * Like most other Unix systems, set the ctime for inodes on a
  	 * rename.
-	 * inode_dec_link_count() will mark the inode dirty.
 	 */
 	old_inode->i_ctime = CURRENT_TIME_SEC;
+	mark_inode_dirty(old_inode);
 
 	ext2_delete_entry (old_de, old_page);
-	inode_dec_link_count(old_inode);
 
 	if (dir_de) {
 		if (old_dir != new_dir)
-- 
1.7.4.4

