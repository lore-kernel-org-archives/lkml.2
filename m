Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab1HBWPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 18:15:51 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:55141 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584Ab1HBWPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 18:15:43 -0400
From: Len Brown <lenb@kernel.org>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 07/19] ACPI, APEI, GHES, Support disable GHES at boot time
Date: Tue, 02 Aug 2011 18:14:40 -0400
Message-id: <b6a9501658530d8b8374e37f1edb549039a8a260.1312323131.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.6.396.ge0613
In-reply-to: <1312323292-2986-1-git-send-email-lenb@kernel.org>
References: <1312323292-2986-1-git-send-email-lenb@kernel.org>
In-reply-to: <ca7cc5110a313a609da40ae948978a585352564b.1312323131.git.len.brown@intel.com>
References: <ca7cc5110a313a609da40ae948978a585352564b.1312323131.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

Some machine may have broken firmware so that GHES and firmware first
mode should be disabled.  This patch adds support to that.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/apei/ghes.c |    8 ++++++++
 drivers/acpi/apei/hest.c |   17 +++++++++--------
 include/acpi/apei.h      |    1 +
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index f339c0f..b142b94 100644
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
diff --git a/drivers/acpi/apei/hest.c b/drivers/acpi/apei/hest.c
index 181bc2f..05fee06 100644
--- a/drivers/acpi/apei/hest.c
+++ b/drivers/acpi/apei/hest.c
@@ -231,16 +231,17 @@ void __init acpi_hest_init(void)
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
diff --git a/include/acpi/apei.h b/include/acpi/apei.h
index e67b523..d40bc55 100644
--- a/include/acpi/apei.h
+++ b/include/acpi/apei.h
@@ -18,6 +18,7 @@
 
 extern int hest_disable;
 extern int erst_disable;
+extern int ghes_disable;
 
 #ifdef CONFIG_ACPI_APEI
 void __init acpi_hest_init(void);
-- 
1.7.6.396.ge0613

