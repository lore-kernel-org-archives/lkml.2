Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab1KQMfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 07:35:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab1KQMfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 07:35:07 -0500
Date: Thu, 17 Nov 2011 14:36:32 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        levinsasha928@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 11/11] virtio: balloon: Add freeze, restore handlers
 to support S4
Message-ID: <20111117123632.GF19682@redhat.com>
References: <cover.1321530505.git.amit.shah@redhat.com>
 <1147d4f726e51f2e03a84f3732d60ccd0d8e480c.1321530505.git.amit.shah@redhat.com>
 <20111117122508.GB19682@redhat.com>
 <20111117122920.GB2873@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111117122920.GB2873@amit-x200.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 05:59:20PM +0530, Amit Shah wrote:
> On (Thu) 17 Nov 2011 [14:25:08], Michael S. Tsirkin wrote:
> > On Thu, Nov 17, 2011 at 05:27:42PM +0530, Amit Shah wrote:
> > > Delete the vqs on the freeze callback to prepare for hibernation.
> > > Re-create the vqs in the restore callback to resume normal function.
> > > 
> > > Signed-off-by: Amit Shah <amit.shah@redhat.com>
> > > ---
> > >  drivers/virtio/virtio_balloon.c |   20 ++++++++++++++++++++
> > >  1 files changed, 20 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> > > index 1ff3cf4..90149d1 100644
> > > --- a/drivers/virtio/virtio_balloon.c
> > > +++ b/drivers/virtio/virtio_balloon.c
> > > @@ -363,6 +363,22 @@ static void __devexit virtballoon_remove(struct virtio_device *vdev)
> > >  	kfree(vb);
> > >  }
> > >  
> > > +#ifdef CONFIG_PM
> > > +static int virtballoon_freeze(struct virtio_device *vdev)
> > > +{
> > > +	/* Now we reset the device so we can clean up the queues. */
> > > +	vdev->config->reset(vdev);
> > > +
> > 
> > This is a weird thing to do. We normally delete vqs then reset.
> 
> No, all the drivers first reset, then delete.

BTW, reset does not flush callbacks at the moment.
It probably should.

> > For example, I don't know whether we guarantee what happens
> > to MSI-X vectors assigned meanwhile if you reset.
> > IIRC qemu doesn't use MSI-X for the balloon, but nothing
> > prevents it.
> > 
> > > +	vdev->config->del_vqs(vdev);
> > 
> > What prevents requests being submitted at this point?
> > I see all kind of handling of freezing in the balloon thread ...
> > maybe that gives us some guarantees, but if yes
> > it makes sense to add a comment to point this out.
> 
> Once reset, the host won't write anything to the vqs anyway..
> 
> 		Amit

But thread might have already been scheduled, handling
previous requests.

-- 
MST
