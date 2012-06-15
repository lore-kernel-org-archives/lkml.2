Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab2FOVQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 17:16:03 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:44662 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab2FOVQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 17:16:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH -v5 3/3] PCIe, PM, Add PCIe runtime D3cold support
Date: Fri, 15 Jun 2012 23:21:16 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0+; KDE/4.6.0; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, Zheng Yan <zheng.z.yan@intel.com>
References: <1339382833-7928-1-git-send-email-ying.huang@intel.com> <1339382833-7928-4-git-send-email-ying.huang@intel.com>
In-Reply-To: <1339382833-7928-4-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201206152321.16913.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 11, 2012, Huang Ying wrote:
> This patch adds runtime D3cold support to PCIe bus.  D3cold is the
> deepest power saving state for PCIe devices.  Where the main PCIe link
> will be powered off totally, so before the PCIe main link is powered
> on again, you can not access the device, even the configuration space,
> which is still accessible in D3hot.  Because the main PCIe link is not
> available, the PCI PM registers can not be used to put device into/out
> of D3cold state, that will be done by platform logic such as ACPI
> _PR3.
> 
> To support remote wake up in D3cold, aux power is supplied, and a
> side-band pin: WAKE# is used to notify remote wake up event, the pin
> is usually connected to platform logic such as ACPI GPE.  This is
> quite different with other power saving states, where remote wake up
> is notified via PME message through the PCIe main link.
> 
> PCIe devices in plug-in slot usually has no direct platform logic, for
> example, there is usually no ACPI _PR3 for them.  The D3cold support
> for these devices can be done via the PCIe port connected to it.  When
> power on/off the PCIe port, the corresponding PCIe devices are powered
> on/off too.  And the remote wake up event from PCIe device will be
> notified to the corresponding PCIe port.
> 
> The PCI subsystem D3cold support and corresponding ACPI platform
> support is implemented in the patch.  Including the support for PCIe
> devices in plug-in slot.
> 
> For more information about PCIe D3cold and corresponding ACPI support,
> please refer to:
> 
> - PCI Express Base Specification Revision 2.0
> - Advanced Configuration and Power Interface Specification Revision 5.0
> 
> Originally-by: Zheng Yan <zheng.z.yan@intel.com>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
>  drivers/pci/pci-acpi.c         |   23 ++++++--
>  drivers/pci/pci-driver.c       |   10 +++
>  drivers/pci/pci-sysfs.c        |   29 ++++++++++
>  drivers/pci/pci.c              |  114 +++++++++++++++++++++++++++++++++++++----
>  drivers/pci/pci.h              |    1 
>  drivers/pci/pcie/portdrv_pci.c |   44 ++++++++++++++-
>  include/linux/pci.h            |   16 ++++-
>  7 files changed, 215 insertions(+), 22 deletions(-)
> 
> --- a/drivers/pci/pci-acpi.c
> +++ b/drivers/pci/pci-acpi.c
> @@ -48,6 +48,12 @@ static void pci_acpi_wake_dev(acpi_handl
>  	if (event != ACPI_NOTIFY_DEVICE_WAKE || !pci_dev)
>  		return;
>  
> +	if (pci_dev->current_state == PCI_D3cold) {
> +		pci_wakeup_event(pci_dev);
> +		pm_runtime_resume(&pci_dev->dev);
> +		return;
> +	}
> +
>  	if (!pci_dev->pm_cap || !pci_dev->pme_support
>  	     || pci_check_pme_status(pci_dev)) {
>  		if (pci_dev->pme_poll)
> @@ -187,10 +193,13 @@ acpi_status pci_acpi_remove_pm_notifier(
>  
>  static pci_power_t acpi_pci_choose_state(struct pci_dev *pdev)
>  {
> -	int acpi_state;
> +	int acpi_state, d_max;
>  
> -	acpi_state = acpi_pm_device_sleep_state(&pdev->dev, NULL,
> -						ACPI_STATE_D3);
> +	if (pdev->no_d3cold)
> +		d_max = ACPI_STATE_D3_HOT;
> +	else
> +		d_max = ACPI_STATE_D3_COLD;
> +	acpi_state = acpi_pm_device_sleep_state(&pdev->dev, NULL, d_max);
>  	if (acpi_state < 0)
>  		return PCI_POWER_ERROR;
>  
> @@ -297,7 +306,13 @@ static void acpi_pci_propagate_run_wake(
>  
>  static int acpi_pci_run_wake(struct pci_dev *dev, bool enable)
>  {
> -	if (dev->pme_interrupt)
> +	/*
> +	 * Per PCI Express Base Specification Revision 2.0 section
> +	 * 5.3.3.2 Link Wakeup, platform support is needed for D3cold
> +	 * waking up to power on the main link even if there is PME
> +	 * support for D3cold
> +	 */
> +	if (dev->pme_interrupt && !dev->runtime_d3cold)
>  		return 0;
>  
>  	if (!acpi_pm_device_run_wake(&dev->dev, enable))
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -1019,10 +1019,13 @@ static int pci_pm_runtime_suspend(struct
>  	if (!pm || !pm->runtime_suspend)
>  		return -ENOSYS;
>  
> +	pci_dev->no_d3cold = false;
>  	error = pm->runtime_suspend(dev);
>  	suspend_report_result(pm->runtime_suspend, error);
>  	if (error)
>  		return error;
> +	if (!pci_dev->d3cold_allowed)
> +		pci_dev->no_d3cold = true;
>  
>  	pci_fixup_device(pci_fixup_suspend, pci_dev);
>  
> @@ -1044,6 +1047,7 @@ static int pci_pm_runtime_suspend(struct
>  
>  static int pci_pm_runtime_resume(struct device *dev)
>  {
> +	int rc;
>  	struct pci_dev *pci_dev = to_pci_dev(dev);
>  	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
>  
> @@ -1054,7 +1058,11 @@ static int pci_pm_runtime_resume(struct
>  	__pci_enable_wake(pci_dev, PCI_D0, true, false);
>  	pci_fixup_device(pci_fixup_resume, pci_dev);
>  
> -	return pm->runtime_resume(dev);
> +	rc = pm->runtime_resume(dev);
> +
> +	pci_dev->runtime_d3cold = false;
> +
> +	return rc;
>  }
>  
>  static int pci_pm_runtime_idle(struct device *dev)
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -28,6 +28,7 @@
>  #include <linux/pci-aspm.h>
>  #include <linux/slab.h>
>  #include <linux/vgaarb.h>
> +#include <linux/pm_runtime.h>
>  #include "pci.h"
>  
>  static int sysfs_initialized;	/* = 0 */
> @@ -378,6 +379,31 @@ dev_bus_rescan_store(struct device *dev,
>  
>  #endif
>  
> +#if defined(CONFIG_PM_RUNTIME) && defined(CONFIG_ACPI)
> +static ssize_t d3cold_allowed_store(struct device *dev,
> +				    struct device_attribute *attr,
> +				    const char *buf, size_t count)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	unsigned long val;
> +
> +	if (strict_strtoul(buf, 0, &val) < 0)
> +		return -EINVAL;
> +
> +	pdev->d3cold_allowed = !!val;
> +	pm_runtime_resume(dev);
> +
> +	return count;
> +}
> +
> +static ssize_t d3cold_allowed_show(struct device *dev,
> +				   struct device_attribute *attr, char *buf)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	return sprintf (buf, "%u\n", pdev->d3cold_allowed);
> +}
> +#endif
> +
>  struct device_attribute pci_dev_attrs[] = {
>  	__ATTR_RO(resource),
>  	__ATTR_RO(vendor),
> @@ -402,6 +428,9 @@ struct device_attribute pci_dev_attrs[]
>  	__ATTR(remove, (S_IWUSR|S_IWGRP), NULL, remove_store),
>  	__ATTR(rescan, (S_IWUSR|S_IWGRP), NULL, dev_rescan_store),
>  #endif
> +#if defined(CONFIG_PM_RUNTIME) && defined(CONFIG_ACPI)
> +	__ATTR(d3cold_allowed, 0644, d3cold_allowed_show, d3cold_allowed_store),
> +#endif
>  	__ATTR_NULL,
>  };
>  
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -622,7 +622,8 @@ static int pci_raw_set_power_state(struc
>  		dev_info(&dev->dev, "Refused to change power state, "
>  			"currently in D%d\n", dev->current_state);
>  
> -	/* According to section 5.4.1 of the "PCI BUS POWER MANAGEMENT
> +	/*
> +	 * According to section 5.4.1 of the "PCI BUS POWER MANAGEMENT
>  	 * INTERFACE SPECIFICATION, REV. 1.2", a device transitioning
>  	 * from D3hot to D0 _may_ perform an internal reset, thereby
>  	 * going to "D0 Uninitialized" rather than "D0 Initialized".
> @@ -654,6 +655,16 @@ void pci_update_current_state(struct pci
>  	if (dev->pm_cap) {
>  		u16 pmcsr;
>  
> +		/*
> +		 * Configuration space is not accessible for device in
> +		 * D3cold, so just keep or set D3cold for safety
> +		 */
> +		if (dev->current_state == PCI_D3cold)
> +			return;
> +		if (state == PCI_D3cold) {
> +			dev->current_state = PCI_D3cold;
> +			return;
> +		}
>  		pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pmcsr);
>  		dev->current_state = (pmcsr & PCI_PM_CTRL_STATE_MASK);
>  	} else {
> @@ -694,8 +705,50 @@ static int pci_platform_power_transition
>   */
>  static void __pci_start_power_transition(struct pci_dev *dev, pci_power_t state)
>  {
> -	if (state == PCI_D0)
> +	if (state == PCI_D0) {
>  		pci_platform_power_transition(dev, PCI_D0);
> +		/*
> +		 * Mandatory power management transition delays, see
> +		 * PCI Express Base Specification Revision 2.0 Section
> +		 * 6.6.1: Conventional Reset.  Do not delay for
> +		 * devices powered on/off by corresponding bridge,
> +		 * because have already delayed for the bridge.
> +		 */
> +		if (dev->runtime_d3cold) {
> +			msleep(dev->d3cold_delay);
> +			/*
> +			 * When powering on a bridge from D3cold, the
> +			 * whole hierarchy may be powered on into
> +			 * D0uninitialized state, resume them to give
> +			 * them a chance to suspend again
> +			 */
> +			pci_wakeup_bus(dev->subordinate);
> +		}
> +	}
> +}
> +
> +/**
> + * __pci_dev_set_current_state - Set current state of a PCI device
> + * @dev: Device to handle
> + * @data: pointer to state to be set
> + */
> +static int __pci_dev_set_current_state(struct pci_dev *dev, void *data)
> +{
> +	pci_power_t state = *(pci_power_t *)data;
> +
> +	dev->current_state = state;
> +	return 0;
> +}
> +
> +/**
> + * __pci_bus_set_current_state - Walk given bus and set current state of devices
> + * @bus: Top bus of the subtree to walk.
> + * @state: state to be set
> + */
> +static void __pci_bus_set_current_state(struct pci_bus *bus, pci_power_t state)
> +{
> +	if (bus)
> +		pci_walk_bus(bus, __pci_dev_set_current_state, &state);
>  }
>  
>  /**
> @@ -707,8 +760,15 @@ static void __pci_start_power_transition
>   */
>  int __pci_complete_power_transition(struct pci_dev *dev, pci_power_t state)
>  {
> -	return state >= PCI_D0 ?
> -			pci_platform_power_transition(dev, state) : -EINVAL;
> +	int ret;
> +
> +	if (state < PCI_D0)
> +		return -EINVAL;
> +	ret = pci_platform_power_transition(dev, state);
> +	/* Power off the bridge may power off the whole hierarchy */
> +	if (!ret && state == PCI_D3cold)
> +		__pci_bus_set_current_state(dev->subordinate, PCI_D3cold);
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(__pci_complete_power_transition);
>  
> @@ -731,9 +791,13 @@ int pci_set_power_state(struct pci_dev *
>  {
>  	int error;
>  
> -	/* bound the state we're entering */
> -	if (state > PCI_D3hot)
> +	/* D3cold during system suspend/hibernate is not supported */
> +	if (!dev->runtime_d3cold && state > PCI_D3hot)

I don't think this is the right place for the dev->runtime_d3cold check,
I've already told you that and haven't heard anything from you causing me
to change my mind.

If you don't want D3cold to be used during system sleep transitions,
please make sure that D3cold is not passed to pci_set_power_state() in
those cases.

Thanks,
Rafael
