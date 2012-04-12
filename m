Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab2DLLdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 07:33:43 -0400
Received: from smtp8.mail.ru ([94.100.176.53]:38848 "EHLO smtp8.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083Ab2DLLdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 07:33:42 -0400
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Dmitry Artamonow <mad_soft@inbox.ru>,
        Paul Parsons <lost.distance@yahoo.com>,
        Philipp Zabel <philipp.zabel@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: asic3: fix asic3_gpio_to_irq
Date: Thu, 12 Apr 2012 15:33:34 +0400
Message-Id: <1334230414-1768-1-git-send-email-mad_soft@inbox.ru>
X-Mailer: git-send-email 1.7.5.1.300.gc565c
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assumption that irq numbers of asic3 gpios start at
IRQ_BOARD_START is certainly wrong - driver may as well
use any other base for its irqs (consider for example
the imaginary case of two ASIC3 chips onboard)

Furthermore, some platforms even don't have IRQ_BOARD_START
defined, so driver will fail to build on them:
-------------------------------------------------------
drivers/mfd/asic3.c: In function 'asic3_gpio_to_irq':
drivers/mfd/asic3.c:530: error: 'IRQ_BOARD_START' undeclared (first use in this function)
drivers/mfd/asic3.c:530: error: (Each undeclared identifier is reported only once
drivers/mfd/asic3.c:530: error: for each function it appears in.)
-------------------------------------------------------

Fix it by using irq_base from driver data.

Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
---
 drivers/mfd/asic3.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

For reference: the build failure above can be reproduced
for example when building kernel for some StrongARM
machine, say:
 make h3600_defconfig
 make menuconfig  #enable CONFIG_MFD_ASIC3
 make

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 1895cf9..1582c3d 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -527,7 +527,9 @@ static void asic3_gpio_set(struct gpio_chip *chip,
 
 static int asic3_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 {
-	return (offset < ASIC3_NUM_GPIOS) ? IRQ_BOARD_START + offset : -ENXIO;
+	struct asic3 *asic = container_of(chip, struct asic3, gpio);
+
+	return (offset < ASIC3_NUM_GPIOS) ? asic->irq_base + offset : -ENXIO;
 }
 
 static __init int asic3_gpio_probe(struct platform_device *pdev,
-- 
1.7.5.1.300.gc565c

