Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab2JLMcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 08:32:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63948 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755720Ab2JLMcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 08:32:53 -0400
X-IronPort-AV: E=Sophos;i="4.80,577,1344182400"; 
   d="scan'208";a="5990338"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: bhelgaas@google.com, lenb@kernel.org, yinghai@kernel.org,
        jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Subject: [PATCH v2] Fix a hard coding style when determining if a device is a container.
Date: Fri, 12 Oct 2012 20:31:38 +0800
Message-Id: <1350045098-7232-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/12 20:32:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/12 20:32:34,
	Serialize complete at 2012/10/12 20:32:34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"ACPI0004","PNP0A05" and "PNP0A06" are all defined in array
container_device_ids[], so use it, but not the hard coding style.

Also, introduce a new api is_container_device() to determine if a
device is a container device.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
 drivers/acpi/container.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
index 1f9f7d7..ffd76ee 100644
--- a/drivers/acpi/container.c
+++ b/drivers/acpi/container.c
@@ -92,6 +92,19 @@ static int is_device_present(acpi_handle handle)
 	return ((sta & ACPI_STA_DEVICE_PRESENT) == ACPI_STA_DEVICE_PRESENT);
 }
 
+static int is_container_device(const char *hid)
+{
+	const struct acpi_device_id *container_id;
+
+	for (container_id = container_device_ids;
+	     container_id->id[0]; container_id++) {
+		if (!strcmp((char *)container_id->id, hid))
+			return 1;
+	}
+
+	return 0;
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

