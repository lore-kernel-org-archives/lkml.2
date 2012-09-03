Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab2ICOuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 10:50:13 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52675 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab2ICOuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 10:50:12 -0400
MIME-Version: 1.0
In-Reply-To: <20120903141445.GA5054@redhat.com>
References: <1346680242-5717-1-git-send-email-sjur.brandeland@stericsson.com>
	<20120903141445.GA5054@redhat.com>
Date: Mon, 3 Sep 2012 16:50:10 +0200
Message-ID: <CAJK669aRsbOOmjmT+K8OHYvenOhkYWuSOx6nBM7hxC_C4mmw-g@mail.gmail.com>
Subject: Re: [PATCH] virtio: Don't access device data after unregistration.
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        "Guzman Lugo, Fernadndo" <fernando.lugo@ti.com>,
        virtualization@lists.linux-foundation.org,
        Ohad Ben-Cohen <ohad@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

>> Fix panic in virtio.c when CONFIG_DEBUG_SLAB is set.
>
> What's the root cause of the panic?

I believe the cause of the panic is calling
ida_simple_remove(&virtio_index_ida, dev->index);
when the dev structure is "poisoned" after kfree.
It might be the "BUG_ON((int)id < 0)" that bites...

>> Use device_del() and put_device() instead of
>> device_unregister(), and access device data before
>> calling put_device().

> Why does this help? Does device_unregister free the
> device so dev->index access crashes?

Yes, if device ref-count is one when calling unregister
the device is freed.

> If yes virtio_pci_remove will crash too
> as it accesses the device after the
> call to unregister_virtio_device so the
> fix won't be effective.

I discovered this using the remoteproc framework.
It might be that device is unregistered with ref-count greater
than one normally, in that case this bug will not show up.

Regards,
Sjur
