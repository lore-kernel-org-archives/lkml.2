Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab0EJVdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 17:33:41 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:35213 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab0EJVdk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 17:33:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=im+9snqeAc9ZztMX4px2Dcq2w9XY5tbxLJKv94zfY4Fo+Biw0rEOlpqouNeDgiDO/U
         E9AsInUqOBxCngr7LIYQTUl3kUaTxOBPPKvCaOO6/ZJPvcUsoMQ4/B1tiTSfguHan8rp
         jRxvO3BAV4bO7Ns5G1057qgfUg/9VbtFBl0rE=
MIME-Version: 1.0
In-Reply-To: <1272677785-23881-3-git-send-email-johnstul@us.ibm.com>
References: <1272677785-23881-1-git-send-email-johnstul@us.ibm.com>
	 <1272677785-23881-2-git-send-email-johnstul@us.ibm.com>
	 <1272677785-23881-3-git-send-email-johnstul@us.ibm.com>
Date: Mon, 10 May 2010 17:33:39 -0400
Message-ID: <AANLkTik35lel9vGzepy10zshOnvY1_P7Vbr91Q_G0PkC@mail.gmail.com>
Subject: Re: [RFC][PATCH 3/3] Try to convert non-trivial clocksources to 
	clocksource_register_hz
From: Jim Cromie <jim.cromie@gmail.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 9:36 PM, John Stultz <johnstul@us.ibm.com> wrote:
> NOT FOR INCLUSION!
> NOT FOR INCLUSION!
>
> I've already gone through and converted the rest of the clocksources
> to use clocksource_register_hz, and I'll be hopefully pushing those
> to arch maintainers for 2.6.36-2.6.37.
>
> However, in going through all the clocksources, I hit a few
> non-trivial conversions and wanted to bring them up on the list
> early so they can be handled soon.
>
> The following patch tries to convert the non-trival clocksources
> to use clocksource_register_hz/khz. It is likely broken. I will
> need arch maintainer help to figure out the best way to resovle
> these clocksources.
>
> This patch requires the previous "Add clocksource_register_hz/khz
> interface" patch to build.
>
> So any help maintainers can provide in finding solutions to
> break the mult/shift assumptions in the arch code would be
> greatly appreciated!
>
> thanks
> -john
>
> NOT FOR INCLUSION!
> NOT FOR INCLUSION!
>  drivers/clocksource/scx200_hrt.c    |   19 ++++++-------------
>  drivers/clocksource/sh_cmt.c        |    4 ++--
>  drivers/clocksource/sh_tmu.c        |    4 ++--
>  kernel/time/jiffies.c               |    3 ++-
>  7 files changed, 35 insertions(+), 29 deletions(-)
>

> diff --git a/drivers/clocksource/scx200_hrt.c b/drivers/clocksource/scx200_hrt.c
> index 27f4d96..24f884c 100644
> --- a/drivers/clocksource/scx200_hrt.c
> +++ b/drivers/clocksource/scx200_hrt.c
> @@ -49,9 +49,6 @@ static cycle_t read_hrt(struct clocksource *cs)
>        return (cycle_t) inl(scx200_cb_base + SCx200_TIMER_OFFSET);
>  }
>
> -#define HRT_SHIFT_1    22
> -#define HRT_SHIFT_27   26
> -
>  static struct clocksource cs_hrt = {
>        .name           = "scx200_hrt",
>        .rating         = 250,
> @@ -63,6 +60,7 @@ static struct clocksource cs_hrt = {
>
>  static int __init init_hrt_clocksource(void)
>  {
> +       u32 freq;
>        /* Make sure scx200 has initialized the configuration block */
>        if (!scx200_cb_present())
>                return -ENODEV;
> @@ -79,19 +77,14 @@ static int __init init_hrt_clocksource(void)
>        outb(HR_TMEN | (mhz27 ? HR_TMCLKSEL : 0),
>             scx200_cb_base + SCx200_TMCNFG_OFFSET);
>
> -       if (mhz27) {
> -               cs_hrt.shift = HRT_SHIFT_27;
> -               cs_hrt.mult = clocksource_hz2mult((HRT_FREQ + ppm) * 27,
> -                                                 cs_hrt.shift);
> -       } else {
> -               cs_hrt.shift = HRT_SHIFT_1;
> -               cs_hrt.mult = clocksource_hz2mult(HRT_FREQ + ppm,
> -                                                 cs_hrt.shift);
> -       }
> +       freq = (HRT_FREQ + ppm);
> +       if (mhz27)
> +               freq *= 27;
> +
>        printk(KERN_INFO "enabling scx200 high-res timer (%s MHz +%d ppm)\n",
>                mhz27 ? "27":"1", ppm);
>
> -       return clocksource_register(&cs_hrt);
> +       return clocksource_register_hz(&cs_hrt, freq);
>  }
>
>  module_init(init_hrt_clocksource);


hi John,

On casual inspection, this looks good, however
I wont be able to try it on the hardware til early June earliest.

I have a few qs, (idle musings really)

- scx200_hrt cannot be rmmod'd, due iirc to the clocksource design.
This is not a problem, but I wonder if it might be added later, and what
it might mean to the drivers (in a new module_exit())

- HRT_SHIFT_1/_27 macros are removed, and now calculated in clocksource code.
I chose a 1:16 shift ratio for the 1:27 input clocks.  I suppose I could have
used 1:32, I dont recall thinking of it or trying it then.
What would/should your new code do ?

- when writing scx200_hrt, I chose to adjust by ppm, not +/- hz
partly cuz it was easier to describe in a 1-line mod-desc, and partly
cuz 1/27ppm vernier-knob is overkill on a $0.25 crystal.
The new API name (with _hz suffix) suggests that I could change
the mod-param-name, and add it in after the 1:27 multiplier.

<OT - out of scope in this thread>

on 5/3, slashdot had a synopsis of this item:
http://queue.acm.org/detail.cfm?id=1773943
It proposes a different split of duty between kernel and NTP daemon,
but oddly doesnt mention PTP.
Does this or PTP make any sense in Linux ?

thanks
-jimc
