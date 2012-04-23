Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab2DWJPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 05:15:23 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:53617 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751721Ab2DWJPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 05:15:20 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Philippe LANGLAIS <philippe.langlais@stericsson.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 8/9] ARM: ux500: implement pin API
Date: Mon, 23 Apr 2012 11:15:06 +0200
Message-ID: <1335172506-27755-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Implement an API to allow a list of pincfgs to be remuxed to active
and sleep modes, for power saving. This is not exported on purpose,
because it is not to be called by drivers directly.

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Reviewed-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/Makefile            |    2 +-
 arch/arm/mach-ux500/board-mop500-pins.c |    1 +
 arch/arm/mach-ux500/pins.c              |   88 +++++++++++++++++++++++++++++++
 arch/arm/mach-ux500/pins.h              |   46 ++++++++++++++++
 4 files changed, 136 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/mach-ux500/pins.c
 create mode 100644 arch/arm/mach-ux500/pins.h

diff --git a/arch/arm/mach-ux500/Makefile b/arch/arm/mach-ux500/Makefile
index 465b9ec..bfd902d 100644
--- a/arch/arm/mach-ux500/Makefile
+++ b/arch/arm/mach-ux500/Makefile
@@ -3,7 +3,7 @@
 #
 
 obj-y				:= clock.o cpu.o devices.o devices-common.o \
-				   id.o usb.o timer.o
+				   id.o pins.o usb.o timer.o
 obj-$(CONFIG_CACHE_L2X0)	+= cache-l2x0.o
 obj-$(CONFIG_UX500_SOC_DB5500)	+= cpu-db5500.o dma-db5500.o
 obj-$(CONFIG_UX500_SOC_DB8500)	+= cpu-db8500.o devices-db8500.o
diff --git a/arch/arm/mach-ux500/board-mop500-pins.c b/arch/arm/mach-ux500/board-mop500-pins.c
index f5413dc..e2a2e50 100644
--- a/arch/arm/mach-ux500/board-mop500-pins.c
+++ b/arch/arm/mach-ux500/board-mop500-pins.c
@@ -14,6 +14,7 @@
 #include <mach/hardware.h>
 
 #include "pins-db8500.h"
+#include "pins.h"
 
 static pin_cfg_t mop500_pins_common[] = {
 	/* I2C */
diff --git a/arch/arm/mach-ux500/pins.c b/arch/arm/mach-ux500/pins.c
new file mode 100644
index 0000000..38c1d47
--- /dev/null
+++ b/arch/arm/mach-ux500/pins.c
@@ -0,0 +1,88 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
+ * License terms: GNU General Public License (GPL), version 2
+ */
+
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/device.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/err.h>
+#include <plat/pincfg.h>
+
+#include "pins.h"
+
+static LIST_HEAD(pin_lookups);
+static DEFINE_MUTEX(pin_lookups_mutex);
+static DEFINE_SPINLOCK(pins_lock);
+
+void __init ux500_pins_add(struct ux500_pin_lookup *pl, size_t num)
+{
+	mutex_lock(&pin_lookups_mutex);
+
+	while (num--) {
+		list_add_tail(&pl->node, &pin_lookups);
+		pl++;
+	}
+
+	mutex_unlock(&pin_lookups_mutex);
+}
+
+struct ux500_pins *ux500_pins_get(const char *name)
+{
+	struct ux500_pins *pins = NULL;
+	struct ux500_pin_lookup *pl;
+
+	mutex_lock(&pin_lookups_mutex);
+
+	list_for_each_entry(pl, &pin_lookups, node) {
+		if (!strcmp(pl->name, name)) {
+			pins = pl->pins;
+			goto out;
+		}
+	}
+
+out:
+	mutex_unlock(&pin_lookups_mutex);
+	return pins;
+}
+
+int ux500_pins_enable(struct ux500_pins *pins)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&pins_lock, flags);
+
+	if (pins->usage++ == 0)
+		ret = nmk_config_pins(pins->cfg, pins->num);
+
+	spin_unlock_irqrestore(&pins_lock, flags);
+	return ret;
+}
+
+int ux500_pins_disable(struct ux500_pins *pins)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&pins_lock, flags);
+
+	if (WARN_ON(pins->usage == 0))
+		goto out;
+
+	if (--pins->usage == 0)
+		ret = nmk_config_pins_sleep(pins->cfg, pins->num);
+
+out:
+	spin_unlock_irqrestore(&pins_lock, flags);
+	return ret;
+}
+
+void ux500_pins_put(struct ux500_pins *pins)
+{
+	WARN_ON(!pins);
+}
diff --git a/arch/arm/mach-ux500/pins.h b/arch/arm/mach-ux500/pins.h
new file mode 100644
index 0000000..0d36af2
--- /dev/null
+++ b/arch/arm/mach-ux500/pins.h
@@ -0,0 +1,46 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
+ * License terms: GNU General Public License (GPL), version 2
+ */
+
+#ifndef __MACH_UX500_PINS_H
+#define __MACH_UX500_PINS_H
+
+#include <linux/list.h>
+#include <plat/pincfg.h>
+
+#define PIN_LOOKUP(_name, _pins)	\
+{					\
+	.name	= _name,		\
+	.pins	= _pins,		\
+}
+
+#define UX500_PINS(name, pins...)			\
+struct ux500_pins name = {				\
+	.cfg = (pin_cfg_t[]) {pins},			\
+	.num = ARRAY_SIZE(((pin_cfg_t[]) {pins})),	\
+}
+
+struct ux500_pins {
+	int usage;
+	int num;
+	pin_cfg_t *cfg;
+};
+
+struct ux500_pin_lookup {
+	struct list_head	node;
+	const char		*name;
+	struct ux500_pins	*pins;
+};
+
+void __init ux500_pins_add(struct ux500_pin_lookup *pl, size_t num);
+void __init ux500_offchip_gpio_init(struct ux500_pins *pins);
+struct ux500_pins *ux500_pins_get(const char *name);
+int ux500_pins_enable(struct ux500_pins *pins);
+int ux500_pins_disable(struct ux500_pins *pins);
+void ux500_pins_put(struct ux500_pins *pins);
+int pins_for_u9500(void);
+
+#endif
-- 
1.7.9.2

