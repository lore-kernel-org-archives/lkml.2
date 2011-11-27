Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab1K0FaJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:30:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999Ab1K0FaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:30:06 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Becky Bruce <beckyb@kernel.crashing.org>,
        Dave Carroll <dcarroll@astekcorp.com>,
        Anton Blanchard <anton@samba.org>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 05/62] powerpc: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:26:45 +0800
Message-Id: <1322371662-26166-6-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 arch/powerpc/kvm/book3s_pr.c      |    4 ++--
 arch/powerpc/mm/dma-noncoherent.c |    5 ++---
 arch/powerpc/mm/hugetlbpage.c     |    4 ++--
 arch/powerpc/mm/mem.c             |    4 ++--
 4 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 3c791e1..fbd4103 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -227,14 +227,14 @@ static void kvmppc_patch_dcbz(struct kvm_vcpu *vcpu, struct kvmppc_pte *pte)
 	hpage_offset /= 4;
 
 	get_page(hpage);
-	page = kmap_atomic(hpage, KM_USER0);
+	page = kmap_atomic(hpage);
 
 	/* patch dcbz into reserved instruction, so we trap */
 	for (i=hpage_offset; i < hpage_offset + (HW_PAGE_SIZE / 4); i++)
 		if ((page[i] & 0xff0007ff) == INS_DCBZ)
 			page[i] &= 0xfffffff7;
 
-	kunmap_atomic(page, KM_USER0);
+	kunmap_atomic(page);
 	put_page(hpage);
 }
 
diff --git a/arch/powerpc/mm/dma-noncoherent.c b/arch/powerpc/mm/dma-noncoherent.c
index 329be36..6747eec 100644
--- a/arch/powerpc/mm/dma-noncoherent.c
+++ b/arch/powerpc/mm/dma-noncoherent.c
@@ -365,12 +365,11 @@ static inline void __dma_sync_page_highmem(struct page *page,
 	local_irq_save(flags);
 
 	do {
-		start = (unsigned long)kmap_atomic(page + seg_nr,
-				KM_PPC_SYNC_PAGE) + seg_offset;
+		start = (unsigned long)kmap_atomic(page + seg_nr) + seg_offset;
 
 		/* Sync this buffer segment */
 		__dma_sync((void *)start, seg_size, direction);
-		kunmap_atomic((void *)start, KM_PPC_SYNC_PAGE);
+		kunmap_atomic((void *)start);
 		seg_nr++;
 
 		/* Calculate next buffer segment size */
diff --git a/arch/powerpc/mm/hugetlbpage.c b/arch/powerpc/mm/hugetlbpage.c
index 8558b57..85d3592 100644
--- a/arch/powerpc/mm/hugetlbpage.c
+++ b/arch/powerpc/mm/hugetlbpage.c
@@ -880,9 +880,9 @@ void flush_dcache_icache_hugepage(struct page *page)
 		if (!PageHighMem(page)) {
 			__flush_dcache_icache(page_address(page+i));
 		} else {
-			start = kmap_atomic(page+i, KM_PPC_SYNC_ICACHE);
+			start = kmap_atomic(page+i);
 			__flush_dcache_icache(start);
-			kunmap_atomic(start, KM_PPC_SYNC_ICACHE);
+			kunmap_atomic(start);
 		}
 	}
 }
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 2dd6bdd..edb8b3a 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -457,9 +457,9 @@ void flush_dcache_icache_page(struct page *page)
 #endif
 #ifdef CONFIG_BOOKE
 	{
-		void *start = kmap_atomic(page, KM_PPC_SYNC_ICACHE);
+		void *start = kmap_atomic(page);
 		__flush_dcache_icache(start);
-		kunmap_atomic(start, KM_PPC_SYNC_ICACHE);
+		kunmap_atomic(start);
 	}
 #elif defined(CONFIG_8xx) || defined(CONFIG_PPC64)
 	/* On 8xx there is no need to kmap since highmem is not supported */
-- 
1.7.4.4

