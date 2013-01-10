Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab3AJOIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 09:08:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab3AJOIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 09:08:09 -0500
Message-ID: <50EECB43.8020405@redhat.com>
Date: Thu, 10 Jan 2013 22:08:03 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Moore <pmoore@redhat.com>
Subject: Re: [PATCH] tun: avoid owner checks on IFF_ATTACH_QUEUE
References: <20130110113108.GF13451@redhat.com>
In-Reply-To: <20130110113108.GF13451@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 07:31 PM, Michael S. Tsirkin wrote:
> At the moment, we check owner when we enable queue in tun.
> This seems redundant and will break some valid uses
> where fd is passed around: I think TUNSETOWNER is there
> to prevent others from attaching to a persistent device not
> owned by them. Here the fd is already attached,
> enabling/disabling queue is more like read/write.

It also change the number of queues of the tuntap, maybe we should limit
this. Note that if management layer does not call TUNSETOWNER, the check
is just a nop. So if management layer want to limit the behavior, it's
its duty to do this correctly.
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>
> ---
>
> Note: this is unrelated to Stefan's bugfix.
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index fbd106e..78e3225 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1789,10 +1792,8 @@ static int tun_set_queue(struct file *file, struct ifreq *ifr)
>  		tun = tfile->detached;
>  		if (!tun)
>  			ret = -EINVAL;
> -		else if (tun_not_capable(tun))
> -			ret = -EPERM;
>  		else
>  			ret = tun_attach(tun, file);
>  	} else if (ifr->ifr_flags & IFF_DETACH_QUEUE) {
>  		tun = rcu_dereference_protected(tfile->tun,
>  						lockdep_rtnl_is_held());


