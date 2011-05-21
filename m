Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab1EUTkJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 15:40:09 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:47776 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252Ab1EUTj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 15:39:29 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-m68k@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 4/4] sparc: iounmap() and *_free_coherent() - Use lookup_resource()
Date: Sat, 21 May 2011 21:39:16 +0200
Message-Id: <1306006756-32009-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1306006756-32009-1-git-send-email-geert@linux-m68k.org>
References: <1306006756-32009-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a custom implementation (which doesn't lock the resource tree) by a
call to lookup_resource()

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/sparc/kernel/ioport.c |   32 +++++++-------------------------
 1 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index 91e8c76..7be5438 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -60,9 +60,6 @@ static inline void mmu_inval_dma_area(void *va, unsigned long len)
 }
 #endif
 
-static struct resource *_sparc_find_resource(struct resource *r,
-					     unsigned long);
-
 static void __iomem *_sparc_ioremap(struct resource *res, u32 bus, u32 pa, int sz);
 static void __iomem *_sparc_alloc_io(unsigned int busno, unsigned long phys,
     unsigned long size, char *name);
@@ -138,7 +135,11 @@ void iounmap(volatile void __iomem *virtual)
 	unsigned long vaddr = (unsigned long) virtual & PAGE_MASK;
 	struct resource *res;
 
-	if ((res = _sparc_find_resource(&sparc_iomap, vaddr)) == NULL) {
+	/*
+	 * XXX Too slow. Can have 8192 DVMA pages on sun4m in the worst case.
+	 * This probably warrants some sort of hashing.
+	*/
+	if ((res = lookup_resource(&sparc_iomap, vaddr)) == NULL) {
 		printk("free_io/iounmap: cannot free %lx\n", vaddr);
 		return;
 	}
@@ -315,7 +316,7 @@ static void sbus_free_coherent(struct device *dev, size_t n, void *p,
 	struct resource *res;
 	struct page *pgv;
 
-	if ((res = _sparc_find_resource(&_sparc_dvma,
+	if ((res = lookup_resource(&_sparc_dvma,
 	    (unsigned long)p)) == NULL) {
 		printk("sbus_free_consistent: cannot free %p\n", p);
 		return;
@@ -491,7 +492,7 @@ static void pci32_free_coherent(struct device *dev, size_t n, void *p,
 	struct resource *res;
 	void *pgp;
 
-	if ((res = _sparc_find_resource(&_sparc_dvma,
+	if ((res = lookup_resource(&_sparc_dvma,
 	    (unsigned long)p)) == NULL) {
 		printk("pci_free_consistent: cannot free %p\n", p);
 		return;
@@ -725,25 +726,6 @@ static const struct file_operations sparc_io_proc_fops = {
 };
 #endif /* CONFIG_PROC_FS */
 
-/*
- * This is a version of find_resource and it belongs to kernel/resource.c.
- * Until we have agreement with Linus and Martin, it lingers here.
- *
- * XXX Too slow. Can have 8192 DVMA pages on sun4m in the worst case.
- * This probably warrants some sort of hashing.
- */
-static struct resource *_sparc_find_resource(struct resource *root,
-					     unsigned long start)
-{
-	struct resource *tmp;
-
-	for (tmp = root->child; tmp != 0; tmp = tmp->sibling) {
-		if (tmp->start == start)
-			return tmp;
-	}
-	return NULL;
-}
-
 static void register_proc_sparc_ioport(void)
 {
 #ifdef CONFIG_PROC_FS
-- 
1.7.0.4

