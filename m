Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215Ab2ILXnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:43:21 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37074 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933165Ab2ILXm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:42:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 04/46] ARM: 7487/1: mm: avoid setting nG bit for user mappings that arent present
Date: Wed, 12 Sep 2012 16:38:54 -0700
Message-Id: <20120912233818.129132756@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233817.662663809@linuxfoundation.org>
References: <20120912233817.662663809@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/pgtable.h |   34 ++++++++++++++++++----------------
 arch/arm/mm/flush.c            |    2 --
 2 files changed, 18 insertions(+), 18 deletions(-)

--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -360,6 +360,18 @@ static inline pte_t *pmd_page_vaddr(pmd_
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
@@ -371,25 +383,15 @@ extern void __sync_icache_dcache(pte_t p
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


