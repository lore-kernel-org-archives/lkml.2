Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab2JJRyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 13:54:10 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4751 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200Ab2JJRxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 13:53:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 10 Oct 2012 10:42:36 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <gregkh@linuxfoundation.org>,
        <sameo@linux.intel.com>
CC: <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 4/5] regmap: add API to get irq_domain from regmap irq
Date: Wed, 10 Oct 2012 22:49:04 +0530
Message-ID: <1349889545-21517-5-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1349889545-21517-1-git-send-email-ldewangan@nvidia.com>
References: <1349889545-21517-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add API regmap_irq_get_irq_domain() for getting the
irq domain from regmap irq. The irq domain created on
result of regmap_add_irq_chip() from driver.

This API is useful in mfd driver when driver add mfd sub devices.
The sub devices IRQs can be passed through IORESOURCE_IRQ and it
need to be mapped properly  with device irq domain. The
mfd_add_devices() creates mapping when adding sub devices and for
this it is require to have irq domain.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- Add stubbing of new API.
- Add empty line between paragraph.

 drivers/base/regmap/regmap-irq.c |   16 ++++++++++++++++
 include/linux/regmap.h           |    8 ++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 5b6b1d8..70bce5f 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -458,3 +458,19 @@ int regmap_irq_get_virq(struct regmap_irq_chip_data *data, int irq)
 	return irq_create_mapping(data->domain, irq);
 }
 EXPORT_SYMBOL_GPL(regmap_irq_get_virq);
+
+/**
+ * regmap_irq_get_irq_domain(): Return IRQ domain for of the interrupt added.
+ *
+ * Useful for drivers who locally create mapping from irq_domain which is
+ * created on result of the call regmap_add_irq_chip().
+ *
+ * @data: regmap_irq controller to operate on.
+ */
+struct irq_domain *regmap_irq_get_irq_domain(struct regmap_irq_chip_data *data)
+{
+	if (data)
+		return data->domain;
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(regmap_irq_get_irq_domain);
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index e3bcc3f..d3216a7 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -317,6 +317,7 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 void regmap_del_irq_chip(int irq, struct regmap_irq_chip_data *data);
 int regmap_irq_chip_get_base(struct regmap_irq_chip_data *data);
 int regmap_irq_get_virq(struct regmap_irq_chip_data *data, int irq);
+struct irq_domain *regmap_irq_get_irq_domain(struct regmap_irq_chip_data *data);
 
 #else
 
@@ -433,6 +434,13 @@ static inline struct regmap *dev_get_regmap(struct device *dev,
 	return NULL;
 }
 
+static inline struct irq_domain *regmap_irq_get_irq_domain(
+			struct regmap_irq_chip_data *data)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return NULL;
+}
+
 #endif
 
 #endif
-- 
1.7.1.1

