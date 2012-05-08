Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab2EHCW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 22:22:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:18463 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756778Ab2EHCWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 22:22:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163196556"
Message-ID: <1336443743.6190.159.camel@yhuang-dev>
Subject: Re: [RFC v2 5/5] PCIe, Add PCIe runtime D3cold support
From: Huang Ying <ying.huang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: huang ying <huang.ying.caritas@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>
Date: Tue, 08 May 2012 10:22:23 +0800
In-Reply-To: <201205072322.51322.rjw@sisk.pl>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com>
	 <201205042250.39519.rjw@sisk.pl>
	 <CAC=cRTP3ZOy1BkvtEZgZ4wfTzaMB8fdZhU_6VOKRwVQ8WLLxJg@mail.gmail.com>
	 <201205072322.51322.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 23:22 +0200, Rafael J. Wysocki wrote:
> On Saturday, May 05, 2012, huang ying wrote:
> > On Sat, May 5, 2012 at 4:50 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > On Friday, May 04, 2012, Huang Ying wrote:
> > >> This patch adds runtime D3cold support to PCIe bus.  D3cold is the
> > >> deepest power saving state for PCIe devices.  Where the main PCIe link
> > >> will be powered off totally, so before the PCIe main link is powered
> > >> on again, you can not access the device, even the configuration space,
> > >> which is still accessible in D3hot.  Because the main PCIe link is not
> > >> available, the PCI PM registers can not be used to put device into/out
> > >> of D3cold state, that will be done by platform logic such as ACPI
> > >> _PR3.
> > >>
> > >> To support remote wake up in D3cold, aux power is supplied, and a
> > >> side-band pin: WAKE# is used to notify remote wake up event, the pin
> > >> is usually connected to platform logic such as ACPI GPE.  This is
> > >> quite different with other power saving states, where remote wake up
> > >> is notified via PME message via the PCIe main link.
> > >>
> > >> PCIe devices in plug-in slot usually has no direct platform logic, for
> > >> example, there is usually no ACPI _PR3 for them.  The D3cold support
> > >> for these devices can be done via the PCIe port connected to it.  When
> > >> power on/off the PCIe port, the corresponding PCIe devices are powered
> > >> on/off too.  And the remote wake up event from PCIe device will be
> > >> notified to the corresponding PCIe port.
> > >>
> > >> The PCI subsystem D3cold support and corresponding ACPI platform
> > >> support is implemented in the patch.  Including the support for PCIe
> > >> devices in plug-in slot.
> > >>
> > >> For more information about PCIe D3cold and corresponding ACPI support,
> > >> please refer to:
> > >>
> > >> - PCI Express Base Specification Revision 2.0
> > >> - Advanced Configuration and Power Interface Specification Revision 5.0
> > >>
> > >> Originally-by: Zheng Yan <zheng.z.yan@intel.com>
> > >> Signed-off-by: Huang Ying <ying.huang@intel.com>
> > >> ---
> > >>  drivers/pci/pci-acpi.c         |   32 +++++++++--
> > >>  drivers/pci/pci-driver.c       |    3 +
> > >>  drivers/pci/pci.c              |  115 +++++++++++++++++++++++++++++++++++++----
> > >>  drivers/pci/pci.h              |    1
> > >>  drivers/pci/pcie/portdrv_pci.c |   28 +++++++++
> > >>  include/linux/pci.h            |   12 +++-
> > >>  6 files changed, 175 insertions(+), 16 deletions(-)
> > >>
> > >> --- a/drivers/pci/pci-acpi.c
> > >> +++ b/drivers/pci/pci-acpi.c
> > >> @@ -48,6 +48,21 @@ static void pci_acpi_wake_dev(acpi_handl
> > >>       if (event != ACPI_NOTIFY_DEVICE_WAKE || !pci_dev)
> > >>               return;
> > >>
> > >> +     if (pci_dev->current_state == PCI_D3cold) {
> > >> +             unsigned int count = 0;
> > >> +
> > >> +             /*
> > >> +              * Powering on bridge need to resume whole hierarchy,
> > >> +              * just resume the children to avoid the bridge going
> > >> +              * suspending as soon as resumed
> > >> +              */
> > >
> > > Don't you need to resume the bridge before you start walking the hierarchy
> > > below it?
> > 
> > When we resume the hierarchy below the bridge, its parent, the bridge,
> > will be resumed firstly. That is:
> > 
> > rpm_resume(child)
> >   rpm_resume(parent)
> >   ->runtime_suspend(child)
> > 
> > >> +             if (pci_dev->subordinate)
> > >> +                     count = pci_wakeup_bus(pci_dev->subordinate);
> > >> +             if (count == 0)
> > >> +                     pm_runtime_resume(&pci_dev->dev);
> > >
> > > What's the count for, exactly?
> > 
> > If there is no devices under the bridge, count returned will be 0,
> > then we will resume bridge itself.
> 
> So it looks like you will resume the bridge in both cases, right?
> 
> Why don't you call pm_runtime_get_sync() on the bridge first and then
> go for resuming the devices below it, then?

OK.  I will do that.

> [...]
> > >>  static int pcie_port_runtime_suspend(struct device *dev)
> > >>  {
> > >>       struct pci_dev *pdev = to_pci_dev(dev);
> > >> +     struct d3cold_info d3cold_info = {
> > >> +             .power_must_be_on       = dev->power.power_must_be_on,
> > >> +             .d3cold_delay           = PCI_PM_D3_WAIT,
> > >> +     };
> > >>
> > >> +     /*
> > >> +      * If any subordinate device need to keep power on, we should
> > >> +      * not power off the port.  The D3cold delay of port should be
> > >> +      * the max of that of all subordinate devices.
> > >
> > > What if some of the devices below the port are ports themselves?  Or PCI-to-PCIe
> > > bridges?
> > 
> > For them, I think the current solution is safe.
> 
> Hmm.  Shouldn't the total delay be a sum rather than a max in those cases?

I think the max is sufficient here.  The delay is used to wait devices
to complete the power on reset after applying the power to them. There
are two possibility.

- Power is applied to all devices (including PCIe port) below altogether
  - We just need wait the max delay

- Power is applied to devices other than PCIe port altogether, for
example, for hierarchy below:

 * rp1
   * dev1
   * rp2
     - dev2
     - dev3

When rp1 is resumed, rp1, dev1 will be applied power.  And when resuming
rp2, rp2, dev2 and dev3 will be applied power.  Here the delay for rp2,
dev2 and dev3 will be sum of delays automatically.

Best Regards,
Huang Ying


