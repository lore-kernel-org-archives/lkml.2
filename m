Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab1KQMbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 07:31:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756975Ab1KQMbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 07:31:45 -0500
Date: Thu, 17 Nov 2011 14:33:11 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        levinsasha928@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 09/11] virtio: net: Add freeze, restore handlers to
 support S4
Message-ID: <20111117123311.GE19682@redhat.com>
References: <cover.1321530505.git.amit.shah@redhat.com>
 <85eca44fe83d2deabfdf402bfed72531ebad6026.1321530505.git.amit.shah@redhat.com>
 <20111117121907.GA19682@redhat.com>
 <20111117122706.GA2873@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111117122706.GA2873@amit-x200.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 05:57:06PM +0530, Amit Shah wrote:
> On (Thu) 17 Nov 2011 [14:19:09], Michael S. Tsirkin wrote:
> > On Thu, Nov 17, 2011 at 05:27:40PM +0530, Amit Shah wrote:
> 
> > > +#ifdef CONFIG_PM
> > > +static int virtnet_freeze(struct virtio_device *vdev)
> > > +{
> > > +	struct virtnet_info *vi = vdev->priv;
> > > +
> > > +	netif_device_detach(vi->dev);
> > > +	remove_vq_common(vi);
> > 
> > This stops TX in progress, if any, but not RX
> > which might use the RX VQ. Then remove_vq_common
> > might delete this VQ while it's still in use.
> > 
> > So I think we need to call something like napi_disable.
> > However, the subtle twist is that we need to call that
> > *after interrupts have been disabled*.
> > Otherwise we might schedule another napi callback.
> 
> resetting the vqs will mean the host won't pass us any data in the
> vqs.  Plus we're removing the vqs altogether.  Also, we're disabling
> the pci device in virtio_pci.c, so all of these actions will take
> care of that, isn't it?

I don't think so.

> In addition, once the vqs are taken off, there's no chance for any
> other rx to happen, so napi_disable() after plugging off vqs doesn't
> make sense.
> 
> 		Amit


Yes but napi might have been scheduled before remove_vq_common was
called, and run afterwards.

-- 
MST
