Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942Ab2FVMg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 08:36:58 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:60748 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761794Ab2FVMgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 08:36:22 -0400
From: Graeme Gregory <gg@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        s-guiriec@ti.com, Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCH 2/3] MFD: add missing hunk to change irq to clear on read
Date: Fri, 22 Jun 2012 13:36:19 +0100
Message-Id: <1340368581-11882-3-git-send-email-gg@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340368581-11882-1-git-send-email-gg@slimlogic.co.uk>
References: <1340368581-11882-1-git-send-email-gg@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During conversion to regmap_irq this hunk was missing being moved
to MFD driver to put the chip into clear on read mode. Also as slave
is now set use it to determine which slave for the register call.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
---
 drivers/mfd/palmas.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index 7dfb018..7ec7d8d 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -356,7 +356,14 @@ static int __devinit palmas_i2c_probe(struct i2c_client *i2c,
 		}
 	}
 
-	ret = regmap_add_irq_chip(palmas->regmap[1], palmas->irq,
+	/* Change IRQ into clear on read mode for efficiency */
+	slave = PALMAS_BASE_TO_SLAVE(PALMAS_INTERRUPT_BASE);
+	addr = PALMAS_BASE_TO_REG(PALMAS_INTERRUPT_BASE, PALMAS_INT_CTRL);
+	reg = PALMAS_INT_CTRL_INT_CLEAR;
+
+	regmap_write(palmas->regmap[slave], addr, reg);
+
+	ret = regmap_add_irq_chip(palmas->regmap[slave], palmas->irq,
 			IRQF_ONESHOT | IRQF_TRIGGER_LOW, -1, &palmas_irq_chip,
 			&palmas->irq_data);
 	if (ret < 0)
-- 
1.7.9.5

