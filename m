Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab2BWMLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 07:11:16 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46319 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab2BWMKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 07:10:44 -0500
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <khilman@ti.com>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>
Subject: [PATCH 5/6] gpio/omap: fix trigger type to unsigned
Date: Thu, 23 Feb 2012 17:40:30 +0530
Message-ID: <1329999031-6914-6-git-send-email-tarun.kanti@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1329999031-6914-1-git-send-email-tarun.kanti@ti.com>
References: <1329999031-6914-1-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPIO trigger parameter is of type unsigned.
enum {
        IRQ_TYPE_NONE           = 0x00000000,
        IRQ_TYPE_EDGE_RISING    = 0x00000001,
        IRQ_TYPE_EDGE_FALLING   = 0x00000002,
        IRQ_TYPE_EDGE_BOTH      = (IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING),
        IRQ_TYPE_LEVEL_HIGH     = 0x00000004,
        IRQ_TYPE_LEVEL_LOW      = 0x00000008,
        IRQ_TYPE_LEVEL_MASK     = (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH),
        IRQ_TYPE_SENSE_MASK     = 0x0000000f,

        IRQ_TYPE_PROBE          = 0x00000010,
...
};
Even though gpio_irq_type(struct irq_data *d, unsigned type) has the right type
of parameter, the subsequent called functions set_gpio_triggering() and
set_gpio_trigger() wrongly makes it signed integer. Fix this.

Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
---
 drivers/gpio/gpio-omap.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 3dd4b3a..67535c8 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -232,7 +232,7 @@ static void _set_gpio_debounce(struct gpio_bank *bank, unsigned gpio,
 }
 
 static inline void set_gpio_trigger(struct gpio_bank *bank, int gpio,
-						int trigger)
+						unsigned trigger)
 {
 	void __iomem *base = bank->base;
 	u32 gpio_bit = 1 << gpio;
@@ -314,7 +314,8 @@ static void _toggle_gpio_edge_triggering(struct gpio_bank *bank, int gpio)
 static void _toggle_gpio_edge_triggering(struct gpio_bank *bank, int gpio) {}
 #endif
 
-static int _set_gpio_triggering(struct gpio_bank *bank, int gpio, int trigger)
+static int _set_gpio_triggering(struct gpio_bank *bank, int gpio,
+							unsigned trigger)
 {
 	void __iomem *reg = bank->base;
 	void __iomem *base = bank->base;
-- 
1.7.0.4

