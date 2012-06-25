Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab2FYIQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 04:16:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:19357 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab2FYIOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 04:14:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="157814269"
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lu@amd.com>,
        Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH v6 06/11] libata-acpi: register/unregister device to/from power resource
Date: Mon, 25 Jun 2012 16:13:07 +0800
Message-Id: <1340611992-41457-7-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340611992-41457-1-git-send-email-ming.m.lin@intel.com>
References: <1340611992-41457-1-git-send-email-ming.m.lin@intel.com>
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
index e01807a..f36284e 100644
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
 
 static int compat_pci_ata(struct ata_port *ap)
-- 
1.7.10

