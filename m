Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010Ab2KHVNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:13:37 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:62601 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756653Ab2KHVNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:13:35 -0500
Message-ID: <1352409211.2771.22.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [rfc net-next v6 3/3] virtio-net: change the number of queues
 through ethtool
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jason Wang <jasowang@redhat.com>
CC: <mst@redhat.com>, <davem@davemloft.net>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <rusty@rustcorp.com.au>, <krkumar2@in.ibm.com>, <kvm@vger.kernel.org>
Date: Thu, 8 Nov 2012 21:13:31 +0000
In-Reply-To: <1351591403-23065-4-git-send-email-jasowang@redhat.com>
References: <1351591403-23065-1-git-send-email-jasowang@redhat.com>
	 <1351591403-23065-4-git-send-email-jasowang@redhat.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 18:03 +0800, Jason Wang wrote:
> This patch implement the {set|get}_channels method of ethool to allow user to
> change the number of queues dymaically when the device is running. This would
> let the user to tune the device for specific applications.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/net/virtio_net.c |   43 +++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 43 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 8cc43e5..66fc129 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1616,10 +1616,53 @@ static struct virtio_driver virtio_net_driver = {
>  #endif
>  };
>  
> +/* TODO: Eliminate OOO packets during switching */
> +static int virtnet_set_channels(struct net_device *dev,
> +				struct ethtool_channels *channels)
> +{
> +	struct virtnet_info *vi = netdev_priv(dev);
> +	u16 queue_pairs = channels->combined_count;
> +
> +	/* Only two modes were support currently */
> +	if (queue_pairs == 0)
> +		return -EINVAL;
> +	if (queue_pairs != vi->total_queue_pairs - 1 && queue_pairs != 1)
> +		return -EINVAL;

You should also check that all of the other counts are == 0.

> +	vi->num_queue_pairs = queue_pairs > 1 ? queue_pairs + 1 : 1;

This doesn't make sense.  You're setting vi->num_queue_pairs to be
combined_count + 1...

> +	BUG_ON(virtnet_set_queues(vi));
> +
> +	netif_set_real_num_tx_queues(dev, vi->num_queue_pairs);
> +	netif_set_real_num_rx_queues(dev, vi->num_queue_pairs);
> +
> +	return 0;
> +}
> +
> +static void virtnet_get_channels(struct net_device *dev,
> +				 struct ethtool_channels *channels)
> +{
> +	struct virtnet_info *vi = netdev_priv(dev);
> +
> +	if (vi->total_queue_pairs != 1) {
> +		channels->combined_count = vi->num_queue_pairs;

but here you report combined_count as being vi->num_queue_pairs.  Do you
need to subtract 1 here?

Ben.

> +		channels->max_combined = vi->total_queue_pairs - 1;
> +	} else {
> +		channels->combined_count = 1;
> +		channels->max_combined = 1;
> +	}
> +
> +	channels->max_other = 0;
> +	channels->rx_count = 0;
> +	channels->tx_count = 0;
> +	channels->other_count = 0;
> +}
> +
>  static const struct ethtool_ops virtnet_ethtool_ops = {
>  	.get_drvinfo = virtnet_get_drvinfo,
>  	.get_link = ethtool_op_get_link,
>  	.get_ringparam = virtnet_get_ringparam,
> +	.set_channels = virtnet_set_channels,
> +	.get_channels = virtnet_get_channels,
>  };
>  
>  static int __init init(void)

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

