Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab1DFChG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 22:37:06 -0400
Received: from ozlabs.org ([203.10.76.45]:33718 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754248Ab1DFChE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 22:37:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jens Axboe <jaxboe@fusionio.com>, Takuma Umeya <tumeya@redhat.com>
Cc: "virtualization\@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, john cooper <john.cooper@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] virtio_blk: decrement index when blockdevice is removed
In-Reply-To: <4D9AA3BC.6030907@fusionio.com>
References: <1969774563.659835.1301978981017.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com> <4D9AA3BC.6030907@fusionio.com>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Wed, 06 Apr 2011 11:02:08 +0930
Message-ID: <87hbacw4fb.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Apr 2011 07:08:12 +0200, Jens Axboe <jaxboe@fusionio.com> wrote:
> On 2011-04-05 06:49, Takuma Umeya wrote:
> > When virtio block device is removed, index does not get decremented. When 
> > another virtio disk is attached it uses the next device letter to the 
> > one that is suppose to be available. 
> > 
> > Signed-off-by: Takuma Umeya <tumeya@redhat.com>
> > 
> > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> > index 6ecf89c..730e7af 100644
> > --- a/drivers/block/virtio_blk.c
> > +++ b/drivers/block/virtio_blk.c
> > @@ -489,6 +489,7 @@ static void __devexit virtblk_remove(struct virtio_device *vdev)
> >         mempool_destroy(vblk->pool);
> >         vdev->config->del_vqs(vdev);
> >         kfree(vblk);
> > +       index--;
> >  }
> >  
> >  static const struct virtio_device_id id_table[] = {
> 
> What happens when you delete a device that isn't the last one?

Obviously we should do something cleverer for assigning drives.

It might be a cute if genhd gave us a function to get the next free
index for a given major number, and format it for us, like so:

      /* Return the next available minor for a given @major, at least
       * @spacing after the previous and, and append appropriate letters
       * to @name if it's not NULL.  -ve errno on fail (-ENOSPC?). */
      int disk_next_minor(int major, unsigned spacing, char *name);

A trivial optimization would be to remember the last major and max minor
(resetting that if any disks are removed).

This could clean up other code, too.

Cheers,
Rusty.
