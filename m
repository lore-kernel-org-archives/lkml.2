Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568Ab2EaS4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 14:56:34 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:46900 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932479Ab2EaS4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 14:56:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH -v4 2/2] PCIe: Add PCIe runtime D3cold support
Date: Thu, 31 May 2012 21:01:39 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0+; KDE/4.6.0; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>
References: <1337305725-10482-1-git-send-email-ying.huang@intel.com> <201205302349.30989.rjw@sisk.pl> <1338424825.6824.18.camel@yhuang-dev>
In-Reply-To: <1338424825.6824.18.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205312101.39919.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 31, 2012, Huang Ying wrote:
> On Wed, 2012-05-30 at 23:49 +0200, Rafael J. Wysocki wrote:
> > On Tuesday, May 22, 2012, Rafael J. Wysocki wrote:
> > > On Friday, May 18, 2012, Huang Ying wrote:
> > > > This patch adds runtime D3cold support to PCIe bus.  D3cold is the
> > > > deepest power saving state for PCIe devices.  Where the main PCIe link
> > > > will be powered off totally, so before the PCIe main link is powered
> > > > on again, you can not access the device, even the configuration space,
> > > > which is still accessible in D3hot.  Because the main PCIe link is not
> > > > available, the PCI PM registers can not be used to put device into/out
> > > > of D3cold state, that will be done by platform logic such as ACPI
> > > > _PR3.
> > > > 
> > > > To support remote wake up in D3cold, aux power is supplied, and a
> > > > side-band pin: WAKE# is used to notify remote wake up event, the pin
> > > > is usually connected to platform logic such as ACPI GPE.  This is
> > > > quite different with other power saving states, where remote wake up
> > > > is notified via PME message through the PCIe main link.
> > > > 
> > > > PCIe devices in plug-in slot usually has no direct platform logic, for
> > > > example, there is usually no ACPI _PR3 for them.  The D3cold support
> > > > for these devices can be done via the PCIe port connected to it.  When
> > > > power on/off the PCIe port, the corresponding PCIe devices are powered
> > > > on/off too.  And the remote wake up event from PCIe device will be
> > > > notified to the corresponding PCIe port.
> > > > 
> > > > The PCI subsystem D3cold support and corresponding ACPI platform
> > > > support is implemented in the patch.  Including the support for PCIe
> > > > devices in plug-in slot.
> > > > 
> > > > For more information about PCIe D3cold and corresponding ACPI support,
> > > > please refer to:
> > > > 
> > > > - PCI Express Base Specification Revision 2.0
> > > > - Advanced Configuration and Power Interface Specification Revision 5.0
> > > > 
> > > > Originally-by: Zheng Yan <zheng.z.yan@intel.com>
> > > > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > > 
> > > Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > On a second thought ...
> > 
> > > > ---
> > > >  drivers/pci/pci-acpi.c         |   23 +++++++-
> > > >  drivers/pci/pci-driver.c       |    3 +
> > > >  drivers/pci/pci-sysfs.c        |   29 ++++++++++
> > > >  drivers/pci/pci.c              |  110 +++++++++++++++++++++++++++++++++++++----
> > > >  drivers/pci/pci.h              |    1 
> > > >  drivers/pci/pcie/portdrv_pci.c |   44 ++++++++++++++--
> > > >  include/linux/pci.h            |   16 ++++-
> > > >  7 files changed, 205 insertions(+), 21 deletions(-)
> > > > 
> > > > --- a/drivers/pci/pci-acpi.c
> > > > +++ b/drivers/pci/pci-acpi.c
> > > > @@ -48,6 +48,12 @@ static void pci_acpi_wake_dev(acpi_handl
> > > >  	if (event != ACPI_NOTIFY_DEVICE_WAKE || !pci_dev)
> > > >  		return;
> > > >  
> > > > +	if (pci_dev->current_state == PCI_D3cold) {
> > > > +		pci_wakeup_event(pci_dev);
> > > > +		pm_runtime_resume(&pci_dev->dev);
> > > > +		return;
> > > > +	}
> > > > +
> > > >  	if (!pci_dev->pm_cap || !pci_dev->pme_support
> > > >  	     || pci_check_pme_status(pci_dev)) {
> > > >  		if (pci_dev->pme_poll)
> > > > @@ -187,10 +193,13 @@ acpi_status pci_acpi_remove_pm_notifier(
> > > >  
> > > >  static pci_power_t acpi_pci_choose_state(struct pci_dev *pdev)
> > > >  {
> > > > -	int acpi_state;
> > > > +	int acpi_state, d_max;
> > > >  
> > > > -	acpi_state = acpi_pm_device_sleep_state(&pdev->dev, NULL,
> > > > -						ACPI_STATE_D3);
> > 
> > I wonder what tree this patch is against?  The code above doesn't seem to
> > be present in the current mainline.
> 
> As stated in [PATCH -v4 0/2], This patchset is based on:
> 
> [PATCH -v2] ACPI, PM, Specify lowest allowed state for device sleep
> state
> 
> Which is sent to LKML separately.

I see.

Can you post the latest version of that patch, please?

Besides, this hunk of the $subject patch:

> @@ -731,8 +791,8 @@ int pci_set_power_state(struct pci_dev *
>       int error;
>  
>       /* bound the state we're entering */
> -     if (state > PCI_D3hot)
> -             state = PCI_D3hot;
> +     if (state > PCI_D3cold)
> +             state = PCI_D3cold;
>       else if (state < PCI_D0)
>               state = PCI_D0;
>       else if ((state == PCI_D1 || state == PCI_D2) && pci_no_d1d2(dev))
> @@ -747,10 +807,15 @@ int pci_set_power_state(struct pci_dev *
>  
>       /* This device is quirked not to be put into D3, so
>          don't put it in D3 */
> -     if (state == PCI_D3hot && (dev->dev_flags & PCI_DEV_FLAGS_NO_D3))
> +     if (state >= PCI_D3hot && (dev->dev_flags & PCI_DEV_FLAGS_NO_D3))
>               return 0;
>  
> -     error = pci_raw_set_power_state(dev, state);
> +     /*
> +      * To put device in D3cold, we put device into D3hot in native
> +      * way, then put device into D3cold with platform ops
> +      */
> +     error = pci_raw_set_power_state(dev, state > PCI_D3hot ?
> +                                     PCI_D3hot : state);
>  
>       if (!__pci_complete_power_transition(dev, state))
>               error = 0;

should be merged separately, because it will affect suspend/hibernation code
paths.  Namely, it will change the behavior in such a way that some devices
put into D3hot previously will be put into D3cold now during system suspend.

Thanks,
Rafael
