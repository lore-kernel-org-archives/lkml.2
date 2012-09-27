Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab2I0RWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 13:22:41 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:65072 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab2I0RWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 13:22:39 -0400
MIME-Version: 1.0
In-Reply-To: <20120927140300.GF14358@n2100.arm.linux.org.uk>
References: <20120818145856.GP18957@n2100.arm.linux.org.uk>
	<CACVXFVPahbFVEP4p2Z9-TvjQ52tUCMuDeLx0X6GP5t0h5gEV8g@mail.gmail.com>
	<20120916082510.GN12245@n2100.arm.linux.org.uk>
	<CACVXFVOZ=4HFAy38q_8ZUjOPffcv_mMTi7KCdh3HcX=MCLw5SQ@mail.gmail.com>
	<20120926200833.GA14340@kroah.com>
	<20120926202321.GD30938@n2100.arm.linux.org.uk>
	<CACVXFVPnpQ6yHiDaoo_CPG7oSEq+ZzxpmTgQv55-tRRyaavDfA@mail.gmail.com>
	<20120927135809.GE14358@n2100.arm.linux.org.uk>
	<20120927140300.GF14358@n2100.arm.linux.org.uk>
Date: Thu, 27 Sep 2012 19:22:38 +0200
Message-ID: <CAGhQ9VzJtx3MJF1wdJd8hv7Hp4T0YJK=vNbJWGj_W7X+mLy-xQ@mail.gmail.com>
Subject: Re: [BUG] Deferred probing in driver model is racy, resulting in lost probes
From: Joachim Eastwood <manabian@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ming Lei <tom.leiming@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Sep 27, 2012 at 4:03 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Sep 27, 2012 at 02:58:09PM +0100, Russell King - ARM Linux wrote:
>> On Thu, Sep 27, 2012 at 07:47:46AM +0800, Ming Lei wrote:
>> > On Thu, Sep 27, 2012 at 4:23 AM, Russell King - ARM Linux
>> > <linux@arm.linux.org.uk> wrote:
>> > > To be honest, I've not bothered to test the above patch, and now when I
>> > > look at it, I notice it's broken - in that on error it will corrupt the
>> > > driver list.  Take a look at the error path.
>> > >
>> > > priv is drv->p.  We add priv->knode_bus to the driver list.  If
>> > > driver_attach() returns an error, then we go to out_unregister, which
>> >
>> > In fact, driver_attach() always returns zero, so it does __not__ affect
>> > your test.
>>
>> It may not affect my test, but the fact is, that patch lays down the
>> foundations for bugs to be introduced.  Now, while I can test it (and
>> have done) I don't think it's suitable for mainline because of _that_.
>>
>> If driver_attach() always returns zero, there's no point in it returning
>> a value - it might as well return void and stop leading people to
>> believe that it might return an error.  So I suggest this alternative
>> patch instead, which gets rid of what is effectively dead code, and
>> probably a few warnings about not checking the return value from a
>> __must_check function (see usb-serial.c).
>>
>> With this patch, no one is lead into a false sense of security that,
>> after your patch, if driver_attach() ever returns an error, proper
>> cleanup will happen - it's blatently obvious to anyone modifying it
>> that if they do want it to return an error, they have to audit all the
>> users of it, which IMHO is a good thing.
>
> Sorry, old version of that patch.  Here's the right one.

<snip patch>

I am also having problems with ASoC modules and deferred probing. This
patch seems to improve the a lot situation, though. Now it work most
of the time, but occasionally I get the warning below.

Not sure if this is directly related to the issue Russell have been
seeing. Guess it can be races in the Atmel ASoC drivers as well(?).

