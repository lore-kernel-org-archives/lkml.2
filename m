Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab2DPWBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 18:01:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:8009 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab2DPWBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 18:01:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="131641872"
Subject: Re: [PATCH] clockevents: Leave broadcast device shtudown only if
 the current device is always running.
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Date: Mon, 16 Apr 2012 15:03:36 -0700
In-Reply-To: <4F8AC59D.6070909@ti.com>
References: <1333951423-27621-1-git-send-email-santosh.shilimkar@ti.com>
	 <1334011304.12400.81.camel@sbsiddha-desk.sc.intel.com>
	 <4F8AC59D.6070909@ti.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1334613816.28674.108.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-15 at 18:27 +0530, Santosh Shilimkar wrote:
> On Tuesday 10 April 2012 04:11 AM, Suresh Siddha wrote:
> > @@ -575,10 +575,12 @@ void tick_broadcast_switch_to_oneshot(void)
> >  	unsigned long flags;
> >  
> >  	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
> > +
> > +	tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
> > +
> >  	if (cpumask_empty(tick_get_broadcast_mask()))
> >  		goto end;
> >  
> > -	tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
> >  	bc = tick_broadcast_device.evtdev;
> >  	if (bc)
> >  		tick_broadcast_setup_oneshot(bc);
> > 
> > 
> Last time when I tried your patch, some how he ethernet IRQ masked
> the issue.
> 
> The problem is still as before. If you make a minimal kernel
> configuration and possibly have only local timer, broadcast timer
> and say console device as CPU wakeup sources, you should hang in
> the boot process itself(Assuming CPUIDLE driver is built-in)
> 
> The main issue is, you are not letting the one time setup
> needed for the broadcast device. Even with above change,
> the 'tick_broadcast_device.evtdev' is still in SHUTDOWN
> mode and the event handler is pointing to clockevents_handle_noop()

On x86, idle driver (like drivers/idle/intel_idle.c:
__setup_broadcast_timer()) calls clockevents_notify() with
CLOCK_EVT_NOTIFY_BROADCAST_ON, during which we do
tick_broadcast_setup_oneshot(). See tick_do_broadcast_on_off() which
does this. That should setup the evtdev handler, mode etc.

And during the next CLOCK_EVT_NOTIFY_BROADCAST_ENTER we program the next
broadcast event.

> So the very first 'CLOCK_EVT_NOTIFY_BROADCAST_ENTER' call won't
> program the broadcast device with next event and CPU won't wakeup
> from low power. if you are lucky and have some other wakeup source,
> system will move further and eventually the handler and
> mode of the broad-cast device get set correctly.

I am confused. Can you elaborate on how on the next spurious wakeup
event, broad-cast device handler, mode is set?

It sounds like the CLOCK_EVT_NOTIFY_BROADCAST_ON/OFF notifications are
missing from your idle driver. But I am confused how it will work on the
next spurious wakeup etc with out the calls to
tick_do_broadcast_on_off()? Perhaps the next spurious wakeup correcting
everything is just theory and you didn't see it in practice?

Anyways, can you add CLOCK_EVT_NOTIFY_BROADCAST_ON/OFF notifications in
your idle driver to see if it addresses the problem. That is the correct
thing to do here.

thanks,
suresh

