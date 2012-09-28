Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032353Ab2I1UZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:25:41 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:48962 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032337Ab2I1UZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:25:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Haifeng Li <omycle@gmail.com>, Gavin Shan <shangw@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.cz>, KyongHo Cho <pullip.cho@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 076/218] mm/page_alloc: fix the page address of higher pages buddy calculation
Date: Fri, 28 Sep 2012 13:14:53 -0700
Message-Id: <20120928201510.291909574@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -579,7 +579,7 @@ static inline void __free_one_page(struc
 		combined_idx = buddy_idx & page_idx;
 		higher_page = page + (combined_idx - page_idx);
 		buddy_idx = __find_buddy_index(combined_idx, order + 1);
-		higher_buddy = page + (buddy_idx - combined_idx);
+		higher_buddy = higher_page + (buddy_idx - combined_idx);
 		if (page_is_buddy(higher_page, higher_buddy, order + 1)) {
 			list_add_tail(&page->lru,
 				&zone->free_area[order].free_list[migratetype]);


