Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab2EYDjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 23:39:10 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:43407 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab2EYDjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 23:39:08 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1205250135340.3231@ionos>
References: <20120509143926.27521.20342.sendpatchset@w520>
	<20120509143942.27521.8595.sendpatchset@w520>
	<alpine.LFD.2.02.1205250135340.3231@ionos>
Date: Fri, 25 May 2012 12:39:06 +0900
Message-ID: <CANqRtoS24CUp3cpoWykJ5Ty5XT3Yn+LNvGL_kF5NdEPAQL0f4A@mail.gmail.com>
Subject: Re: [PATCH 02/03] clocksource: em_sti: Emma Mobile STI driver V2
From: Magnus Damm <magnus.damm@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, horms@verge.net.au,
        linux-sh@vger.kernel.org, johnstul@us.ibm.com, rjw@sisk.pl,
        lethal@linux-sh.org, gregkh@linuxfoundation.org, olof@lixom.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Fri, May 25, 2012 at 8:42 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 9 May 2012, Magnus Damm wrote:
>> +static irqreturn_t em_sti_interrupt(int irq, void *dev_id)
>> +{
>> +     struct em_sti_priv *p = dev_id;
>> +
>> +     /* Always regprogram timer compare A */
>> +     if (p->ced.mode == CLOCK_EVT_MODE_PERIODIC)
>> +             em_sti_update(p);
>
> Why do you want to do that? The core code already handles timers which
> only support oneshot mode.

Oh, I wasn't aware that oneshot only is a valid combination. Thanks
for pointing that out, the code will surely become cleaner!

>> +     spin_lock_irqsave(&p->lock, flags);
>
> Please make that a raw_spinlock.

Ok!

>> +static void em_sti_clock_event_mode(enum clock_event_mode mode,
>> +                                 struct clock_event_device *ced)
>> +{
>> +     struct em_sti_priv *p = ced_to_em_sti(ced);
>> +
>> +     /* deal with old setting first */
>> +     switch (ced->mode) {
>> +     case CLOCK_EVT_MODE_PERIODIC:
>> +     case CLOCK_EVT_MODE_ONESHOT:
>> +             em_sti_stop(p, USER_CLOCKEVENT);
>> +             break;
>> +     default:
>> +             break;
>> +     }
>> +
>> +     switch (mode) {
>> +     case CLOCK_EVT_MODE_PERIODIC:
>> +             dev_info(&p->pdev->dev, "used for periodic clock events\n");
>> +             em_sti_start(p, USER_CLOCKEVENT);
>> +             clockevents_config(&p->ced, p->rate);
>> +             p->delta = (p->rate + HZ/2) / HZ;
>> +             p->next = em_sti_count(p);
>> +             em_sti_update(p);
>> +             break;
>
> All that code in this case can go away.

Right!

>> +static void em_sti_register_clockevent(struct em_sti_priv *p)
>> +{
>> +     struct clock_event_device *ced = &p->ced;
>> +
>> +     memset(ced, 0, sizeof(*ced));
>> +     ced->name = dev_name(&p->pdev->dev);
>> +     ced->features = CLOCK_EVT_FEAT_PERIODIC;
>> +     ced->features |= CLOCK_EVT_FEAT_ONESHOT;
>
> If you make that:
>
>        ced->features = CLOCK_EVT_FEAT_ONESHOT;

Gotcha!

Thanks,

/ magnus
