Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab0DDQqj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 12:46:39 -0400
Received: from isilmar.linta.de ([213.133.102.198]:58815 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750762Ab0DDQqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 12:46:32 -0400
Date: Sun, 4 Apr 2010 18:39:24 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: A few questions and issues with dynticks, NOHZ and powertop
Message-ID: <20100404163924.GA18428@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Dmitry Torokhov <dtor@mail.ru>
References: <20100403223328.GA4507@comet.dominikbrodowski.net>
 <Pine.LNX.4.44L0.1004041110010.2750-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1004041110010.2750-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 04, 2010 at 11:17:37AM -0400, Alan Stern wrote:
> On Sun, 4 Apr 2010, Dominik Brodowski wrote:
> 
> > Booting a SMP-capable kernel with "nosmp", or manually offlining one CPU
> > (or -- though I haven't tested it -- booting a SMP-capable kernel on a
> > system with merely one CPU) means that in up to about half of the calls to
> > tick_nohz_stop_sched_tick() are aborted due to rcu_needs_cpu(). This is
> > quite strange to me: AFAIK, RCU is an excellent tool for SMP, but not really
> > needed for UP?
> 
> I can't answer the real question here, not knowing enough about the RCU
> implementation.  However, your impression is wrong: RCU very definitely
> _is_ useful and needed on UP systems.  It coordinates among processes
> (and interrupt handlers) as well as among processors.

Okay, but still: can't this be sped up by much on UP (especially if
CONFIG_RCU_FAST_NO_HZ is set), so that we can go to sleep right away?

> > 3) USB: built-in UHCI and a built-in 0a5c:2101 Broadcom Corp. A-Link
> > BlueUsbA2 Bluetooth module; built-in EHCI and a built-in 0ac8:c302 Z-Star
> > Microelectronics Corp. Vega USB 2.0 Camera.
> > 
> > usbcore.autosuspend is enabled (= 2), of course.
> > 
> > Recent USB suspend statistics
> > Active  Device name
> > 100.0%	USB device  7-1 : BCM92045NMD (Broadcom Corp)
> > 100.0%	USB device  1-2 : Vega USB 2.0 Camera. (Vimicro Corp.)
> > 100.0%	USB device usb7 : UHCI Host Controller (Linux 2.6.34-rc3 uhci_hcd)
> > 100.0%	USB device usb1 : EHCI Host Controller (Linux 2.6.34-rc3 ehci_hcd)
> > 
> > Booting into /bin/bash on a SMP kernel booted with "nosmp" leads to ~ 10
> > wakeups per second; disabling the cursor helps halfway (~ 5 wakeups); and
> > manually unbinding the USB host drivers from the USB host devices finally
> > lead to ~ 1.1 wakeups per second. What's keeping USB from suspending these
> > unused devices here?
> 
> Either the drivers don't support autosuspend or the devices aren't
> enabled for autosuspend.  By default, autosuspend is disabled for
> (almost) all non-hub devices.  You or your distribution must enable
> it manually by doing:
> 
> 	echo auto >/sys/bus/usb/devices/.../power/level
> 
> If the driver doesn't support autosuspend then enabling it won't be
> enough; you'll also have to unbind the driver from the device.  The
> easiest way to do this is to unconfigure the device:
> 
> 	echo 0 >/sys/bus/usb/devices/.../bConfigurationValue

Thanks! This way, it works, even without manually unbinding the host
drivers.

Best,
	Dominik
