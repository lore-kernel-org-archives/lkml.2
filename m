Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab1GHJB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 05:01:58 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48317 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720Ab1GHJBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 05:01:54 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] gpio: langwell_gpio: ack the correct bit for langwell gpio
 interrupts
To: grant.likely@secretlab.ca, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Fri, 08 Jul 2011 10:02:18 +0100
Message-ID: <20110708090218.18318.32875.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

The wrong bit was masked when acking langwell gpio interrupts.

Reason for maskig the wrong bit was probably because__ffs() and ffs() functions
return bit indexes differently (0..31 vs 1..32)

This fixes langwell based devices from hanging when a gpio interrupt is
triggered and undoes the breakage which occurred in change set
732063b92bb727b27e61580ce278dddefe31c6ad

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/gpio/langwell_gpio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
index bd6571e..644ba12 100644
--- a/drivers/gpio/langwell_gpio.c
+++ b/drivers/gpio/langwell_gpio.c
@@ -223,7 +223,7 @@ static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
 		gedr = gpio_reg(&lnw->chip, base, GEDR);
 		pending = readl(gedr);
 		while (pending) {
-			gpio = __ffs(pending) - 1;
+			gpio = __ffs(pending);
 			mask = BIT(gpio);
 			pending &= ~mask;
 			/* Clear before handling so we can't lose an edge */

