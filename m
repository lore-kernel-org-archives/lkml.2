Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab2FCTbN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 15:31:13 -0400
Received: from gloria.sntech.de ([95.129.55.99]:47037 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754278Ab2FCTbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 15:31:12 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] regulator: gpio-regulator: Fix finding of smallest value
Date: Sun, 3 Jun 2012 21:31:09 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37-2-686; KDE/4.4.5; i686; ; )
Cc: Liam Girdwood <lrg@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Axel Lin <axel.lin@gmail.com>
References: <201206032129.45414.heiko@sntech.de>
In-Reply-To: <201206032129.45414.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206032131.09429.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4dbd8f63f07a (regulator: gpio-regulator: Set the smallest
voltage/current in the specified range) forgot to set the newly
introduced best_val.

Therefore it stayed always at INT_MAX thus breaking the setting
of the voltage.

Included is also an init value for target, as warnings about
a possibly uninitialised target started appearing with this fix.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/regulator/gpio-regulator.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index ebe2b5c..2c38bea 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -104,13 +104,15 @@ static int gpio_regulator_set_value(struct regulator_dev *dev,
 					int min, int max)
 {
 	struct gpio_regulator_data *data = rdev_get_drvdata(dev);
-	int ptr, target, state, best_val = INT_MAX;
+	int ptr, target = 0, state, best_val = INT_MAX;
 
 	for (ptr = 0; ptr < data->nr_states; ptr++)
 		if (data->states[ptr].value < best_val &&
 		    data->states[ptr].value >= min &&
-		    data->states[ptr].value <= max)
+		    data->states[ptr].value <= max) {
 			target = data->states[ptr].gpios;
+			best_val = data->states[ptr].value;
+		}
 
 	if (best_val == INT_MAX)
 		return -EINVAL;
-- 
1.7.2.3

