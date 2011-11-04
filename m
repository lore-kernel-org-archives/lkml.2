Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab1KDNNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 09:13:35 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:55197 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab1KDNNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 09:13:34 -0400
Message-ID: <1320412312.3514.1.camel@js-netbook>
Subject: Re: [PATCH] clocksource: Avoid selecting mult values that might
 overflow when adjusted
From: John Stultz <john.stultz@linaro.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Yong Zhang <yong.zhang0@gmail.com>,
        David Daney <ddaney.cavm@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 04 Nov 2011 09:11:52 -0400
In-Reply-To: <20111103211000.GA17895@elte.hu>
References: <1320264087-3413-1-git-send-email-john.stultz@linaro.org>
	 <20111103211000.GA17895@elte.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11110413-7282-0000-0000-0000033C0B5E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 22:10 +0100, Ingo Molnar wrote:
> * John Stultz <john.stultz@linaro.org> wrote:
> 
> > For some frequqencies, the clocks_calc_mult_shift() function will
> > unfortunately select mult values very close to 0xffffffff.  This
> > has the potential to overflow when NTP adjusts the clock, adding
> > to the mult value.
> > 
> > This patch adds a clocksource.maxadj value, which provides
> > an approximation of an 11% adjustment(NTP limits adjustments to
> > 500ppm and the tick adjustment is limited to 10%), which could
> > be made to the clocksource.mult value. This is then used to both
> > check that the current mult value won't overflow/underflow, as
> > well as warning us if the timekeeping_adjust() code pushes over
> > that 11% boundary.
> > 
> > CC: Yong Zhang <yong.zhang0@gmail.com>
> > CC: David Daney <ddaney.cavm@gmail.com>
> > CC: Thomas Gleixner <tglx@linutronix.de>
> > Reported-by: Chen Jie <chenj@lemote.com>
> > Reported-by: zhangfx <zhangfx@lemote.com>
> > Signed-off-by: John Stultz <john.stultz@linaro.org>
> > ---
> >  include/linux/clocksource.h |    3 +-
> >  kernel/time/clocksource.c   |   53 ++++++++++++++++++++++++++++++++++--------
> >  kernel/time/timekeeping.c   |    3 ++
> >  3 files changed, 48 insertions(+), 11 deletions(-)
> 
> This patch (included in tip:timers/urgent) causes the following boot 
> warning x86:
> 
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at kernel/time/timekeeping.c:855 do_timer+0x47f/0x4c0()
> [    0.000000] Hardware name: System Product Name
> [    0.000000] Adjusting more then 11%
> [    0.000000] Modules linked in:
> [    0.000000] Pid: 0, comm: swapper Not tainted 3.1.0-tip+ #161792
> [    0.000000] Call Trace:
> [    0.000000]  <IRQ>  [<ffffffff81042d0a>] warn_slowpath_common+0x7a/0xb0
> [    0.000000]  [<ffffffff81042de1>] warn_slowpath_fmt+0x41/0x50
> [    0.000000]  [<ffffffff8106e78f>] do_timer+0x47f/0x4c0
> [    0.000000]  [<ffffffff81073953>] tick_periodic+0x63/0x80
> [    0.000000]  [<ffffffff810739f1>] tick_handle_periodic+0x21/0x70
> [    0.000000]  [<ffffffff810046d8>] timer_interrupt+0x18/0x20
> [    0.000000]  [<ffffffff8109ff9e>] handle_irq_event_percpu+0x5e/0x220
> [    0.000000]  [<ffffffff810a019b>] handle_irq_event+0x3b/0x60
> [    0.000000]  [<ffffffff810a295c>] handle_level_irq+0x6c/0xd0
> [    0.000000]  [<ffffffff81003f34>] handle_irq+0x44/0xa0
> 
> Full bootlog and config attached.
> 
> i've excluded it from tip:master for now.

Sounds good. Thanks for the heads up.  Do you have a dmesg for this
system as well, so I can narrow down what I should try to reproduce this
on?

Just FYI: I'm traveling, but will try to nail this down early next week.
thanks
-john


