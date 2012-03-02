Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965389Ab2CBV0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 16:26:18 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50645 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758004Ab2CBV0R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 16:26:17 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of robdclark@gmail.com designates 10.52.24.139 as permitted sender) smtp.mail=robdclark@gmail.com; dkim=pass header.i=robdclark@gmail.com
MIME-Version: 1.0
In-Reply-To: <1330616161-1937-2-git-send-email-daniel.vetter@ffwll.ch>
References: <1330616161-1937-1-git-send-email-daniel.vetter@ffwll.ch>
	<1330616161-1937-2-git-send-email-daniel.vetter@ffwll.ch>
Date: Fri, 2 Mar 2012 15:26:16 -0600
X-Google-Sender-Auth: 7ZZ36qxaXmljUnpyeAjPj2YETuE
Message-ID: <CAF6AEGsfC-BM2DvFn457pMhE-b_Mr5O4RgaP5WVO78QwRBe-5g@mail.gmail.com>
Subject: Re: [PATCH 1/3] dma-buf: don't hold the mutex around map/unmap calls
From: Rob Clark <rob.clark@linaro.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: linaro-mm-sig@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 9:35 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> The mutex protects the attachment list and hence needs to be held
> around the callbakc to the exporters (optional) attach/detach
> functions.
>
> Holding the mutex around the map/unmap calls doesn't protect any
> dma_buf state. Exporters need to properly protect any of their own
> state anyway (to protect against calls from their own interfaces).
> So this only makes the locking messier (and lockdep easier to anger).
>
> Therefore let's just drop this.
>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Reviewed-by: Rob Clark <rob.clark@linaro.org>

> ---
>  drivers/base/dma-buf.c  |    4 ----
>  include/linux/dma-buf.h |    2 +-
>  2 files changed, 1 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
> index e38ad24..1b11192 100644
> --- a/drivers/base/dma-buf.c
> +++ b/drivers/base/dma-buf.c
> @@ -258,10 +258,8 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
>        if (WARN_ON(!attach || !attach->dmabuf || !attach->dmabuf->ops))
>                return ERR_PTR(-EINVAL);
>
> -       mutex_lock(&attach->dmabuf->lock);
>        if (attach->dmabuf->ops->map_dma_buf)
>                sg_table = attach->dmabuf->ops->map_dma_buf(attach, direction);
> -       mutex_unlock(&attach->dmabuf->lock);
>
>        return sg_table;
>  }
> @@ -282,10 +280,8 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
>                            || !attach->dmabuf->ops))
>                return;
>
> -       mutex_lock(&attach->dmabuf->lock);
>        if (attach->dmabuf->ops->unmap_dma_buf)
>                attach->dmabuf->ops->unmap_dma_buf(attach, sg_table);
> -       mutex_unlock(&attach->dmabuf->lock);
>
>  }
>  EXPORT_SYMBOL_GPL(dma_buf_unmap_attachment);
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index f8ac076..f7ad2ca 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -86,7 +86,7 @@ struct dma_buf {
>        struct file *file;
>        struct list_head attachments;
>        const struct dma_buf_ops *ops;
> -       /* mutex to serialize list manipulation and other ops */
> +       /* mutex to serialize list manipulation and attach/detach */
>        struct mutex lock;
>        void *priv;
>  };
> --
> 1.7.7.5
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
