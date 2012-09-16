Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab2IPIZf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 04:25:35 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33809 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab2IPIZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 04:25:30 -0400
Date: Sun, 16 Sep 2012 09:25:10 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [BUG] Deferred probing in driver model is racy, resulting in
	lost probes
Message-ID: <20120916082510.GN12245@n2100.arm.linux.org.uk>
References: <20120818145856.GP18957@n2100.arm.linux.org.uk> <CACVXFVPahbFVEP4p2Z9-TvjQ52tUCMuDeLx0X6GP5t0h5gEV8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVPahbFVEP4p2Z9-TvjQ52tUCMuDeLx0X6GP5t0h5gEV8g@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2012 at 02:41:28PM +0800, Ming Lei wrote:
> On Sat, Aug 18, 2012 at 10:58 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > Okay, so EPROBE_DEFER seems to work when I build everything into the
> > kernel, but when I build a pile of ASoC drivers as modules, it fails
> > every time I've tried booting the platform so far.
> >
> > This is a v3.5 based kernel, with preempt enabled.
> >
> > Okay, what I have is a bunch of devices already pre-registered in the
> > system:
> >
> >         kirkwood-spdif-audio.1 (requiring module snd_soc_kirkwood_spdif)
> >         kirkwood-i2s.1 (requiring module snd_soc_kirkwood_i2s)
> >         kirkwood-pcm-audio.1 (requiring module snd_soc_kirkwood)
> >         spdif-dit (requiring module snd_soc_spdif)
> >
> > and the modules were loaded in this order:
> >
> > Module                  Size  Used by
> > snd_soc_spdif           1020  0         (spdif-dit driver)
> > dove                   24577  1         (dove-drm driver)
> > snd_soc_kirkwood_i2s     5209  0        (kirkwood-i2s driver)
> > snd_soc_kirkwood        3629  0         (kirkwood-pcm-audio driver)
> > snd_soc_kirkwood_spdif     1449  0      (kirkwood-spdif-audio driver)
> >
> > snd_soc_kirkwood_spdif will return -EPROBE_DEFER if it can't find the
> > devices registered into ASoC by the other three modules (referred to as
> > the CPU DAI, and Codec DAI).
> >
> > What I see in the debugging is this (I've added some to increase the
> > debuggability):
> >
> > bus: 'platform': add driver kirkwood-spdif-audio
> > bus: 'platform': driver_probe_device: matched device kirkwood-spdif-audio.1 with driver kirkwood-spdif-audio
> > bus: 'platform': really_probe: probing driver kirkwood-spdif-audio with device kirkwood-spdif-audio.1
> > kirkwood-spdif-audio kirkwood-spdif-audio.1: CPU DAI kirkwood-i2s.1 not registered
> > bus: 'platform': add driver kirkwood-pcm-audio
> > bus: 'platform': add driver kirkwood-i2s
> > kirkwood-spdif-audio kirkwood-spdif-audio.1: failed to register card
> > bus: 'platform': add driver dove-drm
> > platform kirkwood-spdif-audio.1: Driver kirkwood-spdif-audio requests probe deferral
> > platform kirkwood-spdif-audio.1: Added to deferred list
> > bus: 'platform': driver_probe_device: matched device kirkwood-pcm-audio.1 with driver kirkwood-pcm-audio
> > bus: 'platform': really_probe: probing driver kirkwood-pcm-audio with device kirkwood-pcm-audio.1
> > driver: 'kirkwood-pcm-audio.1': driver_bound: bound to device 'kirkwood-pcm-audio'
> > bus: 'platform': really_probe: bound device kirkwood-pcm-audio.1 to driver kirkwood-pcm-audio
> > platform kirkwood-spdif-audio.1: Retrying from deferred list
> > bus: device_attach 'kirkwood-spdif-audio.1' unbound
> 
> Looks the above message is added by yourself, where did you add
> the message?

In... device_attach().  I don't remember where because it's been soo long
since I investigated and reported this problem.  If you're going to take
a month since the report to get around to replying, don't expect folk to
be very helpful when you ask for more information... especially when they
lose the debugging patch they were using to generate this.

