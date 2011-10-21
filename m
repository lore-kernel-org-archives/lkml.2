Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab1JUVSk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 17:18:40 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:58395 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab1JUVSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 17:18:38 -0400
Subject: [PATCH 2/5] ext4: ext4_rename should dirty dir_bh with the correct
	directory
To: Tao Ma <tm@tao.ma>, Theodore Tso <tytso@mit.edu>
From: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 21 Oct 2011 14:18:06 -0700
Message-ID: <20111021211806.10784.76743.stgit@elm3c44.beaverton.ibm.com>
In-Reply-To: <20111021211759.10784.17257.stgit@elm3c44.beaverton.ibm.com>
References: <20111021211759.10784.17257.stgit@elm3c44.beaverton.ibm.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11102121-1780-0000-0000-00000064A269
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
index 310b356..6d3fab4 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2530,7 +2530,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		PARENT_INO(dir_bh->b_data, new_dir->i_sb->s_blocksize) =
 						cpu_to_le32(new_dir->i_ino);
 		BUFFER_TRACE(dir_bh, "call ext4_handle_dirty_metadata");
-		retval = ext4_handle_dirty_metadata(handle, old_dir, dir_bh);
+		retval = ext4_handle_dirty_metadata(handle, old_inode, dir_bh);
 		if (retval) {
 			ext4_std_error(old_dir->i_sb, retval);
 			goto end_rename;

