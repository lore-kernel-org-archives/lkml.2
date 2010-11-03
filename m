Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab0KCIAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 04:00:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195Ab0KCIA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 04:00:28 -0400
Date: Wed, 3 Nov 2010 10:00:19 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: rusty@rustcorp.com.au, davem@davemloft.net, markmc@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] virtio-net: init link state correctly
Message-ID: <20101103080019.GC6772@redhat.com>
References: <20101103070817.26272.31654.stgit@dhcp-91-158.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101103070817.26272.31654.stgit@dhcp-91-158.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 03:08:17PM +0800, Jason Wang wrote:
> We need call netif_carrier_off() and do not assume VIRTIO_NET_S_LINKUP
> before querying device state during probing, otherwise we may get
> wrong operstate after driver was loaded because the link watch event
> was not fired as expected.
> 
> Since the device state changed could be caught through interrupt, the
> unconditional call to nerif_carrier_on() is also removed.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

OK, but this seems broken for hosts without VIRTIO_NET_F_STATUS.  Right?
Probably

	/* Assume link up if device can't report link status,
	   otherwise get link status from config. */
	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_STATUS)) {
		vi->status = 0;
		netif_carrier_off(dev);
  		virtnet_update_status(vi);
	} else {
		vi->status = VIRTIO_NET_S_LINK_UP;
		netif_carrier_on(dev);
	}

Makes sense?

> ---
>  drivers/net/virtio_net.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index bb6b67f..0a0cd35 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -986,9 +986,8 @@ static int virtnet_probe(struct virtio_device *vdev)
>  		goto unregister;
>  	}
>  
> -	vi->status = VIRTIO_NET_S_LINK_UP;
> +	netif_carrier_off(dev);
>  	virtnet_update_status(vi);
> -	netif_carrier_on(dev);
>  
>  	pr_debug("virtnet: registered device %s\n", dev->name);
>  	return 0;
