Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab2JGXkw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:40:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38327 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752937Ab2JGXWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:25 -0400
Message-Id: <20121007225835.696555140@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:58:41 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Li Haifeng <omycle@gmail.com>, Gavin Shan <shangw@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.cz>, KyongHo Cho <pullip.cho@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 007/108] mm/page_alloc: fix the page address of higher pages buddy
 calculation
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Haifeng <omycle@gmail.com>

commit 0ba8f2d59304dfe69b59c034de723ad80f7ab9ac upstream.

The heuristic method for buddy has been introduced since commit
43506fad21ca ("mm/page_alloc.c: simplify calculation of combined index
of adjacent buddy lists").  But the page address of higher page's buddy
was wrongly calculated, which will lead page_is_buddy to fail for ever.
IOW, the heuristic method would be disabled with the wrong page address
of higher page's buddy.

Calculating the page address of higher page's buddy should be based
higher_page with the offset between index of higher page and index of
higher page's buddy.

Signed-off-by: Haifeng Li <omycle@gmail.com>
Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: KyongHo Cho <pullip.cho@samsung.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c66fb87..c13ea75 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -584,7 +584,7 @@ static inline void __free_one_page(struct page *page,
 		combined_idx = buddy_idx & page_idx;
 		higher_page = page + (combined_idx - page_idx);
 		buddy_idx = __find_buddy_index(combined_idx, order + 1);
-		higher_buddy = page + (buddy_idx - combined_idx);
+		higher_buddy = higher_page + (buddy_idx - combined_idx);
 		if (page_is_buddy(higher_page, higher_buddy, order + 1)) {
 			list_add_tail(&page->lru,
 				&zone->free_area[order].free_list[migratetype]);


