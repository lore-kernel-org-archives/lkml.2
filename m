Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab0CZWoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 18:44:38 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:60991 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab0CZWoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 18:44:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mmTuPOxewxGo9L6fQgu/5/PIss9HfolGwehNmUPynW3xD5DdglGmiN0TkWydmxNwu4
         T0xtQ2tlqAF758aF4yDFbcSzoONu1uLV1pr8JmzQLl6iuLynWRxi363fZu5myhMKbau4
         pMcdO/YW9HVCHnEbnEYtO5kr+ln4/7fozEF9Y=
Subject: Re: [PATCH] Add MSG_WAITFORONE flag to recvmmsg
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Brandon L Black <blblack@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Ulrich Drepper <drepper@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100326223530.GA11817@xpc.home>
References: <20100326223530.GA11817@xpc.home>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Mar 2010 23:44:30 +0100
Message-ID: <1269643470.2256.17.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 26 mars 2010 à 17:35 -0500, Brandon L Black a écrit :
> From: Brandon L Black <blblack@gmail.com>
> 
> Add new flag MSG_WAITFORONE for the recvmmsg() syscall.
> When this flag is specified for a blocking socket, recvmmsg()
> will only block until at least 1 packet is available.  The
> default behavior is to block until all vlen packets are
> available.  This flag has no effect on non-blocking sockets
> or when used in combination with MSG_DONTWAIT.
> 
> Signed-off-by: Brandon L Black <blblack@gmail.com>


> 
> ---
> diff --git a/include/linux/socket.h b/include/linux/socket.h
> index 7b3aae2..354cc56 100644
> --- a/include/linux/socket.h
> +++ b/include/linux/socket.h
> @@ -255,6 +255,7 @@ struct ucred {
>  #define MSG_ERRQUEUE	0x2000	/* Fetch message from error queue */
>  #define MSG_NOSIGNAL	0x4000	/* Do not generate SIGPIPE */
>  #define MSG_MORE	0x8000	/* Sender will send more */
> +#define MSG_WAITFORONE	0x10000	/* recvmmsg(): block until 1+ packets avail */
>  
>  #define MSG_EOF         MSG_FIN
>  
> diff --git a/net/socket.c b/net/socket.c
> index 769c386..33304d1 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -2133,7 +2133,10 @@ int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
>  
>  		if (err)
>  			break;
> -		++datagrams;
> +
> +		/* MSG_WAITFORONE turns on MSG_DONTWAIT after one packet */
> +		if (!datagrams++ && (flags & MSG_WAITFORONE))
> +			flags |= MSG_DONTWAIT;


Hmmm, no need to test !datagram, just do :

	++datagrams;

	if (flags & MSG_WAITFORONE)
		flags |= MSG_DONTWAIT;



