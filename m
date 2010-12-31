Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab0LaKWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 05:22:00 -0500
Received: from www84.your-server.de ([213.133.104.84]:51829 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab0LaKV6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 05:21:58 -0500
Subject: Re: [PATCH] UDPCP Communication Protocol
From: Stefani Seibold <stefani@seibold.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, netdev@vger.kernel.org
In-Reply-To: <1293789629.2973.26.camel@edumazet-laptop>
References: <1293787785-3834-1-git-send-email-stefani@seibold.net>
	 <1293789629.2973.26.camel@edumazet-laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 31 Dec 2010 11:22:59 +0100
Message-ID: <1293790979.4787.10.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 8BIT
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 31.12.2010, 11:00 +0100 schrieb Eric Dumazet:
> Le vendredi 31 décembre 2010 à 10:29 +0100, stefani@seibold.net a
> écrit :
> > From: Stefani Seibold <stefani@seibold.net>
> > 
> >  
> >  /*
> >   *	Handle MSG_ERRQUEUE
> > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > index 2d3ded4..f9890a2 100644
> > --- a/net/ipv4/udp.c
> > +++ b/net/ipv4/udp.c
> > @@ -1310,7 +1310,7 @@ static int __udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
> >  	if (inet_sk(sk)->inet_daddr)
> >  		sock_rps_save_rxhash(sk, skb->rxhash);
> >  
> > -	rc = ip_queue_rcv_skb(sk, skb);
> > +	rc = sock_queue_rcv_skb(sk, skb);
> 
> Ouch... Care to explain why you changed this part ???
> 
> You just destroyed commit f84af32cbca70a intent, without any word in
> your changelog. Making UDP slower, while others try to speed it must be
> explained and advertised.
>  
> In general, we prefer a preliminary patch introducing all the changes in
> current stack, then another one with the new protocol.
> 

I reverted this for two reasons:

First ip_queue_rcv_skb drops the dst entry, which breaks the user land
application which expect packet info after a

setsockopt(handle, IPPROTO_IP, IP_PKTINFO, &const_int_1, sizeof(int));

But for packets already in the queue this information will be lost. So
it is a potential race condition.

Second it breaks my UDPCP communication protocol stack module, which
works very well till 2.6.35. I need this information in the data_ready()
function to generate an ACK.


