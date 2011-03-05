Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab1CEQt7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 11:49:59 -0500
Received: from smtp-03.mandic.com.br ([200.225.81.143]:32904 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab1CEQtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 11:49:22 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Eric B Munson <emunson@mgebm.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCHv2 23/24] sys_swapoff: change order to match sys_swapon
Date: Sat,  5 Mar 2011 13:42:24 -0300
Message-Id: <1299343345-3984-24-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The block in sys_swapon which does the final adjustments to the
swap_info_struct and to swap_list is the same as the block which
re-inserts it again at sys_swapoff on failure of try_to_unuse(), except
for the order of the operations within the lock. Since the order should
not matter, arbitrarily change sys_swapoff to match sys_swapon, in
preparation to making both share the same code.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
---
 mm/swapfile.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 33f9102..c9825aa 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1625,6 +1625,10 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 		spin_lock(&swap_lock);
 		if (p->prio < 0)
 			p->prio = --least_priority;
+		p->flags |= SWP_WRITEOK;
+		nr_swap_pages += p->pages;
+		total_swap_pages += p->pages;
+
 		prev = -1;
 		for (i = swap_list.head; i >= 0; i = swap_info[i]->next) {
 			if (p->prio >= swap_info[i]->prio)
@@ -1636,9 +1640,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 			swap_list.head = swap_list.next = type;
 		else
 			swap_info[prev]->next = type;
-		nr_swap_pages += p->pages;
-		total_swap_pages += p->pages;
-		p->flags |= SWP_WRITEOK;
 		spin_unlock(&swap_lock);
 		goto out_dput;
 	}
-- 
1.7.4

