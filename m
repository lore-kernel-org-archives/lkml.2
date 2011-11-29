Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab1K2JLH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 04:11:07 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41080 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab1K2JLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 04:11:03 -0500
MIME-Version: 1.0
In-Reply-To: <201111281753.45287.arnd@arndb.de>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
	<201111251402.28016.arnd@arndb.de>
	<CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com>
	<201111281753.45287.arnd@arndb.de>
Date: Tue, 29 Nov 2011 18:11:02 +0900
Message-ID: <CAJ0PZbT8FcCq=6GzLxOhhpRvCbCaJJEhE9_2GXXT4P0XZp6H-w@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 2:53 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sunday 27 November 2011, Linus Walleij wrote:
>> > How does this relate to the new "pinmux" subsystem that Linus Walleij
>> > maintains? Would it be useful to integrate your driver into pinmux
>> > instead of starting a new subsystem?
>>
>> Looks unrelated to pinmux but very useful.
>
> Ok, got it. So while pinmux controls the setting of some pins, this one
> generates software events when the state is changed from the outside.

For pinmux:
Besides, pinmux does not support multistate-muxing (you cannot set a
gpio pin to have multiple states at the same time) and focusses on
setting pins (device drivers set the GPIO pin configurations). The
target devices of multistate switch class (MSC) do not (actually,
cannot) control the setting of the switch proactively; it is done by
the physical hands of users (plugging in or out external cables). The
target device drivers (MSClass device driver) update switch_dev
information only when the cable states are changed by users.

For USB:
MSC is not for USB only. USB is just one of example cables. This needs
to support HDMI, Analog A/V I/O, Dock, and any other that may be
connected to a computer. (simply a "string" to MSC anyway)

For HID:
MSC is a simple notifier chain provider to provide bridges between
external-port-drivers and other notifiee device drivers and uevent
generator for external-port-drivers.
I'm a bit confused on using HID for the purpose.
Anyway, doesn't this mean that every device driver that gets
notifications from the external-port-drivers also need to be an HID
device? That'd mean that USB(either host/slave) drivers, Charger
drivers, Sound drivers, Video drivers, HDMI drivers, and many others
need to support HID in order to get this simple "plugged-in"
notification.



The target devices include (supported cable lists are not complete):
MAX8997 MUIC: a multi-pin port that may inhabit multiple cables (some
may mutually exclusive) including USB-HOST, USB, Travel Adaptor, HDMI,
Analog Audio / Video x Input / Output, Dock, and others.
FSA9480 USB Switch: USB / Travel Adaptor / HDMI / ...
MAX77693 (base driver soon to be released): same with if not more than
MAX8997 MUIC

We are notifying the changes in the states from MSC to both device
drivers (Charger, USB, Sound, Video, ...) and user spaces
(applications monitoring the cable insertion/removal).



For the next iteration, I'm considering the followings. It'd be much
appreciated if I could get some comments about those beforehand.
1. ABI documentation
2. move the location from /drivers/misc to an independent location.
/drivers/switch? /drivers/multistate-switch? /drivers/msc?
/drivers/mswitch? ...
3. Allow the notifiee device drivers to register its specific
interest. The interface would look like:
int switch_register_interest(struct switch_dev *sdev, const char
*cable_name, struct notifier_block *b);
(the rationale is that the notifiee device does not need to know the
detail about the switch dev configuration but for the name of the
switch dev or notifier).
or even
int switch_register_interest(const char *switch_name, const char
*cable_name, struct notifier_block *b);
and allow notifee to forget about the sdev pointer as well. (and all
the other APIs are for implementing notifier, not notifiee)


Cheers!

MyungJoo

-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
