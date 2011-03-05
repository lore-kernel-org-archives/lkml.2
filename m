Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab1CEQtd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 11:49:33 -0500
Received: from smtp-03.mandic.com.br ([200.225.81.143]:36937 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab1CEQtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 11:49:23 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Eric B Munson <emunson@mgebm.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCHv2 24/24] sys_swapon: separate final enabling of the swapfile
Date: Sat,  5 Mar 2011 13:42:25 -0300
Message-Id: <1299343345-3984-25-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The block in sys_swapon which does the final adjustments to the
swap_info_struct and to swap_list is the same as the block which
re-inserts it again at sys_swapoff on failure of try_to_unuse(). Move
this code to a separate function, and use it both in sys_swapon and
sys_swapoff.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
---
 mm/swapfile.c |   84 ++++++++++++++++++++++++++++----------------------------
 1 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index c9825aa..49eb310 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1550,6 +1550,36 @@ bad_bmap:
 	goto out;
 }
 
+static void enable_swap_info(struct swap_info_struct *p, int prio,
+				unsigned char *swap_map)
+{
+	int i, prev;
+
+	spin_lock(&swap_lock);
+	if (prio >= 0)
+		p->prio = prio;
+	else
+		p->prio = --least_priority;
+	p->swap_map = swap_map;
+	p->flags |= SWP_WRITEOK;
+	nr_swap_pages += p->pages;
+	total_swap_pages += p->pages;
+
+	/* insert swap space into swap_list: */
+	prev = -1;
+	for (i = swap_list.head; i >= 0; i = swap_info[i]->next) {
+		if (p->prio >= swap_info[i]->prio)
+			break;
+		prev = i;
+	}
+	p->next = i;
+	if (prev < 0)
+		swap_list.head = swap_list.next = p->type;
+	else
+		swap_info[prev]->next = p->type;
+	spin_unlock(&swap_lock);
+}
+
 SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
 	struct swap_info_struct *p = NULL;
@@ -1621,26 +1651,14 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	current->flags &= ~PF_OOM_ORIGIN;
 
 	if (err) {
+		/*
+		 * reading p->prio and p->swap_map outside the lock is
+		 * safe here because only sys_swapon and sys_swapoff
+		 * change them, and there can be no other sys_swapon or
+		 * sys_swapoff for this swap_info_struct at this point.
+		 */
 		/* re-insert swap space back into swap_list */
-		spin_lock(&swap_lock);
-		if (p->prio < 0)
-			p->prio = --least_priority;
-		p->flags |= SWP_WRITEOK;
-		nr_swap_pages += p->pages;
-		total_swap_pages += p->pages;
-
-		prev = -1;
-		for (i = swap_list.head; i >= 0; i = swap_info[i]->next) {
-			if (p->prio >= swap_info[i]->prio)
-				break;
-			prev = i;
-		}
-		p->next = i;
-		if (prev < 0)
-			swap_list.head = swap_list.next = type;
-		else
-			swap_info[prev]->next = type;
-		spin_unlock(&swap_lock);
+		enable_swap_info(p, p->prio, p->swap_map);
 		goto out_dput;
 	}
 
@@ -2037,7 +2055,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	char *name;
 	struct file *swap_file = NULL;
 	struct address_space *mapping;
-	int i, prev;
+	int i;
+	int prio;
 	int error;
 	union swap_header *swap_header;
 	int nr_extents;
@@ -2134,30 +2153,11 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	}
 
 	mutex_lock(&swapon_mutex);
-	spin_lock(&swap_lock);
+	prio = -1;
 	if (swap_flags & SWAP_FLAG_PREFER)
-		p->prio =
+		prio =
 		  (swap_flags & SWAP_FLAG_PRIO_MASK) >> SWAP_FLAG_PRIO_SHIFT;
-	else
-		p->prio = --least_priority;
-	p->swap_map = swap_map;
-	p->flags |= SWP_WRITEOK;
-	nr_swap_pages += p->pages;
-	total_swap_pages += p->pages;
-
-	/* insert swap space into swap_list: */
-	prev = -1;
-	for (i = swap_list.head; i >= 0; i = swap_info[i]->next) {
-		if (p->prio >= swap_info[i]->prio)
-			break;
-		prev = i;
-	}
-	p->next = i;
-	if (prev < 0)
-		swap_list.head = swap_list.next = p->type;
-	else
-		swap_info[prev]->next = p->type;
-	spin_unlock(&swap_lock);
+	enable_swap_info(p, prio, swap_map);
 
 	printk(KERN_INFO "Adding %uk swap on %s.  "
 			"Priority:%d extents:%d across:%lluk %s%s\n",
-- 
1.7.4

