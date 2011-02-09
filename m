Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab1BIH0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 02:26:54 -0500
Received: from mailout08.t-online.de ([194.25.134.20]:52048 "EHLO
	mailout08.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab1BIH0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 02:26:52 -0500
Message-ID: <4D5241AD.6030208@t-online.de>
Date: Wed, 09 Feb 2011 08:26:37 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: paulus@samba.org, linux-kernel@vger.kernel.org, mostrows@earthlink.net,
        linux-ppp@vger.kernel.org, xiaosuo@gmail.com, eric.dumazet@gmail.com,
        ebiederm@xmission.com
Subject: Re: [BUG] 2.6.38-rc2: Circular Locking Dependency
References: <20110207104315.GB17044@brick.ozlabs.ibm.com>	<4D50F5FA.7050202@t-online.de>	<20110208.000721.193716330.davem@davemloft.net> <20110208.150411.102552333.davem@davemloft.net>
In-Reply-To: <20110208.150411.102552333.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ID: Tcrm5aZSgh+K3JzC2IuxdHF3YkAH0vAbssCBMwZIX3IwQufzIyzIJkNCmJmlZNTg+t
X-TOI-MSGID: 646304b5-d57e-490c-8cc7-16a3949313a1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.02.2011 00:04, schrieb David Miller:
> From: David Miller <davem@davemloft.net>
> Date: Tue, 08 Feb 2011 00:07:21 -0800 (PST)
>
> [ Eric B., CC:'ing you so that you are aware of the init network
>   namespace leak that's fixed as a side effect of this change. ]
>
>   
>> From: Knut Petersen <Knut_Petersen@t-online.de>
>> Date: Tue, 08 Feb 2011 08:51:22 +0100
>>
>>     
>>> I bisected the problem with the following result:
>>>
>>> aa9421041128abb4d269ee1dc502ff65fb3b7d69 is the first bad commit
>>> commit aa9421041128abb4d269ee1dc502ff65fb3b7d69
>>> Author: Changli Gao <xiaosuo@gmail.com>
>>> Date:   Sat Dec 4 02:31:41 2010 +0000
>>>
>>>     net: init ingress queue
>>>
>>>     The dev field of ingress queue is forgot to initialized, then NULL
>>>     pointer dereference happens in qdisc_alloc().
>>>
>>>     Move inits of tx queues to netif_alloc_netdev_queues().
>>>
>>>     Signed-off-by: Changli Gao <xiaosuo@gmail.com>
>>>     Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
>>>     Signed-off-by: David S. Miller <davem@davemloft.net>
>>>
>>> :040000 040000 dcbb6ab41c4308cba1bc6823d200dcf92aa402d8
>>> b5e190ec681d26ffe62d1d0214c4ef77b8034189 M      net
>>>       
>> Indeed, this initialization is now too early for the sake
>> of getting the lockdep bits right.  The problem is that at
>> the point in which we call netif_alloc_netdev_queue() we
>> haven't initialized dev->type yet, it is therefore always
>> zero when we setup the lockdep class for ->_xmit_lock.
>>     
> Ok, this should fix it, please test it out for me.
>
> Thanks!
>   

Yes, that patch does solve the problem, and I do not see
any negative effects.

Thanks!

Knut

> --------------------
> net: Fix lockdep regression caused by initializing netdev queues too early.
>
> In commit aa9421041128abb4d269ee1dc502ff65fb3b7d69 ("net: init ingress
> queue") we moved the allocation and lock initialization of the queues
> into alloc_netdev_mq() since register_netdevice() is way too late.
>
> The problem is that dev->type is not setup until the setup()
> callback is invoked by alloc_netdev_mq(), and the dev->type is
> what determines the lockdep class to use for the locks in the
> queues.
>
> Fix this by doing the queue allocation after the setup() callback
> runs.
>
> This is safe because the setup() callback is not allowed to make any
> state changes that need to be undone on error (memory allocations,
> etc.).  It may, however, make state changes that are undone by
> free_netdev() (such as netif_napi_add(), which is done by the
> ipoib driver's setup routine).
>
> The previous code also leaked a reference to the &init_net namespace
> object on RX/TX queue allocation failures.
>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  net/core/dev.c |   27 ++++++++++++++++-----------
>  1 files changed, 16 insertions(+), 11 deletions(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index b6d0bf8..8e726cb 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5660,30 +5660,35 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
>  
>  	dev_net_set(dev, &init_net);
>  
> +	dev->gso_max_size = GSO_MAX_SIZE;
> +
> +	INIT_LIST_HEAD(&dev->ethtool_ntuple_list.list);
> +	dev->ethtool_ntuple_list.count = 0;
> +	INIT_LIST_HEAD(&dev->napi_list);
> +	INIT_LIST_HEAD(&dev->unreg_list);
> +	INIT_LIST_HEAD(&dev->link_watch_list);
> +	dev->priv_flags = IFF_XMIT_DST_RELEASE;
> +	setup(dev);
> +
>  	dev->num_tx_queues = txqs;
>  	dev->real_num_tx_queues = txqs;
>  	if (netif_alloc_netdev_queues(dev))
> -		goto free_pcpu;
> +		goto free_all;
>  
>  #ifdef CONFIG_RPS
>  	dev->num_rx_queues = rxqs;
>  	dev->real_num_rx_queues = rxqs;
>  	if (netif_alloc_rx_queues(dev))
> -		goto free_pcpu;
> +		goto free_all;
>  #endif
>  
> -	dev->gso_max_size = GSO_MAX_SIZE;
> -
> -	INIT_LIST_HEAD(&dev->ethtool_ntuple_list.list);
> -	dev->ethtool_ntuple_list.count = 0;
> -	INIT_LIST_HEAD(&dev->napi_list);
> -	INIT_LIST_HEAD(&dev->unreg_list);
> -	INIT_LIST_HEAD(&dev->link_watch_list);
> -	dev->priv_flags = IFF_XMIT_DST_RELEASE;
> -	setup(dev);
>  	strcpy(dev->name, name);
>  	return dev;
>  
> +free_all:
> +	free_netdev(dev);
> +	return NULL;
> +
>  free_pcpu:
>  	free_percpu(dev->pcpu_refcnt);
>  	kfree(dev->_tx);
>   

