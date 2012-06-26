Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab2FZJOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 05:14:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:21580 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752928Ab2FZJOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 05:14:38 -0400
X-IronPort-AV: E=Sophos;i="4.77,476,1336320000"; 
   d="scan'208";a="5266039"
Message-ID: <4FE97E86.60603@cn.fujitsu.com>
Date: Tue, 26 Jun 2012 17:19:02 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: lenb@kernel.org, linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Subject: [PATCH 1/8] fix memory leak when memory device is unbound from the
 module acpi_memhotplug
References: <4FE97DD5.6030205@cn.fujitsu.com>
In-Reply-To: <4FE97DD5.6030205@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/26 17:14:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/26 17:14:50,
	Serialize complete at 2012/06/26 17:14:50
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We allocate memory to store acpi_memory_info, so we should free it before
freeing mem_device.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 drivers/acpi/acpi_memhotplug.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index d985713..f6831d1 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -399,6 +399,18 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
 	return;
 }
 
+static void acpi_free_memory_device(struct acpi_memory_device *mem_device)
+{
+	struct acpi_memory_info *info, *n;
+
+	if (!mem_device)
+		return;
+
+	list_for_each_entry_safe(info, n, &mem_device->res_list, list)
+		kfree(info);
+	kfree(mem_device);
+}
+
 static int acpi_memory_device_add(struct acpi_device *device)
 {
 	int result;
@@ -451,14 +463,10 @@ static int acpi_memory_device_add(struct acpi_device *device)
 
 static int acpi_memory_device_remove(struct acpi_device *device, int type)
 {
-	struct acpi_memory_device *mem_device = NULL;
-
-
 	if (!device || !acpi_driver_data(device))
 		return -EINVAL;
 
-	mem_device = acpi_driver_data(device);
-	kfree(mem_device);
+	acpi_free_memory_device(acpi_driver_data(device));
 
 	return 0;
 }
-- 
1.7.1

