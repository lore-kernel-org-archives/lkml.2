Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933573Ab1KBTQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 15:16:27 -0400
Received: from peace.netnation.com ([204.174.223.2]:49046 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab1KBTQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 15:16:24 -0400
Date: Wed, 2 Nov 2011 12:16:21 -0700
From: Simon Kirby <sim@hostway.ca>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, David Miller <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: Linux 3.1-rc9
Message-ID: <20111102191621.GF5971@hostway.ca>
References: <1318928713.21167.4.camel@twins> <20111018182046.GF1309@hostway.ca> <alpine.LFD.2.02.1110182146440.3240@ionos> <20111024190203.GA24410@hostway.ca> <20111025202049.GB25043@hostway.ca> <20111031173246.GA10614@hostway.ca> <alpine.LFD.2.02.1111021725550.2829@ionos> <1320254854.2292.14.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <1320256157.2292.15.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <1320256701.2292.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320256701.2292.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 06:58:21PM +0100, Eric Dumazet wrote:

> Le mercredi 02 novembre 2011 ?? 18:49 +0100, Eric Dumazet a ??crit :
> > Le mercredi 02 novembre 2011 ?? 18:27 +0100, Eric Dumazet a ??crit :
> > 
> > > I believe it might come from commit 0e734419
> > > (ipv4: Use inet_csk_route_child_sock() in DCCP and TCP.)
> > > 
> > > In case inet_csk_route_child_sock() returns NULL, we dont release socket
> > > lock.
> > > 
> > > 
> > 
> > Yes, thats the problem. I am testing following patch :
> > 
> > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > index 0ea10ee..683d97a 100644
> > --- a/net/ipv4/tcp_ipv4.c
> > +++ b/net/ipv4/tcp_ipv4.c
> > @@ -1510,6 +1510,7 @@ exit:
> >  	NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_LISTENDROPS);
> >  	return NULL;
> >  put_and_exit:
> > +	bh_unlock_sock(newsk);
> >  	sock_put(newsk);
> >  	goto exit;
> >  }
> > 
> 
> 
> This indeed solves the problem, but more closer inspection is needed to
> close all bugs, not this only one.
> 
> # netstat -s
> Ip:
>     6961157 total packets received
>     0 forwarded
>     0 incoming packets discarded
>     6961157 incoming packets delivered
>     6961049 requests sent out
>     2 dropped because of missing route    //// HERE, this is the origin

Actually, we have an anti-abuse daemon that injects blackhole routes, so
this makes sense. (The daemon was written before ipsets were merged and
normal netfilter rules make it fall over under attack.)

I'll try with this patch. Thanks!

Simon-
