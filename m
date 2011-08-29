Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab1H2Sgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 14:36:42 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:49553 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754379Ab1H2Sgj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 14:36:39 -0400
From: Kevin Hilman <khilman@ti.com>
To: Todd Poynor <toddpoynor@google.com>
Cc: "Munegowda\, Keshava" <keshava_mgowda@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        gadiyar@ti.com, sameo@linux.intel.com, parthab@india.ti.com,
        tony@atomide.com, b-cousson@ti.com, paul@pwsan.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com, nm@ti.com,
        vikram.pandita@ti.com
Subject: Re: [PATCH 5/5 v4] mfd: omap: usb: Runtime PM support
Organization: Texas Instruments, Inc.
References: <1312899309-24067-1-git-send-email-keshava_mgowda@ti.com>
	<1312899309-24067-2-git-send-email-keshava_mgowda@ti.com>
	<1312899309-24067-3-git-send-email-keshava_mgowda@ti.com>
	<1312899309-24067-4-git-send-email-keshava_mgowda@ti.com>
	<1312899309-24067-5-git-send-email-keshava_mgowda@ti.com>
	<1312899309-24067-6-git-send-email-keshava_mgowda@ti.com>
	<20110810163142.GA10156@google.com>
	<CAP05o4L+qn4K=jLx5Jo8WsG7LnU=VniQSR+fLc=RM5mW4kP1OQ@mail.gmail.com>
	<20110812213037.GA24803@google.com>
Date: Mon, 29 Aug 2011 11:36:34 -0700
In-Reply-To: <20110812213037.GA24803@google.com> (Todd Poynor's message of
	"Fri, 12 Aug 2011 14:30:37 -0700")
Message-ID: <874o10t68d.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Todd Poynor <toddpoynor@google.com> writes:

> On Fri, Aug 12, 2011 at 12:20:21PM +0530, Munegowda, Keshava wrote:
>> On Wed, Aug 10, 2011 at 10:01 PM, Todd Poynor <toddpoynor@google.com> wrote:
>> >> @@ -913,12 +598,15 @@ static int usbhs_enable(struct device *dev)
>> >>                               (pdata->ehci_data->reset_gpio_port[1], 1);
>> >>       }
>> >>
>> >> -end_count:
>> >> -     omap->count++;
>> >> +     pm_runtime_put_sync(dev);
>> >>       spin_unlock_irqrestore(&omap->lock, flags);
>> >
>> > Is pm_runtime_irq_safe() needed (else I think runtime PM callbacks may
>> > re-enable IRQs... or there's the new *_suspend runtime PM calls that
>> > may avoid this)?
>> 
>>  pm_runtime_irq_safe()  is not required; usbhs does not have a parent
>> and it is the parent driver of
>> ehci and ohci drivers.
>
> But the above expects IRQs to be disabled during the
> pm_runtime_put_sync, and synchronous calls can turn IRQs back on in
> rpm_idle:
>
>         if (callback) {
>                 spin_unlock_irq(&dev->power.lock);
>
>                 callback(dev);
>
> I see other folks who know this better than me are discussing USB run
> time PM and might_sleep contexts, so I'll note this concern and let
> others chime in if they think there's a real problem here.

FYI... The commit below fixes this mainline (merged as of v3.1-rc4).

Kevin


commit 02b26774afebb2d62695ba3230319d70d8c6cc2d
Author: Kevin Hilman <khilman@ti.com>
Date:   Fri Aug 5 21:45:20 2011 +0200

    PM / Runtime: Allow _put_sync() from interrupts-disabled context
    
    Currently the use of pm_runtime_put_sync() is not safe from
    interrupts-disabled context because rpm_idle() will release the
    spinlock and enable interrupts for the idle callbacks.  This enables
    interrupts during a time where interrupts were expected to be
    disabled, and can have strange side effects on drivers that expected
    interrupts to be disabled.
    
    This is not a bug since the documentation clearly states that only
    _put_sync_suspend() is safe in IRQ-safe mode.
    
    However, pm_runtime_put_sync() could be made safe when in IRQ-safe
    mode by releasing the spinlock but not re-enabling interrupts, which
    is what this patch aims to do.
    
    Problem was found when using some buggy drivers that set
    pm_runtime_irq_safe() and used _put_sync() in interrupts-disabled
    context.
    
    Reported-by: Colin Cross <ccross@google.com>
    Tested-by: Nishanth Menon <nm@ti.com>
    Signed-off-by: Kevin Hilman <khilman@ti.com>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

