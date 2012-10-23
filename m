Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763Ab2JWNZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:25:08 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:53562 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757091Ab2JWNZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:25:04 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>
Cc: Manjunath Hadli <manjunath.hadli@ti.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2] media: davinci: vpbe: fix build warning
Date: Tue, 23 Oct 2012 18:54:37 +0530
Message-Id: <1350998677-19890-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

Warnings were generated because of the following commit changed data type for
address pointer

195bbca ARM: 7500/1: io: avoid writeback addressing modes for __raw_ accessors
add  __iomem annotation to fix following warnings

drivers/media/platform/davinci/vpbe_osd.c: In function ‘osd_read’:
drivers/media/platform/davinci/vpbe_osd.c:49:2: warning: passing
 argument 1 of ‘__raw_readl’ makes pointer from integer without a cast [enabled by default]
arch/arm/include/asm/io.h:104:19: note: expected ‘const volatile
 void *’ but argument is of type ‘long unsigned int’

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
 Changes for v2:
 1: Made the base addr to void __iomem * instead of long unsigned,
    as pointed by Laurent.

 drivers/media/platform/davinci/vpbe_osd.c |    9 ++++-----
 include/media/davinci/vpbe_osd.h          |    2 +-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_osd.c b/drivers/media/platform/davinci/vpbe_osd.c
index bba299d..707f243 100644
--- a/drivers/media/platform/davinci/vpbe_osd.c
+++ b/drivers/media/platform/davinci/vpbe_osd.c
@@ -62,7 +62,7 @@ static inline u32 osd_set(struct osd_state *sd, u32 mask, u32 offset)
 {
 	struct osd_state *osd = sd;
 
-	u32 addr = osd->osd_base + offset;
+	void __iomem *addr = osd->osd_base + offset;
 	u32 val = readl(addr) | mask;
 
 	writel(val, addr);
@@ -74,7 +74,7 @@ static inline u32 osd_clear(struct osd_state *sd, u32 mask, u32 offset)
 {
 	struct osd_state *osd = sd;
 
-	u32 addr = osd->osd_base + offset;
+	void __iomem *addr = osd->osd_base + offset;
 	u32 val = readl(addr) & ~mask;
 
 	writel(val, addr);
@@ -87,7 +87,7 @@ static inline u32 osd_modify(struct osd_state *sd, u32 mask, u32 val,
 {
 	struct osd_state *osd = sd;
 
-	u32 addr = osd->osd_base + offset;
+	void __iomem *addr = osd->osd_base + offset;
 	u32 new_val = (readl(addr) & ~mask) | (val & mask);
 
 	writel(new_val, addr);
@@ -1559,8 +1559,7 @@ static int osd_probe(struct platform_device *pdev)
 		ret = -ENODEV;
 		goto free_mem;
 	}
-	osd->osd_base = (unsigned long)ioremap_nocache(res->start,
-							osd->osd_size);
+	osd->osd_base = ioremap_nocache(res->start, osd->osd_size);
 	if (!osd->osd_base) {
 		dev_err(osd->dev, "Unable to map the OSD region\n");
 		ret = -ENODEV;
diff --git a/include/media/davinci/vpbe_osd.h b/include/media/davinci/vpbe_osd.h
index d7e397a..5ab0d8d 100644
--- a/include/media/davinci/vpbe_osd.h
+++ b/include/media/davinci/vpbe_osd.h
@@ -357,7 +357,7 @@ struct osd_state {
 	spinlock_t lock;
 	struct device *dev;
 	dma_addr_t osd_base_phys;
-	unsigned long osd_base;
+	void __iomem *osd_base;
 	unsigned long osd_size;
 	/* 1-->the isr will toggle the VID0 ping-pong buffer */
 	int pingpong;
-- 
1.7.4.1

