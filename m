Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828Ab2JKMmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 08:42:36 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:46650 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756612Ab2JKMmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 08:42:32 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl/nomadik: provide stubs for legacy Nomadik
Date: Thu, 11 Oct 2012 14:41:42 +0200
Message-ID: <1349959302-12151-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The compilation of the pinctrl driver failed on the legacy
Nomadik NHK8815 platform because it was not providing the PRCMU
interfaces needed to support the extended alternate functions
used by the ux500 series.

Solve this by providing some stubs for the legacy platform, to
avoid too much #ifdefs in the code per se. Theoretically this
actually allows the Nomadik and Ux500 to have a single kernel
image with support for the PRCM registers on the Ux500 (though
they have incompatible archs, but the spirit is there).

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index fec9c30..f640f13 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -30,7 +30,20 @@
 #include <linux/pinctrl/pinconf.h>
 /* Since we request GPIOs from ourself */
 #include <linux/pinctrl/consumer.h>
+/*
+ * For the U8500 archs, use the PRCMU register interface, for the older
+ * Nomadik, provide some stubs. The functions using these will only be
+ * called on the U8500 series.
+ */
+#ifdef CONFIG_ARCH_U8500
 #include <linux/mfd/dbx500-prcmu.h>
+#else
+static inline u32 prcmu_read(unsigned int reg) {
+	return 0;
+}
+static inline void prcmu_write(unsigned int reg, u32 value) {}
+static inline void prcmu_write_masked(unsigned int reg, u32 mask, u32 value) {}
+#endif
 
 #include <asm/mach/irq.h>
 
-- 
1.7.11.3

