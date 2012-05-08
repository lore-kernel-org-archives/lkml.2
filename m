Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab2EHJqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 05:46:53 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:57474 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753016Ab2EHJqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 05:46:52 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 09/12] ARM: ux500: delete custom pin control system
Date: Tue, 8 May 2012 11:45:25 +0200
Message-ID: <1336470325-23780-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

At the beginning of the first patch series I included the custom
ux500 pin control system to make sure I could eventually replace
it with the standard subsystem driver. So now that we've done so,
let's remove it.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-pins.c |    1 -
 arch/arm/mach-ux500/pins.c              |   88 -------------------------------
 arch/arm/mach-ux500/pins.h              |   46 ----------------
 3 files changed, 135 deletions(-)
 delete mode 100644 arch/arm/mach-ux500/pins.c
 delete mode 100644 arch/arm/mach-ux500/pins.h

diff --git a/arch/arm/mach-ux500/board-mop500-pins.c b/arch/arm/mach-ux500/board-mop500-pins.c
index 28c456c..157af7e 100644
--- a/arch/arm/mach-ux500/board-mop500-pins.c
+++ b/arch/arm/mach-ux500/board-mop500-pins.c
@@ -17,7 +17,6 @@
 #include <mach/hardware.h>
 
 #include "pins-db8500.h"
-#include "pins.h"
 #include "board-mop500.h"
 
 enum custom_pin_cfg_t {
diff --git a/arch/arm/mach-ux500/pins.c b/arch/arm/mach-ux500/pins.c
deleted file mode 100644
index 38c1d47..0000000
--- a/arch/arm/mach-ux500/pins.c
+++ /dev/null
@@ -1,88 +0,0 @@
-/*
- * Copyright (C) ST-Ericsson SA 2010
- *
- * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
- * License terms: GNU General Public License (GPL), version 2
- */
-
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/device.h>
-#include <linux/mutex.h>
-#include <linux/spinlock.h>
-#include <linux/err.h>
-#include <plat/pincfg.h>
-
-#include "pins.h"
-
-static LIST_HEAD(pin_lookups);
-static DEFINE_MUTEX(pin_lookups_mutex);
-static DEFINE_SPINLOCK(pins_lock);
-
-void __init ux500_pins_add(struct ux500_pin_lookup *pl, size_t num)
-{
-	mutex_lock(&pin_lookups_mutex);
-
-	while (num--) {
-		list_add_tail(&pl->node, &pin_lookups);
-		pl++;
-	}
-
-	mutex_unlock(&pin_lookups_mutex);
-}
-
-struct ux500_pins *ux500_pins_get(const char *name)
-{
-	struct ux500_pins *pins = NULL;
-	struct ux500_pin_lookup *pl;
-
-	mutex_lock(&pin_lookups_mutex);
-
-	list_for_each_entry(pl, &pin_lookups, node) {
-		if (!strcmp(pl->name, name)) {
-			pins = pl->pins;
-			goto out;
-		}
-	}
-
-out:
-	mutex_unlock(&pin_lookups_mutex);
-	return pins;
-}
-
-int ux500_pins_enable(struct ux500_pins *pins)
-{
-	unsigned long flags;
-	int ret = 0;
-
-	spin_lock_irqsave(&pins_lock, flags);
-
-	if (pins->usage++ == 0)
-		ret = nmk_config_pins(pins->cfg, pins->num);
-
-	spin_unlock_irqrestore(&pins_lock, flags);
-	return ret;
-}
-
-int ux500_pins_disable(struct ux500_pins *pins)
-{
-	unsigned long flags;
-	int ret = 0;
-
-	spin_lock_irqsave(&pins_lock, flags);
-
-	if (WARN_ON(pins->usage == 0))
-		goto out;
-
-	if (--pins->usage == 0)
-		ret = nmk_config_pins_sleep(pins->cfg, pins->num);
-
-out:
-	spin_unlock_irqrestore(&pins_lock, flags);
-	return ret;
-}
-
-void ux500_pins_put(struct ux500_pins *pins)
-{
-	WARN_ON(!pins);
-}
diff --git a/arch/arm/mach-ux500/pins.h b/arch/arm/mach-ux500/pins.h
deleted file mode 100644
index 0d36af2..0000000
--- a/arch/arm/mach-ux500/pins.h
+++ /dev/null
@@ -1,46 +0,0 @@
-/*
- * Copyright (C) ST-Ericsson SA 2010
- *
- * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
- * License terms: GNU General Public License (GPL), version 2
- */
-
-#ifndef __MACH_UX500_PINS_H
-#define __MACH_UX500_PINS_H
-
-#include <linux/list.h>
-#include <plat/pincfg.h>
-
-#define PIN_LOOKUP(_name, _pins)	\
-{					\
-	.name	= _name,		\
-	.pins	= _pins,		\
-}
-
-#define UX500_PINS(name, pins...)			\
-struct ux500_pins name = {				\
-	.cfg = (pin_cfg_t[]) {pins},			\
-	.num = ARRAY_SIZE(((pin_cfg_t[]) {pins})),	\
-}
-
-struct ux500_pins {
-	int usage;
-	int num;
-	pin_cfg_t *cfg;
-};
-
-struct ux500_pin_lookup {
-	struct list_head	node;
-	const char		*name;
-	struct ux500_pins	*pins;
-};
-
-void __init ux500_pins_add(struct ux500_pin_lookup *pl, size_t num);
-void __init ux500_offchip_gpio_init(struct ux500_pins *pins);
-struct ux500_pins *ux500_pins_get(const char *name);
-int ux500_pins_enable(struct ux500_pins *pins);
-int ux500_pins_disable(struct ux500_pins *pins);
-void ux500_pins_put(struct ux500_pins *pins);
-int pins_for_u9500(void);
-
-#endif
-- 
1.7.9.2

