Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab2JBND3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 09:03:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314Ab2JBND1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:03:27 -0400
Date: Tue, 2 Oct 2012 10:03:19 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>
Subject: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use
 request_firmware_nowait()
Message-ID: <20121002100319.59146693@redhat.com>
In-Reply-To: <4FE9169D.5020300@redhat.com>
References: <1340285798-8322-1-git-send-email-mchehab@redhat.com>
	<4FE37194.30407@redhat.com>
	<4FE8B8BC.3020702@iki.fi>
	<4FE8C4C4.1050901@redhat.com>
	<4FE8CED5.104@redhat.com>
	<20120625223306.GA2764@kroah.com>
	<4FE9169D.5020300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Em Mon, 25 Jun 2012 22:55:41 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> Em 25-06-2012 19:33, Greg KH escreveu:
> > On Mon, Jun 25, 2012 at 05:49:25PM -0300, Mauro Carvalho Chehab wrote:
> >> Greg,
> >>
> >> Basically, the recent changes at request_firmware() exposed an issue that
> >> affects all media drivers that use firmware (64 drivers).
> > 
> > What change was that?  How did it break anything?
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=827538
> 
> Basically, userspace changes and some pm-related patches, ...
...

As I pinged you back in June, the recent changes on udev made lots of regression
on all media drivers that require firmware. The news is that the fixes are also
causing more regressions...

Btw, Linus also complained about that:
	https://lkml.org/lkml/2012/8/25/136

I basically tried a few different approaches, including deferred probe(),
as you suggested, and request_firmware_async(), as Kay suggested.

The deferred probe() doesn't work as-is, as it will re-probe the driver 
only if a new driver is modprobed. It should likely not be that hard to modify
the drivers core to allow it to re-probe after returning the probe status to 
udev, but I failed to find a way of doing that (mostly because of the lack of 
time, as I'm being too busy those days).

I tried a few other things, like using request_firmware_async() at a few
drivers that require firmware.

That caused a big regression on Kernel 3.6 that we're currently discussing 
how to fix, but basically, media devices are very complex, as they have lots
of different blocks there: tuners, analog video demod, digital video demod, 
audio demod, etc. On most cases, each of those "extra" blocks are implemented
via I2C, and the device initialization happens serialized.

By letting an I2C driver to do asynchronous initialization, other dependent
drivers broke, because there are some signals used by the other blocks that 
are dependent on a proper initialization of a block previously initialized.

One of the specific case is a device very popular in Europe nowadays: the
PCTV 520e. This device uses an em28xx USB bridge chip, a tda18271 i2c tuner
and a drx-k DVB i2c demod (among other things). The DRX-K chipset requires a
firmware; the other chipsets there don't.

The drx-k driver is used in combination with several other drivers, like
em28xx, az6027, xc5000, tda18271, tda18271dd, etc. On my tests, with
the devices I have available (Terratec H5, H6, H7, HTC; Hauppauge HVR 530C),
the usage of request_firmware_async() worked as expected.

So, such patch that made DRX-K firmware load to be deferred were applied at
Kernel 3.6 on this changeset:

commit  bd02dbcd008f92135b2c7a92b6
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Thu Jun 21 09:36:38 2012 -0300

    [media] drxk: change it to use request_firmware_nowait()
    
    The firmware blob may not be available when the driver probes.
    
    Instead of blocking the whole kernel use request_firmware_nowait() and
    continue without firmware.
    
    This shouldn't be that bad on drx-k devices, as they all seem to have an
    internal firmware. So, only the firmware update will take a little longer
    to happen.
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

It should be noticed that, for the DVB demodulation to work, the DVB demod 
should be attached with the tuner module, via this code snippet[1]:

		fe = drxk_attach(&pctv_520e_drxk_cfg, &i2c_adap);
		tda18271_attach(fe, i2c_tuner_address, &i2c_adap, &pctv_520e_tda18271_cfg);

The evil are in the details: the DRX-K chip produces some clocks needed by
the tuner, and it has some generic GPIO pins that allow to control random 
things, with are device-dependent. Also, there is an I2C switch at the board,
used to control I2C access to the tuner: when the switch is off, the tuner is
not visible at the I2C bus[2].

The tda18271 tuner driver needs to read one device register, in order to 
identify the chipset version, as there are a few different setups there,
depending if the silicon is version 1 or 2. As this driver doesn't require
any firmware, such read happens at driver's attach time, with should be fine.

Well, before the patch:

	1) drxk_attach() would synchronously read the firmware and initialize the
	   device, setting the needed GPIO pins and clock signals;

	2) tda18271_attach() would read the version ID register and initialize the
	   device.

However, after the patch, drxk_attach() does nothing but filling some internal data
structures and defer the device init job to happen after the firmware load.

So, when tda18271_attach() is called, there wasn't enough time yet to initialize
the DRX-K device. The end result is that the tda18271 version is not identified
and the I2C driver read fails:

	tda18271_read_regs: [5-0060|M] ERROR: i2c_transfer returned: -19
	Unknown device (16) detected @ 5-0060, device not supported.

Ok, there are lots of ways to fix it, but I suspect that we'll just push the
problem to happen on some place else. 

The fact is that coordinating the initialization between the several parts of 
those devices is already complex enough when done serialized; doing it
asynchronously will make the initialization code complex and won't bring any
benefit, as the I2C bus will serialize the initialization anyway.

Also, this is just one of the 495 media drivers. Several of them require firmware
during probe() and are currently broken. Fixing all of them will likely require
years of hard work. So, we need to do something else.

For Kernel 3.6, we'll likely apply some quick hack.

However, for 3.7 or 3.8, I think that the better is to revert changeset 177bc7dade38b5
and to stop with udev's insanity of requiring asynchronous firmware load during
device driver initialization. If udev's developers are not willing to do that,
we'll likely need to add something at the drivers core to trick udev for it to
think that the modules got probed before the probe actually happens.

What do you think?

[1] This is a simplified version of the code: I removed a macro and the error
    logic from it, to make the code cleaner for reading.

[2] The I2C switch is there to prevent I2C traffic to generate noise that might
    interfere at the tuner functions.

Thanks,
Mauro
