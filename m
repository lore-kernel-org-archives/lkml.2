Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab1J0Oel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 10:34:41 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:61403 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab1J0Oej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 10:34:39 -0400
Message-ID: <4EA96BEA.7060004@oracle.com>
Date: Thu, 27 Oct 2011 20:04:18 +0530
From: Ajaykumar Hotchandani <ajaykumar.hotchandani@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: Set device power state to PCI_D0 for device without
 native PM support
References: <4E8C40A8.6080205@oracle.com> <alpine.DEB.2.00.1110061137120.3519@kaball-desktop> <CAE9FiQVyT=n18JnuBmda86D77Ai4HAC=w68Oo-Na3mCdAxsCMw@mail.gmail.com> <alpine.DEB.2.00.1110061711290.3519@kaball-desktop> <4E92DEC1.5050806@oracle.com> <alpine.DEB.2.00.1110131525320.3519@kaball-desktop> <4E9D8495.4010105@oracle.com> <alpine.DEB.2.00.1110271411450.3519@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1110271411450.3519@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4EA96BFB.00DD,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/27/2011 06:44 PM, Stefano Stabellini wrote:
> On Tue, 18 Oct 2011, Ajaykumar Hotchandani wrote:
>> On 10/13/2011 08:00 PM, Stefano Stabellini wrote:
>>> On Mon, 10 Oct 2011, Ajaykumar Hotchandani wrote:
>>>> On 10/06/2011 09:47 PM, Stefano Stabellini wrote:
>>>>> On Thu, 6 Oct 2011, Yinghai Lu wrote:
>>>>>> On Thu, Oct 6, 2011 at 3:39 AM, Stefano Stabellini
>>>>>> <stefano.stabellini@eu.citrix.com>    wrote:
>>>>>>> I had the same issue and sent a patch a while ago to fix it, adding
>>>>>>>
>>>>>>> current_state = PCI_D0 in acpiphp_glue.c:register_slot
>>>>>>>
>>>>>>> it is strange that this does not work for you:
>>>>>>>
>>>>>>> http://marc.info/?l=linux-kernel&m=129891002722845&w=2
>>>>>> So guest os has to load acpiphp instead of pciehp?
>>>>> maybe pciehp needs to make sure that current_state = D0 in
>>>>> pciehp_enable_slot, like acpiphp does
>>>> Here, acpi hotplugging is involved.
>>>> With your change in register_slot(), device will have proper power state when module is being loaded for the first time after booting.
>>>> However, while unload of pci module; following is in pci_device_remove():
>>>>            if (pci_dev->current_state == PCI_D0)
>>>>                    pci_dev->current_state = PCI_UNKNOWN;
>>>>
>>>> So, device power state state will remain PCI_UNKNOWN while module is loaded again. Subsequently, MSI write will do nothing.
>>> Does this mean that this bug would actually trigger even with devices that
>>> do support _EJ0 and power management?
>> Nope. I don't have system to verify. But, for the scenario you mentioned
>> (device is hot pluggable, acpi bus power manageable and device with
>> pm_cap supported; if I understand it correctly), following is what I
>> think should happen:
>> - Inside pci_platform_power_transition(),
>> platform_pci_power_manageable() will be successful. However,
>> platform_pci_set_power_state() will fail (as device supports EJ0) and
>> subsequently pci_update_current_state() will not get called.
>> - So, current power state of device will not be read and power state of
>> device will remain PCI_UNKNOWN.
>> - Now, pci_raw_set_power_state() will get called. Here, as current power
>> state is PCI_UNKNOWN, pci_write_config_word() will be called with pmcsr
>> value as 0. As, last two bits of pmcsr is 0, written power state of
>> device will be PCI_D0 now. And subsequently, dev->current_state will be
>> assigned as PCI_D0 (by using pci_read_config_word() ).
> OK, I understand.
>
>
>>> Because acpi_pci_set_power_state won't set current_state to PCI_D0
>>> because the "hotplug driver will take care of _PSx" (see
>>> 10b3dcae0f275e2546e55303d64ddbb58cec7599) but the hotplug driver is not
>>> actually invoked when loading again a driver module of an existing pci
>>> device (the example you mention above)?
>> Can you please elaborate more on this?
>> acpi_bus_set_power() will update state of acpi_dev (ACPI_STATE_XX) and
>> not pci_dev (PCI_XX).
>> And here, issue lies with current_state of pci_dev.
> I agree, I was merely stating again what the problem is.
>
> BTW I am OK with your patch.

Should we revert 47e9037ac16637cd7f12b8790ea7ce6680e42168 (your changes 
in register_slot() )
I think, after this change, it's not needed. Or, am I missing some scenario?

