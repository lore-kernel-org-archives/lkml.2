Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab2H1At6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 20:49:58 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:54573 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab2H1At5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 20:49:57 -0400
Message-ID: <503C1523.30302@huawei.com>
Date: Tue, 28 Aug 2012 08:47:31 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        PCI <linux-pci@vger.kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Huang Ying <ying.huang@intel.com>, Hanjun Guo <guohanjun@huawei.com>,
        <linux-kernel@vger.kernel.org>, <gong.chen@linux.intel.com>
Subject: Re: [RESEND BUGFIX PATCH 1/3] PCI/AER: fix pci_ops return NULL when
 hotplug a pci bus which was doing aer error inject
References: <1344685946-8172-1-git-send-email-wangyijing@huawei.com> <5038A210.4030005@huawei.com> <20120827084924.GB3858@gchen.bj.intel.com>
In-Reply-To: <20120827084924.GB3858@gchen.bj.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.84]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> bash[5908]: NaT consumption 17179869216 [1]
>> Modules linked in: aer_inject cpufreq_conservative cpufreq_userspace cpufreq_pow
>> ersave acpi_cpufreq binfmt_misc fuse nls_iso8859_1 loop ipmi_si(+) ipmi_devintf
>> ipmi_msghandler dm_mod ppdev iTCO_wdt iTCO_vendor_support sg igb parport_pc i2c_
>> i801 mptctl i2c_core serio_raw hid_generic lpc_ich mfd_core parport button conta
>> iner usbhid hid uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif ext3 mbca
>> che jbd fan processor ide_pci_generic ide_core ata_piix libata mptsas mptscsih m
>> ptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
>>
> [...]
>>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> Signed-off-by: Jiang Liu <liuj97@gmail.com>
>> ---
>>  drivers/pci/pcie/aer/aer_inject.c |   21 +++++++++++++++++++++
>>  1 files changed, 21 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/pci/pcie/aer/aer_inject.c b/drivers/pci/pcie/aer/aer_inject.c
>> index 5222986..fc28785 100644
>> --- a/drivers/pci/pcie/aer/aer_inject.c
>> +++ b/drivers/pci/pcie/aer/aer_inject.c
>> @@ -109,6 +109,19 @@ static struct aer_error *__find_aer_error_by_dev(struct pci_dev *dev)
>>  	return __find_aer_error((u16)domain, dev->bus->number, dev->devfn);
>>  }
>>
>> +static bool pci_is_upstream_bus(struct pci_bus *bus, struct pci_bus *up_bus)
>> +{
>> +	struct pci_bus *pbus = bus->parent;
>> +
>> +	while (pbus) {
>> +		if (pbus == up_bus)
>> +			return true;
>> +		pbus = pbus->parent;
>> +	}
>> +
>> +	return false;
>> +}
>> +
>>  /* inject_lock must be held before calling */
>>  static struct pci_ops *__find_pci_bus_ops(struct pci_bus *bus)
>>  {
>> @@ -118,6 +131,13 @@ static struct pci_ops *__find_pci_bus_ops(struct pci_bus *bus)
>>  		if (bus_ops->bus == bus)
>>  			return bus_ops->ops;
>>  	}
>> +
>> +	/* here can't find bus_ops, fall back to get bus_ops of upstream bus */
>> +	list_for_each_entry(bus_ops, &pci_bus_ops_list, list) {
>> +		if (pci_is_upstream_bus(bus, bus_ops->bus))
>> +			return bus_ops->ops;
>> +	}
>> +
>>  	return NULL;
>>  }
>>
> At least, when returning NULL, a proper check and protection is needed.
> 
Hi Chen Gong,
    Thanks for your comments. It's real dangerous when returning NULL, Since pci_read_aer/pci_write_aer functions
had no any protection codes to check it. I think maybe we can treat this situation as a read/write access error, and set *val = 0 ?
Another way here is panic system, Becasue this is a really unexpected situation.

-- 
Thanks!
Yijing

