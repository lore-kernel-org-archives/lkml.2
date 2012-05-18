Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031102Ab2ERDGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:06:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40463 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762559Ab2ERCwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:33 -0400
Message-Id: <20120518023255.315413519@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:01 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Metcalf <cmetcalf@tilera.com>,
        Mel Gorman <mel@csn.ul.ie>, Hillf Danton <dhillf@gmail.com>,
        Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [ 07/53] hugetlb: prevent BUG_ON in hugetlb_fault() -> hugetlb_cow()
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Metcalf <cmetcalf@tilera.com>

commit 4998a6c0edce7fae9c0a5463f6ec3fa585258ee7 upstream.

Commit 66aebce747eaf ("hugetlb: fix race condition in hugetlb_fault()")
added code to avoid a race condition by elevating the page refcount in
hugetlb_fault() while calling hugetlb_cow().

However, one code path in hugetlb_cow() includes an assertion that the
page count is 1, whereas it may now also have the value 2 in this path.

The consensus is that this BUG_ON has served its purpose, so rather than
extending it to cover both cases, we just remove it.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Hillf Danton <dhillf@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/hugetlb.c |    1 -
 1 file changed, 1 deletion(-)

--- linux.orig/mm/hugetlb.c
+++ linux/mm/hugetlb.c
@@ -2405,7 +2405,6 @@
 		if (outside_reserve) {
 			BUG_ON(huge_pte_none(pte));
 			if (unmap_ref_private(mm, vma, old_page, address)) {
-				BUG_ON(page_count(old_page) != 1);
 				BUG_ON(huge_pte_none(pte));
 				spin_lock(&mm->page_table_lock);
 				goto retry_avoidcopy;



