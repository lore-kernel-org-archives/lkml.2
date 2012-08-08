Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671Ab2HHOrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 10:47:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53743 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758640Ab2HHOrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:47:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 08/11] mtd/omap2: fix dmaengine_slave_config error handling
Date: Wed,  8 Aug 2012 16:47:25 +0200
Message-Id: <1344437248-20560-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1344437248-20560-1-git-send-email-arnd@arndb.de>
References: <1344437248-20560-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ukBNsWwSy8Q7NQEPAFxUFPJHzryJBbW1VK4UD6SD+kg
 oJmymv7x+NT4SnEnQtCYa8L7JI/pyC6Fk91qdPqRozFEsP0+q2
 PasC48B5jq+8pHcfQHyNNlP04QuRVLKrh1+yRtJaK4PEtn8kGP
 9yRsXQ7tYyWjNDQ5+fa00EoIme0eLMVibeereFg1NPDb+eWQdH
 avamXZoli009M55fUS9CxJ3WGx/c3erI9aVJlKVnMBVXoGIzRB
 kLXQAiwU458OUFfWZA5z4teap6tvYySioQvmtKpEQ2pjE1Td/J
 9Q+sKBWV9eY1menErD2Kzh7KVP2epUzTQfw06d8MfmZ3H7at9m
 281E/kXu2xWSSv2P+cbOuxDgxCfpuCU94k9PlEwvj7DTxNjaI7
 XrL7gGbZH8+/QhLqjNHt8WhQ/gJOePbBKY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The newly added dmaengine support in the omap2 nand driver
potentially causes an undefined return value from the
omap_nand_probe function when dmaengine_slave_config
reports an error. Let's handle this by returning the
same error back to the caller.

Without this patch, building omap2plus_defconfig results in:

drivers/mtd/nand/omap2.c: In function 'omap_nand_probe':
drivers/mtd/nand/omap2.c:1154:6: warning: 'err' may be used uninitialized in this function [-Wuninitialized]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/mtd/nand/omap2.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index e9309b3..ac4fd75 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -1245,7 +1245,6 @@ static int __devinit omap_nand_probe(struct platform_device *pdev)
 			goto out_release_mem_region;
 		} else {
 			struct dma_slave_config cfg;
-			int rc;
 
 			memset(&cfg, 0, sizeof(cfg));
 			cfg.src_addr = info->phys_base;
@@ -1254,10 +1253,10 @@ static int __devinit omap_nand_probe(struct platform_device *pdev)
 			cfg.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 			cfg.src_maxburst = 16;
 			cfg.dst_maxburst = 16;
-			rc = dmaengine_slave_config(info->dma, &cfg);
-			if (rc) {
+			err = dmaengine_slave_config(info->dma, &cfg);
+			if (err) {
 				dev_err(&pdev->dev, "DMA engine slave config failed: %d\n",
-					rc);
+					err);
 				goto out_release_mem_region;
 			}
 			info->nand.read_buf   = omap_read_buf_dma_pref;
-- 
1.7.10

