Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab2IENAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 09:00:23 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60895 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2IENAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 09:00:21 -0400
MIME-Version: 1.0
In-Reply-To: <87zk56e2xc.fsf@rustcorp.com.au>
References: <1346680277-5887-1-git-send-email-sjur.brandeland@stericsson.com>
	<20120903143018.GA5353@redhat.com>
	<CAJK669bkHHMAPYMEr22-6uOwfgJv1uKTbzNBQVVCq=OooExC0g@mail.gmail.com>
	<20120903202737.GD6181@redhat.com>
	<87zk56e2xc.fsf@rustcorp.com.au>
Date: Wed, 5 Sep 2012 15:00:20 +0200
Message-ID: <CAJK669bUXHqaDUZDNZ9i85pRKENUMS_RXw4z7BsSq7Hiw=OOfg@mail.gmail.com>
Subject: Re: [RFC 1/2] virtio_console: Add support for DMA memory allocation
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org,
        =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The driver certainly shouldn't offer VIRTIO_CONSOLE_F_DMA_MEM if you
> don't have DMA!

OK, so the feature table could be done like this:

 static unsigned int features[] = {
	VIRTIO_CONSOLE_F_SIZE,
	VIRTIO_CONSOLE_F_MULTIPORT,
#if VIRTIO_CONSOLE_HAS_DMA
	VIRTIO_CONSOLE_F_DMA_MEM,
#endif
}

If the device then asks for VIRTIO_CONSOLE_F_DMA_MEM
when DMA is not supported, virtio will do BUG_ON() from
virtio_check_driver_offered_feature().

Is this acceptable or should we add a check in virtcons_probe()
and let the probing fail instead?

E.g:
	/* Refuse to bind if F_DMA_MEM request cannot be met */
	if (!VIRTIO_CONSOLE_HAS_DMA &&
	    (vdev->config->get_features(vdev) & (1 << VIRTIO_CONSOLE_F_DMA_MEM))){
		dev_err(&vdev->dev,
			"DMA_MEM requested, but arch does not support DMA\n");
		err = -EINVAL;
		goto fail;
	}

Regards,
Sjur
