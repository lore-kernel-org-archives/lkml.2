Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab1CMUtn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 16:49:43 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20635 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab1CMUtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 16:49:40 -0400
Date: Sun, 13 Mar 2011 21:49:18 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-btrfs@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: [PATCH] BTRFS: Fix mem leak in btrfs_submit_direct()
Message-ID: <alpine.LNX.2.00.1103132145250.29706@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When memory is low and the allocation for 'dip->csums' fail in 
fs/btrfs/inode.c:btrfs_submit_direct() we make the situation worse by 
leaking the memory allocated to 'dip'.
This patch removes the leak by kfree()'ing 'dip' before jumping to the 
'free_ordered' label.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 inode.c |    1 +
 1 file changed, 1 insertion(+)

 compile tested only.

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0efdb65..53f4c8e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6056,6 +6056,7 @@ static void btrfs_submit_direct(int rw, struct bio *bio, struct inode *inode,
 	if (!skip_sum) {
 		dip->csums = kmalloc(sizeof(u32) * bio->bi_vcnt, GFP_NOFS);
 		if (!dip->csums) {
+			kfree(dip);
 			ret = -ENOMEM;
 			goto free_ordered;
 		}


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

