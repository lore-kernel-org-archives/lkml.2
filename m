Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab0KKJ4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 04:56:31 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:13082 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660Ab0KKJ43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 04:56:29 -0500
Message-ID: <002501cb8186$b56a6280$66f8800a@maildom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Marc Kleine-Budde" <mkl@pengutronix.de>
Cc: "Wolfgang Grandegger" <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Wolfram Sang" <w.sang@pengutronix.de>,
        "Christian Pellegrin" <chripell@fsfe.org>,
        "Barry Song" <21cnbao@gmail.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        <socketcan-core@lists.berlios.de>, <netdev@vger.kernel.org>,
        "LKML" <linux-kernel@vger.kernel.org>,
        <andrew.chih.howe.khor@intel.com>, <qi.wang@intel.com>,
        <margie.foster@intel.com>, <yong.y.wang@intel.com>,
        "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>,
        <kok.howg.ewe@intel.com>, <joel.clark@intel.com>
References: <005301cb7ffa$5b63cd90$66f8800a@maildom.okisemi.com> <00fe01cb8009$62e11410$66f8800a@maildom.okisemi.com> <4CD945B4.4060408@pengutronix.de>
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Fix build warnings
Date: Thu, 11 Nov 2010 18:56:24 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 09, 2010 9:59 PM, Marc Kleine-Budde wrote :

> 
> On 11/09/2010 01:26 PM, Tomoya MORINAGA wrote:
> >>>> Can you please explain me your locking sheme? If I understand the
> >>>> documenation correctly the two message interfaces can be used mutual.
> >>>> And you use one for rx the other one for tx.
> >>>
> >>> I show our locking scheme.
> >>> When CPU accesses MessageRAM via IF1, CPU protect until read-modify-write
> >>> so that IF2 access not occurred, vice versa.
> >>
> >> Why is that needed?
> >
> > For MessageRAM data consistency.
> 
> As far as I understand the datasheet the access to IF1 and IF2 is
> completely independent. Why do you lock here?

You are right.
Each IF1 and IF2 is completely independent.
All message objects can be accessed via both IF1 and IF2.
There is a possibility that a message object is accessed by IF1 and IF2 simultaneously.
But this driver separates message object by Tx/Rx completely.(Rx:1~26, Tx:27~32)
Thus, these locks are unnecessary.
I will delete these.

> 
> [...]
> 
> >>>> Please use just "debug" level not warning here. Consider to use
> >>>> netdev_dbg() instead. IMHO the __func__ can be dropped and the
> >>>> "official" name for the error is "Error Warning".
> >>>
> >>> I want to know the reason.
> >>> Why is it not dev_warn but netdev_dbg ?
> >>
> >> If you use warning level it would end up on the console or and in the
> >> syslog. It's quite complicated (for programs) to get information from
> >> there. This is why we send CAN error frames. They hold the same
> >> information but int a binary form, thus it's easier to process.
> >
> > I understand the reason.
> > BTW, Why do you say not dev_dbg but netdev_dbg ?
> 
> Sorry - netdev_dbg() is easier to use, its first argument is the
> netdevice, while dev_dbg needs a device and that's deeply hidden in the
> netdevice.
> 

I understand.


> [...]
> 
> >>>>> +static netdev_tx_t pch_xmit(struct sk_buff *skb, struct net_device *ndev)
> >>>>> +{
> >>>>> + unsigned long flags;
> >>>>> + struct pch_can_priv *priv = netdev_priv(ndev);
> >>>>> + struct can_frame *cf = (struct can_frame *)skb->data;
> >>>>> + int tx_buffer_avail = 0;
> >>>>
> >>>> What I'm totally missing is the TX flow controll. Your driver has to
> >>>> ensure that the package leave the controller in the order that come
> >>>> into the xmit function. Further you have to stop your xmit queue if
> >>>> you're out of tx objects and reenable if you have a object free.
> >>>>
> >>>> Use netif_stop_queue() and netif_wake_queue() for this.
> >>>
> >>> In this code, I think "out of tx objects" cannot be  occurred.
> >>
> >> It's not a matter of code it's the hardware. You cannot put more than a
> >> certain number of CAN frames into the hardware. If you have a CAN bus at
> >> a certain speed, you can only send a certain number of CAN frames in a
> >> second. So you cannot push more than this amount of frames/s into the
> >> hardware.
> >>
> >>> Nevertheless, are netif_stop_queue() and netif_wake_queue() is necessary ?
> >>
> >> Yes.
> >
> > I can' understand your issue.
> > Please can you hear my opinion?
> >
> > Please see the head of pch_xmit.
> >
> >>> + if (priv->tx_obj == (PCH_OBJ_NUM + 1)) { /* Point tail Obj + 1 */
> >>> +  while (ioread32(&priv->regs->treq2) & 0xfc00)
> >>> +   udelay(1);
> >
> > When points tail of Tx message object,
> > this driver waits until completion of all tx messaeg objects.
> 
> Looping busy it not an option here.
> 
> > Thus, application/driver ought not to be able to put Tx object exceed the number of tx message object.
> > Thus I think these code(netif_stop_queue/netif_wake_queue) are completely redundant.
> 
> Nope - please remove the waiting completely and convert your flow
> control to netif_stop_queue/netif_wake_queue.
> 

I see.
I will remove like above.

BTW, Let me know the reason.
Could you explain the reason why you deny looping busy loop ?


Thanks,

Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

