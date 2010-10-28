Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635Ab0J1MSh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 08:18:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59201 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758139Ab0J1MSf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 08:18:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Par-Gunnar Hjalmdahl" <pghatwork@gmail.com>
Subject: Re: [PATCH 1/9] mfd: Add support for the ST-Ericsson CG2900.
Date: Thu, 28 Oct 2010 14:18:30 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linus.walleij@stericsson.com, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <AANLkTineXA2ZY0J7+dZhqywz+4aAVgzihu+LDDbsL8mu@mail.gmail.com> <201010261406.10996.arnd@arndb.de> <AANLkTin72z7AmfkMMH01siwkNNNvHM+1+qXLodmaUx5q@mail.gmail.com>
In-Reply-To: <AANLkTin72z7AmfkMMH01siwkNNNvHM+1+qXLodmaUx5q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201010281418.30399.arnd@arndb.de>
X-Provags-ID: V02:K0:7x90zxlaHSYC9tzq/roSxBTykb8RR01eQugxyuU184E
 z+wbZZFI/rUOzv1zr/9P544wpoOMhnKXyXYnXi4R7eDeajGx2C
 GWwmal+W1yIRnD7OqM3JIaaHGhrfnWsCh6058UvFB1BdtAYrCw
 iOJvzr/ZvMMYRYz2SLOCuMsyoi83w3lxhmUA02iDJdG1V08Q22
 R2PSivdMngFIH0IwAHvhw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 October 2010, Par-Gunnar Hjalmdahl wrote:
> Thanks for this explanation. I would like to see this as a MFD at the
> moment since it is most definitely a silicon, as stated by Linus
> Walleij in a separate answer.
> In the future this could however be extended to be a bus, when we
> could use more chips with this driver.

Ok, fair enough. Time will tell if you need this as a bus then,
or alternatively use multiple multi-function drivers, perhaps
with some shared code in form of another "library" module.
 
The only important part is that you do not introduce user-visible
interfaces that can not be changed if you decide to rewrite the
implementation.

> > Does that mean that cg2900 is to the host side a standard bluetooth HCI,
> > but it uses extensions to the HCI in order to make the other functions
> > available to the host?
> >
> > What chapter in the bluetooth core specification describes this?
> >
> 
> Yes, exactly. Just for Bluetooth functionality you could more or less
> use existing Bluetooth UART drivers (you still have to enable chip and
> so on separately though), but in order to reach FM and GPS this
> protocol has been extended. In order to have an energy efficient
> solution there must also be a common driver that can shut off the chip
> when not in use, hence this CG2900 driver.
> You can read about the original protocol in the Bluetooth Core
> specification Volume 4 Part A - UART Transport Layer.
> This way to extend functionality upon the existing protocol is common
> amongst chip manufacturers for combo chips including Bluetooth
> functionality. Texas Instruments has already posted a driver for their
> chip (in drivers/staging/ti-st) that uses a similar protocol.

Hmm, this sounds like it's at least one level below where I expected
it. So your cg2900 is connected through a UART and behaves like a serial
bluetooth host, right?

If that's the case, I think what you should have done is to make the
low-level interface available to Linux as a tty/serial driver,
which gets switched to the HCI line discipline.

The code for this is in drivers/bluetooth/hci_ldisc.c.

On top of this sits the hci_h4 protocol driver, drivers/bluetooth/hci_h4.c
and you additional functionality would have to hook into that.

Is this a setup you have considered? Any particular reasons why you
decided against it? Or are you actually doing exactly this and I'm
just too blind to see it?

> Oops, I misunderstood your question. The name is supplied by the user
> calling cg2900_register_user. The names are defined for reference in
> include/linux/mfd/cg2900.h.
> We used to have an enum to define this, but since we thought that
> using name lookup to be more future safe (and as well more "Kernel
> like") we chose to use that instead. It can have been a bad choice.
> Problem here is to some extent that we are beginners at Linux coding.

We generally use strings for stuff that comes from hardware or
user and needs to be extensible, like the driver names.

In your case, there is no such requirement, so an enum would probably
have been much simpler.

> A straight minimal API seemed to be easiest way to solve it. As you
> say we could probably use device registration as you state (we are
> already using MFD cells so we could possibly extend that) but I don't
> know if that would improve our code.

Using mfd cells is reasonable, but you really should not try to duplicate
infrastructure code by introducing another layer on top.

I'm not familiar with MFD, but it's clear that your code took a wrong
turn in some place when you had to do that.

>From what I can tell, the slave drivers should only need to register
a platform_driver that binds to the mfd cells created here, but
the base driver should not at all need to interact with the slaves
otherwise.

> We also have a lot of internal dependencies (like our FM driver that
> will be submitted to the Kernel community) so would like to avoid
> changing APIs if possible. But if you make this an absolute demand I
> guess we will have to follow.

Changing internal APIs is not an issue, we do that all the time and you
really need not be afraid of it.

The thing we don't do is to change the user-visible kernel ABI!

I'm not asking to specifically change the string into an enum, the
real question is if you use the right abstraction, and the fact that
you had to choose an identifier like this hints that you are not.

This issue probably disappears once the question of the MFD integration
is solved.

> What is transmitted over each char dev is individual for that channel.
> For BT channels this will be BT data (normally char dev is not used
> for Bluetooth since BT stack connection is done directly in Kernel
> through btcg2900.c), for FM channel this will be FM data, etc. But
> most of all it will not be the same format as the sockets provided by
> the Bluetooth stack (at least I think so) since BT stack have
> protocols below the sockets (such as L2CAP). What is sent over the
> char dev is the same data as sent to the chip minus the H4 header (the
> first byte).

I see.

One point where I think the abstraction went wrong is that you have
a matrix of drivers and channels: The chardev is registered as
an MFD cell and the driver binds to that cell, creating a device
node for each channel (BT_CMD, FM_RADIO, ...).

What you should have instead is a single MFD cell for each channel
and let each channel bind to one driver!

The channel is the primary differentiator between functionality
on the CG2900, so that is what becomes your cell. Since you added
another abstraction on top, you had to duplicate core functionality
of the kernel, which is what I initially saw as "this looks wrong,
no idea what's going on".

> The CG2900 driver is currently written only to support one CG2900
> chip, but of course that could be extended in the future.

Ok. So if you use the MFD framework correctly, future chips
will require a new base driver but the slaves that you already
have drivers for will be able to use their drivers without modification,
right?

	Arnd
