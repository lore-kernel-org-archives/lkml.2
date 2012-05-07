Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab2EGVSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 17:18:06 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:58038 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932162Ab2EGVSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 17:18:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: huang ying <huang.ying.caritas@gmail.com>
Subject: Re: [RFC v2 5/5] PCIe, Add PCIe runtime D3cold support
Date: Mon, 7 May 2012 23:22:51 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Huang Ying <ying.huang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Zheng Yan <zheng.z.yan@intel.com>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com> <201205042250.39519.rjw@sisk.pl> <CAC=cRTP3ZOy1BkvtEZgZ4wfTzaMB8fdZhU_6VOKRwVQ8WLLxJg@mail.gmail.com>
In-Reply-To: <CAC=cRTP3ZOy1BkvtEZgZ4wfTzaMB8fdZhU_6VOKRwVQ8WLLxJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205072322.51322.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 05, 2012, huang ying wrote:
> On Sat, May 5, 2012 at 4:50 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, May 04, 2012, Huang Ying wrote:
> >> This patch adds runtime D3cold support to PCIe bus.  D3cold is the
> >> deepest power saving state for PCIe devices.  Where the main PCIe link
> >> will be powered off totally, so before the PCIe main link is powered
> >> on again, you can not access the device, even the configuration space,
> >> which is still accessible in D3hot.  Because the main PCIe link is not
> >> available, the PCI PM registers can not be used to put device into/out
> >> of D3cold state, that will be done by platform logic such as ACPI
> >> _PR3.
> >>
> >> To support remote wake up in D3cold, aux power is supplied, and a
> >> side-band pin: WAKE# is used to notify remote wake up event, the pin
> >> is usually connected to platform logic such as ACPI GPE.  This is
> >> quite different with other power saving states, where remote wake up
> >> is notified via PME message via the PCIe main link.
> >>
> >> PCIe devices in plug-in slot usually has no direct platform logic, for
> >> example, there is usually no ACPI _PR3 for them.  The D3cold support
> >> for these devices can be done via the PCIe port connected to it.  When
> >> power on/off the PCIe port, the corresponding PCIe devices are powered
> >> on/off too.  And the remote wake up event from PCIe device will be
> >> notified to the corresponding PCIe port.
> >>
> >> The PCI subsystem D3cold support and corresponding ACPI platform
> >> support is implemented in the patch.  Including the support for PCIe
> >> devices in plug-in slot.
> >>
> >> For more information about PCIe D3cold and corresponding ACPI support,
> >> please refer to:
> >>
> >> - PCI Express Base Specification Revision 2.0
> >> - Advanced Configuration and Power Interface Specification Revision 5.0
> >>
> >> Originally-by: Zheng Yan <zheng.z.yan@intel.com>
> >> Signed-off-by: Huang Ying <ying.huang@intel.com>
> >> ---
> >>  drivers/pci/pci-acpi.c         |   32 +++++++++--
> >>  drivers/pci/pci-driver.c       |    3 +
> >>  drivers/pci/pci.c              |  115 +++++++++++++++++++++++++++++++++++++----
> >>  drivers/pci/pci.h              |    1
> >>  drivers/pci/pcie/portdrv_pci.c |   28 +++++++++
> >>  include/linux/pci.h            |   12 +++-
> >>  6 files changed, 175 insertions(+), 16 deletions(-)
> >>
> >> --- a/drivers/pci/pci-acpi.c
> >> +++ b/drivers/pci/pci-acpi.c
> >> @@ -48,6 +48,21 @@ static void pci_acpi_wake_dev(acpi_handl
> >>       if (event != ACPI_NOTIFY_DEVICE_WAKE || !pci_dev)
> >>               return;
> >>
> >> +     if (pci_dev->current_state == PCI_D3cold) {
> >> +             unsigned int count = 0;
> >> +
> >> +             /*
> >> +              * Powering on bridge need to resume whole hierarchy,
> >> +              * just resume the children to avoid the bridge going
> >> +              * suspending as soon as resumed
> >> +              */
> >
> > Don't you need to resume the bridge before you start walking the hierarchy
> > below it?
> 
> When we resume the hierarchy below the bridge, its parent, the bridge,
> will be resumed firstly. That is:
> 
> rpm_resume(child)
>   rpm_resume(parent)
>   ->runtime_suspend(child)
> 
> >> +             if (pci_dev->subordinate)
> >> +                     count = pci_wakeup_bus(pci_dev->subordinate);
> >> +             if (count == 0)
> >> +                     pm_runtime_resume(&pci_dev->dev);
> >
> > What's the count for, exactly?
> 
> If there is no devices under the bridge, count returned will be 0,
> then we will resume bridge itself.

So it looks like you will resume the bridge in both cases, right?

Why don't you call pm_runtime_get_sync() on the bridge first and then
go for resuming the devices below it, then?

[...]
> >>  static int pcie_port_runtime_suspend(struct device *dev)
> >>  {
> >>       struct pci_dev *pdev = to_pci_dev(dev);
> >> +     struct d3cold_info d3cold_info = {
> >> +             .power_must_be_on       = dev->power.power_must_be_on,
> >> +             .d3cold_delay           = PCI_PM_D3_WAIT,
> >> +     };
> >>
> >> +     /*
> >> +      * If any subordinate device need to keep power on, we should
> >> +      * not power off the port.  The D3cold delay of port should be
> >> +      * the max of that of all subordinate devices.
> >
> > What if some of the devices below the port are ports themselves?  Or PCI-to-PCIe
> > bridges?
> 
> For them, I think the current solution is safe.

Hmm.  Shouldn't the total delay be a sum rather than a max in those cases?

Rafael
