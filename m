Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab2DXQhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 12:37:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51534 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506Ab2DXQhw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 12:37:52 -0400
MIME-Version: 1.0
In-Reply-To: <1335258532-20739-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1335258532-20739-1-git-send-email-daniel.vetter@ffwll.ch>
Date: Wed, 25 Apr 2012 01:37:51 +0900
Message-ID: <CAAQKjZMgcxWc44xknM+eZhon4QgvWd92Ci4snwBv2Ziyw1Recw@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: mmap support
From: InKi Dae <daeinki@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: linaro-mm-sig@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Rob Clark <rob.clark@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>
> +static int dma_buf_mmap_internal(struct file *file, struct vm_area_struct *vma)
> +{
> +       struct dma_buf *dmabuf;
> +
> +       if (!is_dma_buf_file(file))
> +               return -EINVAL;
> +
> +       dmabuf = file->private_data;
> +
> +       /* check for overflowing the buffer's size */
> +       if (vma->vm_pgoff + ((vma->vm_end - vma->vm_start) >> PAGE_SHIFT) >
> +           dmabuf->size >> PAGE_SHIFT)

is this condition right? your intention is for checking buffer's size
is valid or not. by the way why is vma->vm_pgoff added to vm region
size?

> +               return -EINVAL;
> +
> +       return dmabuf->ops->mmap(dmabuf, vma);
> +}
> +
>  static const struct file_operations dma_buf_fops = {
>        .release        = dma_buf_release,
> +       .mmap           = dma_buf_mmap_internal,
>  };
>
>  /*
> @@ -82,7 +100,8 @@ struct dma_buf *dma_buf_export(void *priv, const struct dma_buf_ops *ops,
>                          || !ops->unmap_dma_buf
>                          || !ops->release
>                          || !ops->kmap_atomic
> -                         || !ops->kmap)) {
> +                         || !ops->kmap
> +                         || !ops->mmap)) {
>                return ERR_PTR(-EINVAL);
>        }
>
> @@ -406,3 +425,46 @@ void dma_buf_kunmap(struct dma_buf *dmabuf, unsigned long page_num,
>                dmabuf->ops->kunmap(dmabuf, page_num, vaddr);
>  }
>  EXPORT_SYMBOL_GPL(dma_buf_kunmap);
> +
> +
> +/**
> + * dma_buf_mmap - Setup up a userspace mmap with the given vma
> + * @dma_buf:   [in]    buffer that should back the vma
> + * @vma:       [in]    vma for the mmap
> + * @pgoff:     [in]    offset in pages where this mmap should start within the
> + *                     dma-buf buffer.
> + *
> + * This function adjusts the passed in vma so that it points at the file of the
> + * dma_buf operation. It alsog adjusts the starting pgoff and does bounds
> + * checking on the size of the vma. Then it calls the exporters mmap function to
> + * set up the mapping.
> + *
> + * Can return negative error values, returns 0 on success.
> + */
> +int dma_buf_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma,
> +                unsigned long pgoff)
> +{
> +       if (WARN_ON(!dmabuf || !vma))
> +               return -EINVAL;
> +
> +       /* check for offset overflow */
> +       if (pgoff + ((vma->vm_end - vma->vm_start) >> PAGE_SHIFT) < pgoff)

ditto. isn't it checked whether page offset to be mmaped is placed
within vm region or not with the condition, if ((vma->vm_end -
vma->vm_start) >> PAGE_SHIFT) < pgoff)?

> +               return -EOVERFLOW;
> +
> +       /* check for overflowing the buffer's size */
> +       if (pgoff + ((vma->vm_end - vma->vm_start) >> PAGE_SHIFT) >
> +           dmabuf->size >> PAGE_SHIFT)
> +               return -EINVAL;
> +
> +       /* readjust the vma */
> +       if (vma->vm_file)
> +               fput(vma->vm_file);
> +
> +       vma->vm_file = dmabuf->file;
> +       get_file(vma->vm_file);
> +
> +       vma->vm_pgoff = pgoff;
> +
> +       return dmabuf->ops->mmap(dmabuf, vma);
> +}
> +EXPORT_SYMBOL_GPL(dma_buf_mmap);
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index 3efbfc2..1f78d15 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -61,6 +61,10 @@ struct dma_buf_attachment;
>  *                This Callback must not sleep.
>  * @kmap: maps a page from the buffer into kernel address space.
>  * @kunmap: [optional] unmaps a page from the buffer.
> + * @mmap: used to expose the backing storage to userspace. Note that the
> + *       mapping needs to be coherent - if the exporter doesn't directly
> + *       support this, it needs to fake coherency by shooting down any ptes
> + *       when transitioning away from the cpu domain.
>  */
>  struct dma_buf_ops {
>        int (*attach)(struct dma_buf *, struct device *,
> @@ -92,6 +96,8 @@ struct dma_buf_ops {
>        void (*kunmap_atomic)(struct dma_buf *, unsigned long, void *);
>        void *(*kmap)(struct dma_buf *, unsigned long);
>        void (*kunmap)(struct dma_buf *, unsigned long, void *);
> +
> +       int (*mmap)(struct dma_buf *, struct vm_area_struct *vma);
>  };
>
>  /**
> @@ -167,6 +173,9 @@ void *dma_buf_kmap_atomic(struct dma_buf *, unsigned long);
>  void dma_buf_kunmap_atomic(struct dma_buf *, unsigned long, void *);
>  void *dma_buf_kmap(struct dma_buf *, unsigned long);
>  void dma_buf_kunmap(struct dma_buf *, unsigned long, void *);
> +
> +int dma_buf_mmap(struct dma_buf *, struct vm_area_struct *,
> +                unsigned long);
>  #else
>
>  static inline struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
> @@ -248,6 +257,13 @@ static inline void dma_buf_kunmap(struct dma_buf *dmabuf,
>                                  unsigned long pnum, void *vaddr)
>  {
>  }
> +
> +static inline int dma_buf_mmap(struct dma_buf *dmabuf,
> +                              struct vm_area_struct *vma,
> +                              unsigned long pgoff)
> +{
> +       return -ENODEV;
> +}
>  #endif /* CONFIG_DMA_SHARED_BUFFER */
>
>  #endif /* __DMA_BUF_H__ */
> --
> 1.7.10
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
