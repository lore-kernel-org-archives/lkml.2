Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab2JCO4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:56:43 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47417 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354Ab2JCOzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:55:11 -0400
From: Matt Porter <mporter@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Sekhar Nori <nsekhar@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>
Subject: [PATCH v3 1/6] ARM: davinci: sram: ioremap the davinci_soc_info specified sram regions
Date: Wed,  3 Oct 2012 10:55:28 -0400
Message-Id: <1349276133-26408-2-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349276133-26408-1-git-send-email-mporter@ti.com>
References: <1349276133-26408-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Gardiner <bengardiner@nanometrics.ca>

The current davinci init sets up SRAM in iotables. There has been an observed
failure to boot a da850 with 128K specified in the iotable.

Make the davinci sram allocator -- now based on RMK's consolidated SRAM
support -- do an ioremap of the region specified by the entries in
davinci_soc_info before registering with gen_pool_add_virt().

This commit breaks runtime of davinci boards since the regions that
the sram init is now trying to ioremap have been iomapped by their
iotable entries. The iotable entries will be removed in the patches
to come.

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
[rebased to mainline as the consolidated SRAM support was dropped]
Signed-off-by: Matt Porter <mporter@ti.com>
---
 arch/arm/mach-davinci/sram.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-davinci/sram.c b/arch/arm/mach-davinci/sram.c
index db0f778..0e8ca4f 100644
--- a/arch/arm/mach-davinci/sram.c
+++ b/arch/arm/mach-davinci/sram.c
@@ -10,6 +10,7 @@
  */
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/io.h>
 #include <linux/genalloc.h>
 
 #include <mach/common.h>
@@ -32,7 +33,7 @@ void *sram_alloc(size_t len, dma_addr_t *dma)
 		return NULL;
 
 	if (dma)
-		*dma = dma_base + (vaddr - SRAM_VIRT);
+		*dma = gen_pool_virt_to_phys(sram_pool, vaddr);
 	return (void *)vaddr;
 
 }
@@ -53,8 +54,10 @@ EXPORT_SYMBOL(sram_free);
  */
 static int __init sram_init(void)
 {
+	phys_addr_t phys = davinci_soc_info.sram_dma;
 	unsigned len = davinci_soc_info.sram_len;
 	int status = 0;
+	void *addr;
 
 	if (len) {
 		len = min_t(unsigned, len, SRAM_SIZE);
@@ -62,8 +65,16 @@ static int __init sram_init(void)
 		if (!sram_pool)
 			status = -ENOMEM;
 	}
-	if (sram_pool)
-		status = gen_pool_add(sram_pool, SRAM_VIRT, len, -1);
+
+	if (sram_pool) {
+		addr = ioremap(phys, len);
+		if (!addr)
+			return -ENOMEM;
+		if((status = gen_pool_add_virt(sram_pool, (unsigned)addr,
+					       phys, len, -1)))
+			iounmap(addr);
+	}
+
 	WARN_ON(status < 0);
 	return status;
 }
-- 
1.7.9.5

