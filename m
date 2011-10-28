Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab1J1CqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 22:46:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34396 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab1J1CqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 22:46:17 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4EAA1762.1060207@jp.fujitsu.com>
Date: Fri, 28 Oct 2011 11:45:54 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PCI <linux-pci@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] PCI / ACPI: Make acpiphp ignore root bridges using PCIe
 native hotplug
References: <201110220043.38635.rjw@sisk.pl> <201110251525.27446.rjw@sisk.pl> <4EA7543E.7050009@jp.fujitsu.com> <201110261342.51843.rjw@sisk.pl>
In-Reply-To: <201110261342.51843.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/10/26 20:42), Rafael J. Wysocki wrote:
> On Wednesday, October 26, 2011, Kenji Kaneshige wrote:
>> (2011/10/25 22:25), Rafael J. Wysocki wrote:
>>> On Tuesday, October 25, 2011, Kenji Kaneshige wrote:
>>>> Looks good.
>>>> This is also needed for SHPC native hotplug.
>>>
>>> I don't think so, we still leave the SHPC _OSC for the driver to take care
>>> of (which may not be the right thing, but I don't feel confident enough to
>>> decide :-)).
>>
>> I think of the case that acpiphp driver is loaded after shpchp driver is unloaded.
>> Once native hotplug control is granted to OS, there is no way to return the control
>> to firmware. So once shpchp gets the native hotplug control on a given root bridge,
>> acpiphp should not try to handle the hotplug slots under it.
> 
> Good point, but that would be a separate patch I think?

I think separate patch is ok.

Kenji Kaneshige


> 
> Rafael
> 
> 
>>>> (2011/10/22 7:43), Rafael J. Wysocki wrote:
>>>>> From: Rafael J. Wysocki<rjw@sisk.pl>
>>>>>
>>>>> If the kernel has requested control of the PCIe native hotplug
>>>>> feature for a given root complex, the acpiphp driver should not try
>>>>> to handle that root complex and it should leave it to pciehp.
>>>>> Failing to do so causes problems to happen if acpiphp is loaded
>>>>> before pciehp on such systems.
>>>>>
>>>>> To address this issue make find_root_bridges() ignore PCIe root
>>>>> complexes with PCIe native hotplug enabled and make add_bridge()
>>>>> return error code if PCIe native hotplug is enabled for the given
>>>>> root port.  This causes acpiphp to refuse to load if PCIe native
>>>>> hotplug is enabled for all complexes and to refuse binding to
>>>>> the root complexes with PCIe native hotplug is enabled.
>>>>>
>>>>> Signed-off-by: Rafael J. Wysocki<rjw@sisk.pl>
>>>>> ---
>>>>>     drivers/pci/hotplug/acpiphp_glue.c |   29 ++++++++++++++++++++++++-----
>>>>>     1 file changed, 24 insertions(+), 5 deletions(-)
>>>>>
>>>>> Index: linux/drivers/pci/hotplug/acpiphp_glue.c
>>>>> ===================================================================
>>>>> --- linux.orig/drivers/pci/hotplug/acpiphp_glue.c
>>>>> +++ linux/drivers/pci/hotplug/acpiphp_glue.c
>>>>> @@ -458,8 +458,17 @@ static int add_bridge(acpi_handle handle
>>>>>     {
>>>>>     	acpi_status status;
>>>>>     	unsigned long long tmp;
>>>>> +	struct acpi_pci_root *root;
>>>>>     	acpi_handle dummy_handle;
>>>>>
>>>>> +	/*
>>>>> +	 * We shouldn't use this bridge if PCIe native hotplug control has been
>>>>> +	 * granted by the BIOS for it.
>>>>> +	 */
>>>>> +	root = acpi_pci_find_root(handle);
>>>>> +	if (root&&    (root->osc_control_set&    OSC_PCI_EXPRESS_NATIVE_HP_CONTROL))
>>>>> +		return -ENODEV;
>>>>> +
>>>>>     	/* if the bridge doesn't have _STA, we assume it is always there */
>>>>>     	status = acpi_get_handle(handle, "_STA",&dummy_handle);
>>>>>     	if (ACPI_SUCCESS(status)) {
>>>>> @@ -1297,13 +1306,23 @@ static void handle_hotplug_event_func(ac
>>>>>     static acpi_status
>>>>>     find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
>>>>>     {
>>>>> +	struct acpi_pci_root *root;
>>>>>     	int *count = (int *)context;
>>>>>
>>>>> -	if (acpi_is_root_bridge(handle)) {
>>>>> -		acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
>>>>> -				handle_hotplug_event_bridge, NULL);
>>>>> -			(*count)++;
>>>>> -	}
>>>>> +	if (!acpi_is_root_bridge(handle))
>>>>> +		return AE_OK;
>>>>> +
>>>>> +	root = acpi_pci_find_root(handle);
>>>>> +	if (!root)
>>>>> +		return AE_OK;
>>>>> +
>>>>> +	if (root->osc_control_set&    OSC_PCI_EXPRESS_NATIVE_HP_CONTROL)
>>>>> +		return AE_OK;
>>>>> +
>>>>> +	(*count)++;
>>>>> +	acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
>>>>> +				    handle_hotplug_event_bridge, NULL);
>>>>> +
>>>>>     	return AE_OK ;
>>>>>     }
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>>
>>>>
>>>>
>>>
>>>
>>
>>
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

