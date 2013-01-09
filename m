Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450Ab3AIVcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:32:47 -0500
Received: from mail.kernel.org ([198.145.19.201]:42350 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933379Ab3AIUir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:38:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 34/80] ACPI: do acpisleep dmi check when CONFIG_ACPI_SLEEP is set
Date: Wed,  9 Jan 2013 12:35:26 -0800
Message-Id: <20130109201504.755318225@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201500.410171651@linuxfoundation.org>
References: <20130109201500.410171651@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/sleep.c |  348 +++++++++++++++++++++++++--------------------------
 1 file changed, 177 insertions(+), 171 deletions(-)

--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -138,6 +138,180 @@ void __init acpi_old_suspend_ordering(vo
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
@@ -227,6 +401,7 @@ static void acpi_pm_end(void)
 }
 #else /* !CONFIG_ACPI_SLEEP */
 #define acpi_target_sleep_state	ACPI_STATE_S0
+static inline void acpi_sleep_dmi_check(void) {}
 #endif /* CONFIG_ACPI_SLEEP */
 
 #ifdef CONFIG_SUSPEND
@@ -371,175 +546,6 @@ static const struct platform_suspend_ops
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
@@ -880,13 +886,13 @@ int __init acpi_sleep_init(void)
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
 


