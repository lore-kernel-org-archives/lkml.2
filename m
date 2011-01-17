Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab1AQKIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 05:08:41 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54738 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab1AQKIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 05:08:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=EW8qGoreSS1uVgYrc+mG8YdpGAwMuVQzv0DAuR3hhxNtdLca5D7Ak6MLC9TZlTQkWO
         w/3spP705EabwOfPVZJd6vfYJfP391USvqFvGoDt9syzVETGaS/I6swLpPGTOzneavh0
         4GModmzTXgm17j/5h8qligAz/YgkSEPUjv+oU=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arm: mach-omap2: potential NULL dereference
Date: Mon, 17 Jan 2011 13:08:32 +0300
Message-Id: <1295258913-31048-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kzalloc() failed, return -ENOMEM.
sr_dev_init() should signal by return value that there is an error.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Cannot compile this driver, so it is not tested at all.

 arch/arm/mach-omap2/sr_device.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/sr_device.c b/arch/arm/mach-omap2/sr_device.c
index b1e0af1..20fccfb 100644
--- a/arch/arm/mach-omap2/sr_device.c
+++ b/arch/arm/mach-omap2/sr_device.c
@@ -40,7 +40,7 @@ static struct omap_device_pm_latency omap_sr_latency[] = {
 };
 
 /* Read EFUSE values from control registers for OMAP3430 */
-static void __init sr_set_nvalues(struct omap_volt_data *volt_data,
+static int __init sr_set_nvalues(struct omap_volt_data *volt_data,
 				struct omap_sr_data *sr_data)
 {
 	struct omap_sr_nvalue_table *nvalue_table;
@@ -51,6 +51,8 @@ static void __init sr_set_nvalues(struct omap_volt_data *volt_data,
 
 	nvalue_table = kzalloc(sizeof(struct omap_sr_nvalue_table)*count,
 			GFP_KERNEL);
+	if (nvalue_table == NULL)
+		return -ENOMEM;
 
 	for (i = 0; i < count; i++) {
 		u32 v;
@@ -75,6 +77,8 @@ static void __init sr_set_nvalues(struct omap_volt_data *volt_data,
 
 	sr_data->nvalue_table = nvalue_table;
 	sr_data->nvalue_count = count;
+
+	return 0;
 }
 
 static int sr_dev_init(struct omap_hwmod *oh, void *user)
@@ -84,15 +88,18 @@ static int sr_dev_init(struct omap_hwmod *oh, void *user)
 	struct omap_volt_data *volt_data;
 	char *name = "smartreflex";
 	static int i;
+	int err = 0;
 
 	sr_data = kzalloc(sizeof(struct omap_sr_data), GFP_KERNEL);
 	if (!sr_data) {
+		err = -ENOMEM;
 		pr_err("%s: Unable to allocate memory for %s sr_data.Error!\n",
 			__func__, oh->name);
-		return -ENOMEM;
+		goto exit;
 	}
 
 	if (!oh->vdd_name) {
+		err = -EINVAL;
 		pr_err("%s: No voltage domain specified for %s."
 			"Cannot initialize\n", __func__, oh->name);
 		goto exit;
@@ -104,6 +111,7 @@ static int sr_dev_init(struct omap_hwmod *oh, void *user)
 
 	sr_data->voltdm = omap_voltage_domain_lookup(oh->vdd_name);
 	if (IS_ERR(sr_data->voltdm)) {
+		err = PTR_ERR(sr_data->voltdm);
 		pr_err("%s: Unable to get voltage domain pointer for VDD %s\n",
 			__func__, oh->vdd_name);
 		goto exit;
@@ -111,12 +119,15 @@ static int sr_dev_init(struct omap_hwmod *oh, void *user)
 
 	omap_voltage_get_volttable(sr_data->voltdm, &volt_data);
 	if (!volt_data) {
+		err = -EINVAL;
 		pr_warning("%s: No Voltage table registerd fo VDD%d."
 			"Something really wrong\n\n", __func__, i + 1);
 		goto exit;
 	}
 
-	sr_set_nvalues(volt_data, sr_data);
+	err = sr_set_nvalues(volt_data, sr_data);
+	if (err)
+		goto exit;
 
 	sr_data->enable_on_init = sr_enable_on_init;
 
@@ -129,7 +140,7 @@ static int sr_dev_init(struct omap_hwmod *oh, void *user)
 exit:
 	i++;
 	kfree(sr_data);
-	return 0;
+	return err;
 }
 
 /*
-- 
1.7.0.4

