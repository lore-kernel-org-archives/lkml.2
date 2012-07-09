Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab2GIUNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:13:34 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:64548 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751904Ab2GIUNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:13:30 -0400
Message-ID: <1341864803.2535.53.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [net-next RFC V5 5/5] virtio_net: support negotiating the
 number of queues through ctrl vq
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jason Wang <jasowang@redhat.com>
CC: <mst@redhat.com>, <mashirle@us.ibm.com>, <krkumar2@in.ibm.com>,
        <habanero@linux.vnet.ibm.com>, <rusty@rustcorp.com.au>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <edumazet@google.com>,
        <tahm@linux.vnet.ibm.com>, <jwhan@filewood.snu.ac.kr>,
        <davem@davemloft.net>, <akong@redhat.com>, <kvm@vger.kernel.org>,
        <sri@us.ibm.com>
Date: Mon, 9 Jul 2012 21:13:23 +0100
In-Reply-To: <1341484194-8108-6-git-send-email-jasowang@redhat.com>
References: <1341484194-8108-1-git-send-email-jasowang@redhat.com>
	 <1341484194-8108-6-git-send-email-jasowang@redhat.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-05 at 18:29 +0800, Jason Wang wrote:
> This patch let the virtio_net driver can negotiate the number of queues it
> wishes to use through control virtqueue and export an ethtool interface to let
> use tweak it.
> 
> As current multiqueue virtio-net implementation has optimizations on per-cpu
> virtuqueues, so only two modes were support:
> 
> - single queue pair mode
> - multiple queue paris mode, the number of queues matches the number of vcpus
> 
> The single queue mode were used by default currently due to regression of
> multiqueue mode in some test (especially in stream test).
> 
> Since virtio core does not support paritially deleting virtqueues, so during
> mode switching the whole virtqueue were deleted and the driver would re-create
> the virtqueues it would used.
> 
> btw. The queue number negotiating were defered to .ndo_open(), this is because
> only after feature negotitaion could we send the command to control virtqueue
> (as it may also use event index).
[...]
> +static int virtnet_set_channels(struct net_device *dev,
> +				struct ethtool_channels *channels)
> +{
> +	struct virtnet_info *vi = netdev_priv(dev);
> +	u16 queues = channels->rx_count;
> +	unsigned status = VIRTIO_CONFIG_S_ACKNOWLEDGE | VIRTIO_CONFIG_S_DRIVER;
> +
> +	if (channels->rx_count != channels->tx_count)
> +		return -EINVAL;
[...]
> +static void virtnet_get_channels(struct net_device *dev,
> +				 struct ethtool_channels *channels)
> +{
> +	struct virtnet_info *vi = netdev_priv(dev);
> +
> +	channels->max_rx = vi->total_queue_pairs;
> +	channels->max_tx = vi->total_queue_pairs;
> +	channels->max_other = 0;
> +	channels->max_combined = 0;
> +	channels->rx_count = vi->num_queue_pairs;
> +	channels->tx_count = vi->num_queue_pairs;
> +	channels->other_count = 0;
> +	channels->combined_count = 0;
> +}
[...]

It looks like the queue-pairs should be treated as 'combined channels',
not separate RX and TX channels.  Also you don't need to clear the other
members; you can assume that the ethtool core will zero-initialise
structures for 'get' operations.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

