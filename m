Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab2HEQ4t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 12:56:49 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46901 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab2HEQ4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 12:56:44 -0400
MIME-Version: 1.0
In-Reply-To: <501E9DDB.3020807@gmail.com>
References: <1333777207-4151-1-git-send-email-olof@lixom.net>
	<20120407070206.GA17623@core.coreip.homeip.net>
	<4F8089A9.6080704@raumfeld.com>
	<20120503043651.GA11830@core.coreip.homeip.net>
	<20120713070102.GA2223@core.coreip.homeip.net>
	<500561AF.9090901@gmail.com>
	<5008296C.5070709@gmail.com>
	<20120723165120.GB26577@core.coreip.homeip.net>
	<500EE314.7040708@gmail.com>
	<501E9DDB.3020807@gmail.com>
Date: Mon, 6 Aug 2012 00:56:42 +0800
Message-ID: <CAN1soZy-_MdjqS3r3Tc1XET6tPzMxDqjYq3Tn0fYLBNNUkdVAg@mail.gmail.com>
Subject: Re: Emulating level IRQs
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Daniel Mack <zonque@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sven Neumann <s.neumann@raumfeld.com>, Olof Johansson <olof@lixom.net>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 12:22 AM, Daniel Mack <zonque@gmail.com> wrote:
> On 24.07.2012 20:01, Daniel Mack wrote:
>> On 23.07.2012 18:51, Dmitry Torokhov wrote:
>>> On Thu, Jul 19, 2012 at 05:36:12PM +0200, Daniel Mack wrote:
>>
>>>> Ok, finally I found some time. In general, the patch works fine. The
>>>> only detail I had to amend was the irqflags, which were changed from
>>>> IRQF_TRIGGER_RISING/IRQF_TRIGGER_FALLING to
>>>> IRQF_TRIGGER_HIGH/IRQF_TRIGGER_LOW, which doesn't work as the PXA can't
>>>> deal with level-based IRQs. Changing this back to RISING/FALLING makes
>>>> the driver work again.
>>>
>>> Hmm, but that would mean we need to restore reading the data in open()
>>> to make sure we re-arm IRQ in case somebody touched the screen before it
>>> was opened by userspace...
>>
>> I had another look at this and don't really know what to do here. We
>> definitely need level interrupts for this device as the interrupt line's
>> level is the only that tells us when we can stop reading from the
>> device. So it's not just the start condition that bites us here.
>>
>> I copied some people that might help find a solution.
>>
>> To summarize the problem: The EETI touchscreen is a device that asserts
>> a GPIO line when it has events to deliver and waits for I2C commands to
>> empty its buffers. When there are no more buffered events, it will
>> de-assert the line.
>>
>> This device is connected to a PXA GPIO that is only able to deliver edge
>> IRQs, and the old implemenation was to wait for an interrupt and then
>> read data as long as the IRQ's corresponding GPIO was asserted. However,
>> expecting that an IRQ is mappable to a GPIO is not something we should
>> do, so the only clean solution is to teach the PXA GPIO controller level
>> IRQs.
>>
>> So it boils down to the question: Is there any easy and generic way to
>> emulate level irq on chips that don't support that natively?
>
> Otherwise, we would need some sort of generic irq_to_gpio() again, and
> the interrupt line the driver listens to must have support for that sort
> of mapping.
>
> Any opinion on this, anyone?
>
Since you're using gpio as input, you need to call gpio_request() and set it
as input direction. And you could also transfer the gpio number into touch
driver via platform data. Is it OK for you?

Regards
Haojian
