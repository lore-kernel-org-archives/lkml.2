Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab2JIGEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:04:06 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:58217 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab2JIGDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:03:47 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Len Brown <len.brown@intel.com>, stable@vger.kernel.org
Subject: [PATCH 27/30] ACPI: EC: Add a quirk for CLEVO M720T/M730T laptop
Date: Tue,  9 Oct 2012 01:54:17 -0400
Message-Id: <67bfa9b60bd689601554526d144b21d529f78a09.1349761836.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0.rc1
In-Reply-To: <1349762060-25334-1-git-send-email-lenb@kernel.org>
References: <1349762060-25334-1-git-send-email-lenb@kernel.org>
In-Reply-To: <e3f25e6e5836c4790fbe395ff42e241f372d859d.1349761836.git.len.brown@intel.com>
References: <e3f25e6e5836c4790fbe395ff42e241f372d859d.1349761836.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

By enlarging the GPE storm threshold back to 20, that laptop's
EC works fine with interrupt mode instead of polling mode.

https://bugzilla.kernel.org/show_bug.cgi?id=45151

Reported-and-Tested-by: Francesco <trentini@dei.unipd.it>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
cc: stable@vger.kernel.org
---
 drivers/acpi/ec.c | 16 +++++++++++++++-
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
1.8.0.rc1

