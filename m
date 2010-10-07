Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab0JGVYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:24:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54356 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab0JGVYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:24:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sven Neumann <s.neumann@raumfeld.com>
Subject: Re: 2.6.35.6 fails to suspend (pxa2xx-mci.0)
Date: Thu, 7 Oct 2010 23:23:05 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Daniel Mack <daniel@caiaq.de>, Colin Cross <ccross@android.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1286177435.2140.5.camel@sven> <201010070218.41944.rjw@sisk.pl> <1286463808.797.10.camel@bender>
In-Reply-To: <1286463808.797.10.camel@bender>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010072323.05218.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 07, 2010, Sven Neumann wrote:
> Hi,
> 
> On Thu, 2010-10-07 at 02:18 +0200, Rafael J. Wysocki wrote:
> 
> > On Thursday, October 07, 2010, Daniel Mack wrote:
> > > On Mon, Oct 04, 2010 at 09:30:35AM +0200, Sven Neumann wrote:
> > > > we are running an embedded system here based on the PXA300 platform.
> > > > Suspend/resume used to work well so far. However after upgrading the
> > > > kernel from 2.6.34.7 to 2.6.35.6, we get the following error when trying
> > > > to suspend the system:
> > > > 
> > > > # echo "mem" > "/sys/power/state"
> > > > [ 5647.295953] PM: Syncing filesystems ... done.
> > > > [ 5647.318792] Freezing user space processes ... (elapsed 0.01 seconds) done.
> > > > [ 5647.337048] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> > > > [ 5647.356915] Suspending console(s) (use no_console_suspend to debug)
> > > > [ 5647.366651] pm_op(): platform_pm_suspend+0x0/0x5c returns -38
> > > > [ 5647.366671] PM: Device pxa2xx-mci.0 failed to suspend: error -38
> > > > [ 5647.367082] PM: Some devices failed to suspend
> > > 
> > > We've bisected this effect down to commit 152e1d5920 ("PM: Prevent
> > > waiting forever on asynchronous resume after failing suspend").
> > > Suspending our PXA3xx based system breaks with this patch.
> > > 
> > > I tried to understand what's going wrong, but I didn't follow the
> > > discussion about this logic, so I would rather like to pass it back to
> > > the originating people.
> > > 
> > > I can only guess that the problem here is the somewhat tricky handling
> > > around mmc_sdio_suspend(), which returns -ENODEV (-38) in case a
> > > particular function of a card can not be suspended. The SDIO core would
> > > have simply removed the card in this case normally, but the PM core
> > > seems to interfere now, stopping the whole suspend procedure.
> > > 
> > > Can anyone shed some light on this?
> > 
> > I wonder what happens if you echo 0 to /sys/power/pm_async ?
> 
> Nothing happens. The problem persists (tested with 2.6.36-rc7). What
> would you expect to happen?

Exactly that. :-)

Commit 152e1d5920 should not affect the non-async case (I'd be surprised if
it did really) and things should work with /sys/power/pm_async = 0 anyway.

Please try check if you can reproduce with commt 152e1d5920 reverted and
/sys/power/pm_async = 0.  If you can, that's a driver bug.

Thanks,
Rafael
