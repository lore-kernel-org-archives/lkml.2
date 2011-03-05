Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab1CEQtp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 11:49:45 -0500
Received: from smtp-03.mandic.com.br ([200.225.81.143]:45824 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab1CEQtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 11:49:23 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Eric B Munson <emunson@mgebm.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCHv2 22/24] sys_swapon: move printk outside lock
Date: Sat,  5 Mar 2011 13:42:23 -0300
Message-Id: <1299343345-3984-23-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The block in sys_swapon which does the final adjustments to the
swap_info_struct and to swap_list is the same as the block which
re-inserts it again at sys_swapoff on failure of try_to_unuse(). To be
able to make both share the same code, move the printk() call in the
middle of it to just after it.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
---
 mm/swapfile.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 369816d..33f9102 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2144,13 +2144,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	nr_swap_pages += p->pages;
 	total_swap_pages += p->pages;
 
-	printk(KERN_INFO "Adding %uk swap on %s.  "
-			"Priority:%d extents:%d across:%lluk %s%s\n",
-		p->pages<<(PAGE_SHIFT-10), name, p->prio,
-		nr_extents, (unsigned long long)span<<(PAGE_SHIFT-10),
-		(p->flags & SWP_SOLIDSTATE) ? "SS" : "",
-		(p->flags & SWP_DISCARDABLE) ? "D" : "");
-
 	/* insert swap space into swap_list: */
 	prev = -1;
 	for (i = swap_list.head; i >= 0; i = swap_info[i]->next) {
@@ -2164,6 +2157,14 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	else
 		swap_info[prev]->next = p->type;
 	spin_unlock(&swap_lock);
+
+	printk(KERN_INFO "Adding %uk swap on %s.  "
+			"Priority:%d extents:%d across:%lluk %s%s\n",
+		p->pages<<(PAGE_SHIFT-10), name, p->prio,
+		nr_extents, (unsigned long long)span<<(PAGE_SHIFT-10),
+		(p->flags & SWP_SOLIDSTATE) ? "SS" : "",
+		(p->flags & SWP_DISCARDABLE) ? "D" : "");
+
 	mutex_unlock(&swapon_mutex);
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
-- 
1.7.4

