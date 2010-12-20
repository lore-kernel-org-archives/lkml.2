Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab0LTMWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 07:22:06 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58907 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491Ab0LTMWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 07:22:04 -0500
Date: Mon, 20 Dec 2010 12:21:28 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Gregory Bean <gbean@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>, Dima Zavin <dima@android.com>,
        arve@android.com, Steve Muckle <smuckle@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Jeff Ohlstein <johlstei@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/5] msm: timer: SMP timer support for msm
Message-ID: <20101220122128.GD28157@n2100.arm.linux.org.uk>
References: <1291619778-30289-1-git-send-email-johlstei@codeaurora.org> <1291619778-30289-4-git-send-email-johlstei@codeaurora.org> <alpine.LFD.2.00.1012061025240.2653@localhost6.localdomain6> <20101207081701.GA18336@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101207081701.GA18336@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 08:17:01AM +0000, Russell King - ARM Linux wrote:
> On Mon, Dec 06, 2010 at 10:56:14AM +0100, Thomas Gleixner wrote:
> > On Sun, 5 Dec 2010, Jeff Ohlstein wrote:
> > > +#ifdef CONFIG_HOTPLUG_CPU
> > > +void __cpuexit local_timer_stop(void)
> > > +{
> > > +	local_clock_event->set_mode(CLOCK_EVT_MODE_SHUTDOWN, local_clock_event);
> > 
> > Aarg. No. The generic code already handles cpu hotplug. 
> 
> Can you show where this is handled by the generic code?  I can't find
> where this is handled.

Having checked this on Versatile Express with a printk in the ->set_mode
callback, the generic code does not handle shutting down clock event
devices on CPU hot-unplug.

I've analyzed why this is:

The hrtimer() code hooks into the hotplug notifier list, and when it
receives a CPU_DEAD or CPU_DEAD_FROZEN message, it calls 
clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DEAD).

The clockevents code calls its own notifier list, which ultimately calls
tick_notify().  This eventually calls tick_shutdown().

tick_shutdown() looks up the per-cpu tick device, uncouples the clock
event device from the tick device, and sets the clock event device mode
to CLOCK_EVT_MODE_UNUSED.  Note this comment:

                /*
                 * Prevent that the clock events layer tries to call
                 * the set mode function!
                 */
                dev->mode = CLOCK_EVT_MODE_UNUSED;

translating that into English:

	"Prevent the clock events layer calling the set_mode function"

That might be it - to confirm:

It then calls clockevents_exchange_device(dev, NULL).

clockevents_exchange_device(old,new) calls
clockevents_set_mode(old, CLOCK_EVT_MODE_UNUSED), which then does:

        if (dev->mode != mode) {

However, as dev->mode was set to CLOCK_EVT_MODE_UNUSED, and mode is
CLOCK_EVT_MODE_UNUSED, we don't call into the code which supplies the
clock event device at all, leaving it with no way to fully shutdown
its hardware.  It seems this is done on purpose, though it's not clear
why.

This is why arch code, such as ARM, has to implement its own solution
to shutdown clock event devices external to the generic clockevents code.
Until we have a generic solution, I think I'm going to take the above
code extract into the ARM generic local timer code and kill off the
local_timer_stop() function.
