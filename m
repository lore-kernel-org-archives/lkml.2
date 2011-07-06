Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab1GFPlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 11:41:05 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61955 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab1GFPlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 11:41:02 -0400
Subject: [PATCH] platform-drivers-x86: intel_mid_thermal: fix memory leak
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Durgadoss R <durgadoss.r@intel.com>, Alan Cox <alan@linux.intel.com>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jul 2011 23:40:51 +0800
Message-ID: <1309966851.6398.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memory for td_info which is allocated in initialize_sensor()
should be properly kfreed in mid_thermal_probe() error patch and
mid_thermal_remove().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/intel_mid_thermal.c |   26 +++++++++++++++++++-------
 1 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/intel_mid_thermal.c b/drivers/platform/x86/intel_mid_thermal.c
index 3a57832..ccd7b1f 100644
--- a/drivers/platform/x86/intel_mid_thermal.c
+++ b/drivers/platform/x86/intel_mid_thermal.c
@@ -493,20 +493,30 @@ static int mid_thermal_probe(struct platform_device *pdev)
 
 	/* Register each sensor with the generic thermal framework*/
 	for (i = 0; i < MSIC_THERMAL_SENSORS; i++) {
+		struct thermal_device_info *td_info = initialize_sensor(i);
+
+		if (!td_info) {
+			ret = -ENOMEM;
+			goto err;
+		}
 		pinfo->tzd[i] = thermal_zone_device_register(name[i],
-				0, initialize_sensor(i), &tzd_ops, 0, 0, 0, 0);
-		if (IS_ERR(pinfo->tzd[i]))
-			goto reg_fail;
+				0, td_info, &tzd_ops, 0, 0, 0, 0);
+		if (IS_ERR(pinfo->tzd[i])) {
+			kfree(td_info);
+			ret = PTR_ERR(pinfo->tzd[i]);
+			goto err;
+		}
 	}
 
 	pinfo->pdev = pdev;
 	platform_set_drvdata(pdev, pinfo);
 	return 0;
 
-reg_fail:
-	ret = PTR_ERR(pinfo->tzd[i]);
-	while (--i >= 0)
+err:
+	while (--i >= 0) {
+		kfree(pinfo->tzd[i]->devdata);
 		thermal_zone_device_unregister(pinfo->tzd[i]);
+	}
 	configure_adc(0);
 	kfree(pinfo);
 	return ret;
@@ -524,8 +534,10 @@ static int mid_thermal_remove(struct platform_device *pdev)
 	int i;
 	struct platform_info *pinfo = platform_get_drvdata(pdev);
 
-	for (i = 0; i < MSIC_THERMAL_SENSORS; i++)
+	for (i = 0; i < MSIC_THERMAL_SENSORS; i++) {
+		kfree(pinfo->tzd[i]->devdata);
 		thermal_zone_device_unregister(pinfo->tzd[i]);
+	}
 
 	kfree(pinfo);
 	platform_set_drvdata(pdev, NULL);
-- 
1.7.4.1



