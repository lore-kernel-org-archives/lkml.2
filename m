Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab0J1I5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 04:57:41 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:50071 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab0J1I5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 04:57:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=c9fNdI9+TtUxWz5i5ak3IC5UKXv/RtE9f7Nh5aUcsXaG2GnKMhUAFEUQ9XSYLkCTgP
         M6NcGZXDj1gDL9wSgmWsR+etsFfBfm3MIL6zfJDQuwb2ll/5cpD92/Qdwqd9aOtLFUbh
         bJVe/u3slIEOtJco4kFrzDz87g1g1xvu+jxXs=
MIME-Version: 1.0
In-Reply-To: <1288213557.17571.28.camel@localhost.localdomain>
References: <1288213257.17571.25.camel@localhost.localdomain>
	<1288213557.17571.28.camel@localhost.localdomain>
Date: Thu, 28 Oct 2010 09:57:38 +0100
Message-ID: <AANLkTinqG_G2pevoYJyiHiBda1ZZS-53Uqz9WEspbMOy@mail.gmail.com>
Subject: Re: [RFC PATCH 0/1] vhost: Reduce TX used buffer signal for performance
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: "mst@redhat.com" <mst@redhat.com>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 10:05 PM, Shirley Ma <mashirle@us.ibm.com> wrote:
> This patch changes vhost TX used buffer signal to guest from one by
> one to up to 3/4 of vring size. This change improves vhost TX message
> size from 256 to 8K performance for both bandwidth and CPU utilization
> without inducing any regression.

Any concerns about introducing latency or does the guest not care when
TX completions come in?

> Signed-off-by: Shirley Ma <xma@us.ibm.com>
> ---
>
>  drivers/vhost/net.c   |   19 ++++++++++++++++++-
>  drivers/vhost/vhost.c |   31 +++++++++++++++++++++++++++++++
>  drivers/vhost/vhost.h |    3 +++
>  3 files changed, 52 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 4b4da5b..bd1ba71 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -198,7 +198,24 @@ static void handle_tx(struct vhost_net *net)
>                if (err != len)
>                        pr_debug("Truncated TX packet: "
>                                 " len %d != %zd\n", err, len);
> -               vhost_add_used_and_signal(&net->dev, vq, head, 0);
> +               /*
> +                * if no pending buffer size allocate, signal used buffer
> +                * one by one, otherwise, signal used buffer when reaching
> +                * 3/4 ring size to reduce CPU utilization.
> +                */
> +               if (unlikely(vq->pend))
> +                       vhost_add_used_and_signal(&net->dev, vq, head, 0);
> +               else {
> +                       vq->pend[vq->num_pend].id = head;

I don't understand the logic here: if !vq->pend then we assign to
vq->pend[vq->num_pend].

> +                       vq->pend[vq->num_pend].len = 0;
> +                       ++vq->num_pend;
> +                       if (vq->num_pend == (vq->num - (vq->num >> 2))) {
> +                               vhost_add_used_and_signal_n(&net->dev, vq,
> +                                                           vq->pend,
> +                                                           vq->num_pend);
> +                               vq->num_pend = 0;
> +                       }
> +               }
>                total_len += len;
>                if (unlikely(total_len >= VHOST_NET_WEIGHT)) {
>                        vhost_poll_queue(&vq->poll);
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 94701ff..47696d2 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -170,6 +170,16 @@ static void vhost_vq_reset(struct vhost_dev *dev,
>        vq->call_ctx = NULL;
>        vq->call = NULL;
>        vq->log_ctx = NULL;
> +       /* signal pending used buffers */
> +       if (vq->pend) {
> +               if (vq->num_pend != 0) {
> +                       vhost_add_used_and_signal_n(dev, vq, vq->pend,
> +                                                   vq->num_pend);
> +                       vq->num_pend = 0;
> +               }
> +               kfree(vq->pend);
> +       }
> +       vq->pend = NULL;
>  }
>
>  static int vhost_worker(void *data)
> @@ -273,7 +283,13 @@ long vhost_dev_init(struct vhost_dev *dev,
>                dev->vqs[i].heads = NULL;
>                dev->vqs[i].dev = dev;
>                mutex_init(&dev->vqs[i].mutex);
> +               dev->vqs[i].num_pend = 0;
> +               dev->vqs[i].pend = NULL;
>                vhost_vq_reset(dev, dev->vqs + i);
> +               /* signal 3/4 of ring size used buffers */
> +               dev->vqs[i].pend = kmalloc((dev->vqs[i].num -
> +                                          (dev->vqs[i].num >> 2)) *
> +                                          sizeof *vq->peed, GFP_KERNEL);

Has this patch been compile tested?  vq->peed?

Stefan
