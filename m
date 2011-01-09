Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab1AISzP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 13:55:15 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:49855 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab1AISzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 13:55:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Pavan Savoy <pavan_savoy@sify.com>
Subject: Re: [PATCH 00/11] mfd and bluetooth: Add CG2900 suppor
Date: Sun, 9 Jan 2011 19:55:05 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Par-Gunnar HJALMDAHL" <par-gunnar.p.hjalmdahl@stericsson.com>,
        Vitaly Wool <vitalywool@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        "Par-Gunnar Hjalmdahl" <pghatwork@gmail.com>
References: <1292584829-28279-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com> <201101061946.04790.arnd@arndb.de> <AANLkTikJMx2QxYwXS_TrKK5hcnD3G0MNvEiDO+xAZrpo@mail.gmail.com>
In-Reply-To: <AANLkTikJMx2QxYwXS_TrKK5hcnD3G0MNvEiDO+xAZrpo@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101091955.05174.arnd@arndb.de>
X-Provags-ID: V02:K0:AFIb/m7DwB7+DL9WCEp+6YgXmIrH6/tDQoUh9/5sFKd
 bmBiGiMWiaGU3rCF7b2c3WdD4helKUdebha3GuWVchq4UjIz4P
 90f6NE+OAWa19dtA1pSOJTrsDRso+iEiP/lhHrhMGWhwNO9pMB
 E4U80JObkhDNhOfEBLy4evSrotQ7/XF1F4VkehOhYRtqggapTp
 nObx728GMlt+/UREAPtJw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 January 2011, Pavan Savoy wrote:
> On Fri, Jan 7, 2011 at 12:16 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Wednesday 05 January 2011, Par-Gunnar HJALMDAHL wrote:
> >
> >> Sorry for not answering sooner. I've been on Christmas and New Year vacation.
> >
> > I'm also still catching up with email that has accumulated over my
> > vacation, including your previous response.
> >
> > This sounds wrong for both TI and ST-E: AFAICT they are actually built
> > around an HCI interface. It's unfortunate that the TI code actually got
> > merged into the kernel like this.
> 
> I am not sure what does built around HCI Interface mean? Also yes, in TI- code
> we do refer to Bluetooth headers.
> However the fact that I wanted to point out to Par-Gunnar was, that we
> don't want to use
> hciattach and enable HCI-UART + HCI-H4 for enabling our driver or our
> driver should not
> depend on those modules as such...

Good point about hciattach, you certainly shouldn't need to use that if
the kernel already knows that a tty is connected to an HCI and what the
parameters are. Even more so if the HCI is not actually on a rs232 line
but something like i2c or spi. Automatically binding to the right line
discipline should be easily doable in the drivers though.

I don't understand the problem with relying on the hci-uart or hci-h4
modules. If the hardware uses the H4 protocol, we certainly should use
the kernel module that knows how to deal with H4, and we don't want
to have two modules implementing the same protocol.

> >> > instead of common-hci-module, why not create a algo-driver layer 'ala
> >> > i2c ? where individual drivers can register their receive handlers for
> >> > data interpretation ?
> >
> > That would be what I suggested ;-)
> 
> But even here too, the algos layer if you imagine which can be the
> sort of the first
> receiver of data from the transport would refer to BT headers to
> interpret the data (not just BT, but FM/GPS)
> and pass it onto other protocol/client drivers,

Right, that is the entire idea, and I don't see a problem here.
If you do this, you use the headers of the two subsystems you
interface with. What you should /not/ instead is use header
files of a subsystem you don't interface with and reinterprete
the definitions in creative ways, which is what I understood
was being discussed earlier.

> >> In some way you then run into the same problem has I had in previous patch
> >> sets. The functionalities supported is really determined by each chip.
> >> You might or might not have for example GPS in a certain chip. So you do not
> >> want a central module to expose all possible channels to the stacks on top.
> >>
> >> You only want the actually supported features to be exposed to upper layers.
> >> Then the MFD system is pretty nice. It's easy and modularized to expose the
> >> different channels as MFD cells.
> >
> > But as soon as you have the concept of channels with a clearly defined
> > interface, you have almost abstracted it enough to go all the way.
> 
> Something like this is what the recent RFC posted to
> lkml/linux-bluetooth
> http://www.spinics.net/lists/linux-bluetooth/msg09990.html,
> it kinda looks clumsy
> but what I feel is we shouldn't shy away from not referencing
> Bluetooth, (or may be tomorrow GPS
> with NMEA headers)....

The one important goal here should be to avoid code duplication.
Using the header to get the data structures from separate code
means you need to have similar parsing functions in each of the modules
using it. Not sharing the header wouldn't help, because then you end
up duplicating even more. The real solution, speaking very broadly,
must be to have a general module that deals with whatever the more
specific modules have in common, and have a header file that defines
the interface to it.

> >> Also note that the common-hci-module is only really used until the connected
> >> chip has been detected. The chip handler will then set the callback functions
> >> so actual data transmissions never pass the common-hci-module. They go directly
> >> from transport to chip handler. That is not really shown in the picture above.
> >> Just imagine that common-hci-module is removed after a chip has been connected
> >> and a chip handler has been determined.
> >>
> >> I hope I haven't misunderstood your question. I do not know much about the I2C
> >> system, but I tried to understand your question as best as I could.
> >
> > I think there is a disconnect when talking about hierarchies, as it can be applied
> > to different areas:
> >
> > * module dependencies
> > * device detection
> > * sysfs object hierarchy
> > * data flow
> 
> module dependecy-wise I agree,
> I would want FM-V4L2 without BT or I might want GPS simplistic char
> driver without BT or FM V4L2.

But you'd still need to have an HCI module. I believe right now, the
hci module depends on the bluetooth module, and you are right that this
is an undesirable dependency to have for a GPS module. However, the solution
to this should not be to make GPS independent of HCI, but to make parts
of HCI independent of bluetooth.

> device detection wise, It is a problem, there is not "_probe"
> mechanism for UART based transport as it is
> understandable, and pretty much the driver would end up being platform
> device driver ...

The platform device is just the lowest level in the device hierarchy.

If each HCI channel is a device, you can stack bt, gps, audio, ...
devices all on top of the HCI device, which is either stacked on top
of a serial port or in some other way connected to the underying transport.

In this case, the channels themselves are not platform devices, but
would get a new bus for them. That bus is populated by a driver that
owns the HCI and that knows (e.g. from its platform data, hardware
registers, user config or device tree) what channels are present.

> data flow is where I guess the abstraction has to lie in, for
> different vendors...

I don't know what you mean with that. My point was that we need to
consider all the hierarchies, and that they might be different.

	Arnd
