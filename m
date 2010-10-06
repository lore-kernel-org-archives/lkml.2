Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222Ab0JFRiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 13:38:12 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47239 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab0JFRiI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 13:38:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=A5Ap/TenOuUYqF7DKGR1FxduXmNPGc+cJZB3SV+zicJmZ6tsApDSc8c5FfUErlPwXp
         0PPIiSRx9PrdJ3iQ6CgPHlNMuenbMDT2YZ8eyALyZZyp9ZPlJkU8W40oosBuNQyQdsSj
         6WR4ezywQ44uPDEqPm38qD2iMYtwmzl8KOwkc=
MIME-Version: 1.0
In-Reply-To: <20101006163816.GE7070@tux>
References: <20100924230730.GB6566@tux> <1286266981.17473.33.camel@aeonflux>
 <20101005192814.GB11831@tux> <1286308731.2588.13.camel@aeonflux>
 <AANLkTimz7U52_qHaTutQDOFQde+GrWJRA0WpqY__FPgi@mail.gmail.com>
 <1286349552.6145.11.camel@aeonflux> <AANLkTimDvgFtoGLEjgWyYRrhQy6Num-rn_2WYO4Lf84b@mail.gmail.com>
 <1286380566.6145.42.camel@aeonflux> <20101006163816.GE7070@tux>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 6 Oct 2010 10:37:46 -0700
X-Google-Sender-Auth: XRUo2ixIY38w1BcjJSOU9IYS9D8
Message-ID: <AANLkTik9w4_PdcEsbRHakLcxcD334_1Q8hGArxTXPCGF@mail.gmail.com>
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

On Wed, Oct 6, 2010 at 9:38 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Wed, Oct 06, 2010 at 08:56:06AM -0700, Marcel Holtmann wrote:
>> Hi Luis,
>>
>> > > Now I am failing to understand why this was done wrong in the first
>> > > place. Especially if the loading procedure happens as you say it
>> > > happens.
>> >
>> > You got me :) Anyone?
>> >
>> > > This is the example for the Broadcom 203x devices:
>> > >
>> > > static struct usb_device_id blacklist_table[] = {
>> > >        /* Broadcom BCM2033 without firmware */
>> > >        { USB_DEVICE(0x0a5c, 0x2033), .driver_info = BTUSB_IGNORE },
>> > >
>> > > The btusb driver clearly blacklists them. And then bcm203x can take over
>> > > loading the firmware:
>> > >
>> > > static const struct usb_device_id bcm203x_table[] = {
>> > >        /* Broadcom Blutonium (BCM2033) */
>> > >        { USB_DEVICE(0x0a5c, 0x2033) },
>> > >
>> > > So there is a working example of this already in the kernel tree since
>> > > forever.
>> >
>> > Nice, thanks for the pointer. Our team will review and try to address
>> > an alternative patch.
>> >
>> > Now for my own sanity -- I still don't think I get this how this
>> > BCM2033 blacklist trick works, I take it the device once plugged in
>> > gets a generic btusb USB device vendor:device ID. The btusb driver
>> > then picks up the the blacklist table, and searches for a
>> > usb_match_id() on it for the given interface... What I don't get is
>> > how there will be a match here if the USB vendor:device ID is just the
>> > generic btusb one. Can you help me understand how this trick works?
>>
>> the generic Bluetooth USB class descriptors is what btusb uses. With a
>> few expectation for devices that use VID:PID combination.
>
> Ahhh... got it..
>
>> So in general what happens if a device gets matched via the Bluetooth
>> USB class descriptors the btusb driver will claim. We do however check
>> against out blacklist first. If the VID:PID is listed in the blacklist
>> we do return ENODEV. That means that the USB subsystem goes ahead and
>> tries the next driver. In this case bcm203x driver. This will claim it,
>> load the firmware, reset it and come back with different VID:PID values.
>> After that the btusb can successfully claim it since it is no longer in
>> the blacklist.
>
> Ah neat.
>
>> If I understand this all correct without having the hardware available
>> for verifying this, then it should be like this:
>>
>> Just add this to blacklist_table[] in btusb.c:
>>
>>         /* Atheros AR3011 without firmware */
>>         { USB_DEVICE(0x0cf3, 0x3002), .driver_info = BTUSB_IGNORE },
>>
>> And then we can add the firmware loading to ath3k driver to load the
>> specific 1st stage firmware. And then ath3k can load the 2nd stage as
>> well. After that it should become a default Bluetooth USB device and the
>> btusb driver can take care of it.
>
> Got it... thanks for the clarification. So ath3k actually doesn't seem to
> have 2-stage firmware files, ath3k-2.fw actually seems to be a new firmware
> upgrade. The firmware already made it into linux-firmware.git tree but the
> respective patch just never made it upstream. I am not sure of the
> differences between these firmware but I do remember reading from Vikram
> that no new API was changed. I asked for clarification on the firmware
> updates and asked if it can be documented here:
>
> http://wireless.kernel.org/en/users/Drivers/ath3k
>
> If the device can live with simply getting ath3k-1.fw loaded once then
> perhaps the change you described above is all that is needed, not sure.
>
> Deepak, can you please try this patch, I don't have hardware to test
> this with.
>
> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> index d22ce3c..a62c1b2 100644
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -140,6 +140,9 @@ static struct usb_device_id blacklist_table[] = {
>        /* Frontline ComProbe Bluetooth Sniffer */
>        { USB_DEVICE(0x16d3, 0x0002), .driver_info = BTUSB_SNIFFER },
>
> +       /* Atheros AR3011 without firmware */
> +       { USB_DEVICE(0x0cf3, 0x3002), .driver_info = BTUSB_IGNORE },
> +
>        { }     /* Terminating entry */
>  };

I just got this description from Sady:

-------------------------------------------------------------------------------------------------------------------
With eeprom based AR3011 hardware, normally this device gets detected
as a normal USB device with VID=0x0CF3, PID=0x3000.
Ath3k DFU driver will download the firmware in to RAM.
Due to firmware download in the RAM it is exposed as new device
with VID=0x0CF3, PID=0x3002 to host Bluetooth sub system and btusb.ko
driver probe routine gets called to bring up Bluetooth interface.
This is the normal procedure we have done so far on Linux.

With sflash based AR3011 hardware, when we connect the device to USB
port it gets detected as a Bluetooth device because of firmware in
Flash (VID=0x0CF3, PID=0x3002). This triggers the Bluetooth sub
system driver (btusb.ko) directly in the host instead of ath3k
DFU driver. Therefore, there is no firmware downloaded in to the
RAM to bring up Bluetooth at this point. This is the problem
we're trying to "fix".
-------------------------------------------------------------------------------------------------------------------

With the above patch we'd get ath3k to do the firmware uploading but
I'm afraid that we'll go into a loop here unless we can figure out a
way to get btusb to know the device is now ready.

  Luis
