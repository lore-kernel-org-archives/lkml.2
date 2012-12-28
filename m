Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab2L1Tj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:39:28 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55378 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932207Ab2L1TSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:46 -0500
Message-Id: <20121228190349.066715325@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:00 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 090/173] ACPI: do acpisleep dmi check when CONFIG_ACPI_SLEEP is set
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

commit 0ac1b1d7b7424cd6f129b5454b504b3cae746f0e upstream.

The current acpisleep DMI checks only run when CONFIG_SUSPEND is set.
And this may break hibernation on some platforms when CONFIG_SUSPEND
is cleared.

Move acpisleep DMI check into #ifdef CONFIG_ACPI_SLEEP instead.

[rjw: Added acpi_sleep_dmi_check() and rebased on top of earlier
 patches adding entries to acpisleep_dmi_table[].]
References: https://bugzilla.kernel.org/show_bug.cgi?id=45921
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/sleep.c |  348 +++++++++++++++++++++++++-------------------------
 1 file changed, 177 insertions(+), 171 deletions(-)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 1463c56..6efef87 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -124,6 +124,180 @@ void __init acpi_old_suspend_ordering(void)
 	old_suspend_ordering = true;
 }
 
+static int __init init_old_suspend_ordering(const struct dmi_system_id *d)
+{
+	acpi_old_suspend_ordering();
+	return 0;
+}
+
+static int __init init_nvs_nosave(const struct dmi_system_id *d)
+{
+	acpi_nvs_nosave();
+	return 0;
+}
+
+static struct dmi_system_id __initdata acpisleep_dmi_table[] = {
+	{
+	.callback = init_old_suspend_ordering,
+	.ident = "Abit KN9 (nForce4 variant)",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_VENDOR, "http://www.abit.com.tw/"),
+		DMI_MATCH(DMI_BOARD_NAME, "KN9 Series(NF-CK804)"),
+		},
+	},
+	{
+	.callback = init_old_suspend_ordering,
+	.ident = "HP xw4600 Workstation",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP xw4600 Workstation"),
+		},
+	},
+	{
+	.callback = init_old_suspend_ordering,
+	.ident = "Asus Pundit P1-AH2 (M2N8L motherboard)",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTek Computer INC."),
+		DMI_MATCH(DMI_BOARD_NAME, "M2N8L"),
+		},
+	},
+	{
+	.callback = init_old_suspend_ordering,
+	.ident = "Panasonic CF51-2L",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_VENDOR,
+				"Matsushita Electric Industrial Co.,Ltd."),
+		DMI_MATCH(DMI_BOARD_NAME, "CF51-2L"),
+		},
+	},
+	{
+	.callback = init_nvs_nosave,
+	.ident = "Sony Vaio VGN-FW21E",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FW21E"),
+		},
+	},
+	{
+	.callback = init_nvs_nosave,
+	.ident = "Sony Vaio VPCEB17FX",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VPCEB17FX"),
+		},
+	},
+	{
+	.callback = init_nvs_nosave,
+	.ident = "Sony Vaio VGN-SR11M",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-SR11M"),
+		},
+	},
+	{
+	.callback = init_nvs_nosave,
+	.ident = "Everex StepNote Series",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Everex Systems, Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Everex StepNote Series"),
+		},
+	},
+	{
+	.callback = init_nvs_nosave,
+	.ident = "Sony Vaio VPCEB1Z1E",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VPCEB1Z1E"),
+		},
+	},
+	{
+	.callback = init_nvs_nosave,
+	.ident = "Sony Vaio VGN-NW130D",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-NW130D"),
+		},
+	},
+	{
+	.callback = init_nvs_nosave,
+	.ident = "Sony Vaio VPCCW29FX",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VPCCW29FX"),
+		},
+	},
+	{
+	.callback = init_nvs_nosave,
+	.ident = "Averatec AV1020-ED2",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "AVERATEC"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "1000 Series"),
+		},
+	},
+	{
+	.callback = init_old_suspend_ordering,
+	.ident = "Asus A8N-SLI DELUXE",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
+		DMI_MATCH(DMI_BOARD_NAME, "A8N-SLI DELUXE"),
+		},
+	},
+	{
+	.callback = init_old_suspend_ordering,
+	.ident = "Asus A8N-SLI Premium",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
+		DMI_MATCH(DMI_BOARD_NAME, "A8N-SLI Premium"),
+		},
+	},
+	{
+	.callback = init_nvs_nosave,
+	.ident = "Sony Vaio VGN-SR26GN_P",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-SR26GN_P"),
+		},
+	},
+	{
+	.callback = init_nvs_nosave,
+	.ident = "Sony Vaio VPCEB1S1E",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VPCEB1S1E"),
+		},
+	},
+	{
+	.callback = init_nvs_nosave,
+	.ident = "Sony Vaio VGN-FW520F",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FW520F"),
+		},
+	},
+	{
+	.callback = init_nvs_nosave,
+	.ident = "Asus K54C",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "K54C"),
+		},
+	},
+	{
+	.callback = init_nvs_nosave,
+	.ident = "Asus K54HR",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "K54HR"),
+		},
+	},
+	{},
+};
+
+static void acpi_sleep_dmi_check(void)
+{
+	dmi_check_system(acpisleep_dmi_table);
+}
+
 /**
  * acpi_pm_freeze - Disable the GPEs and suspend EC transactions.
  */
