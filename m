Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166Ab1IAAbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 20:31:12 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:43209 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756999Ab1IAAbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 20:31:08 -0400
Subject: [PATCH 03/16] ext4: ext4_mkdir should dirty dir_block with the parent
	inode
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
Date: Wed, 31 Aug 2011 17:30:50 -0700
Message-ID: <20110901003050.31048.58045.stgit@elm3c44.beaverton.ibm.com>
In-Reply-To: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
index f778a54..a067835 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1862,7 +1862,7 @@ retry:
 	ext4_set_de_type(dir->i_sb, de, S_IFDIR);
 	inode->i_nlink = 2;
 	BUFFER_TRACE(dir_block, "call ext4_handle_dirty_metadata");
-	err = ext4_handle_dirty_metadata(handle, dir, dir_block);
+	err = ext4_handle_dirty_metadata(handle, inode, dir_block);
 	if (err)
 		goto out_clear_inode;
 	err = ext4_mark_inode_dirty(handle, inode);

