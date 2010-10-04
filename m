Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab0JDSDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:03:21 -0400
Received: from bhuna.collabora.co.uk ([93.93.128.226]:43821 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab0JDSDT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 14:03:19 -0400
Date: Mon, 4 Oct 2010 19:00:49 +0100
From: Alban Crequy <alban.crequy@collabora.co.uk>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Lennart Poettering <lennart@poettering.net>,
        "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Alban Crequy <alban.crequy@collabora.co.uk>
Subject: Re: [PATCH] AF_UNIX: Implement SO_TIMESTAMP and SO_TIMETAMPNS on 
 Unix sockets
Message-ID: <20101004190049.783f14ab@chocolatine.cbg.collabora.co.uk>
In-Reply-To: <1286210504.18293.370.camel@edumazet-laptop>
References: <1286206706-25733-1-git-send-email-alban.crequy@collabora.co.uk>
	<1286210504.18293.370.camel@edumazet-laptop>
Organization: Collabora
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.21.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Mon, 04 Oct 2010 18:41:44 +0200,
Eric Dumazet <eric.dumazet@gmail.com> a écrit :

> Le lundi 04 octobre 2010 à 16:38 +0100, Alban Crequy a écrit :
> > Userspace applications can already request to receive timestamps
> > with: setsockopt(sockfd, SOL_SOCKET, SO_TIMESTAMP, ...)
> > 
> > Although setsockopt() returns zero (success), timestamps are not
> > added to the ancillary data. This patch fixes that.
> > 
> > Signed-off-by: Alban Crequy <alban.crequy@collabora.co.uk>
> > ---
> >  net/unix/af_unix.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> > index 617bea4..142ccea 100644
> > --- a/net/unix/af_unix.c
> > +++ b/net/unix/af_unix.c
> > @@ -1697,6 +1697,8 @@ static int unix_dgram_recvmsg(struct kiocb
> > *iocb, struct socket *sock, if (err)
> >  		goto out_free;
> >  
> > +	sock_recv_timestamp(msg, sk, skb);
> > +
> >  	if (!siocb->scm) {
> >  		siocb->scm = &tmp_scm;
> >  		memset(&tmp_scm, 0, sizeof(tmp_scm));
> > @@ -1877,6 +1879,8 @@ static int unix_stream_recvmsg(struct kiocb
> > *iocb, struct socket *sock, copied += chunk;
> >  		size -= chunk;
> >  
> > +		sock_recv_timestamp(msg, sk, skb);
> > +
> >  		/* Mark read part of skb as used */
> >  		if (!(flags & MSG_PEEK)) {
> >  			skb_pull(skb, chunk);
> 
> Are you sure its needed for unix_stream case ?

I was about to say it does not cost anything to add it...

> We dont do this for TCP for example, only for datagrams.
> 
> As shown in the past, sock_recv_timestamp() is a bit expensive because
> it takes care of many possible options.

Is it really expensive? It looks like a few flag checks in an inline
function to me.

> It would be better to use in AF_UNIX case (only software timestamps) :
> 
> Solution 1) 
> if (sock_flag(sk, SOCK_RCVTSTAMP))
> 	__sock_recv_timestamp(msg, sk, skb);
> 
> Solution 2) 
> Or something already used elsewhere since 2.6.35 and commit
> 767dd03369ac1 (net: speedup sock_recv_ts_and_drops()) :
> 
> sock_recv_ts_and_drops(msg, sk, skb);
> 
> 
> I would vote for the 1) solution

The patch in the next email implements the 1) solution on SOCK_DGRAM and
SOCK_SEQPACKET (without SOCK_STREAM).

-- 
Alban
