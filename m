Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab0JDSuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:50:06 -0400
Received: from bhuna.collabora.co.uk ([93.93.128.226]:41784 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab0JDSuF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 14:50:05 -0400
Date: Mon, 4 Oct 2010 19:47:34 +0100
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
Message-ID: <20101004194734.6a1caf3e@chocolatine.cbg.collabora.co.uk>
In-Reply-To: <1286215789.2381.2.camel@edumazet-laptop>
References: <20101004190049.783f14ab@chocolatine.cbg.collabora.co.uk>
	<1286215294-29166-1-git-send-email-alban.crequy@collabora.co.uk>
	<1286215789.2381.2.camel@edumazet-laptop>
Organization: Collabora
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.21.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Mon, 04 Oct 2010 20:09:49 +0200,
Eric Dumazet <eric.dumazet@gmail.com> a écrit :

> Le lundi 04 octobre 2010 à 19:01 +0100, Alban Crequy a écrit :
> > Userspace applications can already request to receive timestamps
> > with: setsockopt(sockfd, SOL_SOCKET, SO_TIMESTAMP, ...)
> > 
> > Although setsockopt() returns zero (success), timestamps are not
> > added to the ancillary data. This patch fixes that on SOCK_DGRAM
> > and SOCK_SEQPACKET Unix sockets.
> > 
> > Signed-off-by: Alban Crequy <alban.crequy@collabora.co.uk>
> > ---
> >  net/unix/af_unix.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> > index 617bea4..bca0c1e 100644
> > --- a/net/unix/af_unix.c
> > +++ b/net/unix/af_unix.c
> > @@ -1697,6 +1697,9 @@ static int unix_dgram_recvmsg(struct kiocb
> > *iocb, struct socket *sock, if (err)
> >  		goto out_free;
> >  
> > +	if (sock_flag(sk, SOCK_RCVTSTAMP))
> > +		__sock_recv_timestamp(msg, sk, skb);
> > +
> >  	if (!siocb->scm) {
> >  		siocb->scm = &tmp_scm;
> >  		memset(&tmp_scm, 0, sizeof(tmp_scm));
> 
> Hmm, but how is set skb->tstamp ?
> 
> I think its zero at this point, so __sock_recv_timestamp() use current
> time, not time of send().
> 
> gettimeofday() might be better/cheaper :)

You're right, I just tested it and it was the time of reception. Thanks
for the review.

