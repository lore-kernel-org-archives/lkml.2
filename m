Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab1K3Gku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 01:40:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48742 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab1K3Gkt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 01:40:49 -0500
MIME-Version: 1.0
In-Reply-To: <20111130135847.68a6e4c6@notabene.brown>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
	<201111251402.28016.arnd@arndb.de>
	<CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com>
	<201111281753.45287.arnd@arndb.de>
	<CAJ0PZbT8FcCq=6GzLxOhhpRvCbCaJJEhE9_2GXXT4P0XZp6H-w@mail.gmail.com>
	<20111130135847.68a6e4c6@notabene.brown>
Date: Wed, 30 Nov 2011 15:40:48 +0900
Message-ID: <CAJ0PZbRpoz+uK4QUAO4RG5bhsSpNvm5U-ROtbduXhnFTLMZ1VQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Mike Lockwood <lockwood@android.com>,
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 11:58 AM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 29 Nov 2011 18:11:02 +0900 MyungJoo Ham <myungjoo.ham@gmail.com>
> wrote:
>
>> 3. Allow the notifiee device drivers to register its specific
>> interest. The interface would look like:
>> int switch_register_interest(struct switch_dev *sdev, const char
>> *cable_name, struct notifier_block *b);
>> (the rationale is that the notifiee device does not need to know the
>> detail about the switch dev configuration but for the name of the
>> switch dev or notifier).
>> or even
>> int switch_register_interest(const char *switch_name, const char
>> *cable_name, struct notifier_block *b);
>> and allow notifee to forget about the sdev pointer as well. (and all
>> the other APIs are for implementing notifier, not notifiee)
>
> I'm surprised to find "cable_name" in there.  It is saying that multi-switch
> is always used for cable-plug events.  If that is the case, then maybe the
> name "multiswitch" is too generic.  Maybe this is a "cabledetect" function??

Hmm.. then, would ("switch_name" and "node_name") or ("extcon_name"
and "cable_name") be better?
(extcon: external connect, which is the name I'm considering for now)

I'm focusing on an external connector or port that each physical port
may inhabit multiple cables at a time although it should support a
port that may inhabit a single cable only at a time. However, the
class could be used for other general "multistate mux" that connects
different device drivers.

>
> I'm wondering if a switch should be something much simpler - not even a
> 'device' necessarily.  Maybe it is more like a resource, like gpio or irq or
> pwm or region or clock or ...

If we take the approach of GPIO or IRQ, providing a unique number for
each possible cable, we need to define the numbers at a board file
(bsp), device tree, or with some other mechanisms and pass the numbers
to notifiers (extcon/switch devices) and notifiees (devices using the
cable).

However, unlike GPIO or IRQ, we have more information available at
each node. A "Samsung Slate Dock" notifiee device driver will always
get notified via "Dock" cable of a given
extcon/multistate-switch-class device (notifier, "PortX"). I'm not
sure whether we need to make "Samsung Slate Dock" device driver to use
node "15" and let some other part in kernel define "15" as a "Dock"
cable of a multistate switch device "PortX".

In other words, for GPIO or IRQ, for a device driver X in coding time,
we don't know whether X will be using which "node" of a GPIO-chip or
IRQ-chip. However, for extcon/multistate-switch, we generally know
which "cable/node" of a extcon/multistate-switch device although we
don't know which extcon/multistate-switch device will be used.

Anyway, having no standard naming convention for cables is a obstruct
for that purpose. E.g., every "Dock" device drivers need to use the
cable name "Dock" to be supported. Thus, adding a suggested name list
could be done in the next iteration.

>
> So each switch on a given board is identified by a number and any code that
> wants to know about switch events needs to be given the magic number somehow
> (in platform_data?) and does
>  request_switch(switch_number)
>  switch_register_interest(switch_number, notifier_block)
>
> I don't know exactly how your "cable_name" would fit.  Does that just
> identify the particular value that the switch has?  In that case
> switch_callback could have an optional 'value' so the call back only happens
> when the switch is set to that value (or set from that value).
>
> If you need to make it appear in sysfs, write "switch_export" based on
> "gpio_export".
> If you want the switch to generate input events, write switch_keys based on
> gpio_keys.
>
> I guess my point is that a "switch" - even a "multiswitch" - is an extremely
> generic concept and imposing too much semantics on all switches would be a
> mistake.
>
>
>
> On reflection... I think you said that a switch could have a bit-map of up to
> 32 bits with each bit representing a different cable type, and multiple
> cables can be plugged in at the same time - is that correct?

Yes, correct.

> If so, then why not just have multiple switches, one for each cable type.

Not one for each cable type, One for each cable type and port. We may
have the same cable type attached to multiple different external
ports.
(one external port = one "switch_dev" object = cable detector)

> The thing that detects the cables could then register a "switchchip" (like
> gpiochip) that supports a number of switches all handled by the same code.  A
> client would just register_interest with the individual switches that it
> cares about - i.e. the individual cable(s).
>
> Though I might have misunderstood something.
>
> NeilBrown


Because an instance of "Cable-X's IO" device shoudl be able to
distinguish whether it is attached to a "Cable-X" of switch (or
extcon) "MAX8997-MUIC.0" or "MAX8997-MUIC.1", it seems that providing
a unique name for each cable type may make things more complex for
device drivers. By seperating the names of switch/extcon and
cable/port/node, we can implement device drivers of notifiers
(representing switch/extcon) and notifiees (handling or using
cable/port/node) may keep "cable name" constantly in their device
driver code: "MHL" device driver will use cable "MHL", "USB Host"
device driver will use cable "USB Host", and so on. We only need to
configure which device is waiting to be connected to which
extcon/switch with platform data: e.g., a device "mhl.0" is being
connected to "max8997-muic.0", a device "charger-manager.0" is being
connected to "max8997-muic.1".

Although I'm implementing with devices that have only one "extcon" for
now, I guess it'd better to assume that I'll start working on devices
with two or more soon.


-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
