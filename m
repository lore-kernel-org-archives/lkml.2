Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab1GMVW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 17:22:28 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:29990 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab1GMVW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 17:22:27 -0400
Date: Wed, 13 Jul 2011 23:22:26 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Samuel Ortiz <sameo@linux.intel.com>
cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Subject: [PATCH] mfd: avoid two assignments if failures happen in
 tps65910_i2c_probe
Message-ID: <alpine.LNX.2.00.1107132319020.22281@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/mfd/tps65910.c:tps65910_i2c_probe() there's potential for a
tiny optimization.

We assign to init_data->irq and init_data->irq_base long before we
need them, and there are two potential exits from the function before
they are needed.

Moving the assignments below these two potential exits means we
completely avoid doing them in these two (failure) cases.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/mfd/tps65910.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

  - compile tested only.
  - patch is on top of the patch in https://lkml.org/lkml/2011/7/5/503 
    which is now in linux-next.

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 7a3eb2d..65e9479 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -147,9 +147,6 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	if (init_data == NULL)
 		return -ENOMEM;
 
-	init_data->irq = pmic_plat_data->irq;
-	init_data->irq_base = pmic_plat_data->irq;
-
 	tps65910 = kzalloc(sizeof(struct tps65910), GFP_KERNEL);
 	if (tps65910 == NULL) {
 		kfree(init_data);
@@ -170,6 +167,9 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	if (ret < 0)
 		goto err;
 
+	init_data->irq = pmic_plat_data->irq;
+	init_data->irq_base = pmic_plat_data->irq;
+
 	tps65910_gpio_init(tps65910, pmic_plat_data->gpio_base);
 
 	ret = tps65910_irq_init(tps65910, init_data->irq, init_data);
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

