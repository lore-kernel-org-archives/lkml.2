Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab1HHLHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 07:07:10 -0400
Received: from relay.parallels.com ([195.214.232.42]:55634 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab1HHLHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 07:07:07 -0400
Subject: [PATCH 1/2] vmscan: promote shared file mapped pages
To: <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Date: Mon, 8 Aug 2011 15:06:58 +0400
Message-ID: <20110808110658.31053.55013.stgit@localhost6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit v2.6.33-5448-g6457474 (vmscan: detect mapped file pages used only once)
greatly decreases lifetime of single-used mapped file pages.
Unfortunately it also decreases life time of all shared mapped file pages.
Because after commit v2.6.28-6130-gbf3f3bc (mm: don't mark_page_accessed in fault path)
page-fault handler does not mark page active or even referenced.

Thus page_check_references() activates file page only if it was used twice while
it stays in inactive list, meanwhile it activates anon pages after first access.
Inactive list can be small enough, this way reclaimer can accidentally
throw away any widely used page if it wasn't used twice in short period.

After this patch page_check_references() also activate file mapped page at first
inactive list scan if this page is already used multiple times via several ptes.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/vmscan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 47403c9..3cd766d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -724,7 +724,7 @@ static enum page_references page_check_references(struct page *page,
 		 */
 		SetPageReferenced(page);
 
-		if (referenced_page)
+		if (referenced_page || referenced_ptes > 1)
 			return PAGEREF_ACTIVATE;
 
 		return PAGEREF_KEEP;

