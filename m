Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab1CHQR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 11:17:28 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:26439 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755426Ab1CHQR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 11:17:26 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Allen Kay <allen.m.kay@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1299595858.17339.512.camel@zakaz.uk.xensource.com>
References: <alpine.DEB.2.00.1102281605130.2917@kaball-desktop>
	 <20110304104251.45b257c4@jbarnes-desktop>
	 <1299595858.17339.512.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Mar 2011 16:17:12 +0000
Message-ID: <1299601032.17339.525.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [Xen-devel] Re: [RFC PATCH] set current_state to D0 in
 register_slot
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=vdPf92PhWpEA:10 a=IkcTkHD0fZMA:10 a=tHz9FfFoAAAA:8 a=u82Y5rAqqe5l7JFwmS8A:9 a=wr_4s0ZvNYB8vCdeD5wA:7 a=bGnLDv9Acaw9V-i37qvhS6ID__4A:4 a=QEXdDO2ut3YA:10 a=6O0IECtVFhoA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-08 at 14:50 +0000, Ian Campbell wrote:
> On Fri, 2011-03-04 at 18:42 +0000, Jesse Barnes wrote:
> > On Mon, 28 Feb 2011 16:20:11 +0000
> > Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> > 
> > > Hi all,
> > > if a device doesn't support power management (pm_cap == 0) but it is
> > > acpi_pci_power_manageable() because there is a _PS0 method declared for
> > > it and _EJ0 is also declared for the slot then nobody is going to set
> > > current_state = PCI_D0 for this device.  This is what I think it is
> > > happening:
> > > 
> > > 
> > > pci_enable_device
> > >     |
> > > __pci_enable_device_flags
> > > /* here we do not set current_state because !pm_cap */
> > >     |
> > > do_pci_enable_device
> > >     |
> > > pci_set_power_state
> > >     |
> > > __pci_start_power_transition
> > >     |
> > > pci_platform_power_transition
> > > /* platform_pci_power_manageable() calls acpi_pci_power_manageable that
> > >  * returns true */
> > >     |
> > > platform_pci_set_power_state
> > > /* acpi_pci_set_power_state gets called and does nothing because the
> > >  * acpi device has _EJ0, see the comment "If the ACPI device has _EJ0,
> > >  * ignore the device" */
> > > 
> > > 
> > > at this point if we refer to the commit message that introduced the
> > > comment above (10b3dcae0f275e2546e55303d64ddbb58cec7599), it is up to
> > > the hotplug driver to set the state to D0.
> > > However AFAICT the pci hotplug driver never does, in fact
> > > drivers/pci/hotplug/acpiphp_glue.c:register_slot sets the slot flags to
> > > (SLOT_ENABLED | SLOT_POWEREDON) but it does not set the pci device
> > > current state to PCI_D0.
> > > 
> > > So my proposed fix is also to set current_state = PCI_D0 in
> > > register_slot.
> > > Comments are very welcome.
> > > 
> > > 
> > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > 
> > Yeah, looks fine.  ACPIPHP is happy for the attention. :)
> 
> This helps for coldplug of devices which lack the PCI CFG space power
> management capability but doesn't help with hotplugging such devices.
> 
> Is it fair to assume that any PCI device in a slot which has just been
> powered on will be in D0?
> 
> e.g. Stefano's patch plus the following seem to fix the crashes I've
> been having with 82599 VFs for both hot and cold plug.
> 
> Ian.
> 
> acpiphp: set each new function to state D0 after powering on a slot.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>

That version did it too soon and/or to devices which were already known.
I think this one is more like it:

8<------

>From 5cb5d576e7177762abe29cfba3f616c48e619145 Mon Sep 17 00:00:00 2001
From: Ian Campbell <ian.campbell@citrix.com>
Date: Tue, 8 Mar 2011 16:16:34 +0000
Subject: [PATCH] acpiphp: assume device is in state D0 after powering on a slot.

Devices which do not support PCI configuration space based power
management may not otherwise be enabled.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index e610cfe..a502fef 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -827,6 +827,13 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 	acpiphp_set_hpp_values(bus);
 	acpiphp_set_acpi_region(slot);
 	pci_enable_bridges(bus);
+
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		/* Assume that newly added devices are powered on already. */
+		if (!dev->is_added)
+			dev->current_state = PCI_D0;
+	}
+
 	pci_bus_add_devices(bus);
 
 	list_for_each_entry(func, &slot->funcs, sibling) {
-- 
1.5.6.5



-- 
Ian Campbell
Current Noise: Behemoth - Daimonos

Unix is a Registered Bell of AT&T Trademark Laboratories.
		-- Donn Seeley

