Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759847Ab0FKJT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 05:19:28 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46558 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757706Ab0FKJT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 05:19:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C11FF70.5080909@jp.fujitsu.com>
Date: Fri, 11 Jun 2010 18:18:40 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
CC: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: [PATCH 1/4] x86: ioremap: fix wrong address masking
References: <4C11FF10.4060203@jp.fujitsu.com>
In-Reply-To: <4C11FF10.4060203@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current x86 ioremap() doesn't handle physical address higher than
32-bit properly in X86_32 PAE mode. When physical address higher than
32-bit is passed to ioremap(), higher 32-bits in physical address is
cleared wrongly. Due to this bug, ioremap() can map wrong address to
linear address space.

In my case, 64-bit MMIO region was assigned to a PCI device (ioat
device) on my system. Because of the ioremap()'s bug, wrong physical
address (instead of MMIO region) was mapped to linear address space.
Because of this, loading ioatdma driver caused unexpected behavior
(kernel panic, kernel hangup, ...).

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 arch/x86/mm/ioremap.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

Index: linux-2.6.34/arch/x86/mm/ioremap.c
===================================================================
--- linux-2.6.34.orig/arch/x86/mm/ioremap.c	2010-06-10 07:28:28.222386973 +0900
+++ linux-2.6.34/arch/x86/mm/ioremap.c	2010-06-10 07:28:31.966187993 +0900
@@ -62,7 +62,7 @@
 static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 		unsigned long size, unsigned long prot_val, void *caller)
 {
-	unsigned long pfn, offset, vaddr;
+	unsigned long pfn, last_pfn, offset, vaddr;
 	resource_size_t last_addr;
 	const resource_size_t unaligned_phys_addr = phys_addr;
 	const unsigned long unaligned_size = size;
@@ -100,10 +100,8 @@
 	/*
 	 * Don't allow anybody to remap normal RAM that we're using..
 	 */
-	for (pfn = phys_addr >> PAGE_SHIFT;
-				(pfn << PAGE_SHIFT) < (last_addr & PAGE_MASK);
-				pfn++) {
-
+	last_pfn = last_addr >> PAGE_SHIFT;
+	for (pfn = phys_addr >> PAGE_SHIFT; pfn < last_pfn; pfn++) {
 		int is_ram = page_is_ram(pfn);
 
 		if (is_ram && pfn_valid(pfn) && !PageReserved(pfn_to_page(pfn)))
@@ -115,7 +113,7 @@
 	 * Mappings have to be page-aligned
 	 */
 	offset = phys_addr & ~PAGE_MASK;
-	phys_addr &= PAGE_MASK;
+	phys_addr &= PHYSICAL_PAGE_MASK;
 	size = PAGE_ALIGN(last_addr+1) - phys_addr;
 
 	retval = reserve_memtype(phys_addr, (u64)phys_addr + size,


