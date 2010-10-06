Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187Ab0JFP04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 11:26:56 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40579 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756426Ab0JFP0x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 11:26:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=edos311kpkTh6vF4uCaEJXcMb2ioIXq8uz16RL7jFGGiNeOW4R/zCTQgTLkxoxRfgE
         mTAZ8Vyb6ctA2OxKJ+lOeOkxP2KLJuPYXZX0a8HjSVH0210AUEYMGi5Tfj6wcDnzog3F
         bcHOFCnfbgSKH7zv24C6sNraOR1FSUy+QBTys=
MIME-Version: 1.0
In-Reply-To: <1286349552.6145.11.camel@aeonflux>
References: <20100924230730.GB6566@tux> <1286266981.17473.33.camel@aeonflux>
 <20101005192814.GB11831@tux> <1286308731.2588.13.camel@aeonflux>
 <AANLkTimz7U52_qHaTutQDOFQde+GrWJRA0WpqY__FPgi@mail.gmail.com> <1286349552.6145.11.camel@aeonflux>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 6 Oct 2010 08:26:26 -0700
X-Google-Sender-Auth: EW3dWR_bFUzKP394AZjcikHNAPI
Message-ID: <AANLkTimDvgFtoGLEjgWyYRrhQy6Num-rn_2WYO4Lf84b@mail.gmail.com>
Subject: Re: RFC: btusb firmware load help
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
        Sree Durbha <Sree.Durbha@atheros.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 6, 2010 at 12:19 AM, Marcel Holtmann
<holtmann@linux.intel.com> wrote:
> Hi Luis,
>
>> > most likely via a separate firmware loading driver.
>>
>> Like the fwload patch ? Or something different?
>
> something clean of course and not this hacking around, but in general
> along that.
>
>> > Your ath3k driver is such a driver. Same as the bcm203x driver.
>>
>> Right -- so ath3k depends on some atheros USB device IDs, and its a
>> stupid driver that just loads firmware. The problem with this new
>> device is that it requires two phases. One to load some sort of
>> firmware onto it to get it to read as an ath3k device, and then ath3k
>> will load the right firmware to it. So the hardware device is already
>> claiming a btusb vendor:device ID, we can't change that I believe. Of
>> course for future devices we can, and we've addressed this and its
>> been fixed.
>
> So your current loading procedure is this:
>
>        1) btusb with hacked firmware loading
>        2) ath3k
>        3) btusb with HCI

Not sure of the 3rd part as I do not know what the ath3k firmware
does. I am not sure if by loading the ath3k firmware it then
redeclares itself as a btusb device. Also upon further review I just
noticed the fwload hack used ath3k-1.fw and not ath3k-2.fw. A patch
submitted ages ago to you added ath3k-2.fw upstream but that patch
never made it through upstream, so now I wonder if the fwload crap
thing should be using ath3k-2.fw as well. Anyway, I am also not sure
why after loading the firmware from btusb a second load using ath3k
driver would be needed.

> Who thought that this is a good idea in the first place?

Not sure, this was the way the hardware was designed, it just so
happens there seems to be no generic btusb module equivalent on
Windows or Mac OS X so they have full control over how this is handled
there and apparently in Windows and Mac OS X you can get away with
murder on crap code on drivers, so long as shit works. My
understanding is that the stuff implemented was just some workarounds
to get this to work on Linux. Due to our higher requirement on code
quality, and though process I recommend device drivers get written for
Linux first, perhaps a lesson will be learned here to try to do this
moving forward.

> And more important that I would accept this upstream? This is even worse than I
> thought it is.

Heh, I don't think anyone knew any better. Your suggestions of how to
handle this properly in a way that is agreeable to you is what we were
looking for.

> Please get this craziness fixed.

Without proper feedback the team was not sure what to do, the feedback
I read they got was what they were doing was was crazy but I also saw
no alternative method suggested. It took us a while (this thread) to
get alternatives suggested, but I appreciate them.

