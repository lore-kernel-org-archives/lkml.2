Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab2KGTkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 14:40:24 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:55779 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab2KGTkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 14:40:22 -0500
Subject: Re: [PATCH] tcp: Avoid infinite loop on recvmsg bug
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Julius Werner <jwerner@chromium.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Patrick McHardy <kaber@trash.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        James Morris <jmorris@namei.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>, Dave Jones <davej@redhat.com>,
        Sameer Nanda <snanda@chromium.org>,
        Mandeep Singh Baines <msb@chromium.org>
In-Reply-To: <1352316791-16491-1-git-send-email-jwerner@chromium.org>
References: <CAODwPW9kiG-jo=n0zedv5KT-8-gJcEUrdC3F2mAEjt78tne18g@mail.gmail.com>
	 <1352316791-16491-1-git-send-email-jwerner@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Nov 2012 11:40:19 -0800
Message-ID: <1352317219.5552.6.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-07 at 11:33 -0800, Julius Werner wrote:
> tcp_recvmsg contains a sanity check that WARNs when there is a gap
> between the socket's copied_seq and the first buffer in the
> sk_receive_queue. In theory, the TCP stack makes sure that This Should
> Never Happen (TM)... however, practice shows that there are still a few
> bug reports from it out there (and one in my inbox).
> 
> Unfortunately, when it does happen for whatever reason, the situation
> is not handled very well: the kernel logs a warning and breaks out of
> the loop that walks the receive queue. It proceeds to find nothing else
> to do on the socket and hits sk_wait_data, which cannot block because
> the receive queue is not empty. As no data was read, the outer while
> loop repeats (logging the same warning again) ad infinitum until the
> system's syslog exhausts all available hard drive capacity.
> 
> This patch addresses that issue by closing the socket outright and
> throwing EBADFD to userspace (which seems most appropriate to me at this
> point). As the underlying bug condition is "impossible" and therefore by
> definition unrecoverable, this is the only sensible action other than a
> full panic.
> 
> Signed-off-by: Julius Werner <jwerner@chromium.org>
> ---
>  net/ipv4/tcp.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 197c000..d612308 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1628,7 +1628,7 @@ int tcp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
>  				 "recvmsg bug: copied %X seq %X rcvnxt %X fl %X\n",
>  				 *seq, TCP_SKB_CB(skb)->seq, tp->rcv_nxt,
>  				 flags))
> -				break;
> +				goto selfdestruct;
>  
>  			offset = *seq - TCP_SKB_CB(skb)->seq;
>  			if (tcp_hdr(skb)->syn)
> @@ -1936,6 +1936,11 @@ recv_urg:
>  recv_sndq:
>  	err = tcp_peek_sndq(sk, msg, len);
>  	goto out;
> +
> +selfdestruct:
> +	err = -EBADFD;
> +	tcp_done(sk);
> +	goto out;
>  }
>  EXPORT_SYMBOL(tcp_recvmsg);
>  


What I find very sad in all this is that you didnt mention the driver
that was triggering this bug.

So instead of making real progress, we are discussing of some dubious
'fixes'



