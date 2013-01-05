Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab3AEThf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 14:37:35 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:48477 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab3AEThe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 14:37:34 -0500
Subject: Re: [PATCH V2 3/3] tuntap: don't add to waitqueue when POLLERR
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1357378446-19656-4-git-send-email-jasowang@redhat.com>
References: <1357378446-19656-1-git-send-email-jasowang@redhat.com>
	 <1357378446-19656-4-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Jan 2013 11:37:30 -0800
Message-ID: <1357414650.1678.4092.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-01-05 at 17:34 +0800, Jason Wang wrote:
> Currently, tun_chr_poll() returns POLLERR after waitqueue adding during device
> unregistration. This would confuse some of its user such as vhost which assume
> when POLLERR is returned, it wasn't added to the waitqueue. Fix this by
> returning POLLERR before adding to waitqueue.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/net/tun.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index fbd106e..f9c0049 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -886,7 +886,7 @@ static unsigned int tun_chr_poll(struct file *file, poll_table *wait)
>  	struct sock *sk;
>  	unsigned int mask = 0;
>  
> -	if (!tun)
> +	if (!tun || tun->dev->reg_state != NETREG_REGISTERED)
>  		return POLLERR;
>  
>  	sk = tfile->socket.sk;
> @@ -903,9 +903,6 @@ static unsigned int tun_chr_poll(struct file *file, poll_table *wait)
>  	     sock_writeable(sk)))
>  		mask |= POLLOUT | POLLWRNORM;
>  
> -	if (tun->dev->reg_state != NETREG_REGISTERED)
> -		mask = POLLERR;
> -
>  	tun_put(tun);
>  	return mask;
>  }

This patch is buggy.

First, the caller assuming POLLERR means poll_wait() was not called is
wrong.

Secondly, you add a ref leak.



