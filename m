Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab1ERF6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 01:58:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35695 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab1ERF6h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 01:58:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gr9ZBP3JXFYHYFunIlxf/AG1MpKudyiLU/5Z/79mlytajtZVGcoItB23e6J31AthLI
         XeUKGXRXKZoN7PICdQ/HPzBz+gigPJBOZ8y+5HkYvXPDAKl+iuFAZqgbTGG60hUpzlRr
         3NNyGFt0qFVp769rFban+qGHnwtiSi/ryxOUc=
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <201105172252.32135.rjw@sisk.pl>
References: <20110512061928.GB2460@localhost.ucw.cz>
	<1305608346-23800-1-git-send-email-myungjoo.ham@samsung.com>
	<1305608346-23800-2-git-send-email-myungjoo.ham@samsung.com>
	<201105172252.32135.rjw@sisk.pl>
Date: Wed, 18 May 2011 14:58:36 +0900
X-Google-Sender-Auth: 9Cu4W9Mu2sPEsS25IQGlqBQk9bM
Message-ID: <BANLkTinWF108dOaL-u7Y9vU9Z5X-vSn8zQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] PM / Core: partial resume/suspend API for
 suspend_again users.
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>, kyungmin.park@samsung.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/18 Rafael J. Wysocki <rjw@sisk.pl>:
> On Tuesday, May 17, 2011, MyungJoo Ham wrote:
>> A usage example is:
>>
>> bool example_suspend_again(void)
>> {
>>       int error, monitor_result;
>>
>>       if (!wakeup_reason_is_polling())
>>               return false;
>>
>>       dpm_partial_resume(PMSG_RESUME, devs, ARRAY_SIZE(devs));
>
> I'm not sure you need the first argument here.  Also, if the array is
> NULL terminated, you won't need the third one.
>

It was to pass the parameter to device_resume(), pm_dev_err(),
device_complete(), and device_prepare(), which have been using the
state value. However, as it is supposed to be used in the context of
suspend_devices_and_enter(), I'll remove it and assume PMSG_SUSPEND
and PMSG_RESUME are in effect.

For the array style, do we generally prefer to use NULL at the end
rather than supplying the size? If so, I'll change the array style.

>>       resume_console();
>>
>>       monitor_result = monitor_something();
>>
>>       suspend_console();
>>       error = dpm_partial_suspend(PMSG_SUSPEND, devs, ARRAY_SIZE(devs));
>
> Same here.
>
>>       if (error || monitor_result == ERROR)
>>               return false;
>>
>>       return true;
>> }
>
> That said, I don't like this patch.  The reason is that you call
> suspend_enter() is a loop and it calls the _noirq() callbacks for
> _all_ devices and now you're going to only call .resume() and
> .suspend() for several selected devices.  This is not too consistent.
>
> I wonder if those devices needed for .suspend_again() to work on
> your platform could be resumed and suspended by their drivers'
> _noirq() callbacks?

For now, we need to access PMIC, Fuel-Gauge, Charger (implemented as
regulators), RTC, ADC (w/ hwmon), and UART(drivers/tty/serial).
For PMIC, Fuel-Gauge, Charger, and RTC, they will work with no_irq
callbacks without any modification.
ADC will work if we just let it suspend and resume with no_irq callbacks.

However, for UART/serial, although it is only used for debugging, it
wouldn't be easy and clean to enable only with no_irq callbacks. If we
can keep observing the console with suspend_console_enabled=0, it
would be much helpful.
In order to let some UART/serial drivers work with no-irq callbacks,
we'd need reconstruction in drivers/tty/serial/serial_core.c, too.

Anyway, as the effect of not having partial suspend/resume is limited
for now (support for UART/serial can wait), I may defer this part and
wait for better and clean methods. And yes, because of the possibility
of having dependencies between devices, the inconsistency you've
mentioned could be an issue for some systems. However, because such
dependencies are not explicitly expressed to kernel while the platform
should know about them, partial_suspend/resume was supposed to be
called by the platform's suspend_again ops.

>
> Rafael
>
>


Cheers!

- MyungJoo
-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
