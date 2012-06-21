Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742Ab2FUK7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 06:59:09 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:50016 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757690Ab2FUK7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 06:59:07 -0400
Date: Thu, 21 Jun 2012 12:59:00 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Greg KH <gregkh@linuxfoundation.org>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: Thunderbolt, Apple Monitor & MBA, and excess kworker load
Message-ID: <20120621105900.GA5934@air.dominikbrodowski.net>
References: <20120620154842.GA5788@air.dominikbrodowski.net>
 <20120620155626.GA3384@kroah.com>
 <20120620161012.GK7170@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120620161012.GK7170@phenom.ffwll.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, Jun 20, 2012 at 06:10:12PM +0200, Daniel Vetter wrote:
> On Wed, Jun 20, 2012 at 08:56:26AM -0700, Greg KH wrote:
> > On Wed, Jun 20, 2012 at 05:48:42PM +0200, Dominik Brodowski wrote:
> > > Hi,
> > > 
> > > At work, I wish to attach a 27" Apple Display using thunderbolt to my Mac
> > > Book Air 4,2 13". Using OS X, it works fine, but as I prefer using Linux, I
> > > tested out Ubuntu's stock kernel and (among other) 3.5.0-rc3+ as of f40759e.
> > > Hotplug doesn't work (known issue), but also with coldplug the display
> > > reacts _very_ slow, way too slow for real use: The screen updates only every
> > > half second or so. Is this a known bug? Might something go afoul with
> > > kworker -- they need about 75% of the CPU with the large display attached,
> > > and less than 1% _without_ the large display.
> > 
> > It's not really a known bug, but it is known that Thunderbolt doesn't
> > work all that well, if at all, in Linux due to the BIOS issues that you
> > have run into (the hotplug stuff.)

Is there anything where I could help?

> > Once the device is seen, it should just work like any other PCI device,
> > and so, that might be a DRM driver issue somehow.
> 
> A quick full-system profile would be a good start to tell where we're
> burning through all these cycles exaclty. Also, anything special going on
> with interrupts (if this excessive load is due to supurious display
> hotplug events, drm/i915 should get _tons_ of interrupts).

Did a $ perf record -a -g sleep 10 , and that shows:

-  11,67%      kworker/1:1  [kernel.kallsyms]
   + native_read_tsc
   + delay_tsc

-   9,56%      kworker/3:2  [kernel.kallsyms]
   + native_read_tsc
   + delay_tsc

and other uninteresting things. 

   $ echo workqueue:workqueue_queue_work > /sys/kernel/debug/tracing/set_event
   $ cat /sys/kernel/debug/tracing/trace_pipe

shows these top functions:

    305 i915_hotplug_work_func
    504 flush_to_ldisc
  14759 do_dbs_timer

so nothing of interest either. Interrupts: pretty normal.

Any ideas on how to debug this further?

Thanks & best,

	Dominik
