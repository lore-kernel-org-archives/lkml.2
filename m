Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031307Ab2B2RjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:39:16 -0500
Received: from senator.holtmann.net ([87.106.208.187]:44186 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031280Ab2B2RjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:39:15 -0500
Message-ID: <1330537147.3392.99.camel@aeonflux>
Subject: Re: [PATCH] Bluetooth: Silence static checker warning.
From: Marcel Holtmann <marcel@holtmann.org>
To: santosh nayak <santoshprasadnayak@gmail.com>
Cc: padovan@profusion.mobi, davem@davemloft.net,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Wed, 29 Feb 2012 09:39:07 -0800
In-Reply-To: <1330535217-26785-1-git-send-email-santoshprasadnayak@gmail.com>
References: <1330535217-26785-1-git-send-email-santoshprasadnayak@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Santosh,

> Silencing Static checker warning.
> 1. Endian warning
> 2. variable dereferenced before check 'sk' .
> 
> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
> ---
>  net/bluetooth/l2cap_sock.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
> index 401d942..d206321 100644
> --- a/net/bluetooth/l2cap_sock.c
> +++ b/net/bluetooth/l2cap_sock.c
> @@ -82,7 +82,7 @@ static int l2cap_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
>  	}
>  
>  	if (la.l2_cid)
> -		err = l2cap_add_scid(chan, la.l2_cid);
> +		err = l2cap_add_scid(chan, __le16_to_cpu(la.l2_cid));
>  	else
>  		err = l2cap_add_psm(chan, &la.l2_bdaddr, la.l2_psm);
>  
> @@ -123,7 +123,8 @@ static int l2cap_sock_connect(struct socket *sock, struct sockaddr *addr, int al
>  	if (la.l2_cid && la.l2_psm)
>  		return -EINVAL;
>  
> -	err = l2cap_chan_connect(chan, la.l2_psm, la.l2_cid, &la.l2_bdaddr);
> +	err = l2cap_chan_connect(chan, la.l2_psm, __le16_to_cpu(la.l2_cid),
> +				&la.l2_bdaddr);
>  	if (err)
>  		goto done;

I am not sure about this one. Need to go back and read through the
source code. The value provided from userspace is already in the right
host endian. Could be that we mess up our internal classification. And
instead of adding __le16_to_cpu we should fix its classification.
 
> @@ -795,7 +796,7 @@ static void l2cap_sock_kill(struct sock *sk)
>  static int l2cap_sock_shutdown(struct socket *sock, int how)
>  {
>  	struct sock *sk = sock->sk;
> -	struct l2cap_chan *chan = l2cap_pi(sk)->chan;
> +	struct l2cap_chan *chan;
>  	int err = 0;
>  
>  	BT_DBG("sock %p, sk %p", sock, sk);
> @@ -803,6 +804,8 @@ static int l2cap_sock_shutdown(struct socket *sock, int how)
>  	if (!sk)
>  		return 0;
>  
> +	chan = l2cap_pi(sk)->chan;
> +
>  	lock_sock(sk);
>  	if (!sk->sk_shutdown) {
>  		if (chan->mode == L2CAP_MODE_ERTM)

This one is fine.

Regards

Marcel


