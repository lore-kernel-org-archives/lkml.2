Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194Ab2AFUvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 15:51:04 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42969 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759112Ab2AFUvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 15:51:02 -0500
Date: Fri, 6 Jan 2012 20:50:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>, Frank Mandarino <fmandarino@endrelia.com>,
        Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: Public ridicule due to sound/soc/soc-core.c abuse of the
	driver model
Message-ID: <20120106205036.GB13857@n2100.arm.linux.org.uk>
References: <20120106194052.GA7781@kroah.com> <20120106201458.GF2893@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120106201458.GF2893@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 12:15:01PM -0800, Mark Brown wrote:
> On Fri, Jan 06, 2012 at 11:40:52AM -0800, Greg KH wrote:
> 
> > It was recently pointed out to me that the sound/soc/soc-core.c is
> > flagrantly abusing the driver model by providing "empty" release
> > functions, just to keep the kernel from complaining:
> 
> > Come on people, do you think that I wrote the code in the kernel that
> > produces those errors just for fun?  It was telling you to fix your code
> > by providing a function to free the structure that is being released,
> > not to try to trick the kernel because you think you know better.  The
> > kernel was trying to help you out here, to get the programming model
> > correct, in a place that was commonly misunderstood.
> 
> The problem is that due to the entertaining nature of AC'97 support in
> Linux we don't actually have anything to free at this point - we'd need
> to redo the whole infrastructure, not just this code.

The fact is that these bugs are oopses waiting to happen.  All you need
is the kernel to hold a reference to the kobject underlying the struct
device, and then release that reference after you've kfree'd the structure
containing the struct device, and the kernel will go bang.

I also disagree with your statement - I think it's quite simple to fix:

1. Change to using a flag to indicate whether the struct device is
   registered rather than ac97->dev.bus.
2. Change snd_soc_new_ac97_codec() to initialize codec->ac97->dev,
   including calling device_initialize() on it and setting the release
   function.
3. Change device_register(&codec->ac97->dev); to
   device_add(&codec->ac97->dev);
4. Make the AC97 device release function do the freeing of 'codec->ac97'
5. Change the current device_unregister(&codec->ac97->dev); to
   device_del(&codec->ac97->dev);
6. Change the various kfree(codec->ac97); in the file to do a
   device_put(&codec->ac97->dev);

This will cause device_put() to check the refcount, when that hits
zero it will call the release function, and that in turn will then
kfree() the ac97 structure.

If someone else is holding a reference to this struct device, kfree
will be called once that reference is dropped - and this is the
exact behaviour the driver model as a whole requires.

At least this gets the AC97 ASoC stuff fixed, and one less abuse of the
driver model in the kernel.
