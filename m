Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab2EEIIS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 04:08:18 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:32775 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab2EEIIG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 04:08:06 -0400
MIME-Version: 1.0
In-Reply-To: <201205042250.39519.rjw@sisk.pl>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com>
	<1336119221-21146-6-git-send-email-ying.huang@intel.com>
	<201205042250.39519.rjw@sisk.pl>
Date: Sat, 5 May 2012 16:08:04 +0800
Message-ID: <CAC=cRTP3ZOy1BkvtEZgZ4wfTzaMB8fdZhU_6VOKRwVQ8WLLxJg@mail.gmail.com>
Subject: Re: [RFC v2 5/5] PCIe, Add PCIe runtime D3cold support
From: huang ying <huang.ying.caritas@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Huang Ying <ying.huang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Zheng Yan <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 5, 2012 at 4:50 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, May 04, 2012, Huang Ying wrote:
>> This patch adds runtime D3cold support to PCIe bus.  D3cold is the
>> deepest power saving state for PCIe devices.  Where the main PCIe link
>> will be powered off totally, so before the PCIe main link is powered
>> on again, you can not access the device, even the configuration space,
>> which is still accessible in D3hot.  Because the main PCIe link is not
>> available, the PCI PM registers can not be used to put device into/out
>> of D3cold state, that will be done by platform logic such as ACPI
>> _PR3.
>>
>> To support remote wake up in D3cold, aux power is supplied, and a
>> side-band pin: WAKE# is used to notify remote wake up event, the pin
>> is usually connected to platform logic such as ACPI GPE.  This is
>> quite different with other power saving states, where remote wake up
>> is notified via PME message via the PCIe main link.
>>
>> PCIe devices in plug-in slot usually has no direct platform logic, for
>> example, there is usually no ACPI _PR3 for them.  The D3cold support
>> for these devices can be done via the PCIe port connected to it.  When
>> power on/off the PCIe port, the corresponding PCIe devices are powered
>> on/off too.  And the remote wake up event from PCIe device will be
>> notified to the corresponding PCIe port.
>>
>> The PCI subsystem D3cold support and corresponding ACPI platform
>> support is implemented in the patch.  Including the support for PCIe
>> devices in plug-in slot.
>>
>> For more information about PCIe D3cold and corresponding ACPI support,
>> please refer to:
>>
>> - PCI Express Base Specification Revision 2.0
>> - Advanced Configuration and Power Interface Specification Revision 5.0
>>
>> Originally-by: Zheng Yan <zheng.z.yan@intel.com>
>> Signed-off-by: Huang Ying <ying.huang@intel.com>
>> ---
>>  drivers/pci/pci-acpi.c         |   32 +++++++++--
>>  drivers/pci/pci-driver.c       |    3 +
>>  drivers/pci/pci.c              |  115 +++++++++++++++++++++++++++++++++++++----
>>  drivers/pci/pci.h              |    1
>>  drivers/pci/pcie/portdrv_pci.c |   28 +++++++++
>>  include/linux/pci.h            |   12 +++-
>>  6 files changed, 175 insertions(+), 16 deletions(-)
>>
>> --- a/drivers/pci/pci-acpi.c
>> +++ b/drivers/pci/pci-acpi.c
>> @@ -48,6 +48,21 @@ static void pci_acpi_wake_dev(acpi_handl
>>       if (event != ACPI_NOTIFY_DEVICE_WAKE || !pci_dev)
>>               return;
>>
>> +     if (pci_dev->current_state == PCI_D3cold) {
>> +             unsigned int count = 0;
>> +
>> +             /*
>> +              * Powering on bridge need to resume whole hierarchy,
>> +              * just resume the children to avoid the bridge going
>> +              * suspending as soon as resumed
>> +              */
>
> Don't you need to resume the bridge before you start walking the hierarchy
> below it?

When we resume the hierarchy below the bridge, its parent, the bridge,
will be resumed firstly. That is:

rpm_resume(child)
  rpm_resume(parent)
  ->runtime_suspend(child)

>> +             if (pci_dev->subordinate)
>> +                     count = pci_wakeup_bus(pci_dev->subordinate);
>> +             if (count == 0)
>> +                     pm_runtime_resume(&pci_dev->dev);
>
> What's the count for, exactly?

If there is no devices under the bridge, count returned will be 0,
then we will resume bridge itself.

>> +             return;
>> +     }
>> +
>>       if (!pci_dev->pm_cap || !pci_dev->pme_support
>>            || pci_check_pme_status(pci_dev)) {
>>               if (pci_dev->pme_poll)
>> @@ -187,10 +202,13 @@ acpi_status pci_acpi_remove_pm_notifier(
>>
>>  static pci_power_t acpi_pci_choose_state(struct pci_dev *pdev)
>>  {
>> -     int acpi_state;
>> +     int acpi_state, d_max;
>>
>> -     acpi_state = acpi_pm_device_sleep_state(&pdev->dev, NULL,
>> -                                             ACPI_STATE_D3);
>> +     if (pdev->dev.power.power_must_be_on)
>> +             d_max = ACPI_STATE_D3_HOT;
>> +     else
>> +             d_max = ACPI_STATE_D3_COLD;
>> +     acpi_state = acpi_pm_device_sleep_state(&pdev->dev, NULL, d_max);
>>       if (acpi_state < 0)
>>               return PCI_POWER_ERROR;
>>
>> @@ -297,7 +315,13 @@ static void acpi_pci_propagate_run_wake(
>>
>>  static int acpi_pci_run_wake(struct pci_dev *dev, bool enable)
>>  {
>> -     if (dev->pme_interrupt)
>> +     /*
>> +      * Per PCI Express Base Specification Revision 2.0 section
>> +      * 5.3.3.2 Link Wakeup, platform support is needed for D3cold
>> +      * waking up to power on the main link even if there is PME
>> +      * support for D3cold
>> +      */
>> +     if (dev->pme_interrupt && !dev->runtime_d3cold)
>>               return 0;
>>
>>       if (!acpi_pm_device_run_wake(&dev->dev, enable))
>> --- a/drivers/pci/pci-driver.c
>> +++ b/drivers/pci/pci-driver.c
>> @@ -1013,10 +1013,13 @@ static int pci_pm_runtime_suspend(struct
>>       if (!pm || !pm->runtime_suspend)
>>               return -ENOSYS;
>>
>> +     dev->power.power_must_be_on = false;
>>       error = pm->runtime_suspend(dev);
>>       suspend_report_result(pm->runtime_suspend, error);
>>       if (error)
>>               return error;
>> +     if (!dev->power.power_off_user)
>> +             dev->power.power_must_be_on = true;
>
> That doesn't look good.  The flag itself should be exported via sysfs, but
> only if it is known that power can be removed from the device.
>
>>
>>       pci_fixup_device(pci_fixup_suspend, pci_dev);
>>
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -653,6 +653,12 @@ void pci_update_current_state(struct pci
>>       if (dev->pm_cap) {
>>               u16 pmcsr;
>>
>> +             /*
>> +              * Configuration space is not accessible for device in
>> +              * D3cold, so keep in D3cold for safety
>> +              */
>> +             if (dev->current_state == PCI_D3cold)
>> +                     return;
>>               pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pmcsr);
>>               dev->current_state = (pmcsr & PCI_PM_CTRL_STATE_MASK);
>>       } else {
>> @@ -671,8 +677,11 @@ static int pci_platform_power_transition
>>
>>       if (platform_pci_power_manageable(dev)) {
>>               error = platform_pci_set_power_state(dev, state);
>> -             if (!error)
>> +             if (!error) {
>> +                     if (state == PCI_D3cold)
>> +                             dev->current_state = PCI_D3cold;
>
> +                       else ?

OK.  Will add else here.

>>                       pci_update_current_state(dev, state);
>>
>> +             }
>>               /* Fall back to PCI_D0 if native PM is not supported */
>>               if (!dev->pm_cap)
>>                       dev->current_state = PCI_D0;
>> @@ -693,8 +702,49 @@ static int pci_platform_power_transition
>>   */
>>  static void __pci_start_power_transition(struct pci_dev *dev, pci_power_t state)
>>  {
>> -     if (state == PCI_D0)
>> +     if (state == PCI_D0) {
>>               pci_platform_power_transition(dev, PCI_D0);
>> +             /*
>> +              * Mandatory power management transition delays, see
>> +              * PCI Express Base Specification Revision 2.0 Section
>> +              * 6.6.1: Conventional Reset.  Do not delay for
>> +              * devices powered on/off by corresponding bridge,
>> +              * because have already delayed for the bridge.
>> +              */
>> +             if (dev->runtime_d3cold) {
>> +                     msleep(dev->d3cold_delay);
>> +                     /* When powering on a bridge from D3cold, the
>> +                      * whole hierarchy may be powered on into
>> +                      * D0uninitialized state, resume them to give
>> +                      * them a chance to suspend again */
>> +                     if (dev->subordinate)
>> +                             pci_wakeup_bus(dev->subordinate);
>> +             }
>> +     }
>> +}
>> +
>> +/**
>> + * __pci_dev_set_current_state - Set current state of a PCI device
>> + * @dev: Device to handle
>> + * @data: pointer to state to be set
>> + */
>> +static int __pci_dev_set_current_state(struct pci_dev *dev, void *data)
>> +{
>> +     pci_power_t state = *(pci_power_t *)data;
>> +
>> +     dev->current_state = state;
>> +     return 0;
>> +}
>> +
>> +/**
>> + * __pci_bus_set_current_state - Walk given bus and set current state of devices
>> + * @bus: Top bus of the subtree to walk.
>> + * @state: state to be set
>> + */
>> +static void __pci_bus_set_current_state(struct pci_bus *bus, pci_power_t state)
>> +{
>> +     if (bus)
>> +             pci_walk_bus(bus, __pci_dev_set_current_state, &state);
>>  }
>>
>>  /**
>> @@ -706,8 +756,17 @@ static void __pci_start_power_transition
>>   */
>>  int __pci_complete_power_transition(struct pci_dev *dev, pci_power_t state)
>>  {
>> -     return state >= PCI_D0 ?
>> -                     pci_platform_power_transition(dev, state) : -EINVAL;
>> +     int ret;
>> +
>> +     if (state < PCI_D0)
>> +             return -EINVAL;
>> +     ret = pci_platform_power_transition(dev, state);
>> +     if (!ret && state == PCI_D3cold) {
>> +             /* Power off the bridge may power off the whole hierarchy */
>> +             if (dev->subordinate)
>> +                     __pci_bus_set_current_state(dev->subordinate, state);
>
> I'd just say
>
> +                       __pci_bus_set_current_state(dev->subordinate, PCI_D3cold);
>
> here.  Also you don't need the if (dev->subordinate) check, because
> __pci_bus_set_current_state() will do it anyway.

OK.  Will do that.

>> +     }
>> +     return ret;
>>  }
>>  EXPORT_SYMBOL_GPL(__pci_complete_power_transition);
>>
>> @@ -731,8 +790,8 @@ int pci_set_power_state(struct pci_dev *
>>       int error;
>>
>>       /* bound the state we're entering */
>> -     if (state > PCI_D3hot)
>> -             state = PCI_D3hot;
>> +     if (state > PCI_D3cold)
>> +             state = PCI_D3cold;
>>       else if (state < PCI_D0)
>>               state = PCI_D0;
>>       else if ((state == PCI_D1 || state == PCI_D2) && pci_no_d1d2(dev))
>> @@ -747,10 +806,15 @@ int pci_set_power_state(struct pci_dev *
>>
>>       /* This device is quirked not to be put into D3, so
>>          don't put it in D3 */
>> -     if (state == PCI_D3hot && (dev->dev_flags & PCI_DEV_FLAGS_NO_D3))
>> +     if (state >= PCI_D3hot && (dev->dev_flags & PCI_DEV_FLAGS_NO_D3))
>>               return 0;
>>
>> -     error = pci_raw_set_power_state(dev, state);
>> +     /*
>> +      * To put device in D3cold, we put device into D3hot in native
>> +      * way, then put device into D3cold with platform ops
>> +      */
>> +     error = pci_raw_set_power_state(dev, state > PCI_D3hot ?
>> +                                     PCI_D3hot : state);
>>
>>       if (!__pci_complete_power_transition(dev, state))
>>               error = 0;
>> @@ -1506,6 +1570,34 @@ void pci_pme_wakeup_bus(struct pci_bus *
>>  }
>>
>>  /**
>> + * pci_wakeup - Wake up a PCI device
>> + * @dev: Device to handle.
>> + * @data: to count how many device are waken up.
>> + */
>> +static int pci_wakeup(struct pci_dev *dev, void *data)
>> +{
>> +     unsigned int *count = data;
>> +
>> +     pci_wakeup_event(dev);
>> +     pm_request_resume(&dev->dev);
>> +     (*count)++;
>> +     return 0;
>> +}
>> +
>> +/**
>> + * pci_wakeup_bus - Walk given bus and wake up devices on it
>> + * @bus: Top bus of the subtree to walk.
>> + */
>> +unsigned int pci_wakeup_bus(struct pci_bus *bus)
>> +{
>> +     unsigned int count = 0;
>> +
>> +     if (bus)
>> +             pci_walk_bus(bus, pci_wakeup, &count);
>> +     return count;
>> +}
>> +
>> +/**
>>   * pci_pme_capable - check the capability of PCI device to generate PME#
>>   * @dev: PCI device to handle.
>>   * @state: PCI state from which device will issue PME#.
>> @@ -1789,12 +1881,16 @@ int pci_finish_runtime_suspend(struct pc
>>       if (target_state == PCI_POWER_ERROR)
>>               return -EIO;
>>
>> +     dev->runtime_d3cold = target_state == PCI_D3cold ? true : false;
>
> +       dev->runtime_d3cold = target_state == PCI_D3cold;
>
> will suffice.

OK.  Will do that.

>> +
>>       __pci_enable_wake(dev, target_state, true, pci_dev_run_wake(dev));
>>
>>       error = pci_set_power_state(dev, target_state);
>>
>> -     if (error)
>> +     if (error) {
>>               __pci_enable_wake(dev, target_state, true, false);
>> +             dev->runtime_d3cold = false;
>> +     }
>>
>>       return error;
>>  }
>> @@ -1864,6 +1960,7 @@ void pci_pm_init(struct pci_dev *dev)
>>
>>       dev->pm_cap = pm;
>>       dev->d3_delay = PCI_PM_D3_WAIT;
>> +     dev->d3cold_delay = PCI_PM_D3COLD_WAIT;
>>
>>       dev->d1_support = false;
>>       dev->d2_support = false;
>> --- a/drivers/pci/pci.h
>> +++ b/drivers/pci/pci.h
>> @@ -70,6 +70,7 @@ extern void pci_update_current_state(str
>>  extern void pci_disable_enabled_device(struct pci_dev *dev);
>>  extern int pci_finish_runtime_suspend(struct pci_dev *dev);
>>  extern int __pci_pme_wakeup(struct pci_dev *dev, void *ign);
>> +extern unsigned int pci_wakeup_bus(struct pci_bus *bus);
>>  extern void pci_pm_init(struct pci_dev *dev);
>>  extern void platform_pci_wakeup_init(struct pci_dev *dev);
>>  extern void pci_allocate_cap_save_buffers(struct pci_dev *dev);
>> --- a/drivers/pci/pcie/portdrv_pci.c
>> +++ b/drivers/pci/pcie/portdrv_pci.c
>> @@ -101,10 +101,38 @@ static int pcie_port_resume_noirq(struct
>>  }
>>
>>  #ifdef CONFIG_PM_RUNTIME
>> +struct d3cold_info {
>> +     bool power_must_be_on;
>> +     unsigned int d3cold_delay;
>> +};
>> +
>> +static int pci_dev_d3cold_info(struct pci_dev *pdev, void *data)
>> +{
>> +     struct d3cold_info *info = data;
>> +
>> +     info->d3cold_delay = max_t(unsigned int, pdev->d3cold_delay,
>> +                                info->d3cold_delay);
>> +     info->power_must_be_on = info->power_must_be_on ||
>> +             pdev->dev.power.power_must_be_on;
>> +     return 0;
>> +}
>> +
>>  static int pcie_port_runtime_suspend(struct device *dev)
>>  {
>>       struct pci_dev *pdev = to_pci_dev(dev);
>> +     struct d3cold_info d3cold_info = {
>> +             .power_must_be_on       = dev->power.power_must_be_on,
>> +             .d3cold_delay           = PCI_PM_D3_WAIT,
>> +     };
>>
>> +     /*
>> +      * If any subordinate device need to keep power on, we should
>> +      * not power off the port.  The D3cold delay of port should be
>> +      * the max of that of all subordinate devices.
>
> What if some of the devices below the port are ports themselves?  Or PCI-to-PCIe
> bridges?

For them, I think the current solution is safe.

Best Regards,
Huang Ying
