Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab0LHAq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:46:58 -0500
Received: from kroah.org ([198.145.64.141]:45943 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729Ab0LHAqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:46:49 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:26 2010
Message-Id: <20101208004426.684250970@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mel@csn.ul.ie>
Subject: [023/127] mm: fix is_mem_section_removable() page_order BUG_ON check
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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

---
 mm/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/internal.h
+++ b/mm/internal.h
@@ -59,7 +59,7 @@ extern void prep_compound_page(struct pa
  */
 static inline unsigned long page_order(struct page *page)
 {
-	VM_BUG_ON(!PageBuddy(page));
+	/* PageBuddy() must be checked by the caller */
 	return page_private(page);
 }
 


