Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933768Ab3AIUkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:40:06 -0500
Received: from mail.kernel.org ([198.145.19.201]:43069 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933747Ab3AIUkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:40:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [ 077/123] sparc: huge_ptep_set_* functions need to call set_huge_pte_at()
Date: Wed,  9 Jan 2013 12:35:16 -0800
Message-Id: <20130109201508.487031855@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Dave Kleikamp <dave.kleikamp@oracle.com>

[ Upstream commit 6cb9c3697585c47977c42c5cc1b9fc49247ac530 ]

Modifying the huge pte's requires that all the underlying pte's be
modified.

Version 2: added missing flush_tlb_page()

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/include/asm/hugetlb.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/sparc/include/asm/hugetlb.h
+++ b/arch/sparc/include/asm/hugetlb.h
@@ -61,14 +61,20 @@ static inline pte_t huge_pte_wrprotect(p
 static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
 					   unsigned long addr, pte_t *ptep)
 {
-	ptep_set_wrprotect(mm, addr, ptep);
+	pte_t old_pte = *ptep;
+	set_huge_pte_at(mm, addr, ptep, pte_wrprotect(old_pte));
 }
 
 static inline int huge_ptep_set_access_flags(struct vm_area_struct *vma,
 					     unsigned long addr, pte_t *ptep,
 					     pte_t pte, int dirty)
 {
-	return ptep_set_access_flags(vma, addr, ptep, pte, dirty);
+	int changed = !pte_same(*ptep, pte);
+	if (changed) {
+		set_huge_pte_at(vma->vm_mm, addr, ptep, pte);
+		flush_tlb_page(vma, addr);
+	}
+	return changed;
 }
 
 static inline pte_t huge_ptep_get(pte_t *ptep)


