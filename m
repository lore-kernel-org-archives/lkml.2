Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab0JVPnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 11:43:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757467Ab0JVPnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 11:43:52 -0400
Date: Fri, 22 Oct 2010 11:43:16 -0400
From: Dean Nelson <dnelson@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20101022154315.3643.86047.send-patch@localhost6.localdomain6>
Subject: [PATCH] Add missing spin_lock() to hugetlb_cow()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing spin_lock() of the page_table_lock before an error return in
hugetlb_cow(). Callers of hugtelb_cow() expect it to be held upon return.

Signed-off-by: Dean Nelson <dnelson@redhat.com>
CC: stable@kernel.org

---

Sorry for the noise, if there has already been a patch posted to fix this
issue. I didn't see one.

 mm/hugetlb.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c032738..8ee804b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2380,8 +2380,11 @@ retry_avoidcopy:
 	 * When the original hugepage is shared one, it does not have
 	 * anon_vma prepared.
 	 */
-	if (unlikely(anon_vma_prepare(vma)))
+	if (unlikely(anon_vma_prepare(vma))) {
+		/* Caller expects lock to be held */
+		spin_lock(&mm->page_table_lock);
 		return VM_FAULT_OOM;
+	}
 
 	copy_huge_page(new_page, old_page, address, vma);
 	__SetPageUptodate(new_page);
