Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab0JLHJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 03:09:11 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:22909 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756610Ab0JLHJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 03:09:10 -0400
Message-ID: <000c01cb69dc$5d2aaab0$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Wolfgang Grandegger" <wg@grandegger.com>,
        "David Miller" <davem@davemloft.net>
Cc: <andrew.chih.howe.khor@intel.com>, <sameo@linux.intel.com>,
        <margie.foster@intel.com>, <netdev@vger.kernel.org>,
        <yong.y.wang@intel.com>, <linux-kernel@vger.kernel.org>,
        <socketcan-core@lists.berlios.de>, <mkl@pengutronix.de>,
        <chripell@fsfe.org>, <morinaga526@dsn.okisemi.com>,
        <kok.howg.ewe@intel.com>, <joel.clark@intel.com>, <qi.wang@intel.com>
References: <002e01cb6486$2ed72cc0$66f8800a@maildom.okisemi.com>	<20101005.114506.184852374.davem@davemloft.net>	<000b01cb6503$962bc7f0$66f8800a@maildom.okisemi.com> <20101005.200904.71120150.davem@davemloft.net> <4CAC3D94.9010408@grandegger.com>
Subject: Re: [MeeGo-Dev][PATCH v3] Topcliff: Update PCH_CAN driver to 2.6.35
Date: Tue, 12 Oct 2010 16:09:04 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfgang,

We have implemented our CAN driver with FIFO mode, and
We are testing our CAN driver with FIFO mode.
However, we have found Our CAN hardware spec is different from our anticipated.
Our CAN HW FIFO is not common FIFO.
Using  FIFO mode, there is possibility received packets are out-of-order.

e.g.
Recv packet-A from NW and set to FIFO.
  |A|

Recv packet-B from NW and set to FIFO.
  |A|B|

Recv packet-C is about to set to FIFO
  |A|B|(C)|

Userspace Copies A from Driver
Userspace Copies B from Driver
  |   |   |(C)|

packet-C set to FIFO (C is not head.)
Recv packet-D from NW(Next packet is set to head)
  |D|   |C|

Userspace Copies D from Driver
Userspace Copies C from Driver
Userspace raceived packet order is like below
A-B-D-C

So, I think normal-mode is better than FIFO-mode.

I will revert like the following spec.
  Rx 1 Message Object
  Tx 1 Message Object

Could you agree the above ?

Thanks, Ohtake(OKISemi)
----- Original Message ----- 
From: "Wolfgang Grandegger" <wg@grandegger.com>
To: "David Miller" <davem@davemloft.net>
Cc: <masa-korg@dsn.okisemi.com>; <andrew.chih.howe.khor@intel.com>; <sameo@linux.intel.com>; <margie.foster@intel.com>;
<netdev@vger.kernel.org>; <yong.y.wang@intel.com>; <linux-kernel@vger.kernel.org>; <socketcan-core@lists.berlios.de>;
<mkl@pengutronix.de>; <chripell@fsfe.org>; <morinaga526@dsn.okisemi.com>; <meego-dev@meego.com>;
<kok.howg.ewe@intel.com>; <joel.clark@intel.com>; <qi.wang@intel.com>
Sent: Wednesday, October 06, 2010 6:12 PM
Subject: Re: [MeeGo-Dev][PATCH v3] Topcliff: Update PCH_CAN driver to 2.6.35


> On 10/06/2010 05:09 AM, David Miller wrote:
> > From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
> > Date: Wed, 6 Oct 2010 12:07:15 +0900
> >
> >> Does your mail mean, for accepting upstream, NAPI is essential for
> >> CAN driver ?
> >
> > It is up to the CAN maintainers :-)
>
> Well, our SJA1000 reference driver does still not use NAPI. But NAPI is
> for CAN especially useful to avoid the infamous *bus error irq
> flooding*, which may hang low end systems if the interrupts are handled
> in the IRQ context. Ohtake, if your system can handle well such CAN bus
> error irq storms at 1MB/s, then NAPI is *not* a must to have. Anyway, as
> you are at it, I also suggest to use NAPI right from the beginning.
>
> Wolfgang.
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


