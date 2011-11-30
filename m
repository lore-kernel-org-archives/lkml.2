Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab1K3G64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 01:58:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45903 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab1K3G6z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 01:58:55 -0500
MIME-Version: 1.0
In-Reply-To: <20111130063500.GB12052@suse.de>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
	<201111251402.28016.arnd@arndb.de>
	<CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com>
	<20111127230836.GA29728@suse.de>
	<20111128123114.2601bd7c@notabene.brown>
	<20111128072713.GA17724@suse.de>
	<20111128090446.GB18919@core.coreip.homeip.net>
	<20111130063500.GB12052@suse.de>
Date: Wed, 30 Nov 2011 15:58:54 +0900
Message-ID: <CAJ0PZbR_N+=51AkcP5ijP31ka7G7EXbL8hSzK+umd_W6HPP2gg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, NeilBrown <neilb@suse.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 3:35 PM, Greg KH <gregkh@suse.de> wrote:
> On Mon, Nov 28, 2011 at 01:04:46AM -0800, Dmitry Torokhov wrote:
>> On Mon, Nov 28, 2011 at 04:27:13PM +0900, Greg KH wrote:
>> > On Mon, Nov 28, 2011 at 12:31:14PM +1100, NeilBrown wrote:
>> > >
>> > >  My own thought is that this deserves a new device class which allows easy
>> > >  hook-up of in-kernel signalling using notifications and which can be
>> > >  exported as input devices in much the same way the 'gpio' devices can be
>> > >  exported via gpio_keys.  The switch could also optionally be exported through
>> > >  sysfs much like gpio can be exported through sysfs.
>> >
>> > That might also work, but again, odds are the HID spec already defines
>> > this type of "switch", so why recreate it as a different type of device?
>>
>> HID does not map 1:1 on input. There are items in HID that are better
>> served by other subsystems.
>
> Ok fair enough.
>
> So, how do you want this type of interface to look like, uevents only?
>
> Or something like gpio?
>
> Actually, why can't we just use gpio as-is here and just treat these
> devices as "generic" i/o "pins"?
>
> thanks,
>
> greg k-h

For userspace, GPIO should work.

For device drivers, I'm not sure.

In order to work for device drives, a GPIO event (GPIO Input goes L->H
or H->L) should trigger events in other device drivers. The GPIO value
can be set by the external-connector/multistate-switch driver
(notifier) based on its own interrupts.

Then, with a GPIO X representing the one status of many at a notifier,
a notifier device can set L/H value of GPIO X according to the cable
state based on the interrupts from the port. However, for a device
(charger, hdmi, sound, or anything) being connected to that cable, how
does it get the changed state without polling? Are we generating an
interrupt of GPIO X at the interrupt handler of the notifier?

Assuming that it is possible, this means that each cable status is fed
to only one callback via IRQ subsystem unlike the notifier chain that
allows multiple callbacks registered. Another concern is that this
method may create a lengthy interrupt handling context where we could
use simple notifier chains. The work struct at the interrupt handler
of switch device (notifier) will now invoking a series of interrupts
instead of calling notify.

- We need uevent + notify-chain.


Cheers!
MyungJoo
-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
