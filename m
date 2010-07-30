Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295Ab0G3S5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:57:38 -0400
Received: from kroah.org ([198.145.64.141]:51853 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758585Ab0G3RTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:20 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:08 2010
Message-Id: <20100730171508.401427766@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Monakhov <dmonakhov@openvz.org>, "Theodore Tso" <tytso@mit.edu>
Subject: [097/165] ext4: fix error handling in migrate
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit f39490bcd1691d65dc33689222a12e1fc13dd824 upstream (as of v2.6.33-git11)

Set i_nlink to zero for temporary inode from very beginning.
otherwise we may fail to start new journal handle and this
inode will be unreferenced but with i_nlink == 1
Since we hold inode reference it can not be pruned.

Also add missed journal_start retval check.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/migrate.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -494,14 +494,10 @@ int ext4_ext_migrate(struct inode *inode
 	}
 	i_size_write(tmp_inode, i_size_read(inode));
 	/*
-	 * We don't want the inode to be reclaimed
-	 * if we got interrupted in between. We have
-	 * this tmp inode carrying reference to the
-	 * data blocks of the original file. We set
-	 * the i_nlink to zero at the last stage after
-	 * switching the original file to extent format
+	 * Set the i_nlink to zero so it will be deleted later
+	 * when we drop inode reference.
 	 */
-	tmp_inode->i_nlink = 1;
+	tmp_inode->i_nlink = 0;
 
 	ext4_ext_tree_init(handle, tmp_inode);
 	ext4_orphan_add(handle, tmp_inode);
@@ -528,6 +524,16 @@ int ext4_ext_migrate(struct inode *inode
 	up_read((&EXT4_I(inode)->i_data_sem));
 
 	handle = ext4_journal_start(inode, 1);
+	if (IS_ERR(handle)) {
+		/*
+		 * It is impossible to update on-disk structures without
+		 * a handle, so just rollback in-core changes and live other
+		 * work to orphan_list_cleanup()
+		 */
+		ext4_orphan_del(NULL, tmp_inode);
+		retval = PTR_ERR(handle);
+		goto out;
+	}
 
 	ei = EXT4_I(inode);
 	i_data = ei->i_data;
@@ -609,15 +615,8 @@ err_out:
 
 	/* Reset the extent details */
 	ext4_ext_tree_init(handle, tmp_inode);
-
-	/*
-	 * Set the i_nlink to zero so that
-	 * generic_drop_inode really deletes the
-	 * inode
-	 */
-	tmp_inode->i_nlink = 0;
-
 	ext4_journal_stop(handle);
+out:
 	unlock_new_inode(tmp_inode);
 	iput(tmp_inode);
 


