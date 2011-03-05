Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab1CEQxg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 11:53:36 -0500
Received: from smtp-03.mandic.com.br ([200.225.81.143]:42113 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab1CEQtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 11:49:18 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Eric B Munson <emunson@mgebm.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCHv2 08/24] sys_swapon: move setting of error nearer use
Date: Sat,  5 Mar 2011 13:42:09 -0300
Message-Id: <1299343345-3984-9-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the setting of the error variable nearer the goto in a few places.

Avoids calling PTR_ERR() if not IS_ERR() in two places, and makes the
error condition more explicit in two other places.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
---
 mm/swapfile.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 8893c10..55a50ef 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1917,14 +1917,14 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		return PTR_ERR(p);
 
 	name = getname(specialfile);
-	error = PTR_ERR(name);
 	if (IS_ERR(name)) {
+		error = PTR_ERR(name);
 		name = NULL;
 		goto bad_swap_2;
 	}
 	swap_file = filp_open(name, O_RDWR|O_LARGEFILE, 0);
-	error = PTR_ERR(swap_file);
 	if (IS_ERR(swap_file)) {
+		error = PTR_ERR(swap_file);
 		swap_file = NULL;
 		goto bad_swap_2;
 	}
@@ -1933,17 +1933,17 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	mapping = swap_file->f_mapping;
 	inode = mapping->host;
 
-	error = -EBUSY;
 	for (i = 0; i < nr_swapfiles; i++) {
 		struct swap_info_struct *q = swap_info[i];
 
 		if (q == p || !q->swap_file)
 			continue;
-		if (mapping == q->swap_file->f_mapping)
+		if (mapping == q->swap_file->f_mapping) {
+			error = -EBUSY;
 			goto bad_swap;
+		}
 	}
 
-	error = -EINVAL;
 	if (S_ISBLK(inode->i_mode)) {
 		bdev = bdgrab(I_BDEV(inode));
 		error = blkdev_get(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL,
@@ -1968,6 +1968,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 			goto bad_swap;
 		}
 	} else {
+		error = -EINVAL;
 		goto bad_swap;
 	}
 
-- 
1.7.4

