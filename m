Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab0F2T52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 15:57:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41375 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755874Ab0F2T50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 15:57:26 -0400
Date: Tue, 29 Jun 2010 15:57:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, mark gross <640e9920@gmail.com>,
       Neil Brown <neilb@suse.de>, <linux-pci@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <Arve@smtp1.linux-foundation.org>,
       Florian Mickler <florian@mickler.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH] PM: Make it possible to avoid wakeup events
 from being lost
In-Reply-To: <53596.65110.qm@web180310.mail.gq1.yahoo.com>
Message-ID: <Pine.LNX.4.44L0.1006291533130.1314-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010, David Brownell wrote:

> Did someone post the canonical driver changes
> to make use of this?

No, not really.  The patch itself contains an example (PCI) but it 
doesn't demonstrate the full range of possible usages.

>  Something like
> 
>   suspend() { /* if wake-enabled, up count */ }
>   resume() { /* if upcounted, downcount */ }
> 
> is what first comes to mind.. expecting that
> the suspend/resume methods in the driver are
> already doing the right things for enabling
> and later disabling the "system wake" behavior
> on the various relevant hardware events...

The PCI example looks like this:

	resume()
	{
		...
		if (device_may_wakeup(dev))
			pm_wakeup_event(dev, TIMEOUT_GUESS);
		...
	}

where TIMEOUT_GUESS is an estimate of how long to wait before allowing 
the system to sleep.

For things like keyboards, an example would go more like this:

	irq_handler()
	{
		...
		if (key-press event occurred) {
			...
			if (input queue is empty)
				pm_stay_awake(dev);
			add event to input queue;
			...
		}
		...
	}

	read_queue()
	{
		...
		send queued data to userspace
		if (input queue is empty)
			pm_relax();
		...
	}

I left out the device_may_wakeup tests; things become rather 
complicated if you can have more than one keyboard feeding the same 
input queue and some of them are wakeup-enabled while others aren't.

Clearly the appropriate changes will depend on the subsystem and the
kind of event.  They may also end up depending on the platform; perhaps
this will be used only on relatively small systems like an Android
phone.

Alan Stern

