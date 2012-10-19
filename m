Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030448Ab2JSD1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:27:40 -0400
Received: from mail.kernel.org ([198.145.19.201]:54328 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757996Ab2JSDRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 23:17:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [ 04/37] ACPI: EC: Add a quirk for CLEVO M720T/M730T laptop
Date: Thu, 18 Oct 2012 20:16:27 -0700
Message-Id: <20121019031303.487705314@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019031302.789593147@linuxfoundation.org>
References: <20121019031302.789593147@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Tang <feng.tang@intel.com>

commit 67bfa9b60bd689601554526d144b21d529f78a09 upstream.

By enlarging the GPE storm threshold back to 20, that laptop's
EC works fine with interrupt mode instead of polling mode.

https://bugzilla.kernel.org/show_bug.cgi?id=45151

Reported-and-Tested-by: Francesco <trentini@dei.unipd.it>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/ec.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -920,6 +920,17 @@ static int ec_flag_msi(const struct dmi_
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
@@ -951,10 +962,13 @@ static struct dmi_system_id __initdata e
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


