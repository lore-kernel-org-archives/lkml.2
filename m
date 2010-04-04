Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab0DDUrf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 16:47:35 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58800 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab0DDUr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 16:47:28 -0400
Date: Sun, 4 Apr 2010 13:47:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: A few questions and issues with dynticks, NOHZ and powertop
Message-ID: <20100404204725.GC2644@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100403223328.GA4507@comet.dominikbrodowski.net>
 <Pine.LNX.4.44L0.1004041110010.2750-100000@netrider.rowland.org>
 <20100404163924.GA18428@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100404163924.GA18428@comet.dominikbrodowski.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 04, 2010 at 06:39:24PM +0200, Dominik Brodowski wrote:
> On Sun, Apr 04, 2010 at 11:17:37AM -0400, Alan Stern wrote:
> > On Sun, 4 Apr 2010, Dominik Brodowski wrote:
> > 
> > > Booting a SMP-capable kernel with "nosmp", or manually offlining one CPU
> > > (or -- though I haven't tested it -- booting a SMP-capable kernel on a
> > > system with merely one CPU) means that in up to about half of the calls to
> > > tick_nohz_stop_sched_tick() are aborted due to rcu_needs_cpu(). This is
> > > quite strange to me: AFAIK, RCU is an excellent tool for SMP, but not really
> > > needed for UP?
> > 
> > I can't answer the real question here, not knowing enough about the RCU
> > implementation.  However, your impression is wrong: RCU very definitely
> > _is_ useful and needed on UP systems.  It coordinates among processes
> > (and interrupt handlers) as well as among processors.
> 
> Okay, but still: can't this be sped up by much on UP (especially if
> CONFIG_RCU_FAST_NO_HZ is set), so that we can go to sleep right away?

One situation that will prevent CONFIG_RCU_FAST_NO_HZ from putting the
machine to sleep right away is if there is an RCU callback posted that
spawns another RCU callback, and so on.  CONFIG_RCU_FAST_NO_HZ will handle
one callback that spawns another, but it gives up if the second callback
spawns a third.

Might this be what is happening to you?

If so, would you be willing to patch your kernel?  RCU_NEEDS_CPU_FLUSHES
is currently set to 5, and might be set to (say) 8.  This is defined
in kernel/rcutree_plugin.h, near line 990.

Another thing to try would be running with TINY_RCU, at least if it is
OK that RCU be non-preemptible.

							Thanx, Paul

> > > 3) USB: built-in UHCI and a built-in 0a5c:2101 Broadcom Corp. A-Link
> > > BlueUsbA2 Bluetooth module; built-in EHCI and a built-in 0ac8:c302 Z-Star
> > > Microelectronics Corp. Vega USB 2.0 Camera.
> > > 
> > > usbcore.autosuspend is enabled (= 2), of course.
> > > 
> > > Recent USB suspend statistics
> > > Active  Device name
> > > 100.0%	USB device  7-1 : BCM92045NMD (Broadcom Corp)
> > > 100.0%	USB device  1-2 : Vega USB 2.0 Camera. (Vimicro Corp.)
> > > 100.0%	USB device usb7 : UHCI Host Controller (Linux 2.6.34-rc3 uhci_hcd)
> > > 100.0%	USB device usb1 : EHCI Host Controller (Linux 2.6.34-rc3 ehci_hcd)
> > > 
> > > Booting into /bin/bash on a SMP kernel booted with "nosmp" leads to ~ 10
> > > wakeups per second; disabling the cursor helps halfway (~ 5 wakeups); and
> > > manually unbinding the USB host drivers from the USB host devices finally
> > > lead to ~ 1.1 wakeups per second. What's keeping USB from suspending these
> > > unused devices here?
> > 
> > Either the drivers don't support autosuspend or the devices aren't
> > enabled for autosuspend.  By default, autosuspend is disabled for
> > (almost) all non-hub devices.  You or your distribution must enable
> > it manually by doing:
> > 
> > 	echo auto >/sys/bus/usb/devices/.../power/level
> > 
> > If the driver doesn't support autosuspend then enabling it won't be
> > enough; you'll also have to unbind the driver from the device.  The
> > easiest way to do this is to unconfigure the device:
> > 
> > 	echo 0 >/sys/bus/usb/devices/.../bConfigurationValue
> 
> Thanks! This way, it works, even without manually unbinding the host
> drivers.
> 
> Best,
> 	Dominik
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
