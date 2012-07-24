Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab2GXJT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 05:19:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54502 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966Ab2GXJTZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 05:19:25 -0400
From: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
To: Colin Cross <ccross@android.com>, Linus Walleij <linus.walleij@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Subject: RE: [RFC] ARM: sched_clock: update epoch_cyc on resume
Thread-Topic: [RFC] ARM: sched_clock: update epoch_cyc on resume
Thread-Index: AQHNZHSmfTvAkmFiEEi7338Sd5A1Jpc25E8AgAAJD4CAAFASAIAAA/UAgADk1lA=
Date: Tue, 24 Jul 2012 09:16:59 +0000
Message-ID: <B5906170F1614E41A8A28DE3B8D121433EB19376@DBDE01.ent.ti.com>
References: <1342567672-29071-1-git-send-email-ccross@android.com>
 <CACRpkdaHdCvx1HJNDsyJSZAN--sF+4-V1TbzXZL1v+7Asoe_oA@mail.gmail.com>
 <CAMbhsRR2-VjUeL2XPKubeaG=iLV5NE-i_sVYbuMAryXLxsbo1g@mail.gmail.com>
 <CACRpkdYayLaKzUSq5V9N5sRkV74a+nZ1CbLJzRW7RP=pOU9bfw@mail.gmail.com>
 <CAMbhsRQuXsytM9QLwjW1z1E=0XNztXP1xezbcDEj7Ra6deKLDQ@mail.gmail.com>
In-Reply-To: <CAMbhsRQuXsytM9QLwjW1z1E=0XNztXP1xezbcDEj7Ra6deKLDQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 05:58:32, Colin Cross wrote:
> On Mon, Jul 23, 2012 at 5:14 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Mon, Jul 23, 2012 at 9:27 PM, Colin Cross <ccross@android.com> wrote:
> >> On Mon, Jul 23, 2012 at 11:55 AM, Linus Walleij
> >
> >> Does the clock you use for sched_clock continue to run in all suspend
> >> modes? All the SoC's I've used only have a 32kHz clock in the deepest
> >> suspend mode,
> >
> > Yes, and yes it is 32kHz.
> >

On the platform that I am working on (AM335x) the sched_clock continues to
run and yes even on this it runs @ 32KHz.

> >> which is not ideal for sched_clock.
> >
> > Not that I know why scheduling with 32kHz is so bad compared to the
> > default system scheduling granularity which is HZ if you don't have
> > sched_clock() implemented.
> >
> > Since this seems to be such an important point, what makes you
> > want MHz:es for scheduling granularity? To me the biggest impact
> > is actually the granularity of the timestamps in the printk:s.
> >

I personally find the timestamps in the printks very late in the suspend
or very early in the resume extremely helpful for debugging. 
The printk timestamps also help figure out which portions of the platform
suspend code are taking long and can be optimized.

> > (It's not that I doubt your needs, more curiosity.)
> 
> There's a comment somewhere about higher resolution sched_clock
> providing fairer scheduling.  With 32 kHz sched_clock, every runtime
> measured by the scheduler will be wrong by up to 31.25 us.  Most
> systems have a faster clock, and if it's available it seems silly not
> to use it.
> 
> It's also used for tracing, where 31.25 us resolution is a little low
> for function tracing or function graph tracing.
> 
> >>  For example, on
> >> Tegra2 the faster 1MHz clock used for sched_clock resets in the
> >> deepest suspend state (LP0) but not the shallowest suspend state
> >> (LP2), and which suspend state the chip hits depends on which hardware
> >> is active.  Opting out of this patch would cause Tegra's clock to
> >> sometimes run in suspend, and sometimes not, which seems worse for
> >> debugging than consistently not running in suspend.  I'd be surprised
> >> if a similar situation didn't apply to your platform.
> >

Is there any other slower on Tegra2 which doesn't reset and hence can be used
for sched_clock in LP0 as well as LP2? 

There's a trade-off that the end-user might choose to make - 
either use a faster clock for sched_clock which stops in suspend
or use a slower, in most cases 32KHz, clock which doesn't.
IMO this aspect should be configurable.

> > Well being able to switch between different sched_clock() providers
> > may be the ideal...
> >

Hmm... not exactly. More below.

> >>> - If it absolutely needs to be in the core code, also have a bool
> >>>   field indicating whether the clock is going to die during suspend
> >>>   and add new registration functions for setting that sched_clock
> >>>   type, e.g. setup_sched_clock_nonsuspendable()
> >>
> >> Sounds reasonable if some platforms need the extra complexity.
> >

I am not sure but I am guessing even on OMAPx the timer used as sched_clock
keeps running.

> > OK agreed.
> >
> > A connecting theme is that of being avle to flag clock sources as
> > sched_clock providers. If all clocksources were tagged with
> > rating, and only clocksources were used for sched_clock(), the
> > kernel could select the highest-rated clock under all circumstances.
> >
> > But that's quite intrusive, more of an idea. :-P
> 

Too intrusive I guess ;)

There were some discussions on this in the context of AM335x [1] [2].
Right now only sched_clock can be registered and I guess this restriction
is not going to go away any time soon.

Regards,
Vaibhav B.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2012-January/080862.html 
[2] http://lists.infradead.org/pipermail/linux-arm-kernel/2012-April/092890.html


> sched_clock is supposed to be very low overhead compared to ktime_get,
> and has some strict  requirements if CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
> is not set (see kernel/sched/clock.c), but it might be possible.
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

