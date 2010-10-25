Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab0JYCIq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 22:08:46 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39975 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab0JYCIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 22:08:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=iME7u0x7psv+vFVUlr0dD2bdPAJb9mqbK09gjDh7v5K3D7BoXffrar7UPSMA4q2Alu
         4XYnECkMyhMVYFSAPn5013SAiF+g1SVeY3em5jpvdovUwm/KEB1XH13kBJFu6H0/EjEk
         BvTD0F/6WX+0gGSKpfLBIUqpITBHVVItM4wlc=
Subject: [PATCH 1/2] regulator: max8952 - fix max8952_pmic_probe error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain
Date: Mon, 25 Oct 2010 10:11:07 +0800
Message-Id: <1287972667.23608.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8952.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index f2af0b1..7d6aacf 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -212,9 +212,11 @@ static int __devinit max8952_pmic_probe(struct i2c_client *client,
 	max8952->rdev = regulator_register(&regulator, max8952->dev,
 			&pdata->reg_data, max8952);
 
-	ret = IS_ERR(max8952->rdev);
-	if (ret)
+	if (IS_ERR(max8952->rdev)) {
+		ret = PTR_ERR(max8952->rdev);
 		dev_err(max8952->dev, "regulator init failed (%d)\n", ret);
+		goto err_reg;
+	}
 
 	max8952->en = !!(pdata->reg_data.constraints.boot_on);
 	max8952->vid0 = (pdata->default_mode % 2) == 1;
@@ -309,6 +311,10 @@ static int __devinit max8952_pmic_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, max8952);
 
+	return 0;
+
+err_reg:
+	kfree(max8952);
 	return ret;
 }
 
-- 
1.7.2



