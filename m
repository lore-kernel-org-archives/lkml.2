Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab0JDSJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:09:58 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41928 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab0JDSJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 14:09:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MFvUUM44A0Ukoo03cXtg4bGo3gtGAJ8eKTFnp8afU51KWw9AlfQFdOogzuFad8nf3E
         ZETu1aiqDL+c2vWlrLVAchaJQuU3yxshiHkduGXw3/DFwzpWwT06Q4luh6y1YrOAcA/I
         RXql6TO/Qm4xeC44yUIi1DUJoXlh5zTNRpWzY=
Subject: Re: [PATCH] AF_UNIX: Implement SO_TIMESTAMP and SO_TIMETAMPNS on
 Unix sockets
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alban Crequy <alban.crequy@collabora.co.uk>
Cc: Lennart Poettering <lennart@poettering.net>,
        "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <1286215294-29166-1-git-send-email-alban.crequy@collabora.co.uk>
References: <20101004190049.783f14ab@chocolatine.cbg.collabora.co.uk>
	 <1286215294-29166-1-git-send-email-alban.crequy@collabora.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 20:09:49 +0200
Message-ID: <1286215789.2381.2.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 04 octobre 2010 à 19:01 +0100, Alban Crequy a écrit :
> Userspace applications can already request to receive timestamps with:
> setsockopt(sockfd, SOL_SOCKET, SO_TIMESTAMP, ...)
> 
> Although setsockopt() returns zero (success), timestamps are not added to the
> ancillary data. This patch fixes that on SOCK_DGRAM and SOCK_SEQPACKET Unix
> sockets.
> 
> Signed-off-by: Alban Crequy <alban.crequy@collabora.co.uk>
> ---
>  net/unix/af_unix.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 617bea4..bca0c1e 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -1697,6 +1697,9 @@ static int unix_dgram_recvmsg(struct kiocb *iocb, struct socket *sock,
>  	if (err)
>  		goto out_free;
>  
> +	if (sock_flag(sk, SOCK_RCVTSTAMP))
> +		__sock_recv_timestamp(msg, sk, skb);
> +
>  	if (!siocb->scm) {
>  		siocb->scm = &tmp_scm;
>  		memset(&tmp_scm, 0, sizeof(tmp_scm));

Hmm, but how is set skb->tstamp ?

I think its zero at this point, so __sock_recv_timestamp() use current
time, not time of send().

gettimeofday() might be better/cheaper :)



