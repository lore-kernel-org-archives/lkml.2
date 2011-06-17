Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828Ab1FQI6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:58:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46714 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757698Ab1FQI5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:57:18 -0400
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE LINUX, s.r.o.
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 03/10] x86: translate highmem /dev/mem pointers
Date: Fri, 17 Jun 2011 10:45:01 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc2-0.0.5.bd76874-default; KDE/4.6.0; i686; ; )
References: <201106171038.25988.ptesarik@suse.cz>
In-Reply-To: <201106171038.25988.ptesarik@suse.cz>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106171045.01928.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 32-bit x86, it is necessary to kmap/kunmap /dev/mem pointers in
the high memory area.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 arch/x86/include/asm/io.h |    4 ++--
 arch/x86/mm/ioremap.c     |   24 ++++++++++++++++++------
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index d02804d..9b994dd 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -311,8 +311,8 @@ BUILDIO(b, b, char)
 BUILDIO(w, w, short)
 BUILDIO(l, , int)
 
-extern void *xlate_dev_mem_ptr(unsigned long phys);
-extern void unxlate_dev_mem_ptr(unsigned long phys, void *addr);
+extern void *xlate_dev_mem_ptr(phys_addr_t phys);
+extern void unxlate_dev_mem_ptr(phys_addr_t phys, void *addr);
 
 extern int ioremap_change_attr(unsigned long vaddr, unsigned long size,
 				unsigned long prot_val);
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index be1ef57..fb566d7 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -308,26 +308,38 @@ EXPORT_SYMBOL(iounmap);
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
  * access
  */
-void *xlate_dev_mem_ptr(unsigned long phys)
+void *xlate_dev_mem_ptr(phys_addr_t phys)
 {
 	void *addr;
-	unsigned long start = phys & PAGE_MASK;
+	unsigned long pfn = phys >> PAGE_SHIFT;
+	phys_addr_t start = phys & ~((phys_addr_t)PAGE_SIZE-1);
 
 	/* If page is RAM, we can use __va. Otherwise ioremap and unmap. */
-	if (page_is_ram(start >> PAGE_SHIFT))
+	if (page_is_ram(pfn)) {
+		if (phys >= __pa(high_memory))
+			return pfn_valid(pfn)
+				? kmap(pfn_to_page(pfn))
+				: NULL;
 		return __va(phys);
+	}
 
 	addr = (void __force *)ioremap_cache(start, PAGE_SIZE);
 	if (addr)
-		addr = (void *)((unsigned long)addr | (phys & ~PAGE_MASK));
+		addr = (void *)((unsigned long)addr |
+			((unsigned long)phys & ~PAGE_MASK));
 
 	return addr;
 }
 
-void unxlate_dev_mem_ptr(unsigned long phys, void *addr)
+void unxlate_dev_mem_ptr(phys_addr_t phys, void *addr)
 {
-	if (page_is_ram(phys >> PAGE_SHIFT))
+	unsigned long pfn = phys >> PAGE_SHIFT;
+
+	if (page_is_ram(pfn)) {
+		if (phys >= __pa(high_memory))
+			kunmap(pfn_to_page(pfn));
 		return;
+	}
 
 	iounmap((void __iomem *)((unsigned long)addr & PAGE_MASK));
 	return;
-- 
1.7.3.4
