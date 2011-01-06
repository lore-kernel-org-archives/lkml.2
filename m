Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab1AGOLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 09:11:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55793 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab1AGOLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 09:11:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Par-Gunnar HJALMDAHL" <par-gunnar.p.hjalmdahl@stericsson.com>
Subject: Re: [PATCH 00/11] mfd and bluetooth: Add CG2900 support
Date: Thu, 6 Jan 2011 19:46:04 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Pavan Savoy <pavan_savoy@sify.com>, Vitaly Wool <vitalywool@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        "Par-Gunnar Hjalmdahl" <pghatwork@gmail.com>
References: <1292584829-28279-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com> <AANLkTikxnWZNwf7AO0XnD0Y59Sdk9DMCsGtmap=H_gNk@mail.gmail.com> <AFCDDB4A3EA003429EEF1E7B211FDBBA3348BA7DD2@EXDCVYMBSTM005.EQ1STM.local>
In-Reply-To: <AFCDDB4A3EA003429EEF1E7B211FDBBA3348BA7DD2@EXDCVYMBSTM005.EQ1STM.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101061946.04790.arnd@arndb.de>
X-Provags-ID: V02:K0:gyLOV04CB/yn1IyBvZfz4EgxEm3/GpkqFnxtRuDwE7J
 1UfqXdk7/44WvkoZPEe5rcmI5Tb2NIeGOhOcu030RL2zEnq3UB
 aqZNN2jTG+BNfUolWTjC+cJpEX/klIRsYSC7LkK/hvhK/35VBk
 q7hcRd0frZNWCq7bOskaRF6GCaeZWMX/dSWWXsFF+Bmq0GRrcT
 u5MThm09VIjqptq0ooMZQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 January 2011, Par-Gunnar HJALMDAHL wrote:

> Sorry for not answering sooner. I've been on Christmas and New Year vacation.

I'm also still catching up with email that has accumulated over my
vacation, including your previous response.

> > -----Original Message-----

> > >
> > > I would say our design would map like this:
> > > common-hci-module: cg2900_core
> > > serial, spi, i2c,... : cg2900_uart together with hci_ldisc (for other
> > transports it would be different files)
> > > bt, ti-radio, st-e-radio,...: cg2900_chip together with btcg2900 and
> > other users per channel (cg2900_char_devices for users in User space)
> > > So it is not a 1-to-1 mapping for the upper parts. I would draw it
> > like this:
> > >
> > >                               bt   st-e-radio  st-e-gps
> > >                                |         |          |
> > >                                +---------+----------+
> > >                                          |
> > >                   ti-xx                st-e cg2900...
> > >                     |                    |
> > >                     +---------+----------+
> > >                               |
> > >                       common-hci-module
> > >                               |
> > >                   +-----------+-----------+
> > >                   |        |       |      |
> > >                 serial    spi     i2c    ...

Even if the cg2900 based drivers (bt, st-e-radio, ...) have things in common
that are not true in general, I'd still advocate a model where they all
register directly to the hardware-independent layer. Your base cg2900
driver can then become a library module that is used by some drivers that
use the cg2900 specific functionality, just like there can be other similar
libraries.

> > regarding the architecture above suggested...
> > Is having the common-hci-module, only way ?
> > Why is this dependency on bluetooth at all?
> > 
> 
> The reason I use Bluetooth is that it is the only standardized Host-Controller
> interface in these controllers (at least in the CG2900 which I'm primarily addressing).

That doesn't seem to make any sense if you don't present the standard interface
to Linux but basically still need to come up with your own abstraction layer
for it. It may have been the intention to use a standard HC interface, but either
the HW guys screwed up completely by making it impossible to use it that way,
or you haven't found the right way to integrate with the standard code.

> > for example: today I don't compile my kernel with BT support, but
> > still want to use
> > the chip for FM & GPS, It should be possible correct ?
> 
> Yes, I use the header files from the Bluetooth files inside the driver (for
> packet structures and protocol IDs). I do not use the BT binaries at all in
> the common-hci-module or in the st-e cg2900 module. So it should be OK to
> configure this out. The header files will be there any way.

This proves the point I just made: If it's a standard hardware interface, you
should be able to use the same driver module for a regular bluetooth HCI and
for a cf2900 without bluetooth. There is nothing wrong with requiring kernel
support for HCI if what you have is actually an HCI. Contrary to what Pavan
said, I would not require these to be independent implementations. Of course
in this case you would only require the base hci module to do this, not any of
the upper-level BT modules.

> > Even in TI case, although the firmware download is HCI-VS way, we
> > don't use hci_core
> > to interpret the responses...
> > 
> 
> We don't use that either. We just use the structs and defines in the BT
> headers. The dependency is only in btcg2900.c which is only included if
> BT is configuration enabled.

This sounds wrong for both TI and ST-E: AFAICT they are actually built
around an HCI interface. It's unfortunate that the TI code actually got
merged into the kernel like this.

> > instead of common-hci-module, why not create a algo-driver layer 'ala
> > i2c ? where individual drivers can register their receive handlers for
> > data interpretation ?

That would be what I suggested ;-)

> In some way you then run into the same problem has I had in previous patch
> sets. The functionalities supported is really determined by each chip.
> You might or might not have for example GPS in a certain chip. So you do not
> want a central module to expose all possible channels to the stacks on top.
>
> You only want the actually supported features to be exposed to upper layers.
> Then the MFD system is pretty nice. It's easy and modularized to expose the
> different channels as MFD cells.

But as soon as you have the concept of channels with a clearly defined
interface, you have almost abstracted it enough to go all the way.
 
> Also note that the common-hci-module is only really used until the connected
> chip has been detected. The chip handler will then set the callback functions
> so actual data transmissions never pass the common-hci-module. They go directly
> from transport to chip handler. That is not really shown in the picture above.
> Just imagine that common-hci-module is removed after a chip has been connected
> and a chip handler has been determined.
> 
> I hope I haven't misunderstood your question. I do not know much about the I2C
> system, but I tried to understand your question as best as I could.

I think there is a disconnect when talking about hierarchies, as it can be applied
to different areas:

* module dependencies
* device detection
* sysfs object hierarchy
* data flow

These are often the same or at least related, but we may be talking about different
aspects here. One issue that is often confusing is that from a module layering,
you typically have a common module at the bottom and have both providers (e.g. hosts
controller) and consumers of data (e.g. protocol drivers) on the top, where in a
data flow chart, you typically have the provider below the common code and the
consumer above if (or the other way round, if you prefer).

Since the HCI code in this case is the common component, it really needs to be the
module that everything else registers with in some way. You can have multiple
modules providing HCIs to that, and I suppose a module that provides an HCI should
also be the one that identifies the channels that are present.

The consumers of those channels however should not interface with the module that
provides the channels, but use the HCI code or something on top of it as an
abstraction.

	Arnd

