Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab1CEQtR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 11:49:17 -0500
Received: from smtp-03.mandic.com.br ([200.225.81.143]:59677 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab1CEQtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 11:49:16 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Mar 2011 11:49:15 EST
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Eric B Munson <emunson@mgebm.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCHv2 03/24] sys_swapon: do not depend on "type" after allocation
Date: Sat,  5 Mar 2011 13:42:04 -0300
Message-Id: <1299343345-3984-4-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Within sys_swapon, after the swap_info entry has been allocated, we
always have type == p->type and swap_info[type] == p. Use this fact to
reduce the dependency on the "type" local variable within the function,
as a preparation to move the allocation of the swap_info entry to a
separate function.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
---
 mm/swapfile.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 75ee39c..3ef2d67 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1927,7 +1927,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	for (i = 0; i < nr_swapfiles; i++) {
 		struct swap_info_struct *q = swap_info[i];
 
-		if (i == type || !q->swap_file)
+		if (q == p || !q->swap_file)
 			continue;
 		if (mapping == q->swap_file->f_mapping)
 			goto bad_swap;
@@ -2062,7 +2062,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		}
 	}
 
-	error = swap_cgroup_swapon(type, maxpages);
+	error = swap_cgroup_swapon(p->type, maxpages);
 	if (error)
 		goto bad_swap;
 
@@ -2120,9 +2120,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	}
 	p->next = i;
 	if (prev < 0)
-		swap_list.head = swap_list.next = type;
+		swap_list.head = swap_list.next = p->type;
 	else
-		swap_info[prev]->next = type;
+		swap_info[prev]->next = p->type;
 	spin_unlock(&swap_lock);
 	mutex_unlock(&swapon_mutex);
 	atomic_inc(&proc_poll_event);
@@ -2136,7 +2136,7 @@ bad_swap:
 		blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 	}
 	destroy_swap_extents(p);
-	swap_cgroup_swapoff(type);
+	swap_cgroup_swapoff(p->type);
 bad_swap_2:
 	spin_lock(&swap_lock);
 	p->swap_file = NULL;
-- 
1.7.4

