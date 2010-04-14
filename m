Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab0DNUF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 16:05:58 -0400
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:36115 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab0DNUF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 16:05:57 -0400
X-Greylist: delayed 555 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Apr 2010 16:05:57 EDT
From: Bill Pemberton <wfp5p@virginia.edu>
To: shaggy@linux.vnet.ibm.com
Cc: jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] jfs: fix diAllocExt error in resizing filesystem
Date: Wed, 14 Apr 2010 15:56:41 -0400
Message-Id: <1271275001-20015-1-git-send-email-wfp5p@virginia.edu>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resizing the filesystem would result in an diAllocExt error in some
instances because changes in bmp->db_agsize would not get noticed if
goto extendBmap was called.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
---
 fs/jfs/resize.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/jfs/resize.c b/fs/jfs/resize.c
index 7f24a0b..1aba003 100644
--- a/fs/jfs/resize.c
+++ b/fs/jfs/resize.c
@@ -81,6 +81,7 @@ int jfs_extendfs(struct super_block *sb, s64 newLVSize, int newLogSize)
 	struct inode *iplist[1];
 	struct jfs_superblock *j_sb, *j_sb2;
 	uint old_agsize;
+	int agsizechanged = 0;
 	struct buffer_head *bh, *bh2;
 
 	/* If the volume hasn't grown, get out now */
@@ -333,6 +334,9 @@ int jfs_extendfs(struct super_block *sb, s64 newLVSize, int newLogSize)
 	 */
 	if ((rc = dbExtendFS(ipbmap, XAddress, nblocks)))
 		goto error_out;
+
+	agsizechanged |= (bmp->db_agsize != old_agsize);
+
 	/*
 	 * the map now has extended to cover additional nblocks:
 	 * dn_mapsize = oldMapsize + nblocks;
@@ -432,7 +436,7 @@ int jfs_extendfs(struct super_block *sb, s64 newLVSize, int newLogSize)
 	 * will correctly identify the new ag);
 	 */
 	/* if new AG size the same as old AG size, done! */
-	if (bmp->db_agsize != old_agsize) {
+	if (agsizechanged) {
 		if ((rc = diExtendFS(ipimap, ipbmap)))
 			goto error_out;
 
-- 
1.6.6.1

