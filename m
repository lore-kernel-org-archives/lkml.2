Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab2FILLG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 07:11:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46959 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab2FILLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 07:11:01 -0400
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH v2 2/2] regulator: Parse ramp_delay in while parsing DT for regulators.
Date: Sat,  9 Jun 2012 16:40:39 +0530
Message-Id: <1339240239-5626-2-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1339240239-5626-1-git-send-email-yadi.brar@samsung.com>
References: <1339240239-5626-1-git-send-email-yadi.brar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some hardwares ramp_delay for BUCKs is a configurable parameter which can
be configured through DT.This patch adds support for parsing ramp_delay also
while parsing DT for regulators.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 .../devicetree/bindings/regulator/regulator.txt    |    1 +
 drivers/regulator/of_regulator.c                   |    6 ++++++
 include/linux/regulator/machine.h                  |    2 ++
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
index 5b7a408..d0a7b12 100644
--- a/Documentation/devicetree/bindings/regulator/regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -10,6 +10,7 @@ Optional properties:
 - regulator-always-on: boolean, regulator should never be disabled
 - regulator-boot-on: bootloader/firmware enabled regulator
 - <name>-supply: phandle to the parent supply/regulator node
+- regulator-ramp-delay: ramp delay for regulator(in mV/uS)
 
 Example:
 
diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 56593b7..8b9cb53 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -74,6 +74,7 @@ struct regulator_init_data *of_get_regulator_init_data(struct device *dev,
 						struct device_node *node)
 {
 	struct regulator_init_data *init_data;
+	const __be32 *ramp_delay;
 
 	if (!node)
 		return NULL;
@@ -83,6 +84,11 @@ struct regulator_init_data *of_get_regulator_init_data(struct device *dev,
 		return NULL; /* Out of memory? */
 
 	of_get_regulation_constraints(node, &init_data);
+
+	ramp_delay = of_get_property(node, "regulator-ramp-delay", NULL);
+	if (ramp_delay)
+		init_data->ramp_delay = be32_to_cpu(*ramp_delay);
+
 	return init_data;
 }
 EXPORT_SYMBOL_GPL(of_get_regulator_init_data);
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index b021084..bb29a6b 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -177,6 +177,8 @@ struct regulator_init_data {
 	int num_consumer_supplies;
 	struct regulator_consumer_supply *consumer_supplies;
 
+	int ramp_delay;		/* unit:mV/us */
+
 	/* optional regulator machine specific init */
 	int (*regulator_init)(void *driver_data);
 	void *driver_data;	/* core does not touch this */
-- 
1.7.0.4

