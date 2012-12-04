Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab2LDOrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:47:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab2LDOrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:47:03 -0500
From: Jason Wang <jasowang@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, krkumar2@in.ibm.com, kvm@vger.kernel.org,
        bhutchings@solarflare.com, jwhan@filewood.snu.ac.kr, shiyer@redhat.com
Subject: Re: [PATCH net-next 3/3] virtio-net: change the number of queues through ethtool
Date: Tue, 04 Dec 2012 22:46:47 +0800
Message-ID: <8635859.yLm7QNO6or@jason-thinkpad-t430s>
User-Agent: KMail/4.9.2 (Linux/3.7.0-rc6+; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121204134959.GG7499@redhat.com>
References: <1354619278-35702-1-git-send-email-jasowang@redhat.com> <1354619278-35702-4-git-send-email-jasowang@redhat.com> <20121204134959.GG7499@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 04, 2012 03:49:59 PM Michael S. Tsirkin wrote:
> On Tue, Dec 04, 2012 at 07:07:58PM +0800, Jason Wang wrote:
> > This patch implement the ethtool_{set|get}_channels method of ethool to
> > allow user to change the number of queues dymaically when the device is
> > running. This would let the user to configure it on demand.
> > 
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > ---
> > 
> >  drivers/net/virtio_net.c |   44
> >  ++++++++++++++++++++++++++++++++++++++++++++ 1 files changed, 44
> >  insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 912f5b2..b9f9887 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -1589,10 +1589,54 @@ static struct virtio_driver virtio_net_driver = {
> > 
> >  #endif
> >  };
> > 
> > +/* TODO: Eliminate OOO packets during switching */
> > +static int virtnet_set_channels(struct net_device *dev,
> > +				struct ethtool_channels *channels)
> > +{
> > +	struct virtnet_info *vi = netdev_priv(dev);
> > +	u16 queue_pairs = channels->combined_count;
> > +	u16 old_queue_pairs = vi->curr_queue_pairs;
> > +
> > +	/* We don't support separate rx/tx channels.
> > +	 * We don't allow setting 'other' channels.
> > +	 */
> > +	if (channels->rx_count || channels->tx_count || channels->other_count)
> > +		return -EINVAL;
> > +
> > +	if (queue_pairs > vi->max_queue_pairs)
> > +		return -EINVAL;
> > +
> > +	vi->curr_queue_pairs = queue_pairs;
> > +	if (virtnet_set_queues(vi) == 0) {
> > +		netif_set_real_num_tx_queues(dev, vi->curr_queue_pairs);
> > +		netif_set_real_num_rx_queues(dev, vi->curr_queue_pairs);
> 
> Just use queue_pairs - it's shorter.

Ok.
> 
> > +
> > +		virtnet_set_affinity(vi, true);
> > +	} else
> > +		vi->curr_queue_pairs = old_queue_pairs;
> 
> Should be
> 	ret = virtnet_set_queues(vi);
> 	if (ret) {
> 		vi->curr_queue_pairs = old_queue_pairs;
> 		return ret;
> 	}
> otherwise we loose error reporting.
> 

Right.
> Also it's better if virtnet_set_queues
> gets queue_pairs as parameter and set curr_queue_pairs
> on success.

True, looks simpler than current method, will do it in next version.
> 
> > +
> > +	return 0;
> > +}
> > +
> > +static void virtnet_get_channels(struct net_device *dev,
> > +				 struct ethtool_channels *channels)
> > +{
> > +	struct virtnet_info *vi = netdev_priv(dev);
> > +
> > +	channels->combined_count = vi->curr_queue_pairs;
> > +	channels->max_combined = vi->max_queue_pairs;
> > +	channels->max_other = 0;
> > +	channels->rx_count = 0;
> > +	channels->tx_count = 0;
> > +	channels->other_count = 0;
> > +}
> > +
> > 
> >  static const struct ethtool_ops virtnet_ethtool_ops = {
> >  
> >  	.get_drvinfo = virtnet_get_drvinfo,
> >  	.get_link = ethtool_op_get_link,
> >  	.get_ringparam = virtnet_get_ringparam,
> > 
> > +	.set_channels = virtnet_set_channels,
> > +	.get_channels = virtnet_get_channels,
> > 
> >  };
> >  
> >  static int __init init(void)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