@@ -239,6 +413,7 @@ static void acpi_pm_end(void)
 }
 #else /* !CONFIG_ACPI_SLEEP */
 #define acpi_target_sleep_state	ACPI_STATE_S0
+static inline void acpi_sleep_dmi_check(void) {}
 #endif /* CONFIG_ACPI_SLEEP */
 
 #ifdef CONFIG_SUSPEND
@@ -397,175 +572,6 @@ static const struct platform_suspend_ops acpi_suspend_ops_old = {
 	.end = acpi_pm_end,
 	.recover = acpi_pm_finish,
 };
-
-static int __init init_old_suspend_ordering(const struct dmi_system_id *d)
-{
-	old_suspend_ordering = true;
-	return 0;
-}
-
-static int __init init_nvs_nosave(const struct dmi_system_id *d)
-{
-	acpi_nvs_nosave();
-	return 0;
-}
-
-static struct dmi_system_id __initdata acpisleep_dmi_table[] = {
-	{
-	.callback = init_old_suspend_ordering,
-	.ident = "Abit KN9 (nForce4 variant)",
-	.matches = {
-		DMI_MATCH(DMI_BOARD_VENDOR, "http://www.abit.com.tw/"),
-		DMI_MATCH(DMI_BOARD_NAME, "KN9 Series(NF-CK804)"),
-		},
-	},
-	{
-	.callback = init_old_suspend_ordering,
-	.ident = "HP xw4600 Workstation",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "HP xw4600 Workstation"),
-		},
-	},
-	{
-	.callback = init_old_suspend_ordering,
-	.ident = "Asus Pundit P1-AH2 (M2N8L motherboard)",
-	.matches = {
-		DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTek Computer INC."),
-		DMI_MATCH(DMI_BOARD_NAME, "M2N8L"),
-		},
-	},
-	{
-	.callback = init_old_suspend_ordering,
-	.ident = "Panasonic CF51-2L",
-	.matches = {
-		DMI_MATCH(DMI_BOARD_VENDOR,
-				"Matsushita Electric Industrial Co.,Ltd."),
-		DMI_MATCH(DMI_BOARD_NAME, "CF51-2L"),
-		},
-	},
-	{
-	.callback = init_nvs_nosave,
-	.ident = "Sony Vaio VGN-FW21E",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FW21E"),
-		},
-	},
-	{
-	.callback = init_nvs_nosave,
-	.ident = "Sony Vaio VPCEB17FX",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "VPCEB17FX"),
-		},
-	},
-	{
-	.callback = init_nvs_nosave,
-	.ident = "Sony Vaio VGN-SR11M",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-SR11M"),
-		},
-	},
-	{
-	.callback = init_nvs_nosave,
-	.ident = "Everex StepNote Series",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Everex Systems, Inc."),
-		DMI_MATCH(DMI_PRODUCT_NAME, "Everex StepNote Series"),
-		},
-	},
-	{
-	.callback = init_nvs_nosave,
-	.ident = "Sony Vaio VPCEB1Z1E",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "VPCEB1Z1E"),
-		},
-	},
-	{
-	.callback = init_nvs_nosave,
-	.ident = "Sony Vaio VGN-NW130D",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-NW130D"),
-		},
-	},
-	{
-	.callback = init_nvs_nosave,
-	.ident = "Sony Vaio VPCCW29FX",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "VPCCW29FX"),
-		},
-	},
-	{
-	.callback = init_nvs_nosave,
-	.ident = "Averatec AV1020-ED2",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "AVERATEC"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "1000 Series"),
-		},
-	},
-	{
-	.callback = init_old_suspend_ordering,
-	.ident = "Asus A8N-SLI DELUXE",
-	.matches = {
-		DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
-		DMI_MATCH(DMI_BOARD_NAME, "A8N-SLI DELUXE"),
-		},
-	},
-	{
-	.callback = init_old_suspend_ordering,
-	.ident = "Asus A8N-SLI Premium",
-	.matches = {
-		DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
-		DMI_MATCH(DMI_BOARD_NAME, "A8N-SLI Premium"),
-		},
-	},
-	{
-	.callback = init_nvs_nosave,
-	.ident = "Sony Vaio VGN-SR26GN_P",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-SR26GN_P"),
-		},
-	},
-	{
-	.callback = init_nvs_nosave,
-	.ident = "Sony Vaio VPCEB1S1E",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "VPCEB1S1E"),
-		},
-	},
-	{
-	.callback = init_nvs_nosave,
-	.ident = "Sony Vaio VGN-FW520F",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FW520F"),
-		},
-	},
-	{
-	.callback = init_nvs_nosave,
-	.ident = "Asus K54C",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
-		DMI_MATCH(DMI_PRODUCT_NAME, "K54C"),
-		},
-	},
-	{
-	.callback = init_nvs_nosave,
-	.ident = "Asus K54HR",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
-		DMI_MATCH(DMI_PRODUCT_NAME, "K54HR"),
-		},
-	},
-	{},
-};
 #endif /* CONFIG_SUSPEND */
 
 #ifdef CONFIG_HIBERNATION
@@ -896,13 +902,13 @@ int __init acpi_sleep_init(void)
 	u8 type_a, type_b;
 #ifdef CONFIG_SUSPEND
 	int i = 0;
-
-	dmi_check_system(acpisleep_dmi_table);
 #endif
 
 	if (acpi_disabled)
 		return 0;
 
+	acpi_sleep_dmi_check();
+
 	sleep_states[ACPI_STATE_S0] = 1;
 	printk(KERN_INFO PREFIX "(supports S0");
 


