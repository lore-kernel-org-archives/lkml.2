Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab0LFXZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:25:34 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27245 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab0LFXZa (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 18:25:30 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 18/23] agp/x86: Make agp_generic_* use PCI API.
Date: Mon,  6 Dec 2010 18:24:30 -0500
Message-Id: <1291677875-30493-19-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
References: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad@kernel.org>

We turn the PCI API on for x86/x86_64 AGP drivers. This means that
any calls to:
 agp_generic_insert_memory
 agp_generic_create_gatt_table
 agp_generic_free_gatt_table
 agp_generic_alloc_pages
 agp_generic_alloc_page
 agp_generic_destroy_pages
 agp_generic_destroy_page

Will have the 'struct agp_memory' variable dma_addr filled with the
DMA (bus) address of the page. For agp_generic_[alloc|destroy]_page
it requires that the DMA (bus) address be passed in as extra argument.

Note: This change goes only effect on X86/X86_64 platforms. All
other ones would still be using the old mechanism.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/agp.h |   30 ++++++++++++++++++++----------
 1 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/agp.h b/arch/x86/include/asm/agp.h
index 72e7179..eb4e160 100644
--- a/arch/x86/include/asm/agp.h
+++ b/arch/x86/include/asm/agp.h
@@ -24,22 +24,32 @@
 
 /* GATT allocation. Returns/accepts GATT kernel virtual address. */
 #define alloc_gatt_pages(bridge, order)		\
-	((char *)__get_free_pages(GFP_KERNEL, (order)))
+	({ \
+		pci_alloc_consistent(bridge->dev, \
+				   PAGE_SIZE * (1 << order), \
+				   (dma_addr_t *)&bridge->gatt_bus_addr); \
+	})
 #define free_gatt_pages(bridge, order)	\
-	free_pages((unsigned long)(bridge->gatt_table_real), (order))
+	pci_free_consistent(bridge->dev, bridge->gatt_table_size, \
+			 bridge->gatt_table_real, \
+			 bridge->gatt_bus_addr);
 
 /* pages allocation. */
 #define _agp_alloc_page(bridge, dma_addr) \
 	({ \
-		struct page *_page = NULL; \
-		_page = alloc_page(GFP_KERNEL | GFP_DMA32 | __GFP_ZERO); \
-		if (_page) \
-			*dma_addr = page_to_phys(_page); \
+		void *_addr = NULL; \
+		struct page * _page = NULL;\
+		_addr = pci_alloc_consistent(bridge->dev, PAGE_SIZE, \
+						dma_addr); \
+		if (_addr) \
+			_page = virt_to_page(_addr); \
 		_page; \
 	})
 #define _agp_free_page(bridge, page, dma_addr) \
-	({ \
-		__free_page(page); \
-		*dma_addr = DMA_ERROR_CODE; \
-	})
+ 	({ \
+		void *_addr = NULL; \
+		_addr = page_address(page); \
+		pci_free_consistent(bridge->dev, PAGE_SIZE, _addr, *dma_addr); \
+ 		*dma_addr = DMA_ERROR_CODE; \
+ 	})
 #endif /* _ASM_X86_AGP_H */
-- 
1.7.1

