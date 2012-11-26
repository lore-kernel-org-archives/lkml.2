Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab2KZFnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 00:43:10 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:64826 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab2KZFnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 00:43:08 -0500
Message-ID: <50B3014E.3040107@huawei.com>
Date: Mon, 26 Nov 2012 13:42:38 +0800
From: Hanjun Guo <guohanjun@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Tang Chen <tangchen@cn.fujitsu.com>, <yinghai@kernel.org>,
        <bhelgaas@google.com>, <lenb@kernel.org>, <jiang.liu@huawei.com>,
        <izumi.taku@jp.fujitsu.com>, <linux-acpi@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Wen Congyang <wency@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH v3 0/3] ACPI: container hot remove support.
References: <1351668471-31436-1-git-send-email-tangchen@cn.fujitsu.com> <509106E2.70008@jp.fujitsu.com>
In-Reply-To: <509106E2.70008@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.25]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/10/31 19:09, Yasuaki Ishimatsu wrote:
> Hi Tang,
> 
> 2012/10/31 16:27, Tang Chen wrote:
>> Hi,
>>
>> The container hotplug handler container_notify_cb() didn't implement
>> the hot-remove functionality. So, these 3 patches implement it like
>> the following way:
>>
>> patch 1. Do not use kacpid_wq/kacpid_notify_wq to handle container hotplug event,
>>           use kacpi_hotplug_wq instead to avoid deadlock.
>>           Doing this is to reuse acpi_bus_hot_remove_device() in container
>>           hot-remove handling.
>>
>> patch 2. Introduce a new function container_device_remove() to handle
>>           ACPI_NOTIFY_EJECT_REQUEST event for container.
> 
> If container device contains memory device, the function is 
> very danger. As you know, we are developing a memory hotplug.
> If memory has kernel memory, memory hot remove operations fails.
> But container_device_remove() cannot realize it. So even if
> the memory hot remove operation fails, container_device_remove()
> keeps hot remove operation. Finally, the function sends _EJ0
> to firmware. In this case, if the memory is accessed, kernel
> panic occurs.

Hi all,
I think Yasuaki mentioned the key point for the container device remove,
that is dependency.

Currently, container, processor, and memory hotpulg are managed by different ACPI
hotplug drivers, the driver works when handle device hotplug individually, but they
have no idea for each other.

This may introduce some issues, such as Yasuaki mentioned above, that is to say, we
should remove its child before remove the device itself, and hot add its parent before
the device itself.

According to the ACPI namespace, we can resolve most of dependency issues. On a typical
two processor sockets system, the namespace is like this:

/_SB                   ---container device, with HID ACPI0004
    |_SCK0             ---container device, with HID ACPI0004
	  |_CPU0       ---processor device, with HID ACPI0009 or LNXCPU
          |_...
          |_CPUx
          |_MEM0       ---Memory device, with HID PNP0C80
    |_SCK1
	  |_CPU0
          |_...
          |_CPUx
          |_MEM1
    |_PCI0            ---Host bridge, with HID PNP0A03 or PNP0A08

If hot remove the container device, such as SCK0, we can easily know the dependency list
is CPU0~CPUx and MEM0, but I think the ACPI hotplug driver haven't resolve this now.

And there is another corner case for hotplug devices in the namespace above, that is:
1) Remove SCK0. yes, we can remove it with no dependency to the host bridge PCI0;

2) Remove SCK1 after SCK0. we should remove the host bridge PCI0 first,
   or the system will crash down. yes, dynamic dependency analysis is needed here.
   and the ACPI hotplug driver totally have no idea of this.

so, should we do something to settle this down ?

Thanks
Hanjun Guo


> The example is as follows:
> 
>  https://lkml.org/lkml/2012/9/26/318
> 
> Thanks,
> Yasuaki Ishimatsu
> 
>>



