Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab1LEMGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:06:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37078 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932155Ab1LEMGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:06:13 -0500
Date: Mon, 5 Dec 2011 12:06:08 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: NeilBrown <neilb@suse.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        MyungJoo Ham <myungjoo.ham@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
Message-ID: <20111205120608.GI11150@opensource.wolfsonmicro.com>
References: <201111281753.45287.arnd@arndb.de>
 <CAJ0PZbT8FcCq=6GzLxOhhpRvCbCaJJEhE9_2GXXT4P0XZp6H-w@mail.gmail.com>
 <20111130135847.68a6e4c6@notabene.brown>
 <CAJ0PZbRpoz+uK4QUAO4RG5bhsSpNvm5U-ROtbduXhnFTLMZ1VQ@mail.gmail.com>
 <20111201095633.700e2923@notabene.brown>
 <20111130231740.GA25340@opensource.wolfsonmicro.com>
 <20111130232529.GB3220@core.coreip.homeip.net>
 <20111201162144.187ecca3@notabene.brown>
 <20111201113449.GD2915@opensource.wolfsonmicro.com>
 <20111205140413.0d2c5382@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111205140413.0d2c5382@notabene.brown>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 02:04:13PM +1100, NeilBrown wrote:
> On Thu, 1 Dec 2011 11:34:50 +0000 Mark Brown

> > We really want something a bit more involved in the USB frameworks for
> > the specific example of USB stuff (which is being worked on) - ideally
> > we should be communicating information about how much current the host
> > allows to be drawn throughout the system.

> Sounds like a job for the 'regulator' framework - but that is a guess based
> on not looking very deeply, so I'm probably wrong :-)

The regulator framework might be used to implement the current limits
but it understands nothing about the sematics of what it's doing, it
just understands things at the level of setting values.  Something would
need to sit above it to plug into USB.

> > I think we do want something which lets us say "this is a cable of
> > type X" so that we can report the difference between otherwise identical
> > cables as in the car/desktop dock example I mentioned above.

> I think you are saying that you might have two "cables" which connect up the
> same sets of signals but are "different" somehow.  One connects to a car,
> the other to a desk-top dock.
> How is that difference detected by the hardware?  Presumably some switch?
> So this is just one more binary switch to export to who-ever needs to know
> (presumably user-space) ???

Implementations vary - it may involve something like reading an ID chip
over some bus, for example.  It's definitely not a binary switch, it
needs to have more values than that.

> My GTA04 has a wifi chip connected to an mmc port.  The wifi chip has a
> separate regulator that can be powered up/down independently of everything
> else.
> So when I apply power I need a way to tell the mmc driver to scan the bus.
> It expects this information to come via a GPIO which has an associated IRQ.
> But I don't have a physical gpio to give it.

> So this is a case where one driver (the rfkill driver) needs to signal
> another driver (the mmc driver) to tell it that a new device has become
> available.  It hasn't been plugged in via a cable, it has be turned-on via a
> regulator, but it is conceptually very similar.

This is a very common situation.  The solution we've mostly been going
for for soldered down components is actually rather different, though -
in general it's much nicer for userspace if the device is presented as
always there rather than doing the hotplug thing and we just power it up
as needed.

Due to the existing rfkill implementations I guess the network stack is
already happy with the probe/remove model but that's not universally
true.  Even with userspace understanding things this would for example
also mean that we'd be able to keep the WiFi powered down when we just
happen not to be using it without having to use the rfkill switch.

> I wrote a virtual gpio chip which I call gpio-inout because it provides pairs
> of gpios, an output paired with an input.  When the output is changed it
> triggers an interrupt associated with the input, and the output is always
> readable by the input.

For the implementation I suggest above (which the core can't really cope
with yet but anyway) I'd be using a regulator.
