Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330Ab2AFXmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 18:42:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57407 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758920Ab2AFXmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 18:42:13 -0500
Date: Fri, 6 Jan 2012 15:41:39 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Greg KH <greg@kroah.com>, Frank Mandarino <fmandarino@endrelia.com>,
        Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: Public ridicule due to sound/soc/soc-core.c abuse of the driver
 model
Message-ID: <20120106234135.GH2893@opensource.wolfsonmicro.com>
References: <20120106194052.GA7781@kroah.com>
 <20120106201458.GF2893@opensource.wolfsonmicro.com>
 <20120106205036.GB13857@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120106205036.GB13857@n2100.arm.linux.org.uk>
X-Cookie: A is for Apple.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 08:50:36PM +0000, Russell King - ARM Linux wrote:
> On Fri, Jan 06, 2012 at 12:15:01PM -0800, Mark Brown wrote:

> > The problem is that due to the entertaining nature of AC'97 support in
> > Linux we don't actually have anything to free at this point - we'd need
> > to redo the whole infrastructure, not just this code.

> The fact is that these bugs are oopses waiting to happen.  All you need
> is the kernel to hold a reference to the kobject underlying the struct
> device, and then release that reference after you've kfree'd the structure
> containing the struct device, and the kernel will go bang.

Well, clearly.  But given that the chances of anyone actually removing
an AC'97 device from their system at runtime except in development is
pretty much zero it's not a practical problem.  I'm not saying this is
good, I'm just saying this is *far* from the only problem AC'97 has with
device model and the general fragility of the AC'97 code is such that
fiddling with it in Linus' tree to resolve an issue which is currently
only visible to code inspection doesn't fill me with happy thoughts.

> I also disagree with your statement - I think it's quite simple to fix:

> 1. Change to using a flag to indicate whether the struct device is
>    registered rather than ac97->dev.bus.
> 2. Change snd_soc_new_ac97_codec() to initialize codec->ac97->dev,
>    including calling device_initialize() on it and setting the release
>    function.

Which is crazy in itself since there is an AC'97 bus which shouldn't be
making us open code things.  Never mind the fact that the AC'97 bus is
enumerable so the fact that something other than the bus is even
instantiating these devices is at best questionalble.  But anyway.

> This will cause device_put() to check the refcount, when that hits
> zero it will call the release function, and that in turn will then
> kfree() the ac97 structure.

> If someone else is holding a reference to this struct device, kfree
> will be called once that reference is dropped - and this is the
> exact behaviour the driver model as a whole requires.

This only helps this specific device model bit of things, if anything is
still actually holding a reference to the device and tries to use it
after we tore away the resource underneath it we'll still explode (never
mind the fact that we're backing this stuff up with some global pointers
to other devices which may or may not actually be there...).
