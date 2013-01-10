Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab3AJJqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 04:46:25 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55480 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab3AJJqT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 04:46:19 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Axel Lin <axel.lin@ingics.com>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] regulator-core: update all enable GPIO state in
 _enable/disable
Thread-Topic: [PATCH 2/3] regulator-core: update all enable GPIO state in
 _enable/disable
Thread-Index: Ac3vF1MMan6DWOu1ROel6fNImsx4zQ==
Date: Thu, 10 Jan 2013 09:46:12 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E122AA@DQHE02.ent.ti.com>
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

 When a regulator is enabled or disabled, enable GPIO state is changed if it is
 used.
 If multiple regulators are controlled by one shared GPIO, pin states of other
 GPIOs should be updated also.

 Look up the list of regulators and change the enable pin state if same GPIO
 is used. It guarantees exact value of regulator_is_enabled().

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/regulator/core.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 21b4247..44b2d61 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1473,6 +1473,17 @@ static int regulator_enable_gpio_request(struct regulator_dev *rdev,
 				rdev_get_name(rdev));
 }
 
+static void update_enable_gpio_state(int gpio, bool enable)
+{
+	struct regulator_dev *r;
+
+	/* Update shared enable pin state */
+	list_for_each_entry(r, &regulator_list, list) {
+		if (r->ena_gpio == gpio)
+			r->ena_gpio_state = enable ? 1 : 0;
+	}
+}
+
 static int _regulator_do_enable(struct regulator_dev *rdev)
 {
 	int ret, delay;
@@ -1491,7 +1502,7 @@ static int _regulator_do_enable(struct regulator_dev *rdev)
 	if (rdev->ena_gpio) {
 		gpio_set_value_cansleep(rdev->ena_gpio,
 					!rdev->ena_gpio_invert);
-		rdev->ena_gpio_state = 1;
+		update_enable_gpio_state(rdev->ena_gpio, true);
 	} else if (rdev->desc->ops->enable) {
 		ret = rdev->desc->ops->enable(rdev);
 		if (ret < 0)
@@ -1595,8 +1606,7 @@ static int _regulator_do_disable(struct regulator_dev *rdev)
 	if (rdev->ena_gpio) {
 		gpio_set_value_cansleep(rdev->ena_gpio,
 					rdev->ena_gpio_invert);
-		rdev->ena_gpio_state = 0;
-
+		update_enable_gpio_state(rdev->ena_gpio, false);
 	} else if (rdev->desc->ops->disable) {
 		ret = rdev->desc->ops->disable(rdev);
 		if (ret != 0)
-- 
1.7.9.5


Best Regards,
Milo


