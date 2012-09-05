Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab2IEOet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 10:34:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab2IEOer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 10:34:47 -0400
Date: Wed, 5 Sep 2012 17:35:58 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sjur =?iso-8859-1?Q?Br=E6ndeland?= <sjurbren@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Amit Shah <amit.shah@redhat.com>,
        linux-kernel@vger.kernel.org, Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org,
        Sjur =?iso-8859-1?Q?Br=E6ndeland?= 
	<sjur.brandeland@stericsson.com>
Subject: Re: [RFC 1/2] virtio_console: Add support for DMA memory allocation
Message-ID: <20120905143558.GB10925@redhat.com>
References: <1346680277-5887-1-git-send-email-sjur.brandeland@stericsson.com>
 <20120903143018.GA5353@redhat.com>
 <CAJK669bkHHMAPYMEr22-6uOwfgJv1uKTbzNBQVVCq=OooExC0g@mail.gmail.com>
 <20120903202737.GD6181@redhat.com>
 <87zk56e2xc.fsf@rustcorp.com.au>
 <CAJK669bUXHqaDUZDNZ9i85pRKENUMS_RXw4z7BsSq7Hiw=OOfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJK669bUXHqaDUZDNZ9i85pRKENUMS_RXw4z7BsSq7Hiw=OOfg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 03:00:20PM +0200, Sjur Brændeland wrote:
> > The driver certainly shouldn't offer VIRTIO_CONSOLE_F_DMA_MEM if you
> > don't have DMA!
> 
> OK, so the feature table could be done like this:
> 
>  static unsigned int features[] = {
> 	VIRTIO_CONSOLE_F_SIZE,
> 	VIRTIO_CONSOLE_F_MULTIPORT,
> #if VIRTIO_CONSOLE_HAS_DMA
> 	VIRTIO_CONSOLE_F_DMA_MEM,
> #endif
> }
> 
> If the device then asks for VIRTIO_CONSOLE_F_DMA_MEM
> when DMA is not supported, virtio will do BUG_ON() from
> virtio_check_driver_offered_feature().
> 
> Is this acceptable or should we add a check in virtcons_probe()
> and let the probing fail instead?
> 
> E.g:
> 	/* Refuse to bind if F_DMA_MEM request cannot be met */
> 	if (!VIRTIO_CONSOLE_HAS_DMA &&
> 	    (vdev->config->get_features(vdev) & (1 << VIRTIO_CONSOLE_F_DMA_MEM))){
> 		dev_err(&vdev->dev,
> 			"DMA_MEM requested, but arch does not support DMA\n");
> 		err = -EINVAL;
> 		goto fail;
> 	}
> 
> Regards,
> Sjur

Failing probe would be cleaner. But there is still a problem:
old driver will happily bind to that device and then
fail to work, right?

virtio pci has revision id for this, but remoteproc doesn't
seem to have anything similar. Or did I miss it? If not -
we probably need to use a different
device id, and not a feature bit.

-- 
MST
