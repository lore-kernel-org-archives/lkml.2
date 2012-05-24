Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229Ab2EXWdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 18:33:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab2EXWdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 18:33:23 -0400
Message-ID: <4FBEB72D.4040905@redhat.com>
Date: Thu, 24 May 2012 19:33:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v3.5-rc1] media updates for v3.5
References: <4FBE5518.5090705@redhat.com> <CA+55aFyt2OFOsr5uCpQ6nrur4zhHhmWUJrvMgLH_Wy1niTbC6w@mail.gmail.com>
In-Reply-To: <CA+55aFyt2OFOsr5uCpQ6nrur4zhHhmWUJrvMgLH_Wy1niTbC6w@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Em 24-05-2012 17:42, Linus Torvalds escreveu:
> Btw, I only noticed now, because I normally don't build DVB on my main
> machine with "oldconfig" - why the hell does DVB add tuners with
> "default m"?
> 
> Why would *anybody* with an old config ever want to get those new
> drivers as modules?
> 
> Get rid of all the stupid
> 
>   default m if DVB_FE_CUSTOMISE
> 
> because there's no reason for them. If somebody wants that module,
> they can damn well press the 'm' button. There's absolutely no reason
> for it to default to on.
> 
> This is true of *all* drivers. No driver (and certainly DVB is not at
> all an exception) is so important that it should be "default m" (or
> y).
> 
> There are a few valid reasons to use "default m/y", but I don't see
> that that is the case here:
> 
>  - if you have an *existing* driver that got split up, and "make
> oldconfig" with that old driver enabled would result in it no longer
> supporting the same capability, then a
> 
>      default OLD_DRIVER_WAS_ENABLED
> 
>    is appropriate - it makes "oldconfig" work the way people expect it to work.
> 
>    But this is only when that piece of hardware used to be supported
> already, it's irrelevant for new hardware.
> 
>  - if it's *such* a basic piece of hardware that you simply don't want
> to bother the user with an insane default. Like supporting an ATKBD
> driver on a PC etc.
> 
>    This simply isn't true for media devices.
> 
> So stop doing the silly "enable this driver by default for old
> configurations". It's *wrong*.

For a DVB driver to work, it is generally required to select 3 drivers:
a bridge driver, a tuner driver and a demodulator driver.

The Kconfig default for DVB_FE_CUSTOMISE is 'n'. So, if no DVB bridge is selected,
nothing will be compiled.

The same bridge driver can be used with several different tuner and demods. 
On almost all cases, the tuner and demod drivers are connected via an I2C bus.

The Kconfig logic was built in a way that, when a bridge driver is selected,
all the drivers that might be required will also be selected.

For example:

config DVB_USB_DIB0700
	tristate "DiBcom DiB0700 USB DVB devices (see help for supported devices)"
	depends on DVB_USB
	select DVB_DIB7000P if !DVB_FE_CUSTOMISE
	select DVB_DIB7000M if !DVB_FE_CUSTOMISE
	select DVB_DIB8000 if !DVB_FE_CUSTOMISE
	select DVB_DIB3000MC if !DVB_FE_CUSTOMISE
	select DVB_S5H1411 if !DVB_FE_CUSTOMISE
	select DVB_LGDT3305 if !DVB_FE_CUSTOMISE
	select DVB_TUNER_DIB0070 if !DVB_FE_CUSTOMISE
	select DVB_TUNER_DIB0090 if !DVB_FE_CUSTOMISE
	select MEDIA_TUNER_MT2060 if !MEDIA_TUNER_CUSTOMISE
	select MEDIA_TUNER_MT2266 if !MEDIA_TUNER_CUSTOMISE
	select MEDIA_TUNER_XC2028 if !MEDIA_TUNER_CUSTOMISE
	select MEDIA_TUNER_XC5000 if !MEDIA_TUNER_CUSTOMISE
	select MEDIA_TUNER_XC4000 if !MEDIA_TUNER_CUSTOMISE
	select MEDIA_TUNER_MXL5007T if !MEDIA_TUNER_CUSTOMISE

This driver supports 82 different types of devices. When this driver is selected, 
all supported variants of tuners and frontends are selected, meaning that any of the 
82 types will work.

Keeping DVB_FE_CUSTOMISE not set is the recommended way, as the options 
DVB_FE_CUSTOMISE and MEDIA_TUNER_CUSTOMISE are there only to allow
advanced users to disable the devices that aren't needed.

For example, one of the ISDB-T devices I have here requires only those drivers
to work:
	DVB_USB_DIB0700		- USB bridge and I2C controller
	DVB_DIB8000		- ISDB-T demodulator
	DVB_TUNER_DIB0070 	- the PLL tuner driver

If just DVB_USB_DIB0700 is selected, the bridge driver will be loaded, 
but no DVB devices will appear, as the driver won't initialize properly.

On the other hand, if those tree modules are selected, the remaining tuners/demods
can be disabled, as the bridge driver won't require them.

So, this is an option that it is useful for embedded systems, where
there's just one specific hardware model to be used.

So, in order to avoid non embedded/advanced users that might enable DVB_FE_CUSTOMISE
by mistake to generate lots of not-a-bug bugzillas, when the DVB customise options
are enabled, all I2C modules are selected by default, using the "default m if DVB_FE_CUSTOMISE"
logic.

So, I think that, in this specific case, the "default m if DVB_FE_CUSTOMISE"
makes sense.

Regards,
Mauro

