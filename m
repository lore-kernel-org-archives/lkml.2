Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933774Ab0GOQgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 12:36:08 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48637 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933719Ab0GOQfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 12:35:53 -0400
Date: Thu, 15 Jul 2010 17:35:26 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Conke Hu <conke.hu@gmail.com>
Cc: CoffBeta <coffbeta@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
        inux kernel <linux-kernel@vger.kernel.org>,
        ext-jani.1.nikula@nokia.com,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: tq 2440
Message-ID: <20100715163526.GJ29322@n2100.arm.linux.org.uk>
References: <AANLkTimyBHliUa62qmfja_ke6YTTysiVAtJcZfi8l2gG@mail.gmail.com> <AANLkTil8GE1OguyAfp3XgfJvEmH98yNrlvGAx684a-qL@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTil8GE1OguyAfp3XgfJvEmH98yNrlvGAx684a-qL@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 11:16:30PM +0800, Conke Hu wrote:
> ever notice to the following kernel log?
> "Device 's3c2440-nand' does not have a release() function, it is
> broken and must."
> release() function should be implemented  in the platform_device.

That's not telling you to provide a release function.  The warning is
telling you that a device is being unregistered which doesn't have a
release function.

Consider this point - maybe it doesn't have a release function because
it's not supposed to be unregistered?

> > ------------[ cut here ]------------
> > WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x30/0x44()
> > sysfs: duplicate filename 'dm9000.0' can not be created

This is the cause of the problem.  You're registering two dm9000.0
devices.  That's illegal, and it then causes all these:

> > WARNING: at drivers/base/core.c:122 device_release+0x6c/0x78()
> > Device 's3c24xx_led.3' does not have a release() function, it is broken and mus.
> > WARNING: at drivers/base/core.c:122 device_release+0x6c/0x78()
> > Device 's3c24xx_led.2' does not have a release() function, it is broken and mus.
> > WARNING: at drivers/base/core.c:122 device_release+0x6c/0x78()
> > Device 's3c24xx_led.1' does not have a release() function, it is broken and mus.
> > WARNING: at drivers/base/core.c:122 device_release+0x6c/0x78()
> > Device 's3c24xx_led.0' does not have a release() function, it is broken and mus.
> > WARNING: at drivers/base/core.c:122 device_release+0x6c/0x78()
> > Device 's3c2440-nand' does not have a release() function, it is broken and must.
...

Fix the first problem (which is the real one) and you won't have these
other problems (which aren't actually a problem.)
