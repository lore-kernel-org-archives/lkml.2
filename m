Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab2I0NOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 09:14:36 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:35428 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753734Ab2I0NOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 09:14:33 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 1/4] pinctrl/nomadik: use irq_find_mapping()
Date: Thu, 27 Sep 2012 15:13:35 +0200
Message-ID: <1348751615-17379-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The code was using a homegrown method of looking up the offset
from the irq domain, not to be encouraged. Use the proper
irq_find_mapping() call instead.

Cc: Lee Jones <lee.jones@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 3dde653..e031c84 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -826,16 +826,14 @@ static void __nmk_gpio_irq_handler(unsigned int irq, struct irq_desc *desc,
 {
 	struct nmk_gpio_chip *nmk_chip;
 	struct irq_chip *host_chip = irq_get_chip(irq);
-	unsigned int first_irq;
 
 	chained_irq_enter(host_chip, desc);
 
 	nmk_chip = irq_get_handler_data(irq);
-	first_irq = nmk_chip->domain->revmap_data.legacy.first_irq;
 	while (status) {
 		int bit = __ffs(status);
 
-		generic_handle_irq(first_irq + bit);
+		generic_handle_irq(irq_find_mapping(nmk_chip->domain, bit));
 		status &= ~BIT(bit);
 	}
 
-- 
1.7.11.3

