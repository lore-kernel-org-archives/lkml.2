Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab0EQFge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 01:36:34 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48370 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab0EQFga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 01:36:30 -0400
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] Add flag to identify block swap devices
Date: Mon, 17 May 2010 11:02:42 +0530
Message-Id: <1274074364-8838-2-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1274074364-8838-1-git-send-email-ngupta@vflare.org>
References: <1274074364-8838-1-git-send-email-ngupta@vflare.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added SWP_BLKDEV flag to distinguish block and regular file backed
swap devices. We could also check if a swap is entire block device,
rather than a file, by:
S_ISBLK(swap_info_struct->swap_file->f_mapping->host->i_mode)
but, I think, simply checking this flag is more convenient.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 include/linux/swap.h |    1 +
 mm/swapfile.c        |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 1f59d93..ec2b7a4 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -146,6 +146,7 @@ enum {
 	SWP_DISCARDING	= (1 << 3),	/* now discarding a free cluster */
 	SWP_SOLIDSTATE	= (1 << 4),	/* blkdev seeks are cheap */
 	SWP_CONTINUED	= (1 << 5),	/* swap_map has count continuation */
+	SWP_BLKDEV	= (1 << 6),	/* its a block device */
 					/* add others here before... */
 	SWP_SCANNING	= (1 << 8),	/* refcount in scan_swap_map */
 };
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 6cd0a8f..ecb069e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1884,6 +1884,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		if (error < 0)
 			goto bad_swap;
 		p->bdev = bdev;
+		p->flags |= SWP_BLKDEV;
 	} else if (S_ISREG(inode->i_mode)) {
 		p->bdev = inode->i_sb->s_bdev;
 		mutex_lock(&inode->i_mutex);
-- 
1.6.6.1

