Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030719Ab2CVGIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 02:08:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54798 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030452Ab2CVGIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 02:08:12 -0400
Message-ID: <1332396484.3842.2.camel@phoenix>
Subject: [PATCH] regulator: gpio-regulator: Set the smallest voltage/current
 in the specified range
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 22 Mar 2012 14:08:04 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not assume the gpio regulator states map is sorted in any order.
This patch ensures we always set the smallest voltage/current that falls within
the specified range.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/gpio-regulator.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 42e1cb1..b728b36 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -105,15 +105,15 @@ static int gpio_regulator_set_value(struct regulator_dev *dev,
 					int min, int max)
 {
 	struct gpio_regulator_data *data = rdev_get_drvdata(dev);
-	int ptr, target, state;
+	int ptr, target, state, best_val = INT_MAX;
 
-	target = -1;
 	for (ptr = 0; ptr < data->nr_states; ptr++)
-		if (data->states[ptr].value >= min &&
+		if (data->states[ptr].value < best_val &&
+		    data->states[ptr].value >= min &&
 		    data->states[ptr].value <= max)
 			target = data->states[ptr].gpios;
 
-	if (target < 0)
+	if (best_val == INT_MAX)
 		return -EINVAL;
 
 	for (ptr = 0; ptr < data->nr_gpios; ptr++) {
-- 
1.7.5.4



