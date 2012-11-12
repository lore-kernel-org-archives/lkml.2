Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab2KLQnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 11:43:13 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36002 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab2KLQnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 11:43:09 -0500
From: Joonsoo Kim <js1304@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH] powerpc: change free_bootmem() to kfree()
Date: Tue, 13 Nov 2012 01:40:33 +0900
Message-Id: <1352738433-31085-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit ea96025a('Don't use alloc_bootmem() in init_IRQ() path')
changed alloc_bootmem() to kzalloc(),
but missed to change free_bootmem() to kfree().
So correct it.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c b/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
index 328d221..74861a7 100644
--- a/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
+++ b/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
@@ -16,7 +16,6 @@
 #include <linux/spinlock.h>
 #include <linux/irq.h>
 #include <linux/types.h>
-#include <linux/bootmem.h>
 #include <linux/slab.h>
 
 #include <asm/io.h>
@@ -149,7 +148,7 @@ int __init pq2ads_pci_init_irq(void)
 	priv->regs = of_iomap(np, 0);
 	if (!priv->regs) {
 		printk(KERN_ERR "Cannot map PCI PIC registers.\n");
-		goto out_free_bootmem;
+		goto out_free_kmalloc;
 	}
 
 	/* mask all PCI interrupts */
@@ -171,9 +170,8 @@ int __init pq2ads_pci_init_irq(void)
 
 out_unmap_regs:
 	iounmap(priv->regs);
-out_free_bootmem:
-	free_bootmem((unsigned long)priv,
-	             sizeof(struct pq2ads_pci_pic));
+out_free_kmalloc:
+	kfree(priv);
 	of_node_put(np);
 out_unmap_irq:
 	irq_dispose_mapping(irq);
-- 
1.7.9.5

