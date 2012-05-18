Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471Ab2ERFJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 01:09:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39101 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757359Ab2ERFJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 01:09:13 -0400
Date: Fri, 18 May 2012 02:09:05 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [ 12/53] net: In unregister_netdevice_notifier unregister the
 netdevices.
Message-ID: <20120518050904.GA2971@herton-Z68MA-D2H-B3>
References: <20120518023254.339945758@decadent.org.uk>
 <20120518023255.978828329@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518023255.978828329@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 03:33:06AM +0100, Ben Hutchings wrote:
> 3.2.18-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> [ Upstream commit 7d3d43dab4e978d8d9ad1acf8af15c9b1c4b0f0f ]
> 
> We already synthesize events in register_netdevice_notifier and synthesizing
> events in unregister_netdevice_notifier allows to us remove the need for
> special case cleanup code.
> 
> This change should be safe as it adds no new cases for existing callers
> of unregiser_netdevice_notifier to handle.

It seems this introduces a regression later fixed by commit
c57b54684060c8aced64a5b78ff69ff289af97b9

> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  net/core/dev.c |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 55cd370..d1d2a56 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -1421,14 +1421,34 @@ EXPORT_SYMBOL(register_netdevice_notifier);
>   *	register_netdevice_notifier(). The notifier is unlinked into the
>   *	kernel structures and may then be reused. A negative errno code
>   *	is returned on a failure.
> + *
> + * 	After unregistering unregister and down device events are synthesized
> + *	for all devices on the device list to the removed notifier to remove
> + *	the need for special case cleanup code.
>   */
>  
>  int unregister_netdevice_notifier(struct notifier_block *nb)
>  {
> +	struct net_device *dev;
> +	struct net *net;
>  	int err;
>  
>  	rtnl_lock();
>  	err = raw_notifier_chain_unregister(&netdev_chain, nb);
> +	if (err)
> +		goto unlock;
> +
> +	for_each_net(net) {
> +		for_each_netdev(net, dev) {
> +			if (dev->flags & IFF_UP) {
> +				nb->notifier_call(nb, NETDEV_GOING_DOWN, dev);
> +				nb->notifier_call(nb, NETDEV_DOWN, dev);
> +			}
> +			nb->notifier_call(nb, NETDEV_UNREGISTER, dev);
> +			nb->notifier_call(nb, NETDEV_UNREGISTER_BATCH, dev);
> +		}
> +	}
> +unlock:
>  	rtnl_unlock();
>  	return err;
>  }
> -- 
> 1.7.10.1
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
[]'s
Herton
