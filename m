Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234Ab2IETPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 15:15:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648Ab2IETPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 15:15:46 -0400
Date: Wed, 5 Sep 2012 22:16:57 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sjur =?iso-8859-1?Q?Br=E6ndeland?= <sjurbren@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ohad Ben-Cohen <ohad@wizery.com>,
        Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org,
        Sjur =?iso-8859-1?Q?Br=E6ndeland?= 
	<sjur.brandeland@stericsson.com>
Subject: Re: [RFC 1/2] virtio_console: Add support for DMA memory allocation
Message-ID: <20120905191657.GA15868@redhat.com>
References: <1346680277-5887-1-git-send-email-sjur.brandeland@stericsson.com>
 <20120903143018.GA5353@redhat.com>
 <CAJK669bkHHMAPYMEr22-6uOwfgJv1uKTbzNBQVVCq=OooExC0g@mail.gmail.com>
 <20120903202737.GD6181@redhat.com>
 <87zk56e2xc.fsf@rustcorp.com.au>
 <CAJK669bUXHqaDUZDNZ9i85pRKENUMS_RXw4z7BsSq7Hiw=OOfg@mail.gmail.com>
 <20120905143558.GB10925@redhat.com>
 <CAJK669bhVfgnxuF6wVtdnzs2bgiJ2HzgwfWw4uZ=EqTdm43Jow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJK669bhVfgnxuF6wVtdnzs2bgiJ2HzgwfWw4uZ=EqTdm43Jow@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 08:15:36PM +0200, Sjur Brændeland wrote:
> Hi Michael.
> 
> >> If the device then asks for VIRTIO_CONSOLE_F_DMA_MEM
> >> when DMA is not supported, virtio will do BUG_ON() from
> >> virtio_check_driver_offered_feature().
> >>
> >> Is this acceptable or should we add a check in virtcons_probe()
> >> and let the probing fail instead?
> >>
> >> E.g:
> >>       /* Refuse to bind if F_DMA_MEM request cannot be met */
> >>       if (!VIRTIO_CONSOLE_HAS_DMA &&
> >>           (vdev->config->get_features(vdev) & (1 << VIRTIO_CONSOLE_F_DMA_MEM))){
> >>               dev_err(&vdev->dev,
> >>                       "DMA_MEM requested, but arch does not support DMA\n");
> >>               err = -EINVAL;
> >>               goto fail;
> >>       }
> >>
> >> Regards,
> >> Sjur
> >
> > Failing probe would be cleaner. But there is still a problem:
> > old driver will happily bind to that device and then
> > fail to work, right?
> 
> Not just fail to work, the kernel will panic on the BUG_ON().
> Remoteproc gets the virtio configuration from firmware loaded
> from user space. So this type of problem might be triggered
> for other virtio drivers as well.

how?

> 
> > virtio pci has revision id for this, but remoteproc doesn't
> > seem to have anything similar. Or did I miss it?
> 
> No there are currently no sanity check of
> virtio type and feature bits in remoteproc.
> One option may be to add this...

you can not fix the past.

> > If not -
> > we probably need to use a different
> > device id, and not a feature bit.
> 
> But if I create a new virtio console type, remoteproc
> could still call the existing virtio_console with random
> bad feature bits, causing kernel panic.

cirtio core checks device id - this should not happen.


> Even if we fix this particular problem, the general problem
> still exists: bogus virtio declarations in remoteproc's firmware
> may cause BUG_ON().

which BUG_ON exactly?

> (Note the fundamental difference
> between visualizations and remoteproc. For remoteproc
> the virtio configuration comes from binaries loaded from
> user space).
> 
> So maybe we should look for a more generic solution, e.g.
> changing virtio probe functionality so that devices with
> bad feature bits will not trigger BUG_ON(), but rather refuse
> to bind the driver.
> 
> Regards,
> Sjur
