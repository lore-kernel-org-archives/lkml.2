Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab0EUJJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 05:09:14 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:33491 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab0EUJJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 05:09:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=OYjxHETXlGIU0EAgFf4QBaexXWo4LYwssRtq/RF0LNDcEE6KLtPtPPVPlIpfvVK6n3
         lq7ulkfbqu4UiLAYyrZrPDBVk3tJi0MZZtr3djXdAm5uTG+on8huJi63uOKICYs7+0UJ
         bfkhtcQ/njbg/a0JE4CE48tZkmTfUfAvFmN3s=
Subject: [PATCH] intel_menlow: fix memory leaks in error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Sujith Thomas <sujith.thomas@intel.com>, Zhang Rui <rui.zhang@intel.com>,
       Len Brown <len.brown@intel.com>, platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Fri, 21 May 2010 17:10:33 +0800
Message-Id: <1274433033.21567.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes below fixes in error path:
1. fix a memory leak if device_create_file failed in
intel_menlow_add_one_attribute
2. properly free added attributes before return error in
intel_menlow_register_sensor error handler
3. properly call acpi_bus_unregister_driver before return error in
intel_menlow_module_init

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/intel_menlow.c |   33 ++++++++++++++++++++++-----------
 1 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/platform/x86/intel_menlow.c b/drivers/platform/x86/intel_menlow.c
index 2f795ce..eacd5da 100644
--- a/drivers/platform/x86/intel_menlow.c
+++ b/drivers/platform/x86/intel_menlow.c
@@ -53,6 +53,8 @@ MODULE_LICENSE("GPL");
 #define MEMORY_ARG_CUR_BANDWIDTH 1
 #define MEMORY_ARG_MAX_BANDWIDTH 0
 
+static void intel_menlow_unregister_sensor(void);
+
 /*
  * GTHS returning 'n' would mean that [0,n-1] states are supported
  * In that case max_cstate would be n-1
@@ -406,8 +408,10 @@ static int intel_menlow_add_one_attribute(char *name, int mode, void *show,
 	attr->handle = handle;
 
 	result = device_create_file(dev, &attr->attr);
-	if (result)
+	if (result) {
+		kfree(attr);
 		return result;
+	}
 
 	mutex_lock(&intel_menlow_attr_lock);
 	list_add_tail(&attr->node, &intel_menlow_attr_list);
@@ -431,11 +435,11 @@ static acpi_status intel_menlow_register_sensor(acpi_handle handle, u32 lvl,
 	/* _TZ must have the AUX0/1 methods */
 	status = acpi_get_handle(handle, GET_AUX0, &dummy);
 	if (ACPI_FAILURE(status))
-		goto not_found;
+		return (status == AE_NOT_FOUND) ? AE_OK : status;
 
 	status = acpi_get_handle(handle, SET_AUX0, &dummy);
 	if (ACPI_FAILURE(status))
-		goto not_found;
+		return (status == AE_NOT_FOUND) ? AE_OK : status;
 
 	result = intel_menlow_add_one_attribute("aux0", 0644,
 						aux0_show, aux0_store,
@@ -445,17 +449,19 @@ static acpi_status intel_menlow_register_sensor(acpi_handle handle, u32 lvl,
 
 	status = acpi_get_handle(handle, GET_AUX1, &dummy);
 	if (ACPI_FAILURE(status))
-		goto not_found;
+		goto aux1_not_found;
 
 	status = acpi_get_handle(handle, SET_AUX1, &dummy);
 	if (ACPI_FAILURE(status))
-		goto not_found;
+		goto aux1_not_found;
 
 	result = intel_menlow_add_one_attribute("aux1", 0644,
 						aux1_show, aux1_store,
 						&thermal->device, handle);
-	if (result)
+	if (result) {
+		intel_menlow_unregister_sensor();
 		return AE_ERROR;
+	}
 
 	/*
 	 * create the "dabney_enabled" attribute which means the user app
@@ -465,14 +471,17 @@ static acpi_status intel_menlow_register_sensor(acpi_handle handle, u32 lvl,
 	result = intel_menlow_add_one_attribute("bios_enabled", 0444,
 						bios_enabled_show, NULL,
 						&thermal->device, handle);
-	if (result)
+	if (result) {
+		intel_menlow_unregister_sensor();
 		return AE_ERROR;
+	}
 
- not_found:
+ aux1_not_found:
 	if (status == AE_NOT_FOUND)
 		return AE_OK;
-	else
-		return status;
+
+	intel_menlow_unregister_sensor();
+	return status;
 }
 
 static void intel_menlow_unregister_sensor(void)
@@ -513,8 +522,10 @@ static int __init intel_menlow_module_init(void)
 	status = acpi_walk_namespace(ACPI_TYPE_THERMAL, ACPI_ROOT_OBJECT,
 				     ACPI_UINT32_MAX,
 				     intel_menlow_register_sensor, NULL, NULL, NULL);
-	if (ACPI_FAILURE(status))
+	if (ACPI_FAILURE(status)) {
+		acpi_bus_unregister_driver(&intel_menlow_memory_driver);
 		return -ENODEV;
+	}
 
 	return 0;
 }
-- 
1.5.4.3



