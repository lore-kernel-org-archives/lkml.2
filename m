Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab0JTJEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 05:04:49 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43042 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab0JTJEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 05:04:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=D/BxBgvMuoPI3iMF5MlQ6OYng3pDGXuntKojIQYmlNCyN8cNiO5X5TIL+t8C+By+W4
         xvfn7GqflXivO2RpYNmFFhuWRTRGWSgvHFVFwFd7vEnjLQh0EeQL5K4NASpTHNqndK68
         3PnsMp47AjMkhKhn7zHnZZM3Gu9+sdVkNTxlo=
Subject: [PATCH] mfd: max8998 cleanups
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain
Date: Wed, 20 Oct 2010 17:06:44 +0800
Message-Id: <1287565604.7849.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes below fixes:
1. i2c_smbus_write_byte_data() returns zero or negative value,
   therefore no need to check if ret is greater than zero or not.
2. Properly free irq and unregister max8998->rtc device in
   max8998_i2c_probe() error path and max8998_i2c_remove().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/max8998.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
index a720f41..bb9977b 100644
--- a/drivers/mfd/max8998.c
+++ b/drivers/mfd/max8998.c
@@ -110,8 +110,6 @@ int max8998_update_reg(struct i2c_client *i2c, u8 reg, u8 val, u8 mask)
 		u8 old_val = ret & 0xff;
 		u8 new_val = (val & mask) | (old_val & (~mask));
 		ret = i2c_smbus_write_byte_data(i2c, reg, new_val);
-		if (ret >= 0)
-			ret = 0;
 	}
 	mutex_unlock(&max8998->iolock);
 	return ret;
@@ -155,6 +153,8 @@ static int max8998_i2c_probe(struct i2c_client *i2c,
 
 err:
 	mfd_remove_devices(max8998->dev);
+	max8998_irq_exit(max8998);
+	i2c_unregister_device(max8998->rtc);
 	kfree(max8998);
 	return ret;
 }
@@ -164,6 +164,8 @@ static int max8998_i2c_remove(struct i2c_client *i2c)
 	struct max8998_dev *max8998 = i2c_get_clientdata(i2c);
 
 	mfd_remove_devices(max8998->dev);
+	max8998_irq_exit(max8998);
+	i2c_unregister_device(max8998->rtc);
 	kfree(max8998);
 
 	return 0;
-- 
1.7.2



