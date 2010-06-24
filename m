Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab0FXNTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 09:19:54 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:45362 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab0FXNTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 09:19:52 -0400
Message-ID: <4C235B75.2000807@hp.com>
Date: Thu, 24 Jun 2010 09:19:49 -0400
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Diego_Elio_=27Flameeyes=27_Petten=F2?= 
	<flameeyes@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org
Subject: Re: [PATCH] sctp: implement SIOCINQ ioctl()
References: <1277329060-21543-1-git-send-email-flameeyes@gmail.com>
In-Reply-To: <1277329060-21543-1-git-send-email-flameeyes@gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Diego Elio 'Flameeyes' Pettenò wrote:
> This simple patch copies the current approach for SIOCINQ ioctl() from DCCP
> into SCTp so that the userland code working with SCTP can use a similar
> interface across different protocols to know how much space to allocate for
> a buffer.
> ---
>  net/sctp/socket.c |   31 ++++++++++++++++++++++++++++++-
>  1 files changed, 30 insertions(+), 1 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 44a1ab0..3135b4e 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -3595,7 +3595,36 @@ out:
>  /* The SCTP ioctl handler. */
>  SCTP_STATIC int sctp_ioctl(struct sock *sk, int cmd, unsigned long arg)
>  {
> -	return -ENOIOCTLCMD;
> +	int rc = -ENOTCONN;
> +
> +	sctp_lock_sock(sk);
> +
> +	if (sctp_sstate(sk, LISTENING))

This should add a check for sctp_style(sk, TCP), since one can't read from
a TCP style listening sockets, but can do so from UDP-style (SOCK_SEQPACKET).

-vlad

> +		goto out;
> +
> +	switch(cmd) {
> +	case SIOCINQ: {
> +		struct sk_buff *skb;
> +		unsigned long amount = 0;
> +
> +		skb = skb_peek(&sk->sk_receive_queue);
> +		if (skb != NULL) {
> +			/*
> +			 * We will only return the amount of this packet since
> +			 * that is all that will be read.
> +			 */
> +			amount = skb->len;
> +		}
> +		rc = put_user(amount, (int __user *)arg);
> +	}
> +		break;
> +	default:
> +		rc = -ENOIOCTLCMD;
> +		break;
> +	}
> +out:
> +	sctp_release_sock(sk);
> +	return rc;
>  }
>  
>  /* This is the function which gets called during socket creation to
