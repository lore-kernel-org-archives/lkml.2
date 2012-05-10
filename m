Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712Ab2EJKAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 06:00:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:50607 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758538Ab2EJKAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 06:00:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="142260993"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] gpio/langwell: re-read the IRQ status register after each iteration
Date: Thu, 10 May 2012 13:01:22 +0300
Message-Id: <1336644082-14137-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spotted by Grant Likely. The IRQ status register should be re-read after
each iteration. Otherwise the loop misses the interrupt if it gets raised
immediately after handled.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
This patch applies on top of my previous patch ("gpio: langwell: convert to
use irq_domain").

 drivers/gpio/gpio-langwell.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
index b067357..a1c8754 100644
--- a/drivers/gpio/gpio-langwell.c
+++ b/drivers/gpio/gpio-langwell.c
@@ -250,11 +250,9 @@ static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
 	/* check GPIO controller to check which pin triggered the interrupt */
 	for (base = 0; base < lnw->chip.ngpio; base += 32) {
 		gedr = gpio_reg(&lnw->chip, base, GEDR);
-		pending = readl(gedr);
-		while (pending) {
+		while ((pending = readl(gedr))) {
 			gpio = __ffs(pending);
 			mask = BIT(gpio);
-			pending &= ~mask;
 			/* Clear before handling so we can't lose an edge */
 			writel(mask, gedr);
 			generic_handle_irq(irq_find_mapping(lnw->domain,
-- 
1.7.9.1

