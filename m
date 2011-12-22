Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab1LVMUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 07:20:05 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53768 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1LVMUD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 07:20:03 -0500
MIME-Version: 1.0
In-Reply-To: <1324429254-28383-5-git-send-email-minchan@kernel.org>
References: <1324429254-28383-1-git-send-email-minchan@kernel.org>
	<1324429254-28383-5-git-send-email-minchan@kernel.org>
Date: Thu, 22 Dec 2011 12:20:01 +0000
Message-ID: <CAJSP0QWbkdQhXtrkO6zKrCBACRWcpD3cFz37O+uJ5s=OimSFPw@mail.gmail.com>
Subject: Re: [PATCH 4/6] virtio-blk: implement ->make_request
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Chris Wright <chrisw@sous-sol.org>,
        Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>, Minchan Kim <minchan@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 1:00 AM, Minchan Kim <minchan@kernel.org> wrote:
> +static void virtblk_add_buf_wait(struct virtio_blk *vblk,
> +       struct virtblk_req *vbr, unsigned long out, unsigned long in)
> +{
> +       DEFINE_WAIT(wait);
> +       bool retry, notify;
> +
> +       for (;;) {
> +               prepare_to_wait(&vblk->queue_wait, &wait,
> +                               TASK_UNINTERRUPTIBLE);
> +
> +               spin_lock_irq(&vblk->lock);
> +               if (virtqueue_add_buf(vblk->vq, vbr->sg,
> +                       out, in, vbr) < 0) {
> +                       retry = true;
> +               } else {
> +                       retry = false;
> +               }
> +               notify = virtqueue_kick_prepare(vblk->vq);
> +               spin_unlock_irq(&vblk->lock);
> +
> +               if (notify)

virtblk_make_request() checks that the queue is not plugged.  Do we
need to do that here too?
