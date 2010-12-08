Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0LHMWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 07:22:03 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:47438 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab0LHMWA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 07:22:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tc+jYj8ePJwijx8M3xMtloZBqup9jUqW2gZ6+JZ4iVb8y8WEXTC60s+BuWR9r/JvTv
         jXrPiEskRO9nhJP5omrOHdQh/C2Bo/CGioFhVTf9gKm78GfeoUto/7umDyhOH5vL7rfm
         kZg36egkpoO6VobZC12KZghVHtZQ7vashLtVE=
MIME-Version: 1.0
In-Reply-To: <AANLkTimCKK9NAiXD4wsCkJt8bsy_exYEBWdb1+M6+NOE@mail.gmail.com>
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com>
	<201012061754.44592.arnd@arndb.de>
	<AANLkTin_VOjz=bGCnANgp8G2SFFFOkT3TKRh50p5L1Gj@mail.gmail.com>
	<201012070007.19239.arnd@arndb.de>
	<AANLkTimCKK9NAiXD4wsCkJt8bsy_exYEBWdb1+M6+NOE@mail.gmail.com>
Date: Wed, 8 Dec 2010 13:21:16 +0100
Message-ID: <AANLkTi=B4wT5SbN2qyyO5RZd7qMnkZXHpB6d=RTQeRtX@mail.gmail.com>
Subject: Re: [PATCH 5/9] mfd: Add UART support for the ST-Ericsson CG2900.
From: Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
To: Pavan Savoy <pavan_savoy@sify.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linus.walleij@stericsson.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavan et al,

2010/12/8 Pavan Savoy <pavan_savoy@sify.com>:
> On Tue, Dec 7, 2010 at 4:37 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Monday 06 December 2010 22:24:34 Vitaly Wool wrote:
>>> On Mon, Dec 6, 2010 at 5:54 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>>
>>> >> But I was trying to make a different point here. On a basic level,
>>> >> there's this cg2000 chip from STE that does BT, FM and GPS. There's
>>> >> the chip from TI that does BT, FM and GPS, and there's the Broadcom
>>> >> chip that does BT+FM. They all use HCI to access the other functions
>>> >> of the combo chip and they do it in a really simiar way, with the
>>> >> differences mostly in power management techniques. So I think it's
>>> >> quite sensible to have some kind of framework that is suitable for
>>> >> such devices.
>>> >
>>> > Yes, I agree 100% in principle. I could not find the code that
>>> > Broadcom/TI FM and GPS stuff so far, can you point us to that?
>>>
>>> Sure, the TI "shared transport" code is mostly at drivers/misc/ti-st.
>>>
>>> Some Broadcom BCM43xx chips work in a similar way AFAIK but I'm not
>>> sure about the mainline support for those.
>>
>> Ah, it had not occured to me to look in drivers/misc. Looking at the
>> code over there, it becomes much clearer what your point is. Evidently
>> the ti-st driver implements a line discipline similar to, but conflicting
>> with hci_ldisc, and it has its own copy of the hci_ll code.
>>
>> I guess this is exactly what we're trying to avoid having with the
>> cg2900 code ;-).
>>
>>> > The cg2900 solution for this was to use MFD (plus another layer
>>> > in the posted version, but that will go away I assume). Using
>>> > MFD is not the only possibility here, but I could not see anything
>>> > wrong with it either. Do you think we can move them all over to
>>> > use MFD infrastructure?
>>>
>>> I guess so but it's probably more of a detail than what I'm up to now :)
>>
>> Agreed.
>>
>>> >> But generally speaking, isn't a line discipline/driver attached to a
>>> >> tty? We can use dumb tty for e. g. SPI and still be able to use
>>> >> hci_ll, right?
>>> >
>>> > I suggested that as well, but the point was made that this would
>>> > add an unnecessary indirection for the SPI case, which is not
>>> > really much like a serial port. It's certainly possible to do it
>>> > like you say, but if we add a way to register the high-level
>>> > protocols with an HCI-like multi-function device, we could
>>> > also do it in a way that does not rely on tty-ldisc but keeps it
>>> > as one of the options.
>>>
>>> I actually don't think it's such a big indirection, I prefer to think
>>> of it more as of the abstraction layer. If not use this, are we going
>>> to have direct SPI device drivers? I'm afraid we might end up with a
>>> huge duplication of code in that case.
>>
>> The question is how it should be modeled in a better way than today.
>>
>> I believe we already agree it should be something like
>>
>>   bt   ti-radio    st-e-radio    ti-gps   st-e-gps  broadcom-radio ...
>>   |         |          |            |          |          |         |
>>   +---------+----------+---------+--+----------+----------+---------+
>>                                  |
>>                          common-hci-module
>>                                  |
>>                      +-----------+-----------+
>>                      |        |       |      |
>>                    serial    spi     i2c    ...
>
> Yes, this sort of architecture would certainly help...
> However, I suppose the most common question as one of you stated above
> was how can the channel -ID and other factors such as offset-header
> packet format be generalized?
>
> As in over here, will the common-hci-module work fine, If say ti-radio
> says he is expecting packets starting from id-8 which is of length 10?
> and also work for st-e-radio which would say expecting data from id-6
> with 15 max bytes?
> Answering this I suppose would solve a lot of our problems....
>
> Marcel did previously suggest a bus-driver sort of a structure, where
> the transport are sort of adapter drivers, the data interpretation
> logic like splitting HCI-events, FM CH-8 packets all fall into the
> algos drivers and the actual Bluetooth driver or GPS or FM-V4L2
> drivers falling into the client/protocol drivers....
>

What the cg2900 driver has now turned into is almost like the
cg2900_core acting as a bus, identifying which chip is connected and
choosing correct chip driver from this. This cg2900_core module should
not contain any vendor specific code. When identified, the chip driver
then uses MFD to setup channels according to the functionality it
supports (one MFD device per H4 channel). It's hard to explain
everything of the new architecture here. I would like you to check the
new patch set I'm trying hard to create at the moment. I will try to
get it out on Friday, but it's hard to promise anything (there is a
lot of work to do with it). There you could then see if it is
something you could consider useful.

/P-G

>
>
>> Any objections to this?
>>
>> If you agree, I think we should discuss the alternatives for the common
>> module. I think you are saying we should make the common module a single
>> ldisc doing the multiplexing and have all transports register as ttys into
>> it, right?
>>
>> What we discussed before was to split it into multiple modules, one for
>> the tty ldisc and one for the common code, and then have the spi/i2c/...
>> drivers feed into the common multiplexer without going through tty.
>>
>> I don't currently see a significant advantage or disadvantage with either
>> approach.
>>
>>        Arnd
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bluetooth" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
