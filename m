Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab1JCJyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:54:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964Ab1JCJyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:54:14 -0400
Date: Mon, 3 Oct 2011 11:55:20 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/11] virtio: blk: Add freeze, restore handlers to
 support S4
Message-ID: <20111003095519.GA17023@redhat.com>
References: <cover.1317309123.git.amit.shah@redhat.com>
 <5160f2cf536e7c506a5e90b4cb95e0f2e41c53d9.1317309123.git.amit.shah@redhat.com>
 <20111002093733.GE29706@redhat.com>
 <20111003091646.GA5192@amit-x200.redhat.com>
 <20111003092443.GA16852@redhat.com>
 <20111003093105.GC5192@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111003093105.GC5192@amit-x200.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 03:01:05PM +0530, Amit Shah wrote:
> On (Mon) 03 Oct 2011 [11:24:44], Michael S. Tsirkin wrote:
> > On Mon, Oct 03, 2011 at 02:46:46PM +0530, Amit Shah wrote:
> > > On (Sun) 02 Oct 2011 [11:37:33], Michael S. Tsirkin wrote:
> > > > On Thu, Sep 29, 2011 at 08:56:02PM +0530, Amit Shah wrote:
> > > > > Delete the vq on the freeze callback to prepare for hibernation.
> > > > > Re-create the vq in the restore callback to resume normal function.
> > > > > 
> > > > > Signed-off-by: Amit Shah <amit.shah@redhat.com>
> > > > > ---
> > > > >  drivers/block/virtio_blk.c |   17 +++++++++++++++++
> > > > >  1 files changed, 17 insertions(+), 0 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> > > > > index 509760b..9844d2c 100644
> > > > > --- a/drivers/block/virtio_blk.c
> > > > > +++ b/drivers/block/virtio_blk.c
> > > > > @@ -549,6 +549,19 @@ static void __devexit virtblk_remove(struct virtio_device *vdev)
> > > > >  	kfree(vblk);
> > > > >  }
> > > > >  
> > > > > +#ifdef CONFIG_PM
> > > > > +static int virtblk_freeze(struct virtio_device *vdev)
> > > > > +{
> > > > > +	vdev->config->del_vqs(vdev);
> > > > 
> > > > What prevents the guest from trying to use the VQ while
> > > > this is in progress? IF it does, what prevents a crash?
> > > 
> > > An oversight: Sasha pointed this out, too, and I've now fixed this by
> > > adding a call to vdev->config->reset() before deleting vqs.
> > 
> > This stops the host from accessing the VQ, but does not stop the *guest*.
> 
> Yes, have to ensure all pending IO is complete and nothing new is
> queued.
> 
> 
> 		Amit

reset will effectively cancel pending requests, maybe that
will help.

Also, same concern applies to all virtio devices really.

-- 
MST
