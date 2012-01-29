Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab2A2C5z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 21:57:55 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38969 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab2A2C5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 21:57:54 -0500
Message-ID: <1327805865.2805.23.camel@edumazet-laptop>
Subject: Re: [PATCH 001/001] net: Add tx_queue/rx_queue info to
 /proc/net/unix
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ryan Hajdaj <rhajdaj@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 29 Jan 2012 03:57:45 +0100
In-Reply-To: <CAB0C5qK1FGc5xhGxGzpmELbWfC6GVVxEB9Zan_nU9cC_MxMzew@mail.gmail.com>
References: <CAB0C5qK1FGc5xhGxGzpmELbWfC6GVVxEB9Zan_nU9cC_MxMzew@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 28 janvier 2012 à 21:37 -0500, Ryan Hajdaj a écrit :
> From: Ryan Hajdaj <rhajdaj@gmail.com>
> 
> Add tx_queue/rx_queue info to /proc/net/unix (unix_seq_show)
> 
> Signed-off-by: Ryan Hajdaj <rhajdaj@gmail.com>
> Tested-by: Ryan Hajdaj <rhajdaj@gmail.com>
> ---
> tx_queue/rx_queue info is useful in systems with multiple processes
> using Unix Domain sockets to communicate, as it can be used to check
> process health "at a glance".
> Unit tested on Unix stream and datagram sockets.
> --- linux-3.3-rc1/net/unix/af_unix.c.orig	2012-01-28 20:36:33.000000000 +0000
> +++ linux-3.3-rc1/net/unix/af_unix.c	2012-01-28 19:09:18.000000000 +0000
> @@ -2286,13 +2286,14 @@ static int unix_seq_show(struct seq_file
> 
>  	if (v == SEQ_START_TOKEN)
>  		seq_puts(seq, "Num       RefCount Protocol Flags    Type St "
> -			 "Inode Path\n");
> +			 "tx_queue rx_queue Inode Path\n");
>  	else {
>  		struct sock *s = v;
>  		struct unix_sock *u = unix_sk(s);
>  		unix_state_lock(s);
> 
> -		seq_printf(seq, "%pK: %08X %08X %08X %04X %02X %5lu",
> +		seq_printf(seq,
> +			"%pK: %08X %08X %08X %04X %02X %08lX %08lX %5lu",
>  			s,
>  			atomic_read(&s->sk_refcnt),
>  			0,
> @@ -2301,6 +2302,8 @@ static int unix_seq_show(struct seq_file
>  			s->sk_socket ?
>  			(s->sk_state == TCP_ESTABLISHED ? SS_CONNECTED : SS_UNCONNECTED) :
>  			(s->sk_state == TCP_ESTABLISHED ? SS_CONNECTING : SS_DISCONNECTING),
> +			unix_outq_len(s),
> +			(unix_inq_len(s) < 0 ? 0 : unix_inq_len(s)),
>  			sock_i_ino(s));
> 
>  		if (u->addr) {

You missed some discussion on netdev about this kind of patches.

/proc/net/unix format is frozen.

Pavel Emelyanov did the work to support unix_diag, where you can find
all you need.



