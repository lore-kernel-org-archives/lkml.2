Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab2HNK6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 06:58:16 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43272 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2HNK6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 06:58:14 -0400
MIME-Version: 1.0
Date: Tue, 14 Aug 2012 12:58:13 +0200
Message-ID: <CAOA3yKL8d8GUCjDsmSgmbo0i2kHZ2qxZfc44y96hCgcB-FLZkQ@mail.gmail.com>
Subject: Re: [3.5 regression / mcs7830 / bisected] bridge constantly toggeling
 between disabled and forwarding
From: Ambroz Bizjak <ambrop7@gmail.com>
To: linux-kernel@vger.kernel.org, Ondrej Zary <linux@rainbow-software.org>,
        Michael Leun <lkml20120218@newton.leun.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 24 Jul 2012 01:36:34 +0200
> Michael Leun <lkml20120218@newton.leun.net> wrote:
>
> My report might sound like I'm complaining that link state detection
> works because link state detection was implemented - sorry, but thats
> not true.
>
> I do NOT see this link state changes if there is no traffic on the
> interface, but I start seeing them once I start pinging. I think this
> is not the idea of link state detection?
>
> I would very much appreciate if you could have a look into that,
> because it is rather annoying.
>
> > On Mon, 23 Jul 2012 09:15:04 +0200
> > Michael Leun <lkml20120218@newton.leun.net> wrote:
> >
> > [see issue description below]
> >
> > Bisecting yielded
> >
> > b1ff4f96fd1c63890d78d8939c6e0f2b44ce3113 is the first bad commit
> > commit b1ff4f96fd1c63890d78d8939c6e0f2b44ce3113
> > Author: Ondrej Zary <linux@rainbow-software.org>
> > Date:   Fri Jun 1 10:29:08 2012 +0000
> >
> >     mcs7830: Implement link state detection
> >
> >     Add .status callback that detects link state changes.
> >     Tested with MCS7832CV-AA chip (9710:7830, identified as rev.C by the driver).
> >     Fixes https://bugzilla.kernel.org/show_bug.cgi?id=28532
> >
> >     Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> >     Signed-off-by: David S. Miller <davem@davemloft.net>
> >
> > :040000 040000 5480780cb5e75c57122a621fc3bab0108c16be27 d97efd9cc0a465dff76bcd3a3c547f718f2a5345 M    drivers
> >
> >
> > Reverting that from 3.5 makes the issue go away.
> >
> > > Hi,
> > >
> > > when I use my usb ethernet adapter
> > >
> > > # > lsusb
> > > [...]
> > > Bus 002 Device 009: ID 9710:7830 MosChip Semiconductor MCS7830 10/100 Mbps Ethernet adapter
> > > [...]
> > >
> > > as port of an bridge
> > >
> > > > # brctl addbr br0
> > > > # brctl addif br0 eth0
> > > > # brctl addif br0 ue5
> > > > # ifconfig ue5 up
> > > > # ifconfig br0 up
> > >
> > > (Also does happen when eth0 is not part of the bridge, but the logs I
> > > had available were from that situation...)
> > >
> > > I constantly get messages showing the interface toggeling between
> > > disabled and forwarding state:
> > >
> > > Jul 23 07:40:50 elektra kernel: [ 1539.497337] br0: port 2(ue5) entered disabled state
> > > Jul 23 07:40:50 elektra kernel: [ 1539.554992] br0: port 2(ue5) entered forwarding state
> > > Jul 23 07:40:50 elektra kernel: [ 1539.555005] br0: port 2(ue5) entered forwarding state
> > > Jul 23 07:40:51 elektra kernel: [ 1540.496242] br0: port 2(ue5) entered disabled state
> > > Jul 23 07:40:51 elektra kernel: [ 1540.552534] br0: port 2(ue5) entered forwarding state
> > > Jul 23 07:40:51 elektra kernel: [ 1540.552548] br0: port 2(ue5) entered forwarding state
> > > Jul 23 07:40:52 elektra kernel: [ 1541.550413] br0: port 2(ue5) entered forwarding state
> > > Jul 23 07:40:53 elektra kernel: [ 1542.529672] br0: port 2(ue5) entered disabled state
> > > Jul 23 07:40:53 elektra kernel: [ 1542.587162] br0: port 2(ue5) entered forwarding state
> > > Jul 23 07:40:53 elektra kernel: [ 1542.587175] br0: port 2(ue5) entered forwarding state
> > > Jul 23 07:40:54 elektra kernel: [ 1543.585309] br0: port 2(ue5) entered forwarding state
> > > Jul 23 07:41:00 elektra kernel: [ 1549.360600] br0: port 2(ue5) entered disabled state
> > > Jul 23 07:41:00 elektra kernel: [ 1549.442998] br0: port 2(ue5) entered forwarding state
> > > Jul 23 07:41:00 elektra kernel: [ 1549.443011] br0: port 2(ue5) entered forwarding state
> > > Jul 23 07:41:01 elektra kernel: [ 1550.357686] br0: port 2(ue5) entered disabled state
> > > Jul 23 07:41:01 elektra kernel: [ 1550.408208] br0: port 2(ue5) entered forwarding state
> > > Jul 23 07:41:01 elektra kernel: [ 1550.408222] br0: port 2(ue5) entered forwarding state
> > > Jul 23 07:41:02 elektra kernel: [ 1551.407656] br0: port 2(ue5) entered forwarding state
> > > Jul 23 07:41:03 elektra kernel: [ 1552.401578] br0: port 2(ue5) entered disabled state
> > > Jul 23 07:41:03 elektra kernel: [ 1552.474773] br0: port 2(ue5) entered forwarding state
> > > Jul 23 07:41:03 elektra kernel: [ 1552.474786] br0: port 2(ue5) entered forwarding state
> > > Jul 23 07:41:04 elektra kernel: [ 1553.472487] br0: port 2(ue5) entered forwarding state
> > > Jul 23 07:41:05 elektra kernel: [ 1554.356138] br0: port 2(ue5) entered disabled state
> > > [...]
> > >
> > > This does (in the same situation, nothing else than the kernel changed)
> > > not happen with 3.4.5.
> > >
> > > Does anybody have an idea what the issue might be or do I need to bisect?
> >
> >
> > --
> > MfG,
> >
> > Michael Leun
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
>
>
> --
> MfG,
>
> Michael Leun
>

I'm also hitting this regression in 3.5.1. After I add the device to
the bridge, it's constantly switching between disabled/forwarding, and
losing packets as a result. It appears to be somehow triggered by
traffic. The link state changes are definitely incorrect, as the cable
is plugged in all the time.
