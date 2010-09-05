Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab0IENEV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 09:04:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:53060 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881Ab0IENEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 09:04:20 -0400
Date: Sun, 5 Sep 2010 13:03:53 GMT
From: tip-bot for Francisco Jerez <currojerez@riseup.net>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        akpm@linux-foundation.org, currojerez@riseup.net, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, currojerez@riseup.net, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1283633804-11749-1-git-send-email-currojerez@riseup.net>
References: <1283633804-11749-1-git-send-email-currojerez@riseup.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix the address space annotations of iomap_atomic_prot_pfn()
Message-ID: <tip-cc1a8e523333bc3d990102140f4d12908fa83caf@git.kernel.org>
Git-Commit-ID: cc1a8e523333bc3d990102140f4d12908fa83caf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 05 Sep 2010 13:03:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc1a8e523333bc3d990102140f4d12908fa83caf
Gitweb:     http://git.kernel.org/tip/cc1a8e523333bc3d990102140f4d12908fa83caf
Author:     Francisco Jerez <currojerez@riseup.net>
AuthorDate: Sat, 4 Sep 2010 22:56:43 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 5 Sep 2010 14:26:14 +0200

x86: Fix the address space annotations of iomap_atomic_prot_pfn()

This patch fixes the sparse warnings when the return pointer of
iomap_atomic_prot_pfn() is used as an argument of iowrite32()
and friends.

Signed-off-by: Francisco Jerez <currojerez@riseup.net>
LKML-Reference: <1283633804-11749-1-git-send-email-currojerez@riseup.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
