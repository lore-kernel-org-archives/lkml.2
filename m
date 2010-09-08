Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab0IHQmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 12:42:21 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:44233 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab0IHQli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 12:41:38 -0400
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH 2/5] fsldma: move DMA_SLAVE support functions to the driver
Date: Wed,  8 Sep 2010 09:41:19 -0700
Message-Id: <1283964082-30133-3-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283964082-30133-1-git-send-email-iws@ovro.caltech.edu>
References: <1283964082-30133-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Wed, 08 Sep 2010 09:41:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DMA_SLAVE support functions all existed as static inlines in the
driver specific header arch/powerpc/include/asm/fsldma.h. Move the body
of the functions to the driver itself, and EXPORT_SYMBOL_GPL() them.

At the same time, add the missing linux/list.h header.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 arch/powerpc/include/asm/fsldma.h |   70 +++------------------------------
 drivers/dma/fsldma.c              |   77 +++++++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+), 64 deletions(-)

diff --git a/arch/powerpc/include/asm/fsldma.h b/arch/powerpc/include/asm/fsldma.h
index debc5ed..34ec00b 100644
--- a/arch/powerpc/include/asm/fsldma.h
+++ b/arch/powerpc/include/asm/fsldma.h
@@ -1,7 +1,7 @@
 /*
  * Freescale MPC83XX / MPC85XX DMA Controller
  *
- * Copyright (c) 2009 Ira W. Snyder <iws@ovro.caltech.edu>
+ * Copyright (c) 2009-2010 Ira W. Snyder <iws@ovro.caltech.edu>
  *
  * This file is licensed under the terms of the GNU General Public License
  * version 2. This program is licensed "as is" without any warranty of any
@@ -11,6 +11,7 @@
 #ifndef __ARCH_POWERPC_ASM_FSLDMA_H__
 #define __ARCH_POWERPC_ASM_FSLDMA_H__
 
+#include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/dmaengine.h>
 
@@ -69,69 +70,10 @@ struct fsl_dma_slave {
 	bool external_pause;
 };
 
-/**
- * fsl_dma_slave_append - add an address/length pair to a struct fsl_dma_slave
- * @slave: the &struct fsl_dma_slave to add to
- * @address: the hardware address to add
- * @length: the length of bytes to transfer from @address
- *
- * Add a hardware address/length pair to a struct fsl_dma_slave. Returns 0 on
- * success, -ERRNO otherwise.
- */
-static inline int fsl_dma_slave_append(struct fsl_dma_slave *slave,
-				       dma_addr_t address, size_t length)
-{
-	struct fsl_dma_hw_addr *addr;
-
-	addr = kzalloc(sizeof(*addr), GFP_ATOMIC);
-	if (!addr)
-		return -ENOMEM;
-
-	INIT_LIST_HEAD(&addr->entry);
-	addr->address = address;
-	addr->length = length;
-
-	list_add_tail(&addr->entry, &slave->addresses);
-	return 0;
-}
-
-/**
- * fsl_dma_slave_free - free a struct fsl_dma_slave
- * @slave: the struct fsl_dma_slave to free
- *
- * Free a struct fsl_dma_slave and all associated address/length pairs
- */
-static inline void fsl_dma_slave_free(struct fsl_dma_slave *slave)
-{
-	struct fsl_dma_hw_addr *addr, *tmp;
-
-	if (slave) {
-		list_for_each_entry_safe(addr, tmp, &slave->addresses, entry) {
-			list_del(&addr->entry);
-			kfree(addr);
-		}
-
-		kfree(slave);
-	}
-}
-
-/**
- * fsl_dma_slave_alloc - allocate a struct fsl_dma_slave
- * @gfp: the flags to pass to kmalloc when allocating this structure
- *
- * Allocate a struct fsl_dma_slave for use by the DMA_SLAVE API. Returns a new
- * struct fsl_dma_slave on success, or NULL on failure.
- */
-static inline struct fsl_dma_slave *fsl_dma_slave_alloc(gfp_t gfp)
-{
-	struct fsl_dma_slave *slave;
-
-	slave = kzalloc(sizeof(*slave), gfp);
-	if (!slave)
-		return NULL;
+struct fsl_dma_slave *fsl_dma_slave_alloc(gfp_t gfp);
+void fsl_dma_slave_free(struct fsl_dma_slave *slave);
 
-	INIT_LIST_HEAD(&slave->addresses);
-	return slave;
-}
+int fsl_dma_slave_append(struct fsl_dma_slave *slave, dma_addr_t address,
+			 size_t length, gfp_t gfp);
 
 #endif /* __ARCH_POWERPC_ASM_FSLDMA_H__ */
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index cea08be..f436ca4 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -38,6 +38,83 @@
 #include <asm/fsldma.h>
 #include "fsldma.h"
 
+/*
+ * External API
+ */
+
+/**
+ * fsl_dma_slave_append - add an address/length pair to a struct fsl_dma_slave
+ * @slave: the &struct fsl_dma_slave to add to
+ * @address: the hardware address to add
+ * @length: the length of bytes to transfer from @address
+ * @gfp: the flags to pass to kmalloc when allocating memory
+ *
+ * Add a hardware address/length pair to a struct fsl_dma_slave. Returns 0 on
+ * success, -ERRNO otherwise.
+ */
+int fsl_dma_slave_append(struct fsl_dma_slave *slave, dma_addr_t address,
+			 size_t length, gfp_t gfp)
+{
+	struct fsl_dma_hw_addr *addr;
+
+	addr = kzalloc(sizeof(*addr), gfp);
+	if (!addr)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&addr->entry);
+	addr->address = address;
+	addr->length = length;
+
+	list_add_tail(&addr->entry, &slave->addresses);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fsl_dma_slave_append);
+
+/**
+ * fsl_dma_slave_free - free a struct fsl_dma_slave
+ * @slave: the struct fsl_dma_slave to free
+ *
+ * Free a struct fsl_dma_slave and all associated address/length pairs
+ */
+void fsl_dma_slave_free(struct fsl_dma_slave *slave)
+{
+	struct fsl_dma_hw_addr *addr, *tmp;
+
+	if (slave) {
+		list_for_each_entry_safe(addr, tmp, &slave->addresses, entry) {
+			list_del(&addr->entry);
+			kfree(addr);
+		}
+
+		kfree(slave);
+	}
+}
+EXPORT_SYMBOL_GPL(fsl_dma_slave_free);
+
+/**
+ * fsl_dma_slave_alloc - allocate a struct fsl_dma_slave
+ * @gfp: the flags to pass to kmalloc when allocating this structure
+ *
+ * Allocate a struct fsl_dma_slave for use by the DMA_SLAVE API. Returns a new
+ * struct fsl_dma_slave on success, or NULL on failure.
+ */
+struct fsl_dma_slave *fsl_dma_slave_alloc(gfp_t gfp)
+{
+	struct fsl_dma_slave *slave;
+
+	slave = kzalloc(sizeof(*slave), gfp);
+	if (!slave)
+		return NULL;
+
+	INIT_LIST_HEAD(&slave->addresses);
+	return slave;
+}
+EXPORT_SYMBOL_GPL(fsl_dma_slave_alloc);
+
+/*
+ * Driver Code
+ */
+
 static void dma_init(struct fsldma_chan *chan)
 {
 	/* Reset the channel */
-- 
1.7.1

