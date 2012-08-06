Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab2HFKsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 06:48:19 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59033 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab2HFKrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 06:47:06 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, dmitry.torokhov@gmail.com, sameo@linux.intel.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4/6] mfd: Use interrupt-parent as IRQ controller if specified in DT
Date: Mon,  6 Aug 2012 11:46:40 +0100
Message-Id: <1344250002-6011-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344250002-6011-1-git-send-email-lee.jones@linaro.org>
References: <1344250002-6011-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch the default behaviour is to climb the Device
Tree and use the first encountered interrupt controller. This
does not take into account if a device node has specified to use
a particular IRQ controller using the interrupt-parent property.
This patch ensures that property is adhered to.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/mfd-core.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 0c3a01c..f10f27b 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/irqdomain.h>
 #include <linux/of.h>
+#include <linux/of_irq.h>
 
 int mfd_cell_enable(struct platform_device *pdev)
 {
@@ -78,7 +79,7 @@ static int mfd_add_device(struct device *parent, int id,
 {
 	struct resource *res;
 	struct platform_device *pdev;
-	struct device_node *np = NULL;
+	struct device_node *np, *parent_node = NULL;
 	struct irq_domain *domain = NULL;
 	int ret = -ENOMEM;
 	int r;
@@ -97,7 +98,12 @@ static int mfd_add_device(struct device *parent, int id,
 		for_each_child_of_node(parent->of_node, np) {
 			if (of_device_is_compatible(np, cell->of_compatible)) {
 				pdev->dev.of_node = np;
-				domain = irq_find_host(parent->of_node);
+#ifdef CONFIG_OF
+				parent_node = of_irq_find_parent(np);
+#endif
+				if (!parent_node)
+					parent_node = parent->of_node;
+				domain = irq_find_host(parent_node);
 				break;
 			}
 		}
-- 
1.7.9.5

