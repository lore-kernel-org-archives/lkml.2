Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab2KZB0B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 20:26:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:53226 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208Ab2KZB0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 20:26:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,317,1352102400"; 
   d="scan'208";a="246989286"
Message-ID: <1353893156.28789.86.camel@yhuang-dev>
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
Date: Mon, 26 Nov 2012 09:25:56 +0800
In-Reply-To: <4855631.a4dcc0Gn36@vostro.rjw.lan>
References: <1672179.qgDUs0YdYu@vostro.rjw.lan>
	 <4238031.sDhWdlxYNQ@vostro.rjw.lan> <1353892047.28789.82.camel@yhuang-dev>
	 <4855631.a4dcc0Gn36@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-26 at 02:16 +0100, Rafael J. Wysocki wrote:
> On Monday, November 26, 2012 09:07:27 AM Huang Ying wrote:
> > On Mon, 2012-11-26 at 02:00 +0100, Rafael J. Wysocki wrote:
> > > On Monday, November 26, 2012 08:43:10 AM Huang Ying wrote:
> > > > On Sun, 2012-11-25 at 15:55 +0100, Rafael J. Wysocki wrote:
> > > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > 
> > > > > Make it possible to ask the routines used for adding/removing devices
> > > > > to/from the general ACPI PM domain, acpi_dev_pm_attach() and
> > > > > acpi_dev_pm_detach(), respectively, to change the power states of
> > > > > devices so that they are put into the full-power state automatically
> > > > > by acpi_dev_pm_attach() and into the lowest-power state available
> > > > > automatically by acpi_dev_pm_detach().
> > > > > 
> > > > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > ---
> > > > >  drivers/acpi/device_pm.c |   28 ++++++++++++++++++++++++----
> > > > >  include/linux/acpi.h     |   11 +++++++----
> > > > >  2 files changed, 31 insertions(+), 8 deletions(-)
> > > > > 
> > > > > Index: linux/drivers/acpi/device_pm.c
> > > > > ===================================================================
> > > > > --- linux.orig/drivers/acpi/device_pm.c
> > > > > +++ linux/drivers/acpi/device_pm.c
> > > > > @@ -599,10 +599,12 @@ static struct dev_pm_domain acpi_general
> > > > >  /**
> > > > >   * acpi_dev_pm_attach - Prepare device for ACPI power management.
> > > > >   * @dev: Device to prepare.
> > > > > + * @power_on: Whether or not to power on the device.
> > > > >   *
> > > > >   * If @dev has a valid ACPI handle that has a valid struct acpi_device object
> > > > >   * attached to it, install a wakeup notification handler for the device and
> > > > > - * add it to the general ACPI PM domain.
> > > > > + * add it to the general ACPI PM domain.  If @power_on is set, the device will
> > > > > + * be put into the ACPI D0 state before the function returns.
> > > > >   *
> > > > >   * This assumes that the @dev's bus type uses generic power management callbacks
> > > > >   * (or doesn't use any power management callbacks at all).
> > > > > @@ -610,7 +612,7 @@ static struct dev_pm_domain acpi_general
> > > > >   * Callers must ensure proper synchronization of this function with power
> > > > >   * management callbacks.
> > > > >   */
> > > > > -int acpi_dev_pm_attach(struct device *dev)
> > > > > +int acpi_dev_pm_attach(struct device *dev, bool power_on)
> > > > >  {
> > > > >  	struct acpi_device *adev = acpi_dev_pm_get_node(dev);
> > > > >  
> > > > > @@ -622,6 +624,10 @@ int acpi_dev_pm_attach(struct device *de
> > > > >  
> > > > >  	acpi_add_pm_notifier(adev, acpi_wakeup_device, dev);
> > > > >  	dev->pm_domain = &acpi_general_pm_domain;
> > > > > +	if (power_on) {
> > > > > +		acpi_dev_pm_full_power(adev);
> > > > > +		__acpi_device_run_wake(adev, false);
> > > > > +	}
> > > > >  	return 0;
> > > > >  }
> > > > >  EXPORT_SYMBOL_GPL(acpi_dev_pm_attach);
> > > > > @@ -629,20 +635,34 @@ EXPORT_SYMBOL_GPL(acpi_dev_pm_attach);
> > > > >  /**
> > > > >   * acpi_dev_pm_detach - Remove ACPI power management from the device.
> > > > >   * @dev: Device to take care of.
> > > > > + * @power_off: Whether or not to try to remove power from the device.
> > > > >   *
> > > > >   * Remove the device from the general ACPI PM domain and remove its wakeup
> > > > > - * notifier.
> > > > > + * notifier.  If @power_off is set, additionally remove power from the device if
> > > > > + * possible.
> > > > >   *
> > > > >   * Callers must ensure proper synchronization of this function with power
> > > > >   * management callbacks.
> > > > >   */
> > > > > -void acpi_dev_pm_detach(struct device *dev)
> > > > > +void acpi_dev_pm_detach(struct device *dev, bool power_off)
> > > > >  {
> > > > >  	struct acpi_device *adev = acpi_dev_pm_get_node(dev);
> > > > >  
> > > > >  	if (adev && dev->pm_domain == &acpi_general_pm_domain) {
> > > > >  		dev->pm_domain = NULL;
> > > > >  		acpi_remove_pm_notifier(adev, acpi_wakeup_device);
> > > > > +		if (power_off) {
> > > > > +			/*
> > > > > +			 * If the device's PM QoS resume latency limit or flags
> > > > > +			 * have been exposed to user space, they have to be
> > > > > +			 * hidden at this point, so that they don't affect the
> > > > > +			 * choice of the low-power state to put the device into.
> > > > > +			 */
> > > > > +			dev_pm_qos_hide_latency_limit(dev);
> > > > > +			dev_pm_qos_hide_flags(dev);
> > > > 
> > > > NO_POWER_OFF flag is ignored here.  Is it possible for some device (or
> > > > corresponding ACPI method) has broken D3cold implementation, so that the
> > > > user need a way to disable it?
> > > 
> > > We are removing the driver here and we haven't exposed the flags, have we?
> > 
> > IMHO, the flag may be exposed by the bus instead of device driver.
> > Because some bus can determine whether D3cold is supported by the
> > device.  If the sysfs file for the flag is exposed by the bus, user set
> > it and we silently ignore it, will it cause confusing for the user?
> 
> OK, put it in a different way: If the entity that calls acpi_dev_pm_attach()
> exposes the flags _before_ calling it, then acpi_dev_pm_detach() should not
> hide the flags.  Otherwise, it should hide them.  Currently, the only user
> of acpi_dev_pm_attach() (that will be the platform bus type) will not expose
> the flags before calling that routine, so it is OK for acpi_dev_pm_detach()
> to remove them.

Yes.  You are right.  Thanks for clarification.

Best Regards,
Huang Ying


