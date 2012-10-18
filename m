Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab2JRKN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:13:26 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:8843
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755513Ab2JRKMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:12:51 -0400
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
Subject: [PATCH 4/4] thp: cleanup: introduce mk_huge_pmd()
Date: Thu, 18 Oct 2012 18:12:20 +0800
Message-ID: <1350555140-11030-4-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350555140-11030-1-git-send-email-lliubbo@gmail.com>
References: <1350555140-11030-1-git-send-email-lliubbo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce mk_huge_pmd() to simple code

Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 mm/huge_memory.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 3588fec..9fd1312 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -605,6 +605,15 @@ static inline pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma)
 	return pmd;
 }
 
+static inline pmd_t mk_huge_pmd(struct page *page, struct vm_area_struct *vma)
+{
+	pmd_t entry;
+	entry = mk_pmd(page, vma->vm_page_prot);
+	entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
+	entry = pmd_mkhuge(entry);
+	return entry;
+}
+
 static int __do_huge_pmd_anonymous_page(struct mm_struct *mm,
 					struct vm_area_struct *vma,
 					unsigned long haddr, pmd_t *pmd,
@@ -628,9 +637,7 @@ static int __do_huge_pmd_anonymous_page(struct mm_struct *mm,
 		pte_free(mm, pgtable);
 	} else {
 		pmd_t entry;
-		entry = mk_pmd(page, vma->vm_page_prot);
-		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
-		entry = pmd_mkhuge(entry);
+		entry = mk_huge_pmd(page, vma);
 		/*
 		 * The spinlocking to take the lru_lock inside
 		 * page_add_new_anon_rmap() acts as a full memory
@@ -950,9 +957,7 @@ int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	} else {
 		pmd_t entry;
 		VM_BUG_ON(!PageHead(page));
-		entry = mk_pmd(new_page, vma->vm_page_prot);
-		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
-		entry = pmd_mkhuge(entry);
+		entry = mk_huge_pmd(new_page, vma);
 		pmdp_clear_flush(vma, haddr, pmd);
 		page_add_new_anon_rmap(new_page, vma, haddr);
 		set_pmd_at(mm, haddr, pmd, entry);
@@ -2019,9 +2024,7 @@ static void collapse_huge_page(struct mm_struct *mm,
 	__SetPageUptodate(new_page);
 	pgtable = pmd_pgtable(_pmd);
 
-	_pmd = mk_pmd(new_page, vma->vm_page_prot);
-	_pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
-	_pmd = pmd_mkhuge(_pmd);
+	_pmd = mk_huge_pmd(new_page, vma);
 
 	/*
 	 * spin_lock() below is not the equivalent of smp_wmb(), so
-- 
1.7.9.5


