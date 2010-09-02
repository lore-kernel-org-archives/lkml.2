Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab0IBNkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 09:40:55 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42940 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab0IBNky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 09:40:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=q4OG8fU/bjRGtmMUvCX4yq0EdWj7fByKzpAmYaAUB8EqJ1ou2/1i87dhWQ5gyLWzYE
         FWYbNCyif9vMfBP3GzOs+gqpnk1onOkcxPVQuZx/P9nKKq4S1tWyoMkv7aRBpVf/IIF2
         Jdp6q6cmki9CLzzWU56+L7HGievLydQ48P5fU=
Subject: Re: [PATCH] Gigabit Ethernet driver of Topcliff PCH
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>, Sam Ravnborg <sam@ravnborg.org>,
        Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
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
In-Reply-To: <000a01cb4a9b$e8d6ab00$66f8800a@maildom.okisemi.com>
References: <4C763A67.5040107@dsn.okisemi.com>
	 <4C7D0E7A.5060309@dsn.okisemi.com>
	 <1283266263.2550.106.camel@edumazet-laptop>
	 <000a01cb4a9b$e8d6ab00$66f8800a@maildom.okisemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Sep 2010 15:40:47 +0200
Message-ID: <1283434847.2454.726.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 02 septembre 2010 à 21:39 +0900, Masayuki Ohtake a écrit :
> Hi Eric
> 
> Thank you for your comments.
> 
> > I find hard to believe this driver needs to copy all outgoing frames on
> > pre-allocated skbs.
> >
> > +       /* [Header:14][payload] ---> [Header:14][paddong:2][payload]    */
> > +       memcpy(tmp_skb->data, skb->data, ETH_HLEN);
> > +       tmp_skb->data[ETH_HLEN] = 0x00;
> > +       tmp_skb->data[ETH_HLEN + 1] = 0x00;
> > +       tmp_skb->len = skb->len;
> > +       memcpy(&tmp_skb->data[ETH_HLEN + 2], &skb->data[ETH_HLEN],
> > +              (skb->len - ETH_HLEN));
> > +       buffer_info->kernel_skb = skb;
> > +       skb = tmp_skb;
> >
> > Whats the deal here please ?
> 
> This processing depends on hardware specification.
> 
> At the time of transmission.
> Hardware accepts a packet in the following format.
>   [Header: 14octet] + [padding: 2octet] + [payload]
>   Also, it is necessary to align the head of a [Header: 14octet] at 64byte.
> 
> In my knowledge, SKB received by kernel are the following format.
>   [padding: 2octet] + [Header:14octet] + [payload]
>   Also, The head of [payload] has aligned at 16 byte.
> 
> So, it has adjusted with the format of hardware by a copy.

The two bytes padding can be handled by network stack, if you
force in your setup phase :
	dev->hard_header_len = ETH_HLEN + 2;

then, you can do a single memcpy:

memcpy(tmp_skb->data, skb->data, skb->len);

About the 64 byte alignement, it might be a bit more complex :)




