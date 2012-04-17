Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab2DQCMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 22:12:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:1200 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692Ab2DQCM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 22:12:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="133281054"
Message-ID: <4F8CD18A.5080903@intel.com>
Date: Tue, 17 Apr 2012 10:12:26 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: bhelgaas@google.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Lin Ming <ming.m.lin@intel.com>, Zhang Rui <rui.zhang@intel.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: [RFC PATCH] PCIe: Add PCIe runtime D3cold support
References: <4F8790F6.5080408@intel.com> <201204132141.58063.rjw@sisk.pl> <4F8B828E.9060606@intel.com> <201204161907.13806.rjw@sisk.pl>
In-Reply-To: <201204161907.13806.rjw@sisk.pl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2012 01:07 AM, Rafael J. Wysocki wrote:
> Hi,
> 
> On Monday, April 16, 2012, Yan, Zheng wrote:
>> On 04/14/2012 03:41 AM, Rafael J. Wysocki wrote:
>>> Hi,
>>>
>>> On Friday, April 13, 2012, Yan, Zheng wrote:
>>>> Hi all,
>>>>
>>>> This patch adds PCIe runtime D3cold support, namely cut power supply for functions
>>>> beneath a PCIe port when they all have entered D3. A device in D3cold can only
>>>> generate wake event through the WAKE# pin. Because we can not access to a device's
>>>> configure space while it's in D3cold, pme_poll is disabled for devices in D3cold.
>>>>
>>>> Any comment will be appreciated.
>>>>
>>>> Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
>>>> ---
>>>> diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
>>>> index 0f150f2..e210e8cb 100644
>>>> --- a/drivers/pci/pci-acpi.c
>>>> +++ b/drivers/pci/pci-acpi.c
>>>> @@ -224,7 +224,7 @@ static int acpi_pci_set_power_state(struct pci_dev *dev, pci_power_t state)
>>>>  		[PCI_D1] = ACPI_STATE_D1,
>>>>  		[PCI_D2] = ACPI_STATE_D2,
>>>>  		[PCI_D3hot] = ACPI_STATE_D3,
>>>> -		[PCI_D3cold] = ACPI_STATE_D3
>>>> +		[PCI_D3cold] = ACPI_STATE_D3_COLD
>>>>  	};
>>>>  	int error = -EINVAL;
>>>>  
>>>
>>> Please don't use that ACPI_STATE_D3_COLD thing, it's not defined correctly.
>>>
>>> We should define ACPI_STATE_D3_COLD == ACPI_STATE_D3 and add ACPI_STATE_D3_HOT
>>> instead.  I'll prepare a patch for that over the weekend if no one has done
>>> that already.
>>>
>>>> @@ -296,7 +296,8 @@ static void acpi_pci_propagate_run_wake(struct pci_bus *bus, bool enable)
>>>>  
>>>>  static int acpi_pci_run_wake(struct pci_dev *dev, bool enable)
>>>>  {
>>>> -	if (dev->pme_interrupt)
>>>> +	/* PME interrupt isn't available in the D3cold case */
>>>> +	if (dev->pme_interrupt && !dev->runtime_d3cold)
>>>
>>> This whole thing is wrong.  First off, I don't think that the runtime_d3cold
>>> flag makes any sense.  We already cover that in dev->pme_support.
>>>
>>> Second, pme_interrupt means that the _root_ _port_, not the device itself will
>>> trigger an interrupt whenever the device sends the PME message to it (which
>>> very well may happen for a device in D3_cold woken up by an external signal).
>>>
>> The reason I introduced the runtime_d3cold flag is I can't make the PME interrupt
>> work in the D3cold case in our test platform. Document for our test platform says
>> A device in D3cold can only generate wake event through the WAKE# pin.
> 
> OK, so that clearly is not a standard PCI device, so please don't try to
> make our PCI bus type handle non-standard devices.
> 
>>>>  		return 0;
>>>>  
>>>>  	if (!acpi_pm_device_run_wake(&dev->dev, enable))
>>>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>>>> index 8156744..bc16869 100644
>>>> --- a/drivers/pci/pci.c
>>>> +++ b/drivers/pci/pci.c
>>>> @@ -731,8 +731,8 @@ int pci_set_power_state(struct pci_dev *dev, pci_power_t state)
>>>>  	int error;
>>>>  
>>>
>>> Guys, please.  Never, _ever_, touch pci_set_power_state() without discussing
>>> your ideas with someone who knows how it works and _why_ it works this way.
>>>
>>> The problem here is that you can't program a PCI device into D3_cold, so it
>>> doesn't even make sense to have a helper for that.
>>>
>>>>  	/* bound the state we're entering */
>>>> -	if (state > PCI_D3hot)
>>>> -		state = PCI_D3hot;
>>>> +	if (state > PCI_D3cold)
>>>> +		state = PCI_D3cold;
>>>>  	else if (state < PCI_D0)
>>>>  		state = PCI_D0;
>>>>  	else if ((state == PCI_D1 || state == PCI_D2) && pci_no_d1d2(dev))
>>>> @@ -750,7 +750,8 @@ int pci_set_power_state(struct pci_dev *dev, pci_power_t state)
>>>>  	if (state == PCI_D3hot && (dev->dev_flags & PCI_DEV_FLAGS_NO_D3))
>>>>  		return 0;
>>>>  
>>>> -	error = pci_raw_set_power_state(dev, state);
>>>> +	error = pci_raw_set_power_state(dev, state > PCI_D3hot ?
>>>> +					PCI_D3hot : state);
>>>>  
>>>>  	if (!__pci_complete_power_transition(dev, state))
>>>>  		error = 0;
>>>> @@ -1482,6 +1483,17 @@ bool pci_pme_capable(struct pci_dev *dev, pci_power_t state)
>>>>  	return !!(dev->pme_support & (1 << state));
>>>>  }
>>>>  
>>>> +static void pci_pme_poll_wakeup(struct pci_dev *dev)
>>>> +{
>>>> +	struct pci_dev *bridge = dev->bus->self;
>>>> +
>>>> +	/* don't poll the pme bit if parent is in low power state */
>>>> +	if (bridge && bridge->current_state != PCI_D0)
>>>> +		return;
>>>> +
>>>> +	pci_pme_wakeup(dev, NULL);
>>>> +}
>>>
>>> This one actually makes some sense, although it might be better to put the
>>> test into pci_pme_wakeup() itself.
>>
>> put it into pci_pme_wakeup will break ACPI wakeup, because ACPI wakeup also
>> uses pci_pme_wakeup. When a device exits from D3cold by asserting the WAKE#
>> signal, device power is restored automatically by ACPI, then pci_pme_wakeup
>> is called to check device's PME bit. pci_dev->current_state is PCI_D3hot
>> during the checking. 
> 
> You seem to be talking about two different device here.  One device is
> dev, which is the one being checked for the PME bit and the second one
> is the bridge that should be in D0 so that dev is accessible, right?

