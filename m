Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab1B1T5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 14:57:14 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50531 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab1B1T5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 14:57:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KZDhHLmi9W+lDLLlgKwVqWc8Vmr0PDkmkis17mKKv4NrYWLZvJd3+164tBM0gtj0Xh
         ETfiO8wGZJ2HmR/p7lXg11A+6hzyVQlVOnqGcGg76Al3d0pWOEjCqTiaiD70H1I9vKSD
         oLWh0fRLlLdiCDSQidQ8UmjS+XiKSSne9tbEU=
From: Johan Wessfeldt <johan.wessfeldt@gmail.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Wessfeldt <johan.wessfeldt@gmail.com>
Subject: [PATCH] acpi: Corrections of unchecked calls to request_region
Date: Mon, 28 Feb 2011 20:56:48 +0100
Message-Id: <1298923008-16796-1-git-send-email-johan.wessfeldt@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces checks when acpi osl reserves resources by calling
request_region.

Please review:
Is it valid to return early when acpi_request_region() fails?

Signed-off-by: Johan Wessfeldt <johan.wessfeldt@gmail.com>
---
 drivers/acpi/osl.c |   85 +++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 57 insertions(+), 28 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index c90c76a..5c8c521 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -166,48 +166,77 @@ static u32 acpi_osi_handler(acpi_string interface, u32 supported)
 	return supported;
 }
 
-static void __init acpi_request_region (struct acpi_generic_address *addr,
+static int __init acpi_request_region(struct acpi_generic_address *addr,
 	unsigned int length, char *desc)
 {
+	struct resource *pRes;
+
 	if (!addr->address || !length)
-		return;
+		return -EIO;
 
 	/* Resources are never freed */
-	if (addr->space_id == ACPI_ADR_SPACE_SYSTEM_IO)
-		request_region(addr->address, length, desc);
-	else if (addr->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
-		request_mem_region(addr->address, length, desc);
+	if (addr->space_id == ACPI_ADR_SPACE_SYSTEM_IO) {
+		pRes = request_region(addr->address, length, desc);
+		if (pRes == NULL)
+			return -EIO;
+
+	} else if (addr->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY) {
+		pRes = request_mem_region(addr->address, length, desc);
+		if (pRes == NULL)
+			return -EIO;
+	}
+
+	return 0;
 }
 
 static int __init acpi_reserve_resources(void)
 {
-	acpi_request_region(&acpi_gbl_FADT.xpm1a_event_block, acpi_gbl_FADT.pm1_event_length,
-		"ACPI PM1a_EVT_BLK");
+	if (!acpi_request_region(&acpi_gbl_FADT.xpm1a_event_block,
+				 acpi_gbl_FADT.pm1_event_length,
+				 "ACPI PM1a_EVT_BLK"))
+		return -EIO;
 
-	acpi_request_region(&acpi_gbl_FADT.xpm1b_event_block, acpi_gbl_FADT.pm1_event_length,
-		"ACPI PM1b_EVT_BLK");
+	if (!acpi_request_region(&acpi_gbl_FADT.xpm1b_event_block,
+				 acpi_gbl_FADT.pm1_event_length,
+				 "ACPI PM1b_EVT_BLK"))
+		return -EIO;
 
-	acpi_request_region(&acpi_gbl_FADT.xpm1a_control_block, acpi_gbl_FADT.pm1_control_length,
-		"ACPI PM1a_CNT_BLK");
+	if (!acpi_request_region(&acpi_gbl_FADT.xpm1a_control_block,
+				 acpi_gbl_FADT.pm1_control_length,
+				 "ACPI PM1a_CNT_BLK"))
+		return -EIO;
 
-	acpi_request_region(&acpi_gbl_FADT.xpm1b_control_block, acpi_gbl_FADT.pm1_control_length,
-		"ACPI PM1b_CNT_BLK");
+	if (!acpi_request_region(&acpi_gbl_FADT.xpm1b_control_block,
+				 acpi_gbl_FADT.pm1_control_length,
+				 "ACPI PM1b_CNT_BLK"))
+		return -EIO;
 
-	if (acpi_gbl_FADT.pm_timer_length == 4)
-		acpi_request_region(&acpi_gbl_FADT.xpm_timer_block, 4, "ACPI PM_TMR");
+	if (acpi_gbl_FADT.pm_timer_length == 4) {
+		if (!acpi_request_region(&acpi_gbl_FADT.xpm_timer_block,
+					 4, "ACPI PM_TMR"))
+			return -EIO;
+	}
 
-	acpi_request_region(&acpi_gbl_FADT.xpm2_control_block, acpi_gbl_FADT.pm2_control_length,
-		"ACPI PM2_CNT_BLK");
+	if (!acpi_request_region(&acpi_gbl_FADT.xpm2_control_block,
+				 acpi_gbl_FADT.pm2_control_length,
+				 "ACPI PM2_CNT_BLK"))
+		return -EIO;
 
 	/* Length of GPE blocks must be a non-negative multiple of 2 */
 
-	if (!(acpi_gbl_FADT.gpe0_block_length & 0x1))
-		acpi_request_region(&acpi_gbl_FADT.xgpe0_block,
-			       acpi_gbl_FADT.gpe0_block_length, "ACPI GPE0_BLK");
+	if (!(acpi_gbl_FADT.gpe0_block_length & 0x1)) {
+		if (!acpi_request_region(&acpi_gbl_FADT.xgpe0_block,
+					 acpi_gbl_FADT.gpe0_block_length,
+					 "ACPI GPE0_BLK"))
+			return -EIO;
+	}
 
-	if (!(acpi_gbl_FADT.gpe1_block_length & 0x1))
-		acpi_request_region(&acpi_gbl_FADT.xgpe1_block,
-			       acpi_gbl_FADT.gpe1_block_length, "ACPI GPE1_BLK");
+	if (!(acpi_gbl_FADT.gpe1_block_length & 0x1)) {
+		if (!acpi_request_region(&acpi_gbl_FADT.xgpe1_block,
+					 acpi_gbl_FADT.gpe1_block_length,
+					 "ACPI GPE1_BLK"))
+			return -EIO;
+	}
 
 	return 0;
 }
-- 
1.7.2.3

