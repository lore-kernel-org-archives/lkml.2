Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab2IQAuo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:50:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33425 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753102Ab2IQAtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:43 -0400
Message-Id: <20120917003637.706801413@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:48 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 083/135] ARM: 7487/1: mm: avoid setting nG bit for user mappings that arent
 present
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 47f1204329237a0f8655f5a9f14a38ac81946ca1 upstream.

Swap entries are encoding in ptes such that !pte_present(pte) and
pte_file(pte). The remaining bits of the descriptor are used to identify
the swapfile and offset within it to the swap entry.

When writing such a pte for a user virtual address, set_pte_at
unconditionally sets the nG bit, which (in the case of LPAE) will
corrupt the swapfile offset and lead to a BUG:

[  140.494067] swap_free: Unused swap offset entry 000763b4
[  140.509989] BUG: Bad page map in process rs:main Q:Reg  pte:0ec76800 pmd:8f92e003

This patch fixes the problem by only setting the nG bit for user
mappings that are actually present.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/include/asm/pgtable.h |   34 ++++++++++++++++++----------------
 arch/arm/mm/flush.c            |    2 --
 2 files changed, 18 insertions(+), 18 deletions(-)

--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -232,6 +232,18 @@ static inline pte_t *pmd_page_vaddr(pmd_
 #define set_pte_ext(ptep,pte,ext) cpu_set_pte_ext(ptep,pte,ext)
 #define pte_clear(mm,addr,ptep)	set_pte_ext(ptep, __pte(0), 0)
 
+#define pte_none(pte)		(!pte_val(pte))
+#define pte_present(pte)	(pte_val(pte) & L_PTE_PRESENT)
+#define pte_write(pte)		(!(pte_val(pte) & L_PTE_RDONLY))
+#define pte_dirty(pte)		(pte_val(pte) & L_PTE_DIRTY)
+#define pte_young(pte)		(pte_val(pte) & L_PTE_YOUNG)
+#define pte_exec(pte)		(!(pte_val(pte) & L_PTE_XN))
+#define pte_special(pte)	(0)
+
+#define pte_present_user(pte) \
+	((pte_val(pte) & (L_PTE_PRESENT | L_PTE_USER)) == \
+	 (L_PTE_PRESENT | L_PTE_USER))
+
 #if __LINUX_ARM_ARCH__ < 6
 static inline void __sync_icache_dcache(pte_t pteval)
 {
@@ -243,25 +255,15 @@ extern void __sync_icache_dcache(pte_t p
 static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep, pte_t pteval)
 {
-	if (addr >= TASK_SIZE)
-		set_pte_ext(ptep, pteval, 0);
-	else {
+	unsigned long ext = 0;
+
+	if (addr < TASK_SIZE && pte_present_user(pteval)) {
 		__sync_icache_dcache(pteval);
-		set_pte_ext(ptep, pteval, PTE_EXT_NG);
+		ext |= PTE_EXT_NG;
 	}
-}
 
-#define pte_none(pte)		(!pte_val(pte))
-#define pte_present(pte)	(pte_val(pte) & L_PTE_PRESENT)
-#define pte_write(pte)		(!(pte_val(pte) & L_PTE_RDONLY))
-#define pte_dirty(pte)		(pte_val(pte) & L_PTE_DIRTY)
-#define pte_young(pte)		(pte_val(pte) & L_PTE_YOUNG)
-#define pte_exec(pte)		(!(pte_val(pte) & L_PTE_XN))
-#define pte_special(pte)	(0)
-
-#define pte_present_user(pte) \
-	((pte_val(pte) & (L_PTE_PRESENT | L_PTE_USER)) == \
-	 (L_PTE_PRESENT | L_PTE_USER))
+	set_pte_ext(ptep, pteval, ext);
+}
 
 #define PTE_BIT_FUNC(fn,op) \
 static inline pte_t pte_##fn(pte_t pte) { pte_val(pte) op; return pte; }
--- a/arch/arm/mm/flush.c
+++ b/arch/arm/mm/flush.c
@@ -236,8 +236,6 @@ void __sync_icache_dcache(pte_t pteval)
 	struct page *page;
 	struct address_space *mapping;
 
-	if (!pte_present_user(pteval))
-		return;
 	if (cache_is_vipt_nonaliasing() && !pte_exec(pteval))
 		/* only flush non-aliasing VIPT caches for exec mappings */
 		return;


