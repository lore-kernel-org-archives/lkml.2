Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab2EaAka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 20:40:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:60367 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756318Ab2EaAk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 20:40:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="158925188"
Message-ID: <1338424825.6824.18.camel@yhuang-dev>
Subject: Re: [PATCH -v4 2/2] PCIe: Add PCIe runtime D3cold support
From: Huang Ying <ying.huang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>
Date: Thu, 31 May 2012 08:40:25 +0800
In-Reply-To: <201205302349.30989.rjw@sisk.pl>
References: <1337305725-10482-1-git-send-email-ying.huang@intel.com>
	 <1337305725-10482-3-git-send-email-ying.huang@intel.com>
	 <201205220011.31283.rjw@sisk.pl> <201205302349.30989.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 23:49 +0200, Rafael J. Wysocki wrote:
> On Tuesday, May 22, 2012, Rafael J. Wysocki wrote:
> > On Friday, May 18, 2012, Huang Ying wrote:
> > > This patch adds runtime D3cold support to PCIe bus.  D3cold is the
> > > deepest power saving state for PCIe devices.  Where the main PCIe link
> > > will be powered off totally, so before the PCIe main link is powered
> > > on again, you can not access the device, even the configuration space,
> > > which is still accessible in D3hot.  Because the main PCIe link is not
> > > available, the PCI PM registers can not be used to put device into/out
> > > of D3cold state, that will be done by platform logic such as ACPI
> > > _PR3.
> > > 
> > > To support remote wake up in D3cold, aux power is supplied, and a
> > > side-band pin: WAKE# is used to notify remote wake up event, the pin
> > > is usually connected to platform logic such as ACPI GPE.  This is
> > > quite different with other power saving states, where remote wake up
> > > is notified via PME message through the PCIe main link.
> > > 
> > > PCIe devices in plug-in slot usually has no direct platform logic, for
> > > example, there is usually no ACPI _PR3 for them.  The D3cold support
> > > for these devices can be done via the PCIe port connected to it.  When
> > > power on/off the PCIe port, the corresponding PCIe devices are powered
> > > on/off too.  And the remote wake up event from PCIe device will be
> > > notified to the corresponding PCIe port.
> > > 
> > > The PCI subsystem D3cold support and corresponding ACPI platform
> > > support is implemented in the patch.  Including the support for PCIe
> > > devices in plug-in slot.
> > > 
> > > For more information about PCIe D3cold and corresponding ACPI support,
> > > please refer to:
> > > 
> > > - PCI Express Base Specification Revision 2.0
> > > - Advanced Configuration and Power Interface Specification Revision 5.0
> > > 
> > > Originally-by: Zheng Yan <zheng.z.yan@intel.com>
> > > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > 
> > Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> On a second thought ...
> 
> > > ---
> > >  drivers/pci/pci-acpi.c         |   23 +++++++-
> > >  drivers/pci/pci-driver.c       |    3 +
> > >  drivers/pci/pci-sysfs.c        |   29 ++++++++++
> > >  drivers/pci/pci.c              |  110 +++++++++++++++++++++++++++++++++++++----
> > >  drivers/pci/pci.h              |    1 
> > >  drivers/pci/pcie/portdrv_pci.c |   44 ++++++++++++++--
> > >  include/linux/pci.h            |   16 ++++-
> > >  7 files changed, 205 insertions(+), 21 deletions(-)
> > > 
> > > --- a/drivers/pci/pci-acpi.c
> > > +++ b/drivers/pci/pci-acpi.c
> > > @@ -48,6 +48,12 @@ static void pci_acpi_wake_dev(acpi_handl
> > >  	if (event != ACPI_NOTIFY_DEVICE_WAKE || !pci_dev)
> > >  		return;
> > >  
> > > +	if (pci_dev->current_state == PCI_D3cold) {
> > > +		pci_wakeup_event(pci_dev);
> > > +		pm_runtime_resume(&pci_dev->dev);
> > > +		return;
> > > +	}
> > > +
> > >  	if (!pci_dev->pm_cap || !pci_dev->pme_support
> > >  	     || pci_check_pme_status(pci_dev)) {
> > >  		if (pci_dev->pme_poll)
> > > @@ -187,10 +193,13 @@ acpi_status pci_acpi_remove_pm_notifier(
> > >  
> > >  static pci_power_t acpi_pci_choose_state(struct pci_dev *pdev)
> > >  {
> > > -	int acpi_state;
> > > +	int acpi_state, d_max;
> > >  
> > > -	acpi_state = acpi_pm_device_sleep_state(&pdev->dev, NULL,
> > > -						ACPI_STATE_D3);
> 
> I wonder what tree this patch is against?  The code above doesn't seem to
> be present in the current mainline.

As stated in [PATCH -v4 0/2], This patchset is based on:

[PATCH -v2] ACPI, PM, Specify lowest allowed state for device sleep
state

Which is sent to LKML separately.

Best Regards,
Huang Ying


