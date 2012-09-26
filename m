Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab2IZNso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 09:48:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:39071 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755995Ab2IZNsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 09:48:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,490,1344236400"; 
   d="scan'208";a="226801084"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Huang Ying <ying.huang@intel.com>
Subject: [PATCH] ACPI/PCI: Make PCI devices notified when its power resource turned on
Date: Wed, 26 Sep 2012 21:48:37 +0800
Message-Id: <1348667317-30693-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A set of power resources may be shared by multiple devices.  When all
devices share one set of power resources is put into D3_COLD state,
the power resources will be turned off.  When one of the device is
waked, the power resource will be turned on and all devices share it
will be powered on to D0uninitialized state.  These devices should be
resumed, so that they can get opportunity to go to low power state
later.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/pci_bind.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/acpi/pci_bind.c
+++ b/drivers/acpi/pci_bind.c
@@ -45,6 +45,7 @@ static int acpi_pci_unbind(struct acpi_d
 
 	device_set_run_wake(&dev->dev, false);
 	pci_acpi_remove_pm_notifier(device);
+	acpi_power_resource_unregister_device(dev, device->handle);
 
 	if (!dev->subordinate)
 		goto out;
@@ -71,6 +72,7 @@ static int acpi_pci_bind(struct acpi_dev
 		return 0;
 
 	pci_acpi_add_pm_notifier(device, dev);
+	acpi_power_resource_register_device(dev, device->handle);
 	if (device->wakeup.flags.run_wake)
 		device_set_run_wake(&dev->dev, true);
 
