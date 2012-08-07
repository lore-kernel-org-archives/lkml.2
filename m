Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031408Ab2HGWub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:50:31 -0400
Received: from gloria.sntech.de ([95.129.55.99]:48861 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031252Ab2HGWu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:50:26 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: gpio-regulator: Split setting of voltages and currents
Date: Wed, 8 Aug 2012 00:50:19 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Liam Girdwood <lrg@ti.com>, Axel Lin <axel.lin@gmail.com>,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208080050.20305.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally gpio-regulator used the first item of its state list
that matched the given voltage or current range.

Commit 4dbd8f63f0 (regulator: gpio-regulator: Set the smallest voltage/current
in the specified range) changed this, to make the selection independent of
the ordering of the state list.

But selecting the minimal value is only true for voltage regulators.
For current regulators the maximum in the given range should be
selected instead.

Therefore split the previous common selection function into specific
functions for voltage and current regulators.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/regulator/gpio-regulator.c |   38 ++++++++++++++++++++++++-----------
 1 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 34b67be..8b5944f 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -57,16 +57,17 @@ static int gpio_regulator_get_value(struct regulator_dev *dev)
 	return -EINVAL;
 }
 
-static int gpio_regulator_set_value(struct regulator_dev *dev,
-					int min, int max, unsigned *selector)
+static int gpio_regulator_set_voltage(struct regulator_dev *dev,
+					int min_uV, int max_uV,
+					unsigned *selector)
 {
 	struct gpio_regulator_data *data = rdev_get_drvdata(dev);
 	int ptr, target = 0, state, best_val = INT_MAX;
 
 	for (ptr = 0; ptr < data->nr_states; ptr++)
 		if (data->states[ptr].value < best_val &&
-		    data->states[ptr].value >= min &&
-		    data->states[ptr].value <= max) {
+		    data->states[ptr].value >= min_uV &&
+		    data->states[ptr].value <= max_uV) {
 			target = data->states[ptr].gpios;
 			best_val = data->states[ptr].value;
 			if (selector)
@@ -85,13 +86,6 @@ static int gpio_regulator_set_value(struct regulator_dev *dev,
 	return 0;
 }
 
-static int gpio_regulator_set_voltage(struct regulator_dev *dev,
-					int min_uV, int max_uV,
-					unsigned *selector)
-{
-	return gpio_regulator_set_value(dev, min_uV, max_uV, selector);
-}
-
 static int gpio_regulator_list_voltage(struct regulator_dev *dev,
 				      unsigned selector)
 {
@@ -106,7 +100,27 @@ static int gpio_regulator_list_voltage(struct regulator_dev *dev,
 static int gpio_regulator_set_current_limit(struct regulator_dev *dev,
 					int min_uA, int max_uA)
 {
-	return gpio_regulator_set_value(dev, min_uA, max_uA, NULL);
+	struct gpio_regulator_data *data = rdev_get_drvdata(dev);
+	int ptr, target = 0, state, best_val = 0;
+
+	for (ptr = 0; ptr < data->nr_states; ptr++)
+		if (data->states[ptr].value > best_val &&
+		    data->states[ptr].value >= min_uA &&
+		    data->states[ptr].value <= max_uA) {
+			target = data->states[ptr].gpios;
+			best_val = data->states[ptr].value;
+		}
+
+	if (best_val == 0)
+		return -EINVAL;
+
+	for (ptr = 0; ptr < data->nr_gpios; ptr++) {
+		state = (target & (1 << ptr)) >> ptr;
+		gpio_set_value(data->gpios[ptr].gpio, state);
+	}
+	data->state = target;
+
+	return 0;
 }
 
 static struct regulator_ops gpio_regulator_voltage_ops = {
-- 
1.7.2.3

