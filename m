Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab1E0WzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 18:55:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:35983 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab1E0WzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 18:55:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,283,1304319600"; 
   d="scan'208";a="6045327"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Andi Kleen <ak@linux.intel.com>, tytso@mit.edu
Subject: [PATCH 2/4] EXT4: Set NOSEC flag early when there are no xattrs
Date: Fri, 27 May 2011 15:54:03 -0700
Message-Id: <1306536845-24162-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1306536845-24162-1-git-send-email-andi@firstfloor.org>
References: <1306536845-24162-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This avoids a xattr lookup on every write.

Cc: tytso@mit.edu
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/ext4/ialloc.c |    5 +++++
 fs/ext4/inode.c  |    7 +++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 21bb2f6..cc7878d 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1012,6 +1012,11 @@ got:
 	 */
 	ei->i_flags =
 		ext4_mask_flags(mode, EXT4_I(dir)->i_flags & EXT4_FL_INHERITED);
+	/* 
+ 	 * New inode doesn't have security xattrs. 
+ 	 */
+	if (!is_sgid(inode->i_mode))	
+		inode->i_flags |= S_NOSEC;
 	ei->i_file_acl = 0;
 	ei->i_dtime = 0;
 	ei->i_block_group = group;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f2fa5e8..d03b2b0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4758,6 +4758,13 @@ void ext4_set_inode_flags(struct inode *inode)
 		inode->i_flags |= S_NOATIME;
 	if (flags & EXT4_DIRSYNC_FL)
 		inode->i_flags |= S_DIRSYNC;
+	/*
+	 * Don't know yet if an xattr is really security related, but the first
+	 * write will find out.
+	 */
+	if (!is_sgid(inode->i_mode) &&
+		!ext4_test_inode_state(inode, EXT4_STATE_XATTR))
+		inode->i_flags |= S_NOSEC;
 }
 
 /* Propagate flags from i_flags to EXT4_I(inode)->i_flags */
-- 
1.7.4.4

