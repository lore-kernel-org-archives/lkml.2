Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab1B1QUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:20:16 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:31527 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab1B1QUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:20:15 -0500
X-IronPort-AV: E=Sophos;i="4.62,240,1297036800"; 
   d="scan'208";a="4540810"
Date: Mon, 28 Feb 2011 16:20:11 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: linux-kernel@vger.kernel.org
CC: xen-devel@lists.xensource.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        Allen Kay <allen.m.kay@intel.com>
Subject: [RFC PATCH] set current_state to D0 in register_slot
Message-ID: <alpine.DEB.2.00.1102281605130.2917@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
if a device doesn't support power management (pm_cap == 0) but it is
acpi_pci_power_manageable() because there is a _PS0 method declared for
it and _EJ0 is also declared for the slot then nobody is going to set
current_state = PCI_D0 for this device.  This is what I think it is
happening:


pci_enable_device
    |
__pci_enable_device_flags
/* here we do not set current_state because !pm_cap */
    |
do_pci_enable_device
    |
pci_set_power_state
    |
__pci_start_power_transition
    |
pci_platform_power_transition
/* platform_pci_power_manageable() calls acpi_pci_power_manageable that
 * returns true */
    |
platform_pci_set_power_state
/* acpi_pci_set_power_state gets called and does nothing because the
 * acpi device has _EJ0, see the comment "If the ACPI device has _EJ0,
 * ignore the device" */


at this point if we refer to the commit message that introduced the
comment above (10b3dcae0f275e2546e55303d64ddbb58cec7599), it is up to
the hotplug driver to set the state to D0.
However AFAICT the pci hotplug driver never does, in fact
drivers/pci/hotplug/acpiphp_glue.c:register_slot sets the slot flags to
(SLOT_ENABLED | SLOT_POWEREDON) but it does not set the pci device
current state to PCI_D0.

So my proposed fix is also to set current_state = PCI_D0 in
register_slot.
Comments are very welcome.


Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

---

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index cb23aa2..e610cfe 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -212,6 +212,7 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 
 	pdev = pci_get_slot(pbus, PCI_DEVFN(device, function));
 	if (pdev) {
+		pdev->current_state = PCI_D0;
 		slot->flags |= (SLOT_ENABLED | SLOT_POWEREDON);
 		pci_dev_put(pdev);
 	}
