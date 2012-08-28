Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab2H1X4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 19:56:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59940 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab2H1X4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 19:56:49 -0400
Message-ID: <503D5ABB.6010605@gmail.com>
Date: Wed, 29 Aug 2012 07:56:43 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Don Dutile <ddutile@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 5/5] PCI/xen-pcifront: simplify code by hotplug safe pci_get_domain_bus_and_slot()
References: <1346168638-32724-1-git-send-email-jiang.liu@huawei.com> <1346168638-32724-6-git-send-email-jiang.liu@huawei.com> <20120828165959.GA23312@localhost.localdomain>
In-Reply-To: <20120828165959.GA23312@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2012 12:59 AM, Konrad Rzeszutek Wilk wrote:
> On Tue, Aug 28, 2012 at 11:43:58PM +0800, Jiang Liu wrote:
>> Following code has a race window between pci_find_bus() and pci_get_slot()
>> if PCI hotplug operation happens between them which removes the pci_bus.
>> So use PCI hotplug safe interface pci_get_domain_bus_and_slot() instead,
>> which also reduces code complexity.
> 
> Has this happend in practice? Is this something one can reproduce
> by manipulating SysFS and at the same time unplugging the PCI
> devices?
Hi Konrad,
	We just noticed this issue by code inspection when improving PCI
hotplug implementation. I guess we could trigger such issue by adding
some delay between pci_find_bus() and pci_get_slot().
	Regards!
	Gerry

>>
>> struct pci_bus *pci_bus = pci_find_bus(domain, busno);
>> struct pci_dev *pci_dev = pci_get_slot(pci_bus, devfn);
>>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> ---
>>  drivers/pci/xen-pcifront.c |   10 ++--------
>>  1 file changed, 2 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
>> index d6cc62c..def8d0b 100644
>> --- a/drivers/pci/xen-pcifront.c
>> +++ b/drivers/pci/xen-pcifront.c
>> @@ -982,7 +982,6 @@ static int pcifront_detach_devices(struct pcifront_device *pdev)
>>  	int err = 0;
>>  	int i, num_devs;
>>  	unsigned int domain, bus, slot, func;
>> -	struct pci_bus *pci_bus;
>>  	struct pci_dev *pci_dev;
>>  	char str[64];
>>  
>> @@ -1032,13 +1031,8 @@ static int pcifront_detach_devices(struct pcifront_device *pdev)
>>  			goto out;
>>  		}
>>  
>> -		pci_bus = pci_find_bus(domain, bus);
>> -		if (!pci_bus) {
>> -			dev_dbg(&pdev->xdev->dev, "Cannot get bus %04x:%02x\n",
>> -				domain, bus);
>> -			continue;
>> -		}
>> -		pci_dev = pci_get_slot(pci_bus, PCI_DEVFN(slot, func));
>> +		pci_dev = pci_get_domain_bus_and_slot(domain, bus,
>> +				PCI_DEVFN(slot, func));
>>  		if (!pci_dev) {
>>  			dev_dbg(&pdev->xdev->dev,
>>  				"Cannot get PCI device %04x:%02x:%02x.%d\n",
>> -- 
>> 1.7.9.5
>>

