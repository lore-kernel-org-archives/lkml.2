Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab2FRG2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:28:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:63878 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176Ab2FRG0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:26:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="181387352"
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lu@amd.com>,
        Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        David Woodhouse <David.Woodhouse@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH v5 07/12] libata-acpi: register/unregister device to/from power resource
Date: Mon, 18 Jun 2012 14:26:01 +0800
Message-Id: <1340000766-129148-8-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340000766-129148-1-git-send-email-ming.m.lin@intel.com>
References: <1340000766-129148-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/acpi/power.c      |    2 ++
 drivers/ata/libata-acpi.c |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index dd6d6a3..eb640874 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -390,6 +390,7 @@ void acpi_power_resource_unregister_device(struct device *dev, acpi_handle handl
 		__acpi_power_resource_unregister_device(dev,
 			list->handles[i]);
 }
+EXPORT_SYMBOL_GPL(acpi_power_resource_unregister_device);
 
 static int __acpi_power_resource_register_device(
 	struct acpi_power_managed_device *powered_device, acpi_handle handle)
@@ -460,6 +461,7 @@ int acpi_power_resource_register_device(struct device *dev, acpi_handle handle)
 	printk(KERN_WARNING PREFIX "Invalid Power Resource to register!");
 	return -ENODEV;
 }
+EXPORT_SYMBOL_GPL(acpi_power_resource_register_device);
 
 /**
  * acpi_device_sleep_wake - execute _DSW (Device Sleep Wake) or (deprecated in
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 3f7d376..9287593 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -1025,14 +1025,46 @@ static void ata_acpi_remove_pm_notifier(struct ata_device *dev)
 	}
 }
 
+static void ata_acpi_register_power_resource(struct ata_device *dev)
+{
+	struct scsi_device *sdev = dev->sdev;
+	acpi_handle handle;
+	struct device *device;
+
+	handle = ata_dev_acpi_handle(dev);
+	if (!handle)
+		return;
+
+	device = &sdev->sdev_gendev;
+
+	acpi_power_resource_register_device(device, handle);
+}
+
+static void ata_acpi_unregister_power_resource(struct ata_device *dev)
+{
+	struct scsi_device *sdev = dev->sdev;
+	acpi_handle handle;
+	struct device *device;
+
+	handle = ata_dev_acpi_handle(dev);
+	if (!handle)
+		return;
+
+	device = &sdev->sdev_gendev;
+
+	acpi_power_resource_unregister_device(device, handle);
+}
+
 void ata_acpi_bind(struct ata_device *dev)
 {
 	ata_acpi_add_pm_notifier(dev);
+	ata_acpi_register_power_resource(dev);
 }
 
 void ata_acpi_unbind(struct ata_device *dev)
 {
 	ata_acpi_remove_pm_notifier(dev);
+	ata_acpi_unregister_power_resource(dev);
 }
 
 static int compat_pci_ata(struct device *dev)
-- 
1.7.10

