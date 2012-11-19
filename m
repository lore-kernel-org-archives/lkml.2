Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab2KSLFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 06:05:44 -0500
Received: from mx2.promwad.com ([195.222.87.218]:22627 "EHLO mx2.promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459Ab2KSLFm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 06:05:42 -0500
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Nov 2012 06:05:42 EST
From: Kurachkin Michail <Michail.Kurachkin@promwad.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kuten Ivan <Ivan.Kuten@promwad.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: RE: TDM bus support in Linux Kernel
Thread-Topic: TDM bus support in Linux Kernel
Thread-Index: AQHM4lI1DORXVh0dc0+QjrL9WppqRJYqzy4AgcN9PO4=
Date: Mon, 19 Nov 2012 11:00:12 +0000
Message-ID: <F7F628C32E67B04DAECC5CA53521253E5F9D9350@sv-exmb01-lo1.promwad.corp>
References: <CAKa7sPRgROFY2RfeVW0G_1EWzWXakuWu50tGQ2QuzrvEimU3FQ@mail.gmail.com>,<20120203110036.GA7732@leaf>
In-Reply-To: <20120203110036.GA7732@leaf>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.10.130]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

During the work on developing VoIP network router I designed TDM bus subsystem and wrote SLIC driver for si3226x. This code was developed for the commercial project, and now I am willing to release it under GPL.
Please review my sources (or give me a clue on what to do next) and give some feedback on my work.
https://github.com/stelhs/slic_tdm.git

Some technical delails on my project:

SOHO network router with VoIP based on CPU ARM9 Marvell 88F6283.
Router contains two FXS ports based on Silabs si32260 which is connected to CPU with SPI and TDM buses.

Description of the TDM subsystem:

The code which registers new TDM bus:
/drivers/tdm/tdm_code.c 
/include/linux/tdm/tdm.h

TDM subsystem provides API for registering of various TDM controller drivers:
    tdm_alloc_controller() - alloc memory for TDM controller driver
    tdm_free_controller() - free memory allocated for TDM controller driver
    tdm_controller_register() - register TDM controller driver on TDM bus
    tdm_controller_unregister() - unregister TDM controller driver

    tdm_alloc_voice_channel() - allocate memory for voice channel
    tdm_register_new_voice_channel() - register voice channel on TDM controller
    tdm_free_voice_channels() - unregister and free voice channels
    tdm_register_board_info() - register TDM devices list from board_specific code

TDM controller driver attached to TDM bus. Provides the following API for TDM device drivers:
    tdm_new_device() - allocate memory and create tdm_device
    tdm_add_device() - add tdm device to TDM bus
    request_voice_channel() - attempt to request TDM voice channel for TDM device
    release_voice_channel() - release TDM voice channel
    tdm_run_audio() - enable audio receive/transmit
    tdm_stop_audio() - disable audio receive/transmit
    tdm_recv() - receive one block audio data
    tdm_send() - transmit one block audio data
    tdm_poll_rx() - check for exist incomming data
    tdm_poll_tx() - check free space for transmitting data
    tdm_get_voice_block_size() - return audio block size

TDM controller driver for ARM Marvell kirkwood CPU.
Was tested on CPU ARM9 Marvell 88F6283. This CPU supports two TDM audio channels.
/drivers/tdm/kirkwood_tdm.c
/drivers/tdm/kirkwood_tdm.h

Driver for SLIC Silabs si3226x based on SPI and TDM frameworks.
/drivers/staging/si3226x/si3226x_drv.c
/drivers/staging/si3226x/si3226x_hw.c

Provides two FXS channels and creates the following device files:
/dev/si3226x_cnt.x
/dev/si3226x_fxs0.x
/dev/si3226x_fxs1.x

Regards,

Kurochkin Michail
Software Engineer
Promwad Innovation Company
www.promwad.com

________________________________________
From: Josh Triplett [josh@joshtriplett.org]
Sent: Friday, February 03, 2012 13:00
To: Palstsiuk Viktar
Cc: linux-kernel@vger.kernel.org; alsa-devel@alsa-project.org; Kurachkin Michail; Kuten Ivan
Subject: Re: TDM bus support in Linux Kernel

On Fri, Feb 03, 2012 at 11:59:10AM +0300, Viktar Palstsiuk wrote:
> We are designing custom hardware board where processor is connected
> with analog telephony
> SLIC via TDM bus.
> During investigation of Linux kernel we did not find any corresponding TDM code.
> So decided to write a new TDM subsystem in drivers/tdm (like SPI).
> The subsystem consists of tdm_core.c which implements TDM bus routines,
> e.g. tdm_register_board_info(), tdm_add_device(),
> tdm_controller_register() etc, and
> someplatform_tdm.c which implements platform specific TDM contoller.
>
> Any suggestion if we have chosen right direction and our approach
> conforms Linux kernel architecture?

Disclaimer: not a telephony expert.

>From the information you've provided in this mail, it *sounds* like you
probably have the right approach.  You've definitely done the right
thing by asking for architectural review sooner rather than later, and
it sounds like you've created a nicely abstracted subsystem modeled
after existing Linux subsystems rather than building an entire stack
directly into your driver, which would already put you well ahead of
most hardware vendors.  :)

You should post your code to LKML so that developers can review it.  You
should also CC any potentially interested developers, so they actually
see it.  In addition to CCing anyone specifically interested in
telephony, since you've developed a new subsystem I'd suggest CCing Greg
Kroah-Hartman <gregkh@linuxfoundation.org> as the maintainer of the
driver core.

Also, I don't know whether the TDM bus allows device probing or whether
you have to magically know in advance what devices you expect on a
particular platform.  If the former, you probably want to make sure you
support and use an appropriate MODULE_DEVICE_TABLE for your drivers, so
you can easily look up the right driver for any given device.  If the
latter, you may potentially want to look into the "flattened device
tree" mechanism, which provides a standard means of providing
"hardcoded" hardware configuration information to the kernel at boot
time.  If as the maker of the hardware you have any control over this,
go with the former. :)

> May be there were already some preliminary work for this?

In-kernel, it looks like a "slicoss" driver exists in staging, and
drivers/isdn exists, but AFAICT neither one has had any non-bugfix
development in a long time; the latter has some references to TDM,
though I don't know to what extent it might prove relevant to you.

Outside the kernel, you may want to look at
http://wiki.freeswitch.org/wiki/FreeTDM ; it currently seems to rely on
various out-of-tree and proprietary drivers of dubious status, but you
might still want to look it over, to find out if it has useful ideas or
if you might want to add support for your hardware.

I don't know of any efforts specifically trying to provide a
standardized interface for the TDM bus.  I suspect you'll end up getting
to lead the way here.

Hope that helps,
Josh Triplett
