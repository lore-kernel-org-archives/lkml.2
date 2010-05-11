Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615Ab0EKBvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 21:51:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65195 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab0EKBvj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 21:51:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N7LEF7jgpOOBqJ8LAT1GLckqPVOOqeUFRogdsJ7qCI9bZs57VhFyVG4rB8Nkb7tvwh
         lrHB/j81cb/hXc1AJIuTGOYk9j2LFt3DUj3xIvRmeF8Css8yPaZhoIrUdLx3wqpWzzKT
         J2G/Fr4batWy/MoitG303f6q2pAwchMAyAC/k=
MIME-Version: 1.0
In-Reply-To: <1273536296.3843.66.camel@localhost.localdomain>
References: <1272677785-23881-1-git-send-email-johnstul@us.ibm.com>
	 <1272677785-23881-2-git-send-email-johnstul@us.ibm.com>
	 <1272677785-23881-3-git-send-email-johnstul@us.ibm.com>
	 <AANLkTik35lel9vGzepy10zshOnvY1_P7Vbr91Q_G0PkC@mail.gmail.com>
	 <1273536296.3843.66.camel@localhost.localdomain>
Date: Mon, 10 May 2010 21:51:36 -0400
Message-ID: <AANLkTinT-zftGaHaJfZQ4FE3K0XoCsruTN89lLtq6nqG@mail.gmail.com>
Subject: Re: [RFC][PATCH 3/3] Try to convert non-trivial clocksources to 
	clocksource_register_hz
From: Jim Cromie <jim.cromie@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 8:04 PM, john stultz <johnstul@us.ibm.com> wrote:
> On Mon, 2010-05-10 at 17:33 -0400, Jim Cromie wrote:
>> On Fri, Apr 30, 2010 at 9:36 PM, John Stultz <johnstul@us.ibm.com> wrote:
>> hi John,
>>
>> On casual inspection, this looks good, however
>> I wont be able to try it on the hardware til early June earliest.
>>
>> I have a few qs, (idle musings really)
>>
>> - scx200_hrt cannot be rmmod'd, due iirc to the clocksource design.
>> This is not a problem, but I wonder if it might be added later, and what
>> it might mean to the drivers (in a new module_exit())
>
>
> I've not really heard much of a compelling argument for clocksource
> driver removal, nor has anyone wanted to put much effort there so far.
> That said, I'm not opposed to it right off.  It just not a priority.
>

OK.  Just to be clear, Im not gonna make that argument.
I was imagining dragons there anyway.

>
>> - HRT_SHIFT_1/_27 macros are removed, and now calculated in clocksource code.
>> I chose a 1:16 shift ratio for the 1:27 input clocks.  I suppose I could have
>> used 1:32, I dont recall thinking of it or trying it then.
>> What would/should your new code do ?
>
> I'm not sure I'm following what you mean with the ratios, but the new
> code will select the largest shift value possible, where the resulting
> mult won't overflow 64bits when multiplied against 5 seconds (that
> interval length may be changed in the future) worth of cycles.
>

I hesitate to pursue this (musings), but:
the SHIFT_1, _27 values were 26,22, hence the 16:1 ratio.
the fastclock is 27* the slowclock, which is closer to 32:1 than 16:1,
so one of my SHIFT values is probably suboptimal.
Your new code will fix my error :-)
I'll probably add a printk just to see what shift, mult terms you compute.

>
>> - when writing scx200_hrt, I chose to adjust by ppm, not +/- hz
>> partly cuz it was easier to describe in a 1-line mod-desc, and partly
>> cuz 1/27ppm vernier-knob is overkill on a $0.25 crystal.
>> The new API name (with _hz suffix) suggests that I could change
>> the mod-param-name, and add it in after the 1:27 multiplier.
>
> I believe its still mathematically identical to what you had before, but
> let me know if I'm mistaken here.

Your changes look faithful to the original.
what I meant was changing the meaning of the param, and the computation:

+       freq = HRT_FREQ;
+       if (mhz27)
+               freq *= 27;
+       freq += hz_adjust;

This would give finer (apparent) control when using 27MHz clock,
though temp swings would still move real frequency much more
than the minimum adjustment (hence only an appearance of accuracy).

So, is this proposed parameter-name change an improvement, or needless churn ?
Obviously, I should ask this Q with a patch on top of yours :-}

>
> thanks
> -john
>

no, thank you
-jim
