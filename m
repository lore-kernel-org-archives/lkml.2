Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab2J1Xbw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:31:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42230 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757046Ab2J1X2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:30 -0400
Message-Id: <20121028231545.312080611@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:03 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [ 027/105] ACPI: EC: Add a quirk for CLEVO M720T/M730T laptop
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Tang <feng.tang@intel.com>

commit 67bfa9b60bd689601554526d144b21d529f78a09 upstream.

By enlarging the GPE storm threshold back to 20, that laptop's
EC works fine with interrupt mode instead of polling mode.

https://bugzilla.kernel.org/show_bug.cgi?id=45151

Reported-and-Tested-by: Francesco <trentini@dei.unipd.it>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


