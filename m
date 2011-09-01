Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab1IAAaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 20:30:52 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:59751 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756584Ab1IAAat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 20:30:49 -0400
Subject: [PATCH 02/16] ext4: ext4_rename should dirty dir_bh with the correct
	directory
To: Andreas Dilger <adilger.kernel@dilger.ca>, Theodore Tso <tytso@mit.edu>,
        "Darrick J. Wong" <djwong@us.ibm.com>
From: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Mingming Cao <cmm@us.ibm.com>,
        Joel Becker <jlbec@evilplan.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
Date: Wed, 31 Aug 2011 17:30:44 -0700
Message-ID: <20110901003043.31048.48270.stgit@elm3c44.beaverton.ibm.com>
In-Reply-To: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
index 815c31a..f778a54 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2529,7 +2529,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		PARENT_INO(dir_bh->b_data, new_dir->i_sb->s_blocksize) =
 						cpu_to_le32(new_dir->i_ino);
 		BUFFER_TRACE(dir_bh, "call ext4_handle_dirty_metadata");
-		retval = ext4_handle_dirty_metadata(handle, old_dir, dir_bh);
+		retval = ext4_handle_dirty_metadata(handle, old_inode, dir_bh);
 		if (retval) {
 			ext4_std_error(old_dir->i_sb, retval);
 			goto end_rename;

