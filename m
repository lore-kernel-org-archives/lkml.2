Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab1DEGV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 02:21:59 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52231 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1DEGV5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 02:21:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rwgKP2XDy3A/wpet58GPuLpsrtOCd4IHcLRRDvqm2Q4uXK7ygA9R8D8lcXnlfFT+nu
         9Is77Ty1mv3C451HjbP2fOHe+9szM5ONjEQ5lrT79q3++09SJxWG2pvEQh7pcROuBFbw
         +ZFZLHAVjOwogWqGS7neGiqahe/BTrFnhgvbo=
MIME-Version: 1.0
In-Reply-To: <66015840.659833.1301978966706.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <1457566934.641329.1301903526622.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
	<66015840.659833.1301978966706.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Date: Tue, 5 Apr 2011 07:21:56 +0100
Message-ID: <BANLkTi=DGfKuapLhvt62UVG_h7fzsRRo3g@mail.gmail.com>
Subject: Re: [PATCH] virtio: decrement dev_index when device is unregistered
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Takuma Umeya <tumeya@redhat.com>
Cc: virtualization@lists.linux-foundation.org,
        Stephen Hemminger <shemminger@vyatta.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 5, 2011 at 5:49 AM, Takuma Umeya <tumeya@redhat.com> wrote:
> When virtio device is removed, dev_index does not get decremented.
> The next device hotplug event results in consuming the next pci to
> the one that is suppose to be available.
>
> Signed-off-by: Takuma Umeya <tumeya@redhat.com>
>
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index efb35aa..67fe71d 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -216,6 +216,7 @@ EXPORT_SYMBOL_GPL(register_virtio_device);
>  void unregister_virtio_device(struct virtio_device *dev)
>  {
>        device_unregister(&dev->dev);
> +       dev_index--;

I don't think there is any guarantee that virtio devices are
added/removed in first-in-last-out order.

That means I could add a virtio-net device (index 0) followed by a
virtio-blk device (index 1).  Now I remove the virtio-net device
(index 0) which causes me to decrement dev_index and hand index 1 out
again to the next device.  This leaves us with virtio-blk (index 1)
and the new device with index 1, which is not unique.

Perhaps I missed a constraint which prevents this from occurring?

Stefan
