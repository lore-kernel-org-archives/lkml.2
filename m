Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423419Ab2I1Vgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:36:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52298 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423392Ab2I1Vgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:36:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Krzysztof Halasa <khc@pm.waw.pl>
Subject: [PATCH 05/12] ARM: ixp4xx: use __iomem for MMIO
Date: Fri, 28 Sep 2012 23:36:10 +0200
Message-Id: <1348868177-21205-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1348868177-21205-1-git-send-email-arnd@arndb.de>
References: <1348868177-21205-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Flkxu+zcKmOb3G1KXFQKI+41ZCASAn4zdb7nlMmkyJx
 3ofTCOhC2IEuH1jFEFyVGuoL/CPYaaNjmGR6c1syM1DL+KH7jP
 uXXiEkR7GoMduEmwKR323CgrIUVIHvSVaRlClQ308oLe9OReAh
 3YDSW8+UY4pgm3/1DFYhIdWrLJ13usj5hEtLPIBCDYmdZTJw+Z
 XxLZib1IfgaYUQomMIQON7EEE6PkFLKDPqBxe5eW7Tr/2ZeeIV
 P9Mu2wVgKkq9R4eit5FMXNhsqOaLOTnq/ryRMDBWrs2ZEltlgp
 TNdGSurlqwNGuLzvLsZsOeLzbOA21S8ztGUEeUZyOSlwQmpzlK
 RqntBkClxAlpub/cTfEfgDQ89sO1Tbr69H1+2tpWwVB26rfbnn
 goakW3BDK8L+g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ixp4xx queue manager uses "const struct qmgr_regs __iomem *" as the
type for a pointer that is passed to __raw_writel, which is not
allowed because of the const-ness.

Dropping the 'const' keyword fixes the problem. While we're here,
let's also drop the useless type cast.

Without this patch, building ixp4xx_defconfig results in:

In file included from arch/arm/mach-ixp4xx/ixp4xx_qmgr.c:15:0:
arch/arm/mach-ixp4xx/include/mach/qmgr.h: In function 'qmgr_put_entry':
arch/arm/mach-ixp4xx/include/mach/qmgr.h:96:2: warning: passing argument 2 of '__raw_writel' discards 'const' qualifier from pointer target type [enabled by default]
arch/arm/include/asm/io.h:88:91: note: expected 'volatile void *' but argument is of type 'const u32 *'
In file included from drivers/net/ethernet/xscale/ixp4xx_eth.c:41:0:
arch/arm/mach-ixp4xx/include/mach/qmgr.h: In function 'qmgr_put_entry':
arch/arm/mach-ixp4xx/include/mach/qmgr.h:96:2: warning: passing argument 2 of '__raw_writel' discards 'const' qualifier from pointer target type [enabled by default]
arch/arm/include/asm/io.h:88:91: note: expected 'volatile void *' but argument is of type 'const u32 *'
arch/arm/mach-ixp4xx/ixp4xx_qmgr.c: In function 'qmgr_set_irq':
arch/arm/mach-ixp4xx/ixp4xx_qmgr.c:41:9: warning: passing argument 2 of '__raw_writel' discards 'const' qualifier from pointer target type [enabled by default]
arch/arm/include/asm/io.h:88:91: note: expected 'volatile void *' but argument is of type 'const u32 *'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
---

Krzysztof, please apply in your next branch so this problem goes away in
3.8. I realize it won't make 3.7 any more since the base patches are not
in arm-soc, but it's bad if linux-next is broken.

 arch/arm/mach-ixp4xx/include/mach/qmgr.h |   12 ++++++------
 arch/arm/mach-ixp4xx/ixp4xx_qmgr.c       |    4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-ixp4xx/include/mach/qmgr.h b/arch/arm/mach-ixp4xx/include/mach/qmgr.h
