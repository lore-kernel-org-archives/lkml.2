Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab2DJKdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 06:33:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36183 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab2DJKdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 06:33:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4F840C3C.2060302@jp.fujitsu.com>
Date: Tue, 10 Apr 2012 19:32:28 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Taku Izumi <izumi.taku@jp.fujitsu.com>, Yinghai Lu <yinghai@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/2] PCI, ACPI, x86: update MMCFG information when hot-plugging
 PCI host bridges
References: <1333905129-8776-1-git-send-email-jiang.liu@huawei.com> <1333905129-8776-3-git-send-email-jiang.liu@huawei.com> <4F82CB64.8030808@jp.fujitsu.com> <4F830804.6010007@gmail.com>
In-Reply-To: <4F830804.6010007@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/10 1:02), Jiang Liu wrote:
> Hi Kenji,
> 	Thanks for your careful review and comments.
>
> On 04/09/2012 07:43 PM, Kenji Kaneshige wrote:
>> Your patch looks good to me.
>>
>> I have some comments.
>>
>> (2012/04/09 2:12), Jiang Liu wrote:
>>> This patch enhances pci_root driver to update MMCFG information when
>>> hot-plugging PCI root bridges on x86 platforms.
>>>
>>
>> Do you have the patch that can be applied to Bjorn's pci tree?
>>
>> <snip.>
> Will try to generate a version against Bjorn's version. Could you please tell
> me the exact git link for that? I haven't pull from Bjorn's tree yet.

As you may know, it was announced _today_ (sorry:).

http://www.spinics.net/lists/linux-pci/msg14626.html

>
>>
>>> +int arch_acpi_pci_root_add(struct acpi_pci_root *root)
>>> +{
>>> +	int result = 0;
>>> +	acpi_status status;
>>> +	unsigned long long base_addr;
>>> +	struct pci_mmcfg_region *cfg;
>>> +
>>> +	/*
>>> +	 * Try to insert MMCFG information for host bridges with _CBA method
>>> +	 */
>>> +	status = acpi_evaluate_integer(root->device->handle, METHOD_NAME__CBA,
>>> +				       NULL,&base_addr);
>>> +	if (ACPI_SUCCESS(status)) {
>>> +		result = pci_mmconfig_insert(root->segment,
>>> +					     root->secondary.start,
>>> +					     root->secondary.end,
>>> +					     base_addr);
>>> +		/*
>>> +		 * MMCFG information for hot-pluggable host bridges may have
>>> +		 * already been added by __pci_mmcfg_init();
>>> +		 */
>>> +		if (result == -EEXIST)
>>> +			result = 0;
>>
>> Just for confirmation.
>>  From my interpretation of PCI firmware spec, MCFG doesn't have any entry
>> for hot-pluggable hostbridge. So I assume this is for the machine that
>> is not compliant to the spec. Is my understanding same as yours?
>>
>> <snip.>
> You are right, it's defined to that way in PCI FW Spec 3.1.
> Here I have some concerns about the PCI buses to host all Ubox components
> on Intel NHM/WSM/SNB/IVB processors. BIOS people are prone to declare
> MMCFG information for those host bridges by MCFG table instead of _CBA method,
> though those host bridge will disappear after hot-removing a physical processor.

Ok, thank you for clarification.

>
>>
>>>    static int __devinit acpi_pci_root_add(struct acpi_device *device)
>>>    {
>>>    	unsigned long long segment, bus;
>>> @@ -504,6 +514,14 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
>>>    	strcpy(acpi_device_class(device), ACPI_PCI_ROOT_CLASS);
>>>    	device->driver_data = root;
>>>
>>> +	if (arch_acpi_pci_root_add(root)) {
>>> +		printk(KERN_ERR PREFIX
>>> +			"can't add MMCFG information for Bus %04x:%02x\n",
>>> +			root->segment, (unsigned int)root->secondary.start);

Additional comment.

This printk message looks strange because arch_acpi_pci_root_add()
is not a mmconfig specific function. So I think this message
should be moved to arch specific code (arch_acpi_pci_root_add()).

>>> +		result = -ENODEV;
>>> +		goto out_free;
>>> +	}
>>
>> Desn't this break the system that doesn't support MMCONFIG?
>>
>> In my understanding, arch_acpi_pci_root_add() returns -ENODEV if
>> mmconfig information is found neither in MCFG table nor _CBA. And
>> pci root bridge initialization seems to fail arch_acpi_pci_root_add()
>> returns non-zero value.
> Good catch, will add following code into arch_acpi_pci_root_add() and
> arch_acpi_pci_root_remove() to solve this issue.
> ---
>          /* MMCONFIG disabled */
>          if ((pci_probe&  PCI_PROBE_MMCONF) == 0)
>                  return 0;
> ---

My understanding is that PCI_PROBE_MMCONF is set even if the system
doesn't have MCFG table. So I don't think this solves the issue. I
guess this is what Yinghai pointed out on your V2 patch [6/6].

Additionally, I think there is a remaining issue even if we change
this check like below.

	if (!!(pci_probe & PCI_PROBE_MASK & ~PCI_PROBE_MMCONF))
         	return 0;

I think this check has an assumption that system has at least one
MCFG table entry and it has been initialized before
acpi_pci_root_add() is called. I think this doesn't work on the
system that doesn't have MCFG and all the pci root bridge have
_CBA (that is, all host bridges are hot-pluggable and BIOS is
implemented in the way PCI FW spec defines). As a result, MMCONFIG
would never be enabled on such systems. Could you double check this?

Regards,
Kenji Kaneshige
