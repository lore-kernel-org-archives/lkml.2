Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab1CRV7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:59:47 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49570 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932858Ab1CRV7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:59:35 -0400
Subject: Re: 2.6.39 crashes BUG: unable to handle kernel NULL pointer
 dereference at 000000000000042 .. cmos_checkintr+0x4d/0x55 under Xen as PV
 guest.
From: John Stultz <john.stultz@linaro.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
In-Reply-To: <20110318203830.GA9262@dumpdata.com>
References: <20110318203830.GA9262@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Mar 2011 14:59:26 -0700
Message-ID: <1300485566.2731.46.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-18 at 16:38 -0400, Konrad Rzeszutek Wilk wrote:
> Haven't done any bisection, but looking at the latest set of
> patches John's name is on them. (John, congrats on a new job)

No new job, I'm still at IBM. Just a new email address, as I'm working
as part of the Linaro effort. My old address still work too, and I'll
continue to use them for non-Linaro work.


> With the latest linus/master I get this when starting a Xen Linux PV
> guest:
> 
> [    0.404760] initcall psmouse_init+0x0/0x79 returned 0 after 59 usecs
> [    0.404767] calling  cmos_init+0x0/0x6a @ 1
> [    0.464855] BUG: unable to handle kernel NULL pointer dereference at 0000000000000428
> [    0.464867] IP: [<ffffffff8105d347>] queue_work_on+0x4/0x1d
[snip]
> [    0.465018] Call Trace:
> [    0.465023]  [<ffffffff8105d38f>] queue_work+0x1a/0x1c
> [    0.465029]  [<ffffffff8105d3a4>] schedule_work+0x13/0x15
> [    0.465035]  [<ffffffff81331b2e>] rtc_update_irq+0x10/0x12
> [    0.465041]  [<ffffffff81333939>] cmos_checkintr+0x4d/0x55
> [    0.465047]  [<ffffffff81333987>] cmos_irq_disable+0x46/0x4e
> [    0.465051]  [<ffffffff8133481d>] cmos_set_alarm+0xd9/0x16e
> [    0.465051]  [<ffffffff813320a4>] __rtc_set_alarm+0x7d/0x88
> [    0.465051]  [<ffffffff813321fa>] rtc_timer_enqueue+0x71/0xb8
> [    0.465051]  [<ffffffff81331707>] ? rtc_tm_to_time+0x2f/0x38
> 
> ... full log at the end.
> 
> From a brief look it looks as if rtc_device_register was never
> called, so
> 
> INIT_WORK(&rtc->irqwork, rtc_timer_do_work);
> 
> was never called.. and hence schedule_work tries to derefence an
> unitialized rtc->irqwork.
> 
> Which actually sounds right - the rtc_device_register should not
> be called since there are no RTC clocks exposed.


Huh. Did you see this with 2.6.38 vanilla? Just want to clarify if this
is 2.6.39 only or not.


> There are probably two ways of fixing this - making rtc_update_irq
> check the rtc->irqwork (not attempted) or inhibit cmos_pnp_probe from
> setting this up. Looking at the cmos_pnp_probe and its friend they all
> call cmos_wake_setup, but never checks whether that function works properly.
> 
> The cmos_wake_setup checks for ACPI (which is disabled for PV guests)
> and just returns.
> 
> This little patch seems to work, but not sure if that is the correct
> way to do it?

So I'm still trying to get my head around this (sorry, just back from
vacation).

So the issue is that somehow the cmos code is calling rtc_update_irq
even though there is no cmos rtc device registered. That clearly seems
problematic.

However, its unclear from both the code and your patch if
cmos_wake_setup or cmos_do_probe is causing the rtc_update_irq to be
called.

cmos_do_probe() has lots of checks for the hardware and even registers
the rtc device (which should init the irqwork), so I don't see how the
null irqwork would trip after that point.

Any insight there?

thanks
-john


