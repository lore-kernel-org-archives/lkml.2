Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab2JBPT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:19:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:26688 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236Ab2JBPTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:19:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,524,1344236400"; 
   d="scan'208";a="199642388"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v3 05/10] thp: change_huge_pmd(): keep huge zero page write-protected
Date: Tue,  2 Oct 2012 18:19:27 +0300
Message-Id: <1349191172-28855-6-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1349191172-28855-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1349191172-28855-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

We want to get page fault on write attempt to huge zero page, so let's
keep it write-protected.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
---
 mm/huge_memory.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f30f39d..d864cd4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1249,6 +1249,8 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		pmd_t entry;
 		entry = pmdp_get_and_clear(mm, addr, pmd);
 		entry = pmd_modify(entry, newprot);
+		if (is_huge_zero_pmd(entry))
+			entry = pmd_wrprotect(entry);
 		set_pmd_at(mm, addr, pmd, entry);
 		spin_unlock(&vma->vm_mm->page_table_lock);
 		ret = 1;
-- 
1.7.7.6

