Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab0KIK0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:26:37 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:55631 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab0KIK0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:26:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Par-Gunnar Hjalmdahl" <pghatwork@gmail.com>
Subject: Re: [PATCH 5/9] mfd: Add UART support for the ST-Ericsson CG2900.
Date: Mon, 8 Nov 2010 06:24:49 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linus.walleij@stericsson.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz.Rymanowski@tieto.com
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com> <20101031120429.1ca38140@pyx> <AANLkTimEYAmocFh_c-KftpL2zRm+LaHzgJOBX31iicLj@mail.gmail.com>
In-Reply-To: <AANLkTimEYAmocFh_c-KftpL2zRm+LaHzgJOBX31iicLj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011080624.49224.arnd@arndb.de>
X-Provags-ID: V02:K0:IUfT6oQENZfQDSYuLtwyCmYvDaBwz1RD90zQAxB/8mg
 ibCIX5tOhiUN/8OvxA4BOxP4QSuLlaoVQfNz4vMFJ+OGoCSNIR
 8aauboe3e+pQIEZJ8kguR3kJP8oxgKUwU71t1uWlM7nPT7fYvE
 9n7Q0i2icF1vC+0XoyT4aTX8JdBaYoBCbU5waZ2QNL0uOHiR4n
 ethsOSKLIEi+bpKIcq05g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 November 2010, Par-Gunnar Hjalmdahl wrote:
> 2010/10/31, Alan Cox <alan@lxorguk.ukuu.org.uk>:
> >> It's about the ldisc number. Both bluetooth and cg2900 register themselves
> >> to ldisc 15 (N_HCI). A user doing TIOCSETD can only get one of the two.
> >
> > Ah I see - I had assumed any actual final merge would be assigning it a
> > new LDISC code as is required.
> 
> Sorry for not answering quicker. We in my department have been
> discussing new design as well as trying out some solutions.
> 
> As an answer to previous comments, both from Arnd and Alan, we would
> like to do the following:
>  - Introduce a new ldisc called N_H4_COMBO with a ldisc driver
> accordingly that will be placed under drivers/char

I'm not convinced, although that's what Alan was suggesting. I'd like
to hear from the bluetooth people what they think about this.

Could you summarize why you think that cg2900 is different enough from
an HCI to require a different line discipline? From your previous
explanation it sounded like it was mostly added functionality,
not something entirely different.

>  - Keep CG2900 driver as an MFD. We will however register the MFD
> cells in each driver and remove the function API. The functions
> (write, reset, etc) will instead be placed in each MFD cell using
> function pointers. This way we can use different functions for
> different channels as needed. By placing the MFD cell registration in
> each chip driver we will also only expose the channels that are
> actually supported by each chip. This way we can also remove the
> pretty ugly matching between the devices and respective H4 channel as
> well as the add_h4_user function and the similar other functions.

Ok, excellent.

> We were thinking about if we could re-use the existing hci_ldisc
> driver. As stated before the big problem here is however that
> hci_ldisc directly registers to the Bluetooth stack. We could separate
> the data for FM and GPS in the protocol driver, but it is pretty ugly
> to have two separate data paths within the same driver.

One of us must be misreading the code. As far as I can tell, hci_ldisc
does not register to the bluetooth stack at all, it just provides
the basic multiplex for multiple HCI protocols, while hci_h4.c
communicates to the bluetooth stack.

If I read it correctly, that means that you can still use hci_ldisc,
but need to add another protocol next to hci_h4 and hci_bcsp for
your cg2900.

> As I've state earlier this would also not work with other transports
> such as SPI.I appreciate Arnd's suggestion to create a TTY for SPI,
> but I think that would overcomplicate the situation and create a
> solution more complex than actually needed. We think that creating a
> new ldisc creates a cleaner solution. It will to some extent remind of
> hci_ldisc, but it will not register to any framework except tty.

How would registering ony to tty solve the problem of SPI?

If you just add another hci_cg2900 module, it can register to both
the hci_ldisc and the spi code.

> We've thought about if we should switch cg2900 to a bus, but after
> discussing this we feel that CG2900 has such individual
> characteristics that it could be hard to create a bus that would suite
> it. We therefore will keep the MFD type. We might in the future add
> new chips to the driver, but they will most likely not require so much
> rework of the driver that we will have to create something completely
> new. We will rather create a lib file that contains common code to
> reduce total code size of the driver.

Yes, makes sense.

	Arnd

