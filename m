Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1IGRUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:20:07 -0400
Received: from smtp-out.google.com ([74.125.121.67]:52257 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab1IGRUF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:20:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Kyi/T/vZjP84HWZ0PzdjqTfzpQk0ZDDy0/xZajCSPI13UU+wOQJ96FY3oKmo6C2Rn
	mrmpUZCVCOFYR9+VlXVjg==
MIME-Version: 1.0
In-Reply-To: <4E66D988.9070505@huawei.com>
References: <F1F5DF04259F1B4A82BD6BDE1C479F74098285B0@szxeml527-mbx.china.huawei.com>
 <CAErSpo4JsyHag24SH=zSRHt4c8kYwdcXEnCConGEi2u6dN-pnw@mail.gmail.com>
 <4E65C254.8090107@huawei.com> <CAErSpo5owGuYLP2-JR6uJsM+Pqwna+FUB--p4OhjLVAETqYpcw@mail.gmail.com>
 <4E66D988.9070505@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 6 Sep 2011 23:57:57 -0700
Message-ID: <CAErSpo7Rf+X3MVgmdYvbEXw-UAU7sEEMq5upBkhEn9Eu0zD-zw@mail.gmail.com>
Subject: Re: Re : [PATCH] acpi: Fix hot cpu remove problem on acpi subsystem
To: "canquan.shen" <shencanquan@huawei.com>
Cc: len.brown@intel.com, "shemminger@vyatta.com" <shemminger@vyatta.com>,
        "yakui.zhao@intel.com" <yakui.zhao@intel.com>,
        "xiaowei.yang@huawei.com" <xiaowei.yang@huawei.com>,
        hanweidong <hanweidong@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        linqiangmin@huawei.com, james.chenjiabo@huawei.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 6, 2011 at 7:40 PM, canquan.shen <shencanquan@huawei.com> wrote:
> On 2011/9/7 2:38, Bjorn Helgaas wrote:

>> Is acpi_processor_remove() called when you remove a processor?  I see
>> a path where it will be called via acpi_eject_store():
>>
>>     acpi_eject_store
>>       acpi_os_hotplug_execute(acpi_bus_hot_remove_device)
>>       acpi_bus_hot_remove_device
>>         acpi_bus_trim
>>           acpi_bus_remove
>>             device_release_driver
>>               dev->driver->remove (acpi_processor_remove())
>>             acpi_device_unregister
>>               device_unregister
>>                 device_del
>>                   kobject_uevent(KOBJ_REMOVE)
>>
>> but as far as I can tell, this path is only used when we write
>> something to the "eject" sysfs file.  I would think we'd want to use
>> most of this same path when we hot remove a CPU via the ACPI SCI
>> mechanism.
>>
>
> Because in my patch will send the KOBJ_REMOVE event to udev module. and I
> write a udev rule like the following:
> ACTION=="remove",DRIVER=="processor",SUBSYSTEM=="acpi",RUN+="/bin/bash -c
> 'echo 1 > /sys%p/eject'"
> This rule will write "1" to the "eject" sysfs file. and then call
> acpi_eject_store function.

Hmmm.  I think I understand your proposal, but it seems like a
convoluted path to me.

I guess the real question is whether we must give userspace a chance
to decide whether to actually do the remove or not.  Is there a
requirement to do that?  Neither the dynamic device removal flow (ACPI
spec 4.0a, sec 6.3) nor the ejection flow example (fig 6-5) mentions
doing that.

I mentioned before that I think the ACPI hotplug code should be ripped
out of the drivers and consolidated in the ACPI core.  I think it's
pretty clear from the spec that the 0-0x7f notifications (Bus Check,
Device Check, Eject Request, etc.) are designed to be handled by the
core, not by individual drivers.  We handle hotplug in the drivers
today, but I think that's mainly because we never implemented support
in the Linux ACPI core.  There are comments in acpi_bus_check_device()
and acpi_bus_check_scope() about what we *should* be doing there.

I am opposed to adding more hotplug support to individual drivers
because I still hope that someday we'll support it in the ACPI core.
Many ACPI drivers don't support hotplug at all, and the ones that do
support hotplug do it in a variety of ways.  It's all quite a mess.

Bjorn
