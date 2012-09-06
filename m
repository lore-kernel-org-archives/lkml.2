Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab2IFFsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 01:48:33 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:50492 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751908Ab2IFFsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 01:48:30 -0400
MIME-Version: 1.0
In-Reply-To: <20120906130510.32b0b877@notabene.brown>
References: <20120825214459.7333a376@notabene.brown> <CAMQu2gz0-U4GxEpZFfmJec+0FRs7ugy8EYS3HyYhb1jwbMBjug@mail.gmail.com>
 <20120827085312.75957354@notabene.brown> <CAMQu2gwH0O+NHV7H2aF375qmv0=TKb6RweOLohTHtB4UhQ-1gQ@mail.gmail.com>
 <CAMQu2gw2b8HHDPuSRuHXVYn3sJ5BYi_PuOT=snpa3zD5ert=QQ@mail.gmail.com> <20120906130510.32b0b877@notabene.brown>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Thu, 6 Sep 2012 11:18:09 +0530
Message-ID: <CAMQu2gxGNJ+NW_rcRiXNE=OMTq8Hb81_1hDZnNen6mjc2cf6BQ@mail.gmail.com>
Subject: Re: [PATCH] OMAP GPIO - don't wake from suspend unless requested.
To: NeilBrown <neilb@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>,
        Kevin Hilman <khilman@ti.com>, Tony Lindgren <tony@atomide.com>,
        Cousson@suse.de, Benoit <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>,
        linux-omap@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Jon Hunter <jon-hunter@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 6, 2012 at 8:35 AM, NeilBrown <neilb@suse.de> wrote:
> On Mon, 3 Sep 2012 22:59:06 -0700 "Shilimkar, Santosh"
> <santosh.shilimkar@ti.com> wrote:
>
>> On Sun, Aug 26, 2012 at 6:29 PM, Shilimkar, Santosh
>> <santosh.shilimkar@ti.com> wrote:
>> > On Sun, Aug 26, 2012 at 3:53 PM, NeilBrown <neilb@suse.de> wrote:
>> >>
>> >> On Sun, 26 Aug 2012 09:47:50 +0530 "Shilimkar, Santosh"
>> >> <santosh.shilimkar@ti.com> wrote:
>> >>
>> >> > + Jon,
>> >> >
>> >> > On Sat, Aug 25, 2012 at 5:14 PM, NeilBrown <neilb@suse.de> wrote:
>> >> > >
>> >> > >
>> >> > >
>> >> > > Current kernel will wake from suspend on an event on any active
>> >> > > GPIO even if enable_irq_wake() wasn't called.
>> >> > >
>> >> > > There are two reasons that the hardware wake-enable bit should be set:
>> >> > >
>> >> > > 1/ while non-suspended the CPU might go into a deep sleep (off_mode)
>> >> > >   in which the wake-enable bit is needed for an interrupt to be
>> >> > >   recognised.
>> >> > > 2/ while suspended the GPIO interrupt should wake from suspend if and
>> >> > >    only if irq_wake as been enabled.
>> >> > >
>> >> > > The code currently doesn't keep these two reasons separate so they get
>> >> > > confused and sometimes the wakeup flags is set incorrectly.
>> >> > >
>> >> > > This patch reverts:
>> >> > >  commit 9c4ed9e6c01e7a8bd9079da8267e1f03cb4761fc
>> >> > >     gpio/omap: remove suspend/resume callbacks
>> >> > > and
>> >> > >  commit 0aa2727399c0b78225021413022c164cb99fbc5e
>> >> > >     gpio/omap: remove suspend_wakeup field from struct gpio_bank
>> >> > >
>> >> > > and makes some minor changes so that we have separate flags for "GPIO
>> >> > > should wake from deep idle" and "GPIO should wake from suspend".
>> >> > >
>> >> > > With this patch, the GPIO from my touch screen doesn't wake my device
>> >> > > any more, which is what I want.
>> >> > >
>> >> > > Cc: Kevin Hilman <khilman@ti.com>
>> >> > > Cc: Tony Lindgren <tony@atomide.com>
>> >> > > Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> >> > > Cc: Cousson, Benoit <b-cousson@ti.com>
>> >> > > Cc: Grant Likely <grant.likely@secretlab.ca>
>> >> > > Cc: Tarun Kanti DebBarma <tarun.kanti@ti.com>
>> >> > > Cc: Felipe Balbi <balbi@ti.com>
>> >> > > Cc: Govindraj.R <govindraj.raja@ti.com>
>> >> > >
>> >> > > Signed-off-by: NeilBrown <neilb@suse.de>
>> >> > >
>> >> > The patch doesn't seems to be correct. At least the 2/ gets
>> >> > fixed with a proper IRQCHIP flag. Can you try the patch at
>> >> > end of the email and see if it helps ? Am attaching it in case
>> >> > mailer damages it.
>> >> >
>> >> > Regards
>> >> > Santosh
>> >> >
>> >> > >From b8a38fc75e046f6462610e26c47c620cad850c24 Mon Sep 17 00:00:00 2001
>> >> > From: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> >> > Date: Sun, 26 Aug 2012 09:39:51 +0530
>> >> > Subject: [PATCH] gpio: omap: Set IRQCHIP_MASK_ON_SUSPEND to mask all
>> >> >  non-wakeup gpio wakeups.
>> >> >
>> >> > Set the irq chip flag IRQCHIP_MASK_ON_SUSPEND to cause the irq pm code
>> >> > to mask all non-wake gpios in suspend, which will ensure the wakeup
>> >> > enable
>> >> > bit is not set on non-wake gpios.
>> >> >
>> >> > Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> >> > ---
>> >> >  drivers/gpio/gpio-omap.c |    1 +
>> >> >  1 file changed, 1 insertion(+)
>> >> >
>> >> > diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
>> >> > index e6efd77..50b4c18 100644
>> >> > --- a/drivers/gpio/gpio-omap.c
>> >> > +++ b/drivers/gpio/gpio-omap.c
>> >> > @@ -779,6 +779,7 @@ static struct irq_chip gpio_irq_chip = {
>> >> >       .irq_unmask     = gpio_unmask_irq,
>> >> >       .irq_set_type   = gpio_irq_type,
>> >> >       .irq_set_wake   = gpio_wake_enable,
>> >> > +     .flags          = IRQCHIP_MASK_ON_SUSPEND;
>> >> >  };
>> >> >
>> >> >
>> >> > /*---------------------------------------------------------------------*/
>> >>
>> >>
>> >> No obvious damage, unless the mailer is responsible or the ';' at the end
>> >> of
>> >> the line, rather than ',' :-)
>> >>
>> > :-) That was typo.
>> >
>> >> The approach makes sense, but does actually work.  Should be fixable
>> >> though.
>> >>
>> >> When I try this I get:
>> >>
>> >>
>> >>
>> >> [  158.114440] Checking wakeup interrupts
>> >> [  158.118408] Unhandled fault: external abort on non-linefetch (0x1028)
>> >> at 0xfb054040
>> >> [  158.126403] Internal error: : 1028 [#1] PREEMPT ARM
>> >> [  158.131500] Modules linked in: ipv6 g_ether hso libertas_sdio libertas
>> >> cfg80211
>> >> [  158.139190] CPU: 0    Not tainted  (3.5.0-gta04-debug+ #2)
>> >> [  158.144927] PC is at _set_gpio_triggering+0x38/0x258
>> >> [  158.150115] LR is at gpio_mask_irq+0xac/0xc0
>> >> [  158.154602] pc : [<c01d24a0>]    lr : [<c01d2f68>]    psr: 60000193
>> >> [  158.154602] sp : db521e90  ip : 00000011  fp : beeecc2c
>> >> [  158.166595] r10: c05c8ebc  r9 : daa5a858  r8 : 00000003
>> >> [  158.172027] r7 : a0000193  r6 : 00000000  r5 : fb054000  r4 : ded44e18
>> >> [  158.178863] r3 : 00000001  r2 : 00000000  r1 : ded30340  r0 : 00000040
>> >> [  158.185668] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM
>> >> Segment use
>> >>
>> >> so it looks like runtime PM has turned off the iclk to the GPIO module so
>> >> that
>> >> when we try to tell it to change settings, it is no longer listening to
>> >> us.
>> > From the crash logs it appears like that.
>> >
>> >> The "Checking wakeup interrupts" function happens very late in the suspend
>> >> cycle, after all the suspend_late and suspend_noirq functions have run.
>> >> Maybe it needs to be moved earlier...
>> >>
>> > No it shouldn't be moved and it is that point for lot many good
>> > reasons. Ofcourse
>> > this omap gpio driver crash needs to be addressed. Need to think bit
>> > more on this
>> > issue.
>> >
>> After thinking bit more on this, the problem seems to be coming
>> mainly because the gpio device is runtime suspended bit early than
>> it should be. Similar issue seen with i2c driver as well. The i2c issue
>> was discussed with Rafael at LPC last week. The idea is to move
>> the pm_runtime_enable/disable() calls entirely up to the
>> _late/_early stage of device suspend/resume.
>> Will update this thread once I have further update.
>
> This won't be late enough.  IRQCHIP_MASK_ON_SUSPEND takes effect after all
> the _late callbacks have been called.
> I, too, spoke to Rafael about this in San Diego.  He seemed to agree with me
> that the interrupt needs to be masked in the ->suspend callback.  any later
> is too late.
>
Thanks for information about your discussion. Will wait for the patch then.

Regards
santosh