[   12.230000] mpa1600-audio mpa1600-audio.0: CODEC wm8776.0-001b not registered
[   12.390000] mpa1600-audio mpa1600-audio.0: snd_soc_register_card()
failed: -517
[   12.390000] platform mpa1600-audio.0: Driver mpa1600-audio requests
probe deferral
[   12.720000] ------------[ cut here ]------------
[   12.720000] WARNING: at fs/sysfs/dir.c:536 sysfs_add_one+0x7c/0xa0()
[   12.740000] mpa1600-audio mpa1600-audio.1: CODEC wm8776.0-001a not registered
[   12.910000] mpa1600-audio mpa1600-audio.1: snd_soc_register_card()
failed: -517
[   13.140000] sysfs: cannot create duplicate filename
'/devices/platform/ssc.0/atmel-ssc-dai.0'
[   13.140000] Modules linked in: snd_soc_mpa1600_wm8776(+)
snd_soc_atmel_ssc_dai snd_soc_core pcmcia regmap_i2c snd_pcm
snd_page_alloc ad525x_dpot_i2c snd_timer ad525x_dpot ohci_hcd
leds_pca9532 snd usbcore soundcore gpio_keys rege
[   13.630000] Backtrace:
[   13.630000] [<c000c46c>] (dump_backtrace+0x0/0x10c) from
[<c021ac48>] (dump_stack+0x18/0x1c)
[   13.980000]  r7:c3839ca8 r6:c00d0cf0 r5:c0278f34 r4:00000218
[   13.990000] [<c021ac30>] (dump_stack+0x0/0x1c) from [<c0015ad0>]
(warn_slowpath_common+0x54/0x6c)
[   14.240000] [<c0015a7c>] (warn_slowpath_common+0x0/0x6c) from
[<c0015b8c>] (warn_slowpath_fmt+0x38/0x40)
[   14.470000]  r8:c2d41110 r7:ffffffef r6:c3839ce8 r5:c3a47780 r4:c2c58000
[   14.480000] [<c0015b54>] (warn_slowpath_fmt+0x0/0x40) from
[<c00d0cf0>] (sysfs_add_one+0x7c/0xa0)
[   14.660000]  r3:c2c58000 r2:c0278f64
[   14.660000] [<c00d0c74>] (sysfs_add_one+0x0/0xa0) from [<c00d1898>]
(create_dir+0x6c/0xc0)
[   14.790000]  r7:00000000 r6:00000000 r5:c3a47780 r4:c3839ce8
[   14.790000] [<c00d182c>] (create_dir+0x0/0xc0) from [<c00d19c4>]
(sysfs_create_dir+0xd8/0xf0)
[   14.850000] [<c00d18ec>] (sysfs_create_dir+0x0/0xf0) from
[<c01252f8>] (kobject_add_internal+0xe4/0x1e0)
[   14.870000]  r7:c2d41b00 r6:c02cc2e0 r5:00000000 r4:c2d41110
[   14.880000] [<c0125214>] (kobject_add_internal+0x0/0x1e0) from
[<c0125644>] (kobject_add_varg+0x44/0x54)
[   14.890000] [<c0125600>] (kobject_add_varg+0x0/0x54) from
[<c01256dc>] (kobject_add+0x4c/0x58)
[   14.900000]  r6:00000000 r5:c2d41108 r4:c2d41100
[   14.910000] [<c0125690>] (kobject_add+0x0/0x58) from [<c015220c>]
(device_add+0xe4/0x5d0)
[   14.920000]  r3:c3839db4 r2:00000000
[   14.920000] [<c0152128>] (device_add+0x0/0x5d0) from [<c01561a8>]
(platform_device_add+0x10c/0x164)
[   14.930000] [<c015609c>] (platform_device_add+0x0/0x164) from
[<bf11a9f4>] (atmel_ssc_set_audio+0xac/0xdc [snd_soc_atmel_ssc_dai])
[   14.940000]  r7:c2d41b00 r6:00000000 r5:c2d41100 r4:c02ccf90
[   14.950000] [<bf11a948>] (atmel_ssc_set_audio+0x0/0xdc
[snd_soc_atmel_ssc_dai]) from [<bf11f038>]
(mpa1600_audio_probe+0x38/0x88 [snd_soc_mpa1600_wm8776])
[   14.960000]  r7:bf11f464 r6:c02ccf98 r5:bf11f4a0 r4:c02ccf90
[   14.960000] [<bf11f000>] (mpa1600_audio_probe+0x0/0x88
[snd_soc_mpa1600_wm8776]) from [<c0155b6c>]
(platform_drv_probe+0x20/0x24)
[   14.990000]  r6:c02ccf98 r5:c02ccf98 r4:bf11f464
[   14.990000] [<c0155b4c>] (platform_drv_probe+0x0/0x24) from
[<c0154680>] (driver_probe_device+0xb8/0x20c)
[   15.000000] [<c01545c8>] (driver_probe_device+0x0/0x20c) from
[<c01548a4>] (__device_attach+0x48/0x4c)
[   15.010000]  r7:c3839ea8 r6:c02ccf98 r5:c02ccf98 r4:bf11f464
[   15.020000] [<c015485c>] (__device_attach+0x0/0x4c) from
[<c0152dc0>] (bus_for_each_drv+0x5c/0x9c)
[   15.030000]  r5:c015485c r4:00000000
[   15.030000] [<c0152d64>] (bus_for_each_drv+0x0/0x9c) from
[<c015493c>] (device_attach+0x6c/0x8c)
[   15.040000]  r7:00000089 r6:c02ccfcc r5:c02d7518 r4:c02ccf98
[   15.050000] [<c01548d0>] (device_attach+0x0/0x8c) from [<c0153988>]
(bus_probe_device+0x34/0xa4)
[   15.060000]  r6:c02ccf98 r5:c02d7518 r4:c02ccf98
[   15.060000] [<c0153954>] (bus_probe_device+0x0/0xa4) from
[<c0154240>] (deferred_probe_work_func+0x60/0x94)
[   15.070000]  r6:c02e3750 r5:c02d7400 r4:c02ccf98
[   15.080000] [<c01541e0>] (deferred_probe_work_func+0x0/0x94) from
[<c002c338>] (process_one_work+0x310/0x4a0)
[   15.090000]  r5:c3804500 r4:c02d7408
[   15.100000] [<c002c028>] (process_one_work+0x0/0x4a0) from
[<c002cbc8>] (worker_thread+0x3b8/0x5e0)
[   15.110000] [<c002c810>] (worker_thread+0x0/0x5e0) from
[<c00336e4>] (kthread+0x8c/0x98)
[   15.110000] [<c0033658>] (kthread+0x0/0x98) from [<c001b4d4>]
(do_exit+0x0/0x720)
[   15.120000]  r7:00000013 r6:c001b4d4 r5:c0033658 r4:c3827ecc
[   15.130000] ---[ end trace d7472237284e57c2 ]---
[   15.130000] platform mpa1600-audio.1: Driver mpa1600-audio requests
probe deferral
[   15.150000] ------------[ cut here ]------------
[   15.150000] WARNING: at lib/kobject.c:196 kobject_add_internal+0x17c/0x1e0()
[   15.250000] kobject_add_internal failed for atmel-ssc-dai.0 with
-EEXIST, don't try to register things with the same name in the same
directory.
[   15.390000] Modules linked in: snd_soc_mpa1600_wm8776
snd_soc_atmel_ssc_dai snd_soc_core pcmcia regmap_i2c snd_pcm
snd_page_alloc ad525x_dpot_i2c snd_timer ad525x_dpot ohci_hcd
leds_pca9532 snd usbcore soundcore gpio_keys regmape
[   15.470000] Backtrace:
[   15.470000] [<c000c46c>] (dump_backtrace+0x0/0x10c) from
[<c021ac48>] (dump_stack+0x18/0x1c)
[   15.520000]  r7:c3839d28 r6:c0125390 r5:c027f187 r4:000000c4
[   15.520000] [<c021ac30>] (dump_stack+0x0/0x1c) from [<c0015ad0>]
(warn_slowpath_common+0x54/0x6c)
[   15.620000] [<c0015a7c>] (warn_slowpath_common+0x0/0x6c) from
[<c0015b8c>] (warn_slowpath_fmt+0x38/0x40)
[   15.640000]  r8:ffffffef r7:c2d41b00 r6:c02cc2e0 r5:ffffffef r4:c2d41110
[   15.650000] [<c0015b54>] (warn_slowpath_fmt+0x0/0x40) from
[<c0125390>] (kobject_add_internal+0x17c/0x1e0)
[   15.670000]  r3:c02247bc r2:c027f21f
[   15.680000] [<c0125214>] (kobject_add_internal+0x0/0x1e0) from
[<c0125644>] (kobject_add_varg+0x44/0x54)
[   15.700000] [<c0125600>] (kobject_add_varg+0x0/0x54) from
[<c01256dc>] (kobject_add+0x4c/0x58)
[   15.720000]  r6:00000000 r5:c2d41108 r4:c2d41100
[   15.720000] [<c0125690>] (kobject_add+0x0/0x58) from [<c015220c>]
(device_add+0xe4/0x5d0)
[   15.740000]  r3:c3839db4 r2:00000000
[   15.760000] [<c0152128>] (device_add+0x0/0x5d0) from [<c01561a8>]
(platform_device_add+0x10c/0x164)
[   15.760000] [<c015609c>] (platform_device_add+0x0/0x164) from
[<bf11a9f4>] (atmel_ssc_set_audio+0xac/0xdc [snd_soc_atmel_ssc_dai])
[   15.790000]  r7:c2d41b00 r6:00000000 r5:c2d41100 r4:c02ccf90
[   15.810000] [<bf11a948>] (atmel_ssc_set_audio+0x0/0xdc
[snd_soc_atmel_ssc_dai]) from [<bf11f038>]
(mpa1600_audio_probe+0x38/0x88 [snd_soc_mpa1600_wm8776])
[   15.840000]  r7:bf11f464 r6:c02ccf98 r5:bf11f4a0 r4:c02ccf90
[   15.840000] [<bf11f000>] (mpa1600_audio_probe+0x0/0x88
[snd_soc_mpa1600_wm8776]) from [<c0155b6c>]
(platform_drv_probe+0x20/0x24)
[   15.860000]  r6:c02ccf98 r5:c02ccf98 r4:bf11f464
[   15.880000] [<c0155b4c>] (platform_drv_probe+0x0/0x24) from
[<c0154680>] (driver_probe_device+0xb8/0x20c)
[   15.900000] [<c01545c8>] (driver_probe_device+0x0/0x20c) from
[<c01548a4>] (__device_attach+0x48/0x4c)
[   15.910000]  r7:c3839ea8 r6:c02ccf98 r5:c02ccf98 r4:bf11f464
[   15.920000] [<c015485c>] (__device_attach+0x0/0x4c) from
[<c0152dc0>] (bus_for_each_drv+0x5c/0x9c)
[   15.940000]  r5:c015485c r4:00000000
[   15.950000] [<c0152d64>] (bus_for_each_drv+0x0/0x9c) from
[<c015493c>] (device_attach+0x6c/0x8c)
[   15.960000]  r7:00000089 r6:c02ccfcc r5:c02d7518 r4:c02ccf98
[   15.970000] [<c01548d0>] (device_attach+0x0/0x8c) from [<c0153988>]
(bus_probe_device+0x34/0xa4)
[   16.000000]  r6:c02ccf98 r5:c02d7518 r4:c02ccf98
[   16.030000] [<c0153954>] (bus_probe_device+0x0/0xa4) from
[<c0154240>] (deferred_probe_work_func+0x60/0x94)
[   16.050000]  r6:c02e3750 r5:c02d7400 r4:c02ccf98
[   16.070000] [<c01541e0>] (deferred_probe_work_func+0x0/0x94) from
[<c002c338>] (process_one_work+0x310/0x4a0)
[   16.100000]  r5:c3804500 r4:c02d7408
[   16.100000] [<c002c028>] (process_one_work+0x0/0x4a0) from
[<c002cbc8>] (worker_thread+0x3b8/0x5e0)
[   16.120000] [<c002c810>] (worker_thread+0x0/0x5e0) from
[<c00336e4>] (kthread+0x8c/0x98)
[   16.140000] [<c0033658>] (kthread+0x0/0x98) from [<c001b4d4>]
(do_exit+0x0/0x720)
[   16.150000]  r7:00000013 r6:c001b4d4 r5:c0033658 r4:c3827ecc
[   16.160000] ---[ end trace d7472237284e57c3 ]---
[   16.160000] mpa1600-audio mpa1600-audio.0: Failed to set SSC for audio: -17
[   16.180000] mpa1600-audio: probe of mpa1600-audio.0 failed with error -17

regards
Joachim Eastwood
