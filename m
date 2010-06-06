Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab0FFJPx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 05:15:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361Ab0FFJPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 05:15:51 -0400
Date: Sun, 6 Jun 2010 12:11:22 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, qemu-devel@nongnu.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv3 1/2] virtio: support layout with avail ring before idx
Message-ID: <20100606091122.GC22599@redhat.com>
References: <cover.1275403477.git.mst@redhat.com> <201006042046.49872.rusty@rustcorp.com.au> <20100604114205.GA22599@redhat.com> <201006051340.27194.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006051340.27194.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 05, 2010 at 01:40:26PM +0930, Rusty Russell wrote:
> On Fri, 4 Jun 2010 09:12:05 pm Michael S. Tsirkin wrote:
> > On Fri, Jun 04, 2010 at 08:46:49PM +0930, Rusty Russell wrote:
> > > I'm uncomfortable with moving a field.
> > > 
> > > We haven't done that before and I wonder what will break with old code.
> > 
> > With e.g. my patch, We only do this conditionally when bit is negotitated.
> 
> Of course, but see this change:
> 
> commit ef688e151c00e5d529703be9a04fd506df8bc54e
> Author: Rusty Russell <rusty@rustcorp.com.au>
> Date:   Fri Jun 12 22:16:35 2009 -0600
> 
>     virtio: meet virtio spec by finalizing features before using device
>     
>     Virtio devices are supposed to negotiate features before they start using
>     the device, but the current code doesn't do this.  This is because the
>     driver's probe() function invariably has to add buffers to a virtqueue,
>     or probe the disk (virtio_blk).
>     
>     This currently doesn't matter since no existing backend is strict about
>     the feature negotiation.  But it's possible to imagine a future feature
>     which completely changes how a device operates: in this case, we'd need
>     to acknowledge it before using the device.
>     
>     Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> Now, this isn't impossible to overcome: we know that if they use the ring
> before completing feature negotiation then they don't understand the new
> format.
> 
> But we have to be aware of that on the qemu side.  Are we?

I think we are ok. virtqueue_init which sets the avail/ysed pointers is
called when we write the base address.  So we only need to be careful
and not change this feature bit after creating the rings.


> > > Should we instead just abandon the flags field and use last_used only?
> > > Or, more radically, put flags == last_used when the feature is on?
> > > 
> > > Thoughts?
> > > Rusty.
> > 
> > Hmm, e.g. with TX and virtio net, we almost never want interrupts,
> > whatever the index value.
> 
> Good point.  OK, I give in, I'll take your patch which moves the fields
> to the end.  Is that your preference?

Yes, I think so.
You mean PATCHv3 unchanged with 254 byte padding?

> Please be careful with the qemu side though...
> 
> It's not inconceivable that I'll write that virtio cacheline simulator this
> (coming) week, too...
> 
> Thanks.
> Rusty.