>> > They don't do anything than claiming that USB device, loading the firmware, and then let it reset.
>>
>> Right but if the SFLASH configurations hardware is already shipping
>> and without firmware is claiming to be a BT USB device which matches
>> the USB vendor:device ID of the btusb driver. Unfortunately it does
>> not accept HCI commands which as you indicates breaks some
>> specification. We can and have fixed this in future chipsets but this
>> one cannot be addressed. So what do we do?
>>
>> > And after the reset the btusb can claim the one where the firmware has
>> > been loaded and which behaves like a proper USB dongle.
>>
>> Right, that's what the fwload patch from our BT team does, no?
>
> Yes, but not inside the btusb driver. Stop hacking a generic driver with
> crazy firmware loading only because the USB Bluetooth class descriptors
> got screwed up in the first place.

Thanks for the pointers on this, I believe our team was not familiar
about these specification violations, they could have learned of the
violations through the old threads with you or through other means,
either way they have been addressed for future hardware it seems. So
while new hardware is fixed we still need to address this old hardware
situation. I'll be honest, our team actually gave up completely on
supporting the older hardware upstream on the Linux kernel as they
were under the impression there was no way to support the device in an
acceptable way by you. Our team should have nagged for alternatives
back then but it would have been easier if these would have come from
you instead of a simple NACK of the patch and indicating their
strategy to resolve this was loony.

>> > The part that I don't understand is that you have the ath3k driver doing
>> > it exactly how it should be done, why now started to make nasty hacks in
>> > the btusb driver.
>>
>> Yeah that seems to have been a shortcoming, its something you should
>> expect from us moving forward. I've been told AR3012 and future
>> Atheros chipsets will not have behave this way, and this issue is only
>> present for the AR3011 devices with SFLASH configuration.
>
> Most likely including the flashing into ath3k firmware loading driver
> and that being called bound twice might be a good idea.

Wouldn't ath3k have to claim the generic btusb device IDs for this to work?

> However we are not doing the firmware loading in btusb. Then a patch to blacklist this
> broken device. And then ensure that the firmware changes the USB PIDs
> after success.
>
> And if I understand you correct, then it does this anyway right now
> already. Otherwise the ath3k driver would not bind to it.

Right, I'm under the impression btusb will load, upload the ath3k-1.fw
to the device, then it re-enumerates itself to match the ath3k USB
vendor:device ID, then ath3k will once again load ath3k-1.fw. Not sure
what happens after that as that is all the code I see and am familiar
with. I'll remind you I am not a Bluetooth developer but an 802.11
developer dragged into this as no traction was being made and we need
to start supporting customers on Linux with this, so please bare with
me if I'm off on the BT stuff.

> Now I am failing to understand why this was done wrong in the first
> place. Especially if the loading procedure happens as you say it
> happens.

You got me :) Anyone?

> This is the example for the Broadcom 203x devices:
>
> static struct usb_device_id blacklist_table[] = {
>        /* Broadcom BCM2033 without firmware */
>        { USB_DEVICE(0x0a5c, 0x2033), .driver_info = BTUSB_IGNORE },
>
> The btusb driver clearly blacklists them. And then bcm203x can take over
> loading the firmware:
>
> static const struct usb_device_id bcm203x_table[] = {
>        /* Broadcom Blutonium (BCM2033) */
>        { USB_DEVICE(0x0a5c, 0x2033) },
>
> So there is a working example of this already in the kernel tree since
> forever.

Nice, thanks for the pointer. Our team will review and try to address
an alternative patch.

Now for my own sanity -- I still don't think I get this how this
BCM2033 blacklist trick works, I take it the device once plugged in
gets a generic btusb USB device vendor:device ID. The btusb driver
then picks up the the blacklist table, and searches for a
usb_match_id() on it for the given interface... What I don't get is
how there will be a match here if the USB vendor:device ID is just the
generic btusb one. Can you help me understand how this trick works?

  Luis
