Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab1LALe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 06:34:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53382 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753218Ab1LALe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 06:34:56 -0500
Date: Thu, 1 Dec 2011 11:34:50 +0000
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
Message-ID: <20111201113449.GD2915@opensource.wolfsonmicro.com>
References: <201111251402.28016.arnd@arndb.de>
 <CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com>
 <201111281753.45287.arnd@arndb.de>
 <CAJ0PZbT8FcCq=6GzLxOhhpRvCbCaJJEhE9_2GXXT4P0XZp6H-w@mail.gmail.com>
 <20111130135847.68a6e4c6@notabene.brown>
 <CAJ0PZbRpoz+uK4QUAO4RG5bhsSpNvm5U-ROtbduXhnFTLMZ1VQ@mail.gmail.com>
 <20111201095633.700e2923@notabene.brown>
 <20111130231740.GA25340@opensource.wolfsonmicro.com>
 <20111130232529.GB3220@core.coreip.homeip.net>
 <20111201162144.187ecca3@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201162144.187ecca3@notabene.brown>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 04:21:44PM +1100, NeilBrown wrote:
> On Wed, 30 Nov 2011 15:25:29 -0800 Dmitry Torokhov

> > Physical jack does not have to map 1:1 on logical jack. So 1 physical
> > docking connector can be represented by 1 logical video connector, line
> > in, line out, microphone and maybe else.

> That is just what I was thinking :-)

> It seems that a "connector" could be modelled as a set of binary switches,
> one for each service that is exported (or imported? ... "communicated" maybe)
> through the connector.  When a cable (or dock) is plugged in, some number of
> these switches are all switched on concurrently.  When it is unplugged they
> are all switched off.

> How strongly do we need this understanding of a "group" to be?

It's useful to userspace to know that the grouping is there, and it's
also useful to be able to say that the overall object that was inserted
into the connector is whatever.  That could be done by grouping a bunch
of other objects together.

> Mark says:

> > We also need some way to group things together so that we can understand
> > that we've got a single connector that can detect multiple things (eg,
> > understanding that a cable hsa audio and video capability).

> It isn't immediately obvious why this is the case.  There is no guarantee
> that I want to route audio and video in the same direction.  The best you can
> probably get is a heuristic that both should be routed to the most recently
> available destination.
> But again, maybe I'm missing something important.   I guess the helpful piece
> of information is: How exactly would this knowledge of grouping be used?

Being able to provide useful default behaviour is an important win in
itself, and in many embedded cases the end user has no access to this
sort of policy anyway (consider smartphones and tablets).  You can
probably do much better than you suggest above - for example, if the
device connected is an AV cable then it's more likely that you want to
treat it as a block to be routed together than if the device connected
is a docking station.  You might also choose to do things like
remembering the configurations used with particular cables and restoring
them when reconnected - for example, distinguishing between a car dock
and a desktop docking station.

> One case I am thinking of is the twl4030 driver (a multi-function device for
> power, usb, audio, battery charge etc).
> The battery charger needs to know when the usb device gets a cable plugged in
> so that it can start charging.
> It currently creates a link essentially by using a global variable.

This is the sort of device that MyungJoo is taking about in a lot of his
examples.

> Using a 'switch', the twl-core module could allocate a switch and pass it to
> the usb module for sending notification and to the bci module for receiving
> them.  Whether it passes down a number which is later turned into a pointer,
> or whether it sends down the raw pointer, is just an implementation detail.

We really want something a bit more involved in the USB frameworks for
the specific example of USB stuff (which is being worked on) - ideally
we should be communicating information about how much current the host
allows to be drawn throughout the system.

> Can the same be done for these cable ports that you have in mind?  Presumably
> the common-parent could allocate several switches - maybe even an array of
> switches - and pass the collection of switches to the port, and then pass
> individual switches to individual component drivers.

I *think* so.

> If the switch needs to be exported to user-space then someone needs to
> provide a name for it.  I suspect the common-parent would be the obvious
> choice, or the board file.

Common parents often don't exist - it's not unusual for multiple devices
to be involved in the detection of accessories.  Assuming a straight
tree structure is very dangerous in the embedded context.  Board
assigned naming does seem reasonable to me, though.

> Just to be clear, the functionality that I see a 'switch' supporting is:

> For the owner:
>   - int switch_allocate(void)
>   - void switch_export(int switchnum, char *name)
>      This creates a device which appears in sysfs and has a 'state'
>      attribute which responds to 'poll' requests so a process can find
>      out about changes.

> For the notifier:
>   - void switch_set_state(int switchnum, bool value)
>           This sets the state and notifies all notifiees (listeners).

I think we do want something which lets us say "this is a cable of
type X" so that we can report the difference between otherwise identical
cables as in the car/desktop dock example I mentioned above.
