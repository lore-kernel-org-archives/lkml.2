Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab1GBTa5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 15:30:57 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14555 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab1GBTa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 15:30:56 -0400
Date: Sat, 2 Jul 2011 21:21:38 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Graeme Gregory <gg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] mfd: Don't leak init_data in tps65910_i2c_probe
Message-ID: <alpine.LNX.2.00.1107022120171.16316@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a couple of situations where we leak init_data in
drivers/mfd/tps65910.c:tps65910_i2c_probe() - this patch should take
care of them.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/mfd/tps65910.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

 Compile tested only.

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 2229e66..0db62f4 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -144,15 +144,17 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 		return -EINVAL;
 
 	init_data = kzalloc(sizeof(struct tps65910_platform_data), GFP_KERNEL);
-	if (init_data == NULL)
+	if (!init_data)
 		return -ENOMEM;
 
 	init_data->irq = pmic_plat_data->irq;
 	init_data->irq_base = pmic_plat_data->irq;
 
 	tps65910 = kzalloc(sizeof(struct tps65910), GFP_KERNEL);
-	if (tps65910 == NULL)
+	if (!tps65910) {
+		kfree(init_data);
 		return -ENOMEM;
+	}
 
 	i2c_set_clientdata(i2c, tps65910);
 	tps65910->dev = &i2c->dev;
@@ -174,11 +176,13 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	if (ret < 0)
 		goto err;
 
+	kfree(init_data);
 	return ret;
 
 err:
 	mfd_remove_devices(tps65910->dev);
 	kfree(tps65910);
+	kfree(init_data);
 	return ret;
 }
 
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

