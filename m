Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab0JDQmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 12:42:01 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58184 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab0JDQl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 12:41:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Oln7cttS/8TfuZNaQ7+8eYD31PCXje4Yg60F7x3DdhY4ByWqzPOaqsLGx1LRPwU93o
         DhHvoX/8mJ+8lBCc5mFq94STCgli0KFbqfBucAsfe8tbiBGK7yBPleo5Ul3fziiAR8qr
         hMTivlKdT3NEL8VeHsak+Q8ifNWgN9MMY0g/M=
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
In-Reply-To: <1286206706-25733-1-git-send-email-alban.crequy@collabora.co.uk>
References: <1286206706-25733-1-git-send-email-alban.crequy@collabora.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 18:41:44 +0200
Message-ID: <1286210504.18293.370.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 04 octobre 2010 à 16:38 +0100, Alban Crequy a écrit :
> Userspace applications can already request to receive timestamps with:
> setsockopt(sockfd, SOL_SOCKET, SO_TIMESTAMP, ...)
> 
> Although setsockopt() returns zero (success), timestamps are not added to the
> ancillary data. This patch fixes that.
> 
> Signed-off-by: Alban Crequy <alban.crequy@collabora.co.uk>
> ---
>  net/unix/af_unix.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 617bea4..142ccea 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -1697,6 +1697,8 @@ static int unix_dgram_recvmsg(struct kiocb *iocb, struct socket *sock,
>  	if (err)
>  		goto out_free;
>  
> +	sock_recv_timestamp(msg, sk, skb);
> +
>  	if (!siocb->scm) {
>  		siocb->scm = &tmp_scm;
>  		memset(&tmp_scm, 0, sizeof(tmp_scm));
> @@ -1877,6 +1879,8 @@ static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
>  		copied += chunk;
>  		size -= chunk;
>  
> +		sock_recv_timestamp(msg, sk, skb);
> +
>  		/* Mark read part of skb as used */
>  		if (!(flags & MSG_PEEK)) {
>  			skb_pull(skb, chunk);

Are you sure its needed for unix_stream case ?

We dont do this for TCP for example, only for datagrams.

As shown in the past, sock_recv_timestamp() is a bit expensive because
it takes care of many possible options.

It would be better to use in AF_UNIX case (only software timestamps) :

Solution 1) 
if (sock_flag(sk, SOCK_RCVTSTAMP))
	__sock_recv_timestamp(msg, sk, skb);

Solution 2) 
Or something already used elsewhere since 2.6.35 and commit
767dd03369ac1 (net: speedup sock_recv_ts_and_drops()) :

sock_recv_ts_and_drops(msg, sk, skb);


I would vote for the 1) solution


