Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab3AJJqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 04:46:23 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55479 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab3AJJqT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 04:46:19 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Axel Lin <axel.lin@ingics.com>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] regulator-core: support multiple enable GPIO
Thread-Topic: [PATCH 1/3] regulator-core: support multiple enable GPIO
Thread-Index: Ac3vF1FJW95t2vHgSFGC96cesYSMvw==
Date: Thu, 10 Jan 2013 09:46:10 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E122A2@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch fixes a limitation in case of multiple enable pin usages.
 Several regulators can be enabled/disabled at the same time by one
 shared GPIO pin.
 If specific GPIO pin is already used, then skip requesting the GPIO.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/regulator/core.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index de47880..21b4247 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1456,6 +1456,23 @@ void devm_regulator_put(struct regulator *regulator)
 }
 EXPORT_SYMBOL_GPL(devm_regulator_put);
 
+static int regulator_enable_gpio_request(struct regulator_dev *rdev,
+					const struct regulator_config *config)
+{
+	struct regulator_dev *r;
+	int gpio = config->ena_gpio;
+
+	list_for_each_entry(r, &regulator_list, list) {
+		if (r->ena_gpio == gpio) {
+			rdev_info(rdev, "GPIO %d is already used\n", gpio);
+			return 0;
+		}
+	}
+
+	return gpio_request_one(gpio, GPIOF_DIR_OUT | config->ena_gpio_flags,
+				rdev_get_name(rdev));
+}
+
 static int _regulator_do_enable(struct regulator_dev *rdev)
 {
 	int ret, delay;
@@ -3420,9 +3437,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	dev_set_drvdata(&rdev->dev, rdev);
 
 	if (config->ena_gpio && gpio_is_valid(config->ena_gpio)) {
-		ret = gpio_request_one(config->ena_gpio,
-				       GPIOF_DIR_OUT | config->ena_gpio_flags,
-				       rdev_get_name(rdev));
+		ret = regulator_enable_gpio_request(rdev, config);
 		if (ret != 0) {
 			rdev_err(rdev, "Failed to request enable GPIO%d: %d\n",
 				 config->ena_gpio, ret);
-- 
1.7.9.5


Best Regards,
Milo


