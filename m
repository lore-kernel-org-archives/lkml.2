Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053Ab1FWRYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:24:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932657Ab1FWRYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:24:52 -0400
Date: Thu, 23 Jun 2011 13:24:51 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, evel@driverdev.osuosl.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110623172451.27744.89279.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH 26/35] drivers/staging changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging changes for SMBIOS and System Firmware

As part of the new SMBIOS and System Firmware code:

- Replace old dmi* structures and functions with new sysfw* and smbios*
structures and functions in individual drivers
- cleanup sysfw_id lookup tables
- cleanup of includes for dmi.h and mod_devicetable.h which were included in
some files that did not need them

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/staging/hv/hv_mouse.c      |    1 -
 drivers/staging/hv/hv_timesource.c |   18 +++++++++---------
 drivers/staging/hv/hv_util.c       |   17 ++++++++---------
 drivers/staging/hv/netvsc_drv.c    |   17 ++++++++---------
 drivers/staging/hv/vmbus_drv.c     |    1 -
 5 files changed, 25 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 359e737..b40c23f 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -23,7 +23,6 @@
 #include <linux/hid.h>
 #include <linux/hiddev.h>
 #include <linux/pci.h>
-#include <linux/dmi.h>
 #include <linux/delay.h>
 
 #include "hyperv.h"
diff --git a/drivers/staging/hv/hv_timesource.c b/drivers/staging/hv/hv_timesource.c
index 0efb049..34dc583 100644
--- a/drivers/staging/hv/hv_timesource.c
+++ b/drivers/staging/hv/hv_timesource.c
@@ -27,7 +27,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <asm/hyperv.h>
 #include <asm/mshyperv.h>
 #include <asm/hypervisor.h>
@@ -61,19 +61,19 @@ static struct clocksource hyperv_cs = {
 	.shift          = HV_CLOCK_SHIFT,
 };
 
-static const struct dmi_system_id __initconst
-hv_timesource_dmi_table[] __maybe_unused  = {
+static const struct sysfw_id __initconst
+hv_timesource_smbios_table[] __maybe_unused = {
 	{
 		.ident = "Hyper-V",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Virtual Machine"),
-			DMI_MATCH(DMI_BOARD_NAME, "Virtual Machine"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Microsoft Corporation"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Virtual Machine"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "Virtual Machine"),
 		},
 	},
-	{ },
+	{},
 };
-MODULE_DEVICE_TABLE(dmi, hv_timesource_dmi_table);
+MODULE_DEVICE_TABLE(smbios, hv_timesource_smbios_table);
 
 static const struct pci_device_id __initconst
 hv_timesource_pci_table[] __maybe_unused = {
@@ -89,7 +89,7 @@ static int __init init_hv_clocksource(void)
 		!(ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE))
 		return -ENODEV;
 
-	if (!dmi_check_system(hv_timesource_dmi_table))
+	if (!sysfw_callback(hv_timesource_smbios_table))
 		return -ENODEV;
 
 	pr_info("Registering HyperV clock source\n");
diff --git a/drivers/staging/hv/hv_util.c b/drivers/staging/hv/hv_util.c
index c164b54..2d672b8 100644
--- a/drivers/staging/hv/hv_util.c
+++ b/drivers/staging/hv/hv_util.c
@@ -26,8 +26,8 @@
 #include <linux/slab.h>
 #include <linux/sysctl.h>
 #include <linux/reboot.h>
-#include <linux/dmi.h>
 #include <linux/pci.h>
+#include <linux/sysfw.h>
 
 #include "hyperv.h"
 #include "hv_kvp.h"
@@ -218,19 +218,18 @@ hv_utils_pci_table[] __maybe_unused = {
 MODULE_DEVICE_TABLE(pci, hv_utils_pci_table);
 
 
-static const struct dmi_system_id __initconst
-hv_utils_dmi_table[] __maybe_unused  = {
+static const struct sysfw_id __initconst hv_utils_id_table[] __maybe_unused = {
 	{
 		.ident = "Hyper-V",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Virtual Machine"),
-			DMI_MATCH(DMI_BOARD_NAME, "Virtual Machine"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Microsoft Corporation"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Virtual Machine"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "Virtual Machine"),
 		},
 	},
-	{ },
+	{},
 };
-MODULE_DEVICE_TABLE(dmi, hv_utils_dmi_table);
+MODULE_DEVICE_TABLE(sysfw, hv_utils_id_table);
 
 
 static int __init init_hyperv_utils(void)
@@ -241,7 +240,7 @@ static int __init init_hyperv_utils(void)
 		return -ENODEV;
 
 
-	if (!dmi_check_system(hv_utils_dmi_table))
+	if (!sysfw_callback(hv_utils_id_table))
 		return -ENODEV;
 
 	shut_txf_buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 7b9c229..0ffc210 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -32,8 +32,8 @@
 #include <linux/skbuff.h>
 #include <linux/in.h>
 #include <linux/slab.h>
-#include <linux/dmi.h>
 #include <linux/pci.h>
+#include <linux/sysfw.h>
 #include <net/arp.h>
 #include <net/route.h>
 #include <net/sock.h>
@@ -439,19 +439,18 @@ static void __exit netvsc_drv_exit(void)
 }
 
 
-static const struct dmi_system_id __initconst
-hv_netvsc_dmi_table[] __maybe_unused  = {
+static const struct sysfw_id __initconst hv_netvsc_id_table[] __maybe_unused = {
 	{
 		.ident = "Hyper-V",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Virtual Machine"),
-			DMI_MATCH(DMI_BOARD_NAME, "Virtual Machine"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Microsoft Corporation"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Virtual Machine"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "Virtual Machine"),
 		},
 	},
-	{ },
+	{},
 };
-MODULE_DEVICE_TABLE(dmi, hv_netvsc_dmi_table);
+MODULE_DEVICE_TABLE(sysfw, hv_netvsc_id_table);
 
 static int __init netvsc_drv_init(void)
 {
@@ -460,7 +459,7 @@ static int __init netvsc_drv_init(void)
 
 	pr_info("initializing....");
 
-	if (!dmi_check_system(hv_netvsc_dmi_table))
+	if (!sysfw_callback(hv_netvsc_id_table))
 		return -ENODEV;
 
 
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index ec1d38c..18e3687 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -29,7 +29,6 @@
 #include <linux/interrupt.h>
 #include <linux/sysctl.h>
 #include <linux/pci.h>
-#include <linux/dmi.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
 #include <acpi/acpi_bus.h>
-- 
1.7.5.4

