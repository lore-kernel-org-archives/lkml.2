Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760659Ab1CEBJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:09:42 -0500
Received: from kroah.org ([198.145.64.141]:50414 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760524Ab1CEBAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:45 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:39 2011
Message-Id: <20110305005639.864721706@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Al Viro <viro@ZenIV.linux.org.uk>, Josh Hunt <johunt@akamai.com>,
        Jan Kara <jack@suse.cz>
Subject: [54/73] ext2: Fix link count corruption under heavy link+rename load
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Josh Hunt <johunt@akamai.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext2/namei.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -344,7 +344,6 @@ static int ext2_rename (struct inode * o
 		new_de = ext2_find_entry (new_dir, &new_dentry->d_name, &new_page);
 		if (!new_de)
 			goto out_dir;
-		inode_inc_link_count(old_inode);
 		ext2_set_link(new_dir, new_de, new_page, old_inode, 1);
 		new_inode->i_ctime = CURRENT_TIME_SEC;
 		if (dir_de)
@@ -356,12 +355,9 @@ static int ext2_rename (struct inode * o
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
@@ -369,12 +365,11 @@ static int ext2_rename (struct inode * o
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


