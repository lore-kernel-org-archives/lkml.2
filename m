Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab2DOM5L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 08:57:11 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:60102 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752519Ab2DOM5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 08:57:08 -0400
Message-ID: <4F8AC59D.6070909@ti.com>
Date: Sun, 15 Apr 2012 18:27:01 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: tglx@linutronix.de, linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: Re: [PATCH] clockevents: Leave broadcast device shtudown only if
 the current device is always running.
References: <1333951423-27621-1-git-send-email-santosh.shilimkar@ti.com> <1334011304.12400.81.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1334011304.12400.81.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh,

On Tuesday 10 April 2012 04:11 AM, Suresh Siddha wrote:
> On Mon, 2012-04-09 at 11:33 +0530, Santosh Shilimkar wrote:
>> Commit 77b0d60{clockevents: Leave the broadcast device in shutdown mode
>> when not needed} was intended to leave the broadcast device in shutdown mode
>> when the per-cpu clockevent devices are always running.
>>
>> This breaks the systems where per cpu clock events stop in low power states.
>>
>> Hence revert 77b0d60 and implement the same requirement with use
>> of C3STOP feature flag.
> 
> Problem you encountered is not related to leaving the broadcast device
> in shutdown mode. Problem is that we didn't track the mode change to
> oneshot and later during idle entry/exit, when we request the broadcast
> device services using CLOCK_EVT_NOTIFY_BROADCAST_ENTER etc,
> tick_broadcast_oneshot_control() returns with out doing much as it
> thinks broadcast device is in periodic mode.
> 
> Can you please check if the appended patch fixes the issue? I could
> reproduce the issue on my NHM platform which doesn't have always running
> apic timer and with the appended fix, all is well with cpu's going into
> tickless idle etc. Thanks.
> ---
> 
> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: clockevents: track broadcast device mode change in tick_broadcast_switch_to_oneshot()
> 
> In the commit 77b0d60c5adf39c74039e2142a1d3cd1e4d53799,
> "clockevents: Leave the broadcast device in shutdown mode when not needed",
> we were bailing out too quickly in tick_broadcast_switch_to_oneshot(),
> with out tracking the broadcast device mode change to 'TICKDEV_MODE_ONESHOT'.
> 
> This breaks the platforms which need broadcast device oneshot services during
> deep idle states. tick_broadcast_oneshot_control() thinks that it is
> in periodic mode and fails to take proper decisions based on the
> CLOCK_EVT_NOTIFY_BROADCAST_[ENTER, EXIT] notifications during deep
> idle entry/exit.
> 
> Fix this by tracking the broadcast device mode as 'TICKDEV_MODE_ONESHOT',
> before leaving the broadcast HW device in shutdown mode if there are no active
> requests for the moment.
> 
> Reported-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>  kernel/time/tick-broadcast.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index e883f57..bf57abd 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -575,10 +575,12 @@ void tick_broadcast_switch_to_oneshot(void)
>  	unsigned long flags;
>  
>  	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
> +
> +	tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
> +
>  	if (cpumask_empty(tick_get_broadcast_mask()))
>  		goto end;
>  
> -	tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
>  	bc = tick_broadcast_device.evtdev;
>  	if (bc)
>  		tick_broadcast_setup_oneshot(bc);
> 
> 
Last time when I tried your patch, some how he ethernet IRQ masked
the issue.

The problem is still as before. If you make a minimal kernel
configuration and possibly have only local timer, broadcast timer
and say console device as CPU wakeup sources, you should hang in
the boot process itself(Assuming CPUIDLE driver is built-in)

The main issue is, you are not letting the one time setup
needed for the broadcast device. Even with above change,
the 'tick_broadcast_device.evtdev' is still in SHUTDOWN
mode and the event handler is pointing to clockevents_handle_noop()

So the very first 'CLOCK_EVT_NOTIFY_BROADCAST_ENTER' call won't
program the broadcast device with next event and CPU won't wakeup
from low power. if you are lucky and have some other wakeup source,
system will move further and eventually the handler and
mode of the broad-cast device get set correctly.

At the minimal below things needs to be done to avoid the boot-hang.

-----------------------
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index bf57abd..3b08fb9 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -577,13 +580,16 @@ void tick_broadcast_switch_to_oneshot(void)
        raw_spin_lock_irqsave(&tick_broadcast_lock, flags);

        tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
+       bc = tick_broadcast_device.evtdev;
+       if (bc) {
+               bc->event_handler = tick_handle_oneshot_broadcast;
+               clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
+       }

        if (cpumask_empty(tick_get_broadcast_mask()))
                goto end;

-       bc = tick_broadcast_device.evtdev;
-       if (bc)
-               tick_broadcast_setup_oneshot(bc);
+       tick_broadcast_setup_oneshot(bc);

 end:
        raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
-----------------------

More I think of this, seems that the original patch approach
itself was not right.

What you intended can be easily handled by avoiding
the tick_broadcast_switch_to_oneshot() on machines where
local timers are always running. And that was precisely
I tried in $subject patch [1] and that should solve
the problem what you have at the same time maintain the
existing functionality intact.

Let me know if I am missing something here. Bottom line is
the clock-event broadcasting is still broken after your
change(s) and needs to be fixed.

Regards
Santosh

[1] https://lkml.org/lkml/2012/4/9/13


