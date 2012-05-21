Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab2EURf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 13:35:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50306 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab2EURfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 13:35:25 -0400
Date: Mon, 21 May 2012 14:35:12 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 13/54] net: In unregister_netdevice_notifier unregister the
 netdevices.
Message-ID: <20120521173509.GA2919@herton-Z68MA-D2H-B3>
References: <20120518212656.GA4992@kroah.com>
 <20120518211600.656454343@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518211600.656454343@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 02:16:12PM -0700, Greg KH wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
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
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Please also include these two commits in addition to this change, to
avoid a regression with pktgen:
commit c57b54684060c8aced64a5b78ff69ff289af97b9
commit d4b1133558e0d417342d5d2c49e4c35b428ff20d

> ---
>  net/core/dev.c |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -1406,14 +1406,34 @@ EXPORT_SYMBOL(register_netdevice_notifie
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
