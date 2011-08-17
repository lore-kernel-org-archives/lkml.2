Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab1HQDfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 23:35:48 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:54004 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab1HQDfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 23:35:46 -0400
Date: Tue, 16 Aug 2011 20:35:44 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ext4_rename should dirty dir_bh with the correct directory
Message-ID: <20110817033544.GO20655@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When ext4_rename performs a directory rename (move), dir_bh is a buffer that is
modified to update the '..' link in the directory being moved (old_inode).
However, ext4_handle_dirty_metadata is called with the old parent directory
inode (old_dir) and dir_bh, which is incorrect because dir_bh does not belong
to the parent inode.  Fix this error.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 fs/ext4/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 79ddc43..2b5c34b 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2538,7 +2538,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		PARENT_INO(dir_bh->b_data, new_dir->i_sb->s_blocksize) =
 						cpu_to_le32(new_dir->i_ino);
 		BUFFER_TRACE(dir_bh, "call ext4_handle_dirty_metadata");
-		retval = ext4_handle_dirty_metadata(handle, old_dir, dir_bh);
+		retval = ext4_handle_dirty_metadata(handle, old_inode, dir_bh);
 		if (retval) {
 			ext4_std_error(old_dir->i_sb, retval);
 			goto end_rename;
