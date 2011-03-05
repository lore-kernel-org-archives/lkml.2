Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab1CEQwE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 11:52:04 -0500
Received: from smtp-03.mandic.com.br ([200.225.81.143]:56104 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab1CEQtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 11:49:20 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Eric B Munson <emunson@mgebm.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCHv2 13/24] sys_swapon: separate bdev claim and inode lock
Date: Sat,  5 Mar 2011 13:42:14 -0300
Message-Id: <1299343345-3984-14-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the code which claims the bdev (S_ISBLK) or locks the inode
(S_ISREG) to a separate function. Only code movement, no functional
changes.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
---
 mm/swapfile.c |   64 ++++++++++++++++++++++++++++++++++----------------------
 1 files changed, 39 insertions(+), 25 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 96be104..27faeec 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1889,6 +1889,43 @@ static struct swap_info_struct *alloc_swap_info(void)
 	return p;
 }
 
+static int claim_swapfile(struct swap_info_struct *p, struct inode *inode)
+{
+	int error;
+
+	if (S_ISBLK(inode->i_mode)) {
+		p->bdev = bdgrab(I_BDEV(inode));
+		error = blkdev_get(p->bdev,
+				   FMODE_READ | FMODE_WRITE | FMODE_EXCL,
+				   sys_swapon);
+		if (error < 0) {
+			p->bdev = NULL;
+			error = -EINVAL;
+			goto bad_swap;
+		}
+		p->old_block_size = block_size(p->bdev);
+		error = set_blocksize(p->bdev, PAGE_SIZE);
+		if (error < 0)
+			goto bad_swap;
+		p->flags |= SWP_BLKDEV;
+	} else if (S_ISREG(inode->i_mode)) {
+		p->bdev = inode->i_sb->s_bdev;
+		mutex_lock(&inode->i_mutex);
+		if (IS_SWAPFILE(inode)) {
+			error = -EBUSY;
+			goto bad_swap;
+		}
+	} else {
+		error = -EINVAL;
+		goto bad_swap;
+	}
+
+	return 0;
+
+bad_swap:
+	return error;
+}
+
 SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 {
 	struct swap_info_struct *p;
@@ -1942,32 +1979,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		}
 	}
 
-	if (S_ISBLK(inode->i_mode)) {
-		p->bdev = bdgrab(I_BDEV(inode));
-		error = blkdev_get(p->bdev,
-				   FMODE_READ | FMODE_WRITE | FMODE_EXCL,
-				   sys_swapon);
-		if (error < 0) {
-			p->bdev = NULL;
-			error = -EINVAL;
-			goto bad_swap;
-		}
-		p->old_block_size = block_size(p->bdev);
-		error = set_blocksize(p->bdev, PAGE_SIZE);
-		if (error < 0)
-			goto bad_swap;
-		p->flags |= SWP_BLKDEV;
-	} else if (S_ISREG(inode->i_mode)) {
-		p->bdev = inode->i_sb->s_bdev;
-		mutex_lock(&inode->i_mutex);
-		if (IS_SWAPFILE(inode)) {
-			error = -EBUSY;
-			goto bad_swap;
-		}
-	} else {
-		error = -EINVAL;
+	error = claim_swapfile(p, inode);
+	if (unlikely(error))
 		goto bad_swap;
-	}
 
 	swapfilepages = i_size_read(inode) >> PAGE_SHIFT;
 
-- 
1.7.4

