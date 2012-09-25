Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab2IYK7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 06:59:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39834 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2IYK73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 06:59:29 -0400
Date: Tue, 25 Sep 2012 11:59:13 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Poddar, Sourav" <sourav.poddar@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, gregkh@linuxfoundation.org, khilman@ti.com,
        paul@pwsan.com, tony@atomide.com, linux-kernel@vger.kernel.org,
        santosh.shilimkar@ti.com, linux-serial@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        alan@linux.intel.com
Subject: Re: [RFT/PATCH] serial: omap: prevent resume if device is not
	suspended.
Message-ID: <20120925105913.GM31374@n2100.arm.linux.org.uk>
References: <1347972050-3509-1-git-send-email-sourav.poddar@ti.com> <CAKdam572krJZcayRdJ_AciCUZH3LuzD9yoHenhxrB6j9xDZ6JQ@mail.gmail.com> <20120925083029.GG31374@n2100.arm.linux.org.uk> <20120925083118.GI9137@arwen.pp.htv.fi> <20120925091228.GI31374@n2100.arm.linux.org.uk> <20120925091112.GK9137@arwen.pp.htv.fi> <20120925092118.GJ31374@n2100.arm.linux.org.uk> <CAKdam57bpTJ94Gn=mKVw1Fm-76fVPp3DGjFuNu_HfesybM1hPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKdam57bpTJ94Gn=mKVw1Fm-76fVPp3DGjFuNu_HfesybM1hPg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right, let's get this thread back onto a constructive footing and try
to understand the problems here.

On Tue, Sep 25, 2012 at 03:26:06PM +0530, Poddar, Sourav wrote:
> The issue was observed at serial init itself in the N800 board and the
> log does not show up much.
> http://www.pwsan.com/omap/testlogs/test_tty_next_e36851d0/20120910020323/boot/2420n800/2420n800_log.txt

Right, so output stops when ttyO2 is initialized.

> What we thought the problem might be with n800 is that it tries to
> resume when it didn't suspend before.
> 
> There are two ways through which we thought of handling this issue:
> 
> a) set device as active before enabling pm (which will prevent
> 
> pm_runtime_set_active(dev);
> pm_runtime_enable(dev);
> 
> OR
> 
> b) adding a "suspended" flag to struct omap_uart_port which gets set on
> suspend and cleared on resume. Then on resume you can check:
> 
> if (!up->suspended)
>         return 0;
> 
> But using "pm_runtime_set_active" approach breaks things even on
> beagle board xm, though it works fine on Panda.

Right, so now the question becomes - what is different on the Beagle Board
that prevents solution (a) from working - or put it another way, have we
uncovered _another_ bug.

For N800, for ttyO0 and ttyO1 which aren't in use, it may be correct.
We don't know for certain.  For ttyO2, the port is clearly already in
use as it's being used for console output.  So that means it's _not_
in suspended state, and therefore the initial runtime PM state is
wrong.

For Beagleboard - who knows, we have no information on that.  All we
know is that your (a) sequence causes a regression.

Anyway, let's analyse the code paths.  What is pm_runtime_get_sync()
doing?  Well, it calls __pm_runtime_resume(, RPM_GET_PUT).  That alters
the parent device's state (which doesn't matter for this, as the platform
device is a child of the main platform device, which has no runtime PM.)

It then calls the resume callback (from the pm domain/type/class/bus/
driver) and then does an idle check.

OMAP devices have a pm domain, so this is the candidate for the callback
at this level, which gets us into _od_runtime_resume().  This calls
omap_device_enable() before then moving on to the driver's runtime resume
method, and at that point the runtime PM resume is complete.

So, with your (a) solution, what's different is that we omit calling
omap_device_enable().  Therefore, my hunch is the reason that Beagleboard
doesn't work is because it doesn't like missing that call.

I bet if you do this:

	omap_device_enable(dev);
	pm_runtime_set_active(dev);
	pm_runtime_enable(dev);

that this will solve your problem, and Beagleboard will continue working.

What we have is a mismatch in both your case, and the Beagleboard case,
between the real state of the hardware, the runtime PM state, and the
OMAP hwmod state, and the above should bring all those states entirely
into line with each other for _every_ case.  It doesn't need any hacks
to prevent resume callbacks without prior suspends (which, incidentally,
the runtime PM core already guarantees provided you get the initial
state correct.)
