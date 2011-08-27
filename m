Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab1H0Spc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 14:45:32 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12821 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab1H0Sp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 14:45:29 -0400
Date: Sat, 27 Aug 2011 20:46:30 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Samuel Ortiz <sameo@linux.intel.com>
cc: Margarita Olaya Cabrera <magi@slimlogic.co.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Don't leak init_data in tps65912_device_init()
Message-ID: <alpine.LNX.2.00.1108272044260.27813@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We neglect to free init_data on successful exit.
I also moved two assignments to just before they are needed. This
avoids doing them in case we hit an earlier error exit from the
function.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/mfd/tps65912-core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/tps65912-core.c b/drivers/mfd/tps65912-core.c
index 955bc00..5fec23a 100644
--- a/drivers/mfd/tps65912-core.c
+++ b/drivers/mfd/tps65912-core.c
@@ -131,9 +131,6 @@ int tps65912_device_init(struct tps65912 *tps65912)
 	if (init_data == NULL)
 		return -ENOMEM;
 
-	init_data->irq = pmic_plat_data->irq;
-	init_data->irq_base = pmic_plat_data->irq;
-
 	mutex_init(&tps65912->io_mutex);
 	dev_set_drvdata(tps65912->dev, tps65912);
 
@@ -153,10 +150,13 @@ int tps65912_device_init(struct tps65912 *tps65912)
 	if (ret < 0)
 		goto err;
 
+	init_data->irq = pmic_plat_data->irq;
+	init_data->irq_base = pmic_plat_data->irq;
 	ret = tps65912_irq_init(tps65912, init_data->irq, init_data);
 	if (ret < 0)
 		goto err;
 
+	kfree(init_data);
 	return ret;
 
 err:
-- 
1.7.6.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

