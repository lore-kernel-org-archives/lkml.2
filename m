Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524Ab2J0VVG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 17:21:06 -0400
Received: from smtp-02.mandic.com.br ([200.225.81.133]:46793 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758625Ab2J0VVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 17:21:00 -0400
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH 1/2] mm: refactor reinsert of swap_info in sys_swapoff
Date: Sat, 27 Oct 2012 19:20:46 -0200
Message-Id: <1351372847-13625-2-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351372847-13625-1-git-send-email-cesarb@cesarb.net>
References: <1351372847-13625-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The block within sys_swapoff which re-inserts the swap_info into the
swap_list in case of failure of try_to_unuse() reads a few values outside
the swap_lock. While this is safe at that point, it is subtle code.

Simplify the code by moving the reading of these values to a separate
function, refactoring it a bit so they are read from within the
swap_lock. This is easier to understand, and matches better the way it
worked before I unified the insertion of the swap_info from both
sys_swapon and sys_swapoff.

This change should make no functional difference. The only real change
is moving the read of two or three structure fields to within the lock
(frontswap_map_get() is nothing more than a read of p->frontswap_map).

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 mm/swapfile.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 71cd288..886db96 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1443,13 +1443,12 @@ static int setup_swap_extents(struct swap_info_struct *sis, sector_t *span)
 	return generic_swapfile_activate(sis, swap_file, span);
 }
 
-static void enable_swap_info(struct swap_info_struct *p, int prio,
+static void _enable_swap_info(struct swap_info_struct *p, int prio,
 				unsigned char *swap_map,
 				unsigned long *frontswap_map)
 {
 	int i, prev;
 
-	spin_lock(&swap_lock);
 	if (prio >= 0)
 		p->prio = prio;
 	else
@@ -1473,6 +1472,21 @@ static void enable_swap_info(struct swap_info_struct *p, int prio,
 	else
 		swap_info[prev]->next = p->type;
 	frontswap_init(p->type);
+}
+
+static void enable_swap_info(struct swap_info_struct *p, int prio,
+				unsigned char *swap_map,
+				unsigned long *frontswap_map)
+{
+	spin_lock(&swap_lock);
+	_enable_swap_info(p, prio, swap_map, frontswap_map);
+	spin_unlock(&swap_lock);
+}
+
+static void reinsert_swap_info(struct swap_info_struct *p)
+{
+	spin_lock(&swap_lock);
+	_enable_swap_info(p, p->prio, p->swap_map, frontswap_map_get(p));
 	spin_unlock(&swap_lock);
 }
 
@@ -1549,14 +1563,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	compare_swap_oom_score_adj(OOM_SCORE_ADJ_MAX, oom_score_adj);
 
 	if (err) {
-		/*
-		 * reading p->prio and p->swap_map outside the lock is
-		 * safe here because only sys_swapon and sys_swapoff
-		 * change them, and there can be no other sys_swapon or
-		 * sys_swapoff for this swap_info_struct at this point.
-		 */
 		/* re-insert swap space back into swap_list */
-		enable_swap_info(p, p->prio, p->swap_map, frontswap_map_get(p));
+		reinsert_swap_info(p);
 		goto out_dput;
 	}
 
-- 
1.7.11.7

