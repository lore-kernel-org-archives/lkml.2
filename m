Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab2CMAR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:17:29 -0400
Received: from mail.windriver.com ([147.11.1.11]:46484 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063Ab2CMARZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:17:25 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 002/196] PCI hotplug: acpiphp: set current_state to D0 in register_slot
Date: Mon, 12 Mar 2012 20:12:10 -0400
Message-Id: <1331597724-31358-3-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |    1 +
 1 file changed, 1 insertion(+)

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
-- 
1.7.9.3

