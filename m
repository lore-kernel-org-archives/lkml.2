Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab1BFM3v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 07:29:51 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:56702 "EHLO
	relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab1BFM3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 07:29:49 -0500
X-Originating-IP: 217.70.178.42
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 08/18] eeepc-wmi: switch to platform_create_bundle()
Date: Sun,  6 Feb 2011 13:28:33 +0100
Message-Id: <1296995324-5462-9-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1296995324-5462-1-git-send-email-corentincj@iksaif.net>
References: <1296995324-5462-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allow to remove ~30 lines of code.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/eeepc-wmi.c |   75 +++++++++++---------------------------
 1 files changed, 22 insertions(+), 53 deletions(-)

diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index 583ba78..1fc191b 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -144,9 +144,6 @@ struct eeepc_wmi {
 	struct eeepc_wmi_debug debug;
 };
 
-/* Only used in eeepc_wmi_init() and eeepc_wmi_exit() */
-static struct platform_device *platform_device;
-
 static int eeepc_wmi_input_init(struct eeepc_wmi *eeepc)
 {
 	int err;
@@ -932,33 +929,12 @@ static int eeepc_wmi_sysfs_init(struct platform_device *device)
  */
 static int __init eeepc_wmi_platform_init(struct eeepc_wmi *eeepc)
 {
-	int err;
-
-	eeepc->platform_device = platform_device_alloc(EEEPC_WMI_FILE, -1);
-	if (!eeepc->platform_device)
-		return -ENOMEM;
-	platform_set_drvdata(eeepc->platform_device, eeepc);
-
-	err = platform_device_add(eeepc->platform_device);
-	if (err)
-		goto fail_platform_device;
-
-	err = eeepc_wmi_sysfs_init(eeepc->platform_device);
-	if (err)
-		goto fail_sysfs;
-	return 0;
-
-fail_sysfs:
-	platform_device_del(eeepc->platform_device);
-fail_platform_device:
-	platform_device_put(eeepc->platform_device);
-	return err;
+	return eeepc_wmi_sysfs_init(eeepc->platform_device);
 }
 
 static void eeepc_wmi_platform_exit(struct eeepc_wmi *eeepc)
 {
 	eeepc_wmi_sysfs_exit(eeepc->platform_device);
-	platform_device_unregister(eeepc->platform_device);
 }
 
 /*
@@ -1094,7 +1070,7 @@ static void eeepc_dmi_check(struct eeepc_wmi *eeepc)
 	}
 }
 
-static struct platform_device * __init eeepc_wmi_add(void)
+static int __init eeepc_wmi_add(struct platform_device *pdev)
 {
 	struct eeepc_wmi *eeepc;
 	acpi_status status;
@@ -1102,15 +1078,14 @@ static struct platform_device * __init eeepc_wmi_add(void)
 
 	eeepc = kzalloc(sizeof(struct eeepc_wmi), GFP_KERNEL);
 	if (!eeepc)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
+
+	eeepc->platform_device = pdev;
+	platform_set_drvdata(eeepc->platform_device, eeepc);
 
 	eeepc->hotplug_wireless = hotplug_wireless;
 	eeepc_dmi_check(eeepc);
 
-	/*
-	 * Register the platform device first.  It is used as a parent for the
-	 * sub-devices below.
-	 */
 	err = eeepc_wmi_platform_init(eeepc);
 	if (err)
 		goto fail_platform;
@@ -1147,7 +1122,7 @@ static struct platform_device * __init eeepc_wmi_add(void)
 	if (err)
 		goto fail_debugfs;
 
-	return eeepc->platform_device;
+	return 0;
 
 fail_debugfs:
 	wmi_remove_notify_handler(EEEPC_WMI_EVENT_GUID);
@@ -1163,10 +1138,10 @@ fail_input:
 	eeepc_wmi_platform_exit(eeepc);
 fail_platform:
 	kfree(eeepc);
-	return ERR_PTR(err);
+	return err;
 }
 
-static int eeepc_wmi_remove(struct platform_device *device)
+static int __exit eeepc_wmi_remove(struct platform_device *device)
 {
 	struct eeepc_wmi *eeepc;
 
@@ -1232,6 +1207,7 @@ static const struct dev_pm_ops eeepc_pm_ops = {
 };
 
 static struct platform_driver platform_driver = {
+	.remove = __exit_p(eeepc_wmi_remove),
 	.driver = {
 		.name = EEEPC_WMI_FILE,
 		.owner = THIS_MODULE,
@@ -1260,10 +1236,8 @@ static int __init eeepc_wmi_check_atkd(void)
 	return -1;
 }
 
-static int __init eeepc_wmi_init(void)
+static int __init eeepc_wmi_probe(struct platform_device *pdev)
 {
-	int err;
-
 	if (!wmi_has_guid(EEEPC_WMI_EVENT_GUID) ||
 	    !wmi_has_guid(EEEPC_WMI_MGMT_GUID)) {
 		pr_warning("No known WMI GUID found\n");
@@ -1280,29 +1254,24 @@ static int __init eeepc_wmi_init(void)
 		return -ENODEV;
 	}
 
-	platform_device = eeepc_wmi_add();
-	if (IS_ERR(platform_device)) {
-		err = PTR_ERR(platform_device);
-		goto fail_eeepc_wmi;
-	}
+	return eeepc_wmi_add(pdev);
+}
 
-	err = platform_driver_register(&platform_driver);
-	if (err) {
-		pr_warning("Unable to register platform driver\n");
-		goto fail_platform_driver;
-	}
+static struct platform_device *platform_device;
 
+static int __init eeepc_wmi_init(void)
+{
+	platform_device = platform_create_bundle(&platform_driver,
+						 eeepc_wmi_probe,
+						 NULL, 0, NULL, 0);
+	if (IS_ERR(platform_device))
+		return PTR_ERR(platform_device);
 	return 0;
-
-fail_platform_driver:
-	eeepc_wmi_remove(platform_device);
-fail_eeepc_wmi:
-	return err;
 }
 
 static void __exit eeepc_wmi_exit(void)
 {
-	eeepc_wmi_remove(platform_device);
+	platform_device_unregister(platform_device);
 	platform_driver_unregister(&platform_driver);
 }
 
-- 
1.7.4.rc3

