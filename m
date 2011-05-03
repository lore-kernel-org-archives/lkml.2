Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab1ECPPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 11:15:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54815 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab1ECPPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 11:15:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=mGu4CAcdDe0I3UY+kNgcyCGLqRUjOm4mWzQ9cyjGhrPUhv1OZ6HsoOYAEwyDaocW45
         Qubzh1rbOPfJvzGPNAew3odvZLWiKIAomSAHjFSUIfkzfo3kQAlKzzB4a6iIyVLJzIiX
         DAig6Hn3rAAzNN9LLkme16K5nEELlLF9LsKLU=
Subject: [PATCH] regulator: Remove mc13xxx_unlock in regulator_register
 failure path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Yong Shen <yong.shen@linaro.org>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 May 2011 23:15:04 +0800
Message-ID: <1304435704.2591.18.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not hold the mutex_lock of struct mc13xxx while calling regulator_register,
Thus remove mc13xxx_unlock in regulator_register failure path.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/mc13892-regulator.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index 1b8f739..38e805d 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -537,8 +537,10 @@ static int __devinit mc13892_regulator_probe(struct platform_device *pdev)
 
 	mc13xxx_lock(mc13892);
 	ret = mc13xxx_reg_read(mc13892, MC13892_REVISION, &val);
-	if (ret)
+	if (ret) {
+		mc13xxx_unlock(mc13892);
 		goto err_free;
+	}
 
 	/* enable switch auto mode */
 	if ((val & 0x0000FFFF) == 0x45d0) {
@@ -547,16 +549,20 @@ static int __devinit mc13892_regulator_probe(struct platform_device *pdev)
 			MC13892_SWITCHERS4_SW2MODE_M,
 			MC13892_SWITCHERS4_SW1MODE_AUTO |
 			MC13892_SWITCHERS4_SW2MODE_AUTO);
-		if (ret)
+		if (ret) {
+			mc13xxx_unlock(mc13892);
 			goto err_free;
+		}
 
 		ret = mc13xxx_reg_rmw(mc13892, MC13892_SWITCHERS5,
 			MC13892_SWITCHERS5_SW3MODE_M |
 			MC13892_SWITCHERS5_SW4MODE_M,
 			MC13892_SWITCHERS5_SW3MODE_AUTO |
 			MC13892_SWITCHERS5_SW4MODE_AUTO);
-		if (ret)
+		if (ret) {
+			mc13xxx_unlock(mc13892);
 			goto err_free;
+		}
 	}
 	mc13xxx_unlock(mc13892);
 
@@ -586,7 +592,6 @@ err:
 		regulator_unregister(priv->regulators[i]);
 
 err_free:
-	mc13xxx_unlock(mc13892);
 	kfree(priv);
 
 	return ret;
-- 
1.7.1



