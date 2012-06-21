Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab2FUBbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 21:31:50 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47500 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676Ab2FUBbs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 21:31:48 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1206201031590.1804-100000@iolanthe.rowland.org>
References: <CAK9wHMQ6kJX06ZRjk6w_bt2HDnu=7dQEKde-Cxu8t4QbgLyTCA@mail.gmail.com>
	<Pine.LNX.4.44L0.1206201031590.1804-100000@iolanthe.rowland.org>
Date: Thu, 21 Jun 2012 09:31:47 +0800
Message-ID: <CAK9wHMS_P+y+NmvVVrH+nNOb=KPi3rEgJOWEcRcKf3mTkxjDPA@mail.gmail.com>
Subject: Re: pm runtime and system suspend resume
From: chao xie <xiechao.linux@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        pavel@ucw.cz, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/20 Alan Stern <stern@rowland.harvard.edu>:
> On Wed, 20 Jun 2012, chao xie wrote:
>
>> >> It seems work well, but i have question about the suspend/resume of
>> >> device. When the whole system will go to deep idle, and it will
>> >> suspend the devices. for the function do device suspend
>> >> __device_suspend,
>> >
>> > What source file is that function in?
>> >
>>
>> The function is located at drivers/base/power/main.c
>>
>> >>  it will call pm_runtime_get_noresume(dev). As i
>> >> think it will make the device not do runtime suspend any more. Is that
>> >> correct?
>> >
>> > It sounds wrong.  Why would a suspend routine do that?
>> >
>>
>> I do knot know, but the code is there.
>
> Okay, now I understand your question.  The problem is that system
> suspend uses a separate mechanism from runtime suspend, and we don't
> want the two things to happen at the same time.  Therefore
> __device_suspend does a get_noresume in order to prevent runtime
> suspend from occurring in the middle of a system suspend.
>
>> >> There is the question, how device driver handle the logic surrounds
>> >> it? I want to add pm_runtime_put_sync in dev->driver->pm->suspend
>> >> function, and pm_runtime_get_sync in dev->driver->pm->resume.
>> >
>> > You must not do that.  If you do, your driver will hang.
>> >
>>
>> why it will hang?
>
> Sorry, I misunderstood your question.  It will not hang.  But why do
> you want to add those calls?
>
>> >> Because
>> >> __device_suspend increase the usage_count, pm_runtime_put_sync will
>> >> not do real work.
>> >> So is that right that i directly call pm_runtime_suspend in
>> >> dev->driver->pm->suspend and pm_runtime_resume in
>> >> dev->driver->pm->resume?
>
> No, don't call pm_runtime_suspend.  Just call your driver's
> runtime_suspend routine directly.  Same for resume.
>
>> Finally the real question is who will deal with the dev->pm_domain?
>> when system go to sleep.
>
> The __device_suspend routine in drivers/base/main.c uses
> dev->pm_domain.
>

I check the code, __device_suspend will invoke dev->pm_domain->ops
first if dev->pm_domain is not NULL.
Taking "suspend" as esample, i can do the following things in the
dev->pm_domain->ops->suspend
1. invoke dev->driver->pm->suspend for suspending the device
2. do what we do in dev->pm_domain->ops->runtime_suspend for
suspending the surrounded logic, for example, shutdown the phy or
clocks.
So is above implementation fine?


>> The driver will use pm_runtime_get/put to deal with dev->pm_domain
>> when it want to work or is in idle. Then when system go to sleep, the
>> driver need care about dev->pm_domain too.
>> Usally, dev->pm_domain is a easy way to handle the difference SOCs
>> with same device IP. For example, USB. Many vendor may have same usb
>> IP but difference phy and clock configuration. putting these stuff
>> into dev->pm_domain can make driver be shared by different SOCs.
>
> Alan Stern
>
