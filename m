Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab1ABII4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:08:56 -0500
Received: from mail.windriver.com ([147.11.1.11]:34411 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab1ABHWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:00 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Sunil Mushran <sunil.mushran@oracle.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 044/260] ocfs2: Fix incorrect checksum validation error
Date: Sun,  2 Jan 2011 02:15:40 -0500
Message-Id: <1293952756-15010-45-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:54.0257 (UTC) FILETIME=[9795C610:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sunil Mushran <sunil.mushran@oracle.com>

commit f5ce5a08a40f2086435858ddc80cb40394b082eb upstream.

For local mounts, ocfs2_read_locked_inode() calls ocfs2_read_blocks_sync() to
read the inode off the disk. The latter first checks to see if that block is
cached in the journal, and, if so, returns that block. That is ok.

But ocfs2_read_locked_inode() goes wrong when it tries to validate the checksum
of such blocks. Blocks that are cached in the journal may not have had their
checksum computed as yet. We should not validate the checksums of such blocks.

Fixes ossbz#1282
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1282

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Singed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ocfs2/inode.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index af18988..bbecb19 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -484,7 +484,11 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 						     OCFS2_BH_IGNORE_CACHE);
 	} else {
 		status = ocfs2_read_blocks_sync(osb, args->fi_blkno, 1, &bh);
-		if (!status)
+		/*
+		 * If buffer is in jbd, then its checksum may not have been
+		 * computed as yet.
+		 */
+		if (!status && !buffer_jbd(bh))
 			status = ocfs2_validate_inode_block(osb->sb, bh);
 	}
 	if (status < 0) {
-- 
1.7.3.3

