Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab1CEQwb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 11:52:31 -0500
Received: from smtp-03.mandic.com.br ([200.225.81.143]:41240 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab1CEQtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 11:49:18 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Eric B Munson <emunson@mgebm.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCHv2 12/24] sys_swapon: use a single error label
Date: Sat,  5 Mar 2011 13:42:13 -0300
Message-Id: <1299343345-3984-13-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_swapon currently has two error labels, bad_swap and bad_swap_2.
bad_swap does the same as bad_swap_2 plus destroy_swap_extents() and
swap_cgroup_swapoff(); both are noops in the places where bad_swap_2 is
jumped to. With a single extra test for inode (matching the one in the
S_ISREG case below), all the error paths in the function can go to
bad_swap.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
---
 mm/swapfile.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index ebc0307..96be104 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1918,13 +1918,13 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (IS_ERR(name)) {
 		error = PTR_ERR(name);
 		name = NULL;
-		goto bad_swap_2;
+		goto bad_swap;
 	}
 	swap_file = filp_open(name, O_RDWR|O_LARGEFILE, 0);
 	if (IS_ERR(swap_file)) {
 		error = PTR_ERR(swap_file);
 		swap_file = NULL;
-		goto bad_swap_2;
+		goto bad_swap;
 	}
 
 	p->swap_file = swap_file;
@@ -2141,13 +2141,12 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	error = 0;
 	goto out;
 bad_swap:
-	if (S_ISBLK(inode->i_mode) && p->bdev) {
+	if (inode && S_ISBLK(inode->i_mode) && p->bdev) {
 		set_blocksize(p->bdev, p->old_block_size);
 		blkdev_put(p->bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 	}
 	destroy_swap_extents(p);
 	swap_cgroup_swapoff(p->type);
-bad_swap_2:
 	spin_lock(&swap_lock);
 	p->swap_file = NULL;
 	p->flags = 0;
-- 
1.7.4

