Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab0ICNcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 09:32:31 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:41248 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752773Ab0ICNca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 09:32:30 -0400
Message-ID: <000e01cb4b6c$73b4c8d0$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Stephen Hemminger" <shemminger@vyatta.com>,
        "Eric Dumazet" <eric.dumazet@gmail.com>
Cc: "Sam Ravnborg" <sam@ravnborg.org>, "Joe Perches" <joe@perches.com>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "ML netdev" <netdev@vger.kernel.org>,
        "Greg Rose" <gregory.v.rose@intel.com>,
        "Maxime Bizon" <mbizon@freebox.fr>,
        "Kristoffer Glembo" <kristoffer@gaisler.com>,
        "Ralf Baechle" <ralf@linux-mips.org>,
        "John Linn" <john.linn@xilinx.com>,
        "Randy Dunlap" <randy.dunlap@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, "MeeGo" <meego-dev@meego.com>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Andrew" <andrew.chih.howe.khor@intel.com>,
        "Intel OTC" <joel.clark@intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        "Toshiharu Okada" <okada533@dsn.okisemi.com>,
        "Tomoya Morinaga" <morinaga526@dsn.okisemi.com>,
        "Takahiro Shimizu" <shimizu394@dsn.okisemi.com>
References: <4C763A67.5040107@dsn.okisemi.com><4C7D0E7A.5060309@dsn.okisemi.com><1283266263.2550.106.camel@edumazet-laptop><000a01cb4a9b$e8d6ab00$66f8800a@maildom.okisemi.com><1283434847.2454.726.camel@edumazet-laptop> <20100902081007.2f910bc0@nehalam>
Subject: Re: [PATCH] Gigabit Ethernet driver of Topcliff PCH
Date: Fri, 3 Sep 2010 22:32:19 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric and Stephen

Thank you for your suggestion.

I tried modification of "dev->hard_header_len".
However, there was no changed to a format of SKB received by kernel.
  [Header:14octet] + [payload]

So, I can not a single memcpy.


>Something like:
>       skb = skb_realloc_headroom(skb, 2);
>       if (!skb)
>           goto drop;
>__skb_push(skb, 2);
>        memmove(skb->data, skb->data + 2, ETH_HLEN);
>
>skb->data[ETH_HLEN] = 0;
>skb->data[ETH_HLEN+1] = 0;
>
>        if (!IS_ALIGNED(skb->data, 16)) {
>    nskb = netdev_alloc_skb(dev, skb->len + 16);
>    if (!nskb)
>                goto drop2;
>            skb_reserve(nskb, PTR_ALIGN(skb->data, 16) - skb->data);
>    skb_put(skb, skb->len);
>            memcpy(nskb->data, skb->data, skb->len);
>    dev_kfree_skb(skb);
>            skb = nskb;
>        }

I am going to try modification using "memmove()" and "IS_ALIGNED()".

Thanks, Ohtake(OKISemi)
----- Original Message ----- 
From: "Stephen Hemminger" <shemminger@vyatta.com>
To: "Eric Dumazet" <eric.dumazet@gmail.com>
Cc: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>; "Sam Ravnborg" <sam@ravnborg.org>; "Joe Perches" <joe@perches.com>;
"LKML" <linux-kernel@vger.kernel.org>; "ML netdev" <netdev@vger.kernel.org>; "Greg Rose" <gregory.v.rose@intel.com>;
"Maxime Bizon" <mbizon@freebox.fr>; "Kristoffer Glembo" <kristoffer@gaisler.com>; "Ralf Baechle" <ralf@linux-mips.org>;
"John Linn" <john.linn@xilinx.com>; "Randy Dunlap" <randy.dunlap@oracle.com>; "David S. Miller" <davem@davemloft.net>;
"MeeGo" <meego-dev@meego.com>; "Wang, Qi" <qi.wang@intel.com>; "Wang, Yong Y" <yong.y.wang@intel.com>; "Andrew"
<andrew.chih.howe.khor@intel.com>; "Intel OTC" <joel.clark@intel.com>; "Foster, Margie" <margie.foster@intel.com>;
"Toshiharu Okada" <okada533@dsn.okisemi.com>; "Tomoya Morinaga" <morinaga526@dsn.okisemi.com>; "Takahiro Shimizu"
<shimizu394@dsn.okisemi.com>
Sent: Friday, September 03, 2010 12:10 AM
Subject: Re: [PATCH] Gigabit Ethernet driver of Topcliff PCH


On Thu, 02 Sep 2010 15:40:47 +0200
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Le jeudi 02 septembre 2010 à 21:39 +0900, Masayuki Ohtake a écrit :
> > Hi Eric
> >
> > Thank you for your comments.
> >
> > > I find hard to believe this driver needs to copy all outgoing frames on
> > > pre-allocated skbs.
> > >
> > > +       /* [Header:14][payload] ---> [Header:14][paddong:2][payload]    */
> > > +       memcpy(tmp_skb->data, skb->data, ETH_HLEN);
> > > +       tmp_skb->data[ETH_HLEN] = 0x00;
> > > +       tmp_skb->data[ETH_HLEN + 1] = 0x00;
> > > +       tmp_skb->len = skb->len;
> > > +       memcpy(&tmp_skb->data[ETH_HLEN + 2], &skb->data[ETH_HLEN],
> > > +              (skb->len - ETH_HLEN));
> > > +       buffer_info->kernel_skb = skb;
> > > +       skb = tmp_skb;
> > >
> > > Whats the deal here please ?
> >
> > This processing depends on hardware specification.
> >
> > At the time of transmission.
> > Hardware accepts a packet in the following format.
> >   [Header: 14octet] + [padding: 2octet] + [payload]
> >   Also, it is necessary to align the head of a [Header: 14octet] at 64byte.
> >
> > In my knowledge, SKB received by kernel are the following format.
> >   [padding: 2octet] + [Header:14octet] + [payload]
> >   Also, The head of [payload] has aligned at 16 byte.
> >
> > So, it has adjusted with the format of hardware by a copy.
>
> The two bytes padding can be handled by network stack, if you
> force in your setup phase :
> dev->hard_header_len = ETH_HLEN + 2;
>
> then, you can do a single memcpy:
>
> memcpy(tmp_skb->data, skb->data, skb->len);
>
> About the 64 byte alignement, it might be a bit more complex :)

With Eric's suggestion, you might find most packets are going
to be aligned but the code should not depend on it always being true.
Packets that get forwarded have header determined by the receiving
interface.

Something like:
       skb = skb_realloc_headroom(skb, 2);
       if (!skb)
           goto drop;
__skb_push(skb, 2);
        memmove(skb->data, skb->data + 2, ETH_HLEN);

skb->data[ETH_HLEN] = 0;
skb->data[ETH_HLEN+1] = 0;

        if (!IS_ALIGNED(skb->data, 16)) {
    nskb = netdev_alloc_skb(dev, skb->len + 16);
    if (!nskb)
                goto drop2;
            skb_reserve(nskb, PTR_ALIGN(skb->data, 16) - skb->data);
    skb_put(skb, skb->len);
            memcpy(nskb->data, skb->data, skb->len);
    dev_kfree_skb(skb);
            skb = nskb;
        }




-- 


