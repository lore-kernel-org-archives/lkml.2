Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab0IDU44 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 16:56:56 -0400
Received: from mx1.riseup.net ([204.13.164.18]:50440 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842Ab0IDU4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 16:56:55 -0400
From: Francisco Jerez <currojerez@riseup.net>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/2] x86: Fix the address space annotations of iomap_atomic_prot_pfn().
Date: Sat,  4 Sep 2010 22:56:43 +0200
Message-Id: <1283633804-11749-1-git-send-email-currojerez@riseup.net>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the sparse warnings when the return pointer of
iomap_atomic_prot_pfn() is used as an argument of iowrite32() and
friends.

Signed-off-by: Francisco Jerez <currojerez@riseup.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/iomap.h |    4 ++--
 arch/x86/mm/iomap_32.c       |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/iomap.h b/arch/x86/include/asm/iomap.h
index f35eb45..c4191b3 100644
--- a/arch/x86/include/asm/iomap.h
+++ b/arch/x86/include/asm/iomap.h
@@ -26,11 +26,11 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 
-void *
+void __iomem *
 iomap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot);
 
 void
-iounmap_atomic(void *kvaddr, enum km_type type);
+iounmap_atomic(void __iomem *kvaddr, enum km_type type);
 
 int
 iomap_create_wc(resource_size_t base, unsigned long size, pgprot_t *prot);
diff --git a/arch/x86/mm/iomap_32.c b/arch/x86/mm/iomap_32.c
index 84e236c..72fc70c 100644
--- a/arch/x86/mm/iomap_32.c
+++ b/arch/x86/mm/iomap_32.c
@@ -74,7 +74,7 @@ void *kmap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
 /*
  * Map 'pfn' using fixed map 'type' and protections 'prot'
  */
-void *
+void __iomem *
 iomap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
 {
 	/*
@@ -86,12 +86,12 @@ iomap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
 	if (!pat_enabled && pgprot_val(prot) == pgprot_val(PAGE_KERNEL_WC))
 		prot = PAGE_KERNEL_UC_MINUS;
 
-	return kmap_atomic_prot_pfn(pfn, type, prot);
+	return (void __force __iomem *) kmap_atomic_prot_pfn(pfn, type, prot);
 }
 EXPORT_SYMBOL_GPL(iomap_atomic_prot_pfn);
 
 void
-iounmap_atomic(void *kvaddr, enum km_type type)
+iounmap_atomic(void __iomem *kvaddr, enum km_type type)
 {
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
 	enum fixed_addresses idx = type + KM_TYPE_NR*smp_processor_id();
-- 
1.6.4.4

