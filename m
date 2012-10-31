Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934292Ab2JaKxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 06:53:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39551 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932448Ab2JaKxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 06:53:32 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50910306.2030205@jp.fujitsu.com>
Date: Wed, 31 Oct 2012 19:52:54 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <toshi.kani@hp.com>, <lenb@kernel.org>,
        <wency@cn.fujitsu.com>, <vasilis.liaskovitis@profitbricks.com>
Subject: Re: [PATCH v2] acpi : acpi_bus_trim() stops removing devices when
 failing to remove the device
References: <50769B8C.2060901@jp.fujitsu.com> <1846185.MSykHDcMmb@vostro.rjw.lan> <20121019175941.GB3375@kroah.com> <508A3CDD.20506@jp.fujitsu.com> <20121026152544.GC15840@kroah.com>
In-Reply-To: <20121026152544.GC15840@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

2012/10/27 0:25, Greg Kroah-Hartman wrote:
> On Fri, Oct 26, 2012 at 04:33:49PM +0900, Yasuaki Ishimatsu wrote:
>> Hi Greg,
>>
>> Sorry for late reply.
>>
>> 2012/10/20 2:59, Greg Kroah-Hartman wrote:
>>> On Fri, Oct 19, 2012 at 06:29:52AM +0200, Rafael J. Wysocki wrote:
>>>> On Thursday 11 of October 2012 19:12:28 Yasuaki Ishimatsu wrote:
>>>>> acpi_bus_trim() stops removing devices, when acpi_bus_remove() return error
>>>>> number. But acpi_bus_remove() cannot return error number correctly.
>>>>> acpi_bus_remove() only return -EINVAL, when dev argument is NULL. Thus even if
>>>>> device cannot be removed correctly, acpi_bus_trim() ignores and continues to
>>>>> remove devices. acpi_bus_hot_remove_device() uses acpi_bus_trim() for removing
>>>>> devices. Therefore acpi_bus_hot_remove_device() can send "_EJ0" to firmware,
>>>>> even if the device is running on the system. In this case, the system cannot
>>>>> work well.
>>>>>
>>>>> Vasilis hit the bug at memory hotplug and reported it as follow:
>>>>> https://lkml.org/lkml/2012/9/26/318
>>>>>
>>>>> So acpi_bus_trim() should check whether device was removed or not correctly.
>>>>> The patch adds error check into some functions to remove the device.
>>>>>
>>>>> Applying the patch, acpi_bus_trim() stops removing devices when failing
>>>>> to remove the device. But I think there is no impact with the
>>>>> exceptionof CPU and Memory hotplug path. Because other device also fails
>>>>> but the fail is an irregular case like device is NULL.
>>>>>
>>>>> v1->v2
>>>>> - add a rollback for reinstalling a notify handler.
>>>>>
>>>>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>>>
>>>> Greg, do you think there may be any problems with the changes in dd.c?
>>>
>>> Yes, I don't like it.
>>>
>>> remove should always work, just like the exit call in a module.  It
>>> means that the core wants to remove the driver, so it is going to
>>> happen, a driver can't refuse it.
>>>
>>> Which brings me to the larger question, why would this solve anything?
>>
>> Now we are developing physical memory hot plug.
>>
>> https://lkml.org/lkml/2012/10/23/213
>>
>> So if we aplly the patch-set, we can hot remove a physical memory
>> by the following way.
>>
>> "echo 1 > /sys/bus/acpi/devices/PNP/eject"
>>
>> In this case, acpi_bus_hot_remove_device() tries to remove memory
>> device by acpi_bus_trim(). But if the memory has irremovable memory,
>> memory hot remove fails. And the memory remains in kernel.
>> However acpi_bus_trim() cannot notice that memory hot remove fails and
>> retruns 0. So acpi_bus_hot_remove_device() continues to remove memory
>> devices and sends _EJ0 method to firmware. Thus the memory device cannot
>> be used. But the memory remains in kernel yet. So if someone access the
>> memory, kernel panic occurs.
>
> Why can't you check to find out if you can do the remove operation
> before you enter the driver core asking to actually remove the devices?
> That would allow you to "know" if you can do this before having to go
> through the whole operation.  What happens if you can complete half of
> the removal, and do that, but not the whole thing?  Don't you end up
> with half of the memory chunk gone from the system now?
>

> In other words, please solve this at a higher level than the driver
> core if at all possible.

O.K.
I'll check whether the problem is sloved at a higher level or not.

Thanks,
Yasuaki Ishimatsu

>
> greg k-h
>


