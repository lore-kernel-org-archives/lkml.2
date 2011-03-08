Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab1CHOvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 09:51:07 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:54390 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab1CHOvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 09:51:01 -0500
X-IronPort-AV: E=Sophos;i="4.62,284,1297036800"; 
   d="scan'208";a="4674820"
Subject: Re: [Xen-devel] Re: [RFC PATCH] set current_state to D0 in
 register_slot
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Allen Kay <allen.m.kay@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110304104251.45b257c4@jbarnes-desktop>
References: <alpine.DEB.2.00.1102281605130.2917@kaball-desktop>
	 <20110304104251.45b257c4@jbarnes-desktop>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 8 Mar 2011 14:50:58 +0000
Message-ID: <1299595858.17339.512.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-04 at 18:42 +0000, Jesse Barnes wrote:
> On Mon, 28 Feb 2011 16:20:11 +0000
> Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> 
> > Hi all,
> > if a device doesn't support power management (pm_cap == 0) but it is
> > acpi_pci_power_manageable() because there is a _PS0 method declared for
> > it and _EJ0 is also declared for the slot then nobody is going to set
> > current_state = PCI_D0 for this device.  This is what I think it is
> > happening:
> > 
> > 
> > pci_enable_device
> >     |
> > __pci_enable_device_flags
> > /* here we do not set current_state because !pm_cap */
> >     |
> > do_pci_enable_device
> >     |
> > pci_set_power_state
> >     |
> > __pci_start_power_transition
> >     |
> > pci_platform_power_transition
> > /* platform_pci_power_manageable() calls acpi_pci_power_manageable that
> >  * returns true */
> >     |
> > platform_pci_set_power_state
> > /* acpi_pci_set_power_state gets called and does nothing because the
> >  * acpi device has _EJ0, see the comment "If the ACPI device has _EJ0,
> >  * ignore the device" */
> > 
> > 
> > at this point if we refer to the commit message that introduced the
> > comment above (10b3dcae0f275e2546e55303d64ddbb58cec7599), it is up to
> > the hotplug driver to set the state to D0.
> > However AFAICT the pci hotplug driver never does, in fact
> > drivers/pci/hotplug/acpiphp_glue.c:register_slot sets the slot flags to
> > (SLOT_ENABLED | SLOT_POWEREDON) but it does not set the pci device
> > current state to PCI_D0.
> > 
> > So my proposed fix is also to set current_state = PCI_D0 in
> > register_slot.
> > Comments are very welcome.
> > 
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> Yeah, looks fine.  ACPIPHP is happy for the attention. :)

This helps for coldplug of devices which lack the PCI CFG space power
management capability but doesn't help with hotplugging such devices.

Is it fair to assume that any PCI device in a slot which has just been
powered on will be in D0?

e.g. Stefano's patch plus the following seem to fix the crashes I've
been having with 82599 VFs for both hot and cold plug.

Ian.

acpiphp: set each new function to state D0 after powering on a slot.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index e610cfe..b4befbd 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -819,9 +819,17 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 		}
 	}
 
-	list_for_each_entry(func, &slot->funcs, sibling)
+	list_for_each_entry(func, &slot->funcs, sibling) {
 		acpiphp_bus_add(func);
 
+		dev = pci_get_slot(bus, PCI_DEVFN(slot->device,
+						  func->function));
+		if (!dev)
+			continue;
+		dev->current_state = PCI_D0;
+		pci_dev_put(dev);
+	}
+
 	pci_bus_assign_resources(bus);
 	acpiphp_sanitize_bus(bus);
 	acpiphp_set_hpp_values(bus);


