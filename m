Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab0LFXHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:07:34 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:56400 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab0LFXHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 18:07:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vitaly Wool <vitalywool@gmail.com>
Subject: Re: [PATCH 5/9] mfd: Add UART support for the ST-Ericsson CG2900.
Date: Tue, 7 Dec 2010 00:07:19 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1+; KDE/4.5.1; x86_64; ; )
Cc: "Par-Gunnar Hjalmdahl" <pghatwork@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linus.walleij@stericsson.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com> <201012061754.44592.arnd@arndb.de> <AANLkTin_VOjz=bGCnANgp8G2SFFFOkT3TKRh50p5L1Gj@mail.gmail.com>
In-Reply-To: <AANLkTin_VOjz=bGCnANgp8G2SFFFOkT3TKRh50p5L1Gj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012070007.19239.arnd@arndb.de>
X-Provags-ID: V02:K0:pRoO2mXSUavw8fZgccW0EgHXALGgvK9OvyCWrO+Cmv4
 V9WgxFIr/gAEY/llomfupKA/j09STx0iuJbbU7e1HAbLah50+d
 IvFV18JLsc7tJ4BXeHiJsC8uWFtGTH3TBu5NEnR7/zJ7QshADE
 4HfaQXQPFNhbsWCPVFyMEv7ZlyQPUOZSKKKAOLygEEt2D3LRqW
 CdkVOrDVDPnxAKdEYYeWQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 December 2010 22:24:34 Vitaly Wool wrote:
> On Mon, Dec 6, 2010 at 5:54 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> 
> >> But I was trying to make a different point here. On a basic level,
> >> there's this cg2000 chip from STE that does BT, FM and GPS. There's
> >> the chip from TI that does BT, FM and GPS, and there's the Broadcom
> >> chip that does BT+FM. They all use HCI to access the other functions
> >> of the combo chip and they do it in a really simiar way, with the
> >> differences mostly in power management techniques. So I think it's
> >> quite sensible to have some kind of framework that is suitable for
> >> such devices.
> >
> > Yes, I agree 100% in principle. I could not find the code that
> > Broadcom/TI FM and GPS stuff so far, can you point us to that?
> 
> Sure, the TI "shared transport" code is mostly at drivers/misc/ti-st.
> 
> Some Broadcom BCM43xx chips work in a similar way AFAIK but I'm not
> sure about the mainline support for those.

Ah, it had not occured to me to look in drivers/misc. Looking at the
code over there, it becomes much clearer what your point is. Evidently
the ti-st driver implements a line discipline similar to, but conflicting
with hci_ldisc, and it has its own copy of the hci_ll code.

I guess this is exactly what we're trying to avoid having with the
cg2900 code ;-).

> > The cg2900 solution for this was to use MFD (plus another layer
> > in the posted version, but that will go away I assume). Using
> > MFD is not the only possibility here, but I could not see anything
> > wrong with it either. Do you think we can move them all over to
> > use MFD infrastructure?
> 
> I guess so but it's probably more of a detail than what I'm up to now :)

Agreed.
 
> >> But generally speaking, isn't a line discipline/driver attached to a
> >> tty? We can use dumb tty for e. g. SPI and still be able to use
> >> hci_ll, right?
> >
> > I suggested that as well, but the point was made that this would
> > add an unnecessary indirection for the SPI case, which is not
> > really much like a serial port. It's certainly possible to do it
> > like you say, but if we add a way to register the high-level
> > protocols with an HCI-like multi-function device, we could
> > also do it in a way that does not rely on tty-ldisc but keeps it
> > as one of the options.
> 
> I actually don't think it's such a big indirection, I prefer to think
> of it more as of the abstraction layer. If not use this, are we going
> to have direct SPI device drivers? I'm afraid we might end up with a
> huge duplication of code in that case.

The question is how it should be modeled in a better way than today.

I believe we already agree it should be something like

   bt   ti-radio    st-e-radio    ti-gps   st-e-gps  broadcom-radio ...
   |         |          |            |          |          |         |
   +---------+----------+---------+--+----------+----------+---------+
                                  |
                          common-hci-module
                                  |
                      +-----------+-----------+
                      |        |       |      |
                    serial    spi     i2c    ...


Any objections to this?

If you agree, I think we should discuss the alternatives for the common
module. I think you are saying we should make the common module a single
ldisc doing the multiplexing and have all transports register as ttys into
it, right?

What we discussed before was to split it into multiple modules, one for
the tty ldisc and one for the common code, and then have the spi/i2c/...
drivers feed into the common multiplexer without going through tty.

I don't currently see a significant advantage or disadvantage with either
approach.

	Arnd
