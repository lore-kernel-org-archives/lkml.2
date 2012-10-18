Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab2JRKM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:12:56 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:26615 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755527Ab2JRKMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:12:53 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: 17
X-BigFish: VS17(zzzz1ce5h1202h1d1ah1cabh1d2ahzz8275bhz2ei87h2a8h668h839hd24he5bh107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h13eah1441h14ddhff4m129fs1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Bob Liu <lliubbo@gmail.com>
To: <akpm@linux-foundation.org>
CC: <aarcange@redhat.com>, <xiaoguangrong@linux.vnet.ibm.com>,
        <hughd@google.com>, <rientjes@google.com>,
        <linux-kernel@vger.kernel.org>, <kirill.shutemov@linux.intel.com>,
        Bob Liu <lliubbo@gmail.com>
Subject: [PATCH 3/4] thp: introduce hugepage_vma_check()
Date: Thu, 18 Oct 2012 18:12:19 +0800
Message-ID: <1350555140-11030-3-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350555140-11030-1-git-send-email-lliubbo@gmail.com>
References: <1350555140-11030-1-git-send-email-lliubbo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multi place do the same check.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 mm/huge_memory.c |   38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e575b29..3588fec 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1913,6 +1913,20 @@ static struct page
 }
 #endif
 
+static bool hugepage_vma_check(struct vm_area_struct *vma)
+{
+	if ((!(vma->vm_flags & VM_HUGEPAGE) && !khugepaged_always()) ||
+	    (vma->vm_flags & VM_NOHUGEPAGE))
+		return false;
+
+	if (!vma->anon_vma || vma->vm_ops)
+		return false;
+	if (is_vma_temporary_stack(vma))
+		return false;
+	VM_BUG_ON(vma->vm_flags & VM_NO_THP);
+	return true;
+}
+
 static void collapse_huge_page(struct mm_struct *mm,
 				   unsigned long address,
 				   struct page **hpage,
@@ -1953,17 +1967,8 @@ static void collapse_huge_page(struct mm_struct *mm,
 	hend = vma->vm_end & HPAGE_PMD_MASK;
 	if (address < hstart || address + HPAGE_PMD_SIZE > hend)
 		goto out;
-
-	if ((!(vma->vm_flags & VM_HUGEPAGE) && !khugepaged_always()) ||
-	    (vma->vm_flags & VM_NOHUGEPAGE))
-		goto out;
-
-	if (!vma->anon_vma || vma->vm_ops)
-		goto out;
-	if (is_vma_temporary_stack(vma))
+	if (!hugepage_vma_check(vma))
 		goto out;
-	VM_BUG_ON(vma->vm_flags & VM_NO_THP);
-
 	pmd = hugepage_get_pmd(mm, address);
 	if (!pmd)
 		goto out;
@@ -2171,20 +2176,11 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages,
 			progress++;
 			break;
 		}
-
-		if ((!(vma->vm_flags & VM_HUGEPAGE) &&
-		     !khugepaged_always()) ||
-		    (vma->vm_flags & VM_NOHUGEPAGE)) {
-		skip:
+		if (!hugepage_vma_check(vma)) {
+skip:
 			progress++;
 			continue;
 		}
-		if (!vma->anon_vma || vma->vm_ops)
-			goto skip;
-		if (is_vma_temporary_stack(vma))
-			goto skip;
-		VM_BUG_ON(vma->vm_flags & VM_NO_THP);
-
 		hstart = (vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
 		hend = vma->vm_end & HPAGE_PMD_MASK;
 		if (hstart >= hend)
-- 
1.7.9.5


