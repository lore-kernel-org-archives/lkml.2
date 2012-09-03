Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab2ICO5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 10:57:48 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:65337 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab2ICO5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 10:57:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120903143018.GA5353@redhat.com>
References: <1346680277-5887-1-git-send-email-sjur.brandeland@stericsson.com>
	<20120903143018.GA5353@redhat.com>
Date: Mon, 3 Sep 2012 16:57:45 +0200
Message-ID: <CAJK669bkHHMAPYMEr22-6uOwfgJv1uKTbzNBQVVCq=OooExC0g@mail.gmail.com>
Subject: Re: [RFC 1/2] virtio_console: Add support for DMA memory allocation
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

> How does access to descriptors work in this setup?

When the ring is setup by remoteproc the descriptors are
also allocated using dma_alloc_coherent().

>> -static void free_buf(struct port_buffer *buf)
>> +/* Allcoate data buffer from DMA memory if requested */
>
> typo

Thanks.

>> +static inline void *
>> +alloc_databuf(struct virtio_device *vdev, size_t size, dma_addr_t *dma_handle,
>> +                gfp_t flag)
>>  {
>> -     kfree(buf->buf);
>> +#ifdef CONFIG_HAS_DMA
>> +     if (virtio_has_feature(vdev, VIRTIO_CONSOLE_F_DMA_MEM)) {
>> +             struct device *dev = &vdev->dev;
>> +             /*
>> +              * Allocate DMA memory from ancestors. Finding the ancestor
>> +              * is a bit quirky when DMA_MEMORY_INCLUDES_CHILDREN is not
>> +              * implemented.
>> +              */
>> +             dev = dev->parent ? dev->parent : dev;
>> +             dev = dev->parent ? dev->parent : dev;
>> +             return dma_alloc_coherent(dev, size, dma_handle, flag);
>> +     }
>> +#endif
>
> Are these ifdefs really needed? If DMA_MEM is set,
> can't we use dma_alloc_coherent
> unconditionally?

If an architecture do not support DMA you will get
a link error: "unknown symbol" for dma_alloc_coherent.

Regards,
Sjur
