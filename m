Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759951Ab2FHHEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 03:04:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756764Ab2FHHEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 03:04:34 -0400
Date: Fri, 8 Jun 2012 10:04:32 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: netdev@vger.kernel.org, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [V2 RFC net-next PATCH 2/2] virtio_net: export more statistics
 through ethtool
Message-ID: <20120608070430.GB32532@redhat.com>
References: <20120606075208.29081.75284.stgit@amd-6168-8-1.englab.nay.redhat.com>
 <20120606075217.29081.30713.stgit@amd-6168-8-1.englab.nay.redhat.com>
 <20120607221911.GD16235@redhat.com>
 <4FD172FD.5070200@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD172FD.5070200@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 11:35:25AM +0800, Jason Wang wrote:
> >>>  @@ -655,7 +695,17 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
> >>>    		kfree_skb(skb);
> >>>    		return NETDEV_TX_OK;
> >>>    	}
> >>>  -	virtqueue_kick(vi->svq);
> >>>  +
> >>>  +	kick = virtqueue_kick_prepare(vi->svq);
> >>>  +	if (unlikely(kick))
> >>>  +		virtqueue_notify(vi->svq);
> >>>  +
> >>>  +	u64_stats_update_begin(&stats->syncp);
> >>>  +	if (unlikely(kick))
> >>>  +		stats->data[VIRTNET_TX_KICKS]++;
> >>>  +	stats->data[VIRTNET_TX_Q_BYTES] += skb->len;
> >>>  +	stats->data[VIRTNET_TX_Q_PACKETS]++;
> >is this statistic interesting?
> >how about decrementing when we free?
> >this way we see how many are pending..
> >
> 
> Currently we didn't have per-vq statistics but per-cpu, so the skb
> could be sent by one vcpu and freed by another.
> Pehaps another reason to use per-queue satistics.

Just to stress these things do not need to contradict:
you can have per cpu stats for each queue.

-- 
MST
