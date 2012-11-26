Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab2KZBHd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 20:07:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:39969 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767Ab2KZBHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 20:07:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,317,1352102400"; 
   d="scan'208";a="252337113"
Message-ID: <1353892047.28789.82.camel@yhuang-dev>
Subject: Re: [PATCH 1/2] ACPI / PM: Allow attach/detach routines to change
 device power states
From: Huang Ying <ying.huang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, "Svahn, Kai" <kai.svahn@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Lan, Tianyu" <tianyu.lan@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 26 Nov 2012 09:07:27 +0800
In-Reply-To: <4238031.sDhWdlxYNQ@vostro.rjw.lan>
References: <1672179.qgDUs0YdYu@vostro.rjw.lan>
	 <2576372.XKUY0b7gBl@vostro.rjw.lan> <1353890590.28789.68.camel@yhuang-dev>
	 <4238031.sDhWdlxYNQ@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-26 at 02:00 +0100, Rafael J. Wysocki wrote:
> On Monday, November 26, 2012 08:43:10 AM Huang Ying wrote:
> > On Sun, 2012-11-25 at 15:55 +0100, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > 
> > > Make it possible to ask the routines used for adding/removing devices
> > > to/from the general ACPI PM domain, acpi_dev_pm_attach() and
> > > acpi_dev_pm_detach(), respectively, to change the power states of
> > > devices so that they are put into the full-power state automatically
> > > by acpi_dev_pm_attach() and into the lowest-power state available
> > > automatically by acpi_dev_pm_detach().
> > > 
> > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > ---
> > >  drivers/acpi/device_pm.c |   28 ++++++++++++++++++++++++----
> > >  include/linux/acpi.h     |   11 +++++++----
> > >  2 files changed, 31 insertions(+), 8 deletions(-)
> > > 
> > > Index: linux/drivers/acpi/device_pm.c
> > > ===================================================================
> > > --- linux.orig/drivers/acpi/device_pm.c
> > > +++ linux/drivers/acpi/device_pm.c
> > > @@ -599,10 +599,12 @@ static struct dev_pm_domain acpi_general
> > >  /**
> > >   * acpi_dev_pm_attach - Prepare device for ACPI power management.
> > >   * @dev: Device to prepare.
> > > + * @power_on: Whether or not to power on the device.
> > >   *
> > >   * If @dev has a valid ACPI handle that has a valid struct acpi_device object
> > >   * attached to it, install a wakeup notification handler for the device and
> > > - * add it to the general ACPI PM domain.
> > > + * add it to the general ACPI PM domain.  If @power_on is set, the device will
> > > + * be put into the ACPI D0 state before the function returns.
> > >   *
> > >   * This assumes that the @dev's bus type uses generic power management callbacks
> > >   * (or doesn't use any power management callbacks at all).
> > > @@ -610,7 +612,7 @@ static struct dev_pm_domain acpi_general
> > >   * Callers must ensure proper synchronization of this function with power
> > >   * management callbacks.
> > >   */
> > > -int acpi_dev_pm_attach(struct device *dev)
> > > +int acpi_dev_pm_attach(struct device *dev, bool power_on)
> > >  {
> > >  	struct acpi_device *adev = acpi_dev_pm_get_node(dev);
> > >  
> > > @@ -622,6 +624,10 @@ int acpi_dev_pm_attach(struct device *de
> > >  
> > >  	acpi_add_pm_notifier(adev, acpi_wakeup_device, dev);
> > >  	dev->pm_domain = &acpi_general_pm_domain;
> > > +	if (power_on) {
> > > +		acpi_dev_pm_full_power(adev);
> > > +		__acpi_device_run_wake(adev, false);
> > > +	}
> > >  	return 0;
> > >  }
> > >  EXPORT_SYMBOL_GPL(acpi_dev_pm_attach);
> > > @@ -629,20 +635,34 @@ EXPORT_SYMBOL_GPL(acpi_dev_pm_attach);
> > >  /**
> > >   * acpi_dev_pm_detach - Remove ACPI power management from the device.
> > >   * @dev: Device to take care of.
> > > + * @power_off: Whether or not to try to remove power from the device.
> > >   *
> > >   * Remove the device from the general ACPI PM domain and remove its wakeup
> > > - * notifier.
> > > + * notifier.  If @power_off is set, additionally remove power from the device if
> > > + * possible.
> > >   *
> > >   * Callers must ensure proper synchronization of this function with power
> > >   * management callbacks.
> > >   */
> > > -void acpi_dev_pm_detach(struct device *dev)
> > > +void acpi_dev_pm_detach(struct device *dev, bool power_off)
> > >  {
> > >  	struct acpi_device *adev = acpi_dev_pm_get_node(dev);
> > >  
> > >  	if (adev && dev->pm_domain == &acpi_general_pm_domain) {
> > >  		dev->pm_domain = NULL;
> > >  		acpi_remove_pm_notifier(adev, acpi_wakeup_device);
> > > +		if (power_off) {
> > > +			/*
> > > +			 * If the device's PM QoS resume latency limit or flags
> > > +			 * have been exposed to user space, they have to be
> > > +			 * hidden at this point, so that they don't affect the
> > > +			 * choice of the low-power state to put the device into.
> > > +			 */
> > > +			dev_pm_qos_hide_latency_limit(dev);
> > > +			dev_pm_qos_hide_flags(dev);
> > 
> > NO_POWER_OFF flag is ignored here.  Is it possible for some device (or
> > corresponding ACPI method) has broken D3cold implementation, so that the
> > user need a way to disable it?
> 
> We are removing the driver here and we haven't exposed the flags, have we?

IMHO, the flag may be exposed by the bus instead of device driver.
Because some bus can determine whether D3cold is supported by the
device.  If the sysfs file for the flag is exposed by the bus, user set
it and we silently ignore it, will it cause confusing for the user?

Best Regards,
Huang Ying

> If the driver had exposed them and then left them behind, we need to clean up
> after it and that's why I added those two lines.
> 
> In the future we may decide that the flags need to be exposed by the core,
> because of the broken hardware, for example, before the driver's .probe()
> routine is run and in that case we obviously won't be removing them here any
> more.  For now, however, I think it's better to hide them here.
> 
> Thanks,
> Rafael
> 
> 


