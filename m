Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab1FCBIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 21:08:52 -0400
Received: from smtp-out-212.synserver.de ([212.40.185.212]:1064 "EHLO
	smtp-out-212.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab1FCBIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 21:08:31 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 8419
From: Lars-Peter Clausen <lars@metafoo.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 3/4] MIPS: JZ4740: GPIO: Simplify IRQ demuxer
Date: Fri,  3 Jun 2011 03:06:50 +0200
Message-Id: <1307063211-10098-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1307063211-10098-1-git-send-email-lars@metafoo.de>
References: <1307063211-10098-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already know the base IRQ for a GPIO chip, so there is no need to recalculate
it in the demux handler.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 arch/mips/jz4740/gpio.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/mips/jz4740/gpio.c b/arch/mips/jz4740/gpio.c
index ab583b8..f3590a2 100644
--- a/arch/mips/jz4740/gpio.c
+++ b/arch/mips/jz4740/gpio.c
@@ -301,22 +301,16 @@ static void jz_gpio_irq_demux_handler(unsigned int irq, struct irq_desc *desc)
 {
 	uint32_t flag;
 	unsigned int gpio_irq;
-	unsigned int gpio_bank;
 	struct jz_gpio_chip *chip = irq_desc_get_handler_data(desc);
 
-	gpio_bank = JZ4740_IRQ_GPIO0 - irq;
-
 	flag = readl(chip->base + JZ_REG_GPIO_FLAG);
-
 	if (!flag)
 		return;
 
-	gpio_irq = __fls(flag);
+	gpio_irq = chip->irq_base + __fls(flag);
 
 	jz_gpio_check_trigger_both(chip, irq);
 
-	gpio_irq += (gpio_bank << 5) + JZ4740_IRQ_GPIO(0);
-
 	generic_handle_irq(gpio_irq);
 };
 
-- 
1.7.2.5

