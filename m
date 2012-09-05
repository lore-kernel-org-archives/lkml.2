Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128Ab2IESPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 14:15:39 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49422 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab2IESPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 14:15:37 -0400
MIME-Version: 1.0
In-Reply-To: <20120905143558.GB10925@redhat.com>
References: <1346680277-5887-1-git-send-email-sjur.brandeland@stericsson.com>
	<20120903143018.GA5353@redhat.com>
	<CAJK669bkHHMAPYMEr22-6uOwfgJv1uKTbzNBQVVCq=OooExC0g@mail.gmail.com>
	<20120903202737.GD6181@redhat.com>
	<87zk56e2xc.fsf@rustcorp.com.au>
	<CAJK669bUXHqaDUZDNZ9i85pRKENUMS_RXw4z7BsSq7Hiw=OOfg@mail.gmail.com>
	<20120905143558.GB10925@redhat.com>
Date: Wed, 5 Sep 2012 20:15:36 +0200
Message-ID: <CAJK669bhVfgnxuF6wVtdnzs2bgiJ2HzgwfWw4uZ=EqTdm43Jow@mail.gmail.com>
Subject: Re: [RFC 1/2] virtio_console: Add support for DMA memory allocation
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ohad Ben-Cohen <ohad@wizery.com>
Cc: Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org,
        =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael.

>> If the device then asks for VIRTIO_CONSOLE_F_DMA_MEM
>> when DMA is not supported, virtio will do BUG_ON() from
>> virtio_check_driver_offered_feature().
>>
>> Is this acceptable or should we add a check in virtcons_probe()
>> and let the probing fail instead?
>>
>> E.g:
>>       /* Refuse to bind if F_DMA_MEM request cannot be met */
>>       if (!VIRTIO_CONSOLE_HAS_DMA &&
>>           (vdev->config->get_features(vdev) & (1 << VIRTIO_CONSOLE_F_DMA_MEM))){
>>               dev_err(&vdev->dev,
>>                       "DMA_MEM requested, but arch does not support DMA\n");
>>               err = -EINVAL;
>>               goto fail;
>>       }
>>
>> Regards,
>> Sjur
>
> Failing probe would be cleaner. But there is still a problem:
> old driver will happily bind to that device and then
> fail to work, right?

Not just fail to work, the kernel will panic on the BUG_ON().
Remoteproc gets the virtio configuration from firmware loaded
from user space. So this type of problem might be triggered
for other virtio drivers as well.


> virtio pci has revision id for this, but remoteproc doesn't
> seem to have anything similar. Or did I miss it?

No there are currently no sanity check of
virtio type and feature bits in remoteproc.
One option may be to add this...

> If not -
> we probably need to use a different
> device id, and not a feature bit.

But if I create a new virtio console type, remoteproc
could still call the existing virtio_console with random
bad feature bits, causing kernel panic.

Even if we fix this particular problem, the general problem
still exists: bogus virtio declarations in remoteproc's firmware
may cause BUG_ON(). (Note the fundamental difference
between visualizations and remoteproc. For remoteproc
the virtio configuration comes from binaries loaded from
user space).

So maybe we should look for a more generic solution, e.g.
changing virtio probe functionality so that devices with
bad feature bits will not trigger BUG_ON(), but rather refuse
to bind the driver.

Regards,
Sjur
