Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965193Ab1C3VTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:19:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:24598 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965190Ab1C3VJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673448579"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: stefano.stabellini@eu.citrix.com, jbarnes@virtuousgeek.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [223/275] PCI hotplug: acpiphp: set current_state to D0 in register_slot
Message-Id: <20110330210748.7BBEA3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

commit 47e9037ac16637cd7f12b8790ea7ce6680e42168 upstream.

If a device doesn't support power management (pm_cap == 0) but it is
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
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/pci/hotplug/acpiphp_glue.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-2.6.35.y.orig/drivers/pci/hotplug/acpiphp_glue.c	2011-03-29 22:50:27.345558715 -0700
+++ linux-2.6.35.y/drivers/pci/hotplug/acpiphp_glue.c	2011-03-29 23:03:02.881226447 -0700
@@ -212,6 +212,7 @@
 
 	pdev = pci_get_slot(pbus, PCI_DEVFN(device, function));
 	if (pdev) {
+		pdev->current_state = PCI_D0;
 		slot->flags |= (SLOT_ENABLED | SLOT_POWEREDON);
 		pci_dev_put(pdev);
 	}
