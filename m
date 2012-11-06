Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab2KFV4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 16:56:15 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62157 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342Ab2KFVzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 16:55:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-mtd@lists.infradead.org
Subject: [PATCH 2/8] mtd: diskonchip: use inline functions for DocRead/DocWrite
Date: Tue,  6 Nov 2012 22:55:27 +0100
Message-Id: <1352238933-4886-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1352238933-4886-1-git-send-email-arnd@arndb.de>
References: <1352238933-4886-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:j4mQo1ldyP1BbZvo8WfNWDjUWTVvKfnJuxh4OuqeALG
 MT3FZF1vR8D+sG2pQHqL9bulhM499WjyO99Otpv46bEw6dD1ue
 FtwkTpZbuJ4X6snzr2hjwAPBlqlYlVSz2L+S+eTzPzSO2F5V2s
 fhFq86HQun6bfNHvfW/sqf+Dq6pBlzbWeznZk86u4aD8OqSGMN
 RgwjqIAm43+0MYihuBmlyOvPKpjuuqlvDRylzUCKu8dv9qOp5o
 N1DGRJVtuxjnQtwCWehBUlnETvTl28t6/KRa+hNuG2jgD6/Fa0
 QQvM021o24fwivHQAhzAtSJYdgv2O0wSdSI/ASBfuI2zW4K2Lu
 cctlIiIZPkcM5uVKNXF05+PLAVROuC/HVMfc+aRTF7tPwX0bFe
 6RcfiTDooAEpw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The diskonchip drivers traditionally use home-grown macros for
doing MMIO accesses, which cause a lot of warnings, at least
on ARM machines:

drivers/mtd/devices/doc2000.c: In function 'doc_write':
drivers/mtd/devices/doc2000.c:854:5: warning: value computed is not used [-Wunused-value]
drivers/mtd/devices/doc2000.c: In function 'doc_erase':
drivers/mtd/devices/doc2000.c:1123:5: warning: value computed is not used [-Wunused-value
drivers/mtd/nand/diskonchip.c: In function 'doc2000_read_byte':
drivers/mtd/nand/diskonchip.c:318:3: warning: value computed is not used [-Wunused-value]

A nicer solution is to use the architecture-defined I/O accessors.
Here, we use the __raw_readl/__raw_writel style, instead of the
proper readl/writel ones, in order to preserve the odd semantics
of the existing macros that have their own barrier implementation
and no byte swap. It would be nice to fix this properly and use
the correct accessors as well as make the word size independent
from the architecture, but I guess the hardware is obsolete
enough that we should better not mess the driver an more than
necessary.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: linux-mtd@lists.infradead.org
---
 include/linux/mtd/doc2000.h |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/linux/mtd/doc2000.h b/include/linux/mtd/doc2000.h
index 0f6fea7..407d1e5 100644
--- a/include/linux/mtd/doc2000.h
+++ b/include/linux/mtd/doc2000.h
@@ -92,12 +92,26 @@
  * Others use readb/writeb
  */
 #if defined(__arm__)
-#define ReadDOC_(adr, reg)      ((unsigned char)(*(volatile __u32 *)(((unsigned long)adr)+((reg)<<2))))
-#define WriteDOC_(d, adr, reg)  do{ *(volatile __u32 *)(((unsigned long)adr)+((reg)<<2)) = (__u32)d; wmb();} while(0)
+static inline u8 ReadDOC_(u32 __iomem *addr, unsigned long reg)
+{
+	return __raw_readl(addr + reg);
+}
+static inline void WriteDOC_(u8 data, u32 __iomem *addr, unsigned long reg)
+{
+	__raw_writel(data, addr + reg);
+	wmb();
+}
 #define DOC_IOREMAP_LEN 0x8000
 #elif defined(__ppc__)
-#define ReadDOC_(adr, reg)      ((unsigned char)(*(volatile __u16 *)(((unsigned long)adr)+((reg)<<1))))
-#define WriteDOC_(d, adr, reg)  do{ *(volatile __u16 *)(((unsigned long)adr)+((reg)<<1)) = (__u16)d; wmb();} while(0)
+static inline u8 ReadDOC_(u16 __iomem *addr, unsigned long reg)
+{
+	return __raw_readw(addr + reg);
+}
+static inline void WriteDOC_(u8 data, u16 __iomem *addr, unsigned long reg)
+{
+	__raw_writew(data, addr + reg);
+	wmb();
+}
 #define DOC_IOREMAP_LEN 0x4000
 #else
 #define ReadDOC_(adr, reg)      readb((void __iomem *)(adr) + (reg))
-- 
1.7.10

