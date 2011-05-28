Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab1E1P0x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 11:26:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:3692 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727Ab1E1P0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 11:26:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,285,1304319600"; 
   d="scan'208";a="8935161"
From: Andi Kleen <andi@firstfloor.org>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, tytso@mit.edu
Subject: [PATCH 2/4] EXT4: Set NOSEC flag early when there are no xattrs v2
Date: Sat, 28 May 2011 08:25:52 -0700
Message-Id: <1306596354-18453-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1306596354-18453-1-git-send-email-andi@firstfloor.org>
References: <1306596354-18453-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This avoids a xattr lookup on every write.

v2: Use helper
Cc: tytso@mit.edu
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/ext4/ialloc.c |    4 ++++
 fs/ext4/inode.c  |    6 ++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 21bb2f6..e0aabdb 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1012,6 +1012,10 @@ got:
 	 */
 	ei->i_flags =
 		ext4_mask_flags(mode, EXT4_I(dir)->i_flags & EXT4_FL_INHERITED);
+	/* 
+ 	 * New inode doesn't have security xattrs. 
+ 	 */
+	inode_has_no_xattr(inode);
 	ei->i_file_acl = 0;
 	ei->i_dtime = 0;
 	ei->i_block_group = group;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f2fa5e8..1079d02 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4758,6 +4758,12 @@ void ext4_set_inode_flags(struct inode *inode)
 		inode->i_flags |= S_NOATIME;
 	if (flags & EXT4_DIRSYNC_FL)
 		inode->i_flags |= S_DIRSYNC;
+	/*
+	 * Don't know yet if an xattr is really security related, but the first
+	 * write will find out.
+	 */
+	if (!ext4_test_inode_state(inode, EXT4_STATE_XATTR))
+		inode_has_no_xattr(inode);
 }
 
 /* Propagate flags from i_flags to EXT4_I(inode)->i_flags */
-- 
1.7.4.4

