Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225Ab0E0WB5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:01:57 -0400
Received: from mail1.cray.com ([136.162.62.100]:47171 "EHLO mail1.cray.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933168Ab0E0WBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:01:55 -0400
X-Greylist: delayed 4650 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 May 2010 18:01:52 EDT
Message-ID: <4BFED954.8060807@cray.com>
Date: Thu, 27 May 2010 13:43:00 -0700
From: Doug Doan <dougd@cray.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org, andi@firstfloor.org, lee.schermerhorn@hp.com,
       rientjes@google.com, mel@csn.ul.ie, akpm@linux-foundation.org
Subject: [PATCH] hugetlb: call mmu notifiers on hugepage cow
Content-Type: multipart/mixed;
	boundary="------------000008070908080203040308"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------000008070908080203040308
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

From: Doug Doan <dougd@cray.com>

When a copy-on-write occurs, we take one of two paths in handle_mm_fault: 
through handle_pte_fault for normal pages, or through hugetlb_fault for huge pages.

In the normal page case, we eventually get to do_wp_page and call mmu notifiers 
via ptep_clear_flush_notify. There is no callout to the mmmu notifiers in the 
huge page case. This patch fixes that.

Signed-off-by: Doug Doan <dougd@cray.com>
---

--------------000008070908080203040308
Content-Type: text/plain; name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="patch"

--- mm/hugetlb.c.orig	2010-05-27 13:07:58.569546314 -0700
+++ mm/hugetlb.c	2010-05-26 14:41:06.449296524 -0700
@@ -2345,11 +2345,17 @@ retry_avoidcopy:
 	ptep = huge_pte_offset(mm, address & huge_page_mask(h));
 	if (likely(pte_same(huge_ptep_get(ptep), pte))) {
 		/* Break COW */
+		mmu_notifier_invalidate_range_start(mm,
+			address & huge_page_mask(h),
+			(address & huge_page_mask(h)) + huge_page_size(h));
 		huge_ptep_clear_flush(vma, address, ptep);
 		set_huge_pte_at(mm, address, ptep,
 				make_huge_pte(vma, new_page, 1));
 		/* Make the old page be freed below */
 		new_page = old_page;
+		mmu_notifier_invalidate_range_end(mm,
+			address & huge_page_mask(h),
+			(address & huge_page_mask(h)) + huge_page_size(h));
 	}
 	page_cache_release(new_page);
 	page_cache_release(old_page);

--------------000008070908080203040308--
