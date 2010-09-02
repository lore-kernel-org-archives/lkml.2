Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab0IBDTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 23:19:54 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:33116 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752861Ab0IBDTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 23:19:53 -0400
Message-ID: <001301cb4a4d$b4c4ba80$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Wolfgang Grandegger" <wg@grandegger.com>
Cc: "Samuel Ortiz" <sameo@linux.intel.com>,
        "Christian Pellegrin" <chripell@fsfe.org>,
        "David S. Miller" <davem@davemloft.net>, <arjan@linux.intel.com>,
        <socketcan-core@lists.berlios.de>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        "ML linux-kernel" <linux-kernel@vger.kernel.org>, <gregkh@suse.de>,
        "ML netdev" <netdev@vger.kernel.org>, "Qi" <qi.wang@intel.com>,
        "Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>,
        "Morinaga" <morinaga526@dsn.okisemi.com>
References: <4C61EDE5.4030505@dsn.okisemi.com>	<4C62981B.8050402@grandegger.com>	<D5AB6E638E5A3E4B8F4406B113A5A19A28EA26CC@shsmsx501.ccr.corp.intel.com>	<4C63B6C9.5050804@grandegger.com>	<D5AB6E638E5A3E4B8F4406B113A5A19A28EA29DF@shsmsx501.ccr.corp.intel.com> <000501cb49a9$9cd4bf00$66f8800a@maildom.okisemi.com> <4C7EA0CC.2030609@grandegger.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_CAN driver to 2.6.35
Date: Thu, 2 Sep 2010 12:19:45 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----- 
From: "Wolfgang Grandegger" <wg@grandegger.com>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: "Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>; "Qi" <qi.wang@intel.com>; "ML netdev"
<netdev@vger.kernel.org>; <gregkh@suse.de>; "ML linux-kernel" <linux-kernel@vger.kernel.org>; "Wang, Yong Y"
<yong.y.wang@intel.com>; <socketcan-core@lists.berlios.de>; <arjan@linux.intel.com>; "David S. Miller"
<davem@davemloft.net>; "Christian Pellegrin" <chripell@fsfe.org>; "Samuel Ortiz" <sameo@linux.intel.com>
Sent: Thursday, September 02, 2010 3:51 AM
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_CAN driver to 2.6.35

> ...
> >>>>> - The values for the hw-specific bit-timing registers should be derived
> >>>>>   from the calculated values in "priv->can.bittiming":
> >>>>>
> >>>>>   http://lxr.linux.no/#linux+v2.6.35/include/linux/can/netlink.h#L17
> >>>>>
> >
> > I show current pch_can code below.
> >
> > +static int pch_set_bittiming(struct net_device *ndev)
> > +{
> > + struct pch_can_priv *priv = netdev_priv(ndev);
> > + struct pch_can_os *dev_can_os = priv->pch_can_os_p;
> > + const struct can_bittiming *bt = &priv->can.bittiming;
> >
> > Is the above TRUE, isn't it ?
>
> The code fragment looks good. In that function you should then *derive*
> the values of the bit-timing registers from the data fields of "bt". For
> the SJA1000, you find the code here:
>
> http://lxr.linux.no/#linux+v2.6.35/drivers/net/can/sja1000/sja1000.c#L202
>

I can't understand the your saying.
I think our can driver is implemented like your saying.

In function "pch_set_bittiming", get the value of the bit-timing registers from
the data fields of "bt" at "pch_can_set_baud_custom" or "pch_can_set_baud_simple".

Could you indicate in more detail ?


> >>>>> - The driver should handle state changes and communicate them to the
> >>>>>   user space via error messages, if possible.
> >>>>>
> > What's "state chage" mean ?
>
> Googling for "can bis states" returned:
>
>
http://www.softing.com/home/en/industrial-automation/products/can-bus/more-can-bus/error-handling/error-states.php?navanchor=3010510
>
> The CAN controller usually triggers an interrupt when the state changes,
> which allows the driver to track the CAN state and deliver that
> information to the user space.

I could understand your saying.
In our current code, our driver can detect state change, but doesn't notify to
can-core module or kennel protocol stack.
We will modify our driver to notify to these.

>
> >>>>> - The driver should report errors to the user space via error messages.
> >>>>>
> > Is the above mean using alloc_can_err_skb and set error info and notify to kernel with netif_rx ?
>
> Yes. Please search "Documentation/networking/can.txt" for "error frames"
> for further information.

I understand.
We will modify.

>
> >>>>> - Bus errors seem not to be handled properly.I'm missing can_bus_off().
> >>>>>   Does the controller recover from bus-off automatically?
> > No.
> > CAN driver recovers from Bus-off state.
>
> You mean: "It does *not" recover automatically"! Right?

I meant like below.
CAN-HW itself can't recover from bus-off state automatically.
Cooperate with CAN driver, CAN HW can do automatically.

>
> >
> >>>>>
> >>>>> - I see that the driver uses many TX and RX objects. How do you avoid
> >>>>>   out-of-order transmission and reception?
> >>>> What do you mean out-of-order RX and TX?
> >>>> Atom processor only supports in-order execution, and PCIe-based peripherals
> >>> can solve it with consumer-producer model. Actually IC designer will take care
> >>> of out-of-order PCIe CPLD transaction.
> >>>
> >>> I mean out-of-order transmission to or from the CAN bus. This is handled
> >>> by the CAN controller hardware. It has nothing to to with the processor.
> > Cannot avoid occurring rx or tx our-of-order.
>
> It is a *requirement* as Oliver already pointed out. It's easy to
> achieve if just one TX object is used but it might be tricky with more
> than one.

I agree with your indication.
We will modify so that our CAN driver has only one tx/rx each object.

Thanks, Ohtake(OKISemi)


