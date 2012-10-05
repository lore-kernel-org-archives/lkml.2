Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487Ab2JEPeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 11:34:07 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38332 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478Ab2JEPcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 11:32:07 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 05/10] mfd: Enable the STMPE MFD for Device Tree
Date: Fri,  5 Oct 2012 16:31:41 +0100
Message-Id: <1349451107-8009-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349451107-8009-1-git-send-email-lee.jones@linaro.org>
References: <1349451107-8009-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows the STMPE Multi-Functional Device to be correctly
initialised when booting with Device Tree support enabled. Its
children are specified by the addition of subordinate devices to the
STMPE node in the Device Tree file.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/stmpe.c |   48 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 42 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index e50ebdf..ba157d4 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -885,18 +885,19 @@ static struct irq_domain_ops stmpe_irq_ops = {
         .xlate  = irq_domain_xlate_twocell,
 };
 
-static int __devinit stmpe_irq_init(struct stmpe *stmpe)
+static int __devinit stmpe_irq_init(struct stmpe *stmpe,
+				struct device_node *np)
 {
 	int base = stmpe->irq_base;
 	int num_irqs = stmpe->variant->num_irqs;
 
 	if (base) {
 		stmpe->domain = irq_domain_add_legacy(
-			NULL, num_irqs, base, 0, &stmpe_irq_ops, stmpe);
+			np, num_irqs, base, 0, &stmpe_irq_ops, stmpe);
 	}
 	else {
 		stmpe->domain = irq_domain_add_linear(
-			NULL, num_irqs, &stmpe_irq_ops, stmpe);
+			np, num_irqs, &stmpe_irq_ops, stmpe);
 	}
 
 	if (!stmpe->domain) {
@@ -1016,15 +1017,50 @@ static int __devinit stmpe_devices_init(struct stmpe *stmpe)
 	return ret;
 }
 
+void __devinit stmpe_of_probe(struct stmpe_platform_data *pdata,
+			struct device_node *np)
+{
+	struct device_node *child;
+
+	of_property_read_u32(np, "st,autosleep-timeout",
+			&pdata->autosleep_timeout);
+
+	pdata->autosleep = (pdata->autosleep_timeout) ? true : false;
+
+	for_each_child_of_node(np, child) {
+		if (!strcmp(child->name, "stmpe_gpio")) {
+			pdata->blocks |= STMPE_BLOCK_GPIO;
+		}
+		if (!strcmp(child->name, "stmpe_keypad")) {
+			pdata->blocks |= STMPE_BLOCK_KEYPAD;
+		}
+		if (!strcmp(child->name, "stmpe_touchscreen")) {
+			pdata->blocks |= STMPE_BLOCK_TOUCHSCREEN;
+		}
+		if (!strcmp(child->name, "stmpe_adc")) {
+			pdata->blocks |= STMPE_BLOCK_ADC;
+		}
+	}
+}
+
 /* Called from client specific probe routines */
 int __devinit stmpe_probe(struct stmpe_client_info *ci, int partnum)
 {
 	struct stmpe_platform_data *pdata = dev_get_platdata(ci->dev);
+	struct device_node *np = ci->dev->of_node;
 	struct stmpe *stmpe;
 	int ret;
 
-	if (!pdata)
-		return -EINVAL;
+	if (!pdata) {
+		if (np) {
+			pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
+			if (!pdata)
+				return -ENOMEM;
+
+			stmpe_of_probe(pdata, np);
+		} else
+			return -EINVAL;
+	}
 
 	stmpe = kzalloc(sizeof(struct stmpe), GFP_KERNEL);
 	if (!stmpe)
@@ -1080,7 +1116,7 @@ int __devinit stmpe_probe(struct stmpe_client_info *ci, int partnum)
 		goto free_gpio;
 
 	if (stmpe->irq >= 0) {
-		ret = stmpe_irq_init(stmpe);
+		ret = stmpe_irq_init(stmpe, np);
 		if (ret)
 			goto free_gpio;
 
-- 
1.7.9.5

