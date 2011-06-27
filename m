Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab1F0I21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 04:28:27 -0400
Received: from mga14.intel.com ([143.182.124.37]:21556 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757315Ab1F0I0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 04:26:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,431,1304319600"; 
   d="scan'208";a="19009095"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, mjg59@srcf.ucam.org
Subject: [PATCH -v2 2/4] ACPI, APEI, GHES, Support disable GHES at boot time
Date: Mon, 27 Jun 2011 16:25:58 +0800
Message-Id: <1309163160-3201-3-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309163160-3201-1-git-send-email-ying.huang@intel.com>
References: <1309163160-3201-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some machine may have broken firmware so that GHES and firmware first
mode should be disabled.  This patch adds support to that.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/ghes.c |    8 ++++++++
 drivers/acpi/apei/hest.c |   17 +++++++++--------
 include/acpi/apei.h      |    1 +
 3 files changed, 18 insertions(+), 8 deletions(-)

--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -77,6 +77,9 @@ struct ghes {
 	};
 };
 
+int ghes_disable;
+module_param_named(disable, ghes_disable, bool, 0);
+
 static int ghes_panic_timeout	__read_mostly = 30;
 
 /*
@@ -665,6 +668,11 @@ static int __init ghes_init(void)
 		return -EINVAL;
 	}
 
+	if (ghes_disable) {
+		pr_info(GHES_PFX "GHES is not enabled!\n");
+		return -EINVAL;
+	}
+
 	rc = ghes_ioremap_init();
 	if (rc)
 		goto err;
--- a/drivers/acpi/apei/hest.c
+++ b/drivers/acpi/apei/hest.c
@@ -230,16 +230,17 @@ void __init acpi_hest_init(void)
 		goto err;
 	}
 
-	rc = apei_hest_parse(hest_parse_ghes_count, &ghes_count);
-	if (rc)
-		goto err;
-
-	rc = hest_ghes_dev_register(ghes_count);
-	if (!rc) {
-		pr_info(HEST_PFX "Table parsing has been initialized.\n");
-		return;
+	if (!ghes_disable) {
+		rc = apei_hest_parse(hest_parse_ghes_count, &ghes_count);
+		if (rc)
+			goto err;
+		rc = hest_ghes_dev_register(ghes_count);
+		if (rc)
+			goto err;
 	}
 
+	pr_info(HEST_PFX "Table parsing has been initialized.\n");
+	return;
 err:
 	hest_disable = 1;
 }
--- a/include/acpi/apei.h
+++ b/include/acpi/apei.h
@@ -18,6 +18,7 @@
 
 extern int hest_disable;
 extern int erst_disable;
+extern int ghes_disable;
 
 #ifdef CONFIG_ACPI_APEI
 void __init acpi_hest_init(void);
