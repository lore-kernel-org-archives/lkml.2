Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab0KKOlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 09:41:01 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39888 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab0KKOk7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 09:40:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=abWKA2t9R2ZmjeKtJbEOQ6h1T6G5+QTLwaW34yTnkOng4+0cXbXbCfz8z9p+Y3u7yx
         +HA3LVwYw4fplKXiqnHtLGrN2DSv45dmmnDZEQXHsVdsxcaBXZE2R83TX/BpvQazNIiB
         lYMWGYGCbuuqk6uv4EVgU7iSKAHPL3gBabBms=
MIME-Version: 1.0
In-Reply-To: <AANLkTinzcRv5Mc+9HRwxYgxZCBNER_RdTVHTOyVtozJf@mail.gmail.com>
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com>
	<20101031120429.1ca38140@pyx>
	<AANLkTimEYAmocFh_c-KftpL2zRm+LaHzgJOBX31iicLj@mail.gmail.com>
	<201011080624.49224.arnd@arndb.de>
	<AANLkTinzcRv5Mc+9HRwxYgxZCBNER_RdTVHTOyVtozJf@mail.gmail.com>
Date: Thu, 11 Nov 2010 15:40:58 +0100
Message-ID: <AANLkTi=J_K0sEwyfr4PoFBzEYp4yqYVm3NCRLv6mfLBx@mail.gmail.com>
Subject: Re: [PATCH 5/9] mfd: Add UART support for the ST-Ericsson CG2900.
From: Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linus.walleij@stericsson.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz.Rymanowski@tieto.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/11 Par-Gunnar Hjalmdahl <pghatwork@gmail.com>:
> 2010/11/8 Arnd Bergmann <arnd@arndb.de>:
>> On Friday 05 November 2010, Par-Gunnar Hjalmdahl wrote:
>>> 2010/10/31, Alan Cox <alan@lxorguk.ukuu.org.uk>:
>>> >> It's about the ldisc number. Both bluetooth and cg2900 register themselves
>>> >> to ldisc 15 (N_HCI). A user doing TIOCSETD can only get one of the two.
>>> >
>>> > Ah I see - I had assumed any actual final merge would be assigning it a
>>> > new LDISC code as is required.
>>>
>>> Sorry for not answering quicker. We in my department have been
>>> discussing new design as well as trying out some solutions.
>>>
>>> As an answer to previous comments, both from Arnd and Alan, we would
>>> like to do the following:
>>>  - Introduce a new ldisc called N_H4_COMBO with a ldisc driver
>>> accordingly that will be placed under drivers/char
>>
>> I'm not convinced, although that's what Alan was suggesting. I'd like
>> to hear from the bluetooth people what they think about this.
>>
>> Could you summarize why you think that cg2900 is different enough from
>> an HCI to require a different line discipline? From your previous
>> explanation it sounded like it was mostly added functionality,
>> not something entirely different.
>>
>>> We were thinking about if we could re-use the existing hci_ldisc
>>> driver. As stated before the big problem here is however that
>>> hci_ldisc directly registers to the Bluetooth stack. We could separate
>>> the data for FM and GPS in the protocol driver, but it is pretty ugly
>>> to have two separate data paths within the same driver.
>>
>> One of us must be misreading the code. As far as I can tell, hci_ldisc
>> does not register to the bluetooth stack at all, it just provides
>> the basic multiplex for multiple HCI protocols, while hci_h4.c
>> communicates to the bluetooth stack.
>>
>> If I read it correctly, that means that you can still use hci_ldisc,
>> but need to add another protocol next to hci_h4 and hci_bcsp for
>> your cg2900.
>>
>
> If you look in function hci_ldisc.c/hci_uart_register_dev(), it here
> registers as a driver to the Bluetooth stack. This means that received
> Bluetooth packets would go ldisc->protocol->ldisc->bluetooth, while FM
> and GPS would go ldisc->protocol->(FM/GPS)stack. I think it's quite
> bad to have two different data paths like this. The new ldisc we're
> creating looks a lot like hci_ldisc, but it does not register itself
> to an overlaying stack directly.
> One option would of course be to modify the existing hci_ldisc.c but I
> feel that be rather dangerous and which could create a lot of
> problems.
>
> /P-G
>

After looking again at the code I see that I was wrong.
For the receiving path the data will go ldics->protocol->stack. It's
actually the TX path (to the chip) that is a bit strange where
Bluetooth data is going to stack->ldisc->protocol->ldisc->uart. Here
we would have a separate path for FM and GPS.
I still don't like the idea of making a tty/ldisc for the SPI
transport. I definitely would prefer instead a new ldisc which doesn't
register to any stack on top. My preference would be to keep the
solutions independent, where we use tty/ldisc for UART and a direct
transport protocol driver for SPI (i.e. registering using
spi_register_driver).

/P-G
