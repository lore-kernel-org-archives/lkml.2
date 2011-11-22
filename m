Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab1KVFXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 00:23:09 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42935 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab1KVFXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 00:23:07 -0500
Message-ID: <1321939381.27077.7.camel@edumazet-laptop>
Subject: Re: [PATCH 1/1] AF_UNIX: Fix poll locking problem when reading from
 a stream socket
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexey Moiseytsev <himeraster@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 22 Nov 2011 06:23:01 +0100
In-Reply-To: <1321918525-5078-1-git-send-email-himeraster@gmail.com>
References: <1321918525-5078-1-git-send-email-himeraster@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 22 novembre 2011 à 03:35 +0400, Alexey Moiseytsev a écrit :
> poll() call may be locked by concurrent reading from the same stream
> socket.
> 
> Signed-off-by: Alexey Moiseytsev <himeraster@gmail.com>
> ---
>  net/unix/af_unix.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 466fbcc..b595a3d 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -1957,6 +1957,7 @@ static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
>  			if ((UNIXCB(skb).pid  != siocb->scm->pid) ||
>  			    (UNIXCB(skb).cred != siocb->scm->cred)) {
>  				skb_queue_head(&sk->sk_receive_queue, skb);
> +				sk->sk_data_ready(sk, skb->len);
>  				break;
>  			}
>  		} else {
> @@ -1974,6 +1975,7 @@ static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
>  		chunk = min_t(unsigned int, skb->len, size);
>  		if (memcpy_toiovec(msg->msg_iov, skb->data, chunk)) {
>  			skb_queue_head(&sk->sk_receive_queue, skb);
> +			sk->sk_data_ready(sk, skb->len);
>  			if (copied == 0)
>  				copied = -EFAULT;
>  			break;
> @@ -1991,6 +1993,7 @@ static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
>  			/* put the skb back if we didn't use it up.. */
>  			if (skb->len) {
>  				skb_queue_head(&sk->sk_receive_queue, skb);
> +				sk->sk_data_ready(sk, skb->len);
>  				break;
>  			}
>  
> @@ -2006,6 +2009,7 @@ static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
>  
>  			/* put message back and return */
>  			skb_queue_head(&sk->sk_receive_queue, skb);
> +			sk->sk_data_ready(sk, skb->len);
>  			break;
>  		}
>  	} while (size);

Fine, the fix is technically correct since we own u->readlock mutex,
another thread cannot consume the just requeued skb. 

Small note : the words "locking" and "locked" are more used to describe
the action of taking a spinlock/mutex/rwlock or something, while the bug
you fixed is more about poll() system call being blocked/frozen forever.

Thanks !

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>