> > bus: __device_attach 'kirkwood-spdif-audio.1' probing with 'dove-temp'
> > bus: __device_attach 'kirkwood-spdif-audio.1' probing with 'galcore'
> > bus: __device_attach 'kirkwood-spdif-audio.1' probing with 'alarmtimer'
> > bus: __device_attach 'kirkwood-spdif-audio.1' probing with 'mv_xor_shared'
> > bus: __device_attach 'kirkwood-spdif-audio.1' probing with 'mv_xor'
> > bus: __device_attach 'kirkwood-spdif-audio.1' probing with 'serial8250'
> > bus: __device_attach 'kirkwood-spdif-audio.1' probing with 'sata_mv'
> > bus: __device_attach 'kirkwood-spdif-audio.1' probing with 'orion_spi'
> > bus: __device_attach 'kirkwood-spdif-audio.1' probing with 'mv643xx_eth'
> > bus: __device_attach 'kirkwood-spdif-audio.1' probing with 'mv643xx_eth_port'
> > bus: __device_attach 'kirkwood-spdif-audio.1' probing with 'ap510-vmeta'
> > bus: __device_attach 'kirkwood-spdif-audio.1' probing with 'orion-ehci'
> > bus: __device_attach 'kirkwood-spdif-audio.1' probing with 'rtc-mv'
> > bus: __device_attach 'kirkwood-spdif-audio.1' probing with 'mv64xxx_i2c'
> > bus: __device_attach 'kirkwood-spdif-audio.1' probing with 'gpio-rc-recv'
> > bus: __device_attach 'kirkwood-spdif-audio.1' probing with 'sdhci-pxav2'
> > bus: __device_attach 'kirkwood-spdif-audio.1' probing with 'sdhci-dove'
> > bus: __device_attach 'kirkwood-spdif-audio.1' probing with 'leds-gpio'
> > bus: __device_attach 'kirkwood-spdif-audio.1' probing with 'snd-soc-dummy'
> > bus: __device_attach 'kirkwood-spdif-audio.1' probing with 'soc-audio'
> > bus: __device_attach 'kirkwood-spdif-audio.1' probing with 'kirkwood-pcm-audio'
> >
> > What you notice here is that the kirkwood-spdif-audio driver has gone
> > missing - it hasn't been unloaded, and it still appears in sysfs, and
> > it can still be cleanly unloaded and reloaded.
> 
> It is a bit weird, and I am wondering why is the driver of  kirkwood-spdif-audio
> deleted from bus->p->klist_drivers without being unregistered from
> platform bus?

It isn't.  As I said, it's a race condition due to lack of locking - the
driver hasn't been added to the list of drivers at this point:

int bus_add_driver(struct device_driver *drv)
{
...
        if (drv->bus->p->drivers_autoprobe) {
                error = driver_attach(drv);
                if (error)
                        goto out_unregister;
        }
        klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers);
...
}

Notice that the attaching is done _before_ the driver is added to the
bus driver list.

> > bus: 'platform': driver_probe_device: matched device kirkwood-i2s.1 with driver kirkwood-i2s
> > bus: 'platform': really_probe: probing driver kirkwood-i2s with device kirkwood-i2s.1
> > kirkwood-i2s kirkwood-i2s.1: found external clock
> > driver: 'kirkwood-i2s.1': driver_bound: bound to device 'kirkwood-i2s'
> > bus: 'platform': really_probe: bound device kirkwood-i2s.1 to driver kirkwood-i2s
> > bus: 'platform': driver_probe_device: matched device dove-drm with driver dove-drm
> > bus: 'platform': really_probe: probing driver dove-drm with device dove-drm
> > bus: 'platform': add driver spdif-dit
> > [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> > [drm] No driver support for vblank timestamp query.
> > fb0: dove-drmfb frame buffer device
> > drm: registered panic notifier
> > [drm] Initialized dove-drm 1.0.0 20120730 on minor 0
> > driver: 'dove-drm': driver_bound: bound to device 'dove-drm'
> > bus: 'platform': really_probe: bound device dove-drm to driver dove-drm
> > bus: 'platform': driver_probe_device: matched device spdif-dit with driver spdif-dit
> > bus: 'platform': really_probe: probing driver spdif-dit with device spdif-dit
> > driver: 'spdif-dit': driver_bound: bound to device 'spdif-dit'
> > bus: 'platform': really_probe: bound device spdif-dit to driver spdif-dit
> >
> > I suspect what is going on is that we have a race condition between the
> > device being added to the deferred list vs other drivers successfully
> > probing and running the deferred list, and the driver with the deferred
> > device being added to the driver list.
> >
> > This allows the deferred list to be run *before* the driver is placed
> > onto the bus driver list, which means when we try to re-probe deferred
> 
> Looks the above should not be a problem. After the driver is placed
> on the bus, it still will call driver_attach to probe all unbound devices
> on the bus.

Of course it's not a problem - of course, silly me, that's why it doesn't
work.  I'm sorry for reporting that something doesn't work, and now I see
it's all my fault.  Of course.  Stupid me.  Sorry for reporting a problem.

> > devices, we find no matching driver to probe the device with.  This
> > then results in the device being dropped off the deferred probe list
> > (as the only way it stays on that list is if a driver is probed _and_
> > it returns -EPROBE_DEFER.)
> 
> 
> Thanks,
> -- 
> Ming Lei
