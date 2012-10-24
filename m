Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab2JXGNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 02:13:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:32734 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756369Ab2JXGNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 02:13:08 -0400
X-IronPort-AV: E=Sophos;i="4.80,639,1344182400"; 
   d="scan'208";a="6057182"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: yinghai@kernel.org, bhelgaas@google.com, lenb@kernel.org,
        jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] Fix a hard coding style when determining if a device is a container.
Date: Wed, 24 Oct 2012 14:11:53 +0800
Message-Id: <1351059113-4660-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/24 14:12:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/24 14:12:34,
	Serialize complete at 2012/10/24 14:12:34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"ACPI0004","PNP0A05" and "PNP0A06" are all defined in array
container_device_ids[], so use it, but not the hard coding style.

Also, introduce a new api is_container_device() to determine if a
device is a container device.

change log v2 -> v3:

1. change the is_container_device()'s return value type from int to bool.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
 drivers/acpi/container.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
index 1f9f7d7..69e2d6b 100644
--- a/drivers/acpi/container.c
+++ b/drivers/acpi/container.c
@@ -92,6 +92,19 @@ static int is_device_present(acpi_handle handle)
 	return ((sta & ACPI_STA_DEVICE_PRESENT) == ACPI_STA_DEVICE_PRESENT);
 }
 
+static bool is_container_device(const char *hid)
+{
+	const struct acpi_device_id *container_id;
+
+	for (container_id = container_device_ids;
+	     container_id->id[0]; container_id++) {
+		if (!strcmp((char *)container_id->id, hid))
+			return true;
+	}
+
+	return false;
+}
+
 /*******************************************************************/
 static int acpi_container_add(struct acpi_device *device)
 {
@@ -232,10 +245,8 @@ container_walk_namespace_cb(acpi_handle handle,
 		goto end;
 	}
 
-	if (strcmp(hid, "ACPI0004") && strcmp(hid, "PNP0A05") &&
-	    strcmp(hid, "PNP0A06")) {
+	if (!is_container_device(hid))
 		goto end;
-	}
 
 	switch (*action) {
 	case INSTALL_NOTIFY_HANDLER:
-- 
1.7.1

