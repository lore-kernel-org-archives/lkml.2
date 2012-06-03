Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab2FCTcJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 15:32:09 -0400
Received: from gloria.sntech.de ([95.129.55.99]:47045 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754278Ab2FCTcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 15:32:08 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3] regulator: gpio-regulator: populate selector from set_voltage
Date: Sun, 3 Jun 2012 21:32:05 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37-2-686; KDE/4.4.5; i686; ; )
Cc: Liam Girdwood <lrg@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Axel Lin <axel.lin@gmail.com>
References: <201206032129.45414.heiko@sntech.de>
In-Reply-To: <201206032129.45414.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206032132.06209.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was missing until now and the underlying
_regulator_do_set_voltage is using this value when calling list_voltage.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/regulator/gpio-regulator.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 2c38bea..242851a 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -101,7 +101,7 @@ static int gpio_regulator_get_value(struct regulator_dev *dev)
 }
 
 static int gpio_regulator_set_value(struct regulator_dev *dev,
-					int min, int max)
+					int min, int max, unsigned *selector)
 {
 	struct gpio_regulator_data *data = rdev_get_drvdata(dev);
 	int ptr, target = 0, state, best_val = INT_MAX;
@@ -112,6 +112,8 @@ static int gpio_regulator_set_value(struct regulator_dev *dev,
 		    data->states[ptr].value <= max) {
 			target = data->states[ptr].gpios;
 			best_val = data->states[ptr].value;
+			if (selector)
+				*selector = ptr;
 		}
 
 	if (best_val == INT_MAX)
@@ -130,7 +132,7 @@ static int gpio_regulator_set_voltage(struct regulator_dev *dev,
 					int min_uV, int max_uV,
 					unsigned *selector)
 {
-	return gpio_regulator_set_value(dev, min_uV, max_uV);
+	return gpio_regulator_set_value(dev, min_uV, max_uV, selector);
 }
 
 static int gpio_regulator_list_voltage(struct regulator_dev *dev,
@@ -147,7 +149,7 @@ static int gpio_regulator_list_voltage(struct regulator_dev *dev,
 static int gpio_regulator_set_current_limit(struct regulator_dev *dev,
 					int min_uA, int max_uA)
 {
-	return gpio_regulator_set_value(dev, min_uA, max_uA);
+	return gpio_regulator_set_value(dev, min_uA, max_uA, NULL);
 }
 
 static struct regulator_ops gpio_regulator_voltage_ops = {
-- 
1.7.2.3

