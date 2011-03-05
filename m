Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab1CEQwk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 11:52:40 -0500
Received: from smtp-03.mandic.com.br ([200.225.81.143]:43212 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab1CEQtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 11:49:19 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Eric B Munson <emunson@mgebm.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCHv2 14/24] sys_swapon: simplify error flow in claim_swapfile
Date: Sat,  5 Mar 2011 13:42:15 -0300
Message-Id: <1299343345-3984-15-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there is no cleanup to do, there is no reason to jump to a label.
Return directly instead.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
---
 mm/swapfile.c |   20 ++++++--------------
 1 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 27faeec..058cf1b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1900,30 +1900,22 @@ static int claim_swapfile(struct swap_info_struct *p, struct inode *inode)
 				   sys_swapon);
 		if (error < 0) {
 			p->bdev = NULL;
-			error = -EINVAL;
-			goto bad_swap;
+			return -EINVAL;
 		}
 		p->old_block_size = block_size(p->bdev);
 		error = set_blocksize(p->bdev, PAGE_SIZE);
 		if (error < 0)
-			goto bad_swap;
+			return error;
 		p->flags |= SWP_BLKDEV;
 	} else if (S_ISREG(inode->i_mode)) {
 		p->bdev = inode->i_sb->s_bdev;
 		mutex_lock(&inode->i_mutex);
-		if (IS_SWAPFILE(inode)) {
-			error = -EBUSY;
-			goto bad_swap;
-		}
-	} else {
-		error = -EINVAL;
-		goto bad_swap;
-	}
+		if (IS_SWAPFILE(inode))
+			return -EBUSY;
+	} else
+		return -EINVAL;
 
 	return 0;
-
-bad_swap:
-	return error;
 }
 
 SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
-- 
1.7.4

