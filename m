Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab2IRHNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 03:13:36 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52727 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619Ab2IRHNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 03:13:35 -0400
MIME-Version: 1.0
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A181E13@SHSMSX101.ccr.corp.intel.com>
References: <1347972841.4312.2.camel@cliu38-desktop-build>
	<CAK7N6vqKp0Tcdr0CP4grq12C8-Oe05+uCEyos=mLMitwpet+Zw@mail.gmail.com>
	<27240C0AC20F114CBF8149A2696CBE4A181E13@SHSMSX101.ccr.corp.intel.com>
Date: Tue, 18 Sep 2012 12:43:34 +0530
Message-ID: <CAK7N6vosWH8HoWCyw_jjubL3CRYr-VRdxi1o9WevXd=stSQkcw@mail.gmail.com>
Subject: Re: [PATCH] genirq: Add the IRQS_ONESHOT support for edge interrupt
From: anish singh <anish198519851985@gmail.com>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 10:21 AM, Liu, Chuansheng
<chuansheng.liu@intel.com> wrote:
>> Just curios about the problem you are facing without this code?
> The issue I meet is in my calling request_threaded_irq()[edge interrupt], even with IRQS_ONESHOT,
> When irq thread is handling, the interrupt is still coming, and the primary handler is called,
> It cause possible spin recursive locks if irq handler and irq thread use the same spin lock.

Are you sure you have not returned from the irq_thread and how do you
know that primary handler is called in between when your irq_thread is running?

This comment might help.
kernel/irq/manage.c

    } else if (new->handler == irq_default_primary_handler) {

        /*
         * The interrupt was requested with handler = NULL, so
         * we use the default primary handler for it. But it
         * does not have the oneshot flag set. In combination
         * with level interrupts this is deadly, because the
         * default primary handler just wakes the thread, then
         * the irq lines is reenabled, but the device still
         * has the level irq asserted. Rinse and repeat....
         *
         * While this works for edge type interrupts, we play
         * it safe and reject unconditionally because we can't
         * say for sure which type this interrupt really
         * has. The type flags are unreliable as the
         * underlying chip implementation can override them.
         */

Though I am not an expert on interrupt handling from the code
it looks like this scenario is already taken care of.

Just one more query from someone who knows this code:
Looks to me to be a spelling problem.I don't want to change the code
but just wants to know.

kernel/irq/manage.c

    if (new->flags & IRQF_ONESHOT) {
        /*
         * The thread_mask for the action is or'ed to
         * desc->thread_active to indicate that the
         * IRQF_ONESHOT thread handler has been woken, but not
         * yet finished. The bit is cleared when a thread
         * completes. When all threads of a shared interr
Shouldn't this "desc->thread_active" be desc->threads_active ??

>
>> -----Original Message-----
>> From: anish singh [mailto:anish198519851985@gmail.com]
>> Sent: Tuesday, September 18, 2012 12:31 PM
>> To: Liu, Chuansheng
>> Subject: Re: [PATCH] genirq: Add the IRQS_ONESHOT support for edge interrupt
>>
>> On Tue, Sep 18, 2012 at 6:24 PM, Chuansheng Liu
>> <chuansheng.liu@intel.com> wrote:
>> > In handle_edge_irq(), currently do not care about the flag IRQS_ONESHOT,
>> > but there are many edge interrupt handler with irq thread need it indeed,
>> > so implement here.
>> Just curios about the problem you are facing without this code?
>> >
>> > Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
>> > ---
>> >  kernel/irq/chip.c |    8 +++++++-
>> >  1 files changed, 7 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
>> > index eebd6d5..8e4e49a 100644
>> > --- a/kernel/irq/chip.c
>> > +++ b/kernel/irq/chip.c
>> > @@ -497,7 +497,13 @@ handle_edge_irq(unsigned int irq, struct irq_desc
>> *desc)
>> >         kstat_incr_irqs_this_cpu(irq, desc);
>> >
>> >         /* Start handling the irq */
>> > -       desc->irq_data.chip->irq_ack(&desc->irq_data);
>> > +       if (desc->istate & IRQS_ONESHOT) {
>> > +               mask_ack_irq(desc);
>> > +               handle_irq_event(desc);
>> > +               cond_unmask_irq();
>> > +               goto out_unlock;
>> > +       } else
>> > +               desc->irq_data.chip->irq_ack(&desc->irq_data);
>> >
>> >         do {
>> >                 if (unlikely(!desc->action)) {
>> > --
>> > 1.7.0.4
>> >
>> >
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
