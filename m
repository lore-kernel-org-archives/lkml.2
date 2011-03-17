Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab1CQLxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 07:53:19 -0400
Received: from ozlabs.org ([203.10.76.45]:34571 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910Ab1CQLxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 07:53:18 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@lst.de>
Cc: Christoph Hellwig <hch@lst.de>, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org, stefanha@gmail.com, kwolf@redhat.com,
        prerna@linux.vnet.ibm.com, aliguori@us.ibm.com,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH, RFC] virtio_blk: add cache control support
In-Reply-To: <20110316140958.GB21877@lst.de>
References: <20110315141049.GA30627@lst.de> <20110315141644.GA30803@lst.de> <87y64fhfjw.fsf@rustcorp.com.au> <20110316140958.GB21877@lst.de>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Thu, 17 Mar 2011 15:36:08 +1030
Message-ID: <877hbygwu7.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Mar 2011 15:09:58 +0100, Christoph Hellwig <hch@lst.de> wrote:
> On Wed, Mar 16, 2011 at 02:39:39PM +1030, Rusty Russell wrote:
> > > +	if (strncmp(buf, "write through", sizeof("write through") - 1) == 0) {
> > > +		;
> > > +	} else if (strncmp(buf, "write back", sizeof("write back") - 1) == 0) {
> > 
> >    Is there a reason we're not letting gcc and/or strcmp do the
> > optimization work here?
> 
> I'm happ to switch strcmp.

Of course, that's assuming buf is nul terminated.

> > > +	vdev->config->set(vdev, offsetof(struct virtio_blk_config, features),
> > > +	                  &features, sizeof(features));
> > > +
> > > +	vdev->config->get(vdev, offsetof(struct virtio_blk_config, features),
> > > +			  &features2, sizeof(features2));
> > > +
> > > +	if ((features & VIRTIO_BLK_RT_WCE) !=
> > > +	    (features2 & VIRTIO_BLK_RT_WCE))
> > > +		return -EIO;
> > 
> >    This seems like a debugging check you left in.  Or do you suspect
> > some issues?
> 
> No, it's intentional.  config space writes can't return errors, so we need
> to check that the value has really changed.  I'll add a comment explaining it.

OK, under what circumstances could it fail?

If you're using this mechanism to indicate that the host doesn't support
the feature, that's making an assumption about the nature of config
space writes which isn't true for non-PCI virtio.

ie. lguest and S/390 don't trap writes to config space.

Or perhaps they should?  But we should be explicit about needing it...

Thanks,
Rusty.



