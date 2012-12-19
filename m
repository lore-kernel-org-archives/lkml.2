Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab2LSOnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 09:43:21 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:40355 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751516Ab2LSOnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 09:43:15 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, <stable@kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] mfd: db8500-prcmu: fix irqdomain usage
Date: Wed, 19 Dec 2012 15:42:41 +0100
Message-ID: <1355928161-8082-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This fixes two issues with the DB8500 PRCMU irqdomain:
- You have to state the irq base 0 to get a linear domain
  for the DT case from irq_domain_add_simple()
- The irqdomain was not used to translate the initial irq
  request using irq_create_mapping() making the linear
  case fail as it was lacking a proper descriptor.

I took this opportunity to fix two lines of whitespace
errors in related code as I was anyway messing around with
it.

Cc: stable@kernel.org
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Hi Sam, this is a regression and as such should go into the
-rc series. As you can see I also added the Cc: stable tag.

Yours,
Linus Walleij
---
 drivers/mfd/db8500-prcmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index dc8826d..fcac8e0 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -2524,7 +2524,7 @@ static bool read_mailbox_0(void)
 
 		for (n = 0; n < NUM_PRCMU_WAKEUPS; n++) {
 			if (ev & prcmu_irq_bit[n])
-				generic_handle_irq(IRQ_PRCMU_BASE + n);
+				generic_handle_irq(irq_create_mapping(db8500_irq_domain,n));
 		}
 		r = true;
 		break;
@@ -2737,13 +2737,13 @@ static int db8500_irq_map(struct irq_domain *d, unsigned int virq,
 }
 
 static struct irq_domain_ops db8500_irq_ops = {
-        .map    = db8500_irq_map,
-        .xlate  = irq_domain_xlate_twocell,
+	.map    = db8500_irq_map,
+	.xlate  = irq_domain_xlate_twocell,
 };
 
 static int db8500_irq_init(struct device_node *np)
 {
-	int irq_base = -1;
+	int irq_base = 0;
 
 	/* In the device tree case, just take some IRQs */
 	if (!np)
-- 
1.7.11.3

