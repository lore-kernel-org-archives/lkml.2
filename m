Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab2GXSCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 14:02:30 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51670 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932417Ab2GXSCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 14:02:20 -0400
Message-ID: <500EE314.7040708@gmail.com>
Date: Tue, 24 Jul 2012 20:01:56 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Sven Neumann <s.neumann@raumfeld.com>, Olof Johansson <olof@lixom.net>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Emulating level IRQs (was: Re: [PATCH] Input: eeti_ts: Mark as CONFIG_BROKEN)
References: <1333777207-4151-1-git-send-email-olof@lixom.net> <20120407070206.GA17623@core.coreip.homeip.net> <4F8089A9.6080704@raumfeld.com> <20120503043651.GA11830@core.coreip.homeip.net> <20120713070102.GA2223@core.coreip.homeip.net> <500561AF.9090901@gmail.com> <5008296C.5070709@gmail.com> <20120723165120.GB26577@core.coreip.homeip.net>
In-Reply-To: <20120723165120.GB26577@core.coreip.homeip.net>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.07.2012 18:51, Dmitry Torokhov wrote:
> On Thu, Jul 19, 2012 at 05:36:12PM +0200, Daniel Mack wrote:

>> Ok, finally I found some time. In general, the patch works fine. The
>> only detail I had to amend was the irqflags, which were changed from
>> IRQF_TRIGGER_RISING/IRQF_TRIGGER_FALLING to
>> IRQF_TRIGGER_HIGH/IRQF_TRIGGER_LOW, which doesn't work as the PXA can't
>> deal with level-based IRQs. Changing this back to RISING/FALLING makes
>> the driver work again.
> 
> Hmm, but that would mean we need to restore reading the data in open()
> to make sure we re-arm IRQ in case somebody touched the screen before it
> was opened by userspace...

I had another look at this and don't really know what to do here. We
definitely need level interrupts for this device as the interrupt line's
level is the only that tells us when we can stop reading from the
device. So it's not just the start condition that bites us here.

I copied some people that might help find a solution.

To summarize the problem: The EETI touchscreen is a device that asserts
a GPIO line when it has events to deliver and waits for I2C commands to
empty its buffers. When there are no more buffered events, it will
de-assert the line.

This device is connected to a PXA GPIO that is only able to deliver edge
IRQs, and the old implemenation was to wait for an interrupt and then
read data as long as the IRQ's corresponding GPIO was asserted. However,
expecting that an IRQ is mappable to a GPIO is not something we should
do, so the only clean solution is to teach the PXA GPIO controller level
IRQs.

So it boils down to the question: Is there any easy and generic way to
emulate level irq on chips that don't support that natively?


Daniel





