Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab1GMBdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 21:33:45 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38638 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab1GMBdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 21:33:44 -0400
Subject: Re: [RFC PATCH 08/14] af_netlink.c: make netlink_capable
 userns-aware
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Serge Hallyn <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        dhowells@redhat.com, ebiederm@xmission.com,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
In-Reply-To: <1310513452-13397-9-git-send-email-serge@hallyn.com>
References: <1310513452-13397-1-git-send-email-serge@hallyn.com>
	 <1310513452-13397-9-git-send-email-serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jul 2011 03:33:39 +0200
Message-ID: <1310520819.2634.6.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 12 juillet 2011 à 23:30 +0000, Serge Hallyn a écrit :
> From: Serge E. Hallyn <serge.hallyn@canonical.com>
> 
> netlink_capable should check for permissions against the user
> namespace owning the socket in question.
> 
> Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  net/netlink/af_netlink.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index 6ef64ad..81c1099 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -580,8 +580,15 @@ retry:
>  
>  static inline int netlink_capable(struct socket *sock, unsigned int flag)
>  {
> -	return (nl_table[sock->sk->sk_protocol].nl_nonroot & flag) ||
> -	       capable(CAP_NET_ADMIN);
> +	struct net *net;
> +	if (nl_table[sock->sk->sk_protocol].nl_nonroot & flag)
> +		return 1;
> +#ifdef CONFIG_NET_NS
> +	net = sock->sk->sk_net;
> +#else
> +	net = &init_net;
> +#endif

This is really ugly, please use :

	net = sock_net(sk);

And no more #ifdef