Yes
> 
> So if you put this code into pci_pme_wakeup():
> 
> 	struct pci_dev *bridge = pci_dev->bus->self;
> 
> 	...
> 
> 	if (bridge && bridge->current_state != PCI_D0)
> 		return 0;
> 
> then it should work just like your code above.
No. In the wakeup case, bridge's power is restored automatically by ACPI,
but bridge->current_state does not reflect the power state, it's still PCI_D3hot.

> 
> BTW, can you please explain to me what the #WAKE signal is and how it is
> different from PME#?

#WAKE signal is triggered by a pin connected to the root complex or other
motherboard logic. PME# is triggered by PME message sent to the port.

> 
>>>> +
>>>>  static void pci_pme_list_scan(struct work_struct *work)
>>>>  {
>>>>  	struct pci_pme_device *pme_dev, *n;
>>>> @@ -1490,7 +1502,7 @@ static void pci_pme_list_scan(struct work_struct *work)
>>>>  	if (!list_empty(&pci_pme_list)) {
>>>>  		list_for_each_entry_safe(pme_dev, n, &pci_pme_list, list) {
>>>>  			if (pme_dev->dev->pme_poll) {
>>>> -				pci_pme_wakeup(pme_dev->dev, NULL);
>>>> +				pci_pme_poll_wakeup(pme_dev->dev);
>>>>  			} else {
>>>>  				list_del(&pme_dev->list);
>>>>  				kfree(pme_dev);
>>>> @@ -1608,6 +1620,10 @@ int __pci_enable_wake(struct pci_dev *dev, pci_power_t state,
>>>>  	if (enable) {
>>>>  		int error;
>>>>  
>>>> +		if (runtime && state >= PCI_D3cold)
>>>> +			dev->runtime_d3cold = true;
>>>> +		else
>>>> +			dev->runtime_d3cold = false;
>>>>  		if (pci_pme_capable(dev, state))
>>>>  			pci_pme_active(dev, true);
>>>>  		else
>>>> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
>>>> index e0610bd..d66b7e9 100644
>>>> --- a/drivers/pci/pcie/portdrv_pci.c
>>>> +++ b/drivers/pci/pcie/portdrv_pci.c
>>>> @@ -11,11 +11,13 @@
>>>>  #include <linux/kernel.h>
>>>>  #include <linux/errno.h>
>>>>  #include <linux/pm.h>
>>>> +#include <linux/pm_runtime.h>
>>>>  #include <linux/init.h>
>>>>  #include <linux/pcieport_if.h>
>>>>  #include <linux/aer.h>
>>>>  #include <linux/dmi.h>
>>>>  #include <linux/pci-aspm.h>
>>>> +#include <linux/delay.h>
>>>>  
>>>>  #include "portdrv.h"
>>>>  #include "aer/aerdrv.h"
>>>> @@ -99,6 +101,25 @@ static int pcie_port_resume_noirq(struct device *dev)
>>>>  	return 0;
>>>>  }
>>>>  
>>>> +static int pcie_port_runtime_suspend(struct device *dev)
>>>> +{
>>>> +	struct pci_dev *pdev = to_pci_dev(dev);
>>>> +
>>>> +	pci_save_state(pdev);
>>>
>>> Are you sure this is sufficient?
>>
>> What else should I do?
> 
> First off, you need not do pci_save_state() here, most likely, because
> pci_pm_runtime_suspend() will do it for you later.

Our test platform behaves strangely if this pci_save_state is removed.
I guess it's because pci_fixup_device is called before pci_save_state
in pci_pm_runtime_suspend

> 
> Second, you're suspending a device that has children here.  Namely,
> the PCIe service devices are children of the port they are associated with.
> I wonder if they are suspended and how exactly, if so?
> 
Only the PME service has the PM callbacks. I don't think we should stop the PME
service in the runtime suspend case. For example, when both device and port are
in D3hot, No PME interrupt can be received if we stop the PME service.

Regards
Yan, Zheng
