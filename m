Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab2FRJhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 05:37:11 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:56872 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754100Ab2FRJhI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:37:08 -0400
MIME-Version: 1.0
In-Reply-To: <1340002390-3950-4-git-send-email-asias@redhat.com>
References: <1340002390-3950-1-git-send-email-asias@redhat.com>
	<1340002390-3950-4-git-send-email-asias@redhat.com>
Date: Mon, 18 Jun 2012 10:37:06 +0100
Message-ID: <CAJSP0QV8LWVFe0BFjmzuhm7+zHtm4Ye76zBwyk9HVGNKFhHikw@mail.gmail.com>
Subject: Re: [PATCH 3/3] virtio-blk: Add bio-based IO path for virtio-blk
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Asias He <asias@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Christoph Hellwig <hch@lst.de>, "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 7:53 AM, Asias He <asias@redhat.com> wrote:
> +static void virtblk_add_buf_wait(struct virtio_blk *vblk,
> +                                struct virtblk_req *vbr,
> +                                unsigned long out,
> +                                unsigned long in)
> +{
> +       DEFINE_WAIT(wait);
> +
> +       for (;;) {
> +               prepare_to_wait_exclusive(&vblk->queue_wait, &wait,
> +                                         TASK_UNINTERRUPTIBLE);
> +
> +               spin_lock_irq(vblk->disk->queue->queue_lock);
> +               if (virtqueue_add_buf(vblk->vq, vbr->sg, out, in, vbr,
> +                                     GFP_ATOMIC) < 0) {
> +                       spin_unlock_irq(vblk->disk->queue->queue_lock);
> +                       io_schedule();
> +               } else {
> +                       virtqueue_kick(vblk->vq);
> +                       spin_unlock_irq(vblk->disk->queue->queue_lock);
> +                       break;
> +               }
> +
> +       }

Is there a meaningful condition where we would cancel this request
(e.g. signal)?  If the vring fills up for some reason and we get stuck
here the user might wish to kill hung processes.

Stefan
