Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab0HWDaF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 23:30:05 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63451 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab0HWDaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 23:30:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=dMrfITg8AFwy1tDhXJFA+KsyiPo238mboGwxLCkbOtIcK9ijZwCusJbeE2VzrRGOFf
         g9/8as97/l6nsX0VLSeTkayHPoKdPY+PFMjhKVQ/m+G1tZpuH4Q5fnpJVQswou0RlK3q
         RDMYNminvNUYhqCxnAhwv8ZV+/Hju9NtRWFuI=
Subject: mfd: tps6586x - free allocated resources when unload the module
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Mike Rapoport <mike@compulab.co.il>
Content-Type: text/plain
Date: Mon, 23 Aug 2010 11:33:00 +0800
Message-Id: <1282534380.2281.3.camel@mola>
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
 drivers/mfd/tps6586x.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index 4cde31e..6eb2730 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -338,6 +338,21 @@ err_add_devs:
 
 static int __devexit tps6586x_i2c_remove(struct i2c_client *client)
 {
+	struct tps6586x *tps6586x = i2c_get_clientdata(client);
+	struct tps6586x_platform_data *pdata = client->dev.platform_data;
+	int ret;
+
+	if (pdata->gpio_base) {
+		ret = gpiochip_remove(&tps6586x->gpio);
+		if (ret) {
+			dev_err(&client->dev, "Can't remove gpio chip: %d\n",
+				ret);
+			return ret;
+		}
+	}
+
+	tps6586x_remove_subdevs(tps6586x);
+	kfree(tps6586x);
 	return 0;
 }
 
-- 
1.7.2



