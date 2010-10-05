Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab0JEU3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 16:29:18 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55890 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab0JEU3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 16:29:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=L5UQ0mCqx0Uoc7PuB/TL+4CMXclz9l987pPGjmblRbfmdRhdrVKXSmX+gx3U66KsuS
         YFFTK3BBufyn7YNvZ5VeoD5OTBDgIE8IhTsoIg8EQqGKqAS4QtRVS9Ldyxf8dRPScuXb
         bHUscTXsO+n387qT/NRf0MtpQryIrm47BmRiY=
MIME-Version: 1.0
In-Reply-To: <1286308731.2588.13.camel@aeonflux>
References: <20100924230730.GB6566@tux> <1286266981.17473.33.camel@aeonflux>
 <20101005192814.GB11831@tux> <1286308731.2588.13.camel@aeonflux>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 5 Oct 2010 13:28:53 -0700
X-Google-Sender-Auth: 2ouvvauR6Ip_Xc2NscyBivSxWNo
Message-ID: <AANLkTimz7U52_qHaTutQDOFQde+GrWJRA0WpqY__FPgi@mail.gmail.com>
Subject: Re: RFC: btusb firmware load help
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
        Sree Durbha <Sree.Durbha@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 5, 2010 at 12:58 PM, Marcel Holtmann
<holtmann@linux.intel.com> wrote:
> Hi Luis,
>
>> > > Marcel, I was just poked about this thread:
>> > >
>> > > http://www.spinics.net/lists/linux-bluetooth/msg06087.html
>> > >
>> > > The hack is required because our BT hardware does not accept HCI commands
>> > > when the device is plugged in. If I understood your position you did not
>> > > want to accept the patch because our BT USB devices are violating the
>> > > specification by not acceping HCI commands and yet claiming to be BT
>> > > devices, is that right?
>> >
>> > you don't have to accept HCI commands when your device has no firmware
>> > loaded. That is just fine. However at that point you should not claim to
>> > be a Bluetooth H:2 device with USB Bluetooth descriptors.
>> >
>> > Just having different USB PIDs for without firmware and with firmware
>> > stages would have been fine. The ancient Broadcom 203x devices even got
>> > that part right.
>>
>> Ah I see.
>>
>> > So what about sticking with the current VID:PID for the device without
>> > firmware and we blacklist it in btusb driver. And then the firmware
>> > loading ensures that after reset it uses a different PID for the device
>> > with valid HCI firmware.
>>
>> How would firmware be uploaded to the device if no module
>> is claiming it?
>
> most likely via a separate firmware loading driver.

Like the fwload patch ? Or something different?

> Your ath3k driver is such a driver. Same as the bcm203x driver.

Right -- so ath3k depends on some atheros USB device IDs, and its a
stupid driver that just loads firmware. The problem with this new
device is that it requires two phases. One to load some sort of
firmware onto it to get it to read as an ath3k device, and then ath3k
will load the right firmware to it. So the hardware device is already
claiming a btusb vendor:device ID, we can't change that I believe. Of
course for future devices we can, and we've addressed this and its
been fixed.

> They don't do anything than claiming that USB device, loading the firmware, and then let it reset.

Right but if the SFLASH configurations hardware is already shipping
and without firmware is claiming to be a BT USB device which matches
the USB vendor:device ID of the btusb driver. Unfortunately it does
not accept HCI commands which as you indicates breaks some
specification. We can and have fixed this in future chipsets but this
one cannot be addressed. So what do we do?

> And after the reset the btusb can claim the one where the firmware has
> been loaded and which behaves like a proper USB dongle.

Right, that's what the fwload patch from our BT team does, no?

> The part that I don't understand is that you have the ath3k driver doing
> it exactly how it should be done, why now started to make nasty hacks in
> the btusb driver.

Yeah that seems to have been a shortcoming, its something you should
expect from us moving forward. I've been told AR3012 and future
Atheros chipsets will not have behave this way, and this issue is only
present for the AR3011 devices with SFLASH configuration.

  Luis
