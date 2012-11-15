Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768835Ab2KOT2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 14:28:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:65277 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1768765Ab2KOTZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 14:25:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,259,1352102400"; 
   d="scan'208";a="242837199"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org
Cc: Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        David Rientjes <rientjes@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v6 05/12] thp: change_huge_pmd(): keep huge zero page write-protected
Date: Thu, 15 Nov 2012 21:26:55 +0200
Message-Id: <1353007622-18393-6-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353007622-18393-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1353007622-18393-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

We want to get page fault on write attempt to huge zero page, so let's
keep it write-protected.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/huge_memory.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f5589c0..42607a1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1245,6 +1245,8 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		pmd_t entry;
 		entry = pmdp_get_and_clear(mm, addr, pmd);
 		entry = pmd_modify(entry, newprot);
+		if (is_huge_zero_pmd(entry))
+			entry = pmd_wrprotect(entry);
 		set_pmd_at(mm, addr, pmd, entry);
 		spin_unlock(&vma->vm_mm->page_table_lock);
 		ret = 1;
-- 
1.7.11.7

