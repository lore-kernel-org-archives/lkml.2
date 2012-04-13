Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab2DMG3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 02:29:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:25147 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476Ab2DMG3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 02:29:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="128871278"
Message-ID: <4F87C7AB.3060002@intel.com>
Date: Fri, 13 Apr 2012 14:28:59 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Alex He <alex.he@amd.com>
CC: bhelgaas@google.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH] PCIe: Add PCIe runtime D3cold support
References: <4F8790F6.5080408@intel.com> <20120413060626.GA7856@alex-p.amd.com>
In-Reply-To: <20120413060626.GA7856@alex-p.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2012 02:06 PM, Alex He wrote:
> On Fri, Apr 13, 2012 at 10:35:34AM +0800, Yan, Zheng wrote:
>> Hi all,
>>
>> This patch adds PCIe runtime D3cold support, namely cut power supply for functions
>> beneath a PCIe port when they all have entered D3. A device in D3cold can only
>> generate wake event through the WAKE# pin. Because we can not access to a device's
>> configure space while it's in D3cold, pme_poll is disabled for devices in D3cold.
>>
>> Any comment will be appreciated.
>>
>> Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
>> ---
>> diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
>> index 0f150f2..e210e8cb 100644
>> --- a/drivers/pci/pci-acpi.c
>> +++ b/drivers/pci/pci-acpi.c
>> @@ -224,7 +224,7 @@ static int acpi_pci_set_power_state(struct pci_dev *dev, pci_power_t state)
>>  		[PCI_D1] = ACPI_STATE_D1,
>>  		[PCI_D2] = ACPI_STATE_D2,
>>  		[PCI_D3hot] = ACPI_STATE_D3,
>> -		[PCI_D3cold] = ACPI_STATE_D3
>> +		[PCI_D3cold] = ACPI_STATE_D3_COLD
>>  	};
>>  	int error = -EINVAL;
>>  
>> @@ -296,7 +296,8 @@ static void acpi_pci_propagate_run_wake(struct pci_bus *bus, bool enable)
>>  
>>  static int acpi_pci_run_wake(struct pci_dev *dev, bool enable)
>>  {
>> -	if (dev->pme_interrupt)
>> +	/* PME interrupt isn't available in the D3cold case */
>> +	if (dev->pme_interrupt && !dev->runtime_d3cold)
>>  		return 0;
> PCI BUS PM Interface spec says that PMEs can be support for D3COLD.
> Please check section 3.2.4 , 5.4.2 and 5.4.3.
> 
I can't make PME interrupt work in mint spring platform. Our internal RTD3 document say:
"A device in RTD3 is prohibited from generating any activity other than wake event, through the WAKE# pin"

>>  
>>  	if (!acpi_pm_device_run_wake(&dev->dev, enable))
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index 8156744..bc16869 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -731,8 +731,8 @@ int pci_set_power_state(struct pci_dev *dev, pci_power_t state)
>>  	int error;
>>  
>>  	/* bound the state we're entering */
>> -	if (state > PCI_D3hot)
>> -		state = PCI_D3hot;
>> +	if (state > PCI_D3cold)
>> +		state = PCI_D3cold;
>>  	else if (state < PCI_D0)
>>  		state = PCI_D0;
>>  	else if ((state == PCI_D1 || state == PCI_D2) && pci_no_d1d2(dev))
>> @@ -750,7 +750,8 @@ int pci_set_power_state(struct pci_dev *dev, pci_power_t state)
>>  	if (state == PCI_D3hot && (dev->dev_flags & PCI_DEV_FLAGS_NO_D3))
>>  		return 0;
>>  
>> -	error = pci_raw_set_power_state(dev, state);
>> +	error = pci_raw_set_power_state(dev, state > PCI_D3hot ?
>> +					PCI_D3hot : state);
> Do you want to set the pci device to D3hot if the state = D3Code through
> PMCSR register? I am agree if you realy want that but what is the meaninig
> to distingulish D3cold with D3hot in this patch. We can't put the PCI device
> through PMCSR register.

To set a device to D3cold. We first set device to D3hot through PMCSR register,
then cut the power supply through ACPI.

Regards
Yan, Zheng

> 
>>  
>>  	if (!__pci_complete_power_transition(dev, state))
>>  		error = 0;
>> @@ -1482,6 +1483,17 @@ bool pci_pme_capable(struct pci_dev *dev, pci_power_t state)
>>  	return !!(dev->pme_support & (1 << state));
>>  }
>>  
>> +static void pci_pme_poll_wakeup(struct pci_dev *dev)
>> +{
>> +	struct pci_dev *bridge = dev->bus->self;
>> +
>> +	/* don't poll the pme bit if parent is in low power state */
>> +	if (bridge && bridge->current_state != PCI_D0)
>> +		return;
>> +
>> +	pci_pme_wakeup(dev, NULL);
>> +}
>> +
>>  static void pci_pme_list_scan(struct work_struct *work)
>>  {
>>  	struct pci_pme_device *pme_dev, *n;
>> @@ -1490,7 +1502,7 @@ static void pci_pme_list_scan(struct work_struct *work)
>>  	if (!list_empty(&pci_pme_list)) {
>>  		list_for_each_entry_safe(pme_dev, n, &pci_pme_list, list) {
>>  			if (pme_dev->dev->pme_poll) {
>> -				pci_pme_wakeup(pme_dev->dev, NULL);
>> +				pci_pme_poll_wakeup(pme_dev->dev);
>>  			} else {
>>  				list_del(&pme_dev->list);
>>  				kfree(pme_dev);
>> @@ -1608,6 +1620,10 @@ int __pci_enable_wake(struct pci_dev *dev, pci_power_t state,
>>  	if (enable) {
>>  		int error;
>>  
>> +		if (runtime && state >= PCI_D3cold)
>> +			dev->runtime_d3cold = true;
>> +		else
>> +			dev->runtime_d3cold = false;
>>  		if (pci_pme_capable(dev, state))
>>  			pci_pme_active(dev, true);
>>  		else
>> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
>> index e0610bd..d66b7e9 100644
>> --- a/drivers/pci/pcie/portdrv_pci.c
>> +++ b/drivers/pci/pcie/portdrv_pci.c
>> @@ -11,11 +11,13 @@
>>  #include <linux/kernel.h>
>>  #include <linux/errno.h>
>>  #include <linux/pm.h>
>> +#include <linux/pm_runtime.h>
>>  #include <linux/init.h>
>>  #include <linux/pcieport_if.h>
>>  #include <linux/aer.h>
>>  #include <linux/dmi.h>
>>  #include <linux/pci-aspm.h>
>> +#include <linux/delay.h>
>>  
>>  #include "portdrv.h"
>>  #include "aer/aerdrv.h"
>> @@ -99,6 +101,25 @@ static int pcie_port_resume_noirq(struct device *dev)
>>  	return 0;
>>  }
>>  
>> +static int pcie_port_runtime_suspend(struct device *dev)
>> +{
>> +	struct pci_dev *pdev = to_pci_dev(dev);
>> +
>> +	pci_save_state(pdev);
>> +	return 0;
>> +}
>> +
>> +static int pcie_port_runtime_resume(struct device *dev)
>> +{
>> +	struct pci_dev *pdev = to_pci_dev(dev);
>> +
>> +	pci_restore_state(pdev);
>> +	if (pdev->runtime_d3cold)
>> +		msleep(100);
>> +
>> +	return 0;
>> +}
>> +
>>  static const struct dev_pm_ops pcie_portdrv_pm_ops = {
>>  	.suspend	= pcie_port_device_suspend,
>>  	.resume		= pcie_port_device_resume,
>> @@ -107,6 +128,8 @@ static const struct dev_pm_ops pcie_portdrv_pm_ops = {
>>  	.poweroff	= pcie_port_device_suspend,
>>  	.restore	= pcie_port_device_resume,
>>  	.resume_noirq	= pcie_port_resume_noirq,
>> +	.runtime_suspend = pcie_port_runtime_suspend,
>> +	.runtime_resume = pcie_port_runtime_resume,
>>  };
>>  
>>  #define PCIE_PORTDRV_PM_OPS	(&pcie_portdrv_pm_ops)
>> @@ -144,12 +167,14 @@ static int __devinit pcie_portdrv_probe(struct pci_dev *dev,
>>  		return status;
>>  
>>  	pci_save_state(dev);
>> +	pm_runtime_put_noidle(&dev->dev);
>>  
>>  	return 0;
>>  }
>>  
>>  static void pcie_portdrv_remove(struct pci_dev *dev)
>>  {
>> +	pm_runtime_get_noresume(&dev->dev);
>>  	pcie_port_device_remove(dev);
>>  	pci_disable_device(dev);
>>  }
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index e444f5b..b41d9a1 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -281,6 +281,7 @@ struct pci_dev {
>>  	unsigned int	no_d1d2:1;	/* Only allow D0 and D3 */
>>  	unsigned int	mmio_always_on:1;	/* disallow turning off io/mem
>>  						   decoding during bar sizing */
>> +	unsigned int	runtime_d3cold:1;
>>  	unsigned int	wakeup_prepared:1;
>>  	unsigned int	d3_delay;	/* D3->D0 transition time in ms */
>>  
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 

