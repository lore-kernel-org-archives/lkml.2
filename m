Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab2FZJSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 05:18:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:43378 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755159Ab2FZJSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 05:18:16 -0400
X-IronPort-AV: E=Sophos;i="4.77,476,1336320000"; 
   d="scan'208";a="5266095"
Message-ID: <4FE97F60.90101@cn.fujitsu.com>
Date: Tue, 26 Jun 2012 17:22:40 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: lenb@kernel.org, linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Subject: [PATCH 7/8] auto bind the memory device which is hotpluged before
 the driver is loaded
References: <4FE97DD5.6030205@cn.fujitsu.com>
In-Reply-To: <4FE97DD5.6030205@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/26 17:18:26,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/26 17:18:28,
	Serialize complete at 2012/06/26 17:18:28
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the memory device is hotpluged before the driver is loaded, the
user cannot see this device under the directory /sys/bus/acpi/devices/,
and the user cannot bind it by hand after the driver is loaded.
This patch introduces a new feature to bind such device when is driver
is being loaded.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 drivers/acpi/acpi_memhotplug.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index 148c88a..a682657 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -52,6 +52,9 @@ MODULE_LICENSE("GPL");
 #define MEMORY_POWER_ON_STATE	1
 #define MEMORY_POWER_OFF_STATE	2
 
+static bool auto_probe;
+module_param(auto_probe, bool, S_IRUGO | S_IWUSR);
+
 static int acpi_memory_device_add(struct acpi_device *device);
 static int acpi_memory_device_remove(struct acpi_device *device, int type);
 
@@ -515,12 +518,44 @@ acpi_memory_register_notify_handler(acpi_handle handle,
 				    u32 level, void *ctxt, void **retv)
 {
 	acpi_status status;
-
+	struct acpi_memory_device *mem_device = NULL;
+	unsigned long long current_status;
 
 	status = is_memory_device(handle);
 	if (ACPI_FAILURE(status))
 		return AE_OK;	/* continue */
 
+	if (auto_probe) {
+		if (acpi_memory_get_device(handle, &mem_device))
+			goto install;
+
+		/* Get device present/absent information from the _STA */
+		status = acpi_evaluate_integer(mem_device->device->handle,
+					       "_STA", NULL, &current_status);
+		if (ACPI_FAILURE(status))
+			goto install;
+
+		/*
+		 * Check for device status. Device should be
+		 * present/enabled/functioning.
+		 */
+		if (!((current_status & ACPI_STA_DEVICE_PRESENT)
+		      && (current_status & ACPI_STA_DEVICE_ENABLED)
+		      && (current_status & ACPI_STA_DEVICE_FUNCTIONING)))
+			goto install;
+
+		/* We have bound this device while we register the dirver */
+		if (mem_device->state == MEMORY_POWER_ON_STATE)
+			goto install;
+
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+				  "\nauto probe memory device\n"));
+
+		if (acpi_memory_enable_device(mem_device))
+			pr_err(PREFIX "Cannot enable memory device\n");
+	}
+
+install:
 	status = acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
 					     acpi_memory_device_notify, NULL);
 	/* continue */
-- 
1.7.1

