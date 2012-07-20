Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab2GTHIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 03:08:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:44981 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751449Ab2GTHIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 03:08:25 -0400
X-IronPort-AV: E=Sophos;i="4.77,621,1336320000"; 
   d="scan'208";a="5444894"
Message-ID: <50090509.8000007@cn.fujitsu.com>
Date: Fri, 20 Jul 2012 15:13:13 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org
CC: rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Subject: [RFC PATCH 7/8] x86: make __split_large_page() generally avialable
References: <5009038A.4090001@cn.fujitsu.com>
In-Reply-To: <5009038A.4090001@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/20 15:09:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/20 15:09:05,
	Serialize complete at 2012/07/20 15:09:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to clear page table after calling __remove_pages(). We may
need to clear part of pmd or pud's entry when clearing the page table.
So we need to split it to small page. Make __split_large_page()
generally avialable, and we call call this function to split large page.

CC: David Rientjes <rientjes@google.com>
CC: Jiang Liu <liuj97@gmail.com>
CC: Len Brown <len.brown@intel.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 arch/x86/include/asm/pgtable_types.h |    1 +
 arch/x86/mm/pageattr.c               |   47 ++++++++++++++++++----------------
 2 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 013286a..b725af2 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -334,6 +334,7 @@ static inline void update_page_count(int level, unsigned long pages) { }
  * as a pte too.
  */
 extern pte_t *lookup_address(unsigned long address, unsigned int *level);
+extern int __split_large_page(pte_t *kpte, unsigned long address, pte_t *pbase);
 
 #endif	/* !__ASSEMBLY__ */
 
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index a718e0d..7dcb6f9 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -501,21 +501,13 @@ out_unlock:
 	return do_split;
 }
 
-static int split_large_page(pte_t *kpte, unsigned long address)
+int __split_large_page(pte_t *kpte, unsigned long address, pte_t *pbase)
 {
 	unsigned long pfn, pfninc = 1;
 	unsigned int i, level;
-	pte_t *pbase, *tmp;
+	pte_t *tmp;
 	pgprot_t ref_prot;
-	struct page *base;
-
-	if (!debug_pagealloc)
-		spin_unlock(&cpa_lock);
-	base = alloc_pages(GFP_KERNEL | __GFP_NOTRACK, 0);
-	if (!debug_pagealloc)
-		spin_lock(&cpa_lock);
-	if (!base)
-		return -ENOMEM;
+	struct page *base = virt_to_page(pbase);
 
 	spin_lock(&pgd_lock);
 	/*
@@ -523,10 +515,11 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	 * up for us already:
 	 */
 	tmp = lookup_address(address, &level);
-	if (tmp != kpte)
-		goto out_unlock;
+	if (tmp != kpte) {
+		spin_unlock(&pgd_lock);
+		return 1;
+	}
 
-	pbase = (pte_t *)page_address(base);
 	paravirt_alloc_pte(&init_mm, page_to_pfn(base));
 	ref_prot = pte_pgprot(pte_clrhuge(*kpte));
 	/*
@@ -579,17 +572,27 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	 * going on.
 	 */
 	__flush_tlb_all();
+	spin_unlock(&pgd_lock);
 
-	base = NULL;
+	return 0;
+}
 
-out_unlock:
-	/*
-	 * If we dropped out via the lookup_address check under
-	 * pgd_lock then stick the page back into the pool:
-	 */
-	if (base)
+static int split_large_page(pte_t *kpte, unsigned long address)
+{
+	pte_t *pbase;
+	struct page *base;
+
+	if (!debug_pagealloc)
+		spin_unlock(&cpa_lock);
+	base = alloc_pages(GFP_KERNEL | __GFP_NOTRACK, 0);
+	if (!debug_pagealloc)
+		spin_lock(&cpa_lock);
+	if (!base)
+		return -ENOMEM;
+
+	pbase = (pte_t *)page_address(base);
+	if (__split_large_page(kpte, address, pbase))
 		__free_page(base);
-	spin_unlock(&pgd_lock);
 
 	return 0;
 }
-- 
1.7.1

