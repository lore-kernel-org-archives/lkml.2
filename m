Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab2EHRGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 13:06:34 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39874 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756328Ab2EHRGc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 13:06:32 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1205072054130.6271@ionos>
References: <20120503125611.4314.52231.sendpatchset@w520>
	<alpine.LFD.2.02.1205072054130.6271@ionos>
Date: Wed, 9 May 2012 02:06:32 +0900
Message-ID: <CANqRtoRr5z2GLOfaFnRCFcsQaAaVMvkaDh2=yrhQTvNmAQN-Pg@mail.gmail.com>
Subject: Re: [PATCH] clocksource: em_sti: Emma Mobile STI driver
From: Magnus Damm <magnus.damm@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, horms@verge.net.au, arnd@arndb.de,
        linux-sh@vger.kernel.org, johnstul@us.ibm.com, rjw@sisk.pl,
        lethal@linux-sh.org, gregkh@linuxfoundation.org, olof@lixom.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Tue, May 8, 2012 at 4:10 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 3 May 2012, Magnus Damm wrote:
>> +/* private flags */
>> +#define FLAG_CLOCKEVENT (1 << 0)
>> +#define FLAG_CLOCKSOURCE (1 << 1)
>> +
>> +static int em_sti_start(struct em_sti_priv *p, unsigned long flag)
>> +{
>> +     int ret = 0;
>> +     unsigned long flags;
>> +
>> +     spin_lock_irqsave(&p->lock, flags);
>> +
>> +     if (!(p->flags & (FLAG_CLOCKEVENT | FLAG_CLOCKSOURCE)))
>> +             ret = em_sti_enable(p);
>
> That's confusing. You seem to enable both CLOCKEVENT and CLOCKSOURCE
> independent of "flag" value.

Hm, I believe the idea is to check if it has been enabled already...

>> +
>> +     if (!ret)
>> +             p->flags |= flag;
>
> And then just or "flag" ??????

... but it certainly is overly complicated. I'll rework it into
something that is easier to digest. =)

>> +     spin_unlock_irqrestore(&p->lock, flags);
>> +
>> +     return ret;
>> +}
>> +
>> +static void em_sti_stop(struct em_sti_priv *p, unsigned long flag)
>> +{
>> +     unsigned long flags;
>> +     unsigned long f;
>> +
>> +     spin_lock_irqsave(&p->lock, flags);
>> +
>> +     f = p->flags & (FLAG_CLOCKEVENT | FLAG_CLOCKSOURCE);
>> +     p->flags &= ~flag;
>> +
>> +     if (f && !(p->flags & (FLAG_CLOCKEVENT | FLAG_CLOCKSOURCE)))
>> +             em_sti_disable(p);
>
> Huch? If the caller wants to disable the clockevent, you stop the
> clocksource as well because em_sti_disable() stops the clock.
>
> /me is confused.

I believe the idea is that if the timer is currently enabled (f) and
if we are the last user thenthen stop.

A regular usage counter probably makes much more sense!

>> +static void em_sti_clock_event_start(struct em_sti_priv *p)
>> +{
>> +     struct clock_event_device *ced = &p->ced;
>> +
>> +     em_sti_start(p, FLAG_CLOCKEVENT);
>> +
>> +     /* TODO: calculate good shift from rate and counter bit width */
>> +
>> +     ced->shift = 32;
>> +     ced->mult = div_sc(p->rate, NSEC_PER_SEC, ced->shift);
>
> IIRC, we have a generic function to do that :)

Ok, thanks for pointing that out. Need to look it up!

Will update and post a V2. Thanks for your help!

Cheers,

/ magnus
