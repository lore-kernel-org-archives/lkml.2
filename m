Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab3AIQaC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 11:30:02 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:47314 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab3AIQaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 11:30:00 -0500
Message-ID: <50ED9B03.3020606@gmail.com>
Date: Thu, 10 Jan 2013 00:29:55 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 4/6] PCI/acpiphp: update ACPI hotplug slot information
 when PCI hotplug happens
References: <1357663945-16054-1-git-send-email-jiang.liu@huawei.com> <1357663945-16054-5-git-send-email-jiang.liu@huawei.com> <5038693.7d3RCgbghD@vostro.rjw.lan>
In-Reply-To: <5038693.7d3RCgbghD@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 08:04 AM, Rafael J. Wysocki wrote:
> On Wednesday, January 09, 2013 12:52:23 AM Jiang Liu wrote:
>> Currently the acpiphp driver fails to update hotplug slot information under
>> several conditions, such as:
>> 1) The bridge device is removed through /sys/bus/pci/devices/.../remove
>> 2) The bridge device is added/removed by PCI hotplug driver other than the
>>    acpiphp driver itself. For example, if an IO expansion box with ACPI
>>    hotplug slots available is hot-added by the pciehp driver, all ACPI
>>    hotplug slots won't be discovered by the acpiphp driver.
>>
>> So hook the BUS_NOTIFY_ADD_DEVICE/BUS_NOTIFY_DEL_DEVICE events to
>> update ACPI hotplug slot information when PCI hotplug event happens.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> ---
>>  drivers/pci/hotplug/acpiphp_glue.c |   62 ++++++++++++++++++++++++++++++++++--
>>  1 file changed, 60 insertions(+), 2 deletions(-)
>>
snip
>> +static struct notifier_block acpi_pci_hp_notifier = {
>> +	.notifier_call = &acpi_pci_hp_notify_fn,
>> +};
>> +
>>  static struct acpi_pci_driver acpi_pci_hp_driver = {
>>  	.add =		add_bridge,
>>  	.remove =	remove_bridge,
>> @@ -1448,6 +1503,8 @@ int __init acpiphp_glue_init(void)
>>  	else
>>  		acpi_pci_register_driver(&acpi_pci_hp_driver);
>>  
>> +	bus_register_notifier(&pci_bus_type, &acpi_pci_hp_notifier);
> 
> Your previous patch adds a PCI bus notifier for a similar thing.  Why are
> you adding another one here?
Hi Rafael,
	The acpiphp driver could be built as a module, and this bus notifier
is used to setup/tear down ACPI based PCI hotplug controllers under a PCI bridge.
The previous patch is to add/remove PCI slots. The PCI slot and PCI hotplug
controller are related but different objects, so we use two notifiers to support
them all.
	Thanks!
	Gerry

> 
> 
>> +
>>  	return 0;
>>  }
>>  
>> @@ -1459,6 +1516,7 @@ int __init acpiphp_glue_init(void)
>>   */
>>  void  acpiphp_glue_exit(void)
>>  {
>> +	bus_unregister_notifier(&pci_bus_type, &acpi_pci_hp_notifier);
>>  	acpi_pci_unregister_driver(&acpi_pci_hp_driver);
>>  }
> 
> Thanks,
> Rafael
> 
> 

