Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161171Ab2KNLfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 06:35:04 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42148 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab2KNLfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 06:35:02 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Frank Li <Frank.Li@freescale.com>
Subject: [PATCH 1/1] regulator: gpio-regulator: Catch 'no states property' misuse
Date: Wed, 14 Nov 2012 11:34:48 +0000
Message-Id: <1352892888-15546-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A selection of voltage or current values (AKA states) should always
be specified when using a GPIO regulator. If there are no switchable
states then the fixed regulators should be used instead.

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Frank Li <Frank.Li@freescale.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../bindings/regulator/gpio-regulator.txt          |    3 ++-
 drivers/regulator/gpio-regulator.c                 |    5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/regulator/gpio-regulator.txt b/Documentation/devicetree/bindings/regulator/gpio-regulator.txt
index 3703be2..827fa70 100644
--- a/Documentation/devicetree/bindings/regulator/gpio-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/gpio-regulator.txt
@@ -2,11 +2,12 @@ GPIO controlled regulators
 
 Required properties:
 - compatible		: Must be "regulator-gpio".
+- states		: Selection of available voltages and GPIO configs.
+                         (if you don't have states, then use a fixed regulator)
 
 Optional properties:
 - gpio-enable		: GPIO to use to enable/disable the regulator.
 - gpios			: GPIO group used to control voltage.
-- states		: Selection of available voltages and GPIO configs.
 - startup-delay-us	: Startup time in microseconds.
 - enable-active-high	: Polarity of GPIO is active high (default is low).
 
diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index e467d0a..c82edab 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -183,6 +183,11 @@ of_get_gpio_regulator_config(struct device *dev, struct device_node *np)
 
 	/* Fetch states. */
 	prop = of_find_property(np, "states", NULL);
+	if (!prop) {
+		dev_err(&dev, "No 'states' property found\n");
+		return ERR_PTR(-EINVAL);
+	}
+
 	proplen = prop->length / sizeof(int);
 
 	config->states = devm_kzalloc(dev,
-- 
1.7.9.5

