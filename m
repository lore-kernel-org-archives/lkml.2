Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab3AIQKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 11:10:55 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36329 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab3AIQKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 11:10:53 -0500
Message-ID: <50ED9688.9090304@gmail.com>
Date: Thu, 10 Jan 2013 00:10:48 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v3 2/6] PCI: split registration of PCI bus devices into
 two stages
References: <1357663945-16054-1-git-send-email-jiang.liu@huawei.com> <1357663945-16054-3-git-send-email-jiang.liu@huawei.com> <31602902.kR8ehd6tSR@vostro.rjw.lan>
In-Reply-To: <31602902.kR8ehd6tSR@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 07:29 AM, Rafael J. Wysocki wrote:
> On Wednesday, January 09, 2013 12:52:21 AM Jiang Liu wrote:
snip
>> @@ -1678,7 +1679,8 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>>  	b->dev.class = &pcibus_class;
>>  	b->dev.parent = b->bridge;
>>  	dev_set_name(&b->dev, "%04x:%02x", pci_domain_nr(b), bus);
>> -	error = device_register(&b->dev);
>> +	device_initialize(&b->dev);
>> +	error = device_add(&b->dev);
> 
> Well, the change here isn't really necessary, as far as I can say.
Hi Rafael,
	The kernel documentation recommends to pair device_add() with device_del(),
so the above change is to follow that recommendation because pci_remove_bus() now
invokes device_del().

> 
>>  	if (error)
>>  		goto class_dev_reg_err;
>>  
>> diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
>> index fc38c48..a1fdd0f 100644
>> --- a/drivers/pci/remove.c
>> +++ b/drivers/pci/remove.c
>> @@ -48,11 +48,11 @@ void pci_remove_bus(struct pci_bus *bus)
>>  	list_del(&bus->node);
>>  	pci_bus_release_busn_res(bus);
>>  	up_write(&pci_bus_sem);
>> -	if (!bus->is_added)
>> -		return;
>> -
>> -	pci_remove_legacy_files(bus);
>> -	device_unregister(&bus->dev);
>> +	if (bus->is_added) {
>> +		pci_remove_legacy_files(bus);
>> +		device_del(&bus->dev);
>> +	}
>> +	put_device(&bus->dev);
>>  }
>>  EXPORT_SYMBOL(pci_remove_bus);
>>  
>>
> 
> Apart from the above
> 
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Thanks for your review and Ack.

Regards!
Gerry

