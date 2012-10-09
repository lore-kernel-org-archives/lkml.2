Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab2JIPJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:09:25 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36739 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091Ab2JIPJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:09:22 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jack@suse.cz
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: [PATCH 2/6] udf: don't increment lenExtents while writing to a hole
Date: Wed, 10 Oct 2012 00:09:12 +0900
Message-Id: <1349795352-6389-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Incrementing lenExtents even while writing to a hole is bad
for performance as calls to udf_discard_prealloc and
udf_truncate_tail_extent would not return from start if
isize != lenExtents

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/udf/inode.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 2b77593..8266f2e 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -601,6 +601,7 @@ static sector_t inode_getblk(struct inode *inode, sector_t block,
 	struct udf_inode_info *iinfo = UDF_I(inode);
 	int goal = 0, pgoal = iinfo->i_location.logicalBlockNum;
 	int lastblock = 0;
+	bool isBeyondEOF;
 
 	*err = 0;
 	*new = 0;
@@ -680,7 +681,7 @@ static sector_t inode_getblk(struct inode *inode, sector_t block,
 	/* Are we beyond EOF? */
 	if (etype == -1) {
 		int ret;
-
+		isBeyondEOF = 1;
 		if (count) {
 			if (c)
 				laarr[0] = laarr[1];
@@ -723,6 +724,7 @@ static sector_t inode_getblk(struct inode *inode, sector_t block,
 		endnum = c + 1;
 		lastblock = 1;
 	} else {
+		isBeyondEOF = 0;
 		endnum = startnum = ((count > 2) ? 2 : count);
 
 		/* if the current extent is in position 0,
@@ -770,7 +772,8 @@ static sector_t inode_getblk(struct inode *inode, sector_t block,
 			*err = -ENOSPC;
 			return 0;
 		}
-		iinfo->i_lenExtents += inode->i_sb->s_blocksize;
+		if (isBeyondEOF)
+			iinfo->i_lenExtents += inode->i_sb->s_blocksize;
 	}
 
 	/* if the extent the requsted block is located in contains multiple
-- 
1.7.9.5

