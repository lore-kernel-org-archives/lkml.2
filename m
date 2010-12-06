Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab0LFMBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 07:01:50 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45047 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab0LFMBs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 07:01:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cndHrTNdfddJ6JCBrSMmPO6ukWOjjV848Y+mLiaXHLpJNTP8cXLKP4ouXXlr+LFSNw
         v2MpMBlAp3EFvMxhpSLVyaYTPR/TEoww+lmj6i5t2vTerflVG5Opbt/o5TwTBwx1YQwF
         Bk/qiJWsrLR95nD1e7SqNOUnJVhe6e9bAzyLs=
MIME-Version: 1.0
In-Reply-To: <AANLkTimjACtU_Mx5mDHkm9OpVJ4ueNWgZPsX3YjL0cTi@mail.gmail.com>
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com>
	<20101022135130.617f0ce8@lxorguk.ukuu.org.uk>
	<AANLkTinj93zAXJAipB3HjE62Xa1Z=9k9gPBxaT=+MLtg@mail.gmail.com>
	<20101029172443.61f7b067@pyx>
	<AANLkTimiyxiKzT=9pKXLFACkc6C=nTD2dtBR7PcgjhOL@mail.gmail.com>
	<AANLkTim7brB0JecKXDNddt0am=Um457Kfbm6bRG_yzFM@mail.gmail.com>
	<AANLkTik4T=PsMzB+umSQPLDPmeD-6sebgCtrQRePH_2h@mail.gmail.com>
	<AANLkTimjACtU_Mx5mDHkm9OpVJ4ueNWgZPsX3YjL0cTi@mail.gmail.com>
Date: Mon, 6 Dec 2010 13:01:46 +0100
Message-ID: <AANLkTikMAWikj9HQ76YVeHr7pMoFK6ME2=HHpuQ1kUxq@mail.gmail.com>
Subject: Re: [PATCH 5/9] mfd: Add UART support for the ST-Ericsson CG2900.
From: Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linus.walleij@stericsson.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vitaly,

2010/12/6 Vitaly Wool <vitalywool@gmail.com>:
> Hi Par,
>
> On Mon, Dec 6, 2010 at 10:06 AM, Par-Gunnar Hjalmdahl
> <pghatwork@gmail.com> wrote:
>
>>> So is it true that if there's the other chip with similar
>>> functionality I have to implement support for, I'll have to pretty
>>> much duplicate your line discipline driver?
>>>
>>
>> What will be in the protocol file, i.e. the same level as hci_h4.c,
>> hci_bcsp.c, etc, will be to ~80% vendor specific. The only H4 channels
>> that are in a standardized specification are the Bluetooth channels
>> 1-4. Other channels such as FM and GPS are vendor specific. I've seen
>> that for example TI has the same channels for FM and GPS, but these
>> channels, 8 and 9, are in no way standardized. The CG2900 also carries
>> a number of other channels, such as debug and device channels, which
>> I'm pretty sure is individual for this chip.
>> This identification of the channels is also only one function, even
>> though it is an important function. There are also a lot of other code
>> regarding baud rate settings, low power handling, etc that I'm
>> positive will not apply to chips of other vendors. It is of course
>> possible that other chips from ST-Ericsson, current and future, will
>> be able to reuse this file, but as I said I doubt that other vendors
>> might be able to use it.
>
> Wait. What level of abstraction is this file at if even some future
> STE chips are not guaranteed to work with it? Is it at a level of
> hardcoding the GPIO numbers?
>

There are no GPIOs or similar in the driver code; those are defined
and used in the board specific files under the /arch/ files. What
could be a problem with a future chip would be if for example the HCI
command to change baud rate would change. We have no indication that
this will change, but I cannot give a lifetime guarantee that nothing
will ever change with how the chip startup is handled.

>>> Isn't it better to have a new line discipline that the standard
>>> drivers (H4, LL, ...) will be applicable to?
>
>> I'm not certain what you mean. We are modifying the line discipline a
>> bit, but the only thing we have needed to do with existing protocol
>> drivers has been to add a boolean parameter for the protocol settings
>> (so they will register to the Bluetooth stack). I don't see why we
>> should create a new line discipline driver and then move the existing
>> protocol drivers to this.
>
> Okay, let me try to be more specific. There's for instance
> drivers/bluetooth/hci_ll.c which is the line discipline driver that is
> meant to work with any BT chip supporting LL protocol. Your solution
> seems to imply that one will have to create a variation of this
> implementation for each BT chip supporting LL that will use your
> shared transport implementation. Is it really the case?
>
> Thanks,
>   Vitaly
>

Well, from what I can see LL is an extension of the H4, basically it
adds sleep mode handling in a vendor specific way to the normal H4
protocol. So it is also based on the hci_h4 just as our file is. But
our file has basically nothing in common with what has been for the LL
file. We don't support any of the LL sleep commands for example.
So if I would make a driver for a combo chip supporting LL, I would
either modify the existing hci_ll.c or I would make a new file based
on hci_ll.c. There is not much you could really reuse from our new
file. Basically it would be the handling of any common channels, so if
you would for example have the same specification of FM and GPS you
could maybe save around 20 lines of common code, but you would
probably have to add a lot of more code just to keep the solution
generic.
One major difference is also that hci_ll never changes baud rate or
other settings. I assume that is done from hciattach during startup
instead. But we cannot run with that since we have to shut down the
chip when no user is connected in order to save power. This means that
we have to add vendor specific commands in order to for example set
baud rate. And then you run into these vendor specific problems. If
there would be a standardized specification on how to set baud rate
and how to put chip in sleep I assume things could be solved
differently, but that is not the case.

As a quick answer to your question: that would depend on the
difference between the different controllers, I guess. But CG2900
doesn't support the LL protocol so it is not an issue for that.

/P-G
