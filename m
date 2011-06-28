Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab1F1BPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 21:15:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:49420 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755857Ab1F1BN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 21:13:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,435,1304319600"; 
   d="scan'208";a="19463980"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org
Subject: [PATCH 1/3] ACPI, APEI, HEST, Detect duplicated hardware error source ID
Date: Tue, 28 Jun 2011 09:13:52 +0800
Message-Id: <1309223634-12248-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309223634-12248-1-git-send-email-ying.huang@intel.com>
References: <1309223634-12248-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The firmware on some machine will report duplicated hardware error
source ID in HEST.  This is considered a firmware bug.  To provide
better warning message, this patch adds duplicated hardware error
source ID detecting and corresponding printk.

This patch fixes #37412 on kernel bugzilla:
https://bugzilla.kernel.org/show_bug.cgi?id=37412

Reported-by: marconifabio@ubuntu-it.org
Signed-off-by: Huang Ying <ying.huang@intel.com>
Tested-by: Mathias <janedo.spam@gmail.com>
---
 drivers/acpi/apei/hest.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/acpi/apei/hest.c
+++ b/drivers/acpi/apei/hest.c
@@ -139,13 +139,23 @@ static int __init hest_parse_ghes(struct
 {
 	struct platform_device *ghes_dev;
 	struct ghes_arr *ghes_arr = data;
-	int rc;
+	int rc, i;
 
 	if (hest_hdr->type != ACPI_HEST_TYPE_GENERIC_ERROR)
 		return 0;
 
 	if (!((struct acpi_hest_generic *)hest_hdr)->enabled)
 		return 0;
+	for (i = 0; i < ghes_arr->count; i++) {
+		struct acpi_hest_header *hdr;
+		ghes_dev = ghes_arr->ghes_devs[i];
+		hdr = *(struct acpi_hest_header **)ghes_dev->dev.platform_data;
+		if (hdr->source_id == hest_hdr->source_id) {
+			pr_warning(FW_WARN HEST_PFX "Duplicated hardware error source ID: %d.\n",
+				   hdr->source_id);
+			return -EIO;
+		}
+	}
 	ghes_dev = platform_device_alloc("GHES", hest_hdr->source_id);
 	if (!ghes_dev)
 		return -ENOMEM;
