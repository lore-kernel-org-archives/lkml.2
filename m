Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab1K1JDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 04:03:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60756 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab1K1JDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 04:03:35 -0500
Date: Mon, 28 Nov 2011 01:03:28 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        myungjoo.ham@gmail.com, linux-kernel@vger.kernel.org,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
Message-ID: <20111128090328.GA18919@core.coreip.homeip.net>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
 <201111251402.28016.arnd@arndb.de>
 <CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com>
 <20111127230836.GA29728@suse.de>
 <3f636639-7081-40f5-961d-72b1123c19a0@email.android.com>
 <20111128001941.GA2913@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128001941.GA2913@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 09:19:41AM +0900, Greg KH wrote:
> On Sun, Nov 27, 2011 at 04:09:19PM -0800, Dmitry Torokhov wrote:
> > >> So for the userspace part it seems to me that we need to make
> > >> up our mind about this stuff: is it going to be through input or
> > >> uevent like in this patch? Or ?both??
> > >
> > >Input please, uevent is not for things like switches that are "common",
> > >but for things that are "uncommon" and don't happen often.
> > 
> > Actually, please do not. I never liked audio-related switches added to
> > input; ALSA guys just wore me down. These are usually not switches
> > that user can flip, they are connections between components. Should we
> > switch betide_carrier_*(), power supply state, etc, etc over to input?
> > I think not.
> 
> Yes, I think so :)

Then we disagree here.

> 
> Well, not all of them, but when there is a hardware change of state,
> that a user can make happen (plug in headphone, plug in usb port, etc.)
> they should be input events, as there are a zillion different ways to
> have these types of devices.

I do not agree. Basically everything that happens in the system is
caused by user action somehow, somewhere.

> 
> And as HID has already documented almost all of these already, odds are,
> there's already a HID mapping for what is needed to be exported, and if
> not, it's easy to get a new HID code added, right?

Adding a new HID code is easy but not necessarily right solution. For
example, HID has reports describing battery level, but it does not mean
they should be delivered through input subsystem.

Additionally, do you really want to have full input device for
something like this? The character device; whole sysfs shebang, all the
handlers installed, etc, etc? Way too heavy IMO.

> 
> > I haven't looked at the patch yet, but a class that has an attribute
> > that could be queried and emitting uneventful on state change seems
> > like a good diluting for me.
> 
> For this one case, maybe.  But what about the next one, and the next
> one, and so on.  I would think those would all map better to input than
> one-off class devices with custom uevent messages.

I did not say I was advocating an one-off device. I was advocating a new
"connection" or "link" class that could describe relationship between 2
objects in the system.

> 
> Unless we want to start piping input events through uevents?  :)
> 
> Ok, if you really don't want this, then I suggest we create something
> that encompasses all of these into something unified, much like IIO is
> trying to be for those types of devices.

Yes, exactly. Something lightweight, even lighter than IIO since we do
not expect rapid rate of events here, so single multiplexed delivery
channel (uevents) would work well as notifiers.

-- 
Dmitry
