Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933932Ab1JDXfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 19:35:43 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62562 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933714Ab1JDXfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 19:35:41 -0400
Date: Tue, 4 Oct 2011 17:35:04 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: "G, Manjunath Kondaiah" <manjugk@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <greg@kroah.com>, Dilan Lee <dilee@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-omap@vger.kernel.org
Subject: Re: [RFC PATCH v3] drivercore: Add driver probe deferral mechanism
Message-ID: <20111004233504.GD3009@ponder.secretlab.ca>
References: <20110922184614.25419.84606.stgit@ponder>
 <20111004145148.GA8021@manju-desktop>
 <CACxGe6tXEx1A+ZuBTUdi8jjfx_hOCaX6eSpUOOhNH9us+Mnczg@mail.gmail.com>
 <20111004183516.GB8021@manju-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111004183516.GB8021@manju-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 12:05:16AM +0530, G, Manjunath Kondaiah wrote:
> On Tue, Oct 04, 2011 at 09:58:10AM -0600, Grant Likely wrote:
> > On Tue, Oct 4, 2011 at 8:51 AM, G, Manjunath Kondaiah <manjugk@ti.com> wrote:
> > > On Thu, Sep 22, 2011 at 12:51:23PM -0600, Grant Likely wrote:
> > >> Hi Manjunath,
> > >>
> > >> Here's the current state of the patch.  The major think that needs to
> > >> be done is to convert it to use a separate workqueue as described in
> > >> the TODO above.  It also needs some users adapted to it.  One of the
> > >> gpio drivers would work; preferably one of the newer drivers that
> > >> doesn't have a lot of drivers depending on the early_initcall()
> > >> behaviour yet.
> > >
> > > I have tested this patch on omap3 beagle board by making:
> > > 1. omap-gpio driver init as late_initcall instead of postcore_initcall
> > > 2. mmc driver probe will request gpio through gpio_request and gpio driver
> > > returns -EDEFER_PROBE which in turn makes mmc driver to request deferral probe.
> > > 3. When deferral probe gets activated, it scans driver entries and it will not
> > > find any match for mmc driver probe.
> > 
> > Looks like drivers/mmc/host/omap.c is using platform_driver_probe()
> > instead of platform_driver_register().  Add the probe hook to the
> > platform_driver structure and change it to call
> > platform_driver_register() and it should work.  Don't forget to change
> > mmc_omap_probe from __init to __devinit.
> 
> Yes. After changing it into platform_driver_register, I can see mmc probe is
> getting completed from deferred probe list. But, MMC upper layer will check 
> probe and it waits for ever since probe_count is not getting incremented.
> 
> Log:
> 
> [    1.807830] platform omap_hsmmc.0: Driver omap_hsmmc requests probe deferral
> 
> ...
> 
> [    1.948760] omap_device: omap_gpio.0: new worst case activate latency 0:30517
> [    1.959259] OMAP GPIO hardware version 2.5
> 
> ...
> 
> [    2.000488] platform omap_hsmmc.0: Retrying from deferred list
> [    2.008026] omap_device: omap_hsmmc.0: new worst case activate latency 0:244140
> [    2.020080] input: gpio-keys as /devices/platform/gpio-keys/input/input1
> [    2.035827] omap_hsmmc omap_hsmmc.0: Probe success...
> [    2.042083] twl_rtc twl_rtc: setting system clock to 2000-01-01 01:06:35 UTC
> (946688795)
> [    2.056030] Waiting for root device /dev/mmcblk0p2...
> [    2.061492] driver_probe_done: probe_count = 0
> [    2.168518] driver_probe_done: probe_count = 0
> [    2.277832] driver_probe_done: probe_count = 0
> [    2.387207] driver_probe_done: probe_count = 0
> [    2.496582] driver_probe_done: probe_count = 0
> 
> Waits for ever in init/do_mount.c:
> 	if ((ROOT_DEV == 0) && root_wait) {
> 		printk(KERN_INFO "Waiting for root device %s...\n",
> 			saved_root_name);
> 		while (driver_probe_done() != 0 ||
> 			(ROOT_DEV = name_to_dev_t(saved_root_name)) == 0)
> 			msleep(100);
> 		async_synchronize_full();
> 	}

Okay, it looks like the driver deferral workqueue needs to get kicked
off before the kernel starts waiting for the root filesystem.  Check
the initcall level that is being used by do_mount, and make sure the
deferred probe starts before that...

Hmmm.... wait, that doesn't make sense because the probe is still
successful.  What triggers the exit conditions in that while loop?
How would it be different from when the driver can probe successfully
without deferral?

g.

> 
> -Manjunath
