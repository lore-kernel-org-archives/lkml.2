Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751Ab2FACDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 22:03:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:1930 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620Ab2FACD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 22:03:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="151134218"
Message-ID: <1338516207.6824.34.camel@yhuang-dev>
Subject: Re: [PATCH -v4 2/2] PCIe: Add PCIe runtime D3cold support
From: Huang Ying <ying.huang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>
Date: Fri, 01 Jun 2012 10:03:27 +0800
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

Sorry if you received duplicated email.  Forget to copy all people.

Here is the patch that this patchset is based on,

Subject: [PATCH -v2] ACPI, PM, Specify lowest allowed state for device sleep state

Lower device sleep state can save more power, but has more exit
latency too.  Sometimes, to satisfy some power QoS and other
requirement, we need to constrain the lowest device sleep state.

In this patch, a parameter to specify lowest allowed state for
acpi_pm_device_sleep_state is added.  So that the caller can enforce
the constraint via the parameter.

This is needed by PCIe D3cold support, where the lowest power state
allowed may be D3_HOT instead of default D3_COLD.

Changelog:

v2:
- Minor change per Rafeal's comments

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/sleep.c       |   24 +++++++++++++++++++-----
 drivers/pci/pci-acpi.c     |    3 ++-
 drivers/pnp/pnpacpi/core.c |    4 ++--
 include/acpi/acpi_bus.h    |    6 +++---
 4 files changed, 26 insertions(+), 11 deletions(-)

--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -677,8 +677,9 @@ int acpi_suspend(u32 acpi_state)
  *	@dev: device to examine; its driver model wakeup flags control
  *		whether it should be able to wake up the system
  *	@d_min_p: used to store the upper limit of allowed states range
- *	Return value: preferred power state of the device on success, -ENODEV on
- *		failure (ie. if there's no 'struct acpi_device' for @dev)
+ *	@d_max_in: specify the lowest allowed states
+ *	Return value: preferred power state of the device on success, -ENODEV
+ *	(ie. if there's no 'struct acpi_device' for @dev) or -EINVAL on failure
  *
  *	Find the lowest power (highest number) ACPI device power state that
  *	device @dev can be in while the system is in the sleep state represented
@@ -693,13 +694,15 @@ int acpi_suspend(u32 acpi_state)
  *	via @wake.
  */
 
-int acpi_pm_device_sleep_state(struct device *dev, int *d_min_p)
+int acpi_pm_device_sleep_state(struct device *dev, int *d_min_p, int d_max_in)
 {
 	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);
 	struct acpi_device *adev;
 	char acpi_method[] = "_SxD";
 	unsigned long long d_min, d_max;
 
+	if (d_max_in < ACPI_STATE_D0 || d_max_in > ACPI_STATE_D3)
+		return -EINVAL;
 	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &adev))) {
 		printk(KERN_DEBUG "ACPI handle has no context!\n");
 		return -ENODEV;
@@ -707,8 +710,10 @@ int acpi_pm_device_sleep_state(struct de
 
 	acpi_method[2] = '0' + acpi_target_sleep_state;
 	/*
-	 * If the sleep state is S0, we will return D3, but if the device has
-	 * _S0W, we will use the value from _S0W
+	 * If the sleep state is S0, the lowest limit from ACPI is D3,
+	 * but if the device has _S0W, we will use the value from _S0W
+	 * as the lowest limit from ACPI.  Finally, we will constrain
+	 * the lowest limit with the specified one.
 	 */
 	d_min = ACPI_STATE_D0;
 	d_max = ACPI_STATE_D3;
@@ -752,8 +757,17 @@ int acpi_pm_device_sleep_state(struct de
 		}
 	}
 
+	if (d_max_in < d_min)
+		return -EINVAL;
 	if (d_min_p)
 		*d_min_p = d_min;
+	/* constrain d_max with specified lowest limit (max number) */
+	if (d_max > d_max_in) {
+		for (d_max = d_max_in; d_max > d_min; d_max--) {
+			if (adev->power.states[d_max].flags.valid)
+				break;
+		}
+	}
 	return d_max;
 }
 #endif /* CONFIG_PM */
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -189,7 +189,8 @@ static pci_power_t acpi_pci_choose_state
 {
 	int acpi_state;
 
-	acpi_state = acpi_pm_device_sleep_state(&pdev->dev, NULL);
+	acpi_state = acpi_pm_device_sleep_state(&pdev->dev, NULL,
+						ACPI_STATE_D3);
 	if (acpi_state < 0)
 		return PCI_POWER_ERROR;
 
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -170,8 +170,8 @@ static int pnpacpi_suspend(struct pnp_de
 	}
 
 	if (acpi_bus_power_manageable(handle)) {
-		int power_state = acpi_pm_device_sleep_state(&dev->dev, NULL);
-
+		int power_state = acpi_pm_device_sleep_state(&dev->dev, NULL,
+							     ACPI_STATE_D3);
 		if (power_state < 0)
 			power_state = (state.event == PM_EVENT_ON) ?
 					ACPI_STATE_D0 : ACPI_STATE_D3;
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -383,13 +383,13 @@ int acpi_enable_wakeup_device_power(stru
 int acpi_disable_wakeup_device_power(struct acpi_device *dev);
 
 #ifdef CONFIG_PM
-int acpi_pm_device_sleep_state(struct device *, int *);
+int acpi_pm_device_sleep_state(struct device *, int *, int);
 #else
-static inline int acpi_pm_device_sleep_state(struct device *d, int *p)
+static inline int acpi_pm_device_sleep_state(struct device *d, int *p, int m)
 {
 	if (p)
 		*p = ACPI_STATE_D0;
-	return ACPI_STATE_D3;
+	return (m >= ACPI_STATE_D0 && <= ACPI_STATE_D3) ? m : ACPI_STATE_D0;
 }
 #endif
 


