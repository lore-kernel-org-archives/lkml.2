Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab1JUVSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 17:18:45 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54586 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037Ab1JUVSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 17:18:43 -0400
Subject: [PATCH 3/5] ext4: ext4_mkdir should dirty dir_block with the parent
	inode
To: Tao Ma <tm@tao.ma>, Theodore Tso <tytso@mit.edu>
From: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 21 Oct 2011 14:18:12 -0700
Message-ID: <20111021211812.10784.27324.stgit@elm3c44.beaverton.ibm.com>
In-Reply-To: <20111021211759.10784.17257.stgit@elm3c44.beaverton.ibm.com>
References: <20111021211759.10784.17257.stgit@elm3c44.beaverton.ibm.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11102121-5112-0000-0000-0000012E00A3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext4_mkdir calls ext4_handle_dirty_metadata with dir_block and the inode "dir".
Unfortunately, dir_block belongs to the newly created directory (which is
"inode"), not the parent directory (which is "dir").  Fix the incorrect
association.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 6d3fab4..50c7294 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1863,7 +1863,7 @@ retry:
 	ext4_set_de_type(dir->i_sb, de, S_IFDIR);
 	inode->i_nlink = 2;
 	BUFFER_TRACE(dir_block, "call ext4_handle_dirty_metadata");
-	err = ext4_handle_dirty_metadata(handle, dir, dir_block);
+	err = ext4_handle_dirty_metadata(handle, inode, dir_block);
 	if (err)
 		goto out_clear_inode;
 	err = ext4_mark_inode_dirty(handle, inode);

