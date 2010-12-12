Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab0LMAR7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:17:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35920 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab0LLXqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:13 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: kamezawa.hiroyu@jp.fujitsu.com, fengguang.wu@intel.com, mhocko@suse.cz,
        mel@csn.ul.ie, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [73/223] mm: fix is_mem_section_removable() page_order BUG_ON check
Message-Id: <20101212234611.D7615B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:11 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

commit 572438f9b52236bd8938b1647cc15e027d27ef55 upstream.

page_order() is called by memory hotplug's user interface to check the
section is removable or not.  (is_mem_section_removable())

It calls page_order() withoug holding zone->lock.
So, even if the caller does

	if (PageBuddy(page))
		ret = page_order(page) ...
The caller may hit BUG_ON().

For fixing this, there are 2 choices.
  1. add zone->lock.
  2. remove BUG_ON().

is_mem_section_removable() is used for some "advice" and doesn't need to
be 100% accurate.  This is_removable() can be called via user program..
We don't want to take this important lock for long by user's request.  So,
this patch removes BUG_ON().

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/mm/internal.h
===================================================================
--- linux.orig/mm/internal.h
+++ linux/mm/internal.h
@@ -62,7 +62,7 @@ extern bool is_free_buddy_page(struct pa
  */
 static inline unsigned long page_order(struct page *page)
 {
-	VM_BUG_ON(!PageBuddy(page));
+	/* PageBuddy() must be checked by the caller */
 	return page_private(page);
 }
 
