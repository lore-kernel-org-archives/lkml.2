Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab1LECmF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 21:42:05 -0500
Received: from netrider.rowland.org ([192.131.102.5]:51193 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752644Ab1LECmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 21:42:03 -0500
Date: Sun, 4 Dec 2011 21:42:02 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: NeilBrown <neilb@suse.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
        Peter Chen <peter.chen@freescale.com>, <gregkh@suse.de>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <hzpeterchen@gmail.com>, Igor Grinberg <grinberg@compulab.co.il>
Subject: Re: [PATCH 1/1] driver core: disable device's runtime pm during
 shutdown
In-Reply-To: <20111205085632.5976fe96@notabene.brown>
Message-ID: <Pine.LNX.4.44L0.1112042133470.7508-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Dec 2011, NeilBrown wrote:

> Hi,
>  this patches causes a problem for me.
> 
> Specifically it makes it impossible to power-down a device which uses twl4030
> for power control on an omap3 processor.
> 
> To perform the shutdown we need to send a command over the i2c bus.
> The relevant bus is called omap_i2c.1 and this is normally in suspend mode.
> When a request is sent, omap_i2c_xfer uses pm_runtime_get_sync to wake it up,
> performs the transfer, then calls pm_runtime_put to let it go back to sleep.
> 
> So it is asleep when the new pm_runtime_disable() call is made, so it stays
> asleep, omap_i2c_xfer cannot wake it, the transfer doesn't happen and the
> system doesn't get powered off.

In other words, to perform the system shutdown you need to send a 
command over the i2c bus after the bus controller's shutdown routine 
has been called?

> So here is a device that should *not* have pm disabled at shutdown.

Or maybe it shouldn't be shut down at all.

> So I feel this fix is a little too heavy-handed.
> I don't fully understand the problem scenario described above but it seems to
> me that if the auto-suspend timer can fire after the hardware has been shut
> down, then maybe the hardware-shutdown should be disabling that timer.  Maybe?

That's not robust.  The timer can be restarted, and there are other 
ways of initiating runtime PM besides the timer.

> Suggestions?

Can the shutdown routine for the i2c controller simply call
pm_runtime_enable()?

Alan Stern

