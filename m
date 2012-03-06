Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030304Ab2CFDaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 22:30:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39585 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030246Ab2CFDao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 22:30:44 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>, Thomas Renninger <trenn@suse.de>,
        linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 3/3] toshiba_acpi: Refuse to load on machines with buggy INFO implementations
Date: Mon,  5 Mar 2012 21:30:33 -0600
Message-Id: <1331004633-11862-4-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1331004633-11862-1-git-send-email-seth.forshee@canonical.com>
References: <20120305220407.GA16312@ubuntu-macmini>
 <1331004633-11862-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several Satellite models have a buggy implementation of the INFO method
that causes ACPI exceptions when executed:

 ACPI Error: Result stack is empty! State=ffff88012d70f800 (20110413/dswstate-98)
 ACPI Exception: AE_AML_NO_RETURN_VALUE, Missing or null operand (20110413/dsutils-646)
 ACPI Exception: AE_AML_NO_RETURN_VALUE, While creating Arg 0 (20110413/dsutils-763)
 ACPI Error: Method parse/execution failed [\_SB_.VALZ.GETE] (Node ffff880131175eb0), AE_AML_NO_RETURN_VALUE (20110413/psparse-536)
 ACPI Error: Method parse/execution failed [\_SB_.VALZ.INFO] (Node ffff880131175ed8), AE_AML_NO_RETURN_VALUE (20110413/psparse-536)
 toshiba_acpi: ACPI INFO method execution failed
 toshiba_acpi: Failed to query hotkey event

All known machines with this implementation also have a WMI interface
with event GUID 59142400-C6A3-40FA-BADB-8A2652834100 which is not seen
on any other models. Refuse to load toshiba_acpi on machines with this
guid.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/platform/x86/Kconfig        |    1 +
 drivers/platform/x86/Makefile       |    4 ++++
 drivers/platform/x86/toshiba_acpi.c |   10 ++++++++++
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index f995e6e..b420389f 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -580,6 +580,7 @@ config TOPSTAR_LAPTOP
 config ACPI_TOSHIBA
 	tristate "Toshiba Laptop Extras"
 	depends on ACPI
+	depends on ACPI_WMI
 	select LEDS_CLASS
 	select NEW_LEDS
 	depends on BACKLIGHT_CLASS_DEVICE
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index 293a320..95ce3a1 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -29,7 +29,11 @@ obj-$(CONFIG_ACPI_WMI)		+= wmi.o
 obj-$(CONFIG_MSI_WMI)		+= msi-wmi.o
 obj-$(CONFIG_ACPI_ASUS)		+= asus_acpi.o
 obj-$(CONFIG_TOPSTAR_LAPTOP)	+= topstar-laptop.o
+
+# toshiba_acpi must link after wmi to ensure that wmi devices are found
+# before toshiba_acpi initializes
 obj-$(CONFIG_ACPI_TOSHIBA)	+= toshiba_acpi.o
+
 obj-$(CONFIG_TOSHIBA_BT_RFKILL)	+= toshiba_bluetooth.o
 obj-$(CONFIG_INTEL_SCU_IPC)	+= intel_scu_ipc.o
 obj-$(CONFIG_INTEL_SCU_IPC_UTIL) += intel_scu_ipcutil.o
diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 621b207..b6d0566 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -63,6 +63,8 @@ MODULE_AUTHOR("John Belmonte");
 MODULE_DESCRIPTION("Toshiba Laptop ACPI Extras Driver");
 MODULE_LICENSE("GPL");
 
+#define TOSHIBA_WMI_EVENT_GUID "59142400-C6A3-40FA-BADB-8A2652834100"
+
 /* Scan code for Fn key on TOS1900 models */
 #define TOS1900_FN_SCAN		0x6e
 
@@ -1263,6 +1265,14 @@ static int __init toshiba_acpi_init(void)
 {
 	int ret;
 
+	/*
+	 * Machines with this WMI guid aren't supported due to bugs in
+	 * their AML. This check relies on wmi initializing before
+	 * toshiba_acpi to guarantee guids have been identified.
+	 */
+	if (wmi_has_guid(TOSHIBA_WMI_EVENT_GUID))
+		return -ENODEV;
+
 	toshiba_proc_dir = proc_mkdir(PROC_TOSHIBA, acpi_root_dir);
 	if (!toshiba_proc_dir) {
 		pr_err("Unable to create proc dir " PROC_TOSHIBA "\n");
-- 
1.7.9

