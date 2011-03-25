Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323Ab1CZAY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:24:56 -0400
Received: from kroah.org ([198.145.64.141]:41540 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630Ab1CYXwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:30 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:45:09 2011
Message-Id: <20110325234509.818300291@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:43:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [19/63] PCI hotplug: acpiphp: set current_state to D0 in register_slot
In-Reply-To: <20110325234526.GA18017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/pci/hotplug/acpiphp_glue.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -212,6 +212,7 @@ register_slot(acpi_handle handle, u32 lv
 
 	pdev = pci_get_slot(pbus, PCI_DEVFN(device, function));
 	if (pdev) {
+		pdev->current_state = PCI_D0;
 		slot->flags |= (SLOT_ENABLED | SLOT_POWEREDON);
 		pci_dev_put(pdev);
 	}


