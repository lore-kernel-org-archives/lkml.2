Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108Ab1KBR61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 13:58:27 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35274 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097Ab1KBR6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 13:58:25 -0400
Message-ID: <1320256701.2292.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: Linux 3.1-rc9
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Simon Kirby <sim@hostway.ca>, David Miller <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Network Development <netdev@vger.kernel.org>
Date: Wed, 02 Nov 2011 18:58:21 +0100
In-Reply-To: <1320256157.2292.15.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1318874090.4172.84.camel@twins>
	 <CA+55aFwCBy=4YK6amE=H-BYu9-boj4Po2Zkgf4V261mCx0DC4A@mail.gmail.com>
	 <1318879396.4172.92.camel@twins> <alpine.LFD.2.02.1110172237030.3240@ionos>
	 <alpine.LFD.2.02.1110181037120.3240@ionos> <1318928713.21167.4.camel@twins>
	 <20111018182046.GF1309@hostway.ca>
	 <alpine.LFD.2.02.1110182146440.3240@ionos>
	 <20111024190203.GA24410@hostway.ca> <20111025202049.GB25043@hostway.ca>
	 <20111031173246.GA10614@hostway.ca>
	 <alpine.LFD.2.02.1111021725550.2829@ionos>
	 <1320254854.2292.14.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1320256157.2292.15.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 02 novembre 2011 à 18:49 +0100, Eric Dumazet a écrit :
> Le mercredi 02 novembre 2011 à 18:27 +0100, Eric Dumazet a écrit :
> 
> > I believe it might come from commit 0e734419
> > (ipv4: Use inet_csk_route_child_sock() in DCCP and TCP.)
> > 
> > In case inet_csk_route_child_sock() returns NULL, we dont release socket
> > lock.
> > 
> > 
> 
> Yes, thats the problem. I am testing following patch :
> 
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 0ea10ee..683d97a 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -1510,6 +1510,7 @@ exit:
>  	NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_LISTENDROPS);
>  	return NULL;
>  put_and_exit:
> +	bh_unlock_sock(newsk);
>  	sock_put(newsk);
>  	goto exit;
>  }
> 


This indeed solves the problem, but more closer inspection is needed to
close all bugs, not this only one.

# netstat -s
Ip:
    6961157 total packets received
    0 forwarded
    0 incoming packets discarded
    6961157 incoming packets delivered
    6961049 requests sent out
    2 dropped because of missing route    //// HERE, this is the origin



