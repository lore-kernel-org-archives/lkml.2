Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766Ab2FACZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 22:25:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:9929 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310Ab2FACZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 22:25:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="159385845"
Message-ID: <1338517542.6824.44.camel@yhuang-dev>
Subject: Re: [PATCH -v4 2/2] PCIe: Add PCIe runtime D3cold support
From: Huang Ying <ying.huang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>
Date: Fri, 01 Jun 2012 10:25:42 +0800
In-Reply-To: <201205312101.39919.rjw@sisk.pl>
References: <1337305725-10482-1-git-send-email-ying.huang@intel.com>
	 <201205302349.30989.rjw@sisk.pl> <1338424825.6824.18.camel@yhuang-dev>
	 <201205312101.39919.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 21:01 +0200, Rafael J. Wysocki wrote:
> On Thursday, May 31, 2012, Huang Ying wrote:
> > On Wed, 2012-05-30 at 23:49 +0200, Rafael J. Wysocki wrote:
> > > On Tuesday, May 22, 2012, Rafael J. Wysocki wrote:
> > > > On Friday, May 18, 2012, Huang Ying wrote:
> > > > > This patch adds runtime D3cold support to PCIe bus.  D3cold is the
> > > > > deepest power saving state for PCIe devices.  Where the main PCIe link
> > > > > will be powered off totally, so before the PCIe main link is powered
> > > > > on again, you can not access the device, even the configuration space,
> > > > > which is still accessible in D3hot.  Because the main PCIe link is not
> > > > > available, the PCI PM registers can not be used to put device into/out
> > > > > of D3cold state, that will be done by platform logic such as ACPI
> > > > > _PR3.
> > > > > 
> > > > > To support remote wake up in D3cold, aux power is supplied, and a
> > > > > side-band pin: WAKE# is used to notify remote wake up event, the pin
> > > > > is usually connected to platform logic such as ACPI GPE.  This is
> > > > > quite different with other power saving states, where remote wake up
> > > > > is notified via PME message through the PCIe main link.
> > > > > 
> > > > > PCIe devices in plug-in slot usually has no direct platform logic, for
> > > > > example, there is usually no ACPI _PR3 for them.  The D3cold support
> > > > > for these devices can be done via the PCIe port connected to it.  When
> > > > > power on/off the PCIe port, the corresponding PCIe devices are powered
> > > > > on/off too.  And the remote wake up event from PCIe device will be
> > > > > notified to the corresponding PCIe port.
> > > > > 
> > > > > The PCI subsystem D3cold support and corresponding ACPI platform
> > > > > support is implemented in the patch.  Including the support for PCIe
> > > > > devices in plug-in slot.
> > > > > 
> > > > > For more information about PCIe D3cold and corresponding ACPI support,
> > > > > please refer to:
> > > > > 
> > > > > - PCI Express Base Specification Revision 2.0
> > > > > - Advanced Configuration and Power Interface Specification Revision 5.0
> > > > > 
> > > > > Originally-by: Zheng Yan <zheng.z.yan@intel.com>
> > > > > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > > > 
> > > > Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > On a second thought ...
> > > 
> > > > > ---
> > > > >  drivers/pci/pci-acpi.c         |   23 +++++++-
> > > > >  drivers/pci/pci-driver.c       |    3 +
> > > > >  drivers/pci/pci-sysfs.c        |   29 ++++++++++
> > > > >  drivers/pci/pci.c              |  110 +++++++++++++++++++++++++++++++++++++----
> > > > >  drivers/pci/pci.h              |    1 
> > > > >  drivers/pci/pcie/portdrv_pci.c |   44 ++++++++++++++--
> > > > >  include/linux/pci.h            |   16 ++++-
> > > > >  7 files changed, 205 insertions(+), 21 deletions(-)
> > > > > 
> > > > > --- a/drivers/pci/pci-acpi.c
> > > > > +++ b/drivers/pci/pci-acpi.c
> > > > > @@ -48,6 +48,12 @@ static void pci_acpi_wake_dev(acpi_handl
> > > > >  	if (event != ACPI_NOTIFY_DEVICE_WAKE || !pci_dev)
> > > > >  		return;
> > > > >  
> > > > > +	if (pci_dev->current_state == PCI_D3cold) {
> > > > > +		pci_wakeup_event(pci_dev);
> > > > > +		pm_runtime_resume(&pci_dev->dev);
> > > > > +		return;
> > > > > +	}
> > > > > +
> > > > >  	if (!pci_dev->pm_cap || !pci_dev->pme_support
> > > > >  	     || pci_check_pme_status(pci_dev)) {
> > > > >  		if (pci_dev->pme_poll)
> > > > > @@ -187,10 +193,13 @@ acpi_status pci_acpi_remove_pm_notifier(
> > > > >  
> > > > >  static pci_power_t acpi_pci_choose_state(struct pci_dev *pdev)
> > > > >  {
> > > > > -	int acpi_state;
> > > > > +	int acpi_state, d_max;
> > > > >  
> > > > > -	acpi_state = acpi_pm_device_sleep_state(&pdev->dev, NULL,
> > > > > -						ACPI_STATE_D3);
> > > 
> > > I wonder what tree this patch is against?  The code above doesn't seem to
> > > be present in the current mainline.
> > 
> > As stated in [PATCH -v4 0/2], This patchset is based on:
> > 
> > [PATCH -v2] ACPI, PM, Specify lowest allowed state for device sleep
> > state
> > 
> > Which is sent to LKML separately.
> 
> I see.
> 
> Can you post the latest version of that patch, please?
> 
> Besides, this hunk of the $subject patch:
> 
> > @@ -731,8 +791,8 @@ int pci_set_power_state(struct pci_dev *
> >       int error;
> >  
> >       /* bound the state we're entering */
> > -     if (state > PCI_D3hot)
> > -             state = PCI_D3hot;
> > +     if (state > PCI_D3cold)
> > +             state = PCI_D3cold;
> >       else if (state < PCI_D0)
> >               state = PCI_D0;
> >       else if ((state == PCI_D1 || state == PCI_D2) && pci_no_d1d2(dev))
> > @@ -747,10 +807,15 @@ int pci_set_power_state(struct pci_dev *
> >  
> >       /* This device is quirked not to be put into D3, so
> >          don't put it in D3 */
> > -     if (state == PCI_D3hot && (dev->dev_flags & PCI_DEV_FLAGS_NO_D3))
> > +     if (state >= PCI_D3hot && (dev->dev_flags & PCI_DEV_FLAGS_NO_D3))
> >               return 0;
> >  
> > -     error = pci_raw_set_power_state(dev, state);
> > +     /*
> > +      * To put device in D3cold, we put device into D3hot in native
> > +      * way, then put device into D3cold with platform ops
> > +      */
> > +     error = pci_raw_set_power_state(dev, state > PCI_D3hot ?
> > +                                     PCI_D3hot : state);
> >  
> >       if (!__pci_complete_power_transition(dev, state))
> >               error = 0;
> 
> should be merged separately, because it will affect suspend/hibernation code
> paths.  Namely, it will change the behavior in such a way that some devices
> put into D3hot previously will be put into D3cold now during system suspend.

Yes.  This patch enables both runtime D3cold and D3cold during system
suspend.  How about separate this patch into the following patches?

- Add d3cold disable logic, including flags: no_d3cold, d3cold_allowed,
runtime_d3cold, and disable runtime d3cold (because part of runtime
d3cold support will be enabled by system d3cold support).

- system d3cold support for PCIe port

- system d3cold support in PCI core

- runtime d3cold support for PCIe port

- runtime d3cold support in PCI core

Best Regards,
Huang Ying


