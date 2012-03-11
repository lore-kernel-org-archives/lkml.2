Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab2CKR3e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 13:29:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60512 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab2CKR3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 13:29:32 -0400
Message-ID: <1331486969.2449.15.camel@edumazet-laptop>
Subject: Re: [PATCH] tun: don't hold network namespace by tun sockets
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: davem@davemloft.net, ebiederm@aristanetworks.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xemul@parallel.com,
        shemminger@vyatta.com, devel@openvz.org
Date: Sun, 11 Mar 2012 10:29:29 -0700
In-Reply-To: <20120311152053.30481.29572.stgit@localhost6.localdomain6>
References: <20120311152053.30481.29572.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 11 mars 2012 à 19:21 +0400, Stanislav Kinsbursky a écrit :
> TUN was designed to destroy it's socket on network namesapce shutdown. But this
> will never happen for persistent device, because it's socket holds network
> namespace.
> This patch removes of holding network namespace by TUN socket and replaces it
> by creating socket in init_net and then changing it's net it to desired one. On
> shutdown socket is moved back to init_net prior to final put.
> 
> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
> 
> ---
>  drivers/net/tun.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 2c5d349..92ef539 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -358,8 +358,11 @@ static void tun_net_uninit(struct net_device *dev)
>  static void tun_free_netdev(struct net_device *dev)
>  {
>  	struct tun_struct *tun = netdev_priv(dev);
> +	struct sock *sk = tun->socket.sk;
>  
> -	sock_put(tun->socket.sk);
> +	release_net(sock_net(sk));
> +	sock_net_set(sk, get_net(&init_net));
> +	sock_put(sk);


Hmm, maybe use sk_release_kernel(), as its should be the thing
associated with sk_change_net().

Or at least make intent clear, since its not obvious.



