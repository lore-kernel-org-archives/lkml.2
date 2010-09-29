Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab0I2Lyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 07:54:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:51878 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323Ab0I2LyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 07:54:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,252,1283756400"; 
   d="scan'208";a="559002009"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v2 3/5] ACPI, APEI, HEST Fix the unsuitable usage of platform_data
Date: Wed, 29 Sep 2010 19:53:53 +0800
Message-Id: <1285761235-4751-4-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285761235-4751-1-git-send-email-ying.huang@intel.com>
References: <1285761235-4751-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jin Dongming <jin.dongming@np.css.fujitsu.com>

platform_data in hest_parse_ghes() is used for saving the address of entry
information of erst_tab. When the device is failed to be added, platform_data
will be freed by platform_device_put(). But the value saved in platform_data
should not be freed here. If it is done, it will make system panic.

So I think platform_data should save the address of allocated memory
which saves entry information of erst_tab.

This patch fixed it and I confirmed it on x86_64 next-tree.

v2:
    Transport the pointer of hest_hdr to platform_data using
    platform_device_add_data()

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/ghes.c |    2 +-
 drivers/acpi/apei/hest.c |   11 +++++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -302,7 +302,7 @@ static int __devinit ghes_probe(struct p
 	struct ghes *ghes = NULL;
 	int rc = -EINVAL;
 
-	generic = ghes_dev->dev.platform_data;
+	generic = *(struct acpi_hest_generic **)ghes_dev->dev.platform_data;
 	if (!generic->enabled)
 		return -ENODEV;
 
--- a/drivers/acpi/apei/hest.c
+++ b/drivers/acpi/apei/hest.c
@@ -137,20 +137,23 @@ static int hest_parse_ghes_count(struct
 
 static int hest_parse_ghes(struct acpi_hest_header *hest_hdr, void *data)
 {
-	struct acpi_hest_generic *generic;
 	struct platform_device *ghes_dev;
 	struct ghes_arr *ghes_arr = data;
 	int rc;
 
 	if (hest_hdr->type != ACPI_HEST_TYPE_GENERIC_ERROR)
 		return 0;
-	generic = (struct acpi_hest_generic *)hest_hdr;
-	if (!generic->enabled)
+
+	if (!((struct acpi_hest_generic *)hest_hdr)->enabled)
 		return 0;
 	ghes_dev = platform_device_alloc("GHES", hest_hdr->source_id);
 	if (!ghes_dev)
 		return -ENOMEM;
-	ghes_dev->dev.platform_data = generic;
+
+	rc = platform_device_add_data(ghes_dev, &hest_hdr, sizeof(void *));
+	if (rc)
+		goto err;
+
 	rc = platform_device_add(ghes_dev);
 	if (rc)
 		goto err;
