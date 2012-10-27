Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506Ab2J0VVE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 17:21:04 -0400
Received: from smtp-02.mandic.com.br ([200.225.81.133]:47712 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758620Ab2J0VVA (ORCPT
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
Subject: [PATCH 2/2] mm: do not call frontswap_init() during swapoff
Date: Sat, 27 Oct 2012 19:20:47 -0200
Message-Id: <1351372847-13625-3-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351372847-13625-1-git-send-email-cesarb@cesarb.net>
References: <1351372847-13625-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The call to frontswap_init() was added within enable_swap_info(), which
was called not only during sys_swapon, but also to reinsert the
swap_info into the swap_list in case of failure of try_to_unuse() within
sys_swapoff. This means that frontswap_init() might be called more than
once for the same swap area.

While as far as I could see no frontswap implementation has any problem
with it (and in fact, all the ones I found ignore the parameter passed
to frontswap_init), this could change in the future.

To prevent future problems, move the call to frontswap_init() to outside
the code shared between sys_swapon and sys_swapoff.

Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 mm/swapfile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 886db96..088daf4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1471,7 +1471,6 @@ static void _enable_swap_info(struct swap_info_struct *p, int prio,
 		swap_list.head = swap_list.next = p->type;
 	else
 		swap_info[prev]->next = p->type;
-	frontswap_init(p->type);
 }
 
 static void enable_swap_info(struct swap_info_struct *p, int prio,
@@ -1480,6 +1479,7 @@ static void enable_swap_info(struct swap_info_struct *p, int prio,
 {
 	spin_lock(&swap_lock);
 	_enable_swap_info(p, prio, swap_map, frontswap_map);
+	frontswap_init(p->type);
 	spin_unlock(&swap_lock);
 }
 
-- 
1.7.11.7

