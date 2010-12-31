Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab0LaKlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 05:41:14 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62602 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab0LaKlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 05:41:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CCZgnCFRx568B4qFm/zNe4A2/ZHSjr8QQUQvu8cFV8x2cemT6HREsH+GO0MJyvRNNQ
         MJxmgxoWzsQonVClISWmMBs7j1Q91TCvGCDm9ySceTGME+EvoD864AaPaC90+WmJfVyc
         AIPe/6CknmlaGUQOiZfCFkLJduRhBusBY8rz4=
Subject: Re: [PATCH] UDPCP Communication Protocol
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, netdev@vger.kernel.org
In-Reply-To: <1293790979.4787.10.camel@wall-e>
References: <1293787785-3834-1-git-send-email-stefani@seibold.net>
	 <1293789629.2973.26.camel@edumazet-laptop>
	 <1293790979.4787.10.camel@wall-e>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 31 Dec 2010 11:41:06 +0100
Message-ID: <1293792066.2973.43.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 31 décembre 2010 à 11:22 +0100, Stefani Seibold a écrit :
> Am Freitag, den 31.12.2010, 11:00 +0100 schrieb Eric Dumazet:
> > Le vendredi 31 décembre 2010 à 10:29 +0100, stefani@seibold.net a
> > écrit :
> > > From: Stefani Seibold <stefani@seibold.net>
> > > 
> > >  
> > >  /*
> > >   *	Handle MSG_ERRQUEUE
> > > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > > index 2d3ded4..f9890a2 100644
> > > --- a/net/ipv4/udp.c
> > > +++ b/net/ipv4/udp.c
> > > @@ -1310,7 +1310,7 @@ static int __udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
> > >  	if (inet_sk(sk)->inet_daddr)
> > >  		sock_rps_save_rxhash(sk, skb->rxhash);
> > >  
> > > -	rc = ip_queue_rcv_skb(sk, skb);
> > > +	rc = sock_queue_rcv_skb(sk, skb);
> > 
> > Ouch... Care to explain why you changed this part ???
> > 
> > You just destroyed commit f84af32cbca70a intent, without any word in
> > your changelog. Making UDP slower, while others try to speed it must be
> > explained and advertised.
> >  
> > In general, we prefer a preliminary patch introducing all the changes in
> > current stack, then another one with the new protocol.
> > 
> 
> I reverted this for two reasons:
> 
> First ip_queue_rcv_skb drops the dst entry, which breaks the user land
> application which expect packet info after a
> 
> setsockopt(handle, IPPROTO_IP, IP_PKTINFO, &const_int_1, sizeof(int));
> 
> But for packets already in the queue this information will be lost. So
> it is a potential race condition.
> 

Exactly same race with packet filters. 

If your life depends on that, you must flush incoming queue _after_
issuing setsockopt(handle, IPPROTO_IP, IP_PKTINFO, &const_int_1,
sizeof(int)). So that all following packets have the information needed.



> Second it breaks my UDPCP communication protocol stack module, which
> works very well till 2.6.35. I need this information in the data_ready()
> function to generate an ACK.
> 
> 

See now why you should not proceed like that ?

You know _perfectly_ there is a problem but prefer to keep it for you,
and hope this bit will be unnoticed ?

This is not how things are dealed in linux, really.

You'll have to find a way so that things work well for everybody, not
only for you.

I guess you must fix UDPCP protocol stack, not 'fix linux'



