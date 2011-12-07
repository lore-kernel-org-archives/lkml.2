Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab1LGLoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 06:44:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab1LGLoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 06:44:21 -0500
Date: Wed, 7 Dec 2011 13:46:03 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 09/12] virtio: net: Add freeze, restore handlers to
 support S4
Message-ID: <20111207114603.GF8326@redhat.com>
References: <cover.1323199985.git.amit.shah@redhat.com>
 <712d8d78cf730161181562ed44d4fe08a370b85e.1323199985.git.amit.shah@redhat.com>
 <20111207102824.GC8326@redhat.com>
 <20111207103529.GG4651@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111207103529.GG4651@amit-x200.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 04:05:29PM +0530, Amit Shah wrote:
> On (Wed) 07 Dec 2011 [12:28:24], Michael S. Tsirkin wrote:
> > On Wed, Dec 07, 2011 at 01:18:47AM +0530, Amit Shah wrote:
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 697a0fc..1378f3c 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -1151,6 +1151,38 @@ static void __devexit virtnet_remove(struct virtio_device *vdev)
> > >  	free_netdev(vi->dev);
> > >  }
> > >  
> > > +#ifdef CONFIG_PM
> > > +static int virtnet_freeze(struct virtio_device *vdev)
> > > +{
> > > +	struct virtnet_info *vi = vdev->priv;
> > > +
> > > +	netif_device_detach(vi->dev);
> > > +	if (netif_running(vi->dev))
> > > +		napi_disable(&vi->napi);
> > > +
> > 
> > Could refill_work still be running at this point?
> 
> Yes, it could.  So moving the cancel_delayed_work_sync() before
> disabling napi would work fine?

No, because napi poll can schedule that.
Further, refill can reschedule itself.

It also looks like we have a bug in virtio net cleanup now:
cancel_delayed_work_sync is called after unregister, so
it will be calling napi API on an invalid device.
And, if it schedules itself it will run after device is gone.

I think we need some locking to fix this.

>  Anything else that might similar treatment?
> 
> 		Amit



-- 
MST
