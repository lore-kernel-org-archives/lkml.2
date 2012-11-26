Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab2KZRDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:03:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47258 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573Ab2KZRDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:03:00 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 052/270] ACPI: EC: Add a quirk for CLEVO M720T/M730T laptop
Date: Mon, 26 Nov 2012 14:55:42 -0200
Message-Id: <1353949160-26803-53-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Tang <feng.tang@intel.com>

commit 67bfa9b60bd689601554526d144b21d529f78a09 upstream.

By enlarging the GPE storm threshold back to 20, that laptop's
EC works fine with interrupt mode instead of polling mode.

https://bugzilla.kernel.org/show_bug.cgi?id=45151

Reported-and-Tested-by: Francesco <trentini@dei.unipd.it>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/acpi/ec.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 615264c..a51df96 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -930,6 +930,17 @@ static int ec_flag_msi(const struct dmi_system_id *id)
 	return 0;
 }
 
+/*
+ * Clevo M720 notebook actually works ok with IRQ mode, if we lifted
+ * the GPE storm threshold back to 20
+ */
+static int ec_enlarge_storm_threshold(const struct dmi_system_id *id)
+{
+	pr_debug("Setting the EC GPE storm threshold to 20\n");
+	ec_storm_threshold  = 20;
+	return 0;
+}
+
 static struct dmi_system_id __initdata ec_dmi_table[] = {
 	{
 	ec_skip_dsdt_scan, "Compal JFL92", {
@@ -961,10 +972,13 @@ static struct dmi_system_id __initdata ec_dmi_table[] = {
 	{
 	ec_validate_ecdt, "ASUS hardware", {
 	DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer Inc.") }, NULL},
+	{
+	ec_enlarge_storm_threshold, "CLEVO hardware", {
+	DMI_MATCH(DMI_SYS_VENDOR, "CLEVO Co."),
+	DMI_MATCH(DMI_PRODUCT_NAME, "M720T/M730T"),}, NULL},
 	{},
 };
 
-
 int __init acpi_ec_ecdt_probe(void)
 {
 	acpi_status status;
-- 
1.7.9.5

