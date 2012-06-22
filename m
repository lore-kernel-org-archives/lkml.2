Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013Ab2FVQcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 12:32:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:10991 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565Ab2FVQcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 12:32:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="159630292"
Date: Fri, 22 Jun 2012 09:32:14 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alexis Cortes <alexis.cortes@ti.com>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Quach, Brian'" <brian.quach@ti.com>,
        "'Llamas, Jorge'" <jorge.llamas@ti.com>
Subject: Re: [PATCH] usb: host: xhci: Compliance Mode port recovery
Message-ID: <20120622163214.GC629@xanatos>
References: <002801cd4e68$a4b4f3a0$ee1edae0$@cortes@ti.com>
 <20120619223928.GD21104@xanatos>
 <004101cd4f33$755e8eb0$601bac10$@cortes@ti.com>
 <20120621000734.GB32743@xanatos>
 <003701cd4fde$fd969290$f8c3b7b0$@cortes@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003701cd4fde$fd969290$f8c3b7b0$@cortes@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 01:52:20PM -0500, Alexis Cortes wrote:
> Hi Sarah,
> > How often is this timing issue hit?  On every plug in?  Every 100 plug
> ins?
> > Is it specific to which devices are plugged in or can it be triggered for
> > any device?  Does the redriver get stuck in this state, or is it
> transient?
> 
> It depends on the manufacturing quality of the port terminations and
> internal connections; from our testing we determined the issue hits about
> 20% to 40% of the times. This issue will happen only at first insertion,
> once a port has entered U0, it will never enter compliance (until the system
> is rebooted or sent to S4, i.e. when the redriver is power-cycled).
> 
> This issue can be triggered by any SS device, and once port enters
> compliance, no other device of any kind/speed will work on this port and the
> port will remain unusable until a warm reset is issued or system is power
> cycled.

If I'm understanding you correctly, when this issue is hit once, and we
warm reset the port, the port will never go into compliance mode again.
So even if the user unplugs the device, and the port goes back into
polling, the next plug in will never go into compliance mode, until
after an S4 resume or a power-cycle.  Is that correct?

If so, I see no reason why we shouldn't increase the timer to 10
seconds.  The user will see one very slow enumeration per port, and then
all the other enumerations will work at the normal speed.

> Let me explain this more clearly:
> There's no way to know which ports of the host controller have a redriver
> between the root-port and the physical port, so we need to poll all the
> ports.
> If a port that has the redriver has previously enter to U0 at least once (it
> doesn't matter the actual state of the port, only if it has previously
> entered U0), then the compliance mode issue won't happen (until the system
> is power-cycled or if it resumes from S4). So if all ports have entered at
> least once to U0, I can disable the timer because I know for sure the
> compliance issue won't happen at any port.

Ok, this statement makes it more clear.  Based on that, I think a 10
second timer would work.

I think you'll need a dynamically allocated port bitmask array in the
xhci_hcd to keep track of which ports have entered U0 at least once
since the module was loaded, or we came back from S4.  Then you can
disable the timer if all the ports have come into U0.

This is really going to suck from a power management perspective.  "How
do I stop the timer from polling?"  "Oh, you plug a device into every
single port"  "But there's an internal port with nothing connected!"
"Uhhh..."

Greg, are you sure wouldn't consider a sysfs file for changing the
polling interval?

Sarah Sharp
