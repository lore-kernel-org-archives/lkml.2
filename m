Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab2FRP5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 11:57:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64675 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab2FRP53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 11:57:29 -0400
Date: Mon, 18 Jun 2012 17:57:24 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: [PATCH 1/2 v2] regulator: support multiple dummy fixed regulators
In-Reply-To: <20120618115738.GI3974@opensource.wolfsonmicro.com>
Message-ID: <Pine.LNX.4.64.1206181755370.23884@axis700.grange>
References: <Pine.LNX.4.64.1206181017360.23884@axis700.grange>
 <20120618094145.GC3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181145520.23884@axis700.grange>
 <20120618100657.GG3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181212180.23884@axis700.grange>
 <20120618115738.GI3974@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:fyULnVY6guVUJ9nCzFAqf519G9P9AuTsQiikGDaPlOj
 btFNNHWm1FEtdpTopMqrMRc8YI+KKdXFGkIJiVp/IIPJkP6/Fb
 68SuwuPt5lMGzPt4JUmHaALo5fXsAUQ/s5ZGhig04vhxaZq+rk
 TXnQeYotjJlnYQYaPW703vfHKG1IO34rVE2fQiSQkHENVk1jCl
 1fWHO7SaVZ4bmXkVz2WhQ7qJ0GfV8wNVvFp8x0cFf4f1ERpW9P
 Qqa2EXB49qkFQSaatSafv165qhSZ5PnIdmk02QH1UxxcqLl/aF
 I3jwZrbs8uzIe7aZxNBEdRn8cCP4rPwyapmMhdpWrqPbsJ9iPh
 OpUB2UBt9M7b0RW5+WAtADD2YR5v0qxLS0iJnVz6Do06AAyfV5
 ZRBW44ct2h1Dg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently regulator_register_fixed() uses a constant name to register a
fixed dummy regulator. This is sufficient in principle, since there is no
reason to register multiple such regulators. The user can simply supply all
consumers in one array and use it to initialise such a regulator. However,
in some cases it can be convenient to register multiple such regulators.
This is also easy to achieve by appending the device ID to the name. It is
also consistent with the current behaviour of the code, that fixes a name
itself without giving the user a possibility to provide a custom one.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/regulator/fixed-helper.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/fixed-helper.c b/drivers/regulator/fixed-helper.c
index cacd33c..f66d9e8 100644
--- a/drivers/regulator/fixed-helper.c
+++ b/drivers/regulator/fixed-helper.c
@@ -1,12 +1,17 @@
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/fixed.h>
 
+#define FIXED_BASE "fixed-dummy"
+#define FIXED_NAME FIXED_BASE "-00"
+
 struct fixed_regulator_data {
 	struct fixed_voltage_config cfg;
 	struct regulator_init_data init_data;
 	struct platform_device pdev;
+	char name[sizeof(FIXED_NAME)];
 };
 
 static void regulator_fixed_release(struct device *dev)
@@ -31,7 +36,12 @@ struct platform_device *regulator_register_fixed(int id,
 	if (!data)
 		return NULL;
 
-	data->cfg.supply_name = "fixed-dummy";
+	if (id < 0)
+		strcpy(data->name, FIXED_BASE);
+	else
+		snprintf(data->name, sizeof(FIXED_NAME), FIXED_BASE "-%d", id);
+
+	data->cfg.supply_name = data->name;
 	data->cfg.microvolts = 0;
 	data->cfg.gpio = -EINVAL;
 	data->cfg.enabled_at_boot = 1;
-- 
1.7.2.5

