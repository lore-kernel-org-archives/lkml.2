Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab1F3BCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 21:02:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089Ab1F3BCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 21:02:40 -0400
From: Lachlan McIlroy <lmcilroy@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lachlan McIlroy <lmcilroy@redhat.com>
Subject: [PATCH 1/1] block: initialise bd_super in bdget()
Date: Thu, 30 Jun 2011 11:01:45 +1000
Message-Id: <1309395705-4473-1-git-send-email-lmcilroy@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bd_super is currently reset to NULL in kill_block_super() so we rely on previous
users of the block_device object to initialise this value for the next user.
This quirk was exposed on RHEL5 when a third party filesystem did not always use
kill_block_super() and therefore bd_super wasn't being reset when a block_device
object was recycled within the cache.  This may not be a problem upstream but
makes sense to be defensive.

Signed-off-by: Lachlan McIlroy <lmcilroy@redhat.com>
---
 fs/block_dev.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 610e8e0..2b0dc33 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -547,6 +547,7 @@ struct block_device *bdget(dev_t dev)
 
 	if (inode->i_state & I_NEW) {
 		bdev->bd_contains = NULL;
+		bdev->bd_super = NULL;
 		bdev->bd_inode = inode;
 		bdev->bd_block_size = (1 << inode->i_blkbits);
 		bdev->bd_part_count = 0;
-- 
1.7.2.3

