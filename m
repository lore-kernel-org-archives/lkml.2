Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab2JZHeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 03:34:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40011 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554Ab2JZHeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 03:34:16 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <508A3CDD.20506@jp.fujitsu.com>
Date: Fri, 26 Oct 2012 16:33:49 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <toshi.kani@hp.com>, <lenb@kernel.org>,
        <wency@cn.fujitsu.com>, <vasilis.liaskovitis@profitbricks.com>
Subject: Re: [PATCH v2] acpi : acpi_bus_trim() stops removing devices when
 failing to remove the device
References: <50769B8C.2060901@jp.fujitsu.com> <1846185.MSykHDcMmb@vostro.rjw.lan> <20121019175941.GB3375@kroah.com>
In-Reply-To: <20121019175941.GB3375@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Sorry for late reply.

2012/10/20 2:59, Greg Kroah-Hartman wrote:
> On Fri, Oct 19, 2012 at 06:29:52AM +0200, Rafael J. Wysocki wrote:
>> On Thursday 11 of October 2012 19:12:28 Yasuaki Ishimatsu wrote:
>>> acpi_bus_trim() stops removing devices, when acpi_bus_remove() return error
>>> number. But acpi_bus_remove() cannot return error number correctly.
>>> acpi_bus_remove() only return -EINVAL, when dev argument is NULL. Thus even if
>>> device cannot be removed correctly, acpi_bus_trim() ignores and continues to
>>> remove devices. acpi_bus_hot_remove_device() uses acpi_bus_trim() for removing
>>> devices. Therefore acpi_bus_hot_remove_device() can send "_EJ0" to firmware,
>>> even if the device is running on the system. In this case, the system cannot
>>> work well.
>>>
>>> Vasilis hit the bug at memory hotplug and reported it as follow:
>>> https://lkml.org/lkml/2012/9/26/318
>>>
>>> So acpi_bus_trim() should check whether device was removed or not correctly.
>>> The patch adds error check into some functions to remove the device.
>>>
>>> Applying the patch, acpi_bus_trim() stops removing devices when failing
>>> to remove the device. But I think there is no impact with the
>>> exceptionof CPU and Memory hotplug path. Because other device also fails
>>> but the fail is an irregular case like device is NULL.
>>>
>>> v1->v2
>>> - add a rollback for reinstalling a notify handler.
>>>
>>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>
>> Greg, do you think there may be any problems with the changes in dd.c?
>
> Yes, I don't like it.
>
> remove should always work, just like the exit call in a module.  It
> means that the core wants to remove the driver, so it is going to
> happen, a driver can't refuse it.
>
> Which brings me to the larger question, why would this solve anything?

Now we are developing physical memory hot plug.

https://lkml.org/lkml/2012/10/23/213

So if we aplly the patch-set, we can hot remove a physical memory
by the following way.

"echo 1 > /sys/bus/acpi/devices/PNP/eject"

In this case, acpi_bus_hot_remove_device() tries to remove memory
device by acpi_bus_trim(). But if the memory has irremovable memory,
memory hot remove fails. And the memory remains in kernel.
However acpi_bus_trim() cannot notice that memory hot remove fails and
retruns 0. So acpi_bus_hot_remove_device() continues to remove memory
devices and sends _EJ0 method to firmware. Thus the memory device cannot
be used. But the memory remains in kernel yet. So if someone access the
memory, kernel panic occurs.

Thanks,
Yasuaki Ishimatsu

> If the kernel wants to unbind a device, why would we ever not want that
> to happen?
>
> So, NAK on this patch, sorry.  Fix up the ACPI core to handle this
> properly, don't mess with the driver core here.
>
> greg k-h
>


