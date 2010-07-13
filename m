Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744Ab0GMGY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 02:24:27 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:35626 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751066Ab0GMGYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 02:24:25 -0400
From: Sundar Iyer <sundar.iyer@stericsson.com>
To: <lrg@slimlogic.co.uk>, <broonie@opensource.wolfsonmicro.com>,
        <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <STEricsson_nomadik_linux@list.st.com>,
        Sundar R Iyer <sundar.iyer@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "Acked-By: Mattias Wallin" <mattias.wallin@stericsson.com>,
        "Acked-By: Bengt JONSSON" <bengt.g.jonsson@stericsson.com>
Subject: [PATCH 1/3] ab8500-mfd: add regulator support to ab8500 mfd device
Date: Tue, 13 Jul 2010 11:51:28 +0530
Message-ID: <1279002090-11234-2-git-send-email-sundar.iyer@stericsson.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1279002090-11234-1-git-send-email-sundar.iyer@stericsson.com>
References: <1279002090-11234-1-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sundar R Iyer <sundar.iyer@stericsson.com>

Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Acked-By: Mattias Wallin <mattias.wallin@stericsson.com>
Acked-By: Bengt JONSSON <bengt.g.jonsson@stericsson.com>
Signed-off-by: Sundar R Iyer <sundar.iyer@stericsson.com>
---
 drivers/mfd/ab8500-core.c        |    4 +++-
 include/linux/mfd/ab8500.h       |    6 ++++++
 include/linux/regulator/ab8500.h |   25 +++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/regulator/ab8500.h

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index f3d26fa..defa786 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -16,6 +16,7 @@
 #include <linux/platform_device.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/ab8500.h>
+#include <linux/regulator/ab8500.h>
 
 /*
  * Interrupt register offsets
@@ -352,6 +353,7 @@ static struct mfd_cell ab8500_devs[] = {
 	{ .name = "ab8500-audio", },
 	{ .name = "ab8500-usb", },
 	{ .name = "ab8500-pwm", },
+	{ .name = "ab8500-regulator", },
 };
 
 int __devinit ab8500_init(struct ab8500 *ab8500)
@@ -411,7 +413,7 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
 			goto out_removeirq;
 	}
 
-	ret = mfd_add_devices(ab8500->dev, -1, ab8500_devs,
+	ret = mfd_add_devices(ab8500->dev, 0, ab8500_devs,
 			      ARRAY_SIZE(ab8500_devs), NULL,
 			      ab8500->irq_base);
 	if (ret)
diff --git a/include/linux/mfd/ab8500.h b/include/linux/mfd/ab8500.h
index b63ff3b..f5cec45 100644
--- a/include/linux/mfd/ab8500.h
+++ b/include/linux/mfd/ab8500.h
@@ -76,6 +76,8 @@
 #define AB8500_NR_IRQS			104
 #define AB8500_NUM_IRQ_REGS		13
 
+#define AB8500_NUM_REGULATORS   15
+
 /**
  * struct ab8500 - ab8500 internal structure
  * @dev: parent device
@@ -108,14 +110,18 @@ struct ab8500 {
 	u8 oldmask[AB8500_NUM_IRQ_REGS];
 };
 
+struct regulator_init_data;
+
 /**
  * struct ab8500_platform_data - AB8500 platform data
  * @irq_base: start of AB8500 IRQs, AB8500_NR_IRQS will be used
  * @init: board-specific initialization after detection of ab8500
+ * @regulator: machine-specific constraints for regulators
  */
 struct ab8500_platform_data {
 	int irq_base;
 	void (*init) (struct ab8500 *);
+	struct regulator_init_data *regulator[AB8500_NUM_REGULATORS];
 };
 
 extern int ab8500_write(struct ab8500 *a8500, u16 addr, u8 data);
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
new file mode 100644
index 0000000..f509877
--- /dev/null
+++ b/include/linux/regulator/ab8500.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License v2
+ *
+ * Author: Sundar Iyer <sundar.iyer@stericsson.com> for ST-Ericsson
+ *
+ */
+
+#ifndef __LINUX_MFD_AB8500_REGULATOR_H
+#define __LINUX_MFD_AB8500_REGULATOR_H
+
+/* AB8500 regulators */
+#define AB8500_LDO_AUX1         0
+#define AB8500_LDO_AUX2         1
+#define AB8500_LDO_AUX3         2
+#define AB8500_LDO_INTCORE      3
+#define AB8500_LDO_TVOUT        4
+#define AB8500_LDO_AUDIO	5
+#define AB8500_LDO_ANAMIC1      6
+#define AB8500_LDO_ANAMIC2      7
+#define AB8500_LDO_DMIC         8
+#define AB8500_LDO_ANA          9
+
+#endif
-- 
1.7.0

