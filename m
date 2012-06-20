Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab2FTByo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 21:54:44 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:48085 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2FTByn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 21:54:43 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1206191046000.1814-100000@iolanthe.rowland.org>
References: <CAK9wHMQ7ZLtMTfBKWOb4A8wmjP9EQV8gA_moh5dXxvU0-b-vMQ@mail.gmail.com>
	<Pine.LNX.4.44L0.1206191046000.1814-100000@iolanthe.rowland.org>
Date: Wed, 20 Jun 2012 09:54:42 +0800
Message-ID: <CAK9wHMQ6kJX06ZRjk6w_bt2HDnu=7dQEKde-Cxu8t4QbgLyTCA@mail.gmail.com>
Subject: Re: pm runtime and system suspend resume
From: chao xie <xiechao.linux@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        pavel@ucw.cz, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> hi
>> PM_RUNTIME provide a way for device driver do runtime PM. so for some
>> devices, they have some surrounded logic. For example, the device may
>> get clock from outside, or it need PHY support(USB is a example).
>> To get these dependency out of device driver, i define a struct
>> dev_pm_domain, and make dev.pm_domain point to it. So in the device
>> driver, when the hardware should be enabled, we can call
>> pm_runtime_get_sync while when the hardware is idle or does not work,
>> we can call pm_runtime_put_sync.
>> It seems work well, but i have question about the suspend/resume of
>> device. When the whole system will go to deep idle, and it will
>> suspend the devices. for the function do device suspend
>> __device_suspend,
>
> What source file is that function in?
>

The function is located at drivers/base/power/main.c

>>  it will call pm_runtime_get_noresume(dev). As i
>> think it will make the device not do runtime suspend any more. Is that
>> correct?
>
> It sounds wrong.  Why would a suspend routine do that?
>

I do knot know, but the code is there.

>> There is the question, how device driver handle the logic surrounds
>> it? I want to add pm_runtime_put_sync in dev->driver->pm->suspend
>> function, and pm_runtime_get_sync in dev->driver->pm->resume.
>
> You must not do that.  If you do, your driver will hang.
>

why it will hang?

>> Because
>> __device_suspend increase the usage_count, pm_runtime_put_sync will
>> not do real work.
>> So is that right that i directly call pm_runtime_suspend in
>> dev->driver->pm->suspend and pm_runtime_resume in
>> dev->driver->pm->resume?
>
> No, it works the other way around.  pm_runtime_suspend calls
> dev->driver->pm->suspend, and pm_runtime_resume calls
> dev->driver->pm->resume.
>

I have checked the pm_runtime_suspend implementation. It will call
__pm_runtime_suspend without RPM_GET_PUT. It means that it will
directly call rpm_suspend. in this function, the pm_ops call sequence
is
if (dev->pm_domain)
               callback = dev->pm_domain->ops.runtime_suspend;
       else if (dev->type && dev->type->pm)
               callback = dev->type->pm->runtime_suspend;
       else if (dev->class && dev->class->pm)
               callback = dev->class->pm->runtime_suspend;
       else if (dev->bus && dev->bus->pm)
               callback = dev->bus->pm->runtime_suspend;
       else
               callback = NULL;

       if (!callback && dev->driver && dev->driver->pm)
               callback = dev->driver->pm->runtime_suspend;

It means that if dev->pm_domain is not NULL, it will not call
dev->driver->pm operations.

Finally the real question is who will deal with the dev->pm_domain?
when system go to sleep.
The driver will use pm_runtime_get/put to deal with dev->pm_domain
when it want to work or is in idle. Then when system go to sleep, the
driver need care about dev->pm_domain too.
Usally, dev->pm_domain is a easy way to handle the difference SOCs
with same device IP. For example, USB. Many vendor may have same usb
IP but difference phy and clock configuration. putting these stuff
into dev->pm_domain can make driver be shared by different SOCs.

> Alan Stern
>
