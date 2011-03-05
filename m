Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab1CEQw3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 11:52:29 -0500
Received: from smtp-03.mandic.com.br ([200.225.81.143]:33422 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab1CEQtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 11:49:18 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Eric B Munson <emunson@mgebm.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCHv2 10/24] sys_swapon: remove bdev variable
Date: Sat,  5 Mar 2011 13:42:11 -0300
Message-Id: <1299343345-3984-11-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bdev variable is always equivalent to (S_ISBLK(inode->i_mode) ?
p->bdev : NULL), as long as it being set is moved to a bit earlier. Use
this fact to remove the bdev variable.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
---
 mm/swapfile.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index c655389..bc00c1a 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1893,7 +1893,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 {
 	struct swap_info_struct *p;
 	char *name;
-	struct block_device *bdev = NULL;
 	struct file *swap_file = NULL;
 	struct address_space *mapping;
 	int i, prev;
@@ -1944,19 +1943,19 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	}
 
 	if (S_ISBLK(inode->i_mode)) {
-		bdev = bdgrab(I_BDEV(inode));
-		error = blkdev_get(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL,
+		p->bdev = bdgrab(I_BDEV(inode));
+		error = blkdev_get(p->bdev,
+				   FMODE_READ | FMODE_WRITE | FMODE_EXCL,
 				   sys_swapon);
 		if (error < 0) {
-			bdev = NULL;
+			p->bdev = NULL;
 			error = -EINVAL;
 			goto bad_swap;
 		}
-		p->old_block_size = block_size(bdev);
-		error = set_blocksize(bdev, PAGE_SIZE);
+		p->old_block_size = block_size(p->bdev);
+		error = set_blocksize(p->bdev, PAGE_SIZE);
 		if (error < 0)
 			goto bad_swap;
-		p->bdev = bdev;
 		p->flags |= SWP_BLKDEV;
 	} else if (S_ISREG(inode->i_mode)) {
 		p->bdev = inode->i_sb->s_bdev;
@@ -2140,9 +2139,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	error = 0;
 	goto out;
 bad_swap:
-	if (bdev) {
-		set_blocksize(bdev, p->old_block_size);
-		blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
+	if (S_ISBLK(inode->i_mode) && p->bdev) {
+		set_blocksize(p->bdev, p->old_block_size);
+		blkdev_put(p->bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 	}
 	destroy_swap_extents(p);
 	swap_cgroup_swapoff(p->type);
-- 
1.7.4

