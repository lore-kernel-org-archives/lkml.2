Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965288Ab1C3Vfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:35:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:26918 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964935Ab1C3VI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621237852"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: johunt@akamai.com, viro@ZenIV.linux.org.uk, jack@suse.cz, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [165/275] ext2: Fix link count corruption under heavy link+rename load
Message-Id: <20110330210647.744503E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/ext2/namei.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

Index: linux-2.6.35.y/fs/ext2/namei.c
===================================================================
--- linux-2.6.35.y.orig/fs/ext2/namei.c	2011-03-29 22:50:58.827753164 -0700
+++ linux-2.6.35.y/fs/ext2/namei.c	2011-03-29 23:03:01.688256973 -0700
@@ -344,7 +344,6 @@
 		new_de = ext2_find_entry (new_dir, &new_dentry->d_name, &new_page);
 		if (!new_de)
 			goto out_dir;
-		inode_inc_link_count(old_inode);
 		ext2_set_link(new_dir, new_de, new_page, old_inode, 1);
 		new_inode->i_ctime = CURRENT_TIME_SEC;
 		if (dir_de)
@@ -356,12 +355,9 @@
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
@@ -369,12 +365,11 @@
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