index 0a88d3b..4de8da5 100644
--- a/arch/arm/mach-ixp4xx/include/mach/qmgr.h
+++ b/arch/arm/mach-ixp4xx/include/mach/qmgr.h
@@ -86,7 +86,7 @@ void qmgr_release_queue(unsigned int queue);
 
 static inline void qmgr_put_entry(unsigned int queue, u32 val)
 {
-	const struct qmgr_regs __iomem *qmgr_regs = (void __iomem *)IXP4XX_QMGR_BASE_VIRT;
+	struct qmgr_regs __iomem *qmgr_regs = IXP4XX_QMGR_BASE_VIRT;
 #if DEBUG_QMGR
 	BUG_ON(!qmgr_queue_descs[queue]); /* not yet requested */
 
@@ -99,7 +99,7 @@ static inline void qmgr_put_entry(unsigned int queue, u32 val)
 static inline u32 qmgr_get_entry(unsigned int queue)
 {
 	u32 val;
-	const struct qmgr_regs __iomem *qmgr_regs = (void __iomem *)IXP4XX_QMGR_BASE_VIRT;
+	const struct qmgr_regs __iomem *qmgr_regs = IXP4XX_QMGR_BASE_VIRT;
 	val = __raw_readl(&qmgr_regs->acc[queue][0]);
 #if DEBUG_QMGR
 	BUG_ON(!qmgr_queue_descs[queue]); /* not yet requested */
@@ -112,14 +112,14 @@ static inline u32 qmgr_get_entry(unsigned int queue)
 
 static inline int __qmgr_get_stat1(unsigned int queue)
 {
-	const struct qmgr_regs __iomem *qmgr_regs = (void __iomem *)IXP4XX_QMGR_BASE_VIRT;
+	const struct qmgr_regs __iomem *qmgr_regs = IXP4XX_QMGR_BASE_VIRT;
 	return (__raw_readl(&qmgr_regs->stat1[queue >> 3])
 		>> ((queue & 7) << 2)) & 0xF;
 }
 
 static inline int __qmgr_get_stat2(unsigned int queue)
 {
-	const struct qmgr_regs __iomem *qmgr_regs = (void __iomem *)IXP4XX_QMGR_BASE_VIRT;
+	const struct qmgr_regs __iomem *qmgr_regs = IXP4XX_QMGR_BASE_VIRT;
 	BUG_ON(queue >= HALF_QUEUES);
 	return (__raw_readl(&qmgr_regs->stat2[queue >> 4])
 		>> ((queue & 0xF) << 1)) & 0x3;
@@ -145,7 +145,7 @@ static inline int qmgr_stat_empty(unsigned int queue)
  */
 static inline int qmgr_stat_below_low_watermark(unsigned int queue)
 {
-	const struct qmgr_regs __iomem *qmgr_regs = (void __iomem *)IXP4XX_QMGR_BASE_VIRT;
+	const struct qmgr_regs __iomem *qmgr_regs = IXP4XX_QMGR_BASE_VIRT;
 	if (queue >= HALF_QUEUES)
 		return (__raw_readl(&qmgr_regs->statne_h) >>
 			(queue - HALF_QUEUES)) & 0x01;
@@ -172,7 +172,7 @@ static inline int qmgr_stat_above_high_watermark(unsigned int queue)
  */
 static inline int qmgr_stat_full(unsigned int queue)
 {
-	const struct qmgr_regs __iomem *qmgr_regs = (void __iomem *)IXP4XX_QMGR_BASE_VIRT;
+	const struct qmgr_regs __iomem *qmgr_regs = IXP4XX_QMGR_BASE_VIRT;
 	if (queue >= HALF_QUEUES)
 		return (__raw_readl(&qmgr_regs->statf_h) >>
 			(queue - HALF_QUEUES)) & 0x01;
diff --git a/arch/arm/mach-ixp4xx/ixp4xx_qmgr.c b/arch/arm/mach-ixp4xx/ixp4xx_qmgr.c
index 7c0584e..9d1b6b7 100644
--- a/arch/arm/mach-ixp4xx/ixp4xx_qmgr.c
+++ b/arch/arm/mach-ixp4xx/ixp4xx_qmgr.c
@@ -14,7 +14,7 @@
 #include <linux/module.h>
 #include <mach/qmgr.h>
 
-static const struct qmgr_regs __iomem *qmgr_regs = (void __iomem *)IXP4XX_QMGR_BASE_VIRT;
+static struct qmgr_regs __iomem *qmgr_regs = IXP4XX_QMGR_BASE_VIRT;
 static struct resource *mem_res;
 static spinlock_t qmgr_lock;
 static u32 used_sram_bitmap[4]; /* 128 16-dword pages */
@@ -32,7 +32,7 @@ void qmgr_set_irq(unsigned int queue, int src,
 
 	spin_lock_irqsave(&qmgr_lock, flags);
 	if (queue < HALF_QUEUES) {
-		const u32 __iomem *reg;
+		u32 __iomem *reg;
 		int bit;
 		BUG_ON(src > QUEUE_IRQ_SRC_NOT_FULL);
 		reg = &qmgr_regs->irqsrc[queue >> 3]; /* 8 queues per u32 */
-- 
1.7.10

