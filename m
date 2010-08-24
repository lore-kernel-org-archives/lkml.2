Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab0HXHPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 03:15:55 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40336 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab0HXHPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 03:15:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=pMzzcVVtIpI6WLAZ/+WyaWYpvRGdvea6qtCybxMaaI4I4y0x8LCW92X6/IjuFTsOi7
         kB3wSqeqGfGVg4NCD2woD1yZN98V3gWSkWPunQ2iM6eT4RDviXMp8yXzVwjYLR6O8o7B
         35b/iu+wkQxej/4buCFO9V5UCFvcZmRJT7YGc=
Subject: [PATCH v2] mfd: tps6586x - free allocated resources when unload
	the module
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Mike Rapoport <mike@compulab.co.il>,
        eric miao <eric.y.miao@gmail.com>
Content-Type: text/plain
Date: Tue, 24 Aug 2010 15:18:58 +0800
Message-Id: <1282634338.11025.5.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the resources allocated in tps6586x_i2c_probe(),
we need to free it in tps6586x_i2c_remove().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Changes since V1:
Current implementation allows gpiochip_add() fail in probe,
thus just show a wraning if gpiochip_remove() fail.

I don't have this hardware handy,
I am not sure that does it make sense to allow gpiochip_add() fail in probe.

 drivers/mfd/tps6586x.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index 1c91936..2f9336c 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -344,6 +344,19 @@ err_add_devs:
 
 static int __devexit tps6586x_i2c_remove(struct i2c_client *client)
 {
+	struct tps6586x *tps6586x = i2c_get_clientdata(client);
+	struct tps6586x_platform_data *pdata = client->dev.platform_data;
+	int ret;
+
+	if (pdata->gpio_base) {
+		ret = gpiochip_remove(&tps6586x->gpio);
+		if (ret)
+			dev_err(&client->dev, "Can't remove gpio chip: %d\n",
+				ret);
+	}
+
+	tps6586x_remove_subdevs(tps6586x);
+	kfree(tps6586x);
 	return 0;
 }
 
-- 
1.7.2



