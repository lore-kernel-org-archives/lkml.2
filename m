Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab1BECkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 21:40:21 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:34211 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034Ab1BECkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 21:40:19 -0500
Date: Fri, 4 Feb 2011 18:39:13 -0800
From: Andres Salomon <dilinger@queued.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Timur Tabi <timur@freescale.com>,
        linux-input@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 12/19] twl4030: mfd_cell is now implicitly available to
 drivers
Message-ID: <20110204183913.318e6664@debxo>
In-Reply-To: <20110203093154.GC21591@opensource.wolfsonmicro.com>
References: <20110202195417.228e2656@queued.net>
	<20110202201522.72d37f1e@queued.net>
	<20110203060521.GA25739@core.coreip.homeip.net>
	<20110202223959.244b4a01@queued.net>
	<20110203065339.GA5592@core.coreip.homeip.net>
	<20110202230326.167fe873@queued.net>
	<20110203093154.GC21591@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Feb 2011 09:31:54 +0000
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Wed, Feb 02, 2011 at 11:03:26PM -0800, Andres Salomon wrote:
> > Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
> > > Then they are doing it incorrectly. One possible way is to have
> > > parent device carry relevant data in its drvdata and have
> > > children get it from there.
> 
> > I believe some drivers are even using the parent device already.
> > See drivers/leds/leds-mc13783.c, for example, whose parent device
> > drvdata is used to pass around a struct mc13783 to its children.
> > Sounds like a possibility, will need to look into it further.
> 
> That's the current best practice approach.

One of the main reasons to have the cell data in the platform
device rather than its parent device is because the parent device will
have the entire array of cells.  This isn't helpful when you want to
know specifically which cell's .enable hook to call.  One possibility
is to use the pdev->id field.  Currently, mfd-core allows drivers to
override this per-cell; depending upon how drivers make use of this,
I'm tempted to get rid of it from the mfd_cell struct and just always
have it be an index into the mfd_cell array (dictated by
mfd_add_devices).  Of course, wm831x-core/wm831x-dcdc does some pretty
weird stuff with ->id, so I still need to figure out if what it's doing
is really necessary.

I'm also struggling with a way to have cells automatically saved
by mfd-core. One (ugly) option would be to allow an mfd driver to set
drvdata, and mfd-core (in mfd_add_devices) would allocate a struct that
includes a pointer to drvdata as well as to the mfd_cells.  Drvdata
would be updated to point to this new struct instead.  In one scenario,
this requires evil macro redefining; in another, a weird API addition
to mfd_add_devices to pass the size of what's pointed to by the
parent's drvdata.  I don't like this option very much.

Another option is to require structs that mfd drivers assign to
drvdata to include a pointer to cells, but I'd really like a way to
enforce that with the compiler (BUILD_BUG_ON comes to mind).
It also runs into the problem of not knowing the type in drvdata. I'm
imagining something like:

#define mfd_get_cell(pdev, type) (((type *)platform_get_drvdata(pdev))->cell)

Even that would require the weird API of mfd_add_devices needing to be
passed the type of what's pointed to by the parent's drvdata.

