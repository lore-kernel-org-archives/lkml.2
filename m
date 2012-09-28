Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031491Ab2I1TjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:39:15 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:38829 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031405Ab2I1Thv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:37:51 -0400
From: Matt Porter <mporter@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Benoit Cousson <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Sekhar Nori <nsekhar@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: [PATCH v2 4/7] ARM: davinci: Add support for an L3RAM gen_pool
Date: Fri, 28 Sep 2012 15:37:49 -0400
Message-Id: <1348861072-14507-5-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348861072-14507-1-git-send-email-mporter@ti.com>
References: <1348861072-14507-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

L3RAM (shared SRAM) is needed for use by several drivers.
This creates a genalloc pool and a hook for the platform code
to provide the struct gen_pool * in platform data.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 arch/arm/mach-davinci/include/mach/common.h |    2 ++
 arch/arm/mach-davinci/include/mach/sram.h   |    3 +++
 arch/arm/mach-davinci/sram.c                |   28 ++++++++++++++++++++++++++-
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-davinci/include/mach/common.h b/arch/arm/mach-davinci/include/mach/common.h
index bdc4aa8..5a2ea37 100644
--- a/arch/arm/mach-davinci/include/mach/common.h
+++ b/arch/arm/mach-davinci/include/mach/common.h
@@ -77,6 +77,8 @@ struct davinci_soc_info {
 	struct emac_platform_data	*emac_pdata;
 	dma_addr_t			sram_dma;
 	unsigned			sram_len;
+	dma_addr_t			l3ram_dma;
+	unsigned			l3ram_len;
 };
 
 extern struct davinci_soc_info davinci_soc_info;
diff --git a/arch/arm/mach-davinci/include/mach/sram.h b/arch/arm/mach-davinci/include/mach/sram.h
index 111f7cc..1a81e5b 100644
--- a/arch/arm/mach-davinci/include/mach/sram.h
+++ b/arch/arm/mach-davinci/include/mach/sram.h
@@ -24,4 +24,7 @@
 extern void *sram_alloc(size_t len, dma_addr_t *dma);
 extern void sram_free(void *addr, size_t len);
 
+/* Get the l3ram struct gen_pool * for use in platform data */
+extern struct gen_pool *sram_get_l3ram_pool(void);
+
 #endif /* __MACH_SRAM_H */
diff --git a/arch/arm/mach-davinci/sram.c b/arch/arm/mach-davinci/sram.c
index db0f778..e609fa3 100644
--- a/arch/arm/mach-davinci/sram.c
+++ b/arch/arm/mach-davinci/sram.c
@@ -15,7 +15,12 @@
 #include <mach/common.h>
 #include <mach/sram.h>
 
-static struct gen_pool *sram_pool;
+static struct gen_pool *sram_pool, *l3ram_pool;
+
+struct gen_pool *sram_get_l3ram_pool(void)
+{
+	return l3ram_pool;
+}
 
 void *sram_alloc(size_t len, dma_addr_t *dma)
 {
@@ -54,6 +59,9 @@ EXPORT_SYMBOL(sram_free);
 static int __init sram_init(void)
 {
 	unsigned len = davinci_soc_info.sram_len;
+	unsigned l3ram_dma = davinci_soc_info.l3ram_dma;
+	unsigned l3ram_len = davinci_soc_info.l3ram_len;
+	void *l3ram_virt;
 	int status = 0;
 
 	if (len) {
@@ -65,6 +73,24 @@ static int __init sram_init(void)
 	if (sram_pool)
 		status = gen_pool_add(sram_pool, SRAM_VIRT, len, -1);
 	WARN_ON(status < 0);
+
+	if (l3ram_dma) {
+		l3ram_pool =
+			gen_pool_create(ilog2(SRAM_GRANULARITY), -1);
+		if (!l3ram_pool)
+			status = -ENOMEM;
+	}
+
+	if (l3ram_pool) {
+		l3ram_virt = ioremap(l3ram_dma, l3ram_len);
+		if (l3ram_virt)
+			status = gen_pool_add_virt(l3ram_pool,
+						   (unsigned long)l3ram_virt,
+						   l3ram_dma, l3ram_len, -1);
+		else
+			status = -ENOMEM;
+	}
+
 	return status;
 }
 core_initcall(sram_init);
-- 
1.7.9.5

