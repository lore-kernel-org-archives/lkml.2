Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab2JLG42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 02:56:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59026 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755877Ab2JLG40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 02:56:26 -0400
X-IronPort-AV: E=Sophos;i="4.80,576,1344182400"; 
   d="scan'208";a="5988332"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: bhelgaas@google.com, lenb@kernel.org, yinghai@kernel.org,
        izumi.taku@jp.fujitsu.com, jiang.liu@huawei.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Subject: [PATCH] Fix a hard coding style when determining if a device is a container.
Date: Fri, 12 Oct 2012 14:55:16 +0800
Message-Id: <1350024916-3628-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/12 14:56:11,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/12 14:56:12,
	Serialize complete at 2012/10/12 14:56:12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"ACPI0004","PNP0A05" and "PNP0A06" are all defined in array
container_device_ids[], so use it, but not the hard coding style.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 drivers/acpi/container.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
index 1f9f7d7..448c0e2 100644
--- a/drivers/acpi/container.c
+++ b/drivers/acpi/container.c
@@ -217,6 +217,7 @@ container_walk_namespace_cb(acpi_handle handle,
 {
 	char *hid = NULL;
 	struct acpi_device_info *info;
+	struct acpi_device_id *container_id;
 	acpi_status status;
 	int *action = context;
 
@@ -232,10 +233,13 @@ container_walk_namespace_cb(acpi_handle handle,
 		goto end;
 	}
 
-	if (strcmp(hid, "ACPI0004") && strcmp(hid, "PNP0A05") &&
-	    strcmp(hid, "PNP0A06")) {
-		goto end;
+	for (container_id = container_device_ids;
+	     container_id->id[0]; container_id++) {
+		if (!strcmp((char *)container_id->id, hid))
+			break;
 	}
+	if (!container_id->id[0])
+		goto end;
 
 	switch (*action) {
 	case INSTALL_NOTIFY_HANDLER:
-- 
1.7.1

