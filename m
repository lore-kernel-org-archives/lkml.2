Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab0IBPKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:10:13 -0400
Received: from mail.vyatta.com ([76.74.103.46]:50977 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab0IBPKL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:10:11 -0400
Date: Thu, 2 Sep 2010 08:10:07 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Masayuki Ohtake <masa-korg@dsn.okisemi.com>,
        Sam Ravnborg <sam@ravnborg.org>, Joe Perches <joe@perches.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ML netdev <netdev@vger.kernel.org>,
        Greg Rose <gregory.v.rose@intel.com>, Maxime Bizon <mbizon@freebox.fr>,
        Kristoffer Glembo <kristoffer@gaisler.com>,
        Ralf Baechle <ralf@linux-mips.org>, John Linn <john.linn@xilinx.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, MeeGo <meego-dev@meego.com>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        Andrew <andrew.chih.howe.khor@intel.com>,
        Intel OTC <joel.clark@intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        Toshiharu Okada <okada533@dsn.okisemi.com>,
        Tomoya Morinaga <morinaga526@dsn.okisemi.com>,
        Takahiro Shimizu <shimizu394@dsn.okisemi.com>
Subject: Re: [PATCH] Gigabit Ethernet driver of Topcliff PCH
Message-ID: <20100902081007.2f910bc0@nehalam>
In-Reply-To: <1283434847.2454.726.camel@edumazet-laptop>
References: <4C763A67.5040107@dsn.okisemi.com>
	<4C7D0E7A.5060309@dsn.okisemi.com>
	<1283266263.2550.106.camel@edumazet-laptop>
	<000a01cb4a9b$e8d6ab00$66f8800a@maildom.okisemi.com>
	<1283434847.2454.726.camel@edumazet-laptop>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> 	dev->hard_header_len = ETH_HLEN + 2;
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
