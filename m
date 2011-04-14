Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933865Ab1DNSXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:23:12 -0400
Received: from mail.windriver.com ([147.11.1.11]:38261 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933071Ab1DNRqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:38 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 038/209] mm: fix is_mem_section_removable() page_order BUG_ON check
Date: Thu, 14 Apr 2011 13:41:08 -0400
Message-Id: <1302803039-9400-39-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/internal.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 6a697bb..dedb0af 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -62,7 +62,7 @@ extern bool is_free_buddy_page(struct page *page);
  */
 static inline unsigned long page_order(struct page *page)
 {
-	VM_BUG_ON(!PageBuddy(page));
+	/* PageBuddy() must be checked by the caller */
 	return page_private(page);
 }
 
-- 
1.7.4.4

