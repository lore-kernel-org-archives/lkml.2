Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab0JTU40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 16:56:26 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57478 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934Ab0JTU4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 16:56:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SZ19Q6zN+wblWftqHzP092aR+PkyAba9lJClRGRkLvZ7qyUAkfSQ9FHWEsIWUgUNsY
         r+MsCVTdbneLBiYt4KqxicLwD+x6i8QfmyjBrB/iRnRJY6ZYO1jIePhQs2zJ7aghSNpY
         tgtcDlfYs+N03yhM4fzLRI24jvGNbs18r491M=
From: Alexey Charkov <alchark@gmail.com>
To: vt8500-wm8505-linux-kernel@googlegroups.com
Cc: linux-arm-kernel@lists.infradead.org, Alexey Charkov <alchark@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] input: Add support for VIA VT8500 and compatibles in i8042
Date: Thu, 21 Oct 2010 00:55:35 +0400
Message-Id: <1287608139-21354-3-git-send-email-alchark@gmail.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1287608139-21354-1-git-send-email-alchark@gmail.com>
References: <1287608139-21354-1-git-send-email-alchark@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VIA and WonderMedia Systems-on-Chip feature a standard i8042-compatible
keyboard and mouse controller. This adds necessary glue to enable use
of the standard driver with these systems.

Signed-off-by: Alexey Charkov <alchark@gmail.com>
---

Please review and state whether this could be acceptable for a merge
to mainline in the coming 2.6.37 window. If possible, I would deeply
appreciate a merge to a relevant git tree for integration prior to
asking Linus to pull the changes. I could rebase the code if needed,
currently this is against Linus' master branch.

This patch relies on the basic architecture support for VT8500/WM8505
to be in place, as introduced by PATCH 1/6 in this series.

Due credits go to the community for providing feedback, advice and
testing.

NB: The development is being done at:
http://gitorious.org/linux-on-via-vt8500/vt8500-kernel

Relevant code may be pulled from a git tree in there.

 drivers/input/serio/Kconfig        |    3 +-
 drivers/input/serio/i8042-vt8500.h |   71 ++++++++++++++++++++++++++++++++++++
 drivers/input/serio/i8042.h        |    2 +
 3 files changed, 75 insertions(+), 1 deletions(-)
 create mode 100644 drivers/input/serio/i8042-vt8500.h

diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index 3bfe8fa..2b86774 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -21,7 +21,8 @@ if SERIO
 config SERIO_I8042
 	tristate "i8042 PC Keyboard controller" if EMBEDDED || !X86
 	default y
-	depends on !PARISC && (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST) && \
+	depends on !PARISC && \
+		  (!ARM || ARCH_SHARK || ARCH_VT8500 || FOOTBRIDGE_HOST) && \
 		   (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN
 	help
 	  i8042 is the chip over which the standard AT keyboard and PS/2
diff --git a/drivers/input/serio/i8042-vt8500.h b/drivers/input/serio/i8042-vt8500.h
new file mode 100644
index 0000000..d30df82
--- /dev/null
+++ b/drivers/input/serio/i8042-vt8500.h
@@ -0,0 +1,71 @@
+#ifndef _I8042_VT8500_H
+#define _I8042_VT8500_H
+
+#include <mach/irqs.h>
+#include <mach/vt8500.h>
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+static void __iomem *regbase;
+
+/*
+ * Names.
+ */
+
+#define I8042_KBD_PHYS_DESC "vt8500ps2/serio0"
+#define I8042_AUX_PHYS_DESC "vt8500ps2/serio1"
+#define I8042_MUX_PHYS_DESC "vt8500ps2/serio%d"
+
+/*
+ * IRQs.
+ */
+
+#define I8042_KBD_IRQ	IRQ_PS2KBD
+#define I8042_AUX_IRQ	IRQ_PS2MOUSE
+
+
+/*
+ * Register numbers.
+ */
+
+#define I8042_COMMAND_REG	(regbase + 0x4)
+#define I8042_STATUS_REG	(regbase + 0x4)
+#define I8042_DATA_REG		(regbase + 0x0)
+
+static inline int i8042_read_data(void)
+{
+	return readl(I8042_DATA_REG);
+}
+
+static inline int i8042_read_status(void)
+{
+	return readl(I8042_STATUS_REG);
+}
+
+static inline void i8042_write_data(int val)
+{
+	writel(val, I8042_DATA_REG);
+}
+
+static inline void i8042_write_command(int val)
+{
+	writel(val, I8042_COMMAND_REG);
+}
+
+static inline int i8042_platform_init(void)
+{
+	i8042_reset = 1;
+	regbase = ioremap(VT8500_PS2_BASE, SZ_1K);
+	return 0;
+}
+
+static inline void i8042_platform_exit(void)
+{
+	iounmap(regbase);
+}
+
+#endif /* _I8042_VT8500_H */
diff --git a/drivers/input/serio/i8042.h b/drivers/input/serio/i8042.h
index cbc1beb..bdb2aeb 100644
--- a/drivers/input/serio/i8042.h
+++ b/drivers/input/serio/i8042.h
@@ -16,6 +16,8 @@
 
 #if defined(CONFIG_MACH_JAZZ)
 #include "i8042-jazzio.h"
+#elif defined(CONFIG_ARCH_VT8500)
+#include "i8042-vt8500.h"
 #elif defined(CONFIG_SGI_HAS_I8042)
 #include "i8042-ip22io.h"
 #elif defined(CONFIG_SNI_RM)
-- 
1.7.3.1

