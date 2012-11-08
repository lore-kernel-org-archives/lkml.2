Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705Ab2KHLuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 06:50:13 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:61724 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab2KHLuK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 06:50:10 -0500
MIME-Version: 1.0
In-Reply-To: <1352371427-32363-1-git-send-email-cornelia.huck@de.ibm.com>
References: <1352371427-32363-1-git-send-email-cornelia.huck@de.ibm.com>
Date: Thu, 8 Nov 2012 12:50:09 +0100
Message-ID: <CAJK669bgpLoypjBWn4qs4pAizcnzR7g7zsszjTyCQ4QtOAPdjg@mail.gmail.com>
Subject: Re: [PATCH] virtio: Don't access index after unregister.
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 8, 2012 at 11:43 AM, Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> Virtio wants to release used indices after the corresponding
> virtio device has been unregistered. However, virtio does not
> hold an extra reference, giving up its last reference with
> device_unregister(), making accessing dev->index afterwards
> invalid.
>
> I actually saw problems when testing my (not-yet-merged)
> virtio-ccw code:
>
> - device_add virtio-net,id=xxx
> -> creates device virtio<n> with n>0
>
> - device_del xxx
> -> deletes virtio<n>, but calls ida_simple_remove with an
>    index of 0
>
> - device_add virtio-net,id=xxx
> -> tries to add virtio0, which is still in use...
>
> So let's save the index we want to release before calling
> device_unregister().
>
> Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> ---
>  drivers/virtio/virtio.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index 1e8659c..809b0de 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -225,8 +225,10 @@ EXPORT_SYMBOL_GPL(register_virtio_device);
>
>  void unregister_virtio_device(struct virtio_device *dev)
>  {
> +       int index = dev->index; /* save for after device release */
> +
>         device_unregister(&dev->dev);
> -       ida_simple_remove(&virtio_index_ida, dev->index);
> +       ida_simple_remove(&virtio_index_ida, index);
>  }
>  EXPORT_SYMBOL_GPL(unregister_virtio_device);

Acked-by: Sjur Brændeland <sjur.brandeland@stericsson.com>

Great minds think alike! I discovered issues with this implementation
a while back and Michael suggested an identical patch:
https://lkml.org/lkml/2012/9/4/173
https://lkml.org/lkml/2012/9/7/105

The issue I ran into was that when virtio devices are created by remoteproc
the device memory might be freed when calling  device_unregister(), and
the value of dev->index is then undefined. So this bug bites when
unregistering a Virtio devices from remoteproc with CONFIG_DEBUG_SLAB
enabled. However this bug is not triggered by virtio_pci as it implements a
non-standard device release-function that does not free the device memory.

Thanks,
Sjur
