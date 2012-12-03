Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab2LCGFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 01:05:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab2LCGFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 01:05:44 -0500
From: Jason Wang <jasowang@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: mst@redhat.com, krkumar2@in.ibm.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        bhutchings@solarflare.com, jwhan@filewood.snu.ac.kr, shiyer@redhat.com
Subject: Re: [net-next rfc v7 2/3] virtio_net: multiqueue support
Date: Mon, 03 Dec 2012 14:05:27 +0800
Message-ID: <20845723.CY8SZ4xV0F@jason-thinkpad-t430s>
User-Agent: KMail/4.9.2 (Linux/3.7.0-rc6+; KDE/4.9.2; x86_64; ; )
In-Reply-To: <87vccjj3hj.fsf@rustcorp.com.au>
References: <1354011360-39479-1-git-send-email-jasowang@redhat.com> <1354011360-39479-3-git-send-email-jasowang@redhat.com> <87vccjj3hj.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 03, 2012 12:34:08 PM Rusty Russell wrote:
> Jason Wang <jasowang@redhat.com> writes:
> > +static const struct ethtool_ops virtnet_ethtool_ops;
> > +
> > +/*
> > + * Converting between virtqueue no. and kernel tx/rx queue no.
> > + * 0:rx0 1:tx0 2:cvq 3:rx1 4:tx1 ... 2N+1:rxN 2N+2:txN
> > + */
> > +static int vq2txq(struct virtqueue *vq)
> > +{
> > +	int index = virtqueue_get_queue_index(vq);
> > +	return index == 1 ? 0 : (index - 2) / 2;
> > +}
> > +
> > +static int txq2vq(int txq)
> > +{
> > +	return txq ? 2 * txq + 2 : 1;
> > +}
> > +
> > +static int vq2rxq(struct virtqueue *vq)
> > +{
> > +	int index = virtqueue_get_queue_index(vq);
> > +	return index ? (index - 1) / 2 : 0;
> > +}
> > +
> > +static int rxq2vq(int rxq)
> > +{
> > +	return rxq ? 2 * rxq + 1 : 0;
> > +}
> > +
> 
> I thought MST changed the proposed spec to make the control queue always
> the last one, so this logic becomes trivial.

But it may break the support of legacy guest. If we boot a legacy single queue 
guest on a 2 queue virtio-net device. It may think vq 2 is cvq which is indeed 
rx1.
> 
> > +static int virtnet_set_queues(struct virtnet_info *vi)
> > +{
> > +	struct scatterlist sg;
> > +	struct virtio_net_ctrl_rfs s;
> > +	struct net_device *dev = vi->dev;
> > +
> > +	s.virtqueue_pairs = vi->curr_queue_pairs;
> > +	sg_init_one(&sg, &s, sizeof(s));
> > +
> > +	if (!vi->has_cvq)
> > +		return -EINVAL;
> > +
> > +	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_RFS,
> > +				  VIRTIO_NET_CTRL_RFS_VQ_PAIRS_SET, &sg, 1, 0)){
> > +		dev_warn(&dev->dev, "Fail to set the number of queue pairs to"
> > +			 " %d\n", vi->curr_queue_pairs);
> > +		return -EINVAL;
> > +	}
> 
> Where do we check the VIRTIO_NET_F_RFS bit?

Yes, we need this check. Will let the caller does the check and add a comment 
and check in the caller.
> 
> >  static int virtnet_probe(struct virtio_device *vdev)
> >  {
> > 
> > -	int err;
> > +	int i, err;
> > 
> >  	struct net_device *dev;
> >  	struct virtnet_info *vi;
> > 
> > +	u16 curr_queue_pairs;
> > +
> > +	/* Find if host supports multiqueue virtio_net device */
> > +	err = virtio_config_val(vdev, VIRTIO_NET_F_RFS,
> > +				offsetof(struct virtio_net_config,
> > +				max_virtqueue_pairs), &curr_queue_pairs);
> > +
> > +	/* We need at least 2 queue's */
> > +	if (err)
> > +		curr_queue_pairs = 1;
> 
> Huh?  Just call this queue_pairs.  It's not curr_ at all...
> 
> > +	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
> > +		vi->has_cvq = true;
> > +
> > +	/* Use single tx/rx queue pair as default */
> > +	vi->curr_queue_pairs = 1;
> > +	vi->max_queue_pairs = curr_queue_pairs;
> 
> See...

Right, will use max_queue_pairs then.

Thanks
> 
> Cheers,
> Rusty.
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
